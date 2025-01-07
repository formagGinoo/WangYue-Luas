AssetExistingPanel = BaseClass("AssetExistingPanel", BasePanel)

function AssetExistingPanel:__init()  
    self:SetAsset("Prefabs/UI/AssetPurchase/AssetExistingPanel.prefab")
    self.assetMapItemMap = {}
    self.partnerInfoObjList = {}
    self.deviceInfoObjList = {}
    self.assetInfoItem = nil
end

function AssetExistingPanel:__BindListener()
    self.BgBtn_btn.onClick:AddListener(self:ToFunc("CloseDetailsInfo"))
end

function AssetExistingPanel:__BindEvent()

end

function AssetExistingPanel:__Create()
end

function AssetExistingPanel:__delete()
    for k, v in pairs(self.assetMapItemMap) do
        PoolManager.Instance:Push(PoolType.class, "AssetMapItem", v)
    end
end

function AssetExistingPanel:__Hide()
end

function AssetExistingPanel:__Show()
    self.assetMap = mod.AssetPurchaseCtrl:GetExistingAssetInfo()
    self:CloseDetailsInfo()
end

function AssetExistingPanel:__ShowComplete()
    for k, v in pairs(self.assetMap) do
        local assetMapItem = PoolManager.Instance:Pop(PoolType.class, "AssetMapItem")
        if not assetMapItem then
            assetMapItem = AssetMapItem.New()
        end
        local obj = self["AssetMapItem"..v.asset_id]
        assetMapItem:InitItem(obj,v)
        UtilsUI.SetActive(obj,true)
        assetMapItem:SetBtnEvent(false,function()
            self:OnClickAssetMapItem(assetMapItem)
        end)
        self.assetMapItemMap[v.asset_id] = assetMapItem
        if self.args.jumpAssetId and v.asset_id == self.args.jumpAssetId then
            self:OnClickAssetMapItem(assetMapItem)
            self.args.jumpAssetId = nil
        end
    end
end

function AssetExistingPanel:OnClickAssetMapItem(assetMapItem)
    local assetInfo = assetMapItem.assetInfo
    if self.selectMapItem then
        self.selectMapItem:SetSelectBox(false)
    end
    self.selectMapItem = assetMapItem
    assetMapItem:SetSelectBox(true)
    self:SetDetailsInfo(assetInfo)
end

function AssetExistingPanel:CloseDetailsInfo()
    UtilsUI.SetActive(self.DetailsInfo,false)
    if self.selectMapItem then
        self.selectMapItem:SetSelectBox(false)
    end
end

function AssetExistingPanel:SetDetailsInfo(assetInfo)
    UtilsUI.SetActive(self.DetailsInfo,true)
    self:SetDevicesInfo(assetInfo)
    self:SetPartnerInfo(assetInfo)
    self:SetAssetInfoItem(assetInfo)
end

function AssetExistingPanel:SetPartnerInfo(assetInfo)
    self.partner_list = assetInfo.partner_list
    self:RefreshPartnerList()
end

