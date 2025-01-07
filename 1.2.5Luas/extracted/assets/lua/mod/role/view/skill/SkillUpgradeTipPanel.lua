SkillUpgradeTipPanel = BaseClass("SkillUpgradeTipPanel", BasePanel)


function SkillUpgradeTipPanel:__init()
    self:SetAsset("Prefabs/UI/Skill/SkillUpgradeTipPanel.prefab")
    self.itemList = {}
end

function SkillUpgradeTipPanel:__BindEvent()

end

function SkillUpgradeTipPanel:__BindListener()
    UtilsUI.SetHideCallBack(self.SkillUpgradeTipPanel_Exit, self:ToFunc("Close_HideCallBack"))
    self.Close_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
end

function SkillUpgradeTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function SkillUpgradeTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function SkillUpgradeTipPanel:__Show()
    self.skillId = self.args.skillId
    self.oldLev = self.args.oldLev or 0
    self.newLev = self.args.newLev
    self:ShowDetail()
end

function SkillUpgradeTipPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
    self.Close:SetActive(false)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1,1,function()
        self.Close:SetActive(true)
    end)
end

function SkillUpgradeTipPanel:BlurComplete()
    self:SetActive(true)
end

function SkillUpgradeTipPanel:ShowDetail()
    local skillConfig = RoleConfig.GetSkillConfig(self.skillId)
    local oldLevCfg = RoleConfig.GetSkillLevelConfig(self.skillId, self.oldLev)
    local newLevCfg = RoleConfig.GetSkillLevelConfig(self.skillId, self.newLev)
    self.CurLevelText_txt.text = self.oldLev
    self.CurLevelText2_txt.text = self.newLev
    SingleIconLoader.Load(self.SkillIcon, skillConfig.icon)

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
        local node = self:GetAttributeItem()
        UtilsUI.SetActive(node.Bg, not (showCount % 2 == 0))
        node.Name_txt.text = newConfig[1]
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
                local node = self:GetAttributeItem()
                UtilsUI.SetActive(node.Bg, not (showCount % 2 == 0))
                node.Key_txt.text = oldConfig[1]
                node.OldValue_txt.text = oldConfig[2]
                node.NewValue_txt.text = oldConfig[2]
            end
        end
    end
end

function SkillUpgradeTipPanel:GetAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    obj.objectTransform:SetParent(self.AttributeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function SkillUpgradeTipPanel:OnClick_Close()
    self.SkillUpgradeTipPanel_Exit:SetActive(true)
end

function SkillUpgradeTipPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(SkillUpgradeTipPanel)
end