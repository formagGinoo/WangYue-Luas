Behavior20305021 = BaseClass("Behavior20305021",EntityBehaviorBase)
--电压陷阱
function Behavior20305021.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior20305021:Init()
	self.me = self.instanceId
	self.fx = 0
end

function Behavior20305021:LateInit()
	
end


function Behavior20305021:Update()
	--if BehaviorFunctions.HasBuffKind(self.me,2030502201) then
	--else
		--BehaviorFunctions.AddBuff(self.me,self.me,2030502201)
	--end
	if self.fx ~= 0 then
	else
		self.fx = BehaviorFunctions.CreateEntity(2030502201,self.me)
	end
	
end