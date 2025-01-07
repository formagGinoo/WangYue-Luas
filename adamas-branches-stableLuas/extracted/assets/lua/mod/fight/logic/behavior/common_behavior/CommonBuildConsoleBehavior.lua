CommonBuildConsoleBehavior = BaseClass("CommonBuildConsoleBehavior", BehaviorBase)

local BF = BehaviorFunctions
local zeroInput = { x = 0, y = 0 }
local needFixedAngle = 3
local WaterCheckInterval = 10
local ControlType = {
    Water = 1,
    Ground = 2,
    Air = 3
}
function CommonBuildConsoleBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonBuildConsoleBehavior:InitConfig(fight, entity, axisXMaxAngle, axisXSpeed, axisYSpeed, axisZMaxAngle, axisZMaxSpeed, WaterAxisYSpeed)
    self.fight = fight
    self.entity = entity
    self.isActive = false
    self.axisXMaxAngle = axisXMaxAngle
    self.axisXSpeed = axisXSpeed
    self.axisYSpeed = axisYSpeed
    self.axisZMaxAngle = axisZMaxAngle
    self.axisZMaxSpeed = axisZMaxSpeed
    self.WaterAxisYSpeed = WaterAxisYSpeed
    self.entityTransform = self.entity.clientTransformComponent.transform
    self.notWaterCheckFrame = WaterCheckInterval
    self.controlType = ControlType.Ground
    self.isQiDongOther = false
    EventMgr.Instance:AddListener(EventName.BuildConsoleActive, self:ToFunc("OnBuildConsoleActive"))
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
end

function CommonBuildConsoleBehavior:Update()
    if not self.isActive then
        return
    end
    local euler = self:GetSelfEuler()
    if euler.x >= 50 or euler.z >= 50 then
        MsgBoxManager.Instance:ShowTips(TI18N("角度过大，翻车了"))
        EventMgr.Instance:Fire(EventName.BuildConsoleOffLimit, self.entity.instanceId)
        self:OnUnActive()
        return
    end
    ----水面检测逻辑,从上往下打一条只和水面碰撞的射线，如果距离小于2，就认为在开船
    self:ControlTypeCheck()

    if self.controlType == ControlType.Water then
        self:UpdateOnWater()
    elseif self.controlType == ControlType.Ground then
        self:UpdateOnGround()
    else
        self:UpdateOnAir()
    end
end

function CommonBuildConsoleBehavior:WorldInteractClick(uniqueId, instanceId)
    if instanceId == self.entity.instanceId then
        if #self.entity.jointComponent.childIdList == 0 and #self.entity.jointComponent.parentIdList == 0 then
            MsgBoxManager.Instance:ShowTips(TI18N("不能单独启动"))
            return
        end
        --变身状态不能开飞机
        local role = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
        if BF.HasEntitySign(role,600000012) then
            return
        end
        if not self.isActive then
            self:OnActive()
            self.entity.jointComponent:CallFunctionAtAll("SetActive", { isActive = true }, nil)
        end
    end
end

function CommonBuildConsoleBehavior:OnQuitBuildConsolePanel(instanceId)
    if instanceId == self.entity.instanceId then
        if self.isActive then
            self:OnUnActive()
            self.entity.jointComponent:CallFunctionAtAll("SetActive", { isActive = false }, nil)
        end
    end
end

local maxSpeed = 7
function CommonBuildConsoleBehavior:OnActive()
    if self.isActive then
        return
    end

    --检查角度
    local euler = self:GetSelfEuler()

    if euler.x >= self.axisXMaxAngle or euler.z >= self.axisXMaxAngle then
        --倾覆状态，无法操控
        return
    end
    self.isActive = true
    self.isQiDongOther = true
    if not self.buildConsoleRotationCmp then
        self.entity.clientTransformComponent.gameObject:AddComponent(BuildConsoleRotation)
        self.buildConsoleRotationCmp = self.entity.clientTransformComponent.gameObject:GetComponent(BuildConsoleRotation)
    end

    --进入操控状态，设置玩家
    local ctrlRole = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    ctrlRole.clientTransformComponent:SetLuaControlEntityMove(false)
    --TODO 先加上浮空buff，等Kcc接入后去掉
    ctrlRole.buffComponent:AddState(FightEnum.EntityBuffState.Levitation)
    local point =self.entity.clientTransformComponent:GetTransform("RolePosition")
    ctrlRole.clientTransformComponent.transform:SetParent(point)
    ctrlRole.partComponent:SetCollisionEnable(false)
    ctrlRole.collistionComponent:SetCollisionEnable(false)
    UnityUtils.SetLocalPosition(ctrlRole.clientTransformComponent.transform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(ctrlRole.clientTransformComponent.transform, 0, 0, 0)

    self.entity.clientTransformComponent.rigidbody.maxLinearVelocity = maxSpeed

    Fight.Instance.clientFight.buildManager:OpenBuildConsolePanel(self.entity.instanceId)
    BehaviorFunctions.DoSetEntityState(ctrlRole.instanceId, FightEnum.EntityState.Build)
    ctrlRole.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildConsole)
end

function CommonBuildConsoleBehavior:OnUnActive()
    if not self.isActive then
        return
    end
    self.isActive = false
    self.isQiDongOther = false
    local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
    local ctrlRole = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    ctrlRole.clientTransformComponent:SetLuaControlEntityMove(true)
    ctrlRole.buffComponent:RemoveState(FightEnum.EntityBuffState.Levitation)
    ctrlRole.clientTransformComponent.transform:SetParent(entityRoot)
    local pos = ctrlRole.clientTransformComponent.transform.position
    ctrlRole.transformComponent:SetPosition(pos.x, pos.y, pos.z)
    ctrlRole.partComponent:SetCollisionEnable(true)
    self.buildConsoleRotationCmp:SetConsoleActive(false)
    local q = ctrlRole.transformComponent:GetRotation()
    local e = q:ToEulerAngles()
    q:SetEuler(0, e.y, 0)
    ctrlRole.transformComponent:SetRotation(q)
    ctrlRole.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildEnd)
    self.entity.clientTransformComponent.rigidbody.maxLinearVelocity = 20
