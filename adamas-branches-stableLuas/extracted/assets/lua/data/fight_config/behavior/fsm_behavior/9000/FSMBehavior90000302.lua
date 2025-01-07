FSMBehavior90000302 = BaseClass("FSMBehavior90000302",FSMBehaviorBase)



function FSMBehavior90000302.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior90000302:Init()
	self.skillDone = false
end

function FSMBehavior90000302:Update()
	if self.skillDone == true then
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end