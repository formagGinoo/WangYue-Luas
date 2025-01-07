WeaponUpgradePanelV2 = BaseClass("WeaponUpgradePanelV2", BasePanel)

function WeaponUpgradePanelV2:__init()
    self:SetAsset("Prefabs/UI/Weapon/WeaponUpgradePanelV2.prefab")
    self.sortType = BagEnum.SortType.Quality
    self.cacheMap = {}
    self.attrList = {}
end

function WeaponUpgradePanelV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.WeaponUpgradeComplete, self:ToFunc("WeaponUpgradeComplete"))
end

function WeaponUpgradePanelV2:__BindEvent()
    EventMgr.Instance:AddListener(EventName.WeaponUpgradeComplete, self:ToFunc("WeaponUpgradeComplete"))
end

function WeaponUpgradePanelV2:__BindListener()
    self.AddButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.MoreButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.UpgradeButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
    self.StageTip_btn.onClick:AddListener(self:ToFunc("ClickStageTip"))
end

function WeaponUpgradePanelV2:__Hide()
    --自动选择列表
    self.autoSelectList ={}
    --抽象类型列表
    self.abstractList = {}
	self:RemoveSelect()
    for key, value in pairs(self.attrList) do
        self:CacheAttrObj(value)
    end
    self.attrList = {}
end

function WeaponUpgradePanelV2:__Show()
    self.autoSelectList = {}
    self.abstractList = {}

    self:ShowDetail()
end

function WeaponUpgradePanelV2:WeaponInfoChange()
    self.targetLev = nil
    self:ShowDetail()
end

--#region 界面逻辑
function WeaponUpgradePanelV2:ShowDetail(uniqueId)
    local weaponData = self:GetWeaponData()
    local limitLev = RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage).level_limit
    local needExp = RoleConfig.GetWeaponLevelExp(weaponData.template_id, weaponData.lev + 1)
    
    if RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage + 1) then
        self.StageTip_rect:SetParent(self.AttributeList_rect)
        self.StageTip_rect:SetAsFirstSibling()
        self.StageTipText_txt.text = string.format(TI18N("LV.%s"), limitLev)
    else
        self.StageTip_rect:SetParent(self.Cache_rect)
    end

    self.CurLevel_txt.text = weaponData.lev
    self.MaxLevel_txt.text = limitLev
    self.AddExp_img.fillAmount = 0
    self.CurExp_img.fillAmount = weaponData.exp / needExp
    self.ExpNumber_txt.text = string.format("%s/%s", weaponData.exp, needExp)
    self.CostMoneyCount_txt.text = 0
    self.LevelAddNumber_txt.text = ""
    self.ExpAddNumber_txt.text = ""

    self:ShowAttrChange()
end

--显示前4个道具
function WeaponUpgradePanelV2:UpdateShowItem()
    self:ShowAttrChange()
    local itemList = {}
    local weaponList = {}
    for type, list in pairs(self.autoSelectList) do
        for key, value in pairs(list) do
            if type == BagEnum.BagType.Item then
                table.insert(itemList, {id = key, count = value})
            elseif type == BagEnum.BagType.Weapon then
                table.insert(weaponList, {id = key, count = value})
            end
        end
    end
    table.sort(itemList, function (a, b)
        return ItemConfig.GetItemConfig(a.id).quality > ItemConfig.GetItemConfig(b.id).quality
    end)

    table.sort(weaponList, function (a, b)
        local aConfig = ItemConfig.GetItemConfig(mod.BagCtrl:GetWeaponData(a.id).template_id)
        local bConfig = ItemConfig.GetItemConfig(mod.BagCtrl:GetWeaponData(b.id).template_id)
        if mod.BagCtrl:GetWeaponData(a.id).lev ~= mod.BagCtrl:GetWeaponData(b.id).lev then
            return mod.BagCtrl:GetWeaponData(a.id).lev > mod.BagCtrl:GetWeaponData(b.id).lev
        end
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end
        if aConfig.type ~= bConfig.type then
            return aConfig.type > bConfig.type
        end
        return aConfig.order_id > aConfig.order_id
    end)

    local showCount = 0
    self.commonItems = self.commonItems or {}
    for index, value in ipairs(itemList) do
        if showCount == 4 then
           break
        end
        showCount = showCount + 1
        local itemInfo = {template_id = value.id, count = value.count, scale = 0.8, btnFunc = self:ToFunc("OpenSelectPanel")}
        --local item = ItemManager.Instance:GetItem(self.CostList_rect, itemInfo, true)
        if not self.commonItems[showCount] then
            self.commonItems[showCount] = CommonItem.New()
            self.commonItems[showCount]:InitItem(self["ItemObj"..showCount], nil, true)
        end
        UtilsUI.SetActive(self["ItemObj"..showCount], true)
        self.commonItems[showCount]:SetItem(itemInfo)
        self.commonItems[showCount]:Show()
    end

    for index, value in ipairs(weaponList) do
        if showCount == 4 then
            break
        end
        showCount = showCount + 1
        local itemInfo = mod.BagCtrl:GetWeaponData(value.id)
        local copyInfo = UtilsBase.copytab(itemInfo)
        copyInfo.scale = 0.8
        copyInfo.btnFunc = self:ToFunc("OpenSelectPanel")
        --local item = ItemManager.Instance:GetItem(self.CostList_rect, copyInfo, true)
        if not self.commonItems[showCount] then
            self.commonItems[showCount] = CommonItem.New()
            self.commonItems[showCount]:InitItem(self["ItemObj"..showCount], nil, true)
        end
        UtilsUI.SetActive(self["ItemObj"..showCount], true)
        self.commonItems[showCount]:SetItem(copyInfo)
        self.commonItems[showCount]:Show()
    end
    UtilsUI.SetActive(self.AddGroup, showCount < 4)
    for i = showCount + 1, 4, 1 do
        UtilsUI.SetActive(self["ItemObj"..i], false)
    end

    if self.allCount and self.allCount > 0 then
        self.MoreButton:SetActive(true)
        self.CostTip_txt.text =  string.format(TI18N("选择物品(已选%s个)"), self.allCount)
        self.CountText_txt.text = self.allCount
    else
        self.MoreButton:SetActive(false)
        self.CostTip_txt.text =  TI18N("选择物品")
    end
