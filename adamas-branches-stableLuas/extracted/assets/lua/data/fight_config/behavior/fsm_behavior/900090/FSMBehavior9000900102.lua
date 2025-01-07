FSMBehavior9000900102 = BaseClass("FSMBehavior9000900102",FSMBehaviorBase)
--NPC通用AI-子状态机-默认状态：巡逻
--巡逻的本质：走到下一目标点
--巡逻中玩家贴近，npc会后退

--初始化
function FSMBehavior9000900102:Init()
	self.me = self.instanceId
	self.nextPoint = nil
	self.curPoint = nil
	self.inPathFinding = false
end


--初始化结束
function FSMBehavior9000900102:LateInit()
	BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Patrol")
end

--帧事件
function FSMBehavior9000900102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.nextPoint = self.ParentBehavior.nextPoint
	self.curPoint = self.ParentBehavior.curPoint
	if BehaviorFunctions.CanCtrl(self.me) then
 		local roleDisatnce = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
		if roleDisatnce < 2 then
			--self:WalkBack()
		end
		if self.curPoint then
			local myPos = BehaviorFunctions.GetPositionP(self.me)
			local heightD = math.abs(self.curPoint.y - myPos.y)
			--存在障碍开启寻路
			if BehaviorFunctions.CheckObstaclesBetweenPos(myPos,self.curPoint) or heightD > 1 then
				if not self.inPathFinding then
					self:PathFindingBegin(self.curPoint)
				end
			else
				if not self.inPathFinding then
					BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.curPoint.x,self.curPoint.y,self.curPoint.z,true)
				end
			end
			if  BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
				--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			end
		end
	end
end

--后走
function FSMBehavior9000900102:WalkBack()
	BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
	if BehaviorFunctions.GetEntityState(self.me)~= FightEnum.EntityState.Move then
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
		if BehaviorFunctions.GetSubMoveState(self.me)~= FightEnum.EntityMoveSubState.WalkBack then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
		end
	end
end

--退出当前状态
function FSMBehavior9000900102:OnLeaveState()
	BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
	BehaviorFunctions.StopMove(self.me)
	BehaviorFunctions.ClearPathFinding(self.me)
end

--寻路开始
function FSMBehavior9000900102:PathFindingBegin(pos)
	local result = BehaviorFunctions.SetPathFollowPos(self.me,pos)
	self.inPathFinding = true
	if result == true then
		return true
	else
		return false
	end
end

--寻路结束
function FSMBehavior9000900102:PathFindingEnd(instanceId,result)
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
