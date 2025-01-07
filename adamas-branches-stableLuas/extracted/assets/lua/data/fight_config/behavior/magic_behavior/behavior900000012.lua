
Behavior900000012 = BaseClass("Behavior900000012",EntityBehaviorBase)
function Behavior900000012.GetGenerates()


end

function Behavior900000012.GetMagics()

end

function Behavior900000012:Init()
	self.me = self.instanceId		--记录自己
end

function Behavior900000012:Update()
	BehaviorFunctions.SetEntityValue(self.me,"runAi",false)  --屏蔽逻辑
end