PartnerUpgradePanel = BaseClass("PartnerUpgradePanel", BasePanel)

function PartnerUpgradePanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerUpgradePanel.prefab")
    self.sortType = BagEnum.SortType.Quality
    self.cacheMap = {}
    self.attrList = {}
end

function PartnerUpgradePanel:__delete()
    --EventMgr.Instance:RemoveListener(EventName.PartnerUpgradeComplete, self:ToFunc(""))
end

function PartnerUpgradePanel:__BindEvent()
    --EventMgr.Instance:AddListener(EventName.PartnerUpgradeComplete, self:ToFunc(""))
end

function PartnerUpgradePanel:__CacheObject()
    self.delayShow = self.AttributeList:GetComponent(LayoutDelayShow)
end

function PartnerUpgradePanel:__BindListener()
    self.AddButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.MoreButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.UpgradeButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
    self.StageTip_btn.onClick:AddListener(self:ToFunc("ClickStageTip"))
end

function PartnerUpgradePanel:__Hide()
    --自动选择列表
    self.autoSelectList ={}
    self:CacheAllAttrObj()
end

function PartnerUpgradePanel:__Show()
    self.autoSelectList = {}
    self:ShowDetail()
    self:RemoveSelect()
    self:SetCameraSetings()
end

function PartnerUpgradePanel:PartnerInfoChange()
    self.targetLev = nil
    --TODO 暂时在这里重置
    self:RemoveSelect()
    self:ShowDetail()
end

function PartnerUpgradePanel:SetCameraSetings()
    local partner = self:GetPartnerData().template_id
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.Level)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("PartnerRoot", cameraConfig.model_rotation)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("PartnerRoot", cameraConfig.anim, 0.5)
    CustomUnityUtils.SetDepthOfFieldBoken(true, cameraConfig.camera_position.z - 2.7, 300, cameraConfig.aperture or 10)
end

--#region 界面逻辑
function PartnerUpgradePanel:ShowDetail(uniqueId)
    local partnerData = self:GetPartnerData()
    local limitLev = RoleConfig.PartnerMaxLev
    local needExp = RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1)
    
    local unlockLev, count = RoleConfig.GetPartnerNextUnlockSkillCount(partnerData.template_id, partnerData.lev)
    if unlockLev then
        self.StageTip_rect:SetParent(self.AttributeList_rect)
        self.StageTip_rect:SetAsFirstSibling()
        self.StageTipText_txt.text = string.format("LV.%s", unlockLev)
        self.StageTipText2_txt.text = string.format(TI18N("解锁%s个随机新战技"), count)
    else
        self.StageTip_rect:SetParent(self.Cache_rect)
    end

    self.CostMoneyCount_txt.text = 0
    self.LevelAddNumber_txt.text = ""
    self.ExpAddNumber_txt.text = ""
    self.CurLevel_txt.text = partnerData.lev
    self.MaxLevel_txt.text = limitLev
    self.AddExp_img.fillAmount = 0

    if needExp then
        self.Bottom:SetActive(true)
    else
        self.Bottom:SetActive(false)
        self.CurExp_img.fillAmount = 1
        self.ExpNumber_txt.text = string.format("%s/%s", partnerData.exp, partnerData.exp)
        return
    end

    self.CurExp_img.fillAmount = partnerData.exp / needExp
    self.ExpNumber_txt.text = string.format("%s/%s", partnerData.exp, needExp)
end

