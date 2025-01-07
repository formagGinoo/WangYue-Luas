CommonAnimFSM = BaseClass("CommonAnimFSM", FSM)

function CommonAnimFSM:__init()

end

function CommonAnimFSM:Init(fight, entity)
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

function CommonAnimFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(FightEnum.CommonAnimState.None, objectPool:Get(CommonNoneMachine))
    self:AddState(FightEnum.CommonAnimState.CommonAnimStart, objectPool:Get(CommonAnimStartMachine))
    self:AddState(FightEnum.CommonAnimState.CommonAnimEnd, objectPool:Get(CommonAnimEndMachine))
    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end
end

function CommonAnimFSM:OnEnter(params, callback)
    self:SwitchState(FightEnum.CommonAnimState.CommonAnimStart, params, callback)
end

function CommonAnimFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

function CommonAnimFSM:Update()
    if not self.statesMachine then return end
    self.statesMachine:Update()
end

function CommonAnimFSM:CanMove()
    return self.canMove
end

function CommonAnimFSM:CanCastSkill()
    return false
end

function CommonAnimFSM:Reset()

end

function CommonAnimFSM:OnLeave()
    self.statesMachine:OnLeave()
end

function CommonAnimFSM:SetCanMove(canMove)
    self.canMove = canMove
end

function CommonAnimFSM:SetHackingType(hackingType)
    self.hackingType = hackingType
end

function CommonAnimFSM:GetHackingType()
    return self.hackingType
end

function CommonAnimFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(CommonAnimFSM, self)
end

function CommonAnimFSM:__delete()

end