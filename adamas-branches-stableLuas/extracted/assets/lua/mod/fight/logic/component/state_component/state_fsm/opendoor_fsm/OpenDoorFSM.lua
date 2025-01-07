OpenDoorFSM = BaseClass("OpenDoorFSM", FSM)

function OpenDoorFSM:__init()

end

function OpenDoorFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.moveComponent = self.entity.moveComponent
    self.moveDir = FightEnum.Direction.None
    self.animatorComponent = self.entity.animatorComponent
    self.canMove = false
    self.lockTargetEnable = false
    self.hackingType = nil
    self:InitStates()
end

function OpenDoorFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(FightEnum.OpenDoorState.OpenDoorStart, objectPool:Get(OpenDoorStartMachine))
    self:AddState(FightEnum.OpenDoorState.Driving, objectPool:Get(DrivingMachine))
    self:AddState(FightEnum.OpenDoorState.OpenDoorEnd, objectPool:Get(OpenDoorEndMachine))
    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end
end

function OpenDoorFSM:OnEnter(type, callback,bip)
    self:SwitchState(type, callback,bip)
end

function OpenDoorFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

function OpenDoorFSM:Update()
    if not self.statesMachine then return end
    self.statesMachine:Update()
end

function OpenDoorFSM:CanMove()
    return self.canMove
end

function OpenDoorFSM:CanCastSkill()
    return false
end

function OpenDoorFSM:CanJump()
    return false
end

function OpenDoorFSM:CanHit()
    return false
end

function OpenDoorFSM:CanStun()
    return false
end

function OpenDoorFSM:Reset()

end

function OpenDoorFSM:OnLeave()
    self.statesMachine:OnLeave()
	self.entity.clientIkComponent:SetGenericPoser(nil,false)
end

function OpenDoorFSM:SetCanMove(canMove)
    self.canMove = canMove
end

function OpenDoorFSM:SetHackingType(hackingType)
    self.hackingType = hackingType
end

function OpenDoorFSM:GetHackingType()
    return self.hackingType
end

function OpenDoorFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(OpenDoorFSM, self)
end

function OpenDoorFSM:__delete()

end