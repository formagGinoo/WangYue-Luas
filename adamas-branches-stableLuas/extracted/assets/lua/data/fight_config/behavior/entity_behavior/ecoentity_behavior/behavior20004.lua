Behavior20004 = BaseClass("Behavior20004",EntityBehaviorBase)
--竞速挑战
function Behavior20004.GetGenerates()

end

function Behavior20004:Init()
	self.me = self.instanceId
end


function Behavior20004:Update()
	--if self.isTrigger then
		--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1) then
			--print("collect")
			--self.isTrigger = false
			--BehaviorFunctions.InteractTrigger(false)
			--BehaviorFunctions.InteractEntityHit(self.me, FightEnum.SysEntityOpType.Mine)
		--end
	--end
end


function Behavior20004:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.CreateDuplicate(1001)
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId) --移除
	end
end


function Behavior20004:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return
	end

	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end

	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item,200001,"开启挑战", 1)
end


function Behavior20004:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end