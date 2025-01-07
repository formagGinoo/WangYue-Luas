
AimFSM = BaseClass("AimFSM", FSM)

local EntityAimState = FightEnum.EntityAimState
local AimScreenW = Screen.width * 0.5
local AimScreenH = Screen.height * 0.5
local AimParam = Config.EntityCommonConfig.AimParam
local WeakEntityEffectId = 1000000004
local Quat = Quat
local AimLockTarget = Config.EntityCommonConfig.AimLockTarget

function AimFSM:__init()
	self.lockTargetMoveX = 0
	self.lockTargetMoveY = 0
end

function AimFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.moveComponent = self.entity.moveComponent
    self.moveDir = FightEnum.Direction.None
    self.animatorComponent = self.entity.animatorComponent
    self.canMove = true
    self.lockTargetEnable = false
    self:InitStates()
end

function AimFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(EntityAimState.AimStart, objectPool:Get(AimStartMachine))
    self:AddState(EntityAimState.Aiming, objectPool:Get(AimIngMachine))
    self:AddState(EntityAimState.AimShoot, objectPool:Get(AimShootMachine))
    self:AddState(EntityAimState.AimEnd, objectPool:Get(AimEndMachine))
    for k, v in pairs(self.states) do
        v:Init(self.fight,self.entity,self)
    end
end

function AimFSM:SwitchState(state,attackConfig,attackEntity)
    self:BaseFunc("SwitchState", state,attackConfig,attackEntity)
    self.fight.entityManager:CallBehaviorFun("AimSwitchState", self.entity.instanceId, state)
    self:Update()
end

function AimFSM:OnEnter()
    AimFSM.weakNess = true
    self.clientTransformComponent:SetGroupVisible("AimGroup", true)
    self.weakNessEntity = self.fight.entityManager:CreateEntity(WeakEntityEffectId, self.entity) 

    local eulerAngles = self.fight.clientFight.cameraManager:GetCameraRotaion().eulerAngles
    eulerAngles.x = 0
    eulerAngles.z = 0
    self.entity.rotateComponent:SetRotation(Quat.Euler(eulerAngles))
	self.clientTransformComponent:ClearMoveX()
    self.clientTransformComponent:Async()

    if not self.aimTargetTrans then
        self.aimTargetTrans = self.fight.clientFight:GetAimTargetTrans()
        self.transform = self.clientTransformComponent:GetTransform()
    end
    CustomUnityUtils.SetAimTarget(self.transform, self.aimTargetTrans)

    self.entity.animatorComponent:PlayAnimation("Stand2", 0, 0)
    if self.moveDir == FightEnum.Direction.None then
        self.animatorComponent:PlayAnimation(FightEnum.WalkDirAnim[self.moveDir], nil, self.walkLayer)
		self.animatorComponent:Update()
    end
    self.entity.logicMove = true
end

function AimFSM:LateInit()
    self.clientTransformComponent = self.entity.clientEntity.clientTransformComponent   
    self.clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent    

    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end

    if self.clientAnimatorComponent then
        local animator = self.clientAnimatorComponent.animator
        self.aimLayer = animator:GetLayerIndex("AimLayer")
        self.walkLayer = animator:GetLayerIndex("AimWalkLayer")
    end
	
	if self.entity.attrComponent then
		self.walkSpeed = self.entity.attrComponent.attrs[EntityAttrsConfig.AttrType.WalkSpeed]
	else
		self.walkSpeed = 0
	end
	
	if self.entity.aimComponent then
		self.aimConfig = self.entity.aimComponent.config
	end
end

function AimFSM:Update()
    self.statesMachine:Update()
    local moveEvent = self.fight.operationManager:GetMoveEvent()
    if self.canMove and moveEvent and self.walkSpeed > 0 then
        local speed = self.walkSpeed * FightUtil.deltaTimeSecond
        local rotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
		local forward = rotate * Vec3.forward
		
        local entityForward = self.entity.transformComponent.rotation * Vec3.forward
        local degree = CustomUnityUtils.AngleSigned(entityForward, forward) % 360
        self:UpdateMoveAnim(degree)
        self.moveComponent:DoMove(forward.x * speed, forward.z * speed)
    end

    self:UpdateSetAimUITarget()
end

function AimFSM:StartMove()
    self:Update()
end

function AimFSM:StopMove()
    self.moveDir = FightEnum.Direction.None
    self.animatorComponent:PlayAnimation(FightEnum.WalkDirAnim[self.moveDir], nil, self.walkLayer)
end

function AimFSM:CanMove()
    return self.canMove
end

function AimFSM:CanCastSkill()
    return true
end

