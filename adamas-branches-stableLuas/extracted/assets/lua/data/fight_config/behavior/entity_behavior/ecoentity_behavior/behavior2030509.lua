Behavior2030509 = BaseClass("Behavior2030509",EntityBehaviorBase)
--资源预加载
function Behavior2030509.GetGenerates()
	local generates = {20305091,2030509002,2030509003,2030509004,2030509005,2030509006}
	return generates
end
--mgaic预加载
function Behavior2030509.GetMagics()
	local generates = {203050902}
	return generates
end

function Behavior2030509:Init()
	self.me = self.instanceId
	
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = nil
	self.backHited = nil

	self.MonsterCommonParam.canBeAss = false				--可以被暗杀

	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil                                                   --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 1           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 3           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12           --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 60          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 3            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 203050902            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 203050902            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 203050902            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0.5				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 0				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {

		----敲击
		--{id = 203050901,
			--minDistance = 0.5,         --技能释放最小距离（有等号）
			--maxDistance = 30,        --技能释放最大距离（无等号）
			--angle = 30,              --技能释放角度
			--cd = 0.1,                  --技能cd，单位：秒
			--durationFrame = 1,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},
		
		--敲击
		{id = 203050903,
			minDistance = 0.5,         --技能释放最小距离（有等号）
			maxDistance = 50,        --技能释放最大距离（无等号）
			angle = 360,              --技能释放角度
			cd = 0,                  --技能cd，单位：秒
			durationFrame = 60,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},




	}

	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 0                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 0                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 0                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = false               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 10        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 10         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 10               --移动发呆时间
	self.MonsterCommonParam.canRun = false                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 203050902		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 30           --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 5       --脱战时间
	self.MonsterCommonParam.canNotChase = 30             --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = 50

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0
	--属性参数
	self.ElementList={}
	
	
	------------------------------------------------------------------------------------------炮塔特殊逻辑
	self.ifDie = false
	self.On = true
	self.angle = 0
	self.angleIn = false
	self.meFrontPos = 0

	self.red = false
	self.red1 = false
	self.red2 = false
	
	self.attackFrameNow = 0       --炮塔攻击时的当前时间
	self.attackFrameNext = 0      --炮塔下次攻击的时间
	self.attackFrameCdEnemy = 60       --炮塔攻击的cd
	self.attackFrameCdfriend = 60       --炮塔作为友方攻击的cd
	self.attackCountMax = 5 --炮塔每波攻击会使用的技能次数
	self.attackCount = 0 --炮塔攻击次数计算
	self.attackKey = false --炮塔开始攻击的开关
	
	self.attackStart = false --炮塔开始使用技能攻击，开始旋转的开关
	
	self.searchPosL = nil --左边的角度点位
	self.searchPosR = nil --右边的角度点位
	
	--self.mePosL = { x=0,y=0,z=0}
	--self.mePosR = { x=0,y=0,z=0}
	
	self.searchFrame = 0
	self.searchFrameCd = 150
	self.searchFrameNext = 0
	
	self.searchDirection = 0
	self.searchKey = false
	
	self.searchFrameKey = false
	
	--------------------------------------------------------------------------------------------炮塔友方逻辑
	self.friend = false --是否是友方
	self.targetList = {} --目标列表
	self.target = nil
	self.searchDis = 10 --搜索敌人距离
	
	self.attackAngle = 10  --攻击角度
	
	
	
	---------------------------------------------------------------------------------------------炮塔操控逻辑
	self.control = false --操控炮塔
	

end

