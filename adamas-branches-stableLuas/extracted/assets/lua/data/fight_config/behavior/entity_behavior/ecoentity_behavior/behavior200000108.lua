Behavior200000108 = BaseClass("Behavior200000108",EntityBehaviorBase)
--竞速挑战
function Behavior200000108.GetGenerates()

end

function Behavior200000108:Init()
	self.me = self.instanceId
	self.duplicateLevelID = nil
	self.showSelf = true
end


function Behavior200000108:Update()
	if self.showSelf == false then
		if not BehaviorFunctions.HasBuffKind(self.me,200000101) then
			--对自身施加隐藏buff
			BehaviorFunctions.AddBuff(self.me,self.me,200000101)
		end
	end
	if self.sInstanceId then
		BehaviorFunctions.GetNpcExtraParam(self.sInstanceId)
	end
end


function Behavior200000108:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.CreateDuplicate(31000001)
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId) --移除
	end
end


function Behavior200000108:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return
	end

	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end

	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item,200001,"开启挑战", 1)
end


function Behavior200000108:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end