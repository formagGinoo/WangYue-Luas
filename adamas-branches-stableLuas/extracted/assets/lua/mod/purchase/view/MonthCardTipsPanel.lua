MonthCardTipsPanel = BaseClass("MonthCardTipsPanel", BasePanel)

function MonthCardTipsPanel:__init()
    self:SetAsset("Prefabs/UI/Purchase/MonthCardTipsPanel.prefab")

end

function MonthCardTipsPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))
end

function MonthCardTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function MonthCardTipsPanel:__Create()

end

function MonthCardTipsPanel:__delete()

end

function MonthCardTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function MonthCardTipsPanel:__Hide()

end

function MonthCardTipsPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end

function MonthCardTipsPanel:__Show()
    self:ShowInfo()
end

function MonthCardTipsPanel:ShowInfo()
    self.DescTips_txt.text = PurchaseConfig.DataMonthcard[1].tips
end