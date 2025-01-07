IdleFSM = BaseClass("IdleFSM",FSM)
local EntityIdleType = FightEnum.EntityIdleType

function IdleFSM:__init()
end

function IdleFSM:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self:InitStates()
end

function IdleFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(EntityIdleType.None, objectPool:Get(IdleNoneMachine))
	self:AddState(EntityIdleType.FightIdle, objectPool:Get(IdleFightMachine))
	self:AddState(EntityIdleType.FightToLeisurely, objectPool:Get(IdleFightToLeisurelyMachine))
	self:AddState(EntityIdleType.LeisurelyIdle, objectPool:Get(IdleLeisurelyMachine))
	self:AddState(EntityIdleType.InjuredIdle, objectPool:Get(IdleInjuredMachine))
	for k, v in pairs(self.states) do
		v:Init(self.fight,self.entity,self)
	end
	self:SwitchState(EntityIdleType.None)
end

function IdleFSM:SetIdleType(type)
	if self:IsState(type)then
		return
	end
	self:SwitchState(type)
end


function IdleFSM:OnEnter()
	if self.entity.defaultIdleType then
		self:SwitchState(self.entity.defaultIdleType)
	else
		self:SwitchState(EntityIdleType.LeisurelyIdle)
	end
end

function IdleFSM:CanMove()
	return true
end

function IdleFSM:CanCastSkill()
	return self.statesMachine:CanCastSkill()
end

function IdleFSM:CanJump()
	return self.statesMachine:CanJump()
end

function IdleFSM:CanClimb()
	return self.statesMachine:CanClimb()
end

function IdleFSM:Reset()
	self:SwitchState(EntityIdleType.None)
end

function IdleFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(IdleFSM,self)
end

function IdleFSM:__delete()
end
