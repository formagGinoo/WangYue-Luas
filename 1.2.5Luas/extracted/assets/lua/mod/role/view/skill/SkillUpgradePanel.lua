SkillUpgradePanel = BaseClass("SkillUpgradePanel", BasePanel)

function SkillUpgradePanel:__init()
    self:SetAsset("Prefabs/UI/Skill/SkillUpgradePanel.prefab")
    self.itemList = {}
end

function SkillUpgradePanel:__delete()
    
end

function SkillUpgradePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function SkillUpgradePanel:__BindListener()
    self:SetHideNode("SkillUpgradePanel_Exit")
    self:BindCloseBtn(self.CloseButton_btn,self:ToFunc("OnClick_Close_CB"))
    self.SubmitButton_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
end

function SkillUpgradePanel:__Show()
    self.skillId = self.args.skillId
    self.roleId = self.args.roleId
    self:ShowDetail()
end

function SkillUpgradePanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    for i = #self.itemList, 1, -1 do
        local item =  table.remove(self.itemList, i)
        ItemManager.Instance:PushItemToPool(item)
    end
end

function SkillUpgradePanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 1, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    --TODO模糊效果失效
    --self:SetActive(false)
    self.blurBack:Show({self:ToFunc("BlurComplete") })
end

function SkillUpgradePanel:BlurComplete()
    self:SetActive(true)
end

function SkillUpgradePanel:ShowDetail()
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId)
    local realLev = lev + exLev

    local skillConfig = RoleConfig.GetSkillConfig(skillId)
    local oldLevCfg = RoleConfig.GetSkillLevelConfig(skillId, realLev)
    local baseLevCfg = RoleConfig.GetSkillLevelConfig(skillId, lev + 1)
    local newLevCfg = RoleConfig.GetSkillLevelConfig(skillId, realLev + 1)
    self.OldCurLevel_txt.text = realLev
    self.NewCurLevel_txt.text = realLev + 1
    self.OldMaxLevel_txt.text = skillConfig.level_limit + exLev
    self.NewMaxLevel_txt.text = skillConfig.level_limit + exLev

    -- for i = self.AttrRoot_rect.childCount, 1, -1 do
    --     GameObject.Destroy(i - 1)
    -- end

    for i = 1, #baseLevCfg.need_item, 1 do
        local config = baseLevCfg.need_item[i]
        local curCount = mod.BagCtrl:GetItemCountById(config[1])
        local itemInfo =
        {
            template_id = config[1],
            count = ItemConfig.GetItemCountInfo(curCount, config[2]),
            scale = 0.8
        }
        local item = ItemManager.Instance:GetItem(self.ItemRoot_rect, itemInfo, true)
        table.insert(self.itemList,item)
    end
    local showCount = 0
    for i = 1, #newLevCfg.desc_attr, 1 do
        local newConfig = newLevCfg.desc_attr[i]
        local oldValue = ""
        if oldLevCfg then
            for j = 1, #oldLevCfg.desc_attr, 1 do
                local oldConfig = oldLevCfg.desc_attr[j]
                if newConfig[1] == oldConfig[1] then
                    oldValue = oldConfig[2]
                    break
                end
            end
        end
        showCount = showCount + 1
        local node = self:GetAttrObj()
        UtilsUI.SetActive(node.BG, not (showCount % 2 == 0))
        node.Key_txt.text = newConfig[1]
        node.OldValue_txt.text = oldValue
        node.NewValue_txt.text = newConfig[2]
    end
    if oldLevCfg then
        for i = 1, #oldLevCfg.desc_attr, 1 do
            local oldConfig = oldLevCfg.desc_attr[i]
            local notNewValue = true
            for j = 1, #newLevCfg.desc_attr, 1 do
                local newConfig = oldLevCfg.desc_attr[j]
                if newConfig[1] == oldConfig[1] then
                    notNewValue = false
                    break
                end
            end
            if notNewValue then
                showCount = showCount + 1
                local node = self:GetAttrObj()
                UtilsUI.SetActive(node.BG, not (showCount % 2 == 0))
                node.Key_txt.text = oldConfig[1]
                node.OldValue_txt.text = oldConfig[2]
                node.NewValue_txt.text = oldConfig[2]
            end
        end
    end

    local curGold = mod.BagCtrl:GetGoldCount()
    if curGold < baseLevCfg.need_gold then
        self.NeedGold_txt.text = string.format("<color=#ff5c5c>%s</color>/%s", curGold, baseLevCfg.need_gold)
    else
        self.NeedGold_txt.text = string.format("%s/%s", curGold, baseLevCfg.need_gold)
    end


    if lev == 0 then
        self.SubmitText_txt.text = TI18N("解锁")
    else
        self.SubmitText_txt.text = TI18N("升级")
    end
end

function SkillUpgradePanel:GetAttrObj()
    local obj = self:PopUITmpObject("AttrObj")
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetParent(self.AttrRoot_rect)
    obj.objectTransform:ResetAttr()
    return obj
end

function SkillUpgradePanel:OnClick_Close()
    self.SkillUpgradePanel_Exit:SetActive(true)
end

function SkillUpgradePanel:OnClick_Close_CB()
    PanelManager.Instance:ClosePanel(SkillUpgradePanel)
end

function SkillUpgradePanel:OnClick_Submit()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId)
    local baseLevCfg = RoleConfig.GetSkillLevelConfig(skillId, lev + 1)
    for i = 1, #baseLevCfg.need_item, 1 do
        local config = baseLevCfg.need_item[i]
        if config[1] ~= 0 then
            local curCount = mod.BagCtrl:GetItemCountById(config[1])
            if curCount < config[2] then
                MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
                return
            end
        end
    end
    local curGold = mod.BagCtrl:GetGoldCount()
    if curGold < baseLevCfg.need_gold then
        MsgBoxManager.Instance:ShowTips(TI18N("所需金币不足"))
        return
    end
    mod.RoleCtrl:RoleSkillUpgrade(self.roleId, self.skillId)
end