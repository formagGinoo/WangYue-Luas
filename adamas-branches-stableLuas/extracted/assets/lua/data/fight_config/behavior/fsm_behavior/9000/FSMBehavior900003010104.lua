FSMBehavior900003010104 = BaseClass("FSMBehavior900003010104",FSMBehaviorBase)
--战斗游荡状态


function FSMBehavior900003010104.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003010104:Init()

end

function FSMBehavior900003010104:Update()
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		--处于远距离，有跑步，向前跑(RunForward)；无跑步，向前走(WalkForward)
		if self.MainBehavior.canRun then
			if self.MainBehavior.haveRunAndHit
				and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunAndHit then
				self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.RunAndHit
			elseif self.MainBehavior.haveRunAndHit == false
				and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunForward then
				self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.RunForward
			end
		elseif self.MainBehavior.canRun == false and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.WalkForward then
			self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.WalkForward
		end
		--针对怪物稍微走出一点点中距离，就马上往前走几帧又切wander的抽搐表现，暂时用前走的cd来进行保护，最好独立定义一个时间by李伟越
		self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + 0.5 * 30
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end