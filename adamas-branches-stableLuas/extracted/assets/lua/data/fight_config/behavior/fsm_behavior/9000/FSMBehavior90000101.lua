FSMBehavior90000101 = BaseClass("FSMBehavior90000101",FSMBehaviorBase)
--出生默认状态


function FSMBehavior90000101.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior90000101:Init()

end

function FSMBehavior90000101:Update()
	BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
end