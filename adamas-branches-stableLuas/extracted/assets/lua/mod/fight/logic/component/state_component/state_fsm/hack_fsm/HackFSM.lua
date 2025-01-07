HackFSM = BaseClass("HackFSM", FSM)

function HackFSM:__init()

end

function HackFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.moveComponent = self.entity.moveComponent
    self.moveDir = FightEnum.Direction.None
    self.animatorComponent = self.entity.animatorComponent
    self.canMove = true
    self.lockTargetEnable = false
    self.hackingType = nil
    self:InitStates()
end

function HackFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(FightEnum.HackState.HackStart, objectPool:Get(HackStartMachine))
    self:AddState(FightEnum.HackState.Waiting, objectPool:Get(WaitingHackMachine))
    self:AddState(FightEnum.HackState.Hacking, objectPool:Get(HackingMachine))
    self:AddState(FightEnum.HackState.HackEnd, objectPool:Get(HackEndMachine))
    self:AddState(FightEnum.HackState.HackInput, objectPool:Get(HackInputMachine))
    self:AddState(FightEnum.HackState.BeingHacked, objectPool:Get(BeingHackedMachine))
    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end
end

function HackFSM:OnEnter()
    self:SwitchState(FightEnum.HackState.HackStart)
end

function HackFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

function HackFSM:Update()
	if not self.statesMachine then return end
	self.statesMachine:Update()
end

function HackFSM:CanMove()
    return self.canMove
end

function HackFSM:CanCastSkill()
    return false
end

function HackFSM:Reset()

end

function HackFSM:OnLeave()
    self.statesMachine:OnLeave()
end

function HackFSM:SetCanMove(canMove)
    self.canMove = canMove
end

function HackFSM:SetHackingType(hackingType)
    self.hackingType = hackingType
end

function HackFSM:GetHackingType()
    return self.hackingType
end

function HackFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(HackFSM, self)
end

function HackFSM:__delete()

end