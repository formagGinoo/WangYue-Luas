FSMBehavior900003010102 = BaseClass("FSMBehavior900003010102",FSMBehaviorBase)
--战斗游荡障碍寻路状态


function FSMBehavior900003010102.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003010102:Init()

end

function FSMBehavior900003010102:Update()
	if self.MainBehavior.pathFindKey == true
		and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		BehaviorFunctions.CancelLookAt(self.MainBehavior.me)
		BehaviorFunctions.SetPathFollowEntity(self.MainBehavior.me,self.MainBehavior.battleTarget)
		if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.Run then
			BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Run)
		end
		self.MainBehavior.pathFindKey = false
	end
	BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
end

function FSMBehavior900003010102:PathFindingEnd(instanceId,result)
	if instanceId == self.MainBehavior.me then
		if result == true then
			self:StopPathFind()
		else
			--因为异常结束
			self.MainBehavior.pathFindKey = true
			local state = BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget)
			if BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) ~= FightEnum.EntityState.Fall
				and BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) ~= FightEnum.EntityState.Jump then
				self:StopPathFind()
			end
			--当角色在跳的时候，寻路到角色脚下的点
			if BehaviorFunctions.SetPathFollowEntity(self.MainBehavior.me,self.MainBehavior.battleTarget)==false
				and (BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) == FightEnum.EntityState.Fall
					or BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) == FightEnum.EntityState.Jump) then
				local pos =BehaviorFunctions.GetPositionP(self.MainBehavior.battleTarget)
				local h,layer=BehaviorFunctions.CheckPosHeight(pos)
				local pos2 = {["x"]=pos.x,["y"]=pos.y-h,["z"]=pos.z}
				BehaviorFunctions.SetPathFollowPos(self.MainBehavior.battleTarget,pos2)
			end
		end
	end
end

function FSMBehavior900003010102:StopPathFind()
	BehaviorFunctions.DoSetEntityState(self.MainBehavior.me,FightEnum.EntityState.Idle)
	BehaviorFunctions.ClearPathFinding(self.MainBehavior.me)
	self.MainBehavior.pathFindKey = true
end