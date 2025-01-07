Behavior800010 = BaseClass("Behavior800010",EntityBehaviorBase)
--于静，嘉元版
function Behavior800010.GetGenerates()
	-- local generates = {}
	-- return generates
end
function Behavior800010:Init()
	self.NpcCommon = BehaviorFunctions.CreateBehavior("NpcCommon",self)
end

function Behavior800010:LateInit()
	self.NpcCommon:LateInit()
end


function Behavior800010:Update()
	self.NpcCommon:Update()
end