function Behavior2030509:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
	self.mePos = BehaviorFunctions.GetPositionP(self.me)
	self.searchPosL = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3,60)
	self.searchPosR = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3,-60)
	
	self.mePosL = BehaviorFunctions.GetPositionOffsetP(self.mePos,self.searchPosL,3,60)
	self.mePosR = BehaviorFunctions.GetPositionOffsetP(self.mePos,self.searchPosR,3,-60)

	--self.mePosL.x = self.mePos.x + self.searchPosL.x
	--self.mePosL.y = self.mePos.y + self.searchPosL.y
	--self.mePosL.z = self.mePos.z + self.searchPosL.z

	--self.mePosR.x = self.mePos.x + self.searchPosR.x
	--self.mePosR.y = self.mePos.y + self.searchPosR.y
	--self.mePosR.z = self.mePos.z + self.searchPosR.z
	
end
	
function Behavior2030509:Update()
	
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()
	self.attackFrameNow = BehaviorFunctions.GetFightFrame()
	self.ctrlRolePos = BehaviorFunctions.GetPositionP(self.ctrlRole)
	self.redPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,self.MonsterCommonParam.warnLongRange,0)
	

	
	--获得操控角色和自己的距离，根据距离来开关
	self.dis = BehaviorFunctions.GetDistanceFromPos(self.ctrlRolePos,self.mePos)
	--获得自己的前方位置
	if self.meFrontPos == 0 then
		self.meFrontPos = BehaviorFunctions.GetEntityPositionOffset(self.me, 0, 0, 10)
	end

	
	
	if self.On == true and self.friend == false then
		if self.dis < self.MonsterCommonParam.ExitFightRange  then
				self.MonsterCommonParam:Update()
				self.MonsterCommonBehavior.MonsterBorn:Update()
				self.MonsterCommonBehavior.MonsterPeace:Update()
				self.MonsterCommonBehavior.MonsterWarn:Update()
				self.MonsterCommonBehavior.MonsterExitFight:Update()
				--self.MonsterCommonBehavior.MonsterWander:Update()
				--self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
				BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me, "beAssassin",self.beAssassin)
				BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)

				--if self.attackKey == true then        --炮塔的攻击按照波次进行，每波攻击几次，停顿片刻，再继续下一波次攻击
				if self.MonsterCommonParam.inFight == true and self.ifDie == false then
					self.MonsterCommonBehavior.MonsterCastSkill:Update()
				end
				--end
		end
	end
	
	
	
	
	-----------------------------------------------------------------------------------------炮台特殊逻辑----
	if self.friend == false and self.control == false then
		--若进入战斗状态、角色距离自己小于侦测距离，且自己未死亡，则始终朝向角色
		if self.MonsterCommonParam.inFight == true and self.ifDie == false and self.On == true then

			if self.dis < self.MonsterCommonParam.ExitFightRange  then
				if BehaviorFunctions.CanCastSkill(self.me) then
					BehaviorFunctions.CancelLookAt(self.me)
				else
					if BehaviorFunctions.GetSkillSign(self.me,2030509031) then
						self.attackStart = true
					end
					
					if BehaviorFunctions.GetSkillSign(self.me,2030509032) then
						BehaviorFunctions.CancelLookAt(self.me)
						self.attackStart = false
					end
					
					--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.MonsterCommonParam.battleTarget,90,90,100,90,3,false)
				end
				BehaviorFunctions.ShowWarnAlertnessUI(self.me, true)
			else
				BehaviorFunctions.CancelLookAt(self.me)
				BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.meFrontPos.x,self.meFrontPos.y,self.meFrontPos.z,20,20,20,10,false)
				BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
			end
		else

			--如果是超出距离，则会回归最初的角度
			if self.MonsterCommonParam.inFight == false and self.ifDie == false and self.On == true then
				
				
				if self.MonsterCommonParam.warnState == 0 then
					
					BehaviorFunctions.CancelLookAt(self.me)
					BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.meFrontPos.x,self.meFrontPos.y,self.meFrontPos.z,20,20,20,10,false)
					BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
					
					--if self.searchFrameKey == false then
						--self.searchFrameNext = self.searchFrame + self.searchFrameCd
						--self.searchFrameKey = true
					--end
					--self.searchFrame = BehaviorFunctions.GetFightFrame()
					
					--if self.searchFrame > self.searchFrameNext then
						--self.searchKey = true
						--if self.searchDirection == 0 then
							--self.searchDirection = 1
						--elseif self.searchDirection == 1 then
							--self.searchDirection = 0
						--end
					--end

					--if self.searchKey == true then
						--self.searchKey = false
						--self.searchFrameKey = false
						--if self.searchDirection == 0 then
							--BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.mePosL.x,self.mePosL.y,self.mePosL.z,20,20,10,20,4,false)
						--elseif self.searchDirection == 1 then
							--BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.mePosR.x,self.mePosR.y,self.mePosR.z,20,20,10,20,4,false)
						--end
					--end
					--BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
					--self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
				
				elseif self.MonsterCommonParam.warnState == 1 then
					--if self.dis < self.MonsterCommonParam.ExitFightRange then
						--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.MonsterCommonParam.battleTarget,10,10,10,10,3,false)
					--else
						
					--end
					
				end
					
			end
		end
	end
	
	
	------------------------------------------------------------------------------------------炮塔使用技能开始旋转逻辑------------
	if self.attackStart == true and self.friend == false then
		BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.MonsterCommonParam.battleTarget,180,180,180,90,1,false)
	elseif self.attackStart == true and self.friend == true then
		if self.target then
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.target,180,180,180,90,1,false)
		end
	end
	
	
	----判断当前帧率，判断是否要释放攻击
	--if self.On == true then
		--if self.attackFrameNow > self.attackFrameNext then --如果到了下次攻击的区间
			--if self.attackKey == false then
				--self.attackKey = true --开启攻击开关
			--end
		--end
	--end
	
	
	
	
	
	----检测区域预览
	--if self.red == false then
		--self.red = true
		--self.redMid = BehaviorFunctions.CreateEntity(20305091,self.me,self.mePos.x,self.mePos.y,self.mePos.z)
	--end
	
	--if self.redMid then
		--BehaviorFunctions.DoLookAtPositionImmediately(self.redMid,self.redPos.x,self.redPos.y,self.redPos.z,false)
	--end
	
	--if self.red1 == false then
		--self.red1 = true
		--self.redLeft = BehaviorFunctions.CreateEntity(20305091,self.me,self.mePos.x,self.mePos.y,self.mePos.z,self.redPos1.x,self.redPos1.y,self.redPos1.z)
	--end

	--if self.redLeft then
		--BehaviorFunctions.DoLookAtPositionImmediately(self.redLeft,self.redPos1.x,self.redPos1.y,self.redPos1.z,false)
	--end
	
	--------------------------------------------------------------------------------------------------------当判定成友方时----------
	if self.friend == true then
		
		if self.scan then
			BehaviorFunctions.RemoveEntity(self.scan)
			self.scan = nil
		end
		if self.halo then
			BehaviorFunctions.RemoveEntity(self.halo)
			self.halo = nil
		end
		if self.mark then
			BehaviorFunctions.RemoveEntity(self.mark)
			self.mark = nil
		end
		if self.enemylight then
			BehaviorFunctions.RemoveEntity(self.enemylight)
			self.enemylight = nil
		end
		

		
		if self.On == true then
			if not self.friendlight then
				self.friendlight = BehaviorFunctions.CreateEntity(2030509006,self.me)
			end
		else
			if self.friendlight then
				BehaviorFunctions.RemoveEntity(self.friendlight)
				self.friendlight = nil
			end
		end

		
	else
		if self.On == true then
			if not self.halo then
				self.halo = BehaviorFunctions.CreateEntity(2030509003,self.me)
			end
			
			if not self.enemylight then
				self.enemylight = BehaviorFunctions.CreateEntity(2030509005,self.me)
			end
			
			
			if self.MonsterCommonParam.inFight then
				if self.scan then
					BehaviorFunctions.RemoveEntity(self.scan)
					self.scan = nil
				end

				if self.mark then
					BehaviorFunctions.RemoveEntity(self.mark)
					self.mark = nil
				end
			else
				
				if not self.scan then
					self.scan = BehaviorFunctions.CreateEntity(2030509002,self.me)
				end

				if not self.mark then
					self.mark = BehaviorFunctions.CreateEntity(2030509004,self.me)
				end

				
			end
		else
			if self.scan then
				BehaviorFunctions.RemoveEntity(self.scan)
				self.scan = nil
			end
			if self.halo then
				BehaviorFunctions.RemoveEntity(self.halo)
				self.halo = nil
			end
			if self.mark then
				BehaviorFunctions.RemoveEntity(self.mark)
				self.mark = nil
			end
			if self.enemylight then
				BehaviorFunctions.RemoveEntity(self.enemylight)
				self.enemylight = nil
			end
		end
		
		

		
		

		
	end
	
	
	if self.friend == true and self.On == true and self.control == false  then
		
		--更改阵营，并且把头顶的警戒标志去掉
		if BehaviorFunctions.GetCampType(self.me) == FightEnum.EntityCamp.Camp2 then
			BehaviorFunctions.ChangeCamp(self.me,FightEnum.EntityCamp.Camp1)
			BehaviorFunctions.ShowQuestionAlertnessUI(self.me,false)
			BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
		end
		
		--检测当前是否有目标
		if self.target and BehaviorFunctions.CheckEntity(self.target) then
			--检测目标是否死亡
			if  BehaviorFunctions.GetEntityState(self.target) ~= FightEnum.EntityState.Die then
				self.targetAngle = BehaviorFunctions.GetEntityAngle(self.me,self.target)
				
				----攻击开关如果开启，则会自动攻击
				--if self.attackKey == true then

				if BehaviorFunctions.CanCastSkill(self.me) then
					BehaviorFunctions.CastSkillByTarget(self.me,203050904,self.target) --释放炮击技能
					BehaviorFunctions.CancelLookAt(self.me)
				else
					if BehaviorFunctions.GetSkillSign(self.me,2030509031) then
						self.attackStart = true
					end

					if BehaviorFunctions.GetSkillSign(self.me,2030509032) then
						BehaviorFunctions.CancelLookAt(self.me)
						self.attackStart = false
					end
				end
				--BehaviorFunctions.SetEntityTrackTarget(self.me,self.target) --设置追踪目标
				--if BehaviorFunctions.CanCastSkill(self.me)  then
					----if self.targetAngle < self.attackAngle or self.targetAngle > (360-self.attackAngle) then
						--
						----self.attackCount = self.attackCount +1
						----炮台和目标之间没碰撞，且距离小于最大攻击距离
					----else
						----BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.target,180,120,120,3,false)
					----end
				--end
				----攻击开关没有开启，则只会转动
				--else
				--if self.targetAngle < self.attackAngle or self.targetAngle > (360-self.attackAngle) then
				--else
				--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.target,180,120,120,3,false)
				--end
				--end
				
				--攻击目标死亡的情况
			elseif self.target then
				self.target = nil
				self.attackStart = false
				BehaviorFunctions.CancelLookAt(self.me)
				table.remove(self.targetList,1)
			end
			
		else
			if next(self.targetList) == nil then
				self.targetList = BehaviorFunctions.SearchNpcList(self.me, self.searchDis,FightEnum.EntityCamp.Camp2,{FightEnum.EntityNpcTag.Monster},nil,nil,false) --搜索范围内的目标
				
				if next(self.targetList) then
					for i = 1, #self.targetList do
						if  BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Die then
							self.target = self.targetList[i]
							self.targetList = {}
							break
						end
					end
				end
			end
		end
		
		
		
		----判断周围是否有敌人
		--if next(self.targetList) == nil then
			--self.targetList = BehaviorFunctions.SearchNpcList(self.me, self.searchDis,FightEnum.EntityCamp.Camp2,{FightEnum.EntityNpcTag.Monster},nil,nil,false) --搜索范围内的目标
			
			--if next(self.targetList) then
				--self.target = self.targetList[1]
				
				--if self.target then
					--if  BehaviorFunctions.GetEntityState(self.target) ~= FightEnum.EntityState.Die then
						--self.targetAngle = BehaviorFunctions.GetEntityAngle(self.me,self.target)
						
						------攻击开关如果开启，则会自动攻击
						----if self.attackKey == true then
							
							----BehaviorFunctions.SetEntityTrackTarget(self.me,self.target) --设置追踪目标
							--if BehaviorFunctions.CanCastSkill(self.me)  then
								--if self.targetAngle < self.attackAngle or self.targetAngle > (360-self.attackAngle) then
									--BehaviorFunctions.CastSkillByTarget(self.me,203050903,self.target) --释放炮击技能
									--self.attackCount = self.attackCount +1
									----炮台和目标之间没碰撞，且距离小于最大攻击距离
								--else
									--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.target,180,120,120,3,false)
								--end
							--end
						------攻击开关没有开启，则只会转动
						----else
							----if self.targetAngle < self.attackAngle or self.targetAngle > (360-self.attackAngle) then
							----else
								----BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.target,180,120,120,3,false)
							----end
						----end
					
					----攻击目标死亡的情况	
					--elseif self.target then
						--self.target = nil
						--BehaviorFunctions.CancelLookAt(self.me)
						--table.remove(self.targetList,1)
					--end
				--end
			--end
		--end
		
		--攻击波次判断
		if self.attackCount < self.attackCountMax then
		else
			--关闭攻击开关，重置攻击次数
			self.attackCount = 0
			--self.attackKey = false

			--计算下次攻击波次的时间
			if self.friend == true then
				self.attackFrameNext = self.attackFrameNow + self.attackFrameCdfriend
			else
				self.attackFrameNext = self.attackFrameNow + self.attackFrameCdEnemy
			end

		end
		
		
		if self.On == true and self.control == true then
			--更改阵营，并且把头顶的警戒标志去掉
			if BehaviorFunctions.GetCampType(self.me) == FightEnum.EntityCamp.Camp2 then
				BehaviorFunctions.ChangeCamp(self.me,FightEnum.EntityCamp.Camp1)
				BehaviorFunctions.ShowQuestionAlertnessUI(self.me,false)
				BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
			end
			
		end
		
		
	end
	

