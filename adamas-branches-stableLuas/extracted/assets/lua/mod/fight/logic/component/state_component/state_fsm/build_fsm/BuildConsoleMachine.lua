BuildConsoleMachine = BaseClass("BuildConsoleMachine", MachineBase)
local AnimatorNameConfig = Config.EntityCommonConfig.AnimatorNames

function BuildConsoleMachine:__init()

end

function BuildConsoleMachine:Init(fight, entity, buildFSM)
    self.fight = fight
    self.entity = entity
    self.buildFSM = buildFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
end

function BuildConsoleMachine:OnEnter()
    self.entity.animatorComponent:PlayAnimation(AnimatorNameConfig.BuildBodyIdle, nil, self.aimLayer)
    self.entity.animatorComponent:PlayAnimation(FightEnum.BuildWalkDirAnim[FightEnum.Direction.None], nil, self.walkLayer)
    self.entity.animatorComponent:Update()
    self.fight.entityManager:CallBehaviorFun("OnBuildStateChange", self.entity.instanceId, FightEnum.EntityBuildState.BuildConsole)
    self.buildFSM:SetCanMove(false)
end

function BuildConsoleMachine:LateInit()
    self.clientTransformComponent = self.entity.clientTransformComponent
    self.clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent

    if self.clientAnimatorComponent then
        local animator = self.clientAnimatorComponent.animator
        self.walkLayer = animator:GetLayerIndex("AimWalkLayer")
        self.aimLayer = animator:GetLayerIndex("AimLayer")
    end
end

function BuildConsoleMachine:Update()

end

function BuildConsoleMachine:OnLeave()
end

function BuildConsoleMachine:StartMove()

end

function BuildConsoleMachine:OnCache()
end

function BuildConsoleMachine:__cache()
end

function BuildConsoleMachine:__delete()
end