WorldLevelChangePanel = BaseClass("WorldLevelChangePanel", BasePanel)

function WorldLevelChangePanel:__init()
    self:SetAsset("Prefabs/UI/WorldLevel/WorldLevelChangePanel.prefab")
end

function WorldLevelChangePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function WorldLevelChangePanel:__BindListener()
    --self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.Submit_btn,self:ToFunc("OnClick_Submit"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClick_Close"))
end

function WorldLevelChangePanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function WorldLevelChangePanel:__Show()
    self.oldLev = self.args.oldLev
    self.newLev = self.args.newLev
    self.TitleText_txt.text = TI18N("世界等级调整")
    self:ShowDetail()

    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
        self.blurBack:Show()
    end
end

function WorldLevelChangePanel:ShowDetail()
    local isDegrade = self.oldLev > self.newLev
    self.NewLev_txt.text = self.newLev
    self.OldLev_txt.text = self.oldLev

    for i = 1, 3, 1 do
        local obj = self:PopUITmpObject("DescObj", self.DescRoot_rect)
        obj.Desc_txt.text = WorldLevelConfig.GetChangeDesc(i, self.newLev, isDegrade)
    end
end

function WorldLevelChangePanel:OnClick_Submit()
    if self.oldLev > self.newLev then
        mod.WorldLevelCtrl:WorldLevelDegrade()
    else
        mod.WorldLevelCtrl:WorldLevelUpgrade()
    end
    PanelManager.Instance:ClosePanel(self)
end

function WorldLevelChangePanel:OnClick_Close()
    PanelManager.Instance:ClosePanel(self)
end