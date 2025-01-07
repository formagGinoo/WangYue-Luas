Behavior900010 = BaseClass("Behavior900010",EntityBehaviorBase)

--预加载
function Behavior900090.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900090.GetMagics()
	local generates = {90001001,90001002,900000108}
	return generates
end


function Behavior900090:Init()

	self.canRun = true 					--跑步开关
	self.canLRWalk = true               --左右走开关
	self.walkSwitchTime = 3             --移动方向切换时间
	self.walkDazeTime = 1               --移动发呆时间
	self.shortRange = 4                 --近距离边界值
	self.longRange = 5                  --远距离边界值
	self.minRange = 4                   --极限近身距离
	self.visionAngle = 60               --视野范围
	self.initialSkillCd = 9				--技能初始cd
	self.commonSkillCd = 5				--技能公共cd
	self.initialDazeTime = 4.4		    --初始发呆时间

	--技能表(id,最大释放距离,最小释放距离,释放角度,技能CD秒数,技能持续帧数,技能用帧数,技能优先级,是否自动释放,技能释放最低生命万分比，最高万分比)
	self.initialSkillList = {
		{id = 900010001,maxdistance = 3,mindistance = 0.1,angle = 30,cd = 8,durationFrame = 70,frame = 0,priority = 1,isAuto = true,minLifeRatio = 0,maxLifeRatio = 10000},
		--技能2 近距离普攻
		{id = 900010002,maxdistance = 3,mindistance = 0.1,angle = 30,cd = 8,durationFrame = 90,frame = 0,priority = 1,isAuto = true,minLifeRatio = 0,maxLifeRatio = 10000},
		--技能3 近距离普攻
		{id = 900010003,maxdistance = 3,mindistance = 0.1,angle = 30,cd = 8,durationFrame = 90,frame = 0,priority = 1,isAuto = true,minLifeRatio = 0,maxLifeRatio = 10000},
		--技能4 近距离普攻
		{id = 900010004,maxdistance = 3,mindistance = 0.1,angle = 30,cd = 8,durationFrame = 90,frame = 0,priority = 1,isAuto = true,minLifeRatio = 0,maxLifeRatio = 10000},
	}

	--自身参数
	self.me = self.instanceId							                    --自身
	self.battleTarget = 0								                    --战斗目标
	self.fightFrame = BehaviorFunctions.GetFightFrame()                   	--世界帧数
	self.myFrame = 0								                      	--自身帧数
	self.battleTargetDistance = 0		                                    --战斗目标与自身的距离
	self.myState = 0					                                    --自身状态
	self.initialState = 0                                                   --初始化进度
	self.bronSkillState = 0                                                 --出生技能进度
	self.currentSkillId = 0				                                    --记录当前释放中技能，否则为0
	self.currentSkillList= {}                                               --当前技能列表
	self.dazeFrame = self.fightFrame + self.initialDazeTime * 30	        --(初始)发呆帧数
	self.commonSkillCdFrame = self.fightFrame + self.initialSkillCd * 30	--(初始)技能公共冷却帧数
	self.walkSwitchFrame = 0	                                            --移动方向切换帧数
	self.skillState = 0					                                    --技能信号，0没有预备技能，1进行攻击条件适配
	self.skillIsAuto = false                                                --是否自动放技能
	self.inVision = false			                                        --是否在视野内
	self.battleRange = 0                                                    --0默认，1近距离，2中距离，3远距离
	self.moveState = 0					                                    --选择信号，0默认,1游荡，2前走，3前跑，4后退
	self.inSkillAngle = 0                                                   --是否符合技能释放角度
	self.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	self.groupSkillNum = 0
	self.canTurn = 0 														--是否可以转身
	self.visionLost = 0 												    --是否丢失视野（一开始本就不在视野范围内不算丢失视野）
	self.isSkill = 0 												        --正在释放技能
	self.randomFrame = 0
	self.skillId = 900010001

	self.tutoTime	= 0
	
	self.skillFrame = 0
	
end


function Behavior900090:Update()

	--获取一系列参数
	self.battleTarget = BehaviorFunctions.GetCtrlEntity() --获取玩家角色
	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)--与玩家角色的距离
	self.fightFrame = BehaviorFunctions.GetFightFrame()
	--角度60以内进入视线角
	self.insight = BehaviorFunctions.CompEntityLessAngle(self.me,self.battleTarget,60)
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	
	self.panduan = self.fightFrame/30 - self.skillFrame/30
	
	--出生（暂无特殊出生逻辑）
	if self.initialState == 0 then
		self.initialState = 1
		--self.currentSkillList = self:InitSkillList()
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
		BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.LeisurelyIdle)
	end
	
	--是否在视听范围内
	if 	self.battleTargetDistance <= 15 or self.insight == true then
			self.inVision = 1
			BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.FightIdle)
			self.canTurn = 1
			--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
	else
			self.inVision = 0
			self.canTurn = 0
			--BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.LeisurelyIdle)
	end
	
	--是否盯着玩家
	if  self.canTurn == 1 and self.myState ~= FightEnum.EntityState.Die then
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,true,0,180,-2)
	else
			BehaviorFunctions.CancelLookAt(self.me)
	end
	
		
	--放技能	
	if self.inVision == 1 and self.isSkill == 0 and self.battleTargetDistance <= 3 and self.myState ~= FightEnum.EntityState.Die then
		if self.panduan >= 8 then
			BehaviorFunctions.CastSkillByTarget(self.me,900010002,self.battleTarget)
			self.canTurn = 0
			self.skillFrame = BehaviorFunctions.GetFightFrame()--技能cd用
		end
	end
	
	
	-- 追击玩家
	if self.inVision == 1 and self.isSkill == 0 and self.myState ~= FightEnum.EntityState.Die then
			if self.battleTargetDistance >=4 then --当距离大于时跑步
				if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
					BehaviorFunctions.SetPathFollowEntity(self.me,self.battleTarget)
					BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
				
				elseif BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then 
					if BehaviorFunctions.GetSubMoveState(self.me) == FightEnum.EntityMoveSubState.Walk then
						BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)	
						BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
					end
				end
		
			elseif self.battleTargetDistance <= 4 and self.battleTargetDistance > 1.5 then--当距离小于时走路
				if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
					if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
						--BehaviorFunctions.SetPathFollowEntity(self.me,self.battleTarget)
						--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
						BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)	
						BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
					end
				end
				--近距离还在跑强制普攻
			elseif BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move and self.battleTargetDistance < 1.5 then
					BehaviorFunctions.CastSkillByTarget(self.me,900010001,self.battleTarget)
					self.moveState = 0
			
				
			
		
			
			
			end				
	end

	
	
	
end
		
			


--开始放技能
function Behavior900090:CastSkill(instanceId,skillId,skillType)
	if skillId == 900010001 or skillId == 900010002 then
		self.isSkill = 1
	end
end
--结束放技能
function Behavior900090:FinishSkill(instanceId,skillId,skillType)
	if skillId == 900010001 or skillId == 900010002 then
		self.isSkill = 0
	end
end
function Behavior900090:BreakSkill(instanceId,skillId,skillType)
	if skillId == 900010001 or skillId == 900010002 then
		self.isSkill = 0
	end
end




function Behavior900090:BeDodge(attackInstanceId,hitInstanceId,limit)

	BehaviorFunctions.SetEntityValue(self.me,"DodgeDet",true)

end

function Behavior900090:Death(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.DoMagic(self.me,self.me,900000008)
	end
end


	
	
	
	
	
	
