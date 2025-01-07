Behavior2021101 = BaseClass("Behavior2021101",EntityBehaviorBase)
--小光柱通用逻辑
function Behavior2021101.GetGenerates()

end

function Behavior2021101:Init()
	self.me = self.instanceId
end

function Behavior2021101:LateInit()
	
end

function Behavior2021101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	if distance < 20  then
		BehaviorFunctions.SetEntityShowState(self.me,false)
	else
		BehaviorFunctions.SetEntityShowState(self.me,true)
	end
end