BuildMoveMachine = BaseClass("BuildMoveMachine", MachineBase)
local AnimatorNameConfig = Config.EntityCommonConfig.AnimatorNames

function BuildMoveMachine:__init()

end

function BuildMoveMachine:Init(fight, entity, buildFSM)
    self.fight = fight
    self.entity = entity
    self.buildFSM = buildFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
    self.moveDir = FightEnum.Direction.None
    self.canMove = true
end

function BuildMoveMachine:LateInit()
    self.clientTransformComponent = self.entity.clientTransformComponent
    self.clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent

    if self.clientAnimatorComponent then
        local animator = self.clientAnimatorComponent.animator
        self.walkLayer = animator:GetLayerIndex("AimWalkLayer")
        self.aimLayer = animator:GetLayerIndex("AimLayer")
    end

    if self.entity.attrComponent then
        self.runSpeed = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed)
    else
        self.runSpeed = 0
    end
end

function BuildMoveMachine:OnEnter()
    local eulerAngles = self.fight.clientFight.cameraManager:GetCameraRotaion().eulerAngles
    eulerAngles.x = 0
    eulerAngles.z = 0
    self.entity.rotateComponent:SetRotation(Quat.Euler(eulerAngles))
    self.clientTransformComponent:ClearMoveX()
    self.clientTransformComponent:Async()

    --TODO
    self.entity.animatorComponent:PlayAnimation("Stand1", 0, 0)
    self.entity.animatorComponent:PlayAnimation(AnimatorNameConfig.BuildBodyIdle, nil, self.aimLayer)
    if self.moveDir == FightEnum.Direction.None then
        self.animatorComponent:PlayAnimation(FightEnum.BuildWalkDirAnim[self.moveDir], nil, self.walkLayer)
        self.animatorComponent:Update()
    end
    self.entity.logicMove = true
    self.fight.entityManager:CallBehaviorFun("OnBuildStateChange", self.entity.instanceId, FightEnum.EntityBuildState.BuildMove)
end

function BuildMoveMachine:Update()
    local eulerAngles = self.fight.clientFight.cameraManager:GetCameraRotaion().eulerAngles
    eulerAngles.x = 0
    eulerAngles.z = 0
    self.entity.rotateComponent:SetRotation(Quat.Euler(eulerAngles))
    self.clientTransformComponent:ClearMoveX()
    self.clientTransformComponent:Async()
    
    
    local moveEvent = self.fight.operationManager:GetMoveEvent()

    if moveEvent and self.buildFSM.disableLeft then
        if moveEvent.x > 0 then
            moveEvent = nil
            self:StopMove()
        end
    end
    if moveEvent and self.buildFSM.disableRight then
        if moveEvent.x < 0 then
            moveEvent = nil
            self:StopMove()
        end
    end
    if self.canMove and moveEvent and self.runSpeed > 0 then
        local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
        local speed = self.runSpeed * FightUtil.deltaTimeSecond * timeScale
        local rotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
        local forward = rotate * Vec3.forward

        local entityForward = self.entity.transformComponent.rotation * Vec3.forward
        local degree = CustomUnityUtils.AngleSigned(entityForward, forward) % 360
        self:UpdateMoveAnim(degree)
        self.moveComponent:DoMove(forward.x * speed, forward.z * speed)
    end
end


function BuildMoveMachine:UpdateMoveAnim(degree)
    local moveDir
    if 315 <= degree or degree < 45 then
        moveDir = FightEnum.Direction.Forward
    elseif 45 <= degree and degree < 135 then
        moveDir = FightEnum.Direction.Right
    elseif 135 <= degree and degree < 225 then
        moveDir = FightEnum.Direction.Back
    else
        moveDir = FightEnum.Direction.Left
    end

    if moveDir ~= self.moveDir then
        self.moveDir = moveDir
        self.animatorComponent:PlayAnimation(FightEnum.BuildWalkDirAnim[moveDir], nil, self.walkLayer)
    end
end

function BuildMoveMachine:StartMove()
    --if not self.statesMachine then return end
    --if self.statesMachine.StartMove then
    --    self.statesMachine:StartMove()
    --end
end

function BuildMoveMachine:StopMove()
    self.moveDir = FightEnum.Direction.None
    self.animatorComponent:PlayAnimation(FightEnum.BuildWalkDirAnim[self.moveDir], nil, self.walkLayer)
end

function BuildMoveMachine:OnLeave()
    self.moveDir = FightEnum.Direction.None
    self.entity.logicMove = false
end

function BuildMoveMachine:OnCache()

end

function BuildMoveMachine:__cache()

end

function BuildMoveMachine:__delete()

end