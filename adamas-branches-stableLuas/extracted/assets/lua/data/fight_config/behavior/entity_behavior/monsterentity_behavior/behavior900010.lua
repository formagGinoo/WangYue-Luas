
Behavior900010 = BaseClass("Behavior900010",EntityBehaviorBase)


function Behavior900010:Init()
	
	
	--通用参数
	--可设置参数
	self.difficultyDegree = 0           --难度系数
	self.haveBornSkill = false           --是否有出生技能
	self.haveSpecialBornLogic = false    --出生技能是否有特殊逻辑
	self.bornSkillId = 900010021	    --出生技能id
	self.canRun = true                  --跑步开关
	self.canLRWalk = true               --左右走开关
	self.walkSwitchTime = 3             --移动方向切换时间
	self.walkDazeTime = 1               --移动发呆时间
	self.shortRange = 4                 --近距离边界值
	self.longRange = 5                 --远距离边界值
	self.minRange = 4                   --极限近身距离
	self.visionAngle = 60               --视野范围
	self.initialSkillCd = 9				--技能初始cd
	self.commonSkillCd = 5				--技能公共cd
	self.initialDazeTime = 4.4		    --初始发呆时间
	self.defaultSkillId = 900010001		--普攻技能id，用于特殊情况的保底

	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.initialSkillList = {
		--蜥蜴通用技能
		--技能1 近距离普攻
		{id = 900010001,distance = 1,angle = 30,cd = 40,durationFrame = 90,frame = 0,priority = 25,isAuto = true,difficultyDegree = 0},
		--技能2 近距离普攻
		{id = 900010002,distance = 2,angle = 30,cd = 25,durationFrame = 90,frame = 0,priority = 15,isAuto = true,difficultyDegree = 0},
		--技能3 近距离普攻
		{id = 900010003,distance = 2,angle = 30,cd = 15,durationFrame = 90,frame = 0,priority = 10,isAuto = true,difficultyDegree = 0},
		--技能4 近距离普攻
		{id = 900010004,distance = 2,angle = 30,cd = 5,durationFrame = 90,frame = 0,priority = 5,isAuto = true,difficultyDegree = 0},

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
	self.groupSkillNum = 0                                                  --执行分组释放的技能编号

	--自定义参数
	--特殊演出技能
	--self.actSkillIdList = {900010004,900010005}
	self.randomFrame = 0
	self.skillId = 900010001

	self.tutoTime	= 0
end


function Behavior900010.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900010.GetMagics()
	local generates = {900000008}
	return generates
end

function Behavior900010:Update()

	--每帧参数记录
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)
	self.fightFrame = BehaviorFunctions.GetFightFrame()
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	self.groupSkillSign = BehaviorFunctions.GetEntityValue(self.me,"GroupSkill")

	--教学靶子模式
	self.tutoMode = BehaviorFunctions.GetEntityValue(self.me,"idle")

	if self.tutoMode == nil then
		self.tutoMode = 0
	end

	if self.tutoMode == 1 then

		self.tutoAttack = BehaviorFunctions.GetEntityValue(self.me,"TutoAttack")

		if self.myState ~= FightEnum.EntityState.Die and BehaviorFunctions.CanCastSkill(self.me) == true then
			--BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,true,0,180,-2)
		end

		--判断是否处于范围内，若否，进入移动状态
		if self.battleTargetDistance >= 3 and self.moveState == 0 and self.myState ~= FightEnum.EntityState.Die and self.myState ~= FightEnum.EntityState.Move then
			self.moveState = 1

		elseif self.battleTargetDistance < 3 and self.moveState == 1 and self.myState ~= FightEnum.EntityState.Die and self.myState ~= FightEnum.EntityState.FightIdle then
			self.moveState = 0
		end

		if BehaviorFunctions.CanCastSkill(self.me) == true then

			if self.moveState == 1 and self.myState ~= FightEnum.EntityState.Die and self.myState ~= FightEnum.EntityState.Move then
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)

			elseif self.moveState == 0 and self.myState ~= FightEnum.EntityState.Die and self.myState ~= FightEnum.EntityState.FightIdle then
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
			end

		end


		if self.tutoAttack == 1 and self.moveState == 0 and self.fightFrame - self.tutoTime >= 120 and BehaviorFunctions.CanCastSkill(self.me) == true then
			local skillId = 900010001
			if self.battleTargetDistance <= 3 then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
				BehaviorFunctions.CastSkillByTarget ( self.me,skillId,self.battleTarget )
				BehaviorFunctions.SetEntityValue(self.me,"tutoAttacking",1)
				self.tutoTime = BehaviorFunctions.GetFightFrame()
			end
			if self.moveState == 1 then
				BehaviorFunctions.BreakSkill(self.me)
			end
		end

	elseif self.tutoMode == 0 then

		--通用出生技能
		if self.initialState == 0 and self.haveBornSkill == true then
			BehaviorFunctions.CastSkillByTarget(self.me,self.bornSkillId,self.battleTarget)
			if self.haveSpecialBornLogic then
				if self.bronSkillState == 0  then
					self.bronSkillState = 1
				end
			else
				self.initialState = 1
			end
			--特殊出生逻辑
			if  self.bronSkillState == 1 and self.battleTargetDistance < 5 then
				self.randomFrame = BehaviorFunctions.GetFightFrame() + BehaviorFunctions.RandomSelect(10,20,30)
				self.bronSkillState = 2
			end
			if self.bronSkillState == 2 and self.randomFrame < self.fightFrame then
				BehaviorFunctions.CastSkillByTarget(self.me,self.bornSkillId+1,self.battleTarget)
				self.initialState = 1
			end
		elseif self.initialState == 0 and self.haveBornSkill == false then
			self.initialState = 1
		end


		--初始化
		if self.initialState == 1 and BehaviorFunctions.CanCtrl(self.me) then
			if self.fightFrame > self.dazeFrame then
				self.currentSkillList = self:InitSkillList()
				self.initialState = 2
				BehaviorFunctions.SetEntityValue(self.me,"canGroup",true)
			else
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
			end
		end

		--分组处理
		if self.groupSkillSign == 0 then
			self.skillIsAuto = false
		elseif self.groupSkillSign == 1 then
			self.skillIsAuto = true
			if self.groupSkillFrame < self.fightFrame and self.groupSkillFrame ~= 0 and self.groupSkillNum ~= 0 then
				self.groupSkillFrame = self.fightFrame - self.groupSkillFrame
				self.currentSkillList[self.groupSkillNum].frame = self.currentSkillList[self.groupSkillNum].frame + self.groupSkillFrame
				self.groupSkillNum = 0
			end
		else
			self.skillIsAuto = true
		end

		--完成初始化
		if self.initialState == 2 and self.battleTarget then

			--区域判断
			if self.battleTargetDistance < self.shortRange then
				self.battleRange = 1
			elseif self.battleTargetDistance > self.longRange then
				self.battleRange = 3
			else
				self.battleRange = 2
			end

			if BehaviorFunctions.CanCastSkill(self.me) then
				--走路:无技能可放时开始走路
				if self.skillState == 0 then
					--处于远距离，有跑步，向前跑；无跑步，向前走
					if self.battleRange == 3  then
						BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
						if self.canRun and self.moveState ~= 3 and self.fightFrame > self.walkSwitchFrame then
							BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
							self.moveState = 3
						elseif self.canRun == false and self.moveState ~= 2 and self.fightFrame > self.walkSwitchFrame then
							BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
							self.moveState = 2
						end
					else
						if self.moveState == 2 then
							self.moveState = 0
						end
					end

					--处于近距离，后退
					if self.battleRange == 1 then
						if self.moveState ~=4 and self.moveState ~= 3 and self.fightFrame > self.walkSwitchFrame then
							BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
							BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
							self.moveState = 4
						end
						--近距离还在跑强制普攻
						if self.moveState == 3 and self.battleTarget < self.minRange then
							BehaviorFunctions.CastSkillByTarget(self.me,self.defaultSkillId,self.battleTarget)
							self.moveState = 0
						end
					else
						if self.moveState == 4 then
							self.moveState = 0
						end
					end

					--处于中距离，左右游荡或发呆。特殊情况：左右有障碍则向前走
					if self.battleRange == 2  then
						if self.moveState ~= 1  and self.moveState ~= 3 then
							self.moveState = 1
						end
						if self.moveState == 1 and self.fightFrame > self.walkSwitchFrame then
							--判断角度，若在视野范围内则左右移动或短暂发呆
							if self.canLRWalk == true then
								if self.inVision == true then
									local R = BehaviorFunctions.RandomSelect(1,2,3,4)
									if R == 1 then
										BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
										self.walkSwitchFrame = self.fightFrame + self.walkSwitchTime * 30
									elseif R == 2 then
										BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
										self.walkSwitchFrame = self.fightFrame + self.walkSwitchTime * 30
									elseif R == 3 then
										BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
										self.walkSwitchFrame = self.fightFrame + self.walkDazeTime * 30
									elseif R == 4 then
										BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
										self.walkSwitchFrame = self.fightFrame + self.walkSwitchTime * 30
									end
									--不在视野范围内根据战斗目标位置决定左走或右走
								else
									if BehaviorFunctions.CheckEntityAngleRange(self.me,self.battleTarget,0,180) then
										BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
										self.walkSwitchFrame = self.fightFrame + self.walkSwitchTime * 30
									elseif BehaviorFunctions.CheckEntityAngleRange(self.me,self.battleTarget,180,360) then
										BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
										self.walkSwitchFrame = self.fightFrame + self.walkSwitchTime * 30
									end
								end
								--不能左右走就发呆或者往前走
							else
								local R = BehaviorFunctions.RandomSelect(1,2)
								if R == 1 then
									BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
									self.walkSwitchFrame = self.fightFrame + self.walkSwitchTime * 30

								elseif R == 2 then
									BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
									self.walkSwitchFrame = self.fightFrame + self.walkDazeTime * 30
								end
							end
						end
					end
					--转向逻辑
					if BehaviorFunctions.CompEntityLessAngle(self.me,self.battleTarget,self.visionAngle/2) then
						self.inVision = true
					else
						self.inVision = false
						if self.myState ==  FightEnum.EntityState.Move then
							BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,true,0,180,-2)
						end
					end
				end
				if self.skillIsAuto then
					--非公共Cd状态且没有已选择技能，则进行技能选择
					if self.fightFrame > self.commonSkillCdFrame and self.skillState == 0 then
						--根据所在区域选择技能
						--远距离
						if self.battleRange == 3 then
							for num = 1,#self.currentSkillList,1 do
								if self.currentSkillList[num].frame < self.fightFrame and self.currentSkillList[num].distance > self.longRange then
									self.skillState = 1
									self.currentSkillListNum = num
									break
								end
								if self.skillState == 1 then
									break
								end
							end
							--近距离
						elseif self.battleRange == 1 then
							for num = 1,#self.currentSkillList,1 do
								if self.currentSkillList[num].frame < self.fightFrame and self.currentSkillList[num].distance < self.shortRange then
									self.skillState = 1
									self.currentSkillListNum = num
									break
								end
								if self.skillState == 1 then
									break
								end
							end
						elseif self.battleRange == 2 then
							for num = 1,#self.currentSkillList,1 do
								if self.currentSkillList[num].frame < self.fightFrame and self.currentSkillList[num].distance >= self.shortRange
									and self.currentSkillList[num].distance <= self.longRange then
									self.skillState = 1
									self.currentSkillListNum = num
									break
								end
								if self.skillState == 1 then
									break
								end
							end
						end
					end
					--释放选好的技能
					if self.skillState == 1  then
						--取消移动
						if self.myState == FightEnum.EntityState.Move then
							BehaviorFunctions.StopMove(self.me)
						end
						--角度判断
						if BehaviorFunctions.CompEntityLessAngle(self.me,self.battleTarget,self.currentSkillList[self.currentSkillListNum].angle) then
							self.inSkillAngle = true
							self.skillState = 2
						else
							self.inSkillAngle = false
							BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,true,0,240,-2)
						end
					end
					--角度合适则放技能
					if self.skillState == 2 then
						BehaviorFunctions.CancelLookAt(self.me)
						BehaviorFunctions.CastSkillByTarget(self.me,self.currentSkillList[self.currentSkillListNum].id,self.battleTarget)
						--LogError(self.currentSkillList[self.currentSkillListNum].id)
						self.currentSkillList[self.currentSkillListNum].frame = self.fightFrame +
						self.currentSkillList[self.currentSkillListNum].cd * 30
						self.commonSkillCdFrame = self.fightFrame + self.commonSkillCd * 30 + self.currentSkillList[self.currentSkillListNum].durationFrame
						self.skillState = 0
						self.moveState = 0
						if self.groupSkillSign == 1 then
							BehaviorFunctions.SetEntityValue(self.me,"GroupSkill",0)
						end
						self.groupSkillFrame = self.fightFrame
						self.groupSkillNum = self.currentSkillListNum
					end

					----检测玩家点击交互按钮
					--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) and BehaviorFunctions.CanCastSkill(self.me) then
					--if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
					--BehaviorFunctions.BreakSkill(self.me)
					--end
					--if self.skillId == 900010004 then
					--self.skillId = 900010001
					--else
					--self.skillId = self.skillId + 1
					--end
					--BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
					--BehaviorFunctions.CastSkillByTarget ( self.me,self.skillId,self.battleTarget )
					--end
				end
			end
		end
	end
