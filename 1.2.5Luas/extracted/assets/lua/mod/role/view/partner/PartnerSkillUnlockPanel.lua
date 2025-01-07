PartnerSkillUnlockPanel = BaseClass("PartnerSkillUnlockPanel", BasePanel)

function PartnerSkillUnlockPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerSkillUnlockPanel.prefab")
end

function PartnerSkillUnlockPanel:__BindEvent()

end

function PartnerSkillUnlockPanel:__BindListener()
    self:SetHideNode("RoleUpgradeTipPanel_exit")
    self:BindCloseBtn(self.Close_btn,self:ToFunc("Close_HideCallBack"))
end

function PartnerSkillUnlockPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerSkillUnlockPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    if self.callBack then
        self.callBack()
    end
end

function PartnerSkillUnlockPanel:__Show()
    self.id = self.args.id
    self.skillId = self.args.skillId
    self.level = self.args.level
    self.oldLevel = self.args.oldLev
    self.desc1 = self.args.desc1
    self.desc2 = self.args.desc2
    self.callBack = self.args.callBack
    self:ShowDetail(self.id, self.skillId, self.level or 1)
end

function PartnerSkillUnlockPanel:__ShowComplete()
    if not self.blurBack then
        local setting = {passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("BlurComplete") })
    self.Close:SetActive(false)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1,1,function()
        if self.Close then
            self.Close:SetActive(true)
        end
    end)
end

function PartnerSkillUnlockPanel:BlurComplete()
    self:SetActive(true)
end

function PartnerSkillUnlockPanel:ShowDetail(partnerId,skillId, lev)
    local skillConfig = RoleConfig.GetPartnerSkillConfig(skillId)
    local levelConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, lev)
    self.TitleText_txt.text = self.desc1 or TI18N("技能解锁")
    self.TitleADAMASText_txt.text = self.desc2 or "jieshuo"
    self.LockBg:SetActive(false)
    self.LevInfo:SetActive(self.oldLevel and true)
    if self.oldLevel then
        self.CurLevelText_txt.text = string.format("%s/%s", lev, RoleConfig.GetPartnerSkillMaxLev(self.id))
    end
    SingleIconLoader.Load(self.Icon, skillConfig.icon)
    self.Box:SetActive(skillConfig.type == RoleConfig.PartnerSkillType.Specificity)
    self.SkillName_txt.text = skillConfig.name
    self.SkillType_txt.text = RoleConfig.PartnerSkillDesc[skillConfig.type]
    if levelConfig.simple_desc == "" then
		self.SkillDesc_txt.text = levelConfig.desc_info

    else
		self.SkillDesc_txt.text = levelConfig.simple_desc
    end
    self.Level_txt.text = lev
end

function PartnerSkillUnlockPanel:OnClick_Close()
    self.RoleUpgradeTipPanel_exit:SetActive(true)
end

function PartnerSkillUnlockPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end