function AimFSM:Reset()

end

function AimFSM:SetShootSingle()
    self.shootSingle = true
end

function AimFSM:OnLeave()
    print("AimFSM OnLeave")
    self.moveDir = FightEnum.Direction.None
    self.shootSingle = false
    self.entity.logicMove = false
    EventMgr.Instance:Fire(EventName.SetAimImage, 0)

    if self.weakNessEntity then
        self.fight.entityManager:RemoveEntity(self.weakNessEntity.instanceId)
        self.weakNessEntity = nil
        AimFSM.weakNess = false
    end

    if self.weakPart then
        self.weakPart:DestroyWeakEffectEntity()
        self.weakPart = nil
    end

    CustomUnityUtils.SetAimAnimateDirection(self.transform, 0, 0,1)  
    self.clientTransformComponent:SetGroupVisible("AimGroup", false)
    -- self:CameraAimEnd() 
end

function AimFSM:GetWeakPart()
    return self.weakPart
end

function AimFSM:SetCanMove(canMove)
    self.canMove = canMove
end

function AimFSM:CameraAimStart(ctX, ctY, ctZ)
    if self.targetDotween then
        self.targetDotween:Kill()
        self.targetDotween = nil
    end

    if not self.cameraTargetOrginPos then
        self.cameraTarget = self.clientTransformComponent:GetTransform("CameraTarget")
        self.cameraTargetOrginPos = self.cameraTarget.localPosition
    end
    
    self.cameraAimStart = true
    UnityUtils.SetLocalPosition(self.cameraTarget, ctX, ctY, ctZ)
    InputManager.Instance:SetCameraMouseInput(true)
end

function AimFSM:CameraAimEnd(time)
    if not self.cameraAimStart then
        return
    end

    if self.targetDotween then
        self.targetDotween:Kill()
        self.targetDotween = nil
    end

    self.cameraAimStart = false
    time = time or 0.2
    self.targetDotween = self.cameraTarget:DOLocalMove(self.cameraTargetOrginPos, time)
    CustomUnityUtils.SetAimTarget(self.transform, nil)  
    InputManager.Instance:SetCameraMouseInput(false)
end


function AimFSM:ShootMissile(missleMoveEntityId, transformName)
    missleMoveEntityId = missleMoveEntityId or self.aimConfig.NormalMissileId

    local missileMoveEntity = self.fight.entityManager:CreateEntity(missleMoveEntityId, self.entity) 
    local orginPos = self.clientTransformComponent:GetTransform(transformName or "Shoot").position
    local distPos = self.aimTargetTrans.position - orginPos
    local rotation = Quaternion.LookRotation(distPos)
    missileMoveEntity.transformComponent:SetPosition(orginPos.x, orginPos.y, orginPos.z)
    local luaRotation = Quat.New()
    luaRotation:CopyValue(rotation)
    missileMoveEntity.rotateComponent:SetRotation(luaRotation)

    return missileMoveEntity.instanceId
end

function AimFSM:UpdateMoveAnim(degree)
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
        self.animatorComponent:PlayAnimation(FightEnum.WalkDirAnim[moveDir], nil, self.walkLayer)
    end
end

function AimFSM:RemoveChargeEffect()
    if self.chargeEffect then
        self.fight.entityManager:RemoveEntity(self.chargeEffect.instanceId)
        self.chargeEffect = nil
    end  

    if self.chargeEndEffect then
        self.fight.entityManager:RemoveEntity(self.chargeEndEffect.instanceId)
        self.chargeEndEffect = nil
    end  
end

function AimFSM:AimStateEnd()
    if self.moveDir == FightEnum.Direction.None then
        self.entity.stateComponent:SetState(FightEnum.EntityState.FightIdle)
    else
        self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
    end
end