end
--预览属性变化
function WeaponUpgradePanelV2:ShowAttrChange()
    local targetLev = self.targetLev
    local weaponData = self:GetWeaponData()

    local oldAttrTable = RoleConfig.GetWeaponBaseAttrs(weaponData.template_id, weaponData.lev, weaponData.stage)
    local newAttrTable
    if targetLev and weaponData.lev ~= targetLev  then
        newAttrTable = RoleConfig.GetWeaponBaseAttrs(weaponData.template_id, targetLev, weaponData.stage)
    end

    local count = 0
    if newAttrTable then
        for index, value in pairs(newAttrTable) do
            count = count + 1
            local node = self.attrList[count] or self:GetAttrObj()
            node.AttrObject_Select:SetActive(true)
            node.AttrObject_fanhui:SetActive(false)
            local oldValue = oldAttrTable[index] or value
            node.AttrText_txt.text, node.OldValue_txt.text = RoleConfig.GetShowAttr(index, oldValue)
            node.AttrText_txt.text, node.NewValue_txt.text = RoleConfig.GetShowAttr(index, value)
            node.arrow2:SetActive(oldValue ~= value)
            node.BG:SetActive(math.fmod(count, 2) ~= 0)
            table.insert(self.attrList, node)
        end
    else
        for index, value in pairs(oldAttrTable) do
            count = count + 1
            local isInit = not self.attrList[count] and true
            local node = self.attrList[count] or self:GetAttrObj()
            if node.AttrObject_Select.activeSelf then
                node.AttrObject_fanhui:SetActive(not isInit and true)
            end
            node.AttrObject_Select:SetActive(false)

            node.AttrText_txt.text, node.CurValue_txt.text = RoleConfig.GetShowAttr(index, value)
            node.BG:SetActive(math.fmod(count, 2) ~= 0)
            table.insert(self.attrList, node)
        end
    end
end

function WeaponUpgradePanelV2:GetAttrObj()
    local node
    if next(self.cacheMap) then
        node = table.remove(self.cacheMap)
    else
 
		node = self:PopUITmpObject("AttrObject")
        node.objectTransform:SetParent(self.AttributeList_rect)
        UtilsUI.GetContainerObject(node.objectTransform, node)
    end
    node.objectTransform:SetParent(self.AttributeList_rect)
    node.objectTransform:SetActive(false)
    UnityUtils.SetLocalScale(node.objectTransform, 1, 1, 1)
    return node
end

function WeaponUpgradePanelV2:CacheAttrObj(node)
    node.objectTransform:SetParent(self.Cache_rect)
    node.AttrObject_Select:SetActive(false)
    node.AttrObject_fanhui:SetActive(false)
    node.NewValue:SetActive(true)
    node.arrow1:SetActive(true)
    node.arrow2:SetActive(true)
    table.insert(self.cacheMap, node)
end

