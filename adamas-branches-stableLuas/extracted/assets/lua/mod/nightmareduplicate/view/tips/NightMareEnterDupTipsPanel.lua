NightMareEnterDupTipsPanel = BaseClass("NightMareEnterDupTipsPanel", BasePanel)
--副本组check
local HeroData = Config.DataHeroMain.Find

function NightMareEnterDupTipsPanel:__init(parent)
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareEnterDupTipsPanel.prefab")
end
function NightMareEnterDupTipsPanel:__BindEvent()

end

function NightMareEnterDupTipsPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("OnClickCancelBtn"))

    self:SetAcceptInput(true)
end

function NightMareEnterDupTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function NightMareEnterDupTipsPanel:__Create()

end

function NightMareEnterDupTipsPanel:__delete()
end

function NightMareEnterDupTipsPanel:__Show()
    --self.TitleText_txt.text = TI18N("梦魇终-启")
    self.roleId = self.args.sameRoleId --相同角色id 
    self.systemDuplicateId = self.args.sysDupId --副本id 
    self.submitCallback = self.args.submitCallback
    self.nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(self.systemDuplicateId)
    self:ShowInfo()
end

function NightMareEnterDupTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function NightMareEnterDupTipsPanel:BlurComplete()
    self:SetActive(true)
end
function NightMareEnterDupTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    PanelManager.Instance:ClosePanel(self)
end

function NightMareEnterDupTipsPanel:ShowInfo()
    local heroCfg = HeroData[self.roleId]
    self.tips_txt.text = TI18N("当前成员")..heroCfg.name..TI18N("已经在队伍中")..self.nightMareDupCfg.name..TI18N("\n请确认是否将其更换到本次挑战中")
end

function NightMareEnterDupTipsPanel:OnClickSubmitBtn()
    --确认按钮
    if self.submitCallback then
        self.submitCallback()
    end
    PanelManager.Instance:ClosePanel(self)
end

function NightMareEnterDupTipsPanel:OnClickCancelBtn()
    --取消按钮
    PanelManager.Instance:ClosePanel(self)
end

