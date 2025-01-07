DrawJumpPurchaseTipsPanel = BaseClass("DrawJumpPurchaseTipsPanel", BasePanel)

function DrawJumpPurchaseTipsPanel:__init()
    self:SetAsset("Prefabs/UI/Draw/DrawJumpPurchaseTipsPanel.prefab")
end

function DrawJumpPurchaseTipsPanel:__delete()

end

function DrawJumpPurchaseTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DrawJumpPurchaseTipsPanel:__Create()
end

function DrawJumpPurchaseTipsPanel:__BindListener()
    self:BindCloseBtn(self.Cancel_btn, self:ToFunc("OnClickCloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn, self:ToFunc("OnClickCloseBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
end

function DrawJumpPurchaseTipsPanel:__BindEvent()
end

function DrawJumpPurchaseTipsPanel:__Show()
    self.TitleText_txt.text = TI18N("提示")

    local itemInfo = DrawConfig.GetItemInfo(self.args.itemId)

    self.TipsText_txt.text = string.format(TI18N("%s不足，是否跳转商城?"), itemInfo.name) 
end

function DrawJumpPurchaseTipsPanel:__Hide()
end

function DrawJumpPurchaseTipsPanel:__ShowComplete()

end

function DrawJumpPurchaseTipsPanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(DrawJumpPurchaseTipsPanel)
end

function DrawJumpPurchaseTipsPanel:OnClickSubmitBtn()
    -- 跳转充值
    JumpToConfig.DoJump(2151)
    --WindowManager.Instance:OpenWindow(PurchaseMainWindow, { _jump = {PurchaseConfig.PageType.Recharge} })
    self:OnClickCloseBtn()
end