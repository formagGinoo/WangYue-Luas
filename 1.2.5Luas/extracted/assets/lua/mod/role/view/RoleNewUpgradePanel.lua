RoleNewUpgradePanel = BaseClass("RoleNewUpgradePanel", BasePanel)

local DataItem = Config.DataItem.data_item
local DataHeroLevAttr = Config.DataHeroLevAttr.Find
local DataHeroLevUpgrade = Config.DataHeroLevUpgrade.Find

function RoleNewUpgradePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleNewUpgradePanel.prefab")
    self.selectItemList = {}
    self.itemObjList = {}
    self.curGoldCost = 0
    self.curLevel = 0
    self.targetLevelLimit = false
    self.isItemEnough = true
    self.curTargetLevel = 0
    self.levelObjList = {}
    self.AttributeItemList = {}
    self.haveItemList = {}

    self.laseCostExp = 0
    self.lastTargetLevel = 0

    self.adsorptionTimer = nil
end

function RoleNewUpgradePanel:__BindEvent()

end

function RoleNewUpgradePanel:__BindListener()
    self.ResetButton_btn.onClick:AddListener(self:ToFunc("ResetUpgradeTarget"))
    self.AutoSelectButton_btn.onClick:AddListener(self:ToFunc("SelectMaxTarget"))
    self.LevelUpButton_btn.onClick:AddListener(self:ToFunc("ClickUpgrade"))
    self.StageTipBtn_btn.onClick:AddListener(self:ToFunc("ClickStageTip"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("onRoleInfoUpdate"))
end

function RoleNewUpgradePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function RoleNewUpgradePanel:__Create()
    self:initCostItem()
    self:initCurrencyBar()
end

function RoleNewUpgradePanel:__delete()
    self:CacheCurrencyBar()
end

function RoleNewUpgradePanel:__Hide()
end

function RoleNewUpgradePanel:__Show()
    self.heroId = self.args.heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.curLevel = self.curRoleInfo.lev
    self.curLevelLimit = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    ---初始化经验物品 RoleConfig.UpgradeItems
    self.selectItemList = {}
    self.curGoldCost = 0
    self.curSelectItem = {}
    self.goldCost = 0
    self:onRoleInfoUpdate(false)
    self:UpdateShow()
end

function RoleNewUpgradePanel:__ShowComplete()
    local config = RoleConfig.GetRoleCameraConfig(self.heroId, RoleConfig.PageCameraType.LevelUp)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("RoleRoot", config.anim)
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("RoleRoot", config.model_rotation)
end

-- ---------------------计算-----------------------------
--计算传入的材料需要消耗多少金币，可以获得多少经验值
function RoleNewUpgradePanel:CalculateCostAndExplore(itemList)
    local cost = 0
    local explore = 0
    for itemId, count in pairs(itemList) do
        cost = cost + count * (DataItem[itemId].property2 or 0)
        explore = explore + count * (DataItem[itemId].property1 or 0)
    end
    return cost, explore
end

--计算最大可升级等级，受金币和经验限制
function RoleNewUpgradePanel:CalculateMaxTargetLevel()
    local curLevel = self.curRoleInfo.lev
    local needExp = -self.curRoleInfo.exp
    --local haveGold = self:GetGoldCount()
    for i = curLevel + 1, self.curLevelLimit do
        needExp = needExp + DataHeroLevUpgrade[i].need_exp
    end
    local selectItemList = {}
    local item = { 20103, 20102, 20101 }

    for _, itemId in ipairs(item) do
        local count = mod.BagCtrl:GetItemCountById(itemId)
        selectItemList[itemId] = math.ceil(needExp / DataItem[itemId].property1)
        selectItemList[itemId] = selectItemList[itemId] > count and count or selectItemList[itemId]
        --if selectItemList[itemId] * (DataItem[itemId].property2 or 0) > haveGold then
        --selectItemList[itemId] = math.floor(haveGold / DataItem[itemId].property2)
        --end
        --haveGold = haveGold - selectItemList[itemId] * (DataItem[itemId].property2 or 0)
        needExp = needExp - selectItemList[itemId] * DataItem[itemId].property1
    end

    local targetLevel, explore, cost = self:CalculateTargetLevel(selectItemList)
    self.maxTargetLevel = targetLevel
    return selectItemList
end

--计算达到目标等级需要的经验值
function RoleNewUpgradePanel:CalculateCostByLevel()
    ---计算当前拥有材料可提供的经验值
    local haveExp = 0
    for _, itemId in pairs(RoleConfig.UpgradeItems) do
        local itemCount = mod.BagCtrl:GetItemCountById(itemId)
        haveExp = haveExp + DataItem[itemId].property1 * itemCount
    end
    ------------------看能否升到满级
    local curLevel = self.curRoleInfo.lev
    local maxNeedExp = 0
    for i = curLevel + 1, self.curLevelLimit do
        maxNeedExp = maxNeedExp + DataHeroLevUpgrade[i].need_exp
    end
    maxNeedExp = maxNeedExp - self.curRoleInfo.exp
    ---不需要升级了
    if maxNeedExp <= 0 then
        for k, itemId in pairs(RoleConfig.UpgradeItems) do
            self.selectItemList[itemId] = 0
            self:updateCostItem(itemId)
        end
        self:updateCostAndExplore()
        return
    end

    if maxNeedExp >= haveExp then
        for k, itemId in pairs(RoleConfig.UpgradeItems) do
            self.selectItemList[itemId] = mod.BagCtrl:GetItemCountById(itemId)
            self:updateCostItem(itemId)
        end
    else
        ---依次选择每种材料的用量
        local item = { 20103, 20102, 20101 }
        for k, itemId in pairs(item) do
            local itemCount = mod.BagCtrl:GetItemCountById(itemId)
            if maxNeedExp > 0 then
                self.selectItemList[itemId] = math.min(itemCount, math.floor(maxNeedExp / DataItem[itemId].property1))
                maxNeedExp = maxNeedExp - DataItem[itemId].property1 * self.selectItemList[itemId]
            end
        end
        ---补齐不足
        for _, itemId in pairs(RoleConfig.UpgradeItems) do
            local itemCount = mod.BagCtrl:GetItemCountById(itemId)
            if maxNeedExp > 0 and self.selectItemList[itemId] < itemCount then
                local addCount = math.min(itemCount - self.selectItemList[itemId], math.ceil(maxNeedExp / DataItem[itemId].property1))
                self.selectItemList[itemId] = self.selectItemList[itemId] + addCount
                maxNeedExp = maxNeedExp - DataItem[itemId].property1 * addCount
            end
            self:updateCostItem(itemId)
        end
    end
    self:updateCostAndExplore()
end

--根据选择的材料，计算可达等级/经验值
function RoleNewUpgradePanel:CalculateTargetLevel(itemList)
    local cost, explore = self:CalculateCostAndExplore(itemList)
    local curLevel = self.curRoleInfo.lev
    local curExp = self.curRoleInfo.exp
    local costExp = explore
    explore = explore + curExp
    local targetLevel = curLevel
    if curLevel >= self.curLevelLimit then
        return curLevel, curExp, cost, costExp
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

    return targetLevel, explore, cost, costExp
end

function RoleNewUpgradePanel:GetGoldCount()
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
function RoleNewUpgradePanel:UpdateShow()
    self:updateCostAndExplore()
    self:CalculateMaxTargetLevel()
end

-- 初始化货币栏
function RoleNewUpgradePanel:initCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.GoldCurrencyBar, 2)
end

