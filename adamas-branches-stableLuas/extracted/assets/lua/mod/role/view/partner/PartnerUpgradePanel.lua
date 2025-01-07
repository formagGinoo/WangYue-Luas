PartnerUpgradePanel = BaseClass("PartnerUpgradePanel", BasePanel)

function PartnerUpgradePanel:__init()
    self:SetAsset("Prefabs/UI/Weapon/LevelUpgradePanel.prefab")
    self.sortType = BagEnum.SortType.Quality
    self.cacheMap = {}
    self.attrList = {}
end

function PartnerUpgradePanel:__delete()
end

function PartnerUpgradePanel:__BindEvent()
end

function PartnerUpgradePanel:__CacheObject()
end

function PartnerUpgradePanel:__BindListener()
    self.AddButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.MoreButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.UpgradeButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
    self.StageTipBtn_btn.onClick:AddListener(self:ToFunc("ClickStageTip"))
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
    --TODO 暂时在这里重置
    self:RemoveSelect()
    self:ShowDetail()
    self.targetLev = nil
end

function PartnerUpgradePanel:SetCameraSetings()
    local partner = self:GetPartnerData().template_id
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.Level)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("PartnerRoot", cameraConfig.model_rotation)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("PartnerRoot", cameraConfig.anim, 0.5)

    local blurConfig = RoleConfig.GetPartnerBlurConfig(partner, RoleConfig.PartnerCameraType.Level)
    Fight.Instance.modelViewMgr:GetView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

--#region 界面逻辑
function PartnerUpgradePanel:ShowDetail(uniqueId)
    local partnerData = self:GetPartnerData()
    local limitLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerData.template_id)
    local needExp = RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1)
    UtilsUI.SetActive(self.LimitTip, not needExp)
    UtilsUI.SetActive(self.UpgradeButton, needExp)
    UtilsUI.SetActive(self.NeedCur, needExp )
    
    local unlockLev, unlockLevConfig = RoleConfig.GetPartnerNextUnlockSkillCount(partnerData.template_id, partnerData.lev)
    if unlockLev then
        self.StageTip_rect:SetParent(self.AttributeList_rect)
        self.StageTip_rect:SetAsFirstSibling()
        local tipStr = string.format(TI18N("升至<color=#ffa234>LV.%s</color>"),unlockLev)
        local addSkillCount = RoleConfig.GetPartenrSkillCountByLev(partnerData.template_id, unlockLev)
        local tipsCount = 0
        if addSkillCount > 0 then
            tipsCount = tipsCount + 1
            local str = ""
            for i, id in ipairs(unlockLevConfig.add_skill) do
                if id ~= 0 then
                    str = string.format("%s <color=#ffa234>%s</color> ",str, RoleConfig.GetPartnerSkillConfig(id).name)
                end
            end
            tipStr = string.format(TI18N("%s解锁天赋技%s"), tipStr, str)
        end
        if unlockLevConfig.add_passive > 0 then
            tipsCount = tipsCount + 1
            if tipsCount == 2 then
                tipStr = string.format(TI18N("%s,<color=#ffa234>%s</color>个被动槽位"), tipStr, unlockLevConfig.add_passive)
            elseif tipsCount == 1 then
                tipStr = string.format(TI18N("%s解锁<color=#ffa234>%s</color>个被动槽位"), tipStr, unlockLevConfig.add_passive)
            end
        end
        if unlockLevConfig.add_plate > 0 then
            tipsCount = tipsCount + 1
            if tipsCount == 2 then
                tipStr = string.format(TI18N("%s,<color=#ffa234>%s</color>个雕纹槽位"), tipStr, unlockLevConfig.add_plate)
            elseif tipsCount == 1 then
                tipStr = string.format(TI18N("%s解锁<color=#ffa234>%s</color>个雕纹槽位"), tipStr, unlockLevConfig.add_plate)
            end
        end
        self.StageTipText_txt.text = tipStr
    else
        self.StageTip_rect:SetParent(self.Cache_rect)
    end

    self.CostMoneyCount_txt.text = 0
    self.LevelAddNumber_txt.text = ""
    -- self.ExpAddNumber_txt.text = ""
    self.Exp_anim:Play("UI_Exp_qeihuan_out_PC", 0, 0)
    self.CurLevel_txt.text = partnerData.lev
    self.MaxLevel_txt.text = limitLev
    self.AddExp_img.fillAmount = 0

    if needExp then
        self.Bottom:SetActive(true)
    else
        self.Bottom:SetActive(false)
        self.CurExp_img.fillAmount = 1
        needExp = RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev)
        self.ExpNumber_txt.text = string.format("%s/%s", needExp, needExp)
        return
    end

    self.CurExp_img.fillAmount = partnerData.exp / needExp
    self.ExpNumber_txt.text = string.format("%s/%s", partnerData.exp, needExp)
end

--显示前4个道具
function PartnerUpgradePanel:UpdateShowItem(isPreview)
    self:ShowAttrChange(isPreview)
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
        local itemInfo = {template_id = value.id, count = value.count, scale = 0.82, btnFunc = self:ToFunc("OpenSelectPanel")}
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
        copyInfo.scale = 0.82
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
        self.CostTip_txt.text =  string.format(TI18N("选择材料(已选%s个)"), self.allCount)
        self.CountText_txt.text = self.allCount
    else
        self.MoreButton:SetActive(false)
        self.CostTip_txt.text =  TI18N("选择材料")
    end
end
--预览属性变化
function PartnerUpgradePanel:ShowAttrChange(isPreview)
    local partnerData = self:GetPartnerData()
    local targetLev = self.targetLev or partnerData.lev
    local planId = RoleConfig.GetPartnerLevPlan(partnerData.template_id).plan
    local attrTable = RoleConfig.GetPartnerPlanByIdAndLev(planId, isPreview and partnerData.lev or targetLev).lev_attr
    local showCount = #attrTable
    for i, v in ipairs(attrTable) do
        attrTable[i].priority = RoleConfig.GetAttrPriority(v[1])
    end
    table.sort(attrTable, function (a, b)
        return a.priority > b.priority
    end)
    for i = 1, showCount, 1 do
        local attr = attrTable[i]
        local attrValue = RoleConfig.GetPartnerAttr(partnerData.template_id, isPreview and partnerData.lev or targetLev, attr[1], attr[2]) 
        
        local isInit = not self.attrList[i] and true
        local obj = self.attrList[i] or self:GetAttrObj()
        local animInfo = obj.AttrObject_anim:GetCurrentAnimatorStateInfo(0)
        if not isInit and targetLev and targetLev > partnerData.lev and isPreview  and not animInfo:IsName("UI_AttrObject_shengji_shuzi_in_PC")then
            obj.AttrObject_anim:Play("UI_AttrObject_shengji_shuzi_in_PC", 0, 0)
        end
        if not animInfo:IsName("UI_AttrObject_shengji_shuzi_out_PC")  and targetLev <= partnerData.lev then
            obj.AttrObject_anim:Play("UI_AttrObject_shengji_shuzi_out_PC", 0, 0)
        end
        obj.BG:SetActive(math.fmod(i, 2) ~= 0)

        local name, oldValue = RoleConfig.GetShowAttr(attr[1], attrValue)
        obj.AttrText_txt.text = name
        obj.CurValue_txt.text = oldValue
        obj.CurValue_txt.text = oldValue
        obj.OldValue_txt.text = oldValue
        local targetValue = RoleConfig.GetPartnerAttr(partnerData.template_id, targetLev, attr[1], attr[2])
        local _, newValue = RoleConfig.GetShowAttr(attr[1], targetValue)
        obj.NewValue_txt.text = newValue
    end
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
    -- obj.AttrObject_Select:SetActive(false)
    -- obj.AttrObject_fanhui:SetActive(false)
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
        name = TI18N("月灵选择"),
        width = 860,
        col = 5,
        bagType = BagEnum.BagType.Partner,
        additionItem = RoleConfig.PartnerUpgradeItems,
        selectList = self.autoSelectList,
        quality = 5,
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
    self:UpdateShowItem(false)
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

    local partnerData = self:GetPartnerData()
    local partnerId = partnerData.template_id

    local tempExp = self.selectExp or 0
    local startLev = partnerData.lev

    local limitLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerData.template_id)

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

    local expAnimInfo = self.Exp_anim:GetCurrentAnimatorStateInfo(0)
    if self.selectExp > 0 and not expAnimInfo:IsName("UI_Exp_qeihuan_in_PC") then
        self.Exp_anim:Play("UI_Exp_qeihuan_in_PC", 0, 0)
    elseif self.selectExp <= 0 and not expAnimInfo:IsName("UI_Exp_qeihuan_out_PC") then
        self.Exp_anim:Play("UI_Exp_qeihuan_out_PC", 0, 0)
    end
    self:SetMoneyCost(self.needGold)

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
        -- 有动效
        -- self.ExpAddNumber_txt.text = ""
    end

    self:UpdateShowItem(true)
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
        local desc = string.format(TI18N("%s不足"), ItemConfig.GetItemConfig(2).name)
        MsgBoxManager.Instance:ShowTips(desc)
        return
    end


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
                self:SubmitUpgrade(partner_id, partner_id_list, item_list)
            end
        }
        PanelManager.Instance:OpenPanel(ItemTipVerifyPanel, param)
        return
    end

    self:SubmitUpgrade(partner_id, partner_id_list, item_list)
end

function PartnerUpgradePanel:SubmitUpgrade(partner_id, partner_id_list, item_list)
    local selectpanel = self.parentWindow:GetPanel(ItemSelectPanelV2)
    if selectpanel then
        selectpanel:PlayExitAnim()
    end
    --self.parentWindow:ClosePanel(ItemSelectPanelV2)
    mod.RoleCtrl:PartnerUpgrade(partner_id, partner_id_list, item_list)
end

function PartnerUpgradePanel:ClickStageTip()
    PanelManager.Instance:OpenPanel(PartnerSkillPreviewPanel, {
        uniqueId = self:GetPartnerData().unique_id,
        partnerId = self:GetPartnerData().template_id,
    })
end

function PartnerUpgradePanel:GetPartnerData()
    return self.parentWindow:GetPartnerData()
end

function PartnerUpgradePanel:HideAnim()
    
end

