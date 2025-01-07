FSMBehavior900003010106 = BaseClass("FSMBehavior900003010106",FSMBehaviorBase)
--战斗游荡状态


function FSMBehavior900003010106.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003010106:Init()

end

function FSMBehavior900003010106:Update()
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		--处于近距离，后退
		--如果后面被堵住就待机
		if self.ParentBehavior.canWalkBack == false then
			if self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.Default then
				self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.Default
			elseif 	self.ParentBehavior.moveState == self.ParentBehavior.MoveStateEnum.Default and self.ParentBehavior.inVision == false then
				if BehaviorFunctions.CheckEntityAngleRange(self.MainBehavior.me,self.MainBehavior.battleTarget,0,180) then
					BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
					self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.Wander
				elseif BehaviorFunctions.CheckEntityAngleRange(self.MainBehavior.me,self.MainBehavior.battleTarget,180,360) then
					BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkRight)
					self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
					self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.Wander
				end
			end
		else
			if self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.WalkBack
				and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunForward
				and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunAndHit  then
				self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.WalkBack
				self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.switchDelayTime * 30
			end
		end
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end