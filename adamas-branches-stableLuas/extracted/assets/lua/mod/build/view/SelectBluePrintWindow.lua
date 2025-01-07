SelectBluePrintWindow = BaseClass("SelectBluePrintWindow", BaseWindow)

local BF = BehaviorFunctions
local BuildData = Config.DataBuild.Find
local BuildDataByEntityId = Config.DataBuild.FindbyInstanceId

local toggleList = {
    All = 1, --按列表
    UsesNumber = 2, --按使用频率排序
    Record = 3,
    Delete = 4,
}

--#region UI操作
function SelectBluePrintWindow:__init()
    self:SetAsset("Prefabs/UI/Build/SelectBluePrintWindow.prefab")
    self.screenPos = Vector3(640, 360, 0)
    self.item_data_list = {}

    self.buildItemList = {}
    self.buildItemCache = {}

    self.curSelectIndex = nil
    self.sourceObjPool = {}

    self.CurToggleType = nil
    self.isSelectBuilding = false
    self.isPC = UtilsUI.CheckPCPlatform()
end

function SelectBluePrintWindow:__BindListener()
    self:__AddUIListener()
end

function SelectBluePrintWindow:__AddUIListener()
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"))
    self.Type1_tog.onValueChanged:AddListener(function(isEnter)
        self:OnToggle_Type(toggleList.All, isEnter)
    end)
    self.Type2_tog.onValueChanged:AddListener(function(isEnter)
        self:OnToggle_Type(toggleList.UsesNumber, isEnter)
    end)
    self.Type3_tog.onValueChanged:AddListener(function(isEnter)
        self:OnToggle_Type(toggleList.Record, isEnter)
    end)
    self.Type4_tog.onValueChanged:AddListener(function(isEnter)
        self:OnToggle_Type(toggleList.Delete, isEnter)
    end)

    --self.BlueprintNameInputField = self.SavePopupEditor.transform:GetComponent(TMP_InputField)
end

function SelectBluePrintWindow:OnToggle_Type(typeId, isEnter)
    if self.CurToggleType == typeId then
        return
    end
    self.CurToggleType = typeId
    for i = 1, 4 do
        UtilsUI.SetTextColor(self["TypeText" .. i .. "_txt"], i == self.CurToggleType and "#000000" or "#FFFFFF")
        self["SelectBg" .. i]:SetActive(i == self.CurToggleType)
    end

    self:OnBuildListUpdate()
end

function SelectBluePrintWindow:__Show()
    self:SetBlurBack()
    self:InitBuildItemPosCalculateInfo()
end

function SelectBluePrintWindow:__ShowComplete()
    self.maxHackingBuildCount = math.floor(BF.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingBuildCount))
    self:OnToggle_Type(toggleList.All, true)
    self:InitCurrencyBar(8)
end

function SelectBluePrintWindow:InitBuildItemPosCalculateInfo()
    local viewPortRect = self.BluePrintListViewport_rect.rect
    local blueListContentComponent = self.Content:GetComponent(HorizontalLayoutGroup)
    local padding = blueListContentComponent.padding
    local buildItemRect = self.BluePrint_rect.rect
    self.blueListContentPadding = { left = padding.left, right = padding.right, top = padding.top, bottom = padding.bottom, spacing = blueListContentComponent.spacing }
    self.bluePrintListViewMaskSize = { width = viewPortRect.width, height = viewPortRect.height }
    self.buildItemSize = { width = buildItemRect.width, height = buildItemRect.height }
end

function SelectBluePrintWindow:CheckCanBuild(data)
    --检查材料是否够用
    --local haveCount = BuildConfig.GetPowerCount()
    --local costItem = haveCount > 0 and ItemConfig.GetItemConfig(8) or ItemConfig.GetItemConfig(13)
    for _, v in pairs(data.cost_list) do
        local count =  mod.BagCtrl:GetItemCountById(v[1])
        if not count or count < v[2] then
            return false
        end
    end

    return true
end

function SelectBluePrintWindow:OnBuildListUpdate()
    self:UpdateBluePrintList()
    self:UpdateBuildList()
end

