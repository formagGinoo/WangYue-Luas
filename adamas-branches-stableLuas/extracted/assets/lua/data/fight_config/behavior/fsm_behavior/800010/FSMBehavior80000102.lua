FSMBehavior80000102 = BaseClass("FSMBehavior80000102",FSMBehaviorBase)
--NPC通用AI-子状态机-默认状态：巡逻
--巡逻的本质：走到下一目标点
--巡逻中玩家贴近，npc会后退

--初始化
function FSMBehavior80000102:Init()
	self.me = self.instanceId
	self.nextPoint = nil
	self.curPoint = nil
	self.inPathFinding = false
end


--初始化结束
function FSMBehavior80000102:LateInit()
	BehaviorFunctions.SetEntityValue(self.me,"InPathFinding",true)
end

--帧事件
function FSMBehavior80000102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.nextPoint = self.ParentBehavior.nextPoint
	self.curPoint = self.ParentBehavior.curPoint
	if BehaviorFunctions.CanCtrl(self.me) then
		if self.curPoint and not self.inWalkBack then
			if not self.inPathFinding then
				self:PathFindingBegin(self.curPoint)
			end
		end
		if self.inPathFinding then
			if  BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
			end
			if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			end
		end
	else
		self.inPathFinding = nil
	end
end

--后走
function FSMBehavior80000102:WalkBack()
	BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
	if BehaviorFunctions.GetEntityState(self.me)~= FightEnum.EntityState.Move then
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
		if BehaviorFunctions.GetSubMoveState(self.me)~= FightEnum.EntityMoveSubState.WalkBack then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
		end
	end
end

--退出当前状态
function FSMBehavior80000102:OnLeaveState()
	BehaviorFunctions.StopMove(self.me)
	BehaviorFunctions.ClearPathFinding(self.me)
	BehaviorFunctions.SetEntityValue(self.me,"InPathFinding",false)
end

--寻路开始
function FSMBehavior80000102:PathFindingBegin(pos)
	local result = BehaviorFunctions.SetPathFollowPos(self.me,pos)
	if result == true then
		self.inPathFinding = true
		--LogError(pos.x,pos.y,pos.z)
		return true
	else
		-- LogError("无法抵达该地点，已停止跟随".."坐标"..pos.x.." "..pos.y.." "..pos.z)
		return false
	end
end

--寻路结束
function FSMBehavior80000102:PathFindingEnd(instanceId,result)
	if instanceId == self.me and result == true	then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(self.me)
		self.inPathFinding = false
		self.pathFindingArrive = true
	elseif instanceId == self.me and result == false then
		--寻路异常
		BehaviorFunctions.ClearPathFinding(self.me)
		self.inPathFinding = false
		--LogError("无法抵达该地点，已停止跟随")
	end
end
