FSMBehavior9000020101 = BaseClass("FSMBehavior9000020101",FSMBehaviorBase)
--和平默认状态


function FSMBehavior9000020101.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000020101:Init()

end

function FSMBehavior9000020101:LateInit()

end

function FSMBehavior9000020101:Update()
	--直接跳转进巡逻或生态表演
	if self.ParentBehavior.peaceState then
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end