DeathMachine = BaseClass("DeathMachine", MachineBase)

function DeathMachine:__init()

end

function DeathMachine:Init(fight, entity)
	self.fight = fight
	self.entity = entity
	self.deathFSM = self.fight.objectPool:Get(DeathFSM)
	self.deathFSM:Init(fight, entity)
    self.deathFSM.parentFSM = self.parentFSM
    self.deathFSM.stateId = self.stateId
end

function DeathMachine:LateInit()
	self.deathFSM:LateInit()
end

function DeathMachine:OnEnter(deathReason, attackEntity, params)
	self.deathFSM:EnterDeath(deathReason, attackEntity, params)
end

function DeathMachine:Update()
	self.deathFSM:Update()
end

function DeathMachine:SetFakeDeathParam(fakeDeathState, fakeDeathTime)
	if not self.deathFSM then
		return
	end

	self.deathFSM:SetFakeDeathParam(fakeDeathState, fakeDeathTime)
end

function DeathMachine:OnLeave()
	self.deathFSM:Reset()
end

function DeathMachine:CanMove()
	return self.deathFSM:CanMove()
end

function DeathMachine:GetSubState()
	return self.deathFSM:GetState()
end

function DeathMachine:CanCastSkill()
	return self.deathFSM:CanCastSkill()
end

function DeathMachine:CanJump()
	return self.deathFSM:CanJump()
end

function DeathMachine:CanHit()
	return self.deathFSM:CanHit()
end

function DeathMachine:CanStun()
	return self.deathFSM:CanStun()
end

function DeathMachine:OnCache()
	if self.deathFSM then
		self.deathFSM:OnCache()
		self.deathFSM = nil
	end

	self.fight.objectPool:Cache(DeathMachine, self)
end

function DeathMachine:__cache()

end

function DeathMachine:__delete()
	if self.deathFSM then
		self.deathFSM:DeleteMe()
		self.deathFSM = nil
	end
end