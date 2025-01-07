RoleUpgradePanel = BaseClass("RoleUpgradePanel", BasePanel)

local DataItem = Config.DataItem.Find
local DataHeroLevAttr = Config.DataHeroLevAttr.Find
local DataHeroLevUpgrade = Config.DataHeroLevUpgrade.Find

function RoleUpgradePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleUpgradePanel.prefab")
    self.selectItemList = {}
    self.itemObjList = {}
    self.curGoldCost = 0
    self.curLevel = 0
    self.targetLevelLimit = false
    self.isItemEnough = true
    self.curTargetLevel = 0
    self.levelObjList = {}
    self.AttributeItemList = {}

    self.color1 = Color(0, 0, 0, 1)
    self.color2 = Color(196 / 255, 201 / 255, 212 / 255, 1)

    self.adsorptionTimer = nil
end

function RoleUpgradePanel:__BindEvent()

end

function RoleUpgradePanel:__BindListener()
    self.ResetButton_btn.onClick:AddListener(self:ToFunc("ResetUpgradeTarget"))
    self.MaxLevelButton_btn.onClick:AddListener(self:ToFunc("SelectMaxTarget"))
    self.LevelUpButton_1_btn.onClick:AddListener(self:ToFunc("ClickUpgrade"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("onRoleInfoUpdate"))

    local dragBehaviour = self.LevelSlider:AddComponent(UIDragBehaviour)
    dragBehaviour.onBeginDrag = function(data)
        self:setOnCalculating(true)
        local content = self.LevelSlider.transform:Find("Viewport/Content")
        if content then
            for i = 0, content.childCount - 1 do
                local cell = content:GetChild(i)
                if cell then
                    local itemObj = UtilsUI.GetContainerObject(cell:GetChild(0))
                    itemObj.Level_txt.fontSize = 86
                    itemObj.Level_txt.color = self.color2
                end
            end
        end
    end
    dragBehaviour.onEndDrag = function(data)
        self:OnLevelSliderDragEnd(data)
    end
end

function RoleUpgradePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function RoleUpgradePanel:__Create()
    self:initCostItem()
end

function RoleUpgradePanel:__delete()
    LuaTimerManager.Instance:RemoveTimer(self.adsorptionTimer)
    LuaTimerManager.Instance:RemoveTimer(self.stopCalculateTimer)
end

function RoleUpgradePanel:__Hide()
    LuaTimerManager.Instance:RemoveTimer(self.adsorptionTimer)
    LuaTimerManager.Instance:RemoveTimer(self.stopCalculateTimer)
end

function RoleUpgradePanel:__Show()
    self.heroId = self.args.heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.curLevel = self.curRoleInfo.lev
    self.curLevelLimit = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    ---初始化经验物品 RoleConfig.UpgradeItems
    self.selectItemList = {}
    self.curGoldCost = 0
    self.curSelectItem = {}
    self.goldCost = 0
    self:UpdateShow()
end

function RoleUpgradePanel:__ShowComplete()
    local config = RoleConfig.GetRoleCameraConfig(self.heroId, RoleConfig.PageCameraType.LevelUp)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("RoleRoot", config.anim)
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("RoleRoot", config.model_rotation)
end

-- ---------------------计算-----------------------------
--计算传入的材料需要消耗多少金币，可以获得多少经验值
function RoleUpgradePanel:CalculateCostAndExplore(itemList)
    local cost = 0
    local explore = 0
    for itemId, count in pairs(itemList) do
        cost = cost + count * (DataItem[itemId].property2 or 0)
        explore = explore + count * (DataItem[itemId].property1 or 0)
    end
    return cost, explore
end

--计算最大可升级等级，受金币和经验限制
function RoleUpgradePanel:CalculateMaxTargetLevel()
    local curLevel = self.curRoleInfo.lev
    local needExp = -self.curRoleInfo.exp
    local haveGold = self:GetGoldCount()
    for i = curLevel + 1, self.curLevelLimit do
        needExp = needExp + DataHeroLevUpgrade[i].need_exp
    end
    local selectItemList = {}
    local item = { 20103, 20102, 20101 }

    for _, itemId in ipairs(item) do
        local count = mod.BagCtrl:GetItemCountById(itemId)
        selectItemList[itemId] = math.ceil(needExp / DataItem[itemId].property1)
        selectItemList[itemId] = selectItemList[itemId] > count and count or selectItemList[itemId]
        if selectItemList[itemId] * (DataItem[itemId].property2 or 0) > haveGold then
            selectItemList[itemId] = math.floor(haveGold / DataItem[itemId].property2)
        end
        haveGold = haveGold - selectItemList[itemId] * (DataItem[itemId].property2 or 0)
        needExp = needExp - selectItemList[itemId] * DataItem[itemId].property1
    end

    local targetLevel, explore, cost = self:CalculateTargetLevel(selectItemList)
    self.maxTargetLevel = targetLevel
    self.MaxLevelText_txt.text = targetLevel
    return selectItemList
end

--计算达到目标等级需要的经验值
function RoleUpgradePanel:CalculateCostByLevel(targetLevel, setLack)
    self.isItemEnough = true
    ---计算需要的经验值
    local curLevel = self.curRoleInfo.lev
    local needExp = 0
    for i = curLevel + 1, targetLevel do
        needExp = needExp + DataHeroLevUpgrade[i].need_exp
    end
    needExp = needExp - self.curRoleInfo.exp
    if needExp <= 0 then
        for k, itemId in pairs(RoleConfig.UpgradeItems) do
            self.selectItemList[itemId] = 0
            self:updateCostItem(itemId, false)
        end
        self:updateCostAndExplore()
    end

    ---计算当前拥有材料可提供的经验值
    local haveExp = 0
    for _, itemId in pairs(RoleConfig.UpgradeItems) do
        local itemCount = mod.BagCtrl:GetItemCountById(itemId)
        haveExp = haveExp + DataItem[itemId].property1 * itemCount
    end
    if haveExp < needExp then
        for k, itemId in pairs(RoleConfig.UpgradeItems) do
            self.selectItemList[itemId] = 0
            self:updateCostItem(itemId, setLack)
        end
        self:updateCostAndExplore(true)
        self.isItemEnough = false
        return
    end
    ---依次选择每种材料的用量
    local item = { 20103, 20102, 20101 }
    for k, itemId in pairs(item) do
        local itemCount = mod.BagCtrl:GetItemCountById(itemId)
        if needExp > 0 then
            self.selectItemList[itemId] = math.min(itemCount, math.floor(needExp / DataItem[itemId].property1))
            needExp = needExp - DataItem[itemId].property1 * self.selectItemList[itemId]
        end
    end
    ---补齐不足
    for _, itemId in pairs(RoleConfig.UpgradeItems) do
        local itemCount = mod.BagCtrl:GetItemCountById(itemId)
        if needExp > 0 and self.selectItemList[itemId] < itemCount then
            local addCount = math.min(itemCount - self.selectItemList[itemId], math.ceil(needExp / DataItem[itemId].property1))
            self.selectItemList[itemId] = self.selectItemList[itemId] + addCount
            needExp = needExp - DataItem[itemId].property1 * addCount
        end
        self:updateCostItem(itemId)
    end
    ---更新表现
    self:updateCostAndExplore()
end

--根据选择的材料，计算可达等级/经验值
function RoleUpgradePanel:CalculateTargetLevel(itemList)
    local cost, explore = self:CalculateCostAndExplore(itemList)
    local curLevel = self.curRoleInfo.lev
    local curExp = self.curRoleInfo.exp
    explore = explore + curExp
    local targetLevel = curLevel
    if curLevel >= self.curLevelLimit then
        return curLevel, curExp, cost
    end

    local needExp = DataHeroLevUpgrade[targetLevel + 1].need_exp
    while targetLevel < self.curLevelLimit and explore - needExp >= 0 do
        explore = explore - needExp
        targetLevel = targetLevel + 1
        if targetLevel == self.curLevelLimit then
            break
        end
        needExp = DataHeroLevUpgrade[targetLevel + 1].need_exp
    end

    if targetLevel == self.curLevelLimit then
        explore = needExp
    end

    return targetLevel, explore, cost
end

function RoleUpgradePanel:GetGoldCount()
    local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
    for k, info in pairs(currency) do
        if info.template_id == 2 then
            return info.count
        end
    end
    return 0
end

-- ----------------------设置表现-----------------------------
--刷新页面
function RoleUpgradePanel:UpdateShow()
    self:RefreshLevelItemCount()
    self:updateCostAndExplore()
    self:CalculateMaxTargetLevel()
    if self.curLevel < self.curLevelLimit then
        self:CalculateCostByLevel(self.curLevel + 1, true)
        self:updateCostAndExplore()
        self:SetScrollToTargetLevel(self.curLevel + 1)
    end
end

function RoleUpgradePanel:OnValueChanged_List(pos)
    self.Tip:SetActive(pos.y > 0.9)
end

--设置为计算中的状态，屏蔽部分点击
function RoleUpgradePanel:setOnCalculating(isOnCalculating)
    for i, itemId in ipairs(RoleConfig.UpgradeItems) do
        local itemObj = self.itemObjList[itemId]
        if itemObj then
            itemObj.CalculatingTip:SetActive(isOnCalculating)
            itemObj.Select:SetActive(false)
            itemObj.Lack:SetActive(false)
        end
    end
    self.UpgradeButton:SetActive(not isOnCalculating)
    self.CalculatingTip:SetActive(isOnCalculating)

    if not isOnCalculating then
        local targetLevel = self:UpdateLevelItemList()
        self:CalculateCostByLevel(targetLevel, true)
    end
end

function RoleUpgradePanel:UpdateLevelItemList()
    local targetLevel = 0
    local content = self.LevelSlider.transform:Find("Viewport/Content")
    if content then
        for i = 0, content.childCount - 1 do
            local cell = content:GetChild(i)
            if cell then
                local itemObj = UtilsUI.GetContainerObject(cell:GetChild(0))
                if math.abs(cell.anchoredPosition.y + content.anchoredPosition.y) < 45 then
                    itemObj.Level_txt.fontSize = 110
                    targetLevel = itemObj.Level_txt.text
                    itemObj.Level_txt.color = self.color1
                else
                    itemObj.Level_txt.fontSize = 86
                    itemObj.Level_txt.color = self.color2
                end
            end
        end
    end
    self.curTargetLevel = tonumber(targetLevel)
    self:updateAttributeChange()
    return tonumber(targetLevel)
end

function RoleUpgradePanel:RefreshItemCell(index, go)
    if not go then
        return
    end
    local itemObj = UtilsUI.GetContainerObject(go)
    local showLevel = self.curRoleInfo.lev + index - 1
    if showLevel < self.curRoleInfo.lev or showLevel > self.curLevelLimit then
        itemObj.Level_txt.text = ""
    else
        itemObj.Level_txt.text = showLevel
    end
end

function RoleUpgradePanel:ResetList()
    self.totalLevelCount = self.curLevelLimit - self.curRoleInfo.lev + 1
    self.LevelSlider_recyceList:SetCellNum(self.totalLevelCount)
    self.LevelSlider_recyceList.onValueChanged:AddListener(self:ToFunc("OnValueChanged_List"))
    self.LevelSlider_recyceList:ResetList()
end

function RoleUpgradePanel:RefreshLevelItemCount()
    self.totalLevelCount = self.curLevelLimit - self.curRoleInfo.lev + 1
    self.LevelSlider_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.LevelSlider_recyceList:SetCellNum(self.totalLevelCount)
    self.LevelSlider_recyceList.onValueChanged:AddListener(self:ToFunc("OnValueChanged_List"))
end

--初始化材料列表
function RoleUpgradePanel:initCostItem()
    self.curSelectItem = {}
    self.haveItemList = {}
    for i, itemId in ipairs(RoleConfig.UpgradeItems) do
        if DataItem[itemId] then
            local itemObj = self:GetCostItem()
            local icon = ItemConfig.GetItemIcon(itemId)
            SingleIconLoader.Load(itemObj.Icon, icon)
            local count = mod.BagCtrl:GetItemCountById(itemId)
            self.haveItemList[itemId] = count
            itemObj.Count_txt.text = count
            self:SetQuality(itemObj, DataItem[itemId].quality)
            local onClickFunc = function()
                self:OnSelectItem(itemId)
            end
            itemObj.Icon_btn.onClick:RemoveAllListeners()
            itemObj.Icon_btn.onClick:AddListener(onClickFunc)
            local dragBehaviour = itemObj.Icon:AddComponent(UIDragBehaviour)
            dragBehaviour.onPointerDown = function(data)
                LuaTimerManager.Instance:RemoveTimer(self.longTouchTimer)
                LuaTimerManager.Instance:RemoveTimer(self.longTouchSelectTimer)
                self.longTouchTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function()
                    local maxCount = mod.BagCtrl:GetItemCountById(itemId)
                    self.longTouchSelectTimer = LuaTimerManager.Instance:AddTimer(maxCount, 0.1, function()
                        self:OnSelectItem(itemId)
                    end)
                end)
            end
            dragBehaviour.onPointerUp = function(data)
                LuaTimerManager.Instance:RemoveTimer(self.longTouchTimer)
                LuaTimerManager.Instance:RemoveTimer(self.longTouchSelectTimer)
            end
            itemObj.object:SetActive(true)
            self.itemObjList[itemId] = itemObj
        end
    end
    self.goldCost = 0
end
--创建材料item
function RoleUpgradePanel:GetCostItem()
    local obj = self:PopUITmpObject("CostItem")
    obj.objectTransform:SetParent(self.CostList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end
--更新材料ui
function RoleUpgradePanel:updateCostItem(itemId, setLack)
    local itemCount = mod.BagCtrl:GetItemCountById(itemId)
    self.itemObjList[itemId].Select:SetActive(false)
    self.itemObjList[itemId].Lack:SetActive(false)
    local selectCount = self.selectItemList[itemId] or 0

    if selectCount > itemCount or setLack then
        self.itemObjList[itemId].Lack:SetActive(true)
    elseif selectCount > 0 and selectCount <= itemCount then
        self.itemObjList[itemId].Select:SetActive(true)
    end

    self.itemObjList[itemId].SelectCount_txt.text = selectCount
end
--设置材料品质
function RoleUpgradePanel:SetQuality(itemObj, quality)
    local frontImg, backImg = ItemManager.GetItemColorImg(quality)
    if not frontImg or not backImg then
        return
    end

    local frontPath = AssetConfig.GetQualityIcon(frontImg)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    SingleIconLoader.Load(itemObj.QualityFront, frontPath)
    SingleIconLoader.Load(itemObj.QualityBack, backPath)
end

--根据选择的材料，更新消耗和可达到的等级
function RoleUpgradePanel:updateCostAndExplore(notUpdateLevelList)
    local targetLevel, explore, cost = self:CalculateTargetLevel(self.selectItemList)
    local haveGold = self:GetGoldCount()
    local itemEnough = true
    for k, itemId in pairs(RoleConfig.UpgradeItems) do
        local selectCount = self.selectItemList[itemId] or 0
        local itemCount = mod.BagCtrl:GetItemCountById(itemId)
        if selectCount > itemCount then
            itemEnough = false
        end
    end

    if not itemEnough then
        self.MoneyCostText_txt.text = string.format("<color=#ff0000>%s</color>", haveGold)
    elseif cost > haveGold then
        self.MoneyCostText_txt.text = string.format("<color=#ff0000>%s</color>/<color=#eb6f00>%s</color>", haveGold, cost)
    else
        self.MoneyCostText_txt.text = string.format("%s/<color=#eb6f00>%s</color>", haveGold, cost)
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.MoneyCost.transform)
    if targetLevel == self.curLevelLimit then
        UnityUtils.SetSizeDelata(self.ExploreValue.transform, 0, 6)
    else
        local explorePercent = explore / DataHeroLevUpgrade[targetLevel + 1].need_exp
        UnityUtils.SetSizeDelata(self.ExploreValue.transform, 233 * explorePercent, 6)
        self.Light:SetActive(explorePercent > 0.1)
    end
    self.targetLevelLimit = targetLevel == self.curLevelLimit

    if not notUpdateLevelList then
        self:SetScrollToTargetLevel(targetLevel)
    end
end

function RoleUpgradePanel:SetScrollToTargetLevel(targetLevel)
    local targetIndex = targetLevel - self.curRoleInfo.lev + 1
    local cellIndex = 2
    if targetLevel - self.curRoleInfo.lev < 2 then
        cellIndex = targetLevel - self.curRoleInfo.lev
    elseif self.curLevelLimit - targetLevel <= 2 then
        cellIndex = targetLevel - self.curLevelLimit + 4
    end
    self.Tip:SetActive(cellIndex < 1)
    self.LevelSlider_recyceList:JumpToIndex(targetIndex, cellIndex)
    self:UpdateLevelItemList()
end

function RoleUpgradePanel:onRoleInfoUpdate(isUnlock)
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.curLevel = self.curRoleInfo.lev
    self.curLevelLimit = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    self.selectItemList = {}
    self.curTargetLevel = 0
    self.curGoldCost = 0

    for itemId, item in pairs(self.itemObjList) do
        item.Select:SetActive(false)
        item.Lack:SetActive(false)
        local count = mod.BagCtrl:GetItemCountById(itemId)
        self.haveItemList[itemId] = count
        item.Count_txt.text = count

        item.CalculatingTip:SetActive(false)
    end
    if isUnlock then
        LuaTimerManager.Instance:RemoveTimer(self.unlockTimer)
        self.unlockTimer = LuaTimerManager.Instance:AddTimer(0.3, 1, function()
            self.upgradeLock = false
        end)
    end
    self:ResetList()
    self:UpdateShow()
end

-- --------------------------交互逻辑--------------------------
--选择当前最大可达等级
function RoleUpgradePanel:SelectMaxTarget()
    if self.curRoleInfo.lev >= self.curLevelLimit then
        return
    end
    self:CalculateCostByLevel(self.maxTargetLevel, false)
    self:updateCostAndExplore()
    self:UpdateLevelItemList()
end

--点击升级按钮
function RoleUpgradePanel:ClickUpgrade()
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end
    if not self.isItemEnough then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
        return
    end

    local itemList = {}
    local cost = 0
    for itemId, count in pairs(self.selectItemList) do
        if mod.BagCtrl:GetItemCountById(itemId) >= count then
            if count > 0 then
                table.insert(itemList, { key = itemId, value = count })
                cost = cost + count * (DataItem[itemId].property2 or 0)
            end
        else
            MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
            return
        end
    end

    if cost == 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("请选择道具或滑动等级列表"))
        return
    end

    local haveGold = self:GetGoldCount()
    if cost > haveGold then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
        return
    end

    if not self.upgradeLock then
        mod.RoleCtrl:RoleUpgrade(self.args.heroId, itemList)
        self.isItemEnough = true
        self.upgradeLock = true
    end
end

--点击重置按钮
function RoleUpgradePanel:ResetUpgradeTarget()
    self:onRoleInfoUpdate(false)
end

--选择材料
function RoleUpgradePanel:OnSelectItem(itemId)
    if not self.selectItemList[itemId] then
        self.selectItemList[itemId] = 0
    end
    if self.targetLevelLimit then
        MsgBoxManager.Instance:ShowTips(TI18N("已达等级上限"))
        return
    end
    if self.selectItemList[itemId] < mod.BagCtrl:GetItemCountById(itemId) then
        self.selectItemList[itemId] = self.selectItemList[itemId] + 1
    else
        MsgBoxManager.Instance:ShowTips(TI18N("道具数量不足"))
    end
    self:updateCostItem(itemId)
    self:updateCostAndExplore(false)
end

function RoleUpgradePanel:OnLevelSliderDragEnd(data)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 0.9, function()
        local content = self.LevelSlider.transform:Find("Viewport/Content")
        local anchorPosition = content.anchoredPosition
        local posY = anchorPosition.y / 90
        local index = posY - math.floor(posY) >= 0.5 and math.ceil(posY) or math.floor(posY)
        local targetPosY = index * 90
        local offset = posY - math.floor(posY) >= 0.5 and 0.05 or -0.05
        content:DOLocalMoveY(targetPosY + offset + 45, 0.1, true)

        LuaTimerManager.Instance:RemoveTimer(self.setNotCalculatingTimer)
        self.setNotCalculatingTimer = LuaTimerManager.Instance:AddTimer(1, 0.2, function()
            self:setOnCalculating(false)
        end)
    end)
end

function RoleUpgradePanel:updateAttributeChange()
    ---比较当前等级和目标等级
    ---计算属性
    ---显示
    if self.curTargetLevel > self.curRoleInfo.lev then
        ---show
        local oldAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
        local newAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curTargetLevel)
        local stageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage)
        local attrId = UtilsBase.GetStringKeys(self.heroId, self.curTargetLevel)
        for index, attr_id in pairs(DataHeroLevAttr[attrId].ui_show_attr) do
            local item = self.AttributeItemList[index] or self:getAttributeItem()
            --item.Bg:SetActive(index % 2 ~= 0)
            item.Name_txt.text = Config.DataAttrsDefine.Find[attr_id].name
            local curValue = oldAttr[attr_id] + stageAttr[attr_id] or 0
            local nextValue = newAttr[attr_id] + stageAttr[attr_id] or 0
            if EntityAttrsConfig.AttrPercent2Attr[attr_id] then
                curValue = curValue * 0.01 .. "%"
                nextValue = nextValue * 0.01 .. "%"
            end
            item.OldValue_txt.text = curValue
            item.NewValue_txt.text = nextValue
            item.object:SetActive(true)
            self.AttributeItemList[index] = item
        end
        self.AttributeInfo:SetActive(true)
    else
        ---hide
        self.AttributeInfo:SetActive(false)
    end
end

function RoleUpgradePanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    obj.objectTransform:SetParent(self.AttributeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function RoleUpgradePanel:OnClose()
    LuaTimerManager.Instance:RemoveTimer(self.unlockTimer)
    self.RoleUpgradePanel_exit:SetActive(true)
end