AssetPurchaseGuidePanel = BaseClass("AssetPurchaseGuidePanel", BasePanel)

function AssetPurchaseGuidePanel:__init()  
    self:SetAsset("Prefabs/UI/AssetPurchase/AssetPurchaseGuidePanel.prefab")
    self.assetInfoObjList = {}
end

function AssetPurchaseGuidePanel:__BindListener()
    self.RecommendBtn_btn.onClick:AddListener(self:ToFunc("OnClickReCommendBtn"))
    self.FurnitureBtn_btn.onClick:AddListener(self:ToFunc("OnClickFurnitureBtn"))
end

function AssetPurchaseGuidePanel:__BindEvent()

end

function AssetPurchaseGuidePanel:__Create()
end

function AssetPurchaseGuidePanel:__delete()
end

function AssetPurchaseGuidePanel:__Hide()
end

function AssetPurchaseGuidePanel:__Show()
    self.ShowInfo = AssetPurchaseConfig.GetAssetPurchaseList()
    table.sort(self.ShowInfo, function(a, b)
        local aIsExisting = mod.AssetPurchaseCtrl:GetExistingAssetInfoById(a.asset_id)
        local bIsExisting = mod.AssetPurchaseCtrl:GetExistingAssetInfoById(b.asset_id)
        if (aIsExisting and bIsExisting) or (aIsExisting == nil and aIsExisting == nil) then
            return a.id < b.id
        end 
        return aIsExisting == nil
    end)
end

function AssetPurchaseGuidePanel:__ShowComplete()
    self:RefreshAssetList()
end

function AssetPurchaseGuidePanel:RefreshAssetList()
    local listNum = #self.ShowInfo
    self.AssetList_recyceList:SetLuaCallBack(self:ToFunc("RefreshAssetCell"))
    self.AssetList_recyceList:SetCellNum(listNum)
end

function AssetPurchaseGuidePanel:RefreshAssetCell(index,go)
    if not go then
        return 
    end

    local assetInfoItem
    local assetInfoObj
    if self.assetInfoObjList[index] then
        assetInfoItem = self.assetInfoObjList[index].assetInfoItem
        assetInfoObj = self.assetInfoObjList[index].assetInfoObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        assetInfoItem = PoolManager.Instance:Pop(PoolType.class, "AssetInfoItem")
        if not assetInfoItem then
            assetInfoItem = AssetInfoItem.New()
        end
        assetInfoObj = uiContainer.AssetInfoItem
        self.assetInfoObjList[index] = {}
        self.assetInfoObjList[index].assetInfoItem = assetInfoItem
        self.assetInfoObjList[index].assetInfoObj = assetInfoObj
        self.assetInfoObjList[index].isSelect = false
    end

    assetInfoItem:InitItem(assetInfoObj,self.ShowInfo[index],true)
    local onClickFunc = function()
        self:OnClick_MoreInfo(self.assetInfoObjList[index].assetInfoItem)
    end
    assetInfoItem:SetBtnEvent(false,onClickFunc)

    if not self.ShowInfo[index] or not next(self.ShowInfo[index]) then
        return 
    end
end

function AssetPurchaseGuidePanel:OnClick_MoreInfo(assetInfoItem)
    local assetinfo = assetInfoItem.assetInfo
    if assetInfoItem.isExisting then
        mod.AssetPurchaseCtrl:GotoAsset(assetinfo.asset_id)
        WindowManager.Instance:CloseWindow(AssetPurchaseMainWindow)
        WindowManager.Instance:CloseWindow(PhoneMenuWindow)
        return
    end
    self:Hide()
    self.parentWindow:OpenBuyInfoPanel(assetinfo)
end

function AssetPurchaseGuidePanel:OnClickReCommendBtn()
    MsgBoxManager.Instance:ShowTips(TI18N("敬请期待"),0.5)
end

function AssetPurchaseGuidePanel:OnClickFurnitureBtn()
    MsgBoxManager.Instance:ShowTips(TI18N("敬请期待"),0.5)
end