function AimFSM:UpdateSetAimUITarget()
    self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
    local imageType = FightEnum.AimImageType.None

    local hitList = CustomUnityUtils.GetScreenRayWorldHits(CameraManager.Instance.mainCameraComponent, 
        AimScreenW, AimScreenH, AimParam.AimMaxDistance, FightEnum.LayerBit.Entity)

    local instanceId, colliderInsId, entity
    if hitList and hitList.Length > 0 then
        for i = 0, hitList.Length - 1 do
            local gameObject = hitList[i].collider.gameObject
            local _entityInsId = tonumber(gameObject.name)
            local _colliderInsId = gameObject:GetInstanceID()
            entity = self.fight.entityManager:GetEntity(_entityInsId)
            if entity and entity.campComponent 
                and entity.campComponent.camp == FightEnum.EntityCamp.Camp2 and entity.partComponent then
                instanceId = _entityInsId
                colliderInsId = _colliderInsId
            end
        end
    end

    self.aimTarget = nil
    if instanceId then
        local entity = self.fight.entityManager:GetEntity(instanceId)
        if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Death) then
             EventMgr.Instance:Fire(EventName.SetAimImage, imageType)
            return
        end

        local part = entity.partComponent:GetPartByColliderInsId(colliderInsId)
        if part and part:IsWeakNess() then
            imageType = FightEnum.AimImageType.PartWeak 

            if self.weakPart and self.weakPart.entity.instanceId ~= instanceId then
                self.weakPart:DestroyWeakEffectEntity()
                self.weakPart = nil
            end

            self.weakPart = part
            self.weakPart:CreateWeakEffectEntity()
        else
            imageType = FightEnum.AimImageType.Part
        end
        self.aimTarget = entity
    end

    if imageType ~= FightEnum.AimImageType.PartWeak then
        if self.weakPart then
            self.weakPart:DestroyWeakEffectEntity()
            self.weakPart = nil
        end
    end

    EventMgr.Instance:Fire(EventName.SetAimImage, imageType)
    self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.Entity)
end

function AimFSM:SetLockTargetEnable(enable)
    self.lockTargetEnable = enable
end

function AimFSM:SetAimPartDecSpeed(isDecSpeed)
    self.aimPartDecSpeed = isDecSpeed
end

function AimFSM:CheckAimPartDecSpeed()
    if self.weakPart and self.aimPartDecSpeed then
        return true
    end

    return false
end

function AimFSM:UpdateLockTarget()
    if not self.lockTargetEnable then
        return
    end

    local entitySearch = self.fight.entityManager.entitySearch
    local lockTarget, partName, lockTransform, viewDistance, checkViewSize, distanceX, distanceY = entitySearch:SearchAimLockViewEntity(self.entity)
    if lockTarget then
        if not self.lockTarget or self.lockTarget.instanceId ~= lockTarget.instanceId or partName ~= self.lockTargetPartName then
            self.lockTarget = lockTarget
            self.lockTargetTransform = lockTransform
            self.lockTargetPartName = partName
        end
	else
		self.lockTarget = nil
		self.lockTargetTransform = nil
        self.lockTargetSpeedX = 0
        self.lockTargetSpeedY = 0
        self.lockTargetMoveX = 0
        self.lockTargetMoveY = 0
        self.lockTargetPartName = nil
    end

    if self.lockTargetTransform and self.cameraTarget then
        self.lockTargetSpeedX = AimLockTarget.MinSpeedX + (1 - distanceX / checkViewSize) * (AimLockTarget.MaxSpeedX - AimLockTarget.MinSpeedX)
        self.lockTargetSpeedY = AimLockTarget.MaxSpeedY + (1 - distanceY / checkViewSize) * (AimLockTarget.MaxSpeedY - AimLockTarget.MinSpeedY)
        self:RotateToLockTarget(self.lockTargetTransform, self.lockTargetSpeedX, self.lockTargetSpeedY)
    end
end

function AimFSM:RotateToLockTarget(targetTransform, speedX, speedY)
    local pos = Vec3.New(0,0,0)
    pos:SetA(targetTransform.position)

    local lookPos = pos - self.cameraTarget.position
    lookPos.y = 0
    local rotate = Quat.LookRotationA(lookPos.x, lookPos.y, lookPos.z)
    local y1 = self.entity.clientEntity.clientTransformComponent.eulerAngles.y
    if speedX then
        self.entity.transformComponent:SetRotation(Quat.RotateTowards(self.entity.transformComponent.rotation, rotate, speedX))
    else
        self.entity.transformComponent:SetRotation(rotate)
    end
    self.entity.clientEntity.clientTransformComponent:UpdateRotate(1)
    self.lockTargetMoveY = self.entity.clientEntity.clientTransformComponent.eulerAngles.y - y1

    local x1 = self.cameraTarget.localRotation.eulerAngles.x
    rotate = Quaternion.LookRotation(pos - self.cameraTarget.position)
    if speedY then
        rotate = Quat.RotateTowards(self.cameraTarget.rotation, rotate, speedY)
    end
    UnityUtils.SetRotation(self.cameraTarget, rotate.x, rotate.y, rotate.z, rotate.w)
    local el = self.cameraTarget.localRotation.eulerAngles
    UnityUtils.SetLocalEulerAngles(self.cameraTarget, el.x, 0, 0)   
    self.lockTargetMoveX = self.cameraTarget.eulerAngles.x - x1
end

function AimFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(AimFSM, self)
end

function AimFSM:__delete()

end




--