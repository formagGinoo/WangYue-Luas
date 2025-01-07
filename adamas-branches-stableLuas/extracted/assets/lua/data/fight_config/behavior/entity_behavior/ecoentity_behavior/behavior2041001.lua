Behavior2041001 = BaseClass("Behavior2041001",EntityBehaviorBase)
--大悬钟
function Behavior2041001.GetGenerates()
	local generates = {20410010101}
	return generates
end

function Behavior2041001:Init()
	--交互控制
	self.me = self.instanceId
	self.effectId = 20410010101
	self.spawned = false
	self.myPos = nil
	self.interactUniqueId = nil
	
	self.Effect = nil
	
	self.posList = nil
	self.canInteract = nil
	self.canActive = true
	self.isActive = false
	self.clicked = false
	self.closed = false
end


function Behavior2041001:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.spawned == false then
		self.myPos = BehaviorFunctions.GetPositionP(self.me)
		self.Effect = BehaviorFunctions.CreateEntity(self.effectId,self.me,self.myPos.x,self.myPos.y,self.myPos.z,nil,nil,nil,self.levelId)
		self.spawned = true
	end
	
	self.canInteract = BehaviorFunctions.GetEntityValue(self.me,"canInteract")
	
end


--交互
function Behavior2041001:WorldInteractClick(uniqueId, instanceId)
	--if instanceId ~= self.me and self.canInteract ~= true then
		--return
	--end
	
	if instanceId == self.me and self.canInteract == true then
		self.clicked = true
		self.closed = true
		BehaviorFunctions.RemoveEntity(self.Effect)
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end


function Behavior2041001:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canActive then
		if self.isActive == false and self.clicked == false then
			if self.isTrigger then
				return
			end

			self.isTrigger = triggerInstanceId == self.me
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,1,nil,"关闭", 1)
		end
	end
end

function Behavior2041001:ExitTrigger(triggerInstanceId,triggerEntityId,InstanceId)
	if not self.isTrigger or triggerInstanceId ~= self.me then
		return
	end
	self.isTrigger = false
	BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	self.interactUniqueId = nil
end