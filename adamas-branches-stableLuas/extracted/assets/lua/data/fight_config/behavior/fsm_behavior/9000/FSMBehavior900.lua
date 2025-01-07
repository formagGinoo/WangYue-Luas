FSMBehavior900 = BaseClass("FSMBehavior900",FSMBehaviorBase)
--资源预加载
function FSMBehavior900.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function FSMBehavior900.GetMagics()
	local generates = {}
	return generates
end

function FSMBehavior900:Init()
	self.hitWhenInitial = 0
end

function FSMBehavior900:LateInit()
	
end

function FSMBehavior900:Update()
	
	--被暗杀动作传参
	BehaviorFunctions.SetEntityValue(self.ParentBehavior.me,"backHited",self.ParentBehavior.backHited)
	BehaviorFunctions.SetEntityValue(self.ParentBehavior.me,"beAssassin",self.ParentBehavior.beAssassin)

end