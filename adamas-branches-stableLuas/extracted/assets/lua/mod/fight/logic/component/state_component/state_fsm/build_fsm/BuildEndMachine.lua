BuildEndMachine = BaseClass("BuildEndMachine", MachineBase)
local AnimatorNameConfig = Config.EntityCommonConfig.AnimatorNames

function BuildEndMachine:__init()

end

function BuildEndMachine:Init(fight, entity, buildFSM)
    self.fight = fight
    self.entity = entity
    self.buildFSM = buildFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
end

function BuildEndMachine:OnEnter()
    self.remainChangeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.BuildEnd, nil, self.aimLayer) or 0
    self.entity.animatorComponent:Update()
    self.fight.entityManager:CallBehaviorFun("OnBuildStateChange", self.entity.instanceId, FightEnum.EntityBuildState.BuildEnd)
    self.buildFSM:SetCanMove(true)
end

function BuildEndMachine:LateInit()
    self.clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent

    if self.clientAnimatorComponent then
        local animator = self.clientAnimatorComponent.animator
        self.aimLayer = animator:GetLayerIndex("AimLayer")
    end
end

function BuildEndMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.remainChangeTime = self.remainChangeTime - time

    if self.remainChangeTime <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function BuildEndMachine:OnLeave()
end

function BuildEndMachine:StartMove()
    self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
end

function BuildEndMachine:OnCache()
end

function BuildEndMachine:__cache()
end

function BuildEndMachine:__delete()
end