end

function Behavior2030509:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

--function Behavior2030509:Die(attackInstanceId,dieInstanceId)
	--if dieInstanceId==self.MonsterCommonParam.me then
		--BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		--BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	--end
	
	--if dieInstanceId == self.target then
		--BehaviorFunctions.CancelLookAt(self.me)
	--end
	
--end


----炮塔死亡之前的处理
function Behavior2030509:BeforeDie(instanceId)
	if instanceId == self.me then
		self.ifDie = true
		BehaviorFunctions.DoMagic(self.me,self.me,900000010)
		BehaviorFunctions.CancelLookAt(self.me)
		local pos = BehaviorFunctions.GetPositionP(self.me)
		self.On = false
		BehaviorFunctions.CreateEntity(2030509001,self.me,pos.x,pos.y,pos.z)
		--BehaviorFunctions.RemoveEntity(self.me)
	end
end




----按下上键，化敌为友
--function Behavior2030509:HackingClickUp(instanceId)
	--if instanceId == self.me then
		----if BehaviorFunctions.GetHackingButtonIsActive(instanceId, FightEnum.KeyEvent.HackUpButton) then
		--self.friend = true
		--self.control = true
		----self.attackCount = 0
		----self.attackKey = false
		--self.attackFrameNext = self.attackFrameNow + self.attackFrameCdfriend
		--BehaviorFunctions.SetHackingButtonActive(self.me, HackingConfig.HackingKey.Up,false)
		--BehaviorFunctions.ShowQuestionAlertnessUI(self.me,false)
		--BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
		----end

	--end