end


--技能列表初始化
function Behavior900010:InitSkillList()
	local list = {}
	for k = 1, #self.initialSkillList do
		list[k] = self.initialSkillList[k]
	end
	--技能列表排序，优先级：优先priority降序，priority相同则id升序
	table.sort(list,function(a,b)
			if a.priority > b.priority then
				return true
			elseif a.priority == b.priority then
				if a.id < b.id then
					return true
				end
			end
		end)
	--剔除非自动释放的及难度系数大于预设难度的技能
	for i = #list,1,-1 do
		if list[i].isAuto ~= true or list[i].difficultyDegree > self.difficultyDegree then
			table.remove(list,i)
		end
	end
	return list
end

--根据id查找列表中对应id的技能的列表下标
function Behavior900010:SerchSkillList(skillid,table)
	for i = #table,1,-1 do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改技能列表
function Behavior900010:initialSkillListAlter(table)
	for i = #self.initialSkillList,1,-1 do
		for j = #table,1,-1 do
			if self.initialSkillList[i].id == table[j].id then
				self.initialSkillList[i] = table[j]
			end
		end
	end
end

--修改技能列表,一次改一个
function Behavior900010:AlterSkillList(table)
	local list = self.initialSkillList
	for i = #list,1,-1 do
		if list[i].id == table[i].id then
			skill[i] = table[i]
		end
	end
	return list
