Behavior2041002 = BaseClass("Behavior2041002",EntityBehaviorBase)
--大悬钟
function Behavior2041002.GetGenerates()
	local generates = {20410010101}
	return generates
end

function Behavior2041002:Init()
	--交互控制
	self.me = self.instanceId
	self.effectId = 204100201
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


function Behavior2041002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.spawned == false then
		self.myPos = BehaviorFunctions.GetPositionP(self.me)
		self.Effect = BehaviorFunctions.CreateEntity(self.effectId,self.me,self.myPos.x,self.myPos.y,self.myPos.z,nil,nil,nil,self.levelId)
		self.spawned = true
	end
end


--交互
function Behavior2041002:WorldInteractClick(uniqueId, instanceId)
	--if instanceId ~= self.me and self.canInteract ~= true then
	--return
	--end

	if instanceId == self.me and self.canInteract == true then
		self.clicked = true
		self.closed = true
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end


function Behavior2041002:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isActive == false and self.clicked == false then
		if self.isTrigger then
			return
		end
		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,1,nil,"捡起", 1)
	end
end

function Behavior2041002:ExitTrigger(triggerInstanceId,triggerEntityId,InstanceId)
	if not self.isTrigger or triggerInstanceId ~= self.me then
		return
	end
	self.isTrigger = false
	BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	self.interactUniqueId = nil
end