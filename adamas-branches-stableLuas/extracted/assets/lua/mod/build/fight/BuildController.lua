---@class BuildController
BuildController = BaseClass("BuildController")
local BuildData = Config.DataBuild.Find
local BF = BehaviorFunctions
local _UnityUtils = UnityUtils
local SmallLuaCSharpArr = SmallLuaCSharpArr
local ControlState = {
    Idle = 1,
    Create = 2,
    Wait = 3,
    Move = 4,
    Joint = 5,
}
local SelectedEffect = 1000201
local TipEffect = 1000202
local AllowBuildEffect = 200001005
local SqrJointCheckRange = 64
local pointA = Vector3(0, 0, 0)
local pointB = Vector3(0, 0, 0)
local tempVector3 = Vec3.New()
local epsilon = 22.5  -- 定义一个误差容限
local rotationLerpTime = 0.3
local Rounding = function(a)
    if math.abs(a) < epsilon then
        return 0
    end
    local _a = (a / 45) % 1
    if _a > 0.5 or (_a < 0 and _a > -0.5) then
        return math.ceil(a / 45) * 45
    else
        return math.floor(a / 45) * 45
    end
end
------------手感参数调整------


----------------------------


function BuildController:__init()
    self.buildIdList = {}
    ---@field Entity[] 直接控制的实体列表
    self.directControlEntityList = {}
    ---@field Entity[] 还包括与控制的实体连接在一起的实体
    self.allControlEntityList = {}
    self.controlCount = 0
    self.state = ControlState.Idle

    self.tempPosition = Vec3.New()
    self.tempQuaternion = Quat.New()

    self.previewDistance = 3
    self.previewDistanceOffset = 0
    self.previewHeight = 1.5
    self.previewHeightOffset = 0
    self.maxBuildDistance = 15
    self.tempEffectFrame = 0
    self.isDelayRemoveChain = false

    --这两个四元数都在RotationObj_Y_T的空间下
    self.targetQuat = Quaternion.identity
    self.currentQuat = Quaternion.identity
    self.quatLerp = 0

    self.eulerLerpPercent = 0
    self.curCanRotate = true
    self.lastRotate = nil
    self.otherEntityOffset = Vec3.New()
    self.helpUpDistance = 0

    self.rotateRecord = { x = 0, y = 0 }

    self.noBlueprintOnCreate = true
    self.buildIdList_temp = {}
    self.directControlEntityList_temp = {}
    self.allControlEntityList_temp = {}
end

function BuildController:StartFight()
    self.jointControlAgentObj = GameObject("JointControlAgent")
    self.jointControlAgent = self.jointControlAgentObj:AddComponent(JointControlAgent)
    self.cylinderMeshColliderObj = Fight.Instance.clientFight.assetsPool:Get("Prefabs/Collider/CylinderMesh.prefab")
    self.jointControlAgent:AddCylinderMesh(self.cylinderMeshColliderObj)
    local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
    self.jointControlAgentObj.transform:SetParent(entityRoot)
    self:InitLuaArray()
end

--加载并创建建造物
function BuildController:LoadBuildEntity(buildId, type)
    if not self.buildCamera then
        self.buildCamera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    end
    self.ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if self.state ~= ControlState.Idle then
        self:ClearOldState()
    end
    --临时播放音效
    BF.DoEntityAudioPlay(self.ctrlEntity.instanceId, "ChongGouMenu_Select", false)--音效
    self.curEntityType = type

    if type == FightEnum.BuildType.Single then
        self.curBuildconfig = BuildData[buildId]
        table.insert(self.buildIdList, self.curBuildconfig.instance_id)
    elseif type == FightEnum.BuildType.Combination then
        self.curBuildconfig = mod.BuildCtrl:GetBluePrintConfig(buildId)
        for _, node in pairs(self.curBuildconfig.nodes) do
            local config = BuildData[node.build_id]
            self.buildIdList[node.index] = config.instance_id
        end
    end

    self.controlCount = 0
    self.state = ControlState.Create
    self:InitPreviewBindPoint()
    TableUtils.ClearTable(self.allControlEntityList)

    for index, entityId in pairs(self.buildIdList) do
        self:LoadEntityAssets(index, entityId)
    end
    self.rotateRecord = { x = 0, y = 0 }
end

--直接抓取实体
function BuildController:SetBuild(entity)
    if not self.buildCamera then
        self.buildCamera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    end
    if self.state ~= ControlState.Idle then
        --self:DestroyBuildEntity()
    end

    self.controlCount = 0
    self.state = ControlState.Wait
    self.curEntityType = FightEnum.BuildType.Single
    table.insert(self.directControlEntityList, entity)

    entity.clientTransformComponent:SetLuaControlEntityMove(false)
    entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
    --设置质量和转动惯量都是为了让控制主体在旋转/移动时能作为重心，效果类似调整重心
    entity.jointComponent:EnterControlState(true, 10)
    entity.jointComponent:CallFunctionAtAll("SetActive", { isActive = false })
    --后续把更多处理都整合到事件
    EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, true)
    self.takeMainEntity = entity
    self.takeMainEntityTransform = entity.clientTransformComponent.transform
    self:CheckMovePlatform(entity, false)

    self.ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    self:InitPreviewBindPoint()
    self.previewHeight = self.takeMainEntityTransform.position.y - self.ctrlEntity.clientTransformComponent.transform.position.y
    self.previewDistance = Vec3.DistanceXZ(entity.transformComponent.position, self.ctrlEntity.transformComponent.position)
    local yaw = CameraManager.Instance.mainCamera.transform.localRotation.eulerAngles.y
    _UnityUtils.SetEulerAngles(self.RotationObj_Y_T, 0, yaw, 0)
    _UnityUtils.SetLocalPosition(self.RotationObj_X_T, 0, self.previewHeight, self.previewDistance)

    local q_1 = Quaternion.Inverse(self.RotationObj_Y_T.rotation) * entity.clientTransformComponent.transform.rotation
    local e = q_1.eulerAngles
    _UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, e.x, e.y, e.z)
    --在修正RotationObj_X_T之前设置跟随，这样才能保证旋转的正确
    self.jointControlAgent:SetControlTransform(self.takeMainEntity.clientTransformComponent.transform, self.RotationObj_X_T, self.ctrlEntity.clientTransformComponent.transform, self.buildCamera.targetGroupTransform, self.ctrlEntity.instanceId)
    local q_2 = Quaternion.Euler(Rounding(e.x), Rounding(e.y), Rounding(e.z))
    _UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, q_2.eulerAngles.x, q_2.eulerAngles.y, q_2.eulerAngles.z)
    self.currentQuat = q_1
    self.targetQuat = q_2
    self.quatLerp = rotationLerpTime
    self.helpUpDistance = 1.5

    self.buildCamera:ChangeToBuild()
    self:InitLinkEffect()

    self:AsyncEntityColliderInfo(entity, false)
    TableUtils.ClearTable(self.allControlEntityList)
    entity.jointComponent:GetAllJointId(self.allControlEntityList)
    for k, v in pairs(self.allControlEntityList) do
        if v ~= entity.instanceId then
            local otherEntity = BF.GetEntity(v)
            --临时把其他拼接物都设置为运动学刚体，并放到主体下
            otherEntity.jointComponent:EnterControlState()
            otherEntity.clientTransformComponent:SetRigidBodyIsKinematic(false)
            EventMgr.Instance:Fire(EventName.BuildControlEntity, otherEntity.instanceId, true)
            table.insert(self.directControlEntityList, otherEntity)
            self:CheckMovePlatform(otherEntity, false)
            self:AsyncEntityColliderInfo(otherEntity, false)
            if entity.buffComponent then
                BF.RemoveBuff(v, TipEffect)
                BF.DoMagic(1, v, SelectedEffect)
            end
        end
    end
    self.rotateRecord = { x = 0, y = 0 }
end

function BuildController:ClearOldState()
    if self.state == ControlState.Move then
        self:OnQuitMoveState()
    end
end

--销毁建造物
function BuildController:OnQuitControl()
    self:RemovePreviewBindPoint()
    if self.state == ControlState.Idle then
        return
    end
    if self.takeMainEntity then
        self.takeMainEntity.clientTransformComponent.rigidbody.inertiaTensor = Vector3(1, 1, 1)
    end
    for _, entity in pairs(self.directControlEntityList) do
        BF.RemoveEntity(entity.instanceId)
    end
    if self.chain and not self.isDelayRemoveChain then
        if BF.CheckEntity(self.chain.instanceId) then
            BF.RemoveEntity(self.chain.instanceId)
        end
        self.chain = nil
    end
    self.controlCount = 0
    TableUtils.ClearTable(self.buildIdList)
    TableUtils.ClearTable(self.directControlEntityList)
    if not self.isDelayRemoveChain then
        self.state = ControlState.Idle
    end
    self.buildCamera:SetCameraDistance(5)
    self.previewDistanceOffset = 0
    self.takeMainEntityTransform = nil

    self.jointControlAgent:StopControl()
    self:DestroyLinkEffect()
end

--加载实体资源
function BuildController:LoadEntityAssets(index, entityId)
    Fight.Instance.clientFight.assetsNodeManager:LoadEntity(entityId, function()
        self:LoadEntityAssetsEnd(index, entityId)
    end)
end


--资源加载完毕，加载实体
function BuildController:LoadEntityAssetsEnd(index, entityId)
    if not TableUtils.ContainValue(self.buildIdList, entityId) then
        return
    end

    local instanceId = BF.CreateEntity(entityId, nil, 0, 0, 0)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    entity.clientTransformComponent:AddRigidBody()
    entity.jointComponent.initControl = true
    EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, true)
    self:CheckMovePlatform(entity, false)
    local rootQ = self.RotationObj_Y_T.rotation
    if self.curEntityType == FightEnum.BuildType.Combination then
        --如果是蓝图则偏移坐标
        local config = self.curBuildconfig.nodes[index]
        self.tempPosition:Set(config.offset.pos_x / 10000, config.offset.pos_y / 10000, config.offset.pos_z / 10000)
        local pos = self.RotationObj_X_T:TransformPoint(self.tempPosition)
        entity.transformComponent:SetPosition(pos.x, pos.y, pos.z)
        _UnityUtils.SetPosition(entity.clientTransformComponent.transform, pos.x, pos.y, pos.z)
        self.tempQuaternion:SetEuler(config.rotate.pos_x / 10000, config.rotate.pos_y / 10000, config.rotate.pos_z / 10000)
        local q = rootQ * self.tempQuaternion
        entity.transformComponent:SetRotation(q)
        _UnityUtils.SetRotation(entity.clientTransformComponent.transform, q.x, q.y, q.z, q.w)
    else
        local pos = self.RotationObj_X_T.position
        local q = self.RotationObj_X_T.rotation
        entity.transformComponent:SetPosition(pos.x, pos.y, pos.z)
        entity.transformComponent:SetRotation(q)
        _UnityUtils.SetPosition(entity.clientTransformComponent.transform, pos.x, pos.y, pos.z)
        _UnityUtils.SetRotation(entity.clientTransformComponent.transform, q.x, q.y, q.z, q.w)
    end
    entity.transformComponent:Async()
    EntityLODManager.Instance:Async(entity.instanceId)
    BF.DoMagic(1, entity.instanceId, AllowBuildEffect)

    self.directControlEntityList[index] = entity
    self.controlCount = self.controlCount + 1
    table.insert(self.allControlEntityList, entity.instanceId)
    if self.controlCount == #self.buildIdList then
        self:OnCreateDone()
        self.state = ControlState.Wait
    end
end

--设置建造物碰撞层级
function BuildController:SetBuildCollisionEnable(entity, enable)
    if entity.partComponent then
        entity.partComponent:SetCollisionEnable(enable)
    end
    entity.collistionComponent:SetCollisionEnable(enable)
end

function BuildController:SetBuildCollisionLayer(entity, layer)
    entity.collistionComponent:SetCollisionLayer(layer)
    if entity.partComponent then
        entity.partComponent:SetCollisionLayer(layer)
    end
end

--全部建造物加载完毕
function BuildController:OnCreateDone()
    --根据蓝图记录的父子关系，设置关节
    if self.curEntityType == FightEnum.BuildType.Combination then
        for index, entity in ipairs(self.directControlEntityList) do
            local config = self.curBuildconfig.nodes[index]
            for _index, parent_index in pairs(config.parent_index) do
                if self.directControlEntityList[parent_index] then
                    local connectPointConfig = config.connect_point[_index]
                    self.directControlEntityList[parent_index].jointComponent:OnAddChild(entity, connectPointConfig.point_type, connectPointConfig.parent_bone_name, connectPointConfig.child_bone_name)
                end
            end
            if #config.parent_index == 0 then
                self.takeMainEntity = entity
                self.takeMainEntityTransform = entity.clientTransformComponent.transform
            else
                entity.jointComponent:EnterControlState()
            end
            EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, true)
        end
        for _, entity in ipairs(self.directControlEntityList) do
            entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
            entity.clientTransformComponent:SetLuaControlEntityMove(false)
            self:AsyncEntityColliderInfo(entity, true)
        end
    else
        self.takeMainEntity = self.directControlEntityList[1]
        self.takeMainEntityTransform = self.takeMainEntity.clientTransformComponent.transform
        self.takeMainEntity.clientTransformComponent:SetRigidBodyIsKinematic(false)
        self.takeMainEntity.clientTransformComponent:SetLuaControlEntityMove(false)
        self:AsyncEntityColliderInfo(self.takeMainEntity, true)
    end
    self:InitLinkEffect()
    self.takeMainEntity.jointComponent:EnterControlState(true, 10)
    self.jointControlAgent:SetControlTransform(self.takeMainEntity.clientTransformComponent.transform, self.RotationObj_X_T, self.ctrlEntity.clientTransformComponent.transform, self.buildCamera.targetGroupTransform, self.ctrlEntity.instanceId)
end

--给建造物加特效
function BuildController:AddEffectToAll(effectId, isAdd)
    for k, entity in pairs(self.directControlEntityList) do
        if isAdd then
            BF.DoMagic(1, entity.instanceId, effectId)
        else
            BF.RemoveBuff(entity.instanceId, effectId)
        end
    end
end

--断开连接
function BuildController:CancelAllJoint()
    --TODO 从Ctrl删除
    local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
    if self.curEntityType == FightEnum.BuildType.Single and self.directControlEntityList[1] then
        BF.DoEntityAudioPlay(self.ctrlEntity.instanceId, "ChongGou_Disconnect", false)--音效
        for index, entity in ipairs(self.directControlEntityList) do
            if index == 1 then
                entity.jointComponent:CancelAllJoint()
            else
                entity.clientTransformComponent.transform:SetParent(entityRoot)
                if not entity.jointComponent.config.IsSetKinematic then
                    entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
                end
                entity.jointComponent:ExitControlState()
                self:CheckMovePlatform(entity, true)
                EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, false)
                BF.RemoveBuff(entity.instanceId, SelectedEffect)
                BF.RemoveBuff(entity.instanceId, AllowBuildEffect)
                BF.DoMagic(1, entity.instanceId, TipEffect)
            end
        end
        local controlEntity = self.directControlEntityList[1]
        TableUtils.ClearTable(self.directControlEntityList)
        TableUtils.ClearTable(self.allControlEntityList)
        self.directControlEntityList[1] = controlEntity
        self.allControlEntityList[1] = controlEntity.instanceId
    end

    self:OnBeCancelJoint()
end

function BuildController:OnBuild()
    local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
    for k, entity in pairs(self.directControlEntityList) do
        entity.clientTransformComponent.transform:SetParent(entityRoot)
        if entity.tagComponent.npcTag == FightEnum.EntityNpcTag.DisplayPartner then
            entity.clientTransformComponent:SetLuaControlEntityMove(true)
            entity.clientTransformComponent:SetRigidBodyIsKinematic(true)
        elseif entity.entityId ~= 2030502 then
            entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
        else
            entity.clientTransformComponent:SetLuaControlEntityMove(true)
            Fight.Instance.entityManager:CallBehaviorFun("OnPartnerBuildSuccess", entity.instanceId)
        end
        entity.jointComponent:ExitControlState()
        EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, false)
        self:CheckMovePlatform(entity, true)
        BF.RemoveBuff(entity.instanceId, AllowBuildEffect)
        BF.RemoveBuff(entity.instanceId, SelectedEffect)
    end

    --单体， 如果能依附则依附
    if self.connectEntity and self.connectTargetEntity then
        --BF.DoEntityAudioPlay(self.ctrlEntity.instanceId, "ChongGou_Connect", false)--音效
        self.state = ControlState.Move
        --设置为不受重力影响
        for k, v in pairs(self.allControlEntityList) do
            local entity = BF.GetEntity(v)
            entity.clientTransformComponent:SetRigidBodyUseGravity(false)
            entity.clientTransformComponent:SetRigidBodyIsKinematic(true)
            EventMgr.Instance:Fire(EventName.BuildControlEntity, v, true)
        end

        local connectTargets = {}
        self.connectTargetEntity.jointComponent:GetAllJointId(connectTargets)
        for k, v in pairs(connectTargets) do
            local entity = BF.GetEntity(v)
            if not entity.jointComponent.config.IsSetKinematic then
                entity.clientTransformComponent:SetRigidBodyUseGravity(false)
                entity.clientTransformComponent:SetRigidBodyIsKinematic(true)
            end
            EventMgr.Instance:Fire(EventName.BuildControlEntity, v, true)
        end

        local lightTransform = self.connectEntity.clientTransformComponent.transform
        local weightTransform = self.connectTargetEntity.clientTransformComponent.transform
        local pointA_local = lightTransform:InverseTransformPoint(pointA)
        local q_1 = Quaternion.Inverse(weightTransform.rotation) * lightTransform.rotation
        local e = q_1.eulerAngles
        local q_2, q_3
        if not self.isUsePrefabPoint then
            --原理：计算出吸附对象参考系下自己的旋转，然后向45°倍数修正
            q_2 = Quaternion.Euler(Rounding(e.x), Rounding(e.y), Rounding(e.z))
            q_3 = weightTransform.rotation * q_2
        else
            --原理：让优先点的朝向相对,计算一个点的朝向的反方向到另一个点的旋转
            local f = Vec3.CreateByUnityVec3(self.transform_B.forward)
            f:Set(-f.x, -f.y, -f.z)
            q_2 = Quat.FromToRotation(Vec3.CreateByUnityVec3(self.transform_A.forward), f)
            q_3 = q_2:ToUnityQuat() * Quat.CreateByUnityQuat(lightTransform.rotation)
        end

        --此时已经对齐,分别检测两个物体移动后是否会碰撞，挑不会碰撞的那一侧进行移动（还差考虑重量）
        local callback = function(effectPos)
            self.connectTargetEntity.jointComponent:OnAddChild(self.connectEntity, self.pointChoseType, self.connectTargetObjName, self.connectObjName)
            if self.connectTargetEntity.jointComponent.jointCtrl then
                self.connectTargetEntity.jointComponent.jointCtrl:AddBuild(self.connectEntity, self.connectTargetEntity.instanceId)
            end
            local buildEffect = Fight.Instance.entityManager:CreateEntity(1000000044)
            buildEffect.transformComponent:SetPosition(effectPos.x, effectPos.y, effectPos.z)
            --重新设置为受重力影响
            LuaTimerManager.Instance:AddTimer(1, 0.3, function()
                for k, v in pairs(self.allControlEntityList) do
                    local entity = BF.GetEntity(v)
                    entity.clientTransformComponent:SetRigidBodyUseGravity(true)
                    entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
                    EventMgr.Instance:Fire(EventName.BuildControlEntity, v, false)
                end
                for k, v in pairs(connectTargets) do
                    local entity = BF.GetEntity(v)
                    if not entity.jointComponent.config.IsSetKinematic then
                        entity.clientTransformComponent:SetRigidBodyUseGravity(true)
                        entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
                    end
                    EventMgr.Instance:Fire(EventName.BuildControlEntity, v, false)
                end
            end)
        end

        _UnityUtils.SetEulerAngles(lightTransform, q_3.eulerAngles.x, q_3.eulerAngles.y, q_3.eulerAngles.z)
        local new_pointA = lightTransform:TransformPoint(pointA_local)
        local offset = (pointB - new_pointA) * 0.99
        if self:CheckMoveCanUse(offset, q_3.eulerAngles.x, q_3.eulerAngles.y, q_3.eulerAngles.z, connectTargets) or self.connectTargetEntity.jointComponent.config.IsDisableMove then
            local percent = 0
            local offset_2 = offset / 15
            LuaTimerManager.Instance:AddTimer(16, 0.02, function()
                percent = percent + 1
                if percent < 16 then
                    for k, v in pairs(self.allControlEntityList) do
                        local entity = BF.GetEntity(v)
                        entity.clientTransformComponent.rigidbody:Move(entity.clientTransformComponent.transform.position + offset_2, entity.clientTransformComponent.transform.rotation)
                    end
                else
                    callback(pointB)
                end
            end)
        else
            local percent = 0
            local offset_2 = (new_pointA - pointB) * 0.99 / 15
            LuaTimerManager.Instance:AddTimer(16, 0.02, function()
                percent = percent + 1
                if percent < 16 then
                    for k, v in pairs(connectTargets) do
                        local entity = BF.GetEntity(v)
                        entity.clientTransformComponent.rigidbody:Move(entity.clientTransformComponent.transform.position + offset_2, entity.clientTransformComponent.transform.rotation)
                    end
                else
                    callback(new_pointA)
                end
            end)
        end

        self.tempEffectFrame = 0
        self.isDelayRemoveChain = true
    else
        if not self.takeMainEntity.jointComponent.jointCtrl then
            local ctrl = Fight.Instance.objectPool:Get(BaseJointCtrl)
            ctrl:Init(Fight.Instance, self.takeMainEntity)
        end
    end
    TableUtils.ClearTable(self.directControlEntityList)
    self:OnQuitControl()
end

--TODO 这里的流程需要重新梳理一下，现在很容易出错
function BuildController:OnCancelTake()
    local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
    for k, entity in pairs(self.directControlEntityList) do
        if entity.clientTransformComponent then
            entity.clientTransformComponent.transform:SetParent(entityRoot)
            if entity.entityId ~= 2030502 and not entity.jointComponent.config.IsSetKinematic then
                entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
            else
                entity.clientTransformComponent:SetLuaControlEntityMove(true)
            end
        end
        entity.jointComponent:ExitControlState()
        Fight.Instance.entityManager:CallBehaviorFun("OnPartnerBuildSuccess", entity.instanceId)

        BF.RemoveBuff(entity.instanceId, SelectedEffect)
        BF.RemoveBuff(entity.instanceId, AllowBuildEffect)
    end
    TableUtils.ClearTable(self.directControlEntityList)
    self:OnQuitControl()
end

--增加位置和角度判断逻辑，没有到指定位置时，持续施加较小的力
function BuildController:Update(lerp)
    --_UnityUtils.BeginSample("BuildController.Update")
    if self.state == ControlState.Idle or self.state == ControlState.Create then
        --_UnityUtils.EndSample()
        return
    end
    if self.state == ControlState.Move then
        self:UpdateChainEffect()
        --_UnityUtils.EndSample()
        return
    end

    self:UpdateRotate()
    self:UpdateTempPreviewPoint()
    self:GetJointInfo()
    self:UpdateLinkEffect()
    --_UnityUtils.EndSample()
end

function BuildController:GetJointInfo()
    --_UnityUtils.BeginSample("BuildController.GetJointInfo")
    --获取所有建造物
    --TODO 仅获取有建造物标签的
    local entitys = Fight.Instance.entityManager:GetEntites()
    --过滤出5m范围内的
    local minSqrDistance = 100
    local closestEntity_Control
    local closestEntity_World
    local positionA, positionB, connectObjName, targetObjName
    self.pointChoseType = nil
    --找到最短距离
    for _, targetEntity in pairs(entitys) do
        if targetEntity.jointComponent and targetEntity.jointComponent.IsCanJoint and not TableUtils.ContainValue(self.allControlEntityList, targetEntity.instanceId) then
            for _, v in pairs(self.allControlEntityList) do
                local entity = BF.GetEntity(v)
                if entity.jointComponent.IsCanJoint and v ~= targetEntity.instanceId and Vec3.SquareDistance(entity.transformComponent.position, targetEntity.transformComponent.position) < SqrJointCheckRange then
                    --过滤掉已拼接的实体，并调用接口，计算出碰撞盒之间最近的距离
                    if not entity.jointComponent:CheckEntityHasJoint(targetEntity.instanceId) then
                        local sqrDistance, _positionA, _positionB, connectName, targetName = self:GetEntityColliderMinSqrDistance(entity, targetEntity)
                        if sqrDistance < entity.jointComponent.adsorbDistance and sqrDistance < targetEntity.jointComponent.adsorbDistance and sqrDistance < minSqrDistance then
                            minSqrDistance = sqrDistance
                            closestEntity_Control = entity
                            closestEntity_World = targetEntity
                            positionA = _positionA
                            positionB = _positionB
                            connectObjName = connectName
                            targetObjName = targetName
                            self.pointChoseType = FightEnum.BuildConnectPointType.NearestPoint
                        end
                    end
                end
            end
        end
    end
    local distance, transform_1, transform_2
    self.isUsePrefabPoint = false
    self.transform_A = nil
    self.transform_B = nil
    if closestEntity_Control and closestEntity_World then
        if (closestEntity_Control.jointComponent.config.OnlyCanUseBuildPoint or closestEntity_World.jointComponent.config.OnlyCanUseBuildPoint) then
            minSqrDistance = 25
        end
        distance, transform_1, transform_2 = closestEntity_Control.jointComponent:GetNearestPoint(closestEntity_World, closestEntity_World.clientTransformComponent.transform)
        if (distance and distance < minSqrDistance) then
            self.transform_A = transform_1
            self.transform_B = transform_2
            positionA = transform_1 and transform_1.position or nil
            positionB = transform_2 and transform_2.position or nil
            connectObjName = transform_1 and transform_1.name or nil
            targetObjName = transform_2 and transform_2.name or nil
            self.isUsePrefabPoint = true
            self.pointChoseType = FightEnum.BuildConnectPointType.PrefabPoint
        else
            if (closestEntity_Control.jointComponent.config.OnlyCanUseBuildPoint or closestEntity_World.jointComponent.config.OnlyCanUseBuildPoint) then
                closestEntity_Control = nil
                closestEntity_World = nil
                positionA = nil
                positionB = nil
            end
        end
    end

    --先让连接点法线共线，然后修正方向
    if positionA and positionB then
        --生成特效连线
        pointA = positionA
        pointB = positionB
        if not self.chain then
            local centerPos = Vec3.Lerp(pointA, pointB, 0.5)
            local chainId = BF.CreateEntity(6000801401, nil, centerPos.x, centerPos.y, centerPos.z)--创建缔约特效
            self.chain = BF.GetEntity(chainId)
            self.initPos = pointA
            --BF.ClientEffectRelation(self.chain, self.PartnerAllParm.role, self.diyueHand, self.me, self.PartnerAllParm.diyuePart, 0)--设置缔约特效
        end
        if self.chain then
            local center = Vec3.Lerp(pointA, pointB, 0.5)
            BF.DoSetPositionP(self.chain.instanceId, center)
            self.chain.clientTransformComponent:SetRelationPos(pointA - center, pointB - center)
        end
    else
        if self.chain then
            if BF.CheckEntity(self.chain.instanceId) then
                BF.RemoveEntity(self.chain.instanceId)
            end
            self.chain = nil
        end
    end

    self.connectEntity = closestEntity_Control
    self.connectTargetEntity = closestEntity_World
    self.connectObjName = connectObjName
    self.connectTargetObjName = targetObjName
    --_UnityUtils.EndSample()
end

---@param entity1 Entity
---@param entity2 Entity
function BuildController:GetEntityColliderMinSqrDistance(entity1, entity2)
    local Layer = FightEnum.Layer.AirWall
    --TODO 直接用Vector3,性能不好,要优化
    local distance, _pointA, _pointB, connectName, targetName = CustomUnityUtils.GetClosestPoint(entity1.clientTransformComponent.gameObject, entity2.clientTransformComponent.gameObject, Layer, pointA, pointB)
    return distance, _pointA, _pointB, connectName, targetName
end

function BuildController:UpdateChainEffect()
    if self.chain then
        self.tempEffectFrame = self.tempEffectFrame + 1 > 10 and 10 or self.tempEffectFrame + 1
        local curPos = Vec3.Lerp(pointA, pointB, self.tempEffectFrame / 10)
        local center = Vec3.Lerp(curPos, pointB, 0.5)
        BF.DoSetPositionP(self.chain.instanceId, center)
        local a = Vector3(curPos.x - center.x, curPos.y - center.y, curPos.z - center.z)
        local b = Vector3(pointB.x - center.x, pointB.y - center.y, pointB.z - center.z)
        self.chain.clientTransformComponent:SetRelationPos(a, b)
        if self.tempEffectFrame == 10 then
            self:OnQuitMoveState()
        end
    end
end

function BuildController:OnQuitMoveState()
    self.isDelayRemoveChain = false
    if self.chain then
        if BF.CheckEntity(self.chain.instanceId) then
            BF.RemoveEntity(self.chain.instanceId)
        end
        self.chain = nil
    end
    self.state = ControlState.Idle
end

--=======================
function BuildController:InitPreviewBindPoint()
    if not self.RotationObj_Y and not self.RotationObj_X then
        self.RotationObj_Y = GameObject("RotationObj_Y")
        self.RotationObj_Y_T = self.RotationObj_Y.transform

        local position = self.ctrlEntity.clientTransformComponent.transform.position
        local euler = self.ctrlEntity.clientTransformComponent.transform.rotation.eulerAngles
        _UnityUtils.SetPosition(self.RotationObj_Y_T, position.x, position.y, position.z)
        _UnityUtils.SetEulerAngles(self.RotationObj_Y_T, 0, euler.y, 0)

        self.RotationObj_X = GameObject("RotationObj_X")
        self.RotationObj_X_T = self.RotationObj_X.transform
        self.RotationObj_X_T:SetParent(self.RotationObj_Y_T)
        _UnityUtils.SetLocalPosition(self.RotationObj_X_T, 0, self.previewHeight, self.previewDistance)
        _UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, 0, 0, 0)
        self:SetCameraExtraTarget(self.RotationObj_X_T)
        self.targetQuat = Quaternion.identity
        self.currentQuat = Quaternion.identity
        self.quatLerp = 0

        self.eulerLerpPercent = 0
        self.curCanRotate = true
    end
end

function BuildController:RemovePreviewBindPoint()
    if self.RotationObj_Y and self.RotationObj_X then
        self:SetCameraExtraTarget()
        GameObject.Destroy(self.RotationObj_Y)
        GameObject.Destroy(self.RotationObj_X)
        self.RotationObj_Y = nil
        self.RotationObj_Y_T = nil
        self.RotationObj_X = nil
        self.RotationObj_X_T = nil
    end
    self.previewDistance = 3
    self.previewHeight = 1
    self.previewDistanceOffset = 0
    self.previewHeightOffset = 0
end

---简单的分段参数，以后做优化可以考虑换成曲线
local yawLimit = 30
local yawBuffer = 5
local tempCameraQ = Quat.New()
local maxHeight = 8
local maxHorizontal = 3
function BuildController:UpdateTempPreviewPoint()
    local screenMoveX = Fight.Instance.clientFight.inputManager.screenMoveX or 0
    local screenMoveY = Fight.Instance.clientFight.inputManager.screenMoveY or 0
    if self.previewDistanceOffset >= 0.05 or self.previewDistanceOffset <= -0.05 then
        self.axis_z_offset = self.previewDistanceOffset * 0.2
        self.previewDistanceOffset = self.previewDistanceOffset * 0.8
    else
        self.previewDistanceOffset = 0
        self.axis_z_offset = 0
    end

    local position = self.ctrlEntity.clientTransformComponent.transform.position
    local y = self.RotationObj_Y_T.position.y
    if self.moveAsyncArr.CSharpArr[2] == 0 and self.takeMainEntityTransform.position.y > position.y and self.moveAsyncArr.CSharpArr[1] > 0.5 then
        y = position.y
    end
    _UnityUtils.SetPosition(self.RotationObj_Y_T, position.x, y, position.z)
    --_UnityUtils.SetPosition(self.RotationObj_Y_T, position.x, self.RotationObj_Y_T.position.y, position.z)
    local yaw = CameraManager.Instance.mainCamera.transform.localRotation.eulerAngles.y
    --在这里处理旋转，根据玩家朝向与所持物件方位的差距限制相机转动速度
    --如果是缩小差距，则不做限制 , 通过比较左右来判断
    local limit_vector = self.takeMainEntityTransform.position - self.RotationObj_Y_T.position
    local q_yaw = tempCameraQ:SetEuler(0, yaw, 0)
    local angle = Quat.Angle(q_yaw, Quat.LookRotationA(limit_vector.x, 0, limit_vector.z))
    local ignoreLimit = false
    local crossProduct = Vec3.Cross(CameraManager.Instance.mainCamera.transform.forward, limit_vector);
    if crossProduct.y > 0 then
        --相机朝向在物件左侧
        if screenMoveX > 0 then
            ignoreLimit = true
        end
    elseif crossProduct.y < 0 then
        --相机朝向在物件右侧
        if screenMoveX < 0 then
            ignoreLimit = true
        end
    else
        ignoreLimit = true
    end
    if math.abs(angle) > yawLimit and not ignoreLimit then
        local maxSpeed = 1 - (math.abs(angle) - yawLimit) / yawBuffer
        maxSpeed = maxSpeed >= 0 and maxSpeed or 0
        self.buildCamera:SetCameraAxisHSpeed(maxSpeed)
    else
        self.buildCamera:SetCameraAxisHSpeed(1)
    end
    _UnityUtils.SetEulerAngles(self.RotationObj_Y_T, 0, yaw, 0)

    --在这里处理远近和高低
    --高低会和当前比较，有一个最大差距，一个缓冲差距，达到缓冲差距后开始减速
    -- <0 此时正在加大差距
    local limit_Pos = self.takeMainEntityTransform.position - self.RotationObj_X_T.position
    if limit_Pos.y * screenMoveY < 0 then
        local absY = math.abs(limit_Pos.y)
        if absY > 1 then
            screenMoveY = 0
        end
    end
    local local_Pos = self.RotationObj_Y_T:InverseTransformPoint(self.takeMainEntityTransform.position)
    --要考虑到不同方向的情况
    --移动导致距离过大时，不能继续朝对应方向移动
    if local_Pos.x > maxHorizontal then
        self.ctrlEntity.stateComponent:GetBuildDisableHorizontalMove(true, false)
    elseif local_Pos.x < -maxHorizontal then
        self.ctrlEntity.stateComponent:GetBuildDisableHorizontalMove(false, true)
    else
        self.ctrlEntity.stateComponent:GetBuildDisableHorizontalMove(false, false)
    end

    if screenMoveY < -50 then
        screenMoveY = -50
    end
    if screenMoveY > 50 then
        screenMoveY = 50
    end
    --高度限制
    if self.RotationObj_X_T.localPosition.y > maxHeight and screenMoveY >= 0 then
        screenMoveY = -1
    end
    --如果地面有碰撞，可以突破高度限制
    --地面碰撞的检测方法:最低点的高处往下打射线，如果碰撞点高于最低点则抬升
    local height = self.moveAsyncArr.CSharpArr[3]
    if screenMoveY < 0 then
        if height < 0.5 and height > 0.3 then
            screenMoveY = (height - 0.3) / 0.2 * screenMoveY
        elseif height < 0.3 and height > 0.2 then
            screenMoveY = 0
        end
    end
    if height < 0.2 then
        screenMoveY = 50
    end
    if screenMoveY > 0 and self.moveAsyncArr.CSharpArr[1] < 0.5 then
        screenMoveY = 0
    end
    local isOnJointGround = self:CheckGroundOnControl()
    if isOnJointGround then
        screenMoveY = 0
        self.helpUpDistance = 0
    end
    self.previewHeight = self.previewHeight + screenMoveY * 0.01 + self.helpUpDistance
    self.helpUpDistance = 0

    --先处理最远距离，由配置限制，可能被最近距离强制突破
    local isOnMove = self.ctrlEntity.moveComponent.moveVector.x ~= 0 or self.ctrlEntity.moveComponent.moveVector.y ~= 0 or self.ctrlEntity.moveComponent.moveVector.z ~= 0
    local minDistance = isOnMove and 3 or 0.5
    if self.previewDistance > 10 and self.axis_z_offset >= 0 then
        self.axis_z_offset = -0.2
    end
    if self.moveAsyncArr.CSharpArr[1] + self.axis_z_offset < minDistance then
        self.axis_z_offset = 0
    end
    if self.moveAsyncArr.CSharpArr[1] < minDistance then
        self.axis_z_offset = 1.5
    end
    if isOnJointGround and isOnMove then
        self.axis_z_offset = 3
    end
    self.previewDistance = self.previewDistance + self.axis_z_offset
    _UnityUtils.SetLocalPosition(self.RotationObj_X_T, 0, self.previewHeight, self.previewDistance)
end

function BuildController:UpdateRotate()
    if self.quatLerp <= 0 then
        return
    end
    local lerp = Global.deltaTime
    local t = lerp / self.quatLerp
    if t > 1 then
        t = 1
        self.quatLerp = 0
    end
    self.quatLerp = self.quatLerp - lerp
    self.currentQuat = Quaternion.Slerp(self.currentQuat, self.targetQuat, t)
    local euler = self.currentQuat.eulerAngles
    _UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, euler.x, euler.y, euler.z)
end

function BuildController:RotatePreviewPoint(rotate, x, y)
    if not self.curCanRotate and rotate == self.lastRotate or not self.takeMainEntity then
        return
    end
    if self.takeMainEntity.jointComponent.config.IsDisableRotation then
        return
    end
    --每次旋转时，记录本地空间下的旋转起始和结束，然后对这个进行插值，然后将插值的变化量变换到世界坐标系，

    self.rotateRecord.x = self.rotateRecord.x + x
    self.rotateRecord.y = self.rotateRecord.y + y
    if self.RotationObj_X_T then
        self.eulerLerpPercent = 0
        self.lastRotate = rotate
        self.targetQuat = rotate * self.targetQuat
        if (x ~= 0 and (self.rotateRecord.x % 2) == 0) or (y ~= 0 and (self.rotateRecord.y % 2) == 0) then
            local _x = Rounding(self.targetQuat.eulerAngles.x)
            local _y = Rounding(self.targetQuat.eulerAngles.y)
            local _z = Rounding(self.targetQuat.eulerAngles.z)
            self.targetQuat = Quaternion.Euler(_x, _y, _z)
        end
        self.quatLerp = self.quatLerp + rotationLerpTime
    end
end

function BuildController:SetPreviewPointDistanceOffset(value)
    self.previewDistanceOffset = value
end

function BuildController:SetPreviewPointHeightOffset(value)
    self.previewHeightOffset = value
end

function BuildController:SetCameraExtraTarget(target)
    if not target then
        self.buildCamera:RemoveExtraTarget()
    end
    self.buildCamera:SetExtraTarget(target)
end

function BuildController:CheckEntityOnBuildControl(instanceId)
    for _, entity in pairs(self.directControlEntityList) do
        if entity.instanceId == instanceId or entity.jointComponent:CheckEntityHasJoint(instanceId) then
            return true
        end
    end
end

function BuildController:CheckMoveCanUse(offset, euler_x, euler_y, euler_z, ignoreList)
    for _, entity in pairs(self.directControlEntityList) do
        local entityId = entity.entityId
        local instanceId = entity.instanceId
        tempVector3:SetA(entity.clientTransformComponent.transform.position)
        tempVector3:Add(offset)
        if not BF.CheckEntityCollideAtPositionAndRotation(entityId, tempVector3.x, tempVector3.y, tempVector3.z, euler_x, euler_y, euler_z, ignoreList or self.allControlEntityList, instanceId, false) then
            return false
        end
    end
    return true
end

function BuildController:CheckMovePlatform(entity, enable)
    if entity.movePlatformComponent then
        entity.movePlatformComponent:SetMovePlatformEnabled(enable)
    end
end

function BuildController:__delete()
    GameObject.Destroy(self.jointControlAgentObj)
    self.jointControlAgentObj = nil
    self.jointControlAgent = nil
    Fight.Instance.objectPool:Cache(SmallLuaCSharpArr, self.colliderAsyncArr)
    Fight.Instance.objectPool:Cache(SmallLuaCSharpArr, self.moveAsyncArr)
end

--moveAsyncArr中参数的意思
--1: 建造物在玩家本地坐标系中的最小z轴坐标(建造物离玩家最近的距离
--2: 建造物是否与玩家碰撞，大于0为有碰撞，此时禁止向上移动
--3：建造物最低点离地面的高度是否小于0.1，大于0为小于，此时应该向上移动建造物
function BuildController:InitLuaArray()
    self.colliderAsyncArr = Fight.Instance.objectPool:Get(SmallLuaCSharpArr)
    self.moveAsyncArr = Fight.Instance.objectPool:Get(SmallLuaCSharpArr)
    self.jointControlAgent:AddLuaArr(self.colliderAsyncArr.access, self.moveAsyncArr.access)
end

function BuildController:AsyncCollider(localOffset, localPosition, localRotation, localScale, type, ignoreName)
    local array = self.colliderAsyncArr.CSharpArr
    array[1] = localPosition.x + localOffset.x
    array[2] = localPosition.y + localOffset.y
    array[3] = localPosition.z + localOffset.z
    array[4] = localRotation.x
    array[5] = localRotation.y
    array[6] = localRotation.z
    array[7] = localRotation.w
    array[8] = localScale.x
    array[9] = localScale.y
    array[10] = localScale.z
    array[11] = type
    array[12] = ignoreName

    self.jointControlAgent:AddNewColliderInfo()
end

function BuildController:AsyncEntityColliderInfo(entity, isLocal)
    local offset = self.takeMainEntityTransform:InverseTransformPoint(entity.clientTransformComponent.transform.position)
    for k, v in pairs(entity.partComponent.parts) do
        local colliderList = v:GetColliderList()
        for _, collision in ipairs(colliderList) do
            local collisionType = collision.collisionType
            if collisionType == FightEnum.CollisionType.Sphere or collisionType == FightEnum.CollisionType.Cube or
                    collisionType == FightEnum.CollisionType.Cylinder or collisionType == FightEnum.CollisionType.CylinderMesh then
                collisionType = collisionType == FightEnum.CollisionType.Cylinder and FightEnum.CollisionType.CylinderMesh or collisionType

                local rotation = isLocal and collision.colliderTransform.localRotation or collision.colliderTransform.rotation
                self:AsyncCollider(offset, collision.colliderTransform.localPosition, rotation, collision.colliderTransform.localScale, collisionType, entity.instanceId)
            end
        end
    end
end

--TODO 究极手举起时断开连接,可能还有未处理的情况
function BuildController:OnBeCancelJoint()
    self.jointControlAgent:ClearAllCollider()
    self:AsyncEntityColliderInfo(self.takeMainEntity, false)
end

function BuildController:InitLinkEffect()
    self.handTransform = self.ctrlEntity.clientTransformComponent:GetTransform("Bip001 L Hand")
    if not self.handTransform then
        LogError("角色模型缺少挂点 Bip001 L Hand , 请在BindTransform中进行绑定")
    end
    if not self.linkEffect then
        self.linkEffect = Fight.Instance.entityManager:CreateEntity(1000000040)
        local pos = self.ctrlEntity.transformComponent.position
        self.linkEffect.transformComponent:SetPosition(pos.x, pos.y, pos.z)
    end
end

function BuildController:UpdateLinkEffect()
    if not self.linkEffect then
        return
    end
    if not self.linkEffectComponent then
        self.linkEffectComponent = self.linkEffect.clientTransformComponent.transform:GetComponent('AraLink')
    end

    Vec3.LerpA(self.handTransform.position, self.RotationObj_X_T.position, 0.5, tempVector3)
    self.linkEffectComponent:SetSelectedPoints({ self.handTransform.position, tempVector3, self.takeMainEntityTransform.position })
end

function BuildController:DestroyLinkEffect()
    if self.linkEffect then
        Fight.Instance.entityManager:RemoveEntity(self.linkEffect.instanceId)
        self.linkEffect = nil
    end
    self.linkEffectComponent = nil
    self.handTransform = nil
end

--#region  临时处理
local testConfig = {
    blueprint_id = 1716555574,
    build_id = 0,
    child_list = {

    },
    image_path = "",
    name = "自定义蓝图1",
    nodes = {
        {
            build_id = 1002,
            child_list = {

            },
            connect_node = "",
            connect_point = {
                {
                    child_bone_name = "ConnectPoint_2",
                    parent_bone_name = "ConnectPoint_8",
                    point_type = "1"
                }
            },
            index = 1,
            node_name = "",
            offset = {
                pos_x = -20558,
                pos_y = 1327,
                pos_z = -21111
            },
            parent_index = {
                5
            },
            parent_transform_name = {

            },
            rotate = {
                pos_x = 2705612,
                pos_y = 3574328,
                pos_z = 25792
            }
        },
        {
            build_id = 1002,
            child_list = {

            },
            connect_node = "",
            connect_point = {
                {
                    child_bone_name = "ConnectPoint_1",
                    parent_bone_name = "ConnectPoint_7",
                    point_type = "1"
                }
            },
            index = 2,
            node_name = "",
            offset = {
                pos_x = 20582,
                pos_y = 1413,
                pos_z = -21275
            },
            parent_index = {
                5
            },
            parent_transform_name = {

            },
            rotate = {
                pos_x = 2701326,
                pos_y = 3599648,
                pos_z = 351
            }
        },
        {
            build_id = 1002,
            child_list = {

            },
            connect_node = "",
            connect_point = {
                {
                    child_bone_name = "ConnectPoint_1",
                    parent_bone_name = "ConnectPoint_9",
                    point_type = "1"
                }
            },
            index = 3,
            node_name = "",
            offset = {
                pos_x = 20607,
                pos_y = 1613,
                pos_z = 28484
            },
            parent_index = {
                5
            },
            parent_transform_name = {

            },
            rotate = {
                pos_x = 2712805,
                pos_y = 1902207,
                pos_z = 1698703
            }
        },
        {
            build_id = 1002,
            child_list = {

            },
            connect_node = "",
            connect_point = {
                {
                    child_bone_name = "ConnectPoint_2",
                    parent_bone_name = "ConnectPoint_10",
                    point_type = "1"
                }
            },
            index = 4,
            node_name = "",
            offset = {
                pos_x = -20557,
                pos_y = 1303,
                pos_z = 28453
            },
            parent_index = {
                5
            },
            parent_transform_name = {

            },
            rotate = {
                pos_x = 2704092,
                pos_y = 3561593,
                pos_z = 38376
            }
        },
        {
            build_id = 1001,
            child_list = {

            },
            connect_node = "",
            connect_point = {

            },
            index = 5,
            node_name = "",
            offset = {
                pos_x = 0,
                pos_y = 0,
                pos_z = 0
            },
            parent_index = {

            },
            parent_transform_name = {

            },
            rotate = {
                pos_x = 0,
                pos_y = 0,
                pos_z = 0
            }
        },
        {
            build_id = 1003,
            child_list = {

            },
            connect_node = "",
            connect_point = {
                {
                    child_bone_name = "ConnectPoint_14",
                    parent_bone_name = "ConnectPoint_1",
                    point_type = "1"
                }
            },
            index = 6,
            node_name = "",
            offset = {
                pos_x = -7,
                pos_y = 2780,
                pos_z = -27
            },
            parent_index = {
                5
            },
            parent_transform_name = {

            },
            rotate = {
                pos_x = 6,
                pos_y = 41912,
                pos_z = -50
            }
        }
    }
}
local testPos = {x = 2360,y = 106,z = 1487}
local testRotate = {x =0,y =36,z = 0}
local cache = {}
local index = 0
function BuildController:TempCreateBlueprint(tempConfig, position, rotation)
    index = index + 1
    local t = { tempConfig = tempConfig  or testConfig, position = position, rotation = rotation, _index = index }
    table.insert(cache, t)
    self:TryCreateNext()
    return index
end

function BuildController:TryCreateNext()
    if not self.noBlueprintOnCreate or #cache <= 0 then
        return
    end
    self.noBlueprintOnCreate = false
    local t = table.remove(cache, 1)
    local tempConfig = t.tempConfig
    local position = t.position
    local rotation = t.rotation
    self.curLocalIndex = t._index

    self.curBuildconfig = tempConfig
    for _, node in pairs(self.curBuildconfig.nodes) do
        local config = BuildData[node.build_id]
        self.buildIdList_temp[node.index] = config.instance_id
    end

    self.TempRotationObj_X = GameObject("RotationObj_X")
    self.TempRotationObj_X_T = self.TempRotationObj_X.transform
    _UnityUtils.SetPosition(self.TempRotationObj_X_T, position.x, position.y, position.z)
    _UnityUtils.SetEulerAngles(self.TempRotationObj_X_T, rotation.x, rotation.y, rotation.z)

    --先加载
    for index, entityId in pairs(self.buildIdList_temp) do
        Fight.Instance.clientFight.assetsNodeManager:LoadEntity(entityId, function()
            self:TempLoadResource(index, entityId)
        end)
    end
end


--资源加载完毕，加载实体
function BuildController:TempLoadResource(index, entityId)
    if not TableUtils.ContainValue(self.buildIdList_temp, entityId) then
        return
    end

    local instanceId = BF.CreateEntity(entityId, nil, 0, 0, 0)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    entity.clientTransformComponent:AddRigidBody()
    entity.jointComponent.initControl = true
    EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, true)
    entity.clientTransformComponent:SetLuaControlEntityMove(true)
    entity.clientTransformComponent:SetRigidBodyIsKinematic(true)


    local rootQ = self.TempRotationObj_X_T.rotation
    local config = self.curBuildconfig.nodes[index]
    self.tempPosition:Set(config.offset.pos_x / 10000, config.offset.pos_y / 10000, config.offset.pos_z / 10000)
    local pos = self.TempRotationObj_X_T:TransformPoint(self.tempPosition)
    entity.transformComponent:SetPosition(pos.x, pos.y, pos.z)
    _UnityUtils.SetPosition(entity.clientTransformComponent.transform, pos.x, pos.y, pos.z)
    self.tempQuaternion:SetEuler(config.rotate.pos_x / 10000, config.rotate.pos_y / 10000, config.rotate.pos_z / 10000)
    local q = rootQ * self.tempQuaternion
    entity.transformComponent:SetRotation(q)
    _UnityUtils.SetRotation(entity.clientTransformComponent.transform, q.x, q.y, q.z, q.w)
    entity.transformComponent:Async()
    EntityLODManager.Instance:Async(entity.instanceId)

    self.directControlEntityList_temp[index] = entity
    self.controlCount = self.controlCount + 1
    table.insert(self.allControlEntityList_temp, entity.instanceId)
    if self.controlCount == #self.buildIdList_temp then
        self:OnTempCreateDone()
    end
end

--全部建造物加载完毕
function BuildController:OnTempCreateDone()
    for _, entity in ipairs(self.directControlEntityList_temp) do
        entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
        entity.clientTransformComponent:SetLuaControlEntityMove(false)
    end
    --根据蓝图记录的父子关系，设置关节
    for index, entity in ipairs(self.directControlEntityList_temp) do
        local config = self.curBuildconfig.nodes[index]
        for _index, parent_index in pairs(config.parent_index) do
            if self.directControlEntityList_temp[parent_index] then
                local connectPointConfig = config.connect_point[_index]
                self.directControlEntityList_temp[parent_index].jointComponent:OnAddChild(entity, connectPointConfig.point_type, connectPointConfig.parent_bone_name, connectPointConfig.child_bone_name)
            end
        end
        if #config.parent_index == 0 then
            self.temp_takeMainEntity = entity
        end
        EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, true)
    end


    Fight.Instance.entityManager:CallBehaviorFun("TempCreateBluePrint", self.curLocalIndex, self.temp_takeMainEntity.instanceId)

    LuaTimerManager.Instance:AddTimer(1, 0.1, function()
        self:OnTempStop()
    end)
end

function BuildController:OnTempStop()
    for k, entity in pairs(self.directControlEntityList_temp) do
        entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
        entity.clientTransformComponent:SetLuaControlEntityMove(false)
        --entity.jointComponent:ExitControlState()
        EventMgr.Instance:Fire(EventName.BuildControlEntity, entity.instanceId, false)
    end
    TableUtils.ClearTable(self.directControlEntityList_temp)

    if not self.temp_takeMainEntity.jointComponent.jointCtrl then
        local ctrl = Fight.Instance.objectPool:Get(BaseJointCtrl)
        ctrl:Init(Fight.Instance, self.temp_takeMainEntity)
    end

    self.temp_takeMainEntity = nil
    if self.TempRotationObj_X then
        GameObject.Destroy(self.TempRotationObj_X)
    end
    self.controlCount = 0
    TableUtils.ClearTable(self.buildIdList_temp)
    TableUtils.ClearTable(self.directControlEntityList_temp)
    self.noBlueprintOnCreate = true
    self:TryCreateNext()
end
--#endregion

function BuildController:CheckGroundOnControl()
    local underEntityIds = Fight.Instance.physicsTerrain:CheckUnderfootMovePlatform(self.ctrlEntity.transformComponent.position, self.ctrlEntity)
    for _, Id in pairs(underEntityIds) do
        local entity = Fight.Instance.entityManager:GetEntity(Id)
        if entity and entity.jointComponent then
            for k, v in pairs(self.allControlEntityList) do
                if entity.instanceId == v then
                    return true
                end
            end
        end
    end
    return false
end