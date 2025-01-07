Behavior900000067 = BaseClass("Behavior900000067",EntityBehaviorBase)
function Behavior900000067.GetGenerates()


end

function Behavior900000067:Init()
	self.me = self.instanceId		--记录自己
	self.addTranslucent = false
end

function Behavior900000067:Update()
	if not self.addTranslucent then
		BehaviorFunctions.SetEntityTranslucent(self.me,2,10)
		self.addTranslucent = true
	end
end
--BehaviorFunctions.AddBuff(3,3,900000067)