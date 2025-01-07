Behavior20305022 = BaseClass("Behavior20305022",EntityBehaviorBase)
--电压陷阱
function Behavior20305022.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior20305022:Init()
	self.me = self.instanceId
	self.fx = 0
end

function Behavior20305022:LateInit()
	
end


function Behavior20305022:Update()
	--if BehaviorFunctions.HasBuffKind(self.me,2030502201) then
	--else
		--BehaviorFunctions.AddBuff(self.me,self.me,2030502201)
	--end
	--if self.fx ~= 0 then
	--else
	--	self.fx = BehaviorFunctions.CreateEntity(2030502001,self.me)
	--	print(111)
	--end
	
end