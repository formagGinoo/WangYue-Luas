Behavior2020203 = BaseClass("Behavior2020203",EntityBehaviorBase)
--草地奇遇
function Behavior2020203.GetGenerates()

end

function Behavior2020203:Init()
	self.me = self.instanceId
	self.effectState = 0
	self.intercatDone = false
end


function Behavior2020203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.effectState == 0  then
		self.stand = BehaviorFunctions.CreateEntity(202020301,self.me)
		self.effectState =1 
	end
end


function Behavior2020203:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		local rand = math.random(1,3)
		if rand == 1  then
			BehaviorFunctions.CreateEntity(202020302,self.me)
		elseif rand == 2 then
			BehaviorFunctions.CreateEntity(202020303,self.me)
		elseif rand == 3 then
			BehaviorFunctions.CreateEntity(202020304,self.me)
		end
		if self.stand then
			BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.stand)
			self.stand = nil
		end
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		self.intercatDone = true
	end
end


function Behavior2020203:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.intercatDone == false then
		if self.isTrigger then
			return
		end
		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Check,nil,"调查",1)
	end
end


function Behavior2020203:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me and self.intercatDone == false then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end