function SelectBluePrintWindow:UpdateBluePrintList()
    self.item_data_list = {}

    local createItemData = function(id, info)
        local data = BuildData[id]
        if not data then
            local parentData
            data = { build_id = info.blueprint_id, name = info.name, cost_list = {} }
            for _, v in pairs(info.nodes) do
                local childData = BuildData[v.build_id]
                if #v.parent_index == 0 then
                    parentData = childData
                end

                for _, cost in pairs(childData.cost_list) do
                    local isAdd = false
                    for i, _cost in pairs(data.cost_list) do
                        if _cost[1] == cost[1] then
                            data.cost_list[i] = { cost[1], _cost[2] + cost[2] }
                            isAdd = true
                            break
                        end
                    end
                    if not isAdd then
                        data.cost_list[#data.cost_list + 1] = { cost[1], cost[2] }
                    end
                end
            end
            data.icon = parentData.icon
        end
        return data
    end

    if self.CurToggleType == toggleList.All or self.CurToggleType == toggleList.Delete then
        local CanBuildList = {}
        local NotBuildList = {}
        --默认解锁的图纸
        if self.CurToggleType ~= toggleList.Delete then
            for k, v in pairs(BuildData) do
                v.type = FightEnum.BuildType.Single
                if v.condition == 0 or TableUtils.ContainValue(mod.BuildCtrl.unlock_build_list, v.build_id) then
                    if self:CheckCanBuild(v) then
                        table.insert(CanBuildList, v)
                    else
                        table.insert(NotBuildList, v)
                    end
                end
            end
        end

        --已拥有蓝图
        for _, v in pairs(mod.BuildCtrl.custom_blueprint_list) do
            local data = createItemData(v.id, v)
            data.type = FightEnum.BuildType.Combination
            if self:CheckCanBuild(data) then
                table.insert(CanBuildList, data)
            else
                table.insert(NotBuildList, data)
            end
        end

        local sortFun = function(a, b)
            local count1, count2 = 0, 0
            for _, v in pairs(a.cost_list) do
                count1 = count1 + v[2]
            end
            for _, v in pairs(b.cost_list) do
                count2 = count2 + v[2]
            end
            return count1 < count2
        end
        --分别排序
        table.sort(CanBuildList, sortFun)
        table.sort(NotBuildList, sortFun)
        TableUtils.InsertTable(CanBuildList, NotBuildList)

        self.item_data_list = CanBuildList
    elseif self.CurToggleType == toggleList.Record then
        local temp = {}
        for k, v in pairs(mod.BuildCtrl.build_use_history) do
            table.insert(temp, { id = k, time = v })
        end
        table.sort(temp, function(a, b)
            return a.time > b.time
        end)
        for _, v in pairs(temp) do
            if BuildData[v.id] or mod.BuildCtrl:GetBluePrintConfig(v.id) then
                table.insert(self.item_data_list, createItemData(v.id, mod.BuildCtrl:GetBluePrintConfig(v.id)))
            end
        end
    elseif self.CurToggleType == toggleList.UsesNumber then
        local temp = {}
        for k, v in pairs(mod.BuildCtrl.build_use_time) do
            table.insert(temp, { id = k, useTime = v })
        end
        table.sort(temp, function(a, b)
            return a.useTime > b.useTime
        end)
        for _, v in pairs(temp) do
            if BuildData[v.id] or mod.BuildCtrl:GetBluePrintConfig(v.id) then
                table.insert(self.item_data_list, createItemData(v.id, mod.BuildCtrl:GetBluePrintConfig(v.id)))
            end
        end
    end
end

--更新蓝图列表
function SelectBluePrintWindow:UpdateBuildList()
    --已解锁的蓝图
    local index = 1
    for i = 1, #self.buildItemList do
        self.buildItemList[i].objectTransform:SetActive(false)
        self.buildItemList[i].Bg_btn.onClick:RemoveAllListeners()
    end
    self.buildItemCache = TableUtils.CopyTable(self.buildItemList)
    TableUtils.ClearTable(self.buildItemList)

    for k, data in pairs(self.item_data_list) do
        local item = self:getBuildItem()
        item.Icon:SetActive(false)

        SingleIconLoader.Load(item.Icon, data.icon, function()
            item.Icon:SetActive(true)
        end)
        if data.type == FightEnum.BuildType.Single then
            local buildCount = 0
            item.Limit_txt.text = buildCount .. "/" .. data.count_limit
            UtilsUI.SetActive(item.Limit, true)
        else
            item.Limit_txt.text = ""
            UtilsUI.SetActive(item.Limit, false)
        end

        item.Name_txt.text = data.name
        item.Select:SetActive(false)

        for i = 1, 2 do
            if data.cost_list[i] and data.cost_list[i][2] > 0 then
                item["ItemCostIcon" .. i]:SetActive(true)
                item["ItemCostCount" .. i .. "_txt"].text = data.cost_list[i][2]
                SingleIconLoader.Load(item["ItemCostIcon" .. i], ItemConfig.GetItemIcon(data.cost_list[i][1]), function()
                    item["ItemCostIcon" .. i]:SetActive(true)
                end)
            else
                item["ItemCostIcon" .. i]:SetActive(false)
            end
        end
        item.TipBg:SetActive(not self:CheckCanBuild(data))
        item.Bg_btn.onClick:RemoveAllListeners()
        item.Bg_btn.onClick:AddListener(function()
            self:OnSelectBuilding(data.build_id, data.type)
        end)

        item.Bg_btn.onClick:RemoveAllListeners()
        item.Bg_btn.onClick:AddListener(function()
            self:OnSelectBuilding(data.build_id, data.type)
        end)
        item.Delete:SetActive(self.CurToggleType == toggleList.Delete)
        item.Delete_btn.onClick:RemoveAllListeners()
        item.Delete_btn.onClick:AddListener(function()
            self:OnDeleteBuilding(data.build_id)
        end)
        item.objectTransform:SetActive(true)
        self.buildItemList[index] = item
        index = index + 1
    end
end

function SelectBluePrintWindow:OnSelectBuilding(buildId, type)
    if self.CurToggleType == toggleList.Delete then
        return
    end
    -- 关闭UI，并打开建造界面
    self.isSelectBuilding = true
    self:PlayExitAnim()
    WindowManager.Instance:CloseWindow(self)
    Fight.Instance.clientFight.buildManager:OpenBuildControlPanel(buildId, type)
end

function SelectBluePrintWindow:OnDeleteBuilding(buildId)
    if self.CurToggleType ~= toggleList.Delete then
        return
    end

    self:OpenPanel(BluePrintDeletePanel, { deleteId = buildId })
end

function SelectBluePrintWindow:getBuildItem()
    if #self.buildItemCache > 0 then
        return table.remove(self.buildItemCache, 1)
    end
    local obj = self:PopUITmpObject("BluePrint")
    obj.objectTransform:SetParent(self.Content.transform)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    obj.objectTransform:SetActive(true)
    return obj
end

function SelectBluePrintWindow:GetBuildItemPosInContent(itemIndex)
    local leftPos = self.blueListContentPadding.left + (itemIndex - 1) * (self.buildItemSize.width + self.blueListContentPadding.spacing)
    local rightPos = leftPos + self.buildItemSize.width
    return leftPos, rightPos
end

function SelectBluePrintWindow:GetSourceObj()
    if next(self.sourceObjPool) then
        return table.remove(self.sourceObjPool)
    end
    local objectInfo = {}
    objectInfo.object = GameObject.Instantiate(self.SingleSource)
    objectInfo.objectTransform = objectInfo.object.transform
    objectInfo.objectTransform:SetParent(self.Node_Source.transform)
    UtilsUI.GetContainerObject(objectInfo.objectTransform, objectInfo)
    UnityUtils.SetLocalScale(objectInfo.objectTransform, 1, 1, 1)

    return objectInfo
end

function SelectBluePrintWindow:OnSelectedBuildItemLeft()
    if self.curSelectIndex == 1 or self.buildModel == BuildModel.OnlyMove then
        return
    end
    self.curSelectIndex = self.curSelectIndex - 1
    local nextItem = self.buildItemList[self.curSelectIndex]
    nextItem.Bg_btn.onClick:Invoke()
end

function SelectBluePrintWindow:OnSelectedBuildItemRight()
    if self.curSelectIndex >= #self.buildItemList or self.buildModel == BuildModel.OnlyMove then
        return
    end
    self.curSelectIndex = self.curSelectIndex + 1
    local nextItem = self.buildItemList[self.curSelectIndex]
    nextItem.Bg_btn.onClick:Invoke()
end

function SelectBluePrintWindow:OnSelectedBuildTypeLeft()
    if self.CurToggleType == 1 or self.buildModel == BuildModel.OnlyMove then
        return
    end
    local nextType = self.CurToggleType - 1
    local nextItem = self["Type" .. nextType .. "_tog"]
    nextItem.isOn = true
end

function SelectBluePrintWindow:OnSelectedBuildTypeRight()
    if self.CurToggleType >= 6 or self.buildModel == BuildModel.OnlyMove then
        return
    end
    local nextType = self.CurToggleType + 1
    local nextItem = self["Type" .. nextType .. "_tog"]
    nextItem.isOn = true
end

function SelectBluePrintWindow:InitCurrencyBar(type)
    if self.currencyBarClass or not type then
        return
    end
    self.currencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
    self.currencyBarClass:init(self.CurrencyBar, type)
end

function SelectBluePrintWindow:CacheCurrencyBar()
    self.currencyBarClass:OnCache()
    self.currencyBarClass = nil
end

--#endregion
function SelectBluePrintWindow:Close_HideCallBack()
    --BF.ExitHackingMode()
    WindowManager.Instance:CloseWindow(SelectBluePrintWindow)
end

--缓存对象
function SelectBluePrintWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function SelectBluePrintWindow:__delete()

end

function SelectBluePrintWindow:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    self:CacheCurrencyBar()

    local ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if not self.isSelectBuilding and BehaviorFunctions.CheckEntityState(ctrlEntity.instanceId, FightEnum.EntityState.Build) then
        ctrlEntity.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildEnd)
    end
    self.isSelectBuilding = false
end