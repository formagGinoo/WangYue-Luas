Behavior2041106 = BaseClass("Behavior2041106",EntityBehaviorBase)
--生态玩法 - 链接电线 - 电路开关起点
function Behavior2041106.GetGenerates()
end
function Behavior2041106:Init()
	self.me = self.instanceId
	self.battleTarget = nil
	self.ecoId = nil
	self.ecoState = nil
	self.myStateEnum =
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
	}
	self.myState = self.myStateEnum.inactive
end
function Behavior2041106:LateInit()
end
function Behavior2041106:Update()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
		BehaviorFunctions.SetEntityHackEnable(self.me,false)
	else
		BehaviorFunctions.SetEntityHackEnable(self.me,false)
	end
end
function Behavior2041106:HackingClickUp(instanceId)
end