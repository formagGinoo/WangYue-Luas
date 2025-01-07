BuildStartMachine = BaseClass("BuildStartMachine", MachineBase)

local AnimatorNameConfig = Config.EntityCommonConfig.AnimatorNames

function BuildStartMachine:__init()

end

function BuildStartMachine:Init(fight, entity, buildFSM)
    self.fight = fight
    self.entity = entity
    self.buildFSM = buildFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
end


function BuildStartMachine:OnEnter()
    local eulerAngles = self.fight.clientFight.cameraManager:GetCameraRotaion().eulerAngles
    eulerAngles.x = 0
    eulerAngles.z = 0
    self.entity.rotateComponent:SetRotation(Quat.Euler(eulerAngles))
    self.clientTransformComponent:ClearMoveX()
    self.clientTransformComponent:Async()


    self.remainChangeTime = self.entity.animatorComponent:PlayAnimation(AnimatorNameConfig.BuildStart, nil, self.aimLayer) or 0
    self.buildFSM:SetCanMove(false)
    self.fight.entityManager:CallBehaviorFun("OnBuildStateChange", self.entity.instanceId, FightEnum.EntityBuildState.BuildStart)
end

function BuildStartMachine:LateInit()
    self.clientTransformComponent = self.entity.clientTransformComponent
    self.clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent

    if self.clientAnimatorComponent then
        local animator = self.clientAnimatorComponent.animator
        self.aimLayer = animator:GetLayerIndex("AimLayer")
    end
end

function BuildStartMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.remainChangeTime = self.remainChangeTime - time

    if self.remainChangeTime <= 0 then
        self.buildFSM:SwitchState(FightEnum.EntityBuildState.BuildMove)
    end
end

function BuildStartMachine:OnLeave()
    self.buildFSM:SetCanMove(true)
end

function BuildStartMachine:OnCache()
    self.fight.objectPool:Cache(BuildStartMachine,self)
end

function BuildStartMachine:__cache()
end

function BuildStartMachine:__delete()
end