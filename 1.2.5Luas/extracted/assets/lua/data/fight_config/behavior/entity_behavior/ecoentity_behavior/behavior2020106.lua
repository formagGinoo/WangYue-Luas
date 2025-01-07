Behavior2020106 = BaseClass("Behavior2020106",EntityBehaviorBase)
--开门
function Behavior2020106.GetGenerates()

end

function Behavior2020106:Init()
	self.me = self.instanceId

	
end


function Behavior2020106:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()

end


function Behavior2020106:WorldInteractClick(uniqueId)
	if BehaviorFunctions.CheckTaskId(102030401) then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
			BehaviorFunctions.InteractEntityHit(self.me,false)
		end
	end
end


function Behavior2020106:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if BehaviorFunctions.CheckTaskId(102030401) then
		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Transport,nil,"开门", 1)

	end

end


function Behavior2020106:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if BehaviorFunctions.CheckTaskId(102030401) then
		if self.isTrigger and triggerInstanceId == self.me then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		end
	end
end