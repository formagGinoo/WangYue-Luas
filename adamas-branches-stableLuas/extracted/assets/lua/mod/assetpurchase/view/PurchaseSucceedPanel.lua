PurchaseSucceedPanel = BaseClass("PurchaseSucceedPanel", BasePanel)

function PurchaseSucceedPanel:__init()  
    self:SetAsset("Prefabs/UI/AssetPurchase/PurchaseSucceedPanel.prefab")
end

function PurchaseSucceedPanel:__BindListener()
    self.GotoBtn_btn.onClick:AddListener(self:ToFunc("OnClick_GotoBtn"))
end

function PurchaseSucceedPanel:__BindEvent()

end

function PurchaseSucceedPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PurchaseSucceedPanel:__delete()
end

function PurchaseSucceedPanel:__Hide()
end

function PurchaseSucceedPanel:__Show()
end

function PurchaseSucceedPanel:__ShowComplete()
end

function PurchaseSucceedPanel:OnClick_GotoBtn()
    self.parentWindow:AfterBuyComplete()
    self.parentWindow:ClosePanel(self)
end
