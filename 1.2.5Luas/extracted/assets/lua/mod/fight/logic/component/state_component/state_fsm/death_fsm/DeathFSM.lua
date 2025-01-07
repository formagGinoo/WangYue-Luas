DeathFSM = BaseClass("DeathFSM", FSM)

local DeathState = FightEnum.DeathState
local DeathReason = FightEnum.DeathReason

function DeathFSM:__init()

end

function DeathFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity

    self.deathReason = nil

    self:InitStates()
    self.reasonEx2State = {
        [DeathReason.Direct] = DeathState.Dying,
        [DeathReason.Damage] = DeathState.Dying,
        [DeathReason.Drowning] = DeathState.Drowning,
        [DeathReason.TerrainDeath] = DeathState.TerrainDeath,
    }
end

function DeathFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(DeathState.None, objectPool:Get(DeathNoneMachine))
    self:AddState(DeathState.Dying, objectPool:Get(DieMachine))
    self:AddState(DeathState.Death, objectPool:Get(DeathCompleteMachine))
    self:AddState(DeathState.Drowning, objectPool:Get(DrowningMachine))
    self:AddState(DeathState.TerrainDeath, objectPool:Get(TerrainDeathMachine))

    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end

    self:SwitchState(DeathState.None)
end

function DeathFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

function DeathFSM:EnterDeath(deathReason, attackEntity)
    local attackInstaceId = attackEntity and attackEntity.instanceId or 0
	self.fight.entityManager:CallBehaviorFun("Die", attackInstaceId, self.entity.instanceId)
    self.fight.taskManager:CallBehaviorFun("Die", attackInstaceId, self.entity.instanceId)

    self.deathReason = deathReason
    self:SwitchState(self.reasonEx2State[self.deathReason])
end

function DeathFSM:Update()
    if self.statesMachine.Update then
        self.statesMachine:Update()
    end
end

function DeathFSM:CanJump()
    return self.statesMachine:CanJump()
end

function DeathFSM:CanMove()
    return self.statesMachine:CanMove()
end

function DeathFSM:CanCastSkill()
    return self.statesMachine:CanCastSkill()
end

function DeathFSM:CanHit()
    return self.statesMachine:CanHit()
end

function DeathFSM:CanStun()
	return false
end

function DeathFSM:Reset()
    self:SwitchState(DeathState.None)
end

function DeathFSM:OnCache()

end

function DeathFSM:__cache()

end

function DeathFSM:__delete()

end