--end


--按下左键，化敌为友
function Behavior2030509:HackingClickLeft(instanceId)
	if instanceId == self.me then
		if self.friend == false then
			self.friend = true
			--self.attackCount = 0
			--self.attackKey = false
			BehaviorFunctions.ShowQuestionAlertnessUI(self.me,false)
			BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
			BehaviorFunctions.CancelLookAt(self.me)
			BehaviorFunctions.SetHackingButtonActive(self.me, HackingConfig.HackingKey.Left,false)
			self.attackStart = false
		end
	end
end


--按下下键，开启关闭
function Behavior2030509:HackingClickDown(instanceId)
	if instanceId == self.me then
		if self.On == true then --如果当前是开启状态，则关闭
			BehaviorFunctions.SetEntityHackActiveState(self.me, true)
			self.On = false
			
			
			BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"MonsterExitFight",true)
			--BehaviorFunctions.DoSetPositionP(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition)
			BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
			BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
			BehaviorFunctions.DoMagic(1,self.MonsterCommonParam.me,900000021)
			self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
			self.MonsterCommonParam.inFight = false
			self.MonsterCommonParam.inPeace = true
			self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
			self.MonsterCommonParam.exitFightState = self.MonsterCommonParam.ExitFightStateEnum.Default
			BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
			
			if self.redMid then
				BehaviorFunctions.RemoveEntity(self.redMid)
				self.redMid = nil
			end
			
			--隐藏头顶警戒ui
			BehaviorFunctions.ShowQuestionAlertnessUI(self.me,false)
			BehaviorFunctions.ShowWarnAlertnessUI(self.me, false)
			
			--关闭自动旋转
			self.attackStart = false
			BehaviorFunctions.CancelLookAt(self.me) --取消旋转
			
		else
			self.On = true
			self.red = false
			BehaviorFunctions.SetEntityHackActiveState(self.me, false)
			BehaviorFunctions.ShowQuestionAlertnessUI(self.me,true)
			BehaviorFunctions.ShowWarnAlertnessUI(self.me, true)
		end
	end
