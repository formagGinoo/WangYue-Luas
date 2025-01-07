TalentUnlockPanel = BaseClass("TalentUnlockPanel", BasePanel)


function TalentUnlockPanel:__init()
	self:SetAsset("Prefabs/UI/Talent/TalentUnlockPanel.prefab")

end

function TalentUnlockPanel:__BindListener()
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
    UtilsUI.SetHideCallBack(self.TalentUnlockPanel_Eixt, self:ToFunc("Close_HideCallBack"))
end

function TalentUnlockPanel:__BindEvent()

end

function TalentUnlockPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TalentUnlockPanel:__Create()

end

function TalentUnlockPanel:__delete()

end

function TalentUnlockPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function TalentUnlockPanel:__Hide()
end

function TalentUnlockPanel:__Show()
    self:UpdateData()
end
function TalentUnlockPanel:UpdateData()
    -- 需要外部传入的参数
    if not self.args.talentId or not self.args.talentLev then
        return
    end
    local talentInfo = TalentConfig.GetTalentInfoById(self.args.talentId)
    if self.args.talentLev > 1 then
        self.TitleText_txt.text = TI18N("天赋") .. TalentConfig.LvUpType.lvUp[1]
        self.SubTitleText_txt.text = TalentConfig.LvUpType.lvUp[2]
    else
        self.TitleText_txt.text = TI18N("天赋") .. TalentConfig.LvUpType.unLock[1]
        self.SubTitleText_txt.text = TalentConfig.LvUpType.unLock[2]
    end
    self.Title_txt.text = talentInfo.name
    self.SubName_txt.text = TalentConfig.GetTalentTypeNameByType(talentInfo.type)
    local levelUpInfo = TalentConfig.GetUpgradeConfig(self.args.talentId, self.args.talentLev)
    self.SkillDesc_txt.text = levelUpInfo.desc
    SingleIconLoader.Load(self.TalentIcon, talentInfo.icon or "")
    self.maxLevel = TalentConfig.GetTalentMaxLvById(self.args.talentId)
    self.gradeText_txt.text = self.args.talentLev .. "/" .. self.maxLevel

end

function TalentUnlockPanel:OnClick_Close()
    UtilsUI.SetActive(self.TalentUnlockPanel_Eixt, true)    
end

function TalentUnlockPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end