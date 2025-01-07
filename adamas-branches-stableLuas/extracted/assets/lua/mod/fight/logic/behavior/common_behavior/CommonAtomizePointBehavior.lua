CommonAtomizePointBehavior = BaseClass("CommonAtomizePointBehavior", BehaviorBase)
--[[
AtomizePoint = {
    ecoId = 0
    locationType = FightEnum.AtomizePointLocationType
    interactType = FightEnum.AtomizePointInteractType
    OutOffsetY = 0
}
AtomizePointGroup = AtomizePoint[]

]]--

local ShuttleEffectFrame = 100
local AtomizeState = {
    idle = 1,
    In = 2,
    shuttle = 3,
    Observe = 4,
    Out = 5,
}

local modelType = {
    [2040901] = 1, --竖管
    [2040902] = 1, --竖管
    [2040903] = 2, --横管
    [2040904] = 2, --横管
}

local Math = MathX
local clamp = Math.Clamp

function CommonAtomizePointBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonAtomizePointBehavior:InitConfig(fight, entity, AtomizePointType, InteractType, HorizontalAxisRange, VerticalAxisRange, FlyFrame, InFrame, OutFrame, OnInChangeCameraFrame, CameraMoveSpeed, lightMoveSpeed_NoTimeLine, lightMoveSpeed_TimeLine)
    self.fight = fight
    self.entity = entity
    self.outPoints = {}
    self.inPoints = {}
    self.AtomizePointLocationType = AtomizePointType
    self.InteractType = InteractType or 0
    self.targetEntity = nil
    self.state = AtomizeState.idle
    self.horizontalAxisRange = HorizontalAxisRange and HorizontalAxisRange or 180
    self.verticalAxisRange = VerticalAxisRange and VerticalAxisRange or 90

    self.onCameraMove = false
    self.cameraMoveFrame = 0
    self.cameraMoveTotalFrame = 0
    self.onBeUse = false

    --移动帧数
    self.FlyFrame = FlyFrame or 10
    --室外穿梭帧数
    self.InFrame_NoTimeLine = InFrame or 10
    --室内穿梭帧数
    self.InFrame_TimeLine= 8
    --室外穿梭相机切换开始帧数
    self.OnInChangeCameraFrame = OnInChangeCameraFrame or 7
    --镜头移动速度
    self.CameraMoveSpeed = CameraMoveSpeed or 1
    --室外结束后光球移动速度
    self.lightMoveSpeed_NoTimeLine = lightMoveSpeed_NoTimeLine or 1
    --室内结束光球移动速度
    self.lightMoveSpeed_TimeLine = lightMoveSpeed_TimeLine or 1
end

local OutFrame = 6
function CommonAtomizePointBehavior:Update()
    if self.state == AtomizeState.In then
        --进入状态，光球飞入烟囱
        if self.lightEntity then
            local pos = self:BezierCurve(self.startPos, self.cp1, self.cp2, self.endPos, 1 - math.sqrt(clamp(1 - self.frame / self.FlyFrame, 0, 1)))
            self.lightEntity.transformComponent.lastPosition:SetA(self.lightEntity.transformComponent.position)
            self.lightEntity.transformComponent.position:Set(pos.x, pos.y, pos.z)
        end
        self.frame = self.frame + 1

        if not self.notPlayTimeline and self.frame == self.OnInChangeCameraFrame then
            CameraManager.Instance.statesMachine:SetWatchCameraDistance(1)
            local InTarget = self.entity.clientTransformComponent:GetTransform("InTarget")
            CameraManager.Instance.statesMachine:SetMainTarget(InTarget)
        end
        if self.frame == self.InFrame then
            self:DoShuttle()
            self:SetState(AtomizeState.shuttle)
        end
    elseif self.state == AtomizeState.shuttle then
        if not self.notPlayTimeline and self.frame == 2 then
            self.cinemachineCamera.m_Priority = 100
            CameraManager.Instance:SetCullingMask(1 << 7)
        end
        self.frame = self.frame + 1
        if self.frame == self.shuttleFrame then
            self:CompleteShuttle()
        end
    elseif self.state == AtomizeState.Out then
        self.frame = self.frame + 1
        if self.lightEntity then
            local pos = self:BezierCurve(self.startPos, self.cp1, self.cp2, self.endPos, 1 - math.sqrt(clamp(1 - self.frame / OutFrame, 0, 1)))
            self.lightEntity.transformComponent.lastPosition:SetA(self.lightEntity.transformComponent.position)
            self.lightEntity.transformComponent.position:Set(pos.x, pos.y, pos.z)
        end
        if self.frame == OutFrame then
            self:CompleteOut()
            self:SetState(AtomizeState.idle)
        end
    end

    if self.notPlayTimeline and self.onCameraMove then
        self.cameraMoveFrame = self.cameraMoveFrame + 1
        self:SetMoveCameraPosByLerp(self.shuttleStartPos, self.shuttleEndPos, self.cameraMoveFrame, self.cameraMoveTotalFrame)
        if self.cameraMoveFrame == self.cameraMoveTotalFrame then
            self.onCameraMove = false
            CameraManager.Instance.statesMachine:ClearAtomizeMovePosition()
        end
    end