end

----侦测到炮台使用了攻击
--function Behavior2030509:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	--if instanceId == self.me then
		--if skillId == 203050901  then
			----如果攻击次数小于最大攻击次数，则攻击次数+1
			--if self.attackCount < self.attackCountMax then
				--self.attackCount = self.attackCount +1
			----如果攻击次数大于等于最大攻击次数，则停止攻击
			--else
			--end
		--end
	--end
--end

--function Behavior2030509:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	--if instanceId == self.me then
		--if skillId == 203050901  then
			----如果攻击次数小于最大攻击次数，则攻击次数+1
			--if self.attackCount < self.attackCountMax then
			--else
				----关闭攻击开关，重置攻击次数
				--self.attackCount = 0
				--self.attackKey = false
				
				----计算下次攻击波次的时间
				--if self.friend == true then
					--self.attackFrameNext = self.attackFrameNow + self.attackFrameCdfriend
				--else
					--self.attackFrameNext = self.attackFrameNow + self.attackFrameCdEnemy
				--end
				
			--end
		--end
	--end
--end


--function Behavior2030509:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	--if instanceId == self.me then
		--if skillId == 203050901  then
			----如果攻击次数小于最大攻击次数，则攻击次数+1
			--if self.attackCount < self.attackCountMax then
			--else
				----关闭攻击开关，重置攻击次数
				--self.attackCount = 0
				--self.attackKey = false

				----计算下次攻击波次的时间
				--if self.friend == true then
					--self.attackFrameNext = self.attackFrameNow + self.attackFrameCdfriend
				--else
					--self.attackFrameNext = self.attackFrameNow + self.attackFrameCdEnemy
				--end
			--end
		--end
	--end
--end