PartnerStoreWindow = BaseClass("PartnerStoreWindow", BaseWindow)

function PartnerStoreWindow:__init()
    self:SetAsset("Prefabs/UI/PartnerCenter/PartnerStoreWindow.prefab")
    self.defaultSelect = 1 --默认选中第一个
    self.curIndex = nil 
    
    --ui
    self.itemObjList = {}
end

function PartnerStoreWindow:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("Close"))
    --监听物件更新
    EventMgr.Instance:AddListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("AssetDecorationInfoUpdate"))
end

function PartnerStoreWindow:__Show(args)
    self.deviceUniqueId = args and args.uniqueId or self.args.uniqueId--设备id 
    self:SetBlurBack()
    self:UpdateLeft()
end

function PartnerStoreWindow:__Hide()

end

function PartnerStoreWindow:__delete()
    if self.leftScrollView_recyceList then
        self.leftScrollView_recyceList:CleanAllCell()
    end
    if self.commonTips then
        self.commonTips:DeleteMe()
    end
    EventMgr.Instance:AddListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("AssetDecorationInfoUpdate"))
end

function PartnerStoreWindow:AssetDecorationInfoUpdate(assetId, deviceUniqueId)
    if self.deviceUniqueId == deviceUniqueId then
        self:UpdateLeft()
    end
end

function PartnerStoreWindow:UpdateLeft()
    
    local deviceInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(self.deviceUniqueId)
    self.leftData = {}
    if deviceInfo.work_info.work_id == 0 then
        return
    end
    
    self.curNum = deviceInfo.work_info.finish_amount
    self.maxNum = 0
    local deviceCollectCfg = PartnerCenterConfig.GetAssetDevicePartnerProductCfg(deviceInfo.work_info.work_id)
    if deviceCollectCfg then
        self.maxNum = deviceCollectCfg.num_max
        table.insert(self.leftData, {template_id = deviceCollectCfg.item, count = deviceInfo.work_info.finish_amount})
    end
    

    UtilsUI.SetActive(self.empty, #self.leftData == 0)
    UtilsUI.SetActive(self.left, #self.leftData ~= 0)
    UtilsUI.SetActive(self.right, #self.leftData ~= 0)
    if #self.leftData == 0 then
        return
    end
    --获取目前所有的在该资产的佩丛
    self.leftScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.leftScrollView_recyceList:SetCellNum(#self.leftData, true)
    self:UpdateLeftOther()
end

function PartnerStoreWindow:UpdateLeftOther()
    --刷新仓库数据、生产效率 
    local curNum = self.curNum
    local maxNum = self.maxNum
    local speed = mod.PartnerCenterCtrl:GetDeviceProductivity(self.deviceUniqueId)
    self.bagNum_txt.text = string.format("<color=#ce6600>%s</color>/%s", curNum, maxNum)
    self.workSpeedTips_txt.text = string.format("生产效率：<color=#ce6600>%s</color>/小时", speed)
end

function PartnerStoreWindow:UpdateRight()
    local data = self.leftData[self.curIndex]
    if not data then
        self.right:SetActive(false)
        return
    end
    self.right:SetActive(true)
    if not self.commonTips then
        self.commonTips = CommonItemTip.New(self.CommonTips)
    end
    self.commonTips:ReSetInfo()
    self.commonTips:SetItemInfo(data)
    UtilsUI.SetActive(self.CommonTips,true)
end

function PartnerStoreWindow:RefreshItemCell(index, go)
    if not go then
        return
    end

    local commonItem
    local itemObj = go
    
    if self.itemObjList[index] then
        commonItem = self.itemObjList[index].commonItem
    else
        commonItem = CommonItem.New()
        self.itemObjList[index] = {}
        self.itemObjList[index].commonItem = commonItem
    end

    self.itemObjList[index].itemObj = itemObj

    self:SingleSelect(index,commonItem)


    local itemInfo = self.leftData[index]
    if not itemInfo or not next(itemInfo) then
        commonItem:InitItem(itemObj, itemInfo, false)
        --commonItem:Show()
        return
    else
        commonItem:InitItem(itemObj, itemInfo, true)
        --commonItem:Show() selectedNormal
    end
    
    if self.defaultSelect and self.defaultSelect == index then
        self.defaultSelect = nil
        itemInfo.btnFunc()
    end
end

function PartnerStoreWindow:SingleSelect(index, commonItem)
    local itemInfo = self.leftData[index]
    if not itemInfo then
        return
    end
    
    itemInfo.btnFunc = function ()
        itemInfo.selectedNormal = true
        if self.curIndex and self.curIndex ~= index then
            local lastItem = self.leftData[self.curIndex]
            lastItem.selectedNormal = false
            self.itemObjList[self.curIndex].commonItem:SetSelected_Normal(false)
        end
        self.curIndex = index
        if self.selectItemFunc then
            self:selectItemFunc()
        end
        commonItem:SetSelected_Normal(true)
    end
end

function PartnerStoreWindow:selectItemFunc()
    self:UpdateRight()
end

function PartnerStoreWindow:Close()
    WindowManager.Instance:CloseWindow(self)
end
