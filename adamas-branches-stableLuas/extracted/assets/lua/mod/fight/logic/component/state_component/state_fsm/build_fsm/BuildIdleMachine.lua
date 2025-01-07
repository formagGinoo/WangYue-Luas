BuildIdleMachine = BaseClass("BuildIdleMachine", MachineBase)
local AnimatorNameConfig = Config.EntityCommonConfig.AnimatorNames

local HackMoveType = {
    Stand = AnimatorNameConfig.HackStand,
    Run = AnimatorNameConfig.HackRun,
}

local BuildMoveType = {
    Stand = AnimatorNameConfig.BuildStand,
    Run = AnimatorNameConfig.BuildRun,
}

function BuildIdleMachine:__init()
end

function BuildIdleMachine:Init(fight, entity, buildFSM)
    self.fight = fight
    self.entity = entity
    self.buildFSM = buildFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
end


function BuildIdleMachine:OnEnter()
    self.entity.logicMove = true

    self.moveType = self:GetMoveType("Stand")
    self.entity.animatorComponent:PlayAnimation(self.moveType, 0, 0)

    self.startSpeed = self.entity.transformComponent:GetSpeed()
    self.stepFrame = 0
    self.changeFrame = 0
    self.fight.entityManager:CallBehaviorFun("OnBuildStateChange", self.entity.instanceId, FightEnum.EntityBuildState.BuildIdle)
end

function BuildIdleMachine:LateInit()
    if self.entity.attrComponent then
        self.speed = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed)
    else
        self.speed = 0
    end
end

function BuildIdleMachine:Update()
    if not self.buildFSM.canMove then
        return
    end

    local moveEvent = self.fight.operationManager:GetMoveEvent()
    local moveType = self:GetMoveType("Stand")
    local speed = 0
    if moveEvent then
        moveType = self:GetMoveType("Run")
        speed = self.speed
    end

    if moveType ~= self.moveType then
        self.moveType = moveType
        self.animatorComponent:PlayAnimation(self.moveType)
        self.startSpeed = self.entity.transformComponent:GetSpeed()
        self.changeFrame = self.entity.animatorComponent.fusionFrame
        self.stepFrame = 0
    end

    if self.stepFrame < self.changeFrame then
        speed = self.startSpeed + (self.speed - self.startSpeed) * (self.stepFrame / self.changeFrame)
        self.stepFrame = self.stepFrame + 1
    end

    local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
    self.entity.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond * timeScale)
end

function BuildIdleMachine:GetMoveType(type)
    local mode = self.fight.hackManager:GetHackMode()
    if mode then
        return mode == FightEnum.HackMode.Build and BuildMoveType[type] or HackMoveType[type]
    else
        return HackMoveType[type]
    end
end

function BuildIdleMachine:OnLeave()
    self.entity.logicMove = false
end

function BuildIdleMachine:OnCache()
end

function BuildIdleMachine:__cache()
end

function BuildIdleMachine:__delete()
end