function WeaponUpgradePanelV2:OpenSelectPanel()
    local config ={
        width = 687,
        col = 5,
        bagType = BagEnum.BagType.Weapon,
        additionItem = RoleConfig.WeaponUpgradeItems,
        selectList = self.autoSelectList,
        quality = 4,
        upgradeItem = self:GetWeaponData().unique_id,
        selectMode = 2,
        pauseSelect = self.notSelect,
        pauseSelectFunc = function ()
            MsgBoxManager.Instance:ShowTips(TI18N("已达最大经验，无法添加"))
        end,
        onClick = self:ToFunc("AddSelectItem"),
        reduceFunc = self:ToFunc("ReduceSelectItem"),
		batchSelectionFunc = self:ToFunc("BatchSelectionFunc")
    }
    self.parentWindow:OpenPanel(ItemSelectPanelV2,{config = config})
end
--#endregion

--#region 数据管理

function WeaponUpgradePanelV2:RemoveSelect()
    self.autoSelectList = {}
    self.allCount = 0
    self.selectExp = 0
    self.needGold = 0
    self.notSelect = false
    self.targetLev = nil
    if self.parentWindow:GetPanel(ItemSelectPanelV2) then
        self.parentWindow:GetPanel(ItemSelectPanelV2):ResetBatchSelection()
    end
    self:UpdateShowItem()
end

--手动选择物品
function WeaponUpgradePanelV2:AddSelectItem(uniqueId, itemId, type, onlyData)
    if not self.autoSelectList[type] then
        self.autoSelectList[type] = {}
    end
    local exp, gold = 0, 0
    if type == BagEnum.BagType.Item then
        self.autoSelectList[type][itemId] = self.autoSelectList[type][itemId] or 0
        self.autoSelectList[type][itemId] = self.autoSelectList[type][itemId] + 1
        local itemConfig = ItemConfig.GetItemConfig(itemId)
        exp = itemConfig.property1
        gold = itemConfig.property2
    elseif type == BagEnum.BagType.Weapon then
        self.autoSelectList[type][uniqueId] = 1
        exp, gold = self:GetWeaponExp(uniqueId)
    end
    self.allCount = self.allCount or 0
    self.allCount = self.allCount + 1

    --判断是否可以继续添加
    self:SelectChange(exp, gold, true, onlyData)
end
--手动移除物品
function WeaponUpgradePanelV2:ReduceSelectItem(uniqueId, itemId, type, onlyData)
    if not self.autoSelectList[type] then
        return
    end
    local exp, gold = 0, 0
    if type == BagEnum.BagType.Item then
        self.autoSelectList[type][itemId] = self.autoSelectList[type][itemId] - 1
        if self.autoSelectList[type][itemId] == 0 then
            self.autoSelectList[type][itemId] = nil
        end
		local itemConfig = ItemConfig.GetItemConfig(itemId)
		exp = itemConfig.property1
		gold = itemConfig.property2
    elseif type == BagEnum.BagType.Weapon then
        self.autoSelectList[type][uniqueId] = nil
        exp, gold = self:GetWeaponExp(uniqueId)
    end

    self.allCount = self.allCount or 0
    self.allCount = self.allCount - 1

    --判断是否可以继续添加
    self:SelectChange(exp, gold, nil, onlyData)
end
--手动操作后数据修改
function WeaponUpgradePanelV2:SelectChange(exp, gold, isAdd, onlyData)
    self.selectExp = self.selectExp or 0
    self.needGold = self.needGold or 0
    if isAdd then
        self.selectExp = self.selectExp + exp
        self.needGold = self.needGold + gold
    else
        self.selectExp = self.selectExp - exp
        self.needGold = self.needGold - gold
    end
    self:SetMoneyCost(self.needGold)
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id

    local tempExp = self.selectExp or 0
    local startLev = weaponData.lev
    local limitLev = RoleConfig.GetStageConfig(weaponId, weaponData.stage).level_limit

    local overflow = 0
    local maxExp = 0
    local level = 0

    for i = startLev + 1, limitLev, 1 do
        if i == startLev + 1 then
            if RoleConfig.GetWeaponLevelExp(weaponId,i) - weaponData.exp > tempExp then
                overflow = weaponData.exp + tempExp
                maxExp = RoleConfig.GetWeaponLevelExp(weaponId,i)
                level = i - 1
                break
            end
            tempExp = tempExp - (RoleConfig.GetWeaponLevelExp(weaponId,i) - weaponData.exp)
        else
            if RoleConfig.GetWeaponLevelExp(weaponId,i) > tempExp then
                overflow = tempExp
                maxExp = RoleConfig.GetWeaponLevelExp(weaponId,i)
                level = i - 1
                break
            end
            tempExp = tempExp - RoleConfig.GetWeaponLevelExp(weaponId,i)
        end
		overflow = tempExp
		level = i
    end

    if level >= limitLev then
        self.notSelect = true
	else
		self.notSelect = false
    end
    if self.parentWindow:GetPanel(ItemSelectPanelV2) then
        self.parentWindow:GetPanel(ItemSelectPanelV2):PauseSelect(level == limitLev)
    end

    self.targetLev = level
    if onlyData then
        return
    end

    if level > weaponData.lev then
        self.AddExp_img.fillAmount = 1
        self.LevelAddNumber_txt.text = string.format("+%s", level - weaponData.lev)
    else
        local oldMax = RoleConfig.GetWeaponLevelExp(weaponData.template_id, weaponData.lev + 1)
        self.AddExp_img.fillAmount = (self.selectExp + weaponData.exp) / oldMax
        self.LevelAddNumber_txt.text = ""
    end
    if self.selectExp and self.selectExp > 0 then
        self.ExpAddNumber_txt.text = string.format("+%s", self.selectExp)
    else
        self.ExpAddNumber_txt.text = ""
    end

    self:UpdateShowItem()
