DeathFSM = BaseClass("DeathFSM", FSM)

local DeathState = FightEnum.DeathState
local DeathReason = FightEnum.DeathReason

function DeathFSM:__init()

end

function DeathFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity

    self.fakeDeath = false
    self.fakeDeathTime = 0
    self.deathReason = nil
    self.deathParams = nil
    self.attackInstance = nil

    self:InitStates()
    self.reasonEx2State = {
        [DeathReason.Direct] = DeathState.Dying,
        [DeathReason.Damage] = DeathState.Dying,
        [DeathReason.Drowning] = DeathState.Drowning,
        [DeathReason.TerrainDeath] = DeathState.TerrainDeath,
        [DeathReason.ExecuteDeath] = DeathState.ExecuteDeath,
        [DeathReason.CatchDeath] = DeathState.CatchDeath,
    }
end

function DeathFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(DeathState.None, objectPool:Get(DeathNoneMachine))
    self:AddState(DeathState.Dying, objectPool:Get(DieMachine))
    self:AddState(DeathState.Death, objectPool:Get(DeathCompleteMachine))
    self:AddState(DeathState.Drowning, objectPool:Get(DrowningMachine))
    self:AddState(DeathState.TerrainDeath, objectPool:Get(TerrainDeathMachine))
    self:AddState(DeathState.ExecuteDeath, objectPool:Get(ExecuteDeathMachine))
    self:AddState(DeathState.FakeDeath, objectPool:Get(FakeDeathMachine))
    self:AddState(DeathState.CatchDeath, objectPool:Get(CatchDeathMachine))

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

function DeathFSM:GetCatchDeathState()
    if self.deathReason ~= DeathReason.CatchDeath then return end
    return self.states[DeathState.CatchDeath]
end

function DeathFSM:EnterDeath(deathReason, attackEntity, params)
    self.deathReason = deathReason
    self.deathParams = params
    self.attackInstance = attackEntity and attackEntity.instanceId or 0

    if self.fakeDeath then
        self:SwitchState(FightEnum.DeathState.FakeDeath)
        self.fakeDeath = false
    else
        self:BeginDie()
    end

    if self.entity.clientIkComponent then
        self.entity.clientIkComponent:SetLookEnable(false)
    end
end

function DeathFSM:BeginDie()
    if self.attackInstance and self.attackInstance ~= 0 then
        self.fight.entityManager:CallBehaviorFun("Kill", self.attackInstance, self.entity.instanceId)
    end

    self.fight.entityManager:CallBehaviorFun("Die", self.attackInstance, self.entity.instanceId, self.deathReason)
    EventMgr.Instance:Fire(EventName.OnEntityDie, self.attackInstance, self.entity.instanceId, self.deathReason)
    EventMgr.Instance:Fire(EventName.UpdateQTERes, self.attackInstance, self.entity.instanceId, self.deathReason)
    self:SwitchState(self.reasonEx2State[self.deathReason], self.deathParams)
end

function DeathFSM:SetFakeDeathParam(fakeDeath, fakeDeathTime)
    self.fakeDeath = fakeDeath
    self.fakeDeathTime = fakeDeath and fakeDeathTime or 0
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
    self.fakeDeath = false
    self.fakeDeathTime = 0
    self.deathReason = nil
    self.deathParams = nil
    self.attackInstance = nil

    self:SwitchState(DeathState.None)
end

function DeathFSM:OnCache()

end

function DeathFSM:__cache()

end

function DeathFSM:__delete()

end