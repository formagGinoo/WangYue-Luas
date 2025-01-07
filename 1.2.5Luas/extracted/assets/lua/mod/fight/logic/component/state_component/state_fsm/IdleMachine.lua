IdleMachine = BaseClass("IdleMachine",MachineBase)

function IdleMachine:__init()

end

function IdleMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.idleFSM = self.fight.objectPool:Get(IdleFSM)
	self.idleFSM:Init(fight,entity)
end

function IdleMachine:OnEnter()
	self.entity.clientEntity.clientTransformComponent:SetGrounderFBBIKActive(true)
	self.idleFSM:OnEnter()
end

function IdleMachine:OnLeave()
	self.entity.clientEntity.clientTransformComponent:SetGrounderFBBIKActive(false)
end

function IdleMachine:Update()
	self.idleFSM:Update()
end

function IdleMachine:CanMove()
	return self.idleFSM:CanMove()
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