-- 移除货币栏
function RoleNewUpgradePanel:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end

--初始化材料列表
function RoleNewUpgradePanel:initCostItem()
    TableUtils.ClearTable(self.curSelectItem)
    TableUtils.ClearTable(self.haveItemList)
    for i, itemId in ipairs(RoleConfig.UpgradeItems) do
        if DataItem[itemId] then
            local itemObj = self:GetCostItem()
            local icon = ItemConfig.GetItemIcon(itemId)
            SingleIconLoader.Load(itemObj.Icon, icon)
            local count = mod.BagCtrl:GetItemCountById(itemId)
            self.haveItemList[itemId] = count
            itemObj.Count_txt.text = count
            self:SetQuality(itemObj, DataItem[itemId].quality)
            ---点击加材料
            local onClickAddFunc = function()
                self:OnSelectItem(itemId, 1)
            end
            itemObj.Icon_btn.onClick:RemoveAllListeners()
            itemObj.Icon_btn.onClick:AddListener(onClickAddFunc)
            ---减少材料
            local onClickSubFunc = function()
                self:OnSelectItem(itemId, -1)
            end
            itemObj.Sub_btn.onClick:RemoveAllListeners()
            itemObj.Sub_btn.onClick:AddListener(onClickSubFunc)
            ---长按加材料
            local dragBehaviour = itemObj.Icon:AddComponent(UIDragBehaviour)
            dragBehaviour.onPointerDown = function(data)
                LuaTimerManager.Instance:RemoveTimer(self.longTouchTimer)
                LuaTimerManager.Instance:RemoveTimer(self.longTouchSelectTimer)
                self.longTouchTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function()
                    local maxCount = mod.BagCtrl:GetItemCountById(itemId)
                    self.longTouchSelectTimer = LuaTimerManager.Instance:AddTimer(maxCount, 0.1, function()
                        self:OnSelectItem(itemId, 1)
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
function RoleNewUpgradePanel:GetCostItem()
    local obj = self:PopUITmpObject("CostItem")
    obj.objectTransform:SetParent(self.CostList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end
--更新材料ui
function RoleNewUpgradePanel:updateCostItem(itemId)
    local itemCount = mod.BagCtrl:GetItemCountById(itemId)
    self.itemObjList[itemId].Select:SetActive(false)
    self.itemObjList[itemId].Lack:SetActive(false)
    local selectCount = self.selectItemList[itemId] or 0

    if selectCount > itemCount then
        self.itemObjList[itemId].Lack:SetActive(true)
    elseif selectCount > 0 and selectCount <= itemCount then
        self.itemObjList[itemId].Select:SetActive(true)
    end
    self.itemObjList[itemId].Sub:SetActive(selectCount > 0)
    self.itemObjList[itemId].SelectCount_txt.text = selectCount
end

--设置材料品质
function RoleNewUpgradePanel:SetQuality(itemObj, quality)
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
function RoleNewUpgradePanel:updateCostAndExplore()
    local targetLevel, explore, cost, costExp = self:CalculateTargetLevel(self.selectItemList)
    local haveGold = self:GetGoldCount()
    local itemEnough = true
    for k, itemId in pairs(RoleConfig.UpgradeItems) do
        local selectCount = self.selectItemList[itemId] or 0
        local itemCount = mod.BagCtrl:GetItemCountById(itemId)
        if selectCount > itemCount then
            itemEnough = false
        end
    end

    if self.laseCostExp == 0 and costExp > 0 then
        self.ExpAddNumber_Open:SetActive(true)
    end
    if self.lastTargetLevel <= self.curRoleInfo.lev and targetLevel > self.curRoleInfo.lev then
        self.LevelAddNumber_Open:SetActive(true)
    end

    if cost > haveGold then
        self.MoneyCostText_txt.text = string.format("<color=#eb6f00>%s</color>", cost)
    else
        self.MoneyCostText_txt.text = string.format("<color=#9b9fad>%s</color>", cost)
    end
    self.lastTargetLevel = self.curTargetLevel
    self.curTargetLevel = targetLevel
    if targetLevel == self.curLevel then
        self.LevelAddNumber_txt.text = ""
    else
        self.LevelAddNumber_txt.text = "+" .. (targetLevel - self.curRoleInfo.lev)
    end
    self.ExpAddNumber_txt.text = costExp == 0 and "" or "+" .. costExp
    self.ResetButton:SetActive(costExp > 0)
    self.LevelUpButton:SetActive(costExp > 0)
    if self.curLevel >= 10 then
        UnityUtils.SetAnchoredPosition(self.MaxLevel_rect, 90, 0)
    else
        UnityUtils.SetAnchoredPosition(self.MaxLevel_rect, 60, 0)
    end
    local config = DataHeroLevUpgrade[self.curLevel + 1]
    if config then
        local needPercent = (config.need_exp - self.curRoleInfo.exp) / config.need_exp
        local curPercent = costExp / config.need_exp
        UnityUtils.SetSizeDelata(self.AddExp.transform, (curPercent > needPercent and needPercent or curPercent) * 298, 8)
    end

    self.targetLevelLimit = targetLevel == self.curLevelLimit
    self.laseCostExp = costExp
    self:updateAttributeChange()
end

function RoleNewUpgradePanel:onRoleInfoUpdate(isUnlock)
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.curLevel = self.curRoleInfo.lev
    self.curLevelLimit = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    TableUtils.ClearTable(self.selectItemList)
    --self.curTargetLevel = 0
    self.curGoldCost = 0

    for itemId, item in pairs(self.itemObjList) do
        item.Select:SetActive(false)
        item.Lack:SetActive(false)
        item.Sub:SetActive(false)
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
    self.CurLevel_txt.text = self.curLevel
    self.MaxLevel_txt.text = "/" .. self.curLevelLimit
    local config = DataHeroLevUpgrade[self.curLevel + 1]
    self.ExpNumber_txt.text = config and self.curRoleInfo.exp .. "/" .. config.need_exp or ""
    if self.curLevel >= 10 then
        UnityUtils.SetAnchoredPosition(self.MaxLevel_rect, 95, 0)
    else
        UnityUtils.SetAnchoredPosition(self.MaxLevel_rect, 60, 0)
    end

    local explorePercent = config and self.curRoleInfo.exp / config.need_exp or 1
    UnityUtils.SetSizeDelata(self.CurExp.transform, explorePercent * 298, 8)
    UnityUtils.SetAnchoredPosition(self.AddExp_rect, explorePercent * 298 + 1, 1)
    self.StageTipText_txt.text = "LV." .. self.curLevelLimit

    if Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)] then
        self.StageTip:SetActive(true)
        UnityUtils.SetAnchoredPosition(self.AttributeInfo_rect, 0, -53)
    else
        self.StageTip:SetActive(false)
        UnityUtils.SetAnchoredPosition(self.AttributeInfo_rect, 0, -13)
    end

    self:UpdateShow()