function AssetExistingPanel:SetDevicesInfo(assetInfo)
    self.decoration_list = {}
    for i, v in pairs(assetInfo.decoration_list) do
        local info = AssetPurchaseConfig.GetAssetDeviceInfoById(v.template_id)
        if info and (info.type == AssetPurchaseConfig.DeviceTypeEnum.Production or info.type == AssetPurchaseConfig.DeviceTypeEnum.Base) then
            table.insert(self.decoration_list, v)
        end
    end
    local maxCount = AssetPurchaseConfig.GetAssetStaffNum(assetInfo.asset_id,assetInfo.level)
    self.PartnerCount_txt.text = string.format("%d/%d",#assetInfo.partner_list,maxCount)
    self:RefreshDeviceList()
end

function AssetExistingPanel:RefreshPartnerList()
    local listNum = #self.partner_list 
    if listNum == 0 then
        UtilsUI.SetActive(self.PartnerEmpty,true)
    end
    self.PartnerList_recyceList:SetLuaCallBack(self:ToFunc("RefreshPartnerCell"))
    self.PartnerList_recyceList:SetCellNum(listNum)
end

function AssetExistingPanel:RefreshPartnerCell(index,go)
    if not go then
        return 
    end

    local partnerInfoObj
    if self.partnerInfoObjList[index] then
        partnerInfoObj = self.partnerInfoObjList[index]
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        partnerInfoObj = uiContainer
        self.partnerInfoObjList[index] = uiContainer
    end
    self:SetPartnerItem(partnerInfoObj, self.partner_list[index])
end

function AssetExistingPanel:RefreshDeviceList()
    local listNum = #self.decoration_list
    if listNum == 0 then
        UtilsUI.SetActive(self.DevicesEmpty,true)
    end
    self.DevicesList_recyceList:SetLuaCallBack(self:ToFunc("RefreshDeviceCell"))
    self.DevicesList_recyceList:SetCellNum(listNum)
end

function AssetExistingPanel:RefreshDeviceCell(index,go)
    if not go then
        return 
    end

    local deviceInfoObj
    if self.deviceInfoObjList[index] then
        deviceInfoObj = self.deviceInfoObjList[index]
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        deviceInfoObj = uiContainer
        self.deviceInfoObjList[index] = uiContainer
    end
    self:SetDeviceItem(deviceInfoObj, self.decoration_list[index])
end

function AssetExistingPanel:SetPartnerItem(itemObj,partnerId)
    local partnerData = mod.BagCtrl:GetPartnerData(partnerId)
    itemObj.Level_txt.text = partnerData.lev
    local partnerConfig = ItemConfig.GetItemConfig(partnerData.template_id)-- ItemConfig.GetItemConfig(partnerId)
    SingleIconLoader.Load(itemObj.Icon, partnerConfig.head_icon)
    local quality = partnerConfig.quality
    for i = 1, 6, 1 do
        UtilsUI.SetActive(itemObj["Quality"..i],i==quality)
    end
    local state = mod.PartnerBagCtrl:GetAssetPartnerState(partnerId)
    if state == FightEnum.PartnerStatusEnum.Sad then
       UtilsUI.SetActive(itemObj.Sad,true)
       UtilsUI.SetActive(itemObj.Hunger,false)
    elseif state == FightEnum.PartnerStatusEnum.Hunger then
        UtilsUI.SetActive(itemObj.Sad,false)
        UtilsUI.SetActive(itemObj.Hunger,true)
    else
        UtilsUI.SetActive(itemObj.Sad,false)
       UtilsUI.SetActive(itemObj.Hunger,false)
    end
end

function AssetExistingPanel:SetDeviceItem(itemObj,deviceInfo)
    local deviceConfig = AssetPurchaseConfig.GetAssetDeviceInfoById(deviceInfo.template_id)
    SingleIconLoader.Load(itemObj.Icon, deviceConfig.icon)
    itemObj.DeviceName_txt.text = deviceConfig.name
    local work_info = deviceInfo.work_info
    if not work_info or #work_info.partner_list == 0 then
        UtilsUI.SetActive(itemObj.Complete,false)
        UtilsUI.SetActive(itemObj.Unused,true)
        UtilsUI.SetActive(itemObj.InProduction,false)
    else 
        if work_info.finish_amount == work_info.work_amount then
            UtilsUI.SetActive(itemObj.Complete,true)
            UtilsUI.SetActive(itemObj.Unused,false)
            UtilsUI.SetActive(itemObj.InProduction,false)
        elseif work_info.finish_amount < work_info.work_amount then
            UtilsUI.SetActive(itemObj.Complete,false)
            UtilsUI.SetActive(itemObj.Unused,false)
            UtilsUI.SetActive(itemObj.InProduction,true)
        end
    end

end

function AssetExistingPanel:SetAssetInfoItem(assetInfo)
    self.assetInfoItem = PoolManager.Instance:Pop(PoolType.class, "AssetInfoItem")
    if self.assetInfoItem == nil then
        self.assetInfoItem = AssetInfoItem.New()
    end
    
    self.assetInfoItem:InitItem(self.AssetInfoItem,AssetPurchaseConfig.GetAssetPurchaseConfigById(assetInfo.asset_id))

    self.assetInfoItem:SetBtnEvent(false,function()
        mod.AssetPurchaseCtrl:GotoAsset(self.assetInfoItem.assetInfo.asset_id)
        WindowManager.Instance:CloseWindow(AssetPurchaseMainWindow)
        WindowManager.Instance:CloseWindow(PhoneMenuWindow)
    end)
end