--显示前4个道具
function PartnerUpgradePanel:UpdateShowItem()
    self:ShowAttrChange()
    local itemList = {}
    local partnerList = {}
    for type, list in pairs(self.autoSelectList) do
        for key, value in pairs(list) do
            if type == BagEnum.BagType.Item then
                table.insert(itemList, {id = key, count = value})
            elseif type == BagEnum.BagType.Partner then
                table.insert(partnerList, {id = key, count = value})
            end
        end
    end
    table.sort(itemList, function (a, b)
        return ItemConfig.GetItemConfig(a.id).quality > ItemConfig.GetItemConfig(b.id).quality
    end)

    table.sort(partnerList, function (a, b)
        local aConfig = ItemConfig.GetItemConfig(mod.BagCtrl:GetPartnerData(a.id).template_id)
        local bConfig = ItemConfig.GetItemConfig(mod.BagCtrl:GetPartnerData(b.id).template_id)
        if mod.BagCtrl:GetPartnerData(a.id).lev ~= mod.BagCtrl:GetPartnerData(b.id).lev then
            return mod.BagCtrl:GetPartnerData(a.id).lev > mod.BagCtrl:GetPartnerData(b.id).lev
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

    for index, value in ipairs(partnerList) do
        if showCount == 4 then
            break
        end
        showCount = showCount + 1
        local itemInfo = mod.BagCtrl:GetPartnerData(value.id)
        local copyInfo = UtilsBase.copytab(itemInfo)
        copyInfo.scale = 0.64
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
        self.CostTip_txt.text =  string.format(TI18N("吞并佩从(已选%s个)"), self.allCount)
        self.CountText_txt.text = self.allCount
    else
        self.MoreButton:SetActive(false)
        self.CostTip_txt.text =  TI18N("吞并佩从")
    end
end
--预览属性变化
function PartnerUpgradePanel:ShowAttrChange()
    local targetLev = self.targetLev
    local partnerData = self:GetPartnerData()
    local attrTable = UtilsBase.copytab(partnerData.property_list) or {}
    local showCount = #attrTable
    for i = 1, #attrTable, 1 do
        attrTable[i].priority = RoleConfig.GetAttrPriority(attrTable[i].key)
    end
    table.sort(attrTable, function (a, b)
        return a.priority > b.priority
    end)

    for i = 1, showCount, 1 do
        local attr = attrTable[i]
        local attrValue = RoleConfig.GetPartnerAttr(partnerData.template_id, partnerData.lev, attr.key, attr.value)
        
        local isInit = not self.attrList[i] and true
        local obj = self.attrList[i] or self:GetAttrObj()
        
        local oldState = obj.AttrObject_Select.activeSelf
        obj.AttrObject_Select:SetActive(not isInit and targetLev and targetLev > partnerData.lev)
        obj.AttrObject_fanhui:SetActive(not isInit and oldState and not obj.AttrObject_Select.activeSelf)
        obj.BG:SetActive(math.fmod(i, 2) ~= 0)

        local name, oldValue = RoleConfig.GetShowAttr(attr.key, attrValue)
        obj.AttrText_txt.text = name
        if not targetLev or targetLev == partnerData.lev then
            obj.CurValue_txt.text = oldValue
        else
            obj.OldValue_txt.text = oldValue
			local targetValue = RoleConfig.GetPartnerAttr(partnerData.template_id, targetLev, attr.key, attr.value)
			local _, newVale = RoleConfig.GetShowAttr(attr.key, targetValue)
			obj.NewValue_txt.text = newVale
        end
    end
    self.delayShow:ResetDelay()
    self.delayShow:InitDelayInfo()
end

function PartnerUpgradePanel:GetAttrObj()
    if next(self.cacheMap) then
        local obj = table.remove(self.cacheMap)
        obj.objectTransform:SetParent(self.AttributeList_rect)
        table.insert(self.attrList, obj)
        return obj
    end
    local obj = self:PopUITmpObject("AttrObject")
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetParent(self.AttributeList_rect)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    table.insert(self.attrList, obj)
    return obj
end

function PartnerUpgradePanel:CacheAttrObj(obj)
    obj.objectTransform:SetParent(self.Cache_rect)
    obj.NewValue:SetActive(true)
    obj.arrow1:SetActive(true)
    obj.arrow2:SetActive(true)
    obj.AttrObject_Select:SetActive(false)
    obj.AttrObject_fanhui:SetActive(false)
    table.insert(self.cacheMap, obj)
end

function PartnerUpgradePanel:CacheAllAttrObj()
    for key, value in pairs(self.attrList) do
        self:CacheAttrObj(value)
    end
    self.attrList = {}
end

function PartnerUpgradePanel:OpenSelectPanel()
    local config ={
        name = TI18N("佩从选择"),
        width = 687,
        col = 5,
        bagType = BagEnum.BagType.Partner,
        selectList = self.autoSelectList,
        quality = 4,
        upgradeItem = self:GetPartnerData().unique_id,
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

function PartnerUpgradePanel:RemoveSelect()
    self.autoSelectList = {}
    self.allCount = 0
    self.selectExp = 0
    self.needGold = 0
    self.notSelect = false
    if self.parentWindow:GetPanel(ItemSelectPanelV2) then
        self.parentWindow:GetPanel(ItemSelectPanelV2):ResetBatchSelection()
    end
    self:UpdateShowItem()
end

--手动选择物品
function PartnerUpgradePanel:AddSelectItem(uniqueId, itemId, type, onlyData)
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
    elseif type == BagEnum.BagType.Partner then
        self.autoSelectList[type][uniqueId] = 1
        exp, gold = self:GetPartnerExp(uniqueId)
    end
    self.allCount = self.allCount or 0
    self.allCount = self.allCount + 1

    --判断是否可以继续添加
    self:SelectChange(exp, gold, true, onlyData)
end
--手动移除物品
function PartnerUpgradePanel:ReduceSelectItem(uniqueId, itemId, type, onlyData)
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
    elseif type == BagEnum.BagType.Partner then
        self.autoSelectList[type][uniqueId] = nil
        exp, gold = self:GetPartnerExp(uniqueId)
    end

    self.allCount = self.allCount or 0
    self.allCount = self.allCount - 1

    --判断是否可以继续添加
    self:SelectChange(exp, gold, nil, onlyData)
end

--手动操作后数据修改
function PartnerUpgradePanel:SelectChange(exp, gold, isAdd, onlyData)
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
    local partnerData = self:GetPartnerData()
    local partnerId = partnerData.template_id

    local tempExp = self.selectExp or 0
    local startLev = partnerData.lev

    --TODO 临时写死的等级上限
    local limitLev = RoleConfig.PartnerMaxLev

    local overflow = 0
    local level = 0

    for i = startLev + 1, limitLev, 1 do
        if i == startLev + 1 then
            if RoleConfig.GetPartnerLevelExp(partnerId,i) - partnerData.exp > tempExp then
                overflow = partnerData.exp + tempExp
                level = i - 1
                break
            end
            tempExp = tempExp - (RoleConfig.GetPartnerLevelExp(partnerId,i) - partnerData.exp)
        else
            if RoleConfig.GetPartnerLevelExp(partnerId,i) > tempExp then
                overflow = tempExp
                level = i - 1
                break
            end
            tempExp = tempExp - RoleConfig.GetPartnerLevelExp(partnerId,i)
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
        self.parentWindow:GetPanel(ItemSelectPanelV2):PauseSelect(self.notSelect)
    end

    self.targetLev = level
    if onlyData then
        return
    end

    if level > partnerData.lev then
        self.AddExp_img.fillAmount = 1
        self.LevelAddNumber_txt.text = string.format("+%s", level - partnerData.lev)
    else
        local oldMax = RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1)
        self.AddExp_img.fillAmount = (self.selectExp + partnerData.exp) / oldMax
        self.LevelAddNumber_txt.text = ""
    end
    if self.selectExp and self.selectExp > 0 then
        self.ExpAddNumber_txt.text = string.format("+%s", self.selectExp)
    else
        self.ExpAddNumber_txt.text = ""
    end

    self:UpdateShowItem()
end

function PartnerUpgradePanel:BatchSelectionFunc()
    self:SelectChange(0, 0, true)
end

function PartnerUpgradePanel:SetMoneyCost(needGold)
    local curGold = mod.BagCtrl:GetGoldCount()
    self.CostMoneyCount_txt.text = ItemConfig.GetGoldShowCount(curGold, needGold)
end

function PartnerUpgradePanel:GetPartnerExp(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local exp, gold = RoleConfig.GetPartnerBaseExp(partnerId)
    local extraExp = 0
    if partnerData.lev > 1 then
        for i = 2, partnerData.lev, 1 do
            extraExp = extraExp + RoleConfig.GetPartnerLevelExp(partnerId, i)
        end
    end

    exp = math.floor(exp + extraExp * 0.8)
    return exp, gold
end


--升级
function PartnerUpgradePanel:OnClick_Upgrade()
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

    -- if self.lockOnClick then
    --     return
    -- end
    -- self.lockOnClick = true


    local partner_id = self:GetPartnerData().unique_id
    local partner_id_list = {}
    local item_list = {}
    local skillBackItem = {}
    for type, list in pairs(self.autoSelectList) do
        if type == BagEnum.BagType.Partner then
            for key, value in pairs(list) do
                table.insert(partner_id_list, key)
                local partnerData = mod.BagCtrl:GetPartnerData(key)
                RoleConfig.CalculatePartnerBack(partnerData.skill_list, skillBackItem)
            end
        elseif type == BagEnum.BagType.Item then
            for key, value in pairs(list) do
                table.insert(item_list, {key = key, value = value})
            end
        end
    end

    if next(skillBackItem) then
        local param = {
            itemMap = skillBackItem,
            submitEvent = function ()
                self:SubmitUpgrade(partner_id, partner_id_list)
            end
        }
        PanelManager.Instance:OpenPanel(ItemTipVerifyPanel, param)
        return
    end

    self:SubmitUpgrade(partner_id, partner_id_list)
end

function PartnerUpgradePanel:SubmitUpgrade(partner_id, partner_id_list)
    self.parentWindow:ClosePanel(ItemSelectPanelV2)
    mod.RoleCtrl:PartnerUpgrade(partner_id, partner_id_list)
end

function PartnerUpgradePanel:ClickStageTip()
    local partnerId = self:GetPartnerData().unique_id
    PanelManager.Instance:OpenPanel(PartnerSkillPreviewPanel, {partnerId = partnerId})
end

function PartnerUpgradePanel:PartnerUpgradeComplete()
    self.lockOnClick = false
    self:RemoveSelect()
end

function PartnerUpgradePanel:GetPartnerData()
    return self.parentWindow:GetPartnerData()
end

function PartnerUpgradePanel:HideAnim()
    self.PartnerUpgradePanel_Exit:SetActive(true)
end