end

function CommonAtomizePointBehavior:SetAtomizePointInteractType(InteractType)
    if InteractType and InteractType ~= 0 then
        self.InteractType = InteractType
    end
end

function CommonAtomizePointBehavior:SetAtomizePointConfig(config, allConfig)
    self.config = config
    TableUtils.ClearTable(self.outPoints)
    TableUtils.ClearTable(self.inPoints)

    for i, v in pairs(allConfig) do
        if v.instanceId ~= self.config.instanceId then
            local point = BehaviorFunctions.GetEntity(v.instanceId)
            if point then
                local interactType = point.commonBehaviorComponent:GetBehaviorByName("CommonAtomizePointBehavior").InteractType
                if interactType == FightEnum.AtomizePointInteractType.Both then
                    table.insert(self.outPoints, v)
                    table.insert(self.inPoints, v)
                elseif interactType == FightEnum.AtomizePointInteractType.In then
                    table.insert(self.inPoints, v)
                elseif interactType == FightEnum.AtomizePointInteractType.Out then
                    table.insert(self.outPoints, v)
                end
            end
        end
    end
end

--点击交互按钮，进入雾化状态，播timeline和特效，准备切镜头
function CommonAtomizePointBehavior:DoBehaviorCrossSpace(instanceId)
    if self.onBeUse then
        return
    end
    if instanceId == self.entity.instanceId then
        self.endTarget = self:RandomEndTarget()
        self.targetEntity = BehaviorFunctions.GetEntity(self.endTarget.instanceId)
        if not self.endTarget then
            return
        end
        self.onBeUse = true
        local endTargetLocationType = self.targetEntity.commonBehaviorComponent:GetBehaviorByName("CommonAtomizePointBehavior"):GetLocationType()
        self.notPlayTimeline = self.AtomizePointLocationType == FightEnum.AtomizePointLocationType.OutDoor and endTargetLocationType == FightEnum.AtomizePointLocationType.OutDoor

        self.atomizeEntityId = BehaviorFunctions.GetCtrlEntity()
        self.atomizeEntity = BehaviorFunctions.GetEntity(self.atomizeEntityId)

        InputManager.Instance:AddLayerCount("Drone")
        self:OpenAtomizeUI(self.entity.instanceId)
        --玩家变成光并隐藏/同时设置状态机为idle
        BehaviorFunctions.DoSetEntityState(self.atomizeEntityId, FightEnum.EntityState.Idle)
        BehaviorFunctions.DoMagic(1, self.atomizeEntityId, 600000029)
        --创建光球
        local initPos = self.atomizeEntity.transformComponent.position
        local lightEntityId = BehaviorFunctions.CreateEntity(600000010, self.entity.instanceId, initPos.x, initPos.y + 1, initPos.z, 0, 0, 0)
        self.lightEntity = BehaviorFunctions.GetEntity(lightEntityId)

        local InTarget = self.entity.clientTransformComponent:GetTransform("InTarget")
        local InPoint = self.entity.clientTransformComponent:GetTransform("InPoint")
        local endPos = InTarget.position
        local forward = self.entity.transformComponent.rotation

        --烟囱播进入特效
        BehaviorFunctions.DoMagic(1, self.entity.instanceId, 200000902)

        self:InitBezierCurveParam(self.lightEntity.transformComponent.position, endPos, forward)
        self:SetState(AtomizeState.In)

        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Atomize)
        --室外穿梭
        local cameraTarget = self.entity.clientTransformComponent:GetTransform("CameraTarget")
        --CameraManager.Instance.statesMachine:SetMainTarget(cameraTarget)
        CameraManager.Instance.statesMachine:SetMainTarget(InPoint)
        CameraManager.Instance.statesMachine:ChangeToWatch()
        --修改相机朝向,横管时从CameraTarget看向，竖管时两点连线
        self.notPlayTimelineYaw = 0
        if self.notPlayTimeline then
            if modelType[self.entity.entityId] == 1 then
                local v1 = cameraTarget.position - self.targetEntity.clientTransformComponent:GetTransform("CameraTarget").position
                local q = Quat.LookRotationA(v1.x, v1.y, v1.z)
                self.notPlayTimelineYaw = q:ToEulerAngles().y
                CameraManager.Instance.statesMachine:SetMoveCameraYaw(self.notPlayTimelineYaw)
            else
                local v2 = endPos - cameraTarget.position
                local q = Quat.LookRotationA(v2.x, v2.y, v2.z)
                self.notPlayTimelineYaw = q:ToEulerAngles().y
				CameraManager.Instance.statesMachine:SetMoveCameraYaw(self.notPlayTimelineYaw)
            end
            CameraManager.Instance.statesMachine:SetWatchCameraRotation(0, self.notPlayTimelineYaw, 0)
            self.InFrame = self.InFrame_NoTimeLine
        else
            if modelType[self.entity.entityId] == 1 then
                local v2 = cameraTarget.position - self.atomizeEntity.transformComponent.position
                local q = Quat.LookRotationA(v2.x, v2.y, v2.z)
                self.notPlayTimelineYaw = q:ToEulerAngles().y
                CameraManager.Instance.statesMachine:SetWatchCameraRotation(90, self.notPlayTimelineYaw, 0)
            else
                local v2 = endPos - cameraTarget.position
                local q = Quat.LookRotationA(v2.x, v2.y, v2.z)
                self.notPlayTimelineYaw = q:ToEulerAngles().y
                CameraManager.Instance.statesMachine:SetWatchCameraRotation(0, self.notPlayTimelineYaw, 0)
            end
            self.InFrame = self.InFrame_TimeLine
        end
    end
end

function CommonAtomizePointBehavior:DoShuttle()
    BehaviorFunctions.RemoveEntity(self.lightEntity.instanceId)
    self.lightEntity = nil

    BehaviorFunctions.DoMagic(1, self.atomizeEntityId, 1000048, 1)
    local pos1 = self.entity.clientTransformComponent:GetTransform("InPoint").position
    if self.notPlayTimeline then
        --室外穿梭
        --用较低的点的XZ坐标和较高点的Y坐标，合成成中继点


        local pos2 = self.entity.clientTransformComponent:GetTransform("CameraTarget").position
        local pos3 = self.targetEntity.clientTransformComponent:GetTransform("InPoint").position
        local pos4 = self.targetEntity.clientTransformComponent:GetTransform("CameraTarget").position
        local StartPos = Vec3.New(0, 0, 0)
        local EndPos = Vec3.New(0, 0, 0)
        if pos1.y < pos3.y then
            StartPos:Set(pos2.x, pos2.y, pos2.z)
            EndPos:Set(pos2.x, pos4.y, pos2.z)
        else
            StartPos:Set(pos4.x, pos1.y, pos4.z)
            EndPos:Set(pos4.x, pos4.y, pos4.z)
        end
        --计算距离,设置过渡事件和帧数
        local distance = math.abs(pos2.y - pos4.y)
        self.cameraMoveTotalFrame = math.ceil(distance / self.CameraMoveSpeed)
        self.cameraMoveFrame = 0
        self.shuttleFrame = math.ceil(math.abs(pos3.y - pos2.y)/ self.lightMoveSpeed_NoTimeLine)
        self.onCameraMove = true

        OutFrame = math.ceil(self.cameraMoveTotalFrame - self.shuttleFrame > 0 and self.cameraMoveTotalFrame - self.shuttleFrame or 1)
        CameraManager.Instance.statesMachine:ChangeToMove()
        self.shuttleStartPos = StartPos
        self.shuttleEndPos = EndPos
    else
        --情况二 某一方为室内，需要切UI，播过渡
        if modelType[self.targetEntity.entityId] == 1 then
            CameraManager.Instance.statesMachine:SetIntoCameraDistance(5)
        else
            CameraManager.Instance.statesMachine:SetIntoCameraDistance(0.1)
        end
        self.ShuttleEffectId = BehaviorFunctions.CreateEntity(600000016, nil, pos1.x, pos1.y, pos1.z)
        local ShuttleEffect = BehaviorFunctions.GetEntity(self.ShuttleEffectId)
        local ShuttleEffectCamera =  ShuttleEffect.clientTransformComponent:GetTransform("Camera")
        self.cinemachineCamera = ShuttleEffectCamera:GetComponent(Cinemachine.CinemachineVirtualCamera)

        self.shuttleFrame = ShuttleEffectFrame
    end
end

function CommonAtomizePointBehavior:CompleteShuttle()
    if self.notPlayTimeline then
        self:CompleteAtomize(self.entity.instanceId)
    else
        CameraManager.Instance.statesMachine:ChangeToInto()
        CameraManager.Instance.statesMachine:SetMainTarget(self.targetEntity.clientTransformComponent:GetTransform("ObservePoint"))
        --BehaviorFunctions.RemoveBuff(self.entity.instanceId, 600000028)
        BehaviorFunctions.RemoveEntity(self.ShuttleEffectId)
        CameraManager.Instance:SetCullingMask(-1)
        self.cinemachineCamera.m_Priority = 0
        CameraManager.Instance.statesMachine:SetCameraIntoPovParam(self.horizontalAxisRange, self.verticalAxisRange)
        if self.atomizeWindow then
            self.atomizeWindow:SetCanControl(true)
        end
    end
end

--确认雾化完成，进入目标点
function CommonAtomizePointBehavior:CompleteAtomize(instanceId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    --获取目标位置
    local InTarget = self.targetEntity.clientTransformComponent:GetTransform("InTarget")
    local OutPoint = self.targetEntity.clientTransformComponent:GetTransform("OutPoint")
    local startPos = InTarget.position
    local endPos = OutPoint.position

    --烟囱播退出特效
    BehaviorFunctions.DoMagic(1, self.endTarget.instanceId, 200000903)

    self.atomizeWindow:SetCanControl(false)
    if self.notPlayTimeline then
        --室外的相机不用动，等玩家到位就行
        CameraManager.Instance.statesMachine:ChangeToInto()
        CameraManager.Instance.statesMachine:SetIntoCameraDistance(5)
        CameraManager.Instance.statesMachine:SetMainTarget(OutPoint)
        CameraManager.Instance.statesMachine:SetCameraIntoPovParam(180, 90)
        local x = self.notPlayTimelineYaw
        if self.notPlayTimelineYaw > 180 then
            x = -360 + self.notPlayTimelineYaw
        --else
        --    x = 180 - self.notPlayTimelineYaw
        end
        CameraManager.Instance.statesMachine:SetIntoCameraRotation(x, 0)
    else
        --出口的相机
        CameraManager.Instance.statesMachine:ChangeToWatch()
        CameraManager.Instance.statesMachine:SetMainTarget(OutPoint)
        --横管要设置到侧面
        if modelType[self.targetEntity.entityId] == 2 then
            CameraManager.Instance.statesMachine:SetWatchCameraDistance(5)
            CameraManager.Instance.statesMachine:SetWatchCameraRotation(0, self.targetEntity.transformComponent.rotation:ToEulerAngles().y + 90, 0)
        end
        OutFrame = math.ceil(Vec3.Distance(startPos,endPos) / self.lightMoveSpeed_TimeLine)
    end

    local lightEntityId = BehaviorFunctions.CreateEntity(600000010, self.entity.instanceId, InTarget.position.x, InTarget.position.y, InTarget.position.z)
    self.lightEntity = BehaviorFunctions.GetEntity(lightEntityId)
    LuaTimerManager.Instance:AddTimer(1, 0, function()
        local forward = self.targetEntity.transformComponent.rotation
        self:InitBezierCurveParam(startPos, endPos, forward)
        self:SetState(AtomizeState.Out)
    end)
end

function CommonAtomizePointBehavior:CompleteOut()
    local OutPoint = self.targetEntity.clientTransformComponent:GetTransform("OutPoint")
    if self.lightEntity then
        BehaviorFunctions.RemoveEntity(self.lightEntity.instanceId)
        self.lightEntity = nil
    end
    --if self.notPlayTimeline then
    --    GameObject.Destroy(self.tempAtomizeCenterPoint)
    --end

    local y = OutPoint.position.y
    if self.notPlayTimeline then
        y = y - 0.5
    end
    BehaviorFunctions.InMapTransport(OutPoint.position.x, y, OutPoint.position.z)
    BehaviorFunctions.SetMainTarget(self.atomizeEntityId)
    BehaviorFunctions.RemoveBuff(self.atomizeEntityId, 1000048)
    BehaviorFunctions.DoMagic(1, self.atomizeEntityId, 600000030)
    --timeline结束后，切换相机,切换UI显示的按钮
    self:StopAtomize()
end

--退出雾化
function CommonAtomizePointBehavior:QuitAtomize(instanceId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    CameraManager.Instance.statesMachine:ChangeToWatch()
    local InPoint = self.entity.clientTransformComponent:GetTransform("CameraTarget")
    CameraManager.Instance.statesMachine:SetMainTarget(InPoint)
    local targetId = self.atomizeEntityId
    self.atomizeWindow:SetCanControl(false)
    LuaTimerManager.Instance:AddTimer(1, 0.5, function()
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
        BehaviorFunctions.SetMainTarget(targetId)
        self:StopAtomize()
    end)
    BehaviorFunctions.RemoveBuff(self.atomizeEntityId, 1000048)
    BehaviorFunctions.DoMagic(1, self.atomizeEntityId, 600000030)
    BehaviorFunctions.DoMagic(1, self.atomizeEntityId, 600000037)
end

--退出雾化
function CommonAtomizePointBehavior:StopAtomize()
    LuaTimerManager.Instance:AddTimer(1,1,function()
        self.onBeUse = false
    end)
    --切换操作模式
    InputManager.Instance:MinusLayerCount("Drone")
    --关闭UI
    self:CloseAtomizeUI()
end

--从除自己外的可出节点随机选择一个作为目标点
function CommonAtomizePointBehavior:RandomEndTarget()
    if #self.outPoints > 1 then
        return self.outPoints[math.random(1, #self.outPoints)]
    else
        return self.outPoints[1]
    end
end

--打开雾化UI
function CommonAtomizePointBehavior:OpenAtomizeUI(instanceId)
    if not self.atomizeWindow then
        WindowManager.Instance:OpenWindow(ControlAtomizeWindow)
        self.atomizeWindow = WindowManager.Instance:GetWindow("ControlAtomizeWindow")
        self.atomizeWindow:SetAtomizeId(instanceId)
    end
end

--关闭雾化UI
function CommonAtomizePointBehavior:CloseAtomizeUI()
    WindowManager.Instance:CloseWindow(self.atomizeWindow)
    self.atomizeWindow = nil
    self.atomizeEntityId = nil
    self.atomizeEntity = nil
end

--切换显示的按钮
function CommonAtomizePointBehavior:ChangeAtomizeUIState(state)
    local window = WindowManager.Instance:GetWindow("AtomizeWindow")
    if window then
        window:SetState(state)
    end
end

--获取位置类型
function CommonAtomizePointBehavior:GetLocationType()
    return self.AtomizePointLocationType
end

function CommonAtomizePointBehavior:SetState(state)
    self.state = state
    self.frame = 0
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

function CommonAtomizePointBehavior:BezierCurve(start, cp1, cp2, endp, t)
    local p0 = lerp(start, cp1, t)
    local p1 = lerp(cp1, cp2, t)
    local p2 = lerp(cp2, endp, t)

    local p01 = lerp(p0, p1, t)
    local p12 = lerp(p1, p2, t)

    return lerp(p01, p12, t) -- 最后的插值结果，也就是在贝塞尔曲线上的点
end

function CommonAtomizePointBehavior:InitBezierCurveParam(startPos, endPos, forward)
    self.startPos = startPos
    self.endPos = endPos
    local dir = endPos - startPos
    self.cp1 = self.startPos + dir * 0.2
    self.cp1 = self.cp1 + Vec3.New(0, 1.5, 0) * forward
    self.cp2 = self.endPos - dir * 0.02
    self.cp2 = self.cp2 + Vec3.New(0, 2, 0) * forward
end

function CommonAtomizePointBehavior:SetMoveCameraPosByLerp(startPos, endPos, timeStep, moveTime)
    local pos = Vec3.Lerp(startPos, endPos, timeStep / moveTime)
    CameraManager.Instance.statesMachine:SetAtomizeMovePosition(pos)
end