end

function CommonBuildConsoleBehavior:GetInput()
    local moveInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Move) or zeroInput
    return moveInput
end
function CommonBuildConsoleBehavior:GetSelfEuler()
    local euler = self.entityTransform.localRotation.eulerAngles
    if euler.x > 180 then
        euler.x = euler.x - 360
    end
    if euler.y > 180 then
        euler.y = euler.y - 360
    end
    if euler.z > 180 then
        euler.z = euler.z - 360
    end
    return euler
end

function CommonBuildConsoleBehavior:ControlTypeCheck()
    self.notWaterCheckFrame = self.notWaterCheckFrame + 1
    if self.notWaterCheckFrame < WaterCheckInterval then
        return
    end
    self.lastWaterCheckFrame = 0
    local pos = self.entity.transformComponent.position
    local height, haveGround, checkLayer = UnityUtils.GetTerrainHeight(pos.x, pos.y + 0.5, pos.z, FightEnum.LayerBit.Water | FightEnum.LayerBit.Default)
    if height < 2 and haveGround then
        if checkLayer == FightEnum.Layer.Water then
            self.controlType = ControlType.Water
        else
            self.controlType = ControlType.Ground
        end
    else
        self.controlType = ControlType.Air
    end
end

function CommonBuildConsoleBehavior:GetAngleSpeed()
    local input = self:GetInput()
    local euler = self:GetSelfEuler()
    local angleSpeedX, angleSpeedY, angleSpeedZ = 0, 0, 0
    if input.x == 0 and input.y == 0 then
        --未操控，自动回正
        if euler.x >= needFixedAngle then
            angleSpeedX = -self.axisXSpeed
        elseif euler.x <= -needFixedAngle then
            angleSpeedX = self.axisXSpeed
        end
        if euler.z >= needFixedAngle then
            angleSpeedZ = -self.axisZMaxSpeed
        elseif euler.z <= -needFixedAngle then
            angleSpeedZ = self.axisZMaxSpeed
        end
    else
        angleSpeedY = self.axisYSpeed * input.x
        angleSpeedX = self.axisXSpeed * input.y
        if euler.x >= self.axisXMaxAngle or euler.x <= -self.axisXMaxAngle then
            angleSpeedX = 0
        end

        if angleSpeedY < 0 and euler.z < self.axisZMaxAngle then
            angleSpeedZ = self.axisZMaxSpeed
        elseif angleSpeedY > 0 and euler.z > -self.axisZMaxAngle then
            angleSpeedZ = -self.axisZMaxSpeed
        end
    end
    return angleSpeedX, angleSpeedY, angleSpeedZ
end

--y:     1    |    W
--x: -1     1 | A     D
--y:    -1    |    S
function CommonBuildConsoleBehavior:UpdateOnAir()
    if not self.buildConsoleRotationCmp then
        return
    end
    if not self.buildConsoleRotationCmp.m_IsActive then
        self.buildConsoleRotationCmp:SetConsoleActive(true)
    end
    local angleSpeedX, angleSpeedY, angleSpeedZ = self:GetAngleSpeed()
    local euler = self:GetSelfEuler()
    if angleSpeedX ~= 0 or angleSpeedY ~= 0 or angleSpeedZ ~= 0 then
        local selfEuler_x = euler.x + angleSpeedX
        local selfEuler_y = euler.y + angleSpeedY
        local selfEuler_z = euler.z + angleSpeedZ
        self.buildConsoleRotationCmp:SetEulerAngleVelocity(selfEuler_x, selfEuler_y, selfEuler_z)
    end
end

function CommonBuildConsoleBehavior:UpdateOnWater()
    if not self.buildConsoleRotationCmp then
        return
    end
    if not self.buildConsoleRotationCmp.m_IsActive then
        self.buildConsoleRotationCmp:SetConsoleActive(true)
    end
    local angleSpeedX, angleSpeedY, angleSpeedZ = self:GetAngleSpeed()
    local euler = self:GetSelfEuler()
    if angleSpeedX ~= 0 or angleSpeedY ~= 0 or angleSpeedZ ~= 0 then
        local selfEuler_y = euler.y + angleSpeedY
        self.buildConsoleRotationCmp:SetEulerAngleVelocity(0, selfEuler_y, 0)
    end
end

function CommonBuildConsoleBehavior:UpdateOnGround()
    if self.buildConsoleRotationCmp.m_IsActive then
        self.buildConsoleRotationCmp:SetConsoleActive(false)
    end
end

function CommonBuildConsoleBehavior:OnBuildConsoleActive(instanceId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    if not self.isActive then
        return
    end
    self.isQiDongOther = not self.isQiDongOther
    if self.entity and self.entity.jointComponent then
        self.entity.jointComponent:CallFunctionAtAll("SetActive", { isActive = self.isQiDongOther }, nil)
    end
end

function CommonBuildConsoleBehavior:OnRemoveEntity(instanceId)
    if instanceId == self.entity.instanceId and self.isActive then
        EventMgr.Instance:Fire(EventName.BuildConsoleOffLimit, self.entity.instanceId)
        self:OnUnActive()
        EventMgr.Instance:RemoveListener(EventName.BuildConsoleActive, self:ToFunc("OnBuildConsoleActive"))
    end
end