end

-- --------------------------交互逻辑--------------------------
--选择当前最大可达等级
function RoleNewUpgradePanel:SelectMaxTarget()
    if self.curRoleInfo.lev >= self.curLevelLimit then
        return
    end
    self:CalculateCostByLevel()
    self:updateCostAndExplore()
end

--点击升级按钮
function RoleNewUpgradePanel:ClickUpgrade()
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
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
        MsgBoxManager.Instance:ShowTips(TI18N("金币不足"))
        return
    end

    if not self.upgradeLock then
        mod.RoleCtrl:RoleUpgrade(self.args.heroId, itemList)
        self.upgradeLock = true
    end
end

--点击重置按钮
function RoleNewUpgradePanel:ResetUpgradeTarget()
    self:onRoleInfoUpdate(false)
end

--选择材料
function RoleNewUpgradePanel:OnSelectItem(itemId, count)
    if not self.selectItemList[itemId] then
        self.selectItemList[itemId] = 0
    end
    if self.targetLevelLimit and count > 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("已达等级上限"))
        return
    end
    if self.selectItemList[itemId] + count >= 0 and self.selectItemList[itemId] + count <= mod.BagCtrl:GetItemCountById(itemId) then
        self.selectItemList[itemId] = self.selectItemList[itemId] + count
    else
        MsgBoxManager.Instance:ShowTips(TI18N("道具数量不足"))
    end

    self:updateCostItem(itemId)
    self:updateCostAndExplore()