end

function WeaponUpgradePanelV2:BatchSelectionFunc()
    self:SelectChange(0,0,true)
end

function WeaponUpgradePanelV2:SetMoneyCost(needGold)
    local curGold = mod.BagCtrl:GetGoldCount()
    self.CostMoneyCount_txt.text = ItemConfig.GetGoldShowCount(curGold, needGold)
end

--获取武器能提供多少经验值
function WeaponUpgradePanelV2:GetWeaponExp(uniqueId)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    local weaponId = weaponData.template_id
    local exp = 0
    local gold = 0
    if RoleConfig.GetWeaponQualityConfig(weaponId) then
        gold = RoleConfig.GetWeaponQualityConfig(weaponId).need_gold
    end

    if weaponData.lev > 1 then
        for i = 1, weaponData.lev, 1 do
            exp = exp + RoleConfig.GetWeaponLevelExp(weaponId,i)
        end
        exp = math.floor(exp * 0.8)
    end
    if RoleConfig.GetWeaponQualityConfig(weaponId) then
        exp = exp + RoleConfig.GetWeaponQualityConfig(weaponId).add_exp
    end
    return exp, gold
end

--升级
function WeaponUpgradePanelV2:OnClick_Upgrade()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end

    if not next(self.autoSelectList) then
        self:OpenSelectPanel()
        return
    end
    if self.needGold > mod.BagCtrl:GetGoldCount() then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
        return
    end

    if self.lockOnClick then
        return
    end
    self.lockOnClick = true

    self.parentWindow:ClosePanel(ItemSelectPanelV2)
    local weapon_id = self:GetWeaponData().unique_id
    local weapon_id_list = {}
    local item_list = {}
    for type, list in pairs(self.autoSelectList) do
        if type == BagEnum.BagType.Weapon then
            for key, value in pairs(list) do
                table.insert(weapon_id_list, key)
            end
        elseif type == BagEnum.BagType.Item then
            for key, value in pairs(list) do
                table.insert(item_list, {key = key, value = value})
            end
        end
    end
    mod.RoleCtrl:WeaponUpgrade(weapon_id, weapon_id_list, item_list)
end

function WeaponUpgradePanelV2:ClickStageTip()
    local stage = self:GetWeaponData().stage + 1
    local id = self:GetWeaponData().template_id
    local baseConfig = RoleConfig.GetStageConfig(id, stage)
    local showBaseText = true
    local targetLev
    if not baseConfig then
        stage = stage - 1
        showBaseText = false
        baseConfig = RoleConfig.GetStageConfig(id, stage)
    else
        local oldConfig = RoleConfig.GetStageConfig(id, stage - 1)
        targetLev = oldConfig.level_limit
    end
    local config = 
    {
        showBaseText = showBaseText,
        targetLev = targetLev,
        baseText = TI18N("武器达到         可突破"),
        stage = stage,
        stageInfo = baseConfig.stage_info
    }
    PanelManager.Instance:OpenPanel(StageUpDescPanel, {config = config})
end

function WeaponUpgradePanelV2:WeaponUpgradeComplete()
    self.lockOnClick = false
    self:RemoveSelect()
end

function WeaponUpgradePanelV2:GetWeaponData()
    return self.parentWindow:GetWeaponData()
end

function WeaponUpgradePanelV2:HideAnim()
    self.WeaponUpgradePanelV2_Exit:SetActive(true)
end