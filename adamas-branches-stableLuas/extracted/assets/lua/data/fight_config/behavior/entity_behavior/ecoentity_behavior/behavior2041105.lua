Behavior2041105 = BaseClass("Behavior2041105",EntityBehaviorBase)
--生态玩法 - 链接电线 - 电路开关起点
function Behavior2041105.GetGenerates()
end
function Behavior2041105:Init()
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
function Behavior2041105:LateInit()
end
function Behavior2041105:Update()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
	end
end
function Behavior2041105:HackingClickUp(instanceId)
	if instanceId == self.me then
		if self.myState == self.myStateEnum.inactive then			--inactive = 1,--未激活状态
			self.myState = self.myStateEnum.activated

			BehaviorFunctions.SetEntityHackEnable(self.me,false)
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.me,true)
			BehaviorFunctions.SetEntityValue(self.me,"wire",true)

			if BehaviorFunctions.GetEntityHackEffectIsTask(self.me) == true then	--开关变黄色
				BehaviorFunctions.SetEntityHackEffectIsTask(self.me, false)
			else
				BehaviorFunctions.SetEntityHackEffectIsTask(self.me, true)
			end
		else
			self.myState = self.myStateEnum.inactive

			BehaviorFunctions.SetEntityHackEnable(self.me,false)
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.me,true)
			BehaviorFunctions.SetEntityValue(self.me,"wire",false)

			BehaviorFunctions.SetEntityHackEffectIsTask(self.me, false)
		end
	end
end