end


function Behavior900010:ReciveGroupMode()
	--self.groupSkillSign参数：【0】待命状态 【1】接收到组攻击命令 【2】未接收到组命令，自主攻击状态
	if self.groupSkillSign then
		--监听组模式信号
		self.groupSkillSign = BehaviorFunctions.GetEntityValue(self.me,"GroupSkill")
		--若组模式没有发来攻击信号，则进入自主模式
		if self.groupSkillSign == nil then
			self.groupSkillSign = 2
		end
	else
		LogError("[警告]该实体不存在groupSkillSign变量,不可调用该函数")
	end
end

function Behavior900010:GroupModeCheck()
	if self.groupSkillSign then
		--检测本次攻击信号是否是组模式发来的，如果是则返回非攻击模式
		if BehaviorFunctions.GetEntityValue(self.me,"GroupSkill") == 1  then
			BehaviorFunctions.SetEntityValue(self.me,"GroupSkill",0)
			BehaviorFunctions.GetEntityValue(self.me,"GroupSkill")
			--LogError("Instance",self.me,self.groupSkillSign)
		end
	else
		LogError("[警告]该实体不存在groupSkillSign变量,不可调用该函数")
	end
end

function Behavior900010:BeDodge(attackInstanceId,hitInstanceId,limit)

	BehaviorFunctions.SetEntityValue(self.me,"DodgeDet",true)

end

function Behavior900010:Death(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.DoMagic(self.me,self.me,900000008)
	end
end