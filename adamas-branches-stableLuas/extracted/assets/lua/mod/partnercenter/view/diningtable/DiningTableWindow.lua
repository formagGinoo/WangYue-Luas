DiningTableWindow = BaseClass("DiningTableWindow", BaseWindow)
DiningTableWindow.active = true

function DiningTableWindow:__init()
    self:SetAsset("Prefabs/UI/PartnerCenter/DiningTableWindow.prefab")
end

function DiningTableWindow:__CacheObject()

end

function DiningTableWindow:__BindListener()
    self.AddBtn_btn.onClick:AddListener(self:ToFunc("OnClick_AddBagFoodToTable"))
    self.AdjustNumBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenAdjustNumPanel"))
    self.GameplayBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenGameplayTeachPanel"))
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))

    EventMgr.Instance:AddListener(EventName.UpdateSelectedFoodItem, self:ToFunc("UpdateSelectedFoodItem"))
    EventMgr.Instance:AddListener(EventName.UpdateDiningTableItemNum, self:ToFunc("UpdateDiningTableItemNum"))
end

function DiningTableWindow:__Show(args)
    self.uniqueId = args and args.uniqueId or self.args.uniqueId
    self.assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    self.deviceId = mod.AssetPurchaseCtrl:GetDecorationListByAssetId(self.assetId)[self.uniqueId].template_id
    self.currFoodItemData = {}
    self.currFoodItemDic = {}
    self.bagItemNumData = {}
    self.bagItemDic = {}
    self.sourceObjList = {}
    self.sourceObjPool = {}
    self.currSelectedItemId = 0
    
    self:InitData()
    
    self:InitCurrFoodScrollView()

    self:InitBagFoodScrollView()
    
    -- 设置默认值
    if #self.currFoodItemData > 0 then
        self:UpdateSelectedFoodItem(self.currFoodItemData[1].itemId)
    end
end

function DiningTableWindow:__Hide()
    self:CacheBar()
end

function DiningTableWindow:__delete()
    -- todo CommonItem放回对象池
    
    EventMgr.Instance:RemoveListener(EventName.UpdateSelectedFoodItem, self:ToFunc("UpdateSelectedFoodItem"))
    EventMgr.Instance:RemoveListener(EventName.UpdateDiningTableItemNum, self:ToFunc("UpdateDiningTableItemNum"))
end

function DiningTableWindow:CacheBar()

end

function DiningTableWindow:InitData()
    self:UpdateCurrItemData()
    
    self:UpdateBagItemNumData()
end

-- 更新当前食品数据
function DiningTableWindow:UpdateCurrItemData()
    self.currFoodItemData = {}
    local diningTableData = PartnerCenterConfig.GetPartnerDiningTableData(self.deviceId)
    local foodList = mod.PartnerCenterCtrl:GetDiningTableFoodList(self.assetId, self.uniqueId)

    -- 获取不同餐桌对应道具
    for i = 1, #diningTableData do
        local itemId = diningTableData[i][1]
        local itemMaxNum = diningTableData[i][2]
        local data = {}
        data.itemId = itemId
        data.maxNum = itemMaxNum
        data.currNum = 0
        for i = 1, #foodList do
            if foodList[i]["key"] == itemId then
                data.currNum = foodList[i]["value"]
            end
        end
        
        table.insert(self.currFoodItemData, data)
    end
end

-- 获取背包对应道具数据
function DiningTableWindow:UpdateBagItemNumData()
    self.bagItemNumData = {}
    
    -- 获取背包对应道具数据
    for i = 1, #self.currFoodItemData do
        local itemCount = mod.BagCtrl:GetItemCountById(self.currFoodItemData[i].itemId)
        if itemCount ~= 0 then
            local data = {}
            data.itemId = self.currFoodItemData[i].itemId
            data.count = itemCount

            table.insert(self.bagItemNumData, data)
        end
    end
end

function DiningTableWindow:InitCurrFoodScrollView()
    if not self.CurrFoodScrollView_recyceList then
        return
    end
    
    self.CurrFoodScrollView_recyceList:CleanAllCell()
    self.CurrFoodScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateCurrFoodItem"))
    self.CurrFoodScrollView_recyceList:SetCellNum(#self.currFoodItemData)
end

function DiningTableWindow:UpdateCurrFoodItem(_index, _obj)
    if not _obj then
        return
    end

    if not self.currFoodItemDic[_index] then
        self.currFoodItemDic[_index] = SingleDiningTableFoodItem.New()
    end
    
    local item = self.currFoodItemDic[_index]
    local data = self.currFoodItemData[_index]
    data.index = _index
    data.obj = _obj
    
    item:UpdateData(data)
end

function DiningTableWindow:InitBagFoodScrollView()
    if not self.BagFoodScrollView_recyceList then
        return
    end

    if self:IsBagItemDataNull() then
        return
    end
    
    self.BagFoodScrollView_recyceList:CleanAllCell()
    self.BagFoodScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateBagFoodItem"))
    self.BagFoodScrollView_recyceList:SetCellNum(#self.bagItemNumData)
end

function DiningTableWindow:UpdateBagFoodItem(_index, _obj)
    if not _obj then
        return
    end
    
    if not self.bagItemDic[_index] then
        local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not commonItem then
            commonItem = CommonItem.New()
        end
        self.bagItemDic[_index] = commonItem
    end
    
    local item = self.bagItemDic[_index]
    local data = self.bagItemNumData[_index]
    local itemInfo = {template_id = data.itemId, count = data.count or 0}

    item:InitItem(_obj, itemInfo, true)
end

-- 成功收到回包协议后，刷新背包和餐桌物品数量
function DiningTableWindow:UpdateDiningTableItemNum(foodList)
    -- 更新数据
    for i = 1, #self.currFoodItemData do
        for j = 1, #foodList do
            if self.currFoodItemData[i].itemId == foodList[j].key then
                self.currFoodItemData[i].currNum = foodList[j].value
            end 
        end
    end
    
    self:UpdateBagItemNumData()

    -- 更新显示
    for i = 1, #self.currFoodItemDic do
        local item = self.currFoodItemDic[i]
        local data = self.currFoodItemData[i]
        
        item:UpdateNum(data.currNum)
    end

    --[[for i = 1, #self.bagItemDic do
        local item = self.bagItemDic[i]
        local data = self.bagItemNumData[i]

        item:SetNum(data.count)
    end]]
    
    local isNull = self:IsBagItemDataNull()
    if isNull then
        self.BagFoodScrollView_recyceList:CleanAllCell()
    else
        self:InitBagFoodScrollView()
    end
end

-- region 同步背包面板更新Tips逻辑
function DiningTableWindow:UpdateTips(itemConfig, itemInfo)
    self:SetTipsBaseInfo(itemConfig, itemInfo)

    self:SetTipsDetailInfo(itemConfig, itemInfo)

    self:UpdateStateIcon(itemConfig)
end

function DiningTableWindow:SetTipsBaseInfo(itemConfig, itemInfo)
    local itemType = ItemConfig.GetItemType(itemInfo.template_id)
    
    for i = 1, 5, 1 do
        UtilsUI.SetActive(self["QualityBack".. i], i == itemConfig.quality)
    end

    -- 设置Icon
    local path = ItemConfig.GetItemIcon(itemInfo.template_id)
    SingleIconLoader.Load(self.ItemIcon, path)

    -- 设置名字
    self.ItemName_txt.text = itemConfig.name

    -- 设置状态Icon
    self:UpdateStateIcon(itemConfig)

    -- 设置基础信息或者类别
    self.Weapon:SetActive(itemType == BagEnum.BagType.Weapon)
    self.TypeName:SetActive(itemType ~= BagEnum.BagType.Weapon)
    if itemType == BagEnum.BagType.Weapon then
        self.NoAttr:SetActive(false)
        SingleIconLoader.Load(self.Stage, "Textures/Icon/Single/StageIcon/" .. itemInfo.stage .. ".png")
        self.WeaponTypeName_txt.text = RoleConfig.GetWeaponTypeConfig(itemConfig.type).type_name
        self.CurLevel_txt.text = itemInfo.lev or 1
        self.MaxLevel_txt.text = RoleConfig.GetStageConfig(itemInfo.template_id, itemInfo.stage or 0).level_limit
    else
        self.NoAttr:SetActive(true)
        local typeConfig = ItemConfig.GetItemTypeConfig(itemConfig.type)
        self.TypeName_txt.text = typeConfig.type_name
    end
end

function DiningTableWindow:SetTipsDetailInfo(itemConfig, itemInfo)
    local itemType = ItemConfig.GetItemType(itemConfig.id)
    local showLock = itemType == BagEnum.BagType.Weapon
    local showStrength = false
    -- TODO 临时处理 后续需要跟随培养系统修改
    self.Node_Grow:SetActive(showLock)
    self.Node_GrowTop:SetActive(showLock or showStrength)
    self.Node_Lock:SetActive(showLock)

    self.Unlock:SetActive(not itemInfo.is_locked)
    self.HaveLock:SetActive(itemInfo.is_locked)

    -- 武器属性
    self.Node_Attr:SetActive(itemType == BagEnum.BagType.Weapon)

    -- 培养线没有出来之前暂时先只显示描述和来源
    -- 精炼信息
    if itemInfo.refine then
        self.Node_Refine:SetActive(true)
        self.RefineLvl_txt.text = itemInfo.refine
        self.RefineName_txt.text = string.format(TI18N("精炼%s阶"), itemInfo.refine)
    else
        self.Node_Refine:SetActive(false)
    end
    -- 显示描述
    if itemType == BagEnum.BagType.Item then
        self.Node_Desc:SetActive(itemConfig.desc ~= nil and itemConfig.desc ~= "")
        self.MainDesc_txt.text = itemConfig.desc
        --TODO 暂时没有内容
        self.SubDesc_txt.text = ""
    elseif itemType == BagEnum.BagType.Weapon then
        local refineConfig = RoleConfig.GetWeaponRefineConfig(itemInfo.template_id,itemInfo.refine or 0)
        self.Node_Desc:SetActive(true)
        if not refineConfig then
            self.MainDesc_txt.text = ""
        else
            self.MainDesc_txt.text = refineConfig.desc
        end
        self.SubDesc_txt.text = itemConfig.desc
    end
    --装备者
    if itemInfo.hero_id and itemInfo.hero_id ~= 0 then
        self.Equiped:SetActive(true)
        self.EquipedTips_txt.text = string.format(TI18N("%s已装备"), RoleConfig.GetRoleConfig(itemInfo.hero_id).name)
        local icon = RoleConfig.GetRoleConfig(itemInfo.hero_id).rhead_icon
        SingleIconLoader.Load(self.Belong, icon)
    else
        self.Equiped:SetActive(false)
    end

    for i = #self.sourceObjList, 1, -1 do
        self.sourceObjList[i].object:SetActive(false)
        table.insert(self.sourceObjPool, table.remove(self.sourceObjList))
    end
    
    self.Node_Source:SetActive(itemConfig.jump_ids and next(itemConfig.jump_ids))
    if itemConfig.jump_ids and next(itemConfig.jump_ids) then
        for i = 1, #itemConfig.jump_ids do
            local sourceObj = self:GetSourceObj()
            local jumpId = itemConfig.jump_ids[i]
            local title = JumpToConfig.GetTitle(jumpId)
            sourceObj.USourceDesc_txt.text = title
            sourceObj.ASourceDesc_txt.text = title
            sourceObj.SingleSource_btn.onClick:RemoveAllListeners()
            if not JumpToConfig.HasJumpEvent(jumpId) then
                sourceObj.ASource:SetActive(true)
                sourceObj.USource:SetActive(false)
            else
                sourceObj.ASource:SetActive(false)
                sourceObj.USource:SetActive(true)
                local onclickFunc = function()
                    self:OnClick_Source(jumpId)
                    PanelManager.Instance:ClosePanel(self)
                end
                sourceObj.SingleSource_btn.onClick:AddListener(onclickFunc)
            end
            sourceObj.object:SetActive(true)

            self.sourceObjList[i] = sourceObj
        end
    end

    --#region 测试逻辑 延迟修改Tips大小
    --[[local delayFunc = function ()
        local detailHeight = Mathf.Clamp(self.TipsDContent_rect.rect.height, 489, 489)
        UnityUtils.SetSizeDelata(self.TipsDetail.transform, self.TipsDetail_rect.rect.width, detailHeight)
        UnityUtils.SetSizeDelata(self.QualityBack.transform, self.TipsDetail_rect.rect.width , detailHeight + 324)
    end

    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
    self.testTimer = LuaTimerManager.Instance:AddTimer(0, 0.03, delayFunc)]]
    --#endregion
end

function DiningTableWindow:GetSourceObj()
    if next(self.sourceObjPool) then
        return table.remove(self.sourceObjPool)
    end
    
    local sourceObj = self:PopUITmpObject("SingleSource")
    sourceObj.objectTransform:SetParent(self.Node_Source.transform)
    UtilsUI.GetContainerObject(sourceObj.objectTransform, sourceObj)
    UnityUtils.SetLocalScale(sourceObj.objectTransform, 1, 1, 1)

    return sourceObj
end

function DiningTableWindow:UpdateStateIcon(itemConfig)

    self:UpdateYingYangIcon(itemConfig)
    self:UpdateAdditionIcon(itemConfig)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.StateIcon.transform)
end

function DiningTableWindow:UpdateYingYangIcon(itemConfig)
    local yinyangIcon = itemConfig.yinyang_icon
    if yinyangIcon == "" or not yinyangIcon then
        if self.YingYangIcon then
            self.YingYangIcon:SetActive(false)
        end
        return
    end
    self.YingYangIcon:SetActive(true)
    SingleIconLoader.Load(self.YingYangIcon, yinyangIcon)
end

function DiningTableWindow:UpdateAdditionIcon(itemConfig)
    local additionIcon = itemConfig.add_icon
    if additionIcon == "" or not additionIcon then
        if self.AdditionIcon then
            self.AdditionIcon:SetActive(false)
        end
        return
    end
    self.AdditionIcon:SetActive(true)
    SingleIconLoader.Load(self.AdditionIcon, additionIcon)
end
-- endRegion

-- 一键添加按钮，向后端发送协议
function DiningTableWindow:OnClick_AddBagFoodToTable()
    -- 当背包没有满足条件的道具时，弹出提示
    if #self.bagItemNumData == 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("当前背包没有满足条件的道具"))
        return
    end

    if self:IsAllCurrFoodItemMaxNum() then
        MsgBoxManager.Instance:ShowTips(TI18N("当前食物已满，无需添加"))
        return
    end

    self.itemNumUpdateTable = {}
    
    for i = 1, #self.bagItemDic do
        for j = 1, #self.currFoodItemDic do
            local itemId = self.bagItemDic[i].itemInfo.template_id
            
            if self.currFoodItemDic[j].itemId == itemId then
                local bagItemNum = self.bagItemDic[i].itemInfo.count
                local currItemNum = self.currFoodItemDic[j].currNum
                local maxItemNum = self.currFoodItemDic[j].maxNum

                -- 当前物品数量小于最大数量时，可以从背包补充
                local finalItemNum
                if currItemNum < maxItemNum then
                    finalItemNum = currItemNum + bagItemNum > maxItemNum and maxItemNum or currItemNum + bagItemNum
                    table.insert(self.itemNumUpdateTable, {["key"] = itemId, ["value"] = finalItemNum})
                end 
            end
        end
    end

    -- 向后端发送协议
    if #self.itemNumUpdateTable ~= 0 then
        mod.PartnerCenterCtrl:SetDiningTableItemNum(self.assetId, self.uniqueId, self.itemNumUpdateTable)
    end
end

function DiningTableWindow:OnClick_OpenAdjustNumPanel()
    local itemMaxNum = self.currSelectedItem.maxNum
    local itemCurrNum = self.currSelectedItem.currNum

    for i = 1, #self.currFoodItemData do
        if self.currFoodItemData[i].itemId == self.currSelectedItemId then
            itemCurrNum = self.currFoodItemData[i].currNum
        end
    end
    
    local bagItemNum = 0
    for i = 1, #self.bagItemDic do
        if self.bagItemDic[i].itemInfo.template_id == self.currSelectedItemId then
            bagItemNum = self.bagItemDic[i].itemInfo.count
        end
    end

    self:OpenPanel(DiningTableAdjustNumPanel, {
        itemId = self.currSelectedItemId, 
        currNum = itemCurrNum, 
        maxNum = itemMaxNum, 
        bagItemNum = bagItemNum,
        assetId = self.assetId,
        uniqueId = self.uniqueId,
        foodList = self.currFoodItemData,
        parent = self})
end

function DiningTableWindow:OnClick_OpenGameplayTeachPanel()
    local teachId = AssetPurchaseConfig.GetGameplayTeachId("AssetPartnerFoodUiTeach")

    BehaviorFunctions.ShowGuideImageTips(teachId)
end

-- 更新选择框和Tips面板
function DiningTableWindow:UpdateSelectedFoodItem(itemId)
    if self.currSelectedItemId == itemId then
        return
    end

    self.currSelectedItemId = itemId
    
    -- 更新选定框
    for i = 1, #self.currFoodItemDic do
        local item = self.currFoodItemDic[i]
        if itemId == item.itemId then
            self.currSelectedItem = item
        end

        item:UpdateSelectedState(itemId == item.itemId)
    end
    
    -- 更新Tips显示
    local itemConfig
    if ItemConfig.GetItemType(itemId) == BagEnum.BagType.Partner then
        itemConfig = RoleConfig.GetPartnerConfig(itemId)
    else
        itemConfig = ItemConfig.GetItemConfig(itemId)
    end
    local itemInfo = self.currSelectedItem.commonItem.itemInfo
    self:UpdateTips(itemConfig, itemInfo)
end

function DiningTableWindow:IsAllCurrFoodItemMaxNum()
    if #self.currFoodItemDic ~= 0 then
        for i = 1, #self.currFoodItemDic do
            if(self.currFoodItemDic[i].currNum ~= self.currFoodItemDic[i].maxNum) then
                return false
            end
        end
        
        return true
    end
    
    LogError("当前食物Item为空，检查配置表")
    return false
end

function DiningTableWindow:IsBagItemDataNull()
    local isNull = true
    for i = 1, #self.bagItemNumData do
        if self.bagItemNumData[i].count ~= 0 then
            isNull = false
            break
        end
    end

    return isNull
end

function DiningTableWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end