BuildFSM = BaseClass("BuildFSM", FSM)

function BuildFSM:__init()

end

function BuildFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
    self.canMove = true
    self:InitStates()
end

function BuildFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(FightEnum.EntityBuildState.BuildIdle, objectPool:Get(BuildIdleMachine))
    self:AddState(FightEnum.EntityBuildState.BuildStart, objectPool:Get(BuildStartMachine))
    self:AddState(FightEnum.EntityBuildState.BuildFail, objectPool:Get(BuildFailMachine))
    self:AddState(FightEnum.EntityBuildState.BuildMove, objectPool:Get(BuildMoveMachine))
    self:AddState(FightEnum.EntityBuildState.BuildEnd, objectPool:Get(BuildEndMachine))
    self:AddState(FightEnum.EntityBuildState.BuildConsole, objectPool:Get(BuildConsoleMachine))

    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end
end

function BuildFSM:OnEnter()
    self:SwitchState(FightEnum.EntityBuildState.BuildIdle)
end

function BuildFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

function BuildFSM:Update()
	if not self.statesMachine then return end
	self.statesMachine:Update()
end

function BuildFSM:CanMove()
    return self.canMove
end

function BuildFSM:SetCanMove(canMove)
    self.canMove = canMove
end

function BuildFSM:SetDisableHorizontalMove(disableLeft, disableRight)
    self.disableLeft = disableLeft
    self.disableRight = disableRight
end

function BuildFSM:CanCastSkill()
    return false
end

function BuildFSM:Reset()

end

function BuildFSM:OnLeave()
    self.statesMachine:OnLeave()
    EventMgr.Instance:Fire(EventName.QuitBuildState)
end

function BuildFSM:StartMove()
    if not self.statesMachine then return end
    if self.statesMachine.StartMove then
        self.statesMachine:StartMove()
    end
end

function BuildFSM:StopMove()
    if not self.statesMachine then return end
    if self.statesMachine.StopMove then
        self.statesMachine:StopMove()
    end
end

function BuildFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(BuildFSM, self)
end

function BuildFSM:__delete()

end