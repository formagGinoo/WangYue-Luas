AssetBuyInfoPanel = BaseClass("AssetBuyInfoPanel", BasePanel)

function AssetBuyInfoPanel:__init()  
    self:SetAsset("Prefabs/UI/AssetPurchase/AssetBuyInfoPanel.prefab")
end

function AssetBuyInfoPanel:__BindListener()
    self.BuyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BuyBtn"))
    self.BackBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BackBtn"))
end

function AssetBuyInfoPanel:__BindEvent()

end

function AssetBuyInfoPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AssetBuyInfoPanel:__delete()
    AssetMgrProxy.Instance:CacheLoader(self.assetShowLoader)
end

function AssetBuyInfoPanel:__Hide()
end

function AssetBuyInfoPanel:__Show()
    self.assetInfo = self.args.assetInfo
end

function AssetBuyInfoPanel:__ShowComplete()
    self:RefreshInfo()
end

function AssetBuyInfoPanel:RefreshInfo()
    self.resList = {}

    for i, v in ipairs(self.assetInfo.asset_show) do
        local deviceresPath = string.format("Prefabs/UI/AssetPurchase/InfoItems/%s.prefab", v)
        table.insert(self.resList, {path = deviceresPath, type = AssetType.Prefab})
    end

    self.assetShowLoader = AssetMgrProxy.Instance:GetLoader("AssetBuyInfoItem")
    self.assetShowLoader:AddListener(self:ToFunc("OnLoadComplete"))
    self.assetShowLoader:LoadAll(self.resList)
end

function AssetBuyInfoPanel:OnLoadComplete()
    for i, v in ipairs(self.resList) do
        self.assetShowLoader:Pop(v.path, self.Content.transform)
    end
end

function AssetBuyInfoPanel:OnClick_BuyBtn()
    self.parentWindow:OpenAssetAgreementPanel(self.assetInfo)
    self.parentWindow:ClosePanel(self)
end

function AssetBuyInfoPanel:OnClick_BackBtn()
    self.parentWindow:CloseBuyInfoPanel()
end
