---@class JointComponent
JointComponent = BaseClass("JointComponent", PoolBaseClass)

local BF = BehaviorFunctions
local FindByInstanceId = Config.DataBuild.FindbyInstanceId
local tempVector3 = Vec3.New()

function JointComponent:__init()
end

---@param fight Fight
---@param entity Entity
function JointComponent:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.config = entity:GetComponentConfig(FightEnum.ComponentType.Joint)
    self.adsorbDistance = (self.config.adsorbDistance or 4) * (self.config.adsorbDistance or 4)
    self.parentIdList = {}
    self.childIdList = {}
    self.fixedJointCmpList = {}
    self.connectNodeList = {}
    self.connectNodeType = {}
    self.isActive = false
    self.delayInitControl = false
    self.initControl = false
    self.IsCanJoint = self.config.IsCanJoint
    self.buildConfig = BuildConfig.GetBuildConfigByEntityId(entity.entityId)
    self.costEnergy = self.buildConfig and (self.buildConfig.cost_energy / 30) or 0

    EventMgr.Instance:AddListener(EventName.WorldInteractClick, self:ToFunc("WorldInteractClick"))
end

function JointComponent:LateInit()
    self.entityTransform = self.entity.clientTransformComponent.transform
    self.JointBuildSetting = self.entity.clientTransformComponent.gameObject:GetComponent(JointBuildSetting)
    if self.entity.partComponent and self.entity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.DisplayPartner then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.AirWall)
    end
end

function JointComponent:Update()
    if not self.initControl and not self.delayInitControl then
        if not self.config.IsSetKinematic then
            self.entity.clientTransformComponent:SetRigidBodyIsKinematic(false)
            self.entity.clientTransformComponent:SetLuaControlEntityMove(false)
        end
        if not self.jointCtrl then
            local ctrl = Fight.Instance.objectPool:Get(BaseJointCtrl)
            ctrl:Init(self.fight, self.entity)
        end
        self.initControl = true
    end

    if self.config.IsAutoCheckAngle then
        self:CheckAngle()
    end

    if not self.isActive or self.costEnergy <= 0 then
        return
    end
    if not BehaviorFunctions.CostPlayerElectricity(self.costEnergy) then
        self:SetActive({ isActive = false })
    end
end

function JointComponent:WorldInteractClick(uniqueId, instanceId)
    --TODO 2080109仅为临时配置，版本后在组件里新增设置或通过tag区分
    if self.entity.entityId == 2080103 or self.entity.entityId == 2080109 then
        return
    end
	if self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.DisplayPartner then
		return
	end

    if instanceId == self.entity.instanceId then
        if not self.isActive then
            MsgBoxManager.Instance:ShowTips(TI18N("激活"))
        else
            MsgBoxManager.Instance:ShowTips(TI18N("关闭"))
        end
        self:CallFunctionAtAll("SetActive", { isActive = not self.isActive }, nil)
    end
end

function JointComponent:SetActive(params)
    self.isActive = params.isActive
    Fight.Instance.entityManager:CallBehaviorFun("OnActiveJointEntity", self.entity.instanceId, self.isActive)
    if self.isActive then
        self.entity.clientTransformComponent:SetLuaControlEntityMove(false)
    end
end

---@public 添加子节点
---@param funName string 函数名
---@param params table 参数组
---@param ignoreId number 外部调用时留空
function JointComponent:CallFunctionAtAll(funName, params, ignoreId)
    self[funName](self, params)
    for k, v in pairs(self.parentIdList) do
        if v ~= ignoreId then
            local entity = BF.GetEntity(v)
            entity.jointComponent:CallFunctionAtAll(funName, params, self.entity.instanceId)
        end
    end

    for k, v in pairs(self.childIdList) do
        if v ~= ignoreId then
            local entity = BF.GetEntity(v)
            entity.jointComponent:CallFunctionAtAll(funName, params, self.entity.instanceId)
        end
    end
end

---@public 检查Entity是否已在这个拼接物上
---@param instanceId number instanceId
---@param ignoreId number 外部调用时留空
function JointComponent:CheckEntityHasJoint(instanceId, ignoreId)
    for k, v in pairs(self.parentIdList) do
        if v ~= ignoreId then
            if v == instanceId then
                return true
            else
                local entity = BF.GetEntity(v)
                if entity.jointComponent:CheckEntityHasJoint(instanceId, self.entity.instanceId) then
                    return true
                end
            end
        end
    end

    for k, v in pairs(self.childIdList) do
        if v ~= ignoreId then
            if v == instanceId then
                return true
            else
                local entity = BF.GetEntity(v)
                if entity.jointComponent:CheckEntityHasJoint(instanceId, self.entity.instanceId) then
                    return true
                end
            end
        end
    end
    return false
end

---@public 检查Entity是否已在这个拼接物上
---@param jointList table
---@param ignoreId number 外部调用时留空
function JointComponent:GetAllJointId(jointList, ignoreId)
    for k, v in pairs(self.parentIdList) do
        if v ~= ignoreId then
            local entity = BF.GetEntity(v)
            entity.jointComponent:GetAllJointId(jointList, self.entity.instanceId)
        end
    end

    for k, v in pairs(self.childIdList) do
        if v ~= ignoreId then
            local entity = BF.GetEntity(v)
            entity.jointComponent:GetAllJointId(jointList, self.entity.instanceId)
        end
    end

    table.insert(jointList, self.entity.instanceId)
end

--记录吸附关系，设置点状态，更新结构树，通知parent
---@public 添加子节点
---@param child Entity 子实体
function JointComponent:OnAddChild(child, pointChoseType, parentBoneName, childBoneName)
    child.jointComponent:OnJointToParent(self.entity, pointChoseType, parentBoneName, childBoneName)
    table.insert(self.childIdList, child.instanceId)
    self.connectNodeList[child.instanceId] = { parentBoneName, childBoneName, pointChoseType }
    if pointChoseType == FightEnum.BuildConnectPointType.PrefabPoint and not UtilsBase.IsNull(self.JointBuildSetting) then
        self.JointBuildSetting:SetConnectPointName(parentBoneName, childBoneName)
    end
    if self.config.IsCallBehavior then
        self.fight.entityManager:CallBehaviorFun("OnBuildConnect", self.entity.instanceId, child.instanceId, parentBoneName, childBoneName)
    end
end

---@private 记录父节点
function JointComponent:OnJointToParent(parent, pointChoseType, parentBoneName, childBoneName)
    local FixedJointCmp
    if self.entity.entityId == 2080106 then
        if pointChoseType == FightEnum.BuildConnectPointType.PrefabPoint then
            local Axle = self.entity.clientTransformComponent:GetTransform("Axle")
            FixedJointCmp = Axle.gameObject:AddComponent(FixedJoint)
        else
            local boneTransform = self.entity.clientTransformComponent:GetTransform(childBoneName)
            FixedJointCmp = boneTransform.gameObject:AddComponent(FixedJoint)
        end
    else
        FixedJointCmp = self.entity.clientTransformComponent.gameObject:AddComponent(FixedJoint)
    end

    if parent.entityId == 2080106 and pointChoseType ~= FightEnum.BuildConnectPointType.PrefabPoint then
        FixedJointCmp.connectedBody = parent.clientTransformComponent:GetTransform(parentBoneName):GetComponent(Rigidbody)
    else
        FixedJointCmp.connectedBody = parent.clientTransformComponent.rigidbody
    end
    ---怎么判断连接点在哪个刚体上？ 先默认连接到转轴吧

    self.fixedJointCmpList[parent.instanceId] = FixedJointCmp

    table.insert(self.parentIdList, parent.instanceId)
    self.connectNodeList[parent.instanceId] = { childBoneName, parentBoneName, pointChoseType }

    --获取父节点的激活状态，并传递给自己的其他父子节点
    self:CallFunctionAtAll("SetActive", { isActive = parent.jointComponent.isActive }, parent.instanceId)

    if not UtilsBase.IsNull(self.JointBuildSetting) then
        self.JointBuildSetting:SetConnectPointName(childBoneName, parentBoneName)
    end
    if self.config.IsCallBehavior then
        self.fight.entityManager:CallBehaviorFun("OnBuildConnect", self.entity.instanceId, parent.instanceId, childBoneName, parentBoneName)
    end
end

---@public 断开和所有节点的连接
function JointComponent:CancelAllJoint(isCache, type)
    type = type or FightEnum.BuildDisConnectType.Player
    for _, v in pairs(self.parentIdList) do
        if BF.CheckEntity(v) then
            local entity = BF.GetEntity(v)
            entity.jointComponent:OnChildCancelJoint(self.entity.instanceId)
            local t = self.JointBuildSetting:GetTransform(self.connectNodeList[v][1])
            if t and t.position then
                local buildEffect = Fight.Instance.entityManager:CreateEntity(1000000045)
                buildEffect.transformComponent:SetPosition(t.position.x, t.position.y, t.position.z)
            end
            if self.jointCtrl then
                self.jointCtrl:RemoveBuild(entity, nil, true)
            end
            if self.config.IsCallBehavior then
                self.fight.entityManager:CallBehaviorFun("OnBuildDisconnect", self.entity.instanceId, v, self.connectNodeList[v][1], self.connectNodeList[v][2], type)
            end
        end
        GameObject.Destroy(self.fixedJointCmpList[v])
        if not UtilsBase.IsNull(self.JointBuildSetting) then
            self.JointBuildSetting:RemoveConnectPointName(self.connectNodeList[v][1])
        end
    end

    for _, v in pairs(self.childIdList) do
        if BF.CheckEntity(v) then
            local entity = BF.GetEntity(v)
            entity.jointComponent:OnParentCancelJoint(self.entity.instanceId)
            local t = self.JointBuildSetting:GetTransform(self.connectNodeList[v][1])
            if t and t.position then
                local buildEffect = Fight.Instance.entityManager:CreateEntity(1000000045)
                buildEffect.transformComponent:SetPosition(t.position.x, t.position.y, t.position.z)
            end
            if self.jointCtrl then
                self.jointCtrl:RemoveBuild(entity, nil, true)
            end
            if self.config.IsCallBehavior then
                self.fight.entityManager:CallBehaviorFun("OnBuildDisconnect", self.entity.instanceId, v, self.connectNodeList[v][1], self.connectNodeList[v][2], type)
            end
        end
        if not UtilsBase.IsNull(self.JointBuildSetting) then
            self.JointBuildSetting:RemoveConnectPointName(self.connectNodeList[v][1])
        end
    end
    if isCache then
        if self.jointCtrl then
            self.jointCtrl:OnEntityRemove(self.entity.instanceId)
        end
    end

    TableUtils.ClearTable(self.parentIdList)
    TableUtils.ClearTable(self.childIdList)
    TableUtils.ClearTable(self.fixedJointCmpList)
    TableUtils.ClearTable(self.connectNodeList)
end

---@private
function JointComponent:OnChildCancelJoint(instanceId)
    for k, v in pairs(self.childIdList) do
        if v == instanceId then
            if not UtilsBase.IsNull(self.JointBuildSetting) then
                self.JointBuildSetting:RemoveConnectPointName(self.connectNodeList[v][1])
            end
            self.connectNodeList[v] = nil
            table.remove(self.childIdList, k)
            return
        end
    end
end

---@private
function JointComponent:OnParentCancelJoint(instanceId)
    if self.fixedJointCmpList[instanceId] then
        GameObject.Destroy(self.fixedJointCmpList[instanceId])
        self.fixedJointCmpList[instanceId] = nil
    end

    for k, v in pairs(self.parentIdList) do
        if v == instanceId then
            if not UtilsBase.IsNull(self.JointBuildSetting) then
                self.JointBuildSetting:RemoveConnectPointName(self.connectNodeList[v][1])
            end
            self.connectNodeList[v] = nil
            table.remove(self.parentIdList, k)
            return
        end
    end
end

---@public 获取蓝图数据
function JointComponent:GetBluePrintNodesData()
    --获取的只是初步数据，还没确定根节点和相应的偏移
    local data = self:GetConnectInfo()
    local rootInstanceId = 0
    --遍历一遍，赋予index，替换父子index的索引
    for k, v in pairs(data) do
        v.index = k
        --替换父index的索引
        for _, _v in pairs(data) do
            for key, instanceId in pairs(_v.parent_index) do
                if instanceId == v.instanceId then
                    _v.parent_index[key] = v.index
                    break
                end
            end
        end
        if #v.parent_index == 0 then
            rootInstanceId = v.instanceId
        end
    end
    --根据根节点计算偏移值和旋转值
    local rootEntity = BF.GetEntity(rootInstanceId)
    local rootTransform = rootEntity.clientTransformComponent.transform
    local rotate = Quaternion.Inverse(rootTransform.rotation)
    --这个时候记录下来的是包含了旋转影响的偏移
    for _, v in pairs(data) do
        if v.instanceId ~= rootInstanceId then
            local childEntity = BF.GetEntity(v.instanceId)
            local offset = rootTransform:InverseTransformPoint(childEntity.clientTransformComponent.transform.position)
            v.offset.pos_x = math.floor(offset.x * 10000)
            v.offset.pos_y = math.floor(offset.y * 10000)
            v.offset.pos_z = math.floor(offset.z * 10000)
            local euler = (rotate * childEntity.clientTransformComponent.transform.rotation).eulerAngles
            v.rotate.pos_x = math.floor(euler.x * 10000)
            v.rotate.pos_y = math.floor(euler.y * 10000)
            v.rotate.pos_z = math.floor(euler.z * 10000)
        end
        v.instanceId = nil
    end

    --LogTable("blue print", data)
    return data
end

---@private
function JointComponent:GetConnectInfo(ignoreId)
    --递归调用父子节点
    local blurPrintData = {}

    local parentBuildId = {}
    for k, v in pairs(self.parentIdList) do
        local entity = BF.GetEntity(v)
        if v ~= ignoreId then
            local data = entity.jointComponent:GetConnectInfo(self.entity.instanceId)
            TableUtils.InsertTable(blurPrintData, data)
        end
        table.insert(parentBuildId, entity.instanceId)
    end

    for k, v in pairs(self.childIdList) do
        if v ~= ignoreId then
            local entity = BF.GetEntity(v)
            local data = entity.jointComponent:GetConnectInfo(self.entity.instanceId)
            TableUtils.InsertTable(blurPrintData, data)
        end
    end

    local connect_point = {}
    for k, v in ipairs(parentBuildId) do
        connect_point[k] = {
            parent_bone_name = self.connectNodeList[v][2],
            child_bone_name = self.connectNodeList[v][1],
            point_type = self.connectNodeList[v][3],
        }
    end

    local data = {
        index = 0,
        build_id = FindByInstanceId[self.entity.entityId][1],
        offset = { pos_x = 0, pos_y = 0, pos_z = 0 },
        rotate = { pos_x = 0, pos_y = 0, pos_z = 0 },
        parent_index = parentBuildId,
        connect_point = connect_point,
        instanceId = self.entity.instanceId
    }

    table.insert(blurPrintData, data)
    return blurPrintData
end

--是否在拼接状态中
function JointComponent:IsOnJointState()
    return #self.parentIdList > 0 or #self.childIdList > 0
end

function JointComponent:GetNearestPoint(entity, transform)
    local distance, transform_1, transform_2
    if not UtilsBase.IsNull(self.JointBuildSetting) and not UtilsBase.IsNull(entity.jointComponent.JointBuildSetting) then
        distance, transform_1, transform_2 = self.JointBuildSetting:GetNearestPointWithOther(transform, transform_1, transform_2)
    end
    return distance, transform_1, transform_2
end

function JointComponent:SetJointCtrl(jointCtrl)
    self.jointCtrl = jointCtrl
end

function JointComponent:RemoveJointCtrl()
    self.jointCtrl = nil
end

function JointComponent:GetJointCenterPoint()
    if not self.jointCtrl then
        return self.entity.transformComponent.position
    end
    return self.jointCtrl:GetJointCenterPoint()
end

function JointComponent:CheckAngle()
    local euler = self:GetSelfEuler()
    if math.abs(euler.x) >= self.config.maxAngle or math.abs(euler.z) >= self.config.maxAngle then
        self:CancelAllJoint(false, FightEnum.BuildDisConnectType.Angle)
        return
    end
end

function JointComponent:GetSelfEuler()
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

function JointComponent:EnterControlState(isMain, inertiaTensorTimes)
    if isMain then
        self.JointBuildSetting:SetMainBuildControl(inertiaTensorTimes)
    else
        self.JointBuildSetting:SetSubBuildControl()
    end
end

function JointComponent:ExitControlState()
    self.JointBuildSetting:QuitBuildControl()
end

function JointComponent:__cache()
    self:CancelAllJoint(true)
    self.fight = nil
    self.entity = nil
    self.jointCtrl = nil
    self.entityTransform = nil
    TableUtils.ClearTable(self.connectNodeList)

    if self.fxBuildLine then
        BehaviorFunctions.ClientEffectRemoveRelation(self.fxBuildLine)
        BehaviorFunctions.RemoveEntity(self.fxBuildLine)
        self.fxBuildLine = nil
    end
    EventMgr.Instance:RemoveListener(EventName.WorldInteractClick, self:ToFunc("WorldInteractClick"))
end

function JointComponent:__delete()
    EventMgr.Instance:RemoveListener(EventName.WorldInteractClick, self:ToFunc("WorldInteractClick"))
end

function JointComponent:OnCache()
    self.fight.objectPool:Cache(JointComponent, self)
end
