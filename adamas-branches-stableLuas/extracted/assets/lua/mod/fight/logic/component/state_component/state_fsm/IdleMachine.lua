IdleMachine = BaseClass("IdleMachine",MachineBase)

function IdleMachine:__init()

end

function IdleMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.idleFSM = self.fight.objectPool:Get(IdleFSM)
	self.idleFSM:Init(fight,entity)
    self.idleFSM.parentFSM = self.parentFSM
    self.idleFSM.stateId = self.stateId
end

function IdleMachine:OnEnter()
	if self.entity.clientIkComponent then
		self.entity.clientIkComponent:SetGrounderFBBIKActive(true)
	end
	self.idleFSM:OnEnter()
end

function IdleMachine:OnLeave()
	if self.entity.clientIkComponent then
		self.entity.clientIkComponent:SetGrounderFBBIKActive(false)
	end
end

function IdleMachine:Update()
	self.idleFSM:Update()
end

function IdleMachine:CanMove()
	return self.idleFSM:CanMove()
end

function IdleMachine:GetSubState()
	return self.idleFSM:GetState()
end

function IdleMachine:CanCastSkill()
	return self.idleFSM:CanCastSkill()
end

function IdleMachine:CanJump()
	return self.idleFSM:CanJump()
end

function IdleMachine:CanClimb()
	return self.idleFSM:CanClimb()
end

function IdleMachine:OnCache()
	if self.idleFSM then
		self.idleFSM:OnCache()
		self.idleFSM = nil
	end
	self.fight.objectPool:Cache(IdleMachine,self)
end

function IdleMachine:__cache()

end

function IdleMachine:__delete()
	if self.idleFSM then
		self.idleFSM:DeleteMe()
		self.idleFSM = nil
	end
end