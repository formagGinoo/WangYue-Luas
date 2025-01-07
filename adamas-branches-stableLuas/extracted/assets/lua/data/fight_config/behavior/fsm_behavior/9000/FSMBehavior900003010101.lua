FSMBehavior900003010101 = BaseClass("FSMBehavior900003010101",FSMBehaviorBase)
--战斗游荡默认状态


function FSMBehavior900003010101.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003010101:Init()

end

function FSMBehavior900003010101:Update()
	BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
end