end

function RoleNewUpgradePanel:updateAttributeChange()
    ---比较当前等级和目标等级
    ---计算属性
    ---显示
    local oldAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
    local stageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage)

    if self.curTargetLevel > self.curRoleInfo.lev then
        ---show
        local attrId = UtilsBase.GetStringKeys(self.heroId, self.curTargetLevel)
        local newAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curTargetLevel)
        for index, attr_id in pairs(DataHeroLevAttr[attrId].ui_show_attr) do
            local item = self.AttributeItemList[index] or self:getAttributeItem()
            item.Name_txt.text = Config.DataAttrsDefine.Find[attr_id].name
            local curValue = oldAttr[attr_id] + stageAttr[attr_id] or 0
            local nextValue = newAttr[attr_id] + stageAttr[attr_id] or 0
            if EntityAttrsConfig.AttrPercent2Attr[attr_id] then
                curValue = curValue * 0.01 .. "%"
                nextValue = nextValue * 0.01 .. "%"
            end
            UnityUtils.SetAnchoredPosition(item.OldValue_rect, -107, 0)
            item.OldValue_txt.text = curValue
            item.NewValue_txt.text = nextValue
            item.NewValue:SetActive(true)
            item.OldValue:SetActive(true)
            item.Arrow:SetActive(true)
            item.UpArrow:SetActive(true)
            item.Bg:SetActive(index % 2 ~= 0)
            self.AttributeItemList[index] = item

            if self.lastTargetLevel == 0 or self.lastTargetLevel == self.curRoleInfo.lev then
                item.AttributeItem_Select:SetActive(true)
            end
        end
    else
        local attrId = UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.lev)
        for index, attr_id in pairs(DataHeroLevAttr[attrId].ui_show_attr) do
            local item = self.AttributeItemList[index] or self:getAttributeItem()
            item.Name_txt.text = Config.DataAttrsDefine.Find[attr_id].name
            local curValue = oldAttr[attr_id] + stageAttr[attr_id] or 0
            if EntityAttrsConfig.AttrPercent2Attr[attr_id] then
                curValue = curValue * 0.01 .. "%"
            end
            UnityUtils.SetAnchoredPosition(item.OldValue_rect, 107, 0)
            item.OldValue_txt.text = curValue
            item.OldValue:SetActive(true)
            item.NewValue:SetActive(false)
            item.Arrow:SetActive(false)
            item.UpArrow:SetActive(false)
            item.Bg:SetActive(index % 2 ~= 0)
            self.AttributeItemList[index] = item

            if self.lastTargetLevel > self.curRoleInfo.lev then
                item.AttributeItem_fanhui:SetActive(true)
            end
        end
    end
end

function RoleNewUpgradePanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    obj.objectTransform:SetParent(self.AttributeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(false)
    return obj
end

function RoleNewUpgradePanel:ClickStageTip()
    self.parentWindow:OpenPanel(RoleStageUpDescPanel, { heroId = self.heroId })
end

function RoleNewUpgradePanel:OnClose()
    LuaTimerManager.Instance:RemoveTimer(self.unlockTimer)
    self.RoleNewUpgradePanel_Exit:SetActive(true)
end