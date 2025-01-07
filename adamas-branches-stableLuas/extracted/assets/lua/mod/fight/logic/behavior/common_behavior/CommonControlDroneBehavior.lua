CommonControlDroneBehavior = BaseClass("CommonControlDroneBehavior", BehaviorBase)

local CollideCheckLayer = FightEnum.LayerBit.Default | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
local BuildData = Config.DataBuild.Find
local BF = BehaviorFunctions

local clamp = MathX.Clamp
local zeroInput = { x = 0, y = 0 }
local droneState = {
    idle = "Idle",
    stand = "Stand1",
    drive = "Stand2",
    forward = "Move1",
    after = "Move2",
    other = "Stand1",
}

local stateMagic = {
    idle = 0,
    stand = 200001021,
    forward = 200001022,
    after = 200001023,
    about = 200001024,
}

function CommonControlDroneBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonControlDroneBehavior:InitConfig(fight, entity, maxHeight, maxControlDistance, costElectricity, controlFrame, MaxHSpeed, hAcc, MaxVSpeed, vAcc, turnSpeed, downSpeed)
    self.fight = fight
    self.entity = entity
    self.tempOffset = Vec3.New()
    self.tempDir = Vec3.New()
    --self.flyCheckBox = Vec3.New()
    self.ignoreList = {}

    self.buttonInput = { x = 0, y = 0 }
    self.curHSpeed = { x = 0, y = 0 }
    self.curVSpeed = 0

    self.maxHeight = maxHeight
    self.maxControlDistance = maxControlDistance
    self.costElectricity = costElectricity
    self.initControlFrame = controlFrame
    self.controlFrame = controlFrame
    self.idle = true
    self.hadActive = false
    self.activeDelay = 0
    self.unActiveFrame = 0

    self.MaxHSpeed = (MaxHSpeed or 9) / 30
    self.hAcc = (hAcc or 1.2) / 30
    self.MaxVSpeed = (MaxVSpeed or 9) / 30
    self.vAcc = (vAcc or 1.2) / 30
    self.turnSpeed = (turnSpeed or 60) / 30

    self.downSpeed = (downSpeed or 1.5) / 30

    --for k, v in pairs(BuildData) do
    --    if self.entity.entityId == v.instance_id then
    --        self.flyCheckBox:Set(v.size.x / 2, v.size.y / 2, v.size.z / 2)
    --        break
    --    end
    --end

    self:SetDroneState(droneState.idle)

    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    EventMgr.Instance:AddListener(EventName.OnEnterStory, self:ToFunc("OnEnterStory"))
end

function CommonControlDroneBehavior:SetDroneParams(MaxHSpeed, hAcc, MaxVSpeed, vAcc, costElectricity)
    self.MaxHSpeed = (MaxHSpeed or 9) / 30
    self.hAcc = (hAcc or 1.2) / 30
    self.MaxVSpeed = (MaxVSpeed or 9) / 30
    self.vAcc = (vAcc or 1.2) / 30

    self.costElectricity = costElectricity
end

function CommonControlDroneBehavior:GetDroneParams()
    return self.MaxHSpeed, self.hAcc, self.MaxVSpeed, self.vAcc, self.costElectricity
end

function CommonControlDroneBehavior:WorldInteractClick(uniqueId, instanceId)
    if instanceId == self.entity.instanceId then
        --进入操控状态
        local driverInstanceId = BF.GetCtrlEntity()
        if BF.CheckEntityState(driverInstanceId, FightEnum.EntityState.Idle) or BF.CheckEntityState(driverInstanceId, FightEnum.EntityState.Move) then
            self:onDroneDrive(instanceId, driverInstanceId)
        else
            MsgBoxManager.Instance:ShowTips(TI18N("请站稳扶好"))
        end
    end
end

function CommonControlDroneBehavior:onDroneDrive(targetInstanceId, driverInstanceId)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    self.idle = false

    BF.EnterControlDroneMode(targetInstanceId)
    BF.SetCameraState(FightEnum.CameraState.Drone)
    --BF.SetMainTarget(self.entity.instanceId)
    --攻击模式相机
    local follow = self.entity.clientTransformComponent:GetTransform("CameraTarget")
    local lookAt = self.entity.clientTransformComponent:GetTransform("LookAt")
    CameraManager.Instance.statesMachine:SetFightTarget(follow, lookAt)

    ---打开操作UI
    InputManager.Instance:AddLayerCount("Drone")
    self.curDriveId = driverInstanceId
    self.driver = BF.GetEntity(self.curDriveId)
    Fight.Instance.entityManager:CallBehaviorFun("OnDriveDrone", self.entity.instanceId, self.curDriveId)

    if self.maxYPos == nil then
        self.maxYPos = self.entity.transformComponent.position.y + self.maxHeight
    end
    BF.SetBatteryVisible(true)
end

function CommonControlDroneBehavior:OnStopDrive(targetInstanceId)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    InputManager.Instance:MinusLayerCount("Drone")
    BF.SetCameraState(FightEnum.CameraState.Operating)
    --BF.SetMainTarget(self.curDriveId)
    Fight.Instance.entityManager:CallBehaviorFun("OnStopDriveDrone", self.entity.instanceId, self.curDriveId)
    self.curDriveId = nil
    self.driver = nil

    BF.RemoveBuff(self.entity.instanceId, 2000010251)
    BF.RemoveBuff(self.entity.instanceId, 2000010252)
    BF.RemoveBuff(self.entity.instanceId, 2000010253)

    BF.ExitControlDroneMode()
    BF.SetBatteryVisible(false)
end

function CommonControlDroneBehavior:Update()
    if self.activeDelay > 0 then
        self.activeDelay = self.activeDelay - 1
        if self.activeDelay == 0 then
            self.hadActive = true
        end
    end

    if not self.hadActive or (self.idle and self.unActiveFrame < 30) then
        self.unActiveFrame = self.unActiveFrame + 1
        return
    end
    self.unActiveFrame = 0

    if not self.entity.moveComponent then
        return
    end
    self.ignoreList = {}
    if self.driver and InputManager.Instance.actionMapName == "Drone" then
        self:SearchTarget()
        --消耗存在时间
        self.controlFrame = self.controlFrame - 1
        EventMgr.Instance:Fire(EventName.OnDroneCountDownUpdate, self.controlFrame, self.initControlFrame)
        --BF.DoMagic(1, self.entity.instanceId, 200001025)
        if self.controlFrame <= 0 then
            MsgBoxManager.Instance:ShowTips(TI18N("无人机摧毁，骇入中断！"))
            self:OnStopDrive(self.entity.instanceId)
            --Fight.Instance.buildingManager:OnBuildingTimeout(self.entity.instanceId)
            return
        elseif self.controlFrame == 300 then
            BF.DoMagic(1, self.entity.instanceId, 2000010251)
        elseif self.controlFrame == 180 then
            BF.DoMagic(1, self.entity.instanceId, 2000010252)
        elseif self.controlFrame == 90 then
            BF.DoMagic(1, self.entity.instanceId, 2000010253)
        end

        --计算距离，距离太远退出驾驶
        if BF.GetDistanceFromPos(self.entity.transformComponent.position, self.driver.transformComponent.position) > self.maxControlDistance then
            MsgBoxManager.Instance:ShowTips(TI18N("超出控制范围"))
            self:OnStopDrive(self.entity.instanceId)
            return
        end

        --耗电,电量不够则退出驾驶
        if not self:CostElectricity(self.costElectricity or 0) then
            MsgBoxManager.Instance:ShowTips(TI18N("电量不足"))
            self:OnStopDrive(self.entity.instanceId)
            return
        end
        self:DoMove()
    else
        self:DoDown()
    end
end

function CommonControlDroneBehavior:GetInput()
    local moveInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Move) or zeroInput
    local flyInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Fly) or zeroInput
    local rotationInput = { x = 0, y = FightMainUIView.bgInput.y }
    if flyInput.x == 0 and flyInput.y == 0 then
        flyInput = self.buttonInput
    end

    if flyInput.x ~= 0 then
        rotationInput.x = flyInput.x
    end
    if flyInput.x ~= 0 then
        flyInput.x = flyInput.x > 0 and 1 or -1
    end
    if flyInput.y ~= 0 then
        flyInput.y = flyInput.y > 0 and 1 or -1
    end
    if rotationInput.x ~= 0 then
        rotationInput.x = rotationInput.x > 0 and 1 or -1
    end
    if rotationInput.y ~= 0 then
        rotationInput.y = rotationInput.y > 0 and 1 or -1
    end
    return moveInput, flyInput, rotationInput
end

function CommonControlDroneBehavior:CostElectricity(costCount)
    return BehaviorFunctions.CostPlayerElectricity(costCount)
end

function CommonControlDroneBehavior:ClickControlDroneUp(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
    self.buttonInput.y = down and 1 or 0
end

function CommonControlDroneBehavior:ClickControlDroneDown(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
    self.buttonInput.y = down and -1 or 0
end

function CommonControlDroneBehavior:ClickControlDroneLeft(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
    self.buttonInput.x = down and -1 or 0
end

function CommonControlDroneBehavior:ClickControlDroneRight(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
    self.buttonInput.x = down and 1 or 0
end

function CommonControlDroneBehavior:SetDroneState(newState)
    if newState == self.droneState then
        return
    end
    self.droneState = newState
    BF.PlayAnimation(self.entity.instanceId, self.droneState) --播放动画
end

function CommonControlDroneBehavior:SetMagicState(newState)
    if newState == self.magicState then
        return
    end
    BF.RemoveBuff(self.entity.instanceId, self.magicState)
    self.magicState = newState
    if newState ~= stateMagic.idle then
        BF.DoMagic(1, self.entity.instanceId, newState)
    end
end

function CommonControlDroneBehavior:EnterTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    if playerId == BF.GetCtrlEntity() then
        self.onPlayerFollow = true
        if self.droneState == droneState.stand then
            self:SetDroneState(droneState.drive)
        end
    end
end

function CommonControlDroneBehavior:ExitTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    if playerId == BF.GetCtrlEntity() then
        self.onPlayerFollow = false
    end
end

function CommonControlDroneBehavior:SetEnable(isEnable)
    self.enable = isEnable
end

function CommonControlDroneBehavior:OnCache()
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    EventMgr.Instance:RemoveListener(EventName.OnEnterStory, self:ToFunc("OnEnterStory"))
end

function CommonControlDroneBehavior:OnRemoveEntity(instanceId)
    if self.curDriveId and instanceId == self.entity.instanceId then
        self:OnStopDrive(instanceId)
    end
end

function CommonControlDroneBehavior:OnEnterStory()
    if self.curDriveId then
        self:OnStopDrive(self.entity.instanceId)
    end
end

function CommonControlDroneBehavior:DoMove()
    if self.entity.jointComponent.isRecordDirty then
        self.entity.jointComponent:GetBluePrint()
    end

    --归一化输入
    local moveInput, flyInput, rotationInput = self:GetInput()
    --更新水平速度
    if moveInput.x ~= 0 then
        self.curHSpeed.x = self.curHSpeed.x + moveInput.x * self.hAcc
        self.curHSpeed.x = clamp(self.curHSpeed.x, -self.MaxHSpeed, self.MaxHSpeed)
    else
        --阻尼
        self.curHSpeed.x = self.curHSpeed.x * 0.9
        if math.abs(self.curHSpeed.x) < self.MaxHSpeed * 0.1 then
            self.curHSpeed.x = 0
        end
    end
    if moveInput.y > 0 then
        self:SetDroneState(droneState.forward)
        self:SetMagicState(stateMagic.forward)
    elseif moveInput.y < 0 then
        self:SetDroneState(droneState.after)
        self:SetMagicState(stateMagic.after)
    else
        if moveInput.x == 0 then
            self:SetMagicState(stateMagic.stand)
        else
            self:SetMagicState(stateMagic.about)
        end
        self:SetDroneState(self.onPlayerFollow and droneState.drive or droneState.stand)
    end

    if moveInput.y ~= 0 then
        self.curHSpeed.y = self.curHSpeed.y + moveInput.y * self.vAcc
        self.curHSpeed.y = clamp(self.curHSpeed.y, -self.MaxVSpeed, self.MaxVSpeed)
    else
        --阻尼
        self.curHSpeed.y = self.curHSpeed.y * 0.9
        if math.abs(self.curHSpeed.y) < self.MaxVSpeed * 0.1 then
            self.curHSpeed.y = 0
        end
    end

    --更新垂直速度
    self.curVSpeed = flyInput.y
    --更新方向
    self.tempOffset:Set(self.curHSpeed.x, self.curVSpeed * 0.2, self.curHSpeed.y)
    local move = self.entity.transformComponent.rotation * self.tempOffset
    move.y = self.curVSpeed * 0.2
    self.tempDir:SetA(move)
    self.tempDir:SetNormalize()

    ---检测新的位置是否会发生碰撞
    local pos = self.entity.transformComponent.position:Clone()
    pos:AddXYZ(move.x, flyInput.y * 0.2, move.z)

    ---------------------------------------------------------------------------------
    ---计算倾斜
    local eulerAngles = self.entity.transformComponent.rotation:ToEulerAngles()
    local eulerX = eulerAngles.x < 90 and eulerAngles.x or eulerAngles.x - 360
    local eulerZ = eulerAngles.z < 90 and eulerAngles.z or eulerAngles.z - 360
    local offsetX, offsetZ = moveInput.y, -moveInput.x

    ---自动回正
    if offsetX == 0 then
        if eulerX > 0 then
            offsetX = eulerX < 1 and -eulerX or -1
        elseif eulerX < 0 then
            offsetX = eulerX > -1 and -eulerX or 1
        end
    end

    if offsetZ == 0 then
        if eulerZ > 0 then
            offsetZ = eulerZ < 1 and -eulerZ or -1
        elseif eulerZ < 0 then
            offsetZ = eulerZ > -1 and -eulerZ or 1
        end
    end

    if (eulerZ > 3 and offsetZ > 0) or (eulerZ < -3 and offsetZ < 0) then
        offsetZ = 0
    end
    rotationInput.y = -rotationInput.y
    if (eulerX > 20 and rotationInput.y > 0) or (eulerX < -10 and rotationInput.y < 0) then
        rotationInput.y = 0
    end

    --TODO 暂时不支持拼接其他实体
    self.ignoreList = {}
    table.insert(self.ignoreList, self.curDriveId)

    local _offsetX = rotationInput.y * 0.5
    local _offsetY = rotationInput.x * self.turnSpeed * 0.5
    local _offsetZ = offsetZ * 0.5
    --local oldEulerAngles = self.entity.transformComponent.rotation:ToEulerAngles()
    --self.transformComponent.rotation:SetEuler(oldEulerAngles.x + _offsetX, oldEulerAngles.y + _offsetY, oldEulerAngles.z + _offsetZ)
    --local newRotate = Quat.Euler(oldEulerAngles.x + _offsetX, oldEulerAngles.y + _offsetY, oldEulerAngles.z + _offsetZ)
    if not BF.CheckEntityCollideAtPositionAndRotation(self.entity.entityId, pos.x, pos.y, pos.z, _offsetX, _offsetY, _offsetZ, self.ignoreList, self.entity.instanceId, false) then
        return
    end
    ---避免侧向移动时下降
    self.entity.moveComponent:SetPositionOffset(move.x, 0, move.z)

    --高度限制
    if self.entity.transformComponent.position.y < self.maxYPos or flyInput.y < 0 then
        self.entity.moveComponent:SetPositionOffset(0, flyInput.y * 0.2, 0)
    end

    self.entity.rotateComponent:DoRotate(_offsetX, _offsetY, _offsetZ)
end

function CommonControlDroneBehavior:DoDown()
    --无人驾驶时，缓慢下降
    self.tempOffset:Set(0, -self.downSpeed, 0)
    local move = self.entity.transformComponent.rotation * self.tempOffset
    move.y = -self.downSpeed
    local length = move:Magnitude()
    self.tempDir:SetA(move)
    self.tempDir:SetNormalize()
    local pos = TableUtils.CopyTable(self.entity.transformComponent.position)
    if not BF.CheckEntityCollideAtPosition(self.entity.entityId, pos.x, pos.y - self.downSpeed, pos.z, self.ignoreList, self.entity.instanceId, false) then
        self.idle = true
        self:SetDroneState(droneState.idle)
        self:SetMagicState(stateMagic.idle)
        return
    end
    local eulerAngles = self.entity.transformComponent.rotation:ToEulerAngles()
    local eulerX = eulerAngles.x < 90 and eulerAngles.x or eulerAngles.x - 360
    local eulerZ = eulerAngles.z < 90 and eulerAngles.z or eulerAngles.z - 360
    local offsetX, offsetZ = 0,0
    if eulerX > 0 then
        offsetX = eulerX < 1 and -eulerX or -1
    elseif eulerX < 0 then
        offsetX = eulerX > -1 and -eulerX or 1
    end
    if eulerZ > 0 then
        offsetZ = eulerZ < 1 and -eulerZ or -1
    elseif eulerZ < 0 then
        offsetZ = eulerZ > -1 and -eulerZ or 1
    end
    if (eulerZ > 3 and offsetZ > 0) or (eulerZ < -3 and offsetZ < 0) then
        offsetZ = 0
    end

    self.idle = false
    self:SetMagicState(stateMagic.stand)
    self:SetDroneState(self.onPlayerFollow and droneState.drive or droneState.stand)
    self.entity.moveComponent:SetPositionOffset(0, -self.downSpeed, 0)
    self.entity.rotateComponent:DoRotate(offsetX * 0.5, 0, offsetZ * 0.5)
end

function CommonControlDroneBehavior:OnPartnerBuildSuccess(instanceId)
    if instanceId == self.instanceId then
        self.activeDelay = 45
    end
end

-------------------------
---PV临时功能，自动索敌
local lockDistance = 165 * 165
local AimState = {
    None = 1,
    Aiming = 2,
    Locked = 3
}
function CommonControlDroneBehavior:SearchTarget()
    --检查锁定是否丢失
     if self.curAttackTarget then
        if BF.CheckEntity(self.curAttackTarget) and BF.GetEntityState(self.curAttackTarget) ~= FightEnum.EntityState.Die then
            local target = BF.GetEntity(self.curAttackTarget)
            local transform = target.clientTransformComponent:GetTransform("HitCase")
            local uiPos = UtilsBase.WorldToUIPointBase(transform.position.x, transform.position.y, transform.position.z)
            local distance = uiPos.x * uiPos.x +  uiPos.y * uiPos.y
            if uiPos.z > 0 and distance <= lockDistance then
                return
            end
        end
        self.curAttackTarget = nil
    end

    self.targets = BF.SearchEntityOnScreen(self.curDriveId, FightEnum.EntityCamp.Camp2, 70, { FightEnum.EntityNpcTag.Monster, FightEnum.EntityNpcTag.Boss })
    for k, v in pairs(self.targets) do
        if v.instanceId and v.distance < lockDistance then
            if BF.CheckEntity(v.instanceId) and BF.GetEntityState(v.instanceId) ~= FightEnum.EntityState.Die then
                self.curAttackTarget = v.instanceId
                --给UI设置锁定目标
                EventMgr.Instance:Fire(EventName.SetDroneAimTarget, v.instanceId)
                return
            end
        end
    end

    --未能设置目标，炮停止攻击
    self.aimState = AimState.None
    EventMgr.Instance:Fire(EventName.SetDroneAimTarget, nil)
end