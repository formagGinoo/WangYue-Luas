BuildPreviewPanel = BaseClass("BuildPreviewPanel", BasePanel)

local ScreenW = Screen.width * 0.5
local ScreenH = Screen.height * 0.5
local BuildDistance = 15
local Vector3 = Vector3
local rotation = Quat.New(0, 0, 0, 0)
local CollideCheckLayer = ~(FightEnum.LayerBit.IgonreRayCastLayer | FightEnum.LayerBit.Area | FightEnum.LayerBit.InRoom)
local LineCheckLayer = ~(FightEnum.LayerBit.IgonreRayCastLayer | FightEnum.LayerBit.Area | FightEnum.LayerBit.InRoom | FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision)
local EntityCollideCheckLayer = FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision
local extraOffset = Vec3.New(0, 0.4, 0)
local BuildData = Config.DataBuild

local AllowBuildEffect = 1000079
local NotAllowBuildEffect = 1000080
local BuildTipEffect = 1000081
local BoxBuildEffect = 1000082
local BuildRemoveEffect = 1000083

--初始化
function BuildPreviewPanel:__init()
    self:SetAsset("Prefabs/UI/Hacking/BuildPreviewPanel.prefab")
    self.screenPos = Vector3(640, 360, 0)
    self.buildItemList = {}
    self.buildPosition = Vec3.New()
    self.normalVec3 = Vec3.New()

    self.onReqBuild = false
    self.curSelectIndex = nil
    self.curSelectBuildId = nil
end

function BuildPreviewPanel:__BindListener()
    self.BuildBtn_btn.onClick:AddListener(self:ToFunc("OnClickBuild"))
    EventMgr.Instance:AddListener(EventName.RemoveHackingBuild, self:ToFunc("UpdateBuildCount"))
end

function BuildPreviewPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.RemoveHackingBuild, self:ToFunc("UpdateBuildCount"))
end

--缓存对象
function BuildPreviewPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function BuildPreviewPanel:__Create()

end

function BuildPreviewPanel:__delete()
    self.curBuildconfig = nil
end

function BuildPreviewPanel:__Hide()
    LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
    if self.previewEntity then
        BehaviorFunctions.RemoveEntity(self.previewEntity.instanceId)
    end
    self.previewEntity = nil
end

function BuildPreviewPanel:__ShowComplete()
    --临时逻辑
    self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.02, self:ToFunc("Update"))

    self:UpdateBuildList()
    self.maxHackingBuildCount = math.floor(BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingBuildCount))
    self:UpdateBuildCount()
end

--更新蓝图列表
function BuildPreviewPanel:UpdateBuildList()
    --应该是拥有的蓝图列表，先用全部数据显示
    local index = 1
    for k, v in pairs(BuildData.Find) do
        local index_temp = index
        local item = self.buildItemList[index] or self:getBuildItem()
        local data = BuildData.Find[k]
        SingleIconLoader.Load(item.Icon, data.icon)
        item.Cost_txt.text = data.cost_count
        item.Limit_txt.text = "x" .. data.count_limit
        item.Select:SetActive(false)

        ---长按显示详情
        local dragBehaviour = item.Bg:AddComponent(UIDragBehaviour)
        dragBehaviour.onPointerDown = function()
            LuaTimerManager.Instance:RemoveTimer(self.longTouchTimer)
            self.longTouchTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function()
                SingleIconLoader.Load(self.DetailIcon, data.icon)
                self.DetailCost_txt.text = data.cost_count
                self.DetailLimit_txt.text = data.count_limit
                self.Detail:SetActive(true)
                self.isShowDetail = true
            end)
        end
        dragBehaviour.onPointerUp = function()
            LuaTimerManager.Instance:RemoveTimer(self.longTouchTimer)
            if self.isShowDetail then
                self.BuildPreviewPanel_Detail_Exit:SetActive(true)
                self.isShowDetail = false
            else
                self:OnSelectBuilding(index_temp, k)
            end
        end
        self.buildItemList[index] = item

        if index == 1 and not self.curBuildconfig then
            self:OnSelectBuilding(index_temp, k)
        else
            if k == self.curBuildconfig.build_id then
                self:OnSelectBuilding(index_temp, k)
            end
        end
        index = index + 1
    end
end

---长按展示详细介绍
function BuildPreviewPanel:ShowDetailInfo(isShow)

end

function BuildPreviewPanel:Update()
    if not self.curBuildconfig then
        return
    end
    local hitList = CustomUnityUtils.GetScreenRayWorldHits(CameraManager.Instance.mainCameraComponent, ScreenW, ScreenH, BuildDistance, LineCheckLayer)
    rotation:Set()

    local isHit = false
    local minDistance = BuildDistance
    local hitIndex, position
    local cur_entityInsId
    if hitList and hitList.Length > 0 then
        for i = 0, hitList.Length - 1 do
            local gameObject = hitList[i].collider.gameObject
            cur_entityInsId = gameObject:GetInstanceID() or "null"
            if hitList[i].distance < minDistance then
                minDistance = hitList[i].distance
                isHit = true
                hitIndex = i
            end
        end
    else
        position = CustomUnityUtils.GetScreenRayWorldPos(CameraManager.Instance.mainCameraComponent, ScreenW, ScreenH, BuildDistance, 0, LineCheckLayer)
    end

    if isHit then
        position = hitList[hitIndex].point
        self.normalVec3:Set(hitList[hitIndex].normal.x, hitList[hitIndex].normal.y, hitList[hitIndex].normal.z)
        self.buildPosition:Set(position.x, position.y, position.z)
    end

    self.canBuild = isHit
    if isHit and self.curBuildconfig.preview_type == FightEnum.BuildPreviewType.adheringSurface then
        rotation:SetFromToRotation1(Vec3.up, self.normalVec3)
        if isHit and (self.normalVec3.y > 0.9 or self.normalVec3.y < -0.9) then
            --TODO 面向玩家
            local euler = rotation:ToEulerAngles()
            --rotation =  rotation * createRotation:SetEuler(euler.x , entity.transformComponent.rotation:ToEulerAngles().y, euler.z)
        end
        local isCollide, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapBoxNonAllocNearPos(position, rotation, self.curBuildconfig.size.x, self.curBuildconfig.size.y, self.curBuildconfig.size.z, EntityCollideCheckLayer)
        self.canBuild = not isCollide
        position = position
    elseif isHit and self.curBuildconfig.preview_type == FightEnum.BuildPreviewType.avoidCollisions then
        position = position + extraOffset
        self.buildPosition.y = self.buildPosition.y + extraOffset.y
        --检测接触点法线方向
        local angle = Vec3.Angle(Vec3.up, self.normalVec3)
        if angle < 30 then
            local height = UnityUtils.GetTerrainHeight(position.x, position.y, position.z, CollideCheckLayer)
            if height < 1 then
                local isCollide, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapBoxNonAllocNearPos(position, rotation, self.curBuildconfig.size.x, self.curBuildconfig.size.y, self.curBuildconfig.size.z, CollideCheckLayer)
                self.canBuild = not isCollide
            end
        else
            self.canBuild = false
        end
    end

    self:UpdatePreviewState(position, rotation, isHit, self.canBuild)

    --更新UI
    local haveCount = HackingConfig.GetPowerCount()
    self.CostCount_txt.text = self.curBuildconfig.cost_count .. "/" .. haveCount
end

function BuildPreviewPanel:UpdatePreviewState(position, rotation, isShow, canBuild)
    if not self.previewEntity then
        self["22133"]:SetActive(false)
        return
    end
    self.previewEntity.transformComponent:SetPosition(position.x, position.y, position.z)
    self.previewEntity.transformComponent:SetRotation(rotation)
    self.previewEntity.clientEntity.clientTransformComponent:SetActive(isShow)

    BehaviorFunctions.RemoveBuffByKind(self.previewEntity.instanceId, 1010)

    self["22133"]:SetActive(canBuild)
    if canBuild then
        BehaviorFunctions.DoMagic(1, self.previewEntity.instanceId, AllowBuildEffect)
    else
        BehaviorFunctions.DoMagic(1, self.previewEntity.instanceId, NotAllowBuildEffect)
    end
end

function BuildPreviewPanel:OnSelectBuilding(index, build_id)
    ---更新UI显示
    self.curBuildconfig = BuildData.Find[build_id]
    for i, v in pairs(self.buildItemList) do
        if i == index then
            v.Select:SetActive(true)
            v.BuildPreviewPanel_BluePrint_Open:SetActive(true)
        else
            v.Select:SetActive(false)
        end
    end
    self.curSelectIndex = index
    self.curSelectBuildId = build_id

    if self.previewEntity and self.previewEntity.entityId == self.curBuildconfig.instance_id then
        return
    end

    ---移除原来的预览
    if self.previewEntity then
        BehaviorFunctions.RemoveBuffByKind(self.previewEntity.instanceId, 1010)
        BehaviorFunctions.RemoveEntity(self.previewEntity.instanceId)
    end

    if self.onReqBuild then
        return
    end

    self.previewEntity = nil
    ---创建新的预览
    Fight.Instance.clientFight.assetsNodeManager:LoadEntity(self.curBuildconfig.instance_id, function()
        local instanceId = BehaviorFunctions.CreateEntity(self.curBuildconfig.instance_id, nil, 0, 0, 0)
        self.previewEntity = Fight.Instance.entityManager:GetEntity(instanceId)
        self.previewEntityClientTransformComponent = self.previewEntity.clientEntity.clientTransformComponent
        local collider = self.previewEntityClientTransformComponent:GetTransform("Collider")
        collider.gameObject:SetActive(false)
        ---设置成不自动销毁
        self.previewEntity.timeoutDeathComponent.remainingFrame = 99999999
        self.previewEntity.clientEntity.clientTransformComponent:SetActive(false)
    end)
end

function BuildPreviewPanel:OnClickCancel()
    PanelManager.Instance:ClosePanel(BuildPreviewPanel)
end

function BuildPreviewPanel:OnClickBuild()
    --放置合法性检测
    if not self.canBuild then
        MsgBoxManager.Instance:ShowTips("建造失败：当前地形无法建造")
        self:OnBuildFail()
        return
    end
    --材料数量检测
    local haveCount = HackingConfig.GetPowerCount()
    if haveCount < self.curBuildconfig.cost_count then
        MsgBoxManager.Instance:ShowTips("建造失败：缺少资源")
        self:OnBuildFail()
        return
    end

    --先把预览的删除,避免复制时污染
    if self.previewEntity then
        Fight.Instance.entityManager:RemoveEntity(self.previewEntity.instanceId)
        self.previewEntity = nil
    end
    self.onReqBuild = true

    local func = function()
        --放置数量检测
        local typeCount = mod.HackingCtrl:GetTypeBuildCount(self.curBuildconfig.build_id)
        if typeCount >= self.curBuildconfig.count_limit then
            mod.HackingCtrl:RemoveBuild(self.curBuildconfig.build_id)
        else
            local totalCount = mod.HackingCtrl:GetTotalBuildCount()
            if totalCount >= self.maxHackingBuildCount then
                mod.HackingCtrl:RemoveBuild()
            end
        end

        local buildPosition = self.buildPosition:Clone()
        local buildRotation = rotation:Clone()

        local instanceId = BehaviorFunctions.CreateEntity(self.curBuildconfig.instance_id, nil, buildPosition.x, buildPosition.y, buildPosition.z)
        local entity = Fight.Instance.entityManager:GetEntity(instanceId)
        UnityUtils.SetRotation(entity.clientEntity.clientTransformComponent:GetTransform(), buildRotation.x, buildRotation.y, buildRotation.z, buildRotation.w)
        entity.clientEntity.clientTransformComponent:GetTransform("Collider").gameObject:SetActive(true)
        --TODO 临时逻辑，下版本改为配置
        if self.curBuildconfig.instance_id == 2030501 then
            BehaviorFunctions.DoMagic(1, entity.instanceId, BoxBuildEffect)
        elseif self.curBuildconfig.instance_id == 2030502 then
            BehaviorFunctions.DoMagic(1, entity.instanceId, 1000085)
            entity.timeoutDeathComponent.remainingFrame = 1800
            entity.timeoutDeathComponent.removeDelayFrame = 21
        end
        --根据加成，重新设置存在时间

        mod.HackingCtrl:AddBuild(self.curBuildconfig.build_id, entity.instanceId)
        self:UpdateBuildCount()

        self.BuildPreview_BuildBtn_Click:SetActive(true)

        --创建完毕后，重新生成预览
        self.onReqBuild = false
        self:OnSelectBuilding(self.curSelectIndex, self.curSelectBuildId)
    end

    --材料消耗，等待回包
    mod.HackingCtrl:ReqCostPower(self.curBuildconfig.build_id, func)
end

function BuildPreviewPanel:getBuildItem()
    local obj = self:PopUITmpObject("BluePrint")
    obj.objectTransform:SetParent(self.Content.transform)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    obj.objectTransform:SetActive(true)
    return obj
end

--建造总数
function BuildPreviewPanel:UpdateBuildCount()
    local curCount = mod.HackingCtrl:GetTotalBuildCount()
    self.BuildCount_txt.text = "已建造：" .. curCount .. "/" .. self.maxHackingBuildCount
    self:UpdateCanBuildCount()
end

--更新可建造数量,创建和销毁时都要调用
function BuildPreviewPanel:UpdateCanBuildCount()
    local index = 1
    for k, v in pairs(BuildData.Find) do
        local item = self.buildItemList[index]
        local data = BuildData.Find[k]
        local typeCount = mod.HackingCtrl:GetTypeBuildCount(data.build_id)
        item.Limit_txt.text = typeCount .. "/" .. data.count_limit
        index = index + 1
    end
end

--点击按钮后建造成功
function BuildPreviewPanel:OnBuildSuccess()

end

--点击按钮后建造失败
function BuildPreviewPanel:OnBuildFail()
    self.BuildPreview_BuildBtn_fail:SetActive(true)
    self.buildItemList[self.curSelectIndex]["22132"]:SetActive(false)
    self.buildItemList[self.curSelectIndex]["22132"]:SetActive(true)
end


