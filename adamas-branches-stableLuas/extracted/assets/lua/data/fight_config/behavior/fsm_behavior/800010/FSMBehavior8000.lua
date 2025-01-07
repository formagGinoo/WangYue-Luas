FSMBehavior8000 = BaseClass("FSMBehavior8000",FSMBehaviorBase)
local PatrolType = FightEnum.NPCPatrolType
local PatrolState = {GoTo = 1, Return = 2 }
--NPC通用AI：状态机总控

--初始化
function FSMBehavior8000:Init()
	self.me = self.instanceId
	self.npcId = nil
	self.isFunc = false
	self.myTerritory = {}
	
	--瞄准判定
	self.aimCheck = false
	self.aimFrame = 0
	self.aimLockTime = 0.3
	self.aimLock = false
	self.aimCheckDistance = 10
	
	--受击碰撞
	self.onHit = false  --进入受击
	self.onCollide = false --进入碰撞
	self.collideAct = nil
	self.CollideActEnum = {
		Collide = 1,
		Dodge = 2,
		}
	--警告
	self.alertDialogId = 601019101
	self.inAlertTalk = false
	self.onAlert = false
	self.chooseSorry = false
	self.chooseRefuse = false
	self.sorryDialogId = 601019103
	self.refuseDialogId = 601019102
	
	--状态
	self.FSMState = 0
	self.FSMSubState = 0
	self.FSMStateEnum = {
		Default = 1,
		Threatened = 2,
		Collide = 3,
		Alert = 4,
		Escape = 5,
		Fight = 6,
		Talk = 7,
		inTask = 99,	
		}
	self.myFSMState = 0
	self.DefaultSubStateEnum = {
		Act = 1,
		Patrol = 2,
	}
	--巡逻相关
	--self.patrolId = nil
	self.needPatrol = false
	self.RoadDots = nil
	--self.Lights = nil
	self.startPointIndex = nil
	self.curPoint = nil
	self.nextPoint = nil
	self.roadEnd = false
	
	--对话相关
	self.defaultDialogId = nil
	self.inDefaultTalk = false
	
	--打电话相关
	self.canCall = false  --是否有打电话配置
	self.canText = false   --是否有发短信配置
	self.phoneCd = 30
	self.inPhoneCd = false
	self.onCall = false --开始打电话
	self.onText = false --开始发短信
end

--初始化结束
function FSMBehavior8000:LateInit()
	local npcId = BehaviorFunctions.GetNpcId(self.me)
	if npcId then
		self.npcId = npcId
		self.movePathPoints = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"move_path_points")
		self.patrolType = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"patrol_type")
		self.isFunc = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"is_func")
		self.myTerritory = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"territory")
		self.canCall = BehaviorFunctions.CheckNpcCanCall(self.npcId)
		self.canText = BehaviorFunctions.CheckNpcCanMail(self.npcId)
	end
	self:InitRoadDotConfig()
	if self.myTerritory and next(self.myTerritory) then
		local beforeList = self.myTerritory
		local afterList = {}
		for i = 1, #beforeList do
			local stepList = beforeList[i]
			if stepList[1]~="" and stepList[2]~="" and stepList[3]~="" then
				table.insert(afterList,{logicName = stepList[1],area = stepList[2],canTrespass = stepList[3]})
			end
		end
		self.myTerritory = afterList
	end
end

--帧事件
function FSMBehavior8000:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:GetFSMState()
	--if not self.magicState then
		--BehaviorFunctions.DoMagic(1,self.me,900000001) --免疫受击
		--BehaviorFunctions.DoMagic(1,self.me,900000013) --免疫锁定
		--BehaviorFunctions.DoMagic(1,self.me,900000020) --免疫受击朝向
		--BehaviorFunctions.DoMagic(1,self.me,900000022) --强制左倾
		--BehaviorFunctions.DoMagic(1,self.me,900000023) --免疫伤害
		--BehaviorFunctions.DoMagic(1,self.me,900000059) --免疫强制位移
		--self.magicState = true
	--end
	--会根据任务变化，所以需要每帧数判断
	if self.npcId then
		self.isInTask = BehaviorFunctions.CheckNpcIsInTask(self.npcId)
		self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
		self.bubbleId = BehaviorFunctions.GetNpcBubbleId(self.npcId)
	
	end
	--任务占用处理
	if self.isInTask == true and self.FSMState ~= self.FSMStateEnum.inTask then
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	elseif self.isInTask == false and self.FSMState == self.FSMStateEnum.inTask then
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
	--瞄准检测
	if self.aimCheck and self.FSMState ==  self.FSMStateEnum.Default then
		if BehaviorFunctions.GetAimTargetInstanceId(self.role) == self.me 
			and BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) < self.aimCheckDistance 
			and BehaviorFunctions.CompEntityLessAngle(self.me,self.role,45) then
			self.aimFrame = self.aimFrame + 1
		else
			self.aimFrame = 0
		end
		--锁定超过3s
		if self.aimFrame >= 30*self.aimLockTime  then
			self.aimLock = true
			self.aimFrame = 0
			BehaviorFunctions.CustomFSMTryChangeState(self.me)
		end		
	end
	--巡逻相关
	--curPoint:当前需要去的点
	--nextPoint:下一个需要去的点
	if self.curPoint and not self.roadEnd then
		local targetPos = self.curPoint
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		local distance = BehaviorFunctions.GetDistanceFromPos(targetPos,myPos)
		if distance > 0.2  then
			if self.FSMState == self.FSMStateEnum.Default and self.FSMSubState ~= self.DefaultSubStateEnum.Patrol then
				self.needPatrol = true
			end
		end
	end
	--打电话发短信
	--根据npc配置，随机打电话或发短信
	if not self.inPhoneCd then
		if self.canCall and self.canText then
			local random = BehaviorFunctions.RandomSelect(1,2)
			if not self.phoneDelayCall then
				if random == 1 then
					self.onCall = true
					self.inPhoneCd = true
					self.phoneDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"inPhoneCd",false)
					self.removeDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"phoneDelayCall",nil)
				else
					self.onText =true
					self.inPhoneCd = true
					self.phoneDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"inPhoneCd",false)
					self.removeDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"phoneDelayCall",nil)
				end
			end
		elseif self.canCall then
			self.onCall = true
			self.inPhoneCd = true
			self.phoneDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"inPhoneCd",false)
			self.removeDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"phoneDelayCall",nil)
		elseif self.canText then
			self.onText = true
			self.inPhoneCd = true
			self.phoneDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"inPhoneCd",false)
			self.removeDelayCall = BehaviorFunctions.AddDelayCallByTime(self.phoneCd,self,self.Assignment,"phoneDelayCall",nil)
		end
	end
end

--受击
function FSMBehavior8000:OnAttackNpc(attackInstanceId,hitInstanceId,instanceId,attackType,skillType)
	--在角色附近受击
	local dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	if not dis then
		return
	end

	if hitInstanceId == self.me	
		and dis <= 3  
		and not self.onHit
		and(attackInstanceId == self.role or (BehaviorFunctions.GetEntityOwner(attackInstanceId) and BehaviorFunctions.GetEntityOwner(attackInstanceId) == self.role))
		and self.FSMState == self.FSMStateEnum.Default 
		and not self.onCollide then
		self.onHit = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end

--移动碰撞
function FSMBehavior8000:OnEntityCollision(instanceId,collisionInstanceId)
	--互相碰撞
	if (instanceId == self.me  and collisionInstanceId == self.role) or (instanceId == self.role  and collisionInstanceId == self.me) then
		if self.FSMState == self.FSMStateEnum.Default and not self.onCollide and not self.onHit then
			self.onCollide = true
			BehaviorFunctions.CustomFSMTryChangeState(self.me)
		end
	end
end

--瞄准检测
function FSMBehavior8000:AimSwitchState(instanceId,Type)
	if instanceId == self.role and Type == FightEnum.EntityAimState.Aiming then
		self.aimCheck = true
	elseif  instanceId == self.role and Type ~= FightEnum.EntityAimState.Aiming and self.aimCheck == true then
		self.aimCheck = false
	end
end

--查询状态
function FSMBehavior8000:GetFSMState()
	self.FSMState = BehaviorFunctions.GetCustomFSMState(self.me)
	--Log("FsmState"..self.FSMState)
	self.FSMSubState = BehaviorFunctions.GetCustomFSMSubState(self.me)
end

--点击交互:播放默认对话
function FSMBehavior8000:WorldInteractClick(uniqueId,instanceId)
	if self.defaultDialogId	 then
		if instanceId == self.me and (self.FSMState == self.FSMStateEnum.Default or self.FSMState == self.FSMStateEnum.inTask) then
			BehaviorFunctions.WorldInteractRemove(self.me)
			self.inDefaultTalk = true
			BehaviorFunctions.CustomFSMTryChangeState(self.me)
		end
	end
end

--路径初始化
function FSMBehavior8000:InitRoadDotConfig()
	if not self.movePathPoints or not next(self.movePathPoints) then
		return
	end
	self.curPointIndex = 1
	self.curPoint = Vec3.New(self.movePathPoints[1][1], self.movePathPoints[1][2], self.movePathPoints[1][3])
	self.patrolState = PatrolState.GoTo

	-->>nextPoint 取下一个路径点
	if self.movePathPoints[self.curPointIndex + 1] then
		self.nextPoint = self.movePathPoints[self.curPointIndex + 1]
	else
		self.nextPoint = nil
	end
end

--路径切换
function FSMBehavior8000:RoadDotSwitch()
	self.curPoint:Set(self.nextPoint[1], self.nextPoint[2], self.nextPoint[3])
	-->>nextPoint 取下一个路径点
	local addValue = self.patrolState == PatrolState.GoTo and 1 or -1
	self.curPointIndex = self.curPointIndex + addValue

	self.nextPoint = self.movePathPoints[self.curPointIndex + addValue]
	if not self.nextPoint then
		if self.patrolType == PatrolType.OneWay then
			self.nextPoint = nil
		elseif self.patrolType == PatrolType.Return then
			self.patrolState = self.patrolState == PatrolState.GoTo and PatrolState.Return or PatrolState.GoTo
			addValue = self.patrolState == PatrolState.GoTo and 1 or -1
			self.nextPoint = self.movePathPoints[self.curPointIndex + addValue]
		elseif self.patrolType == PatrolType.Close then
			self.nextPoint = self.movePathPoints[1]
			self.curPointIndex = 0
		end
	end
end

--红绿灯变化回调
function FSMBehavior8000:TrafficLightChange(id, state)

end

function FSMBehavior8000:OnLeaveState()
	if self.phoneDelayCall then
		BehaviorFunctions.RemoveDelayCall(self.phoneDelayCall)
	end
	if self.removeDelayCall then
		BehaviorFunctions.RemoveDelayCall(self.removeDelayCall)
	end
end


--赋值
function FSMBehavior8000:Assignment(variable,value)
	self[variable] = value
end


function FSMBehavior8000:PathFindingEnd(instanceId,result)
	if instanceId == self.me and result == true	then
		if self.nextPoint then
			self:RoadDotSwitch()
		else
			if self.FSMState == self.FSMStateEnum.Default and self.FSMSubState == self.DefaultSubStateEnum.Patrol then
				self.needPatrol = false
				self.roadEnd = true
			end
		end
	end
end