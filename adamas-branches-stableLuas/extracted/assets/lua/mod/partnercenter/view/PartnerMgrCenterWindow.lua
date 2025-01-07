PartnerMgrCenterWindow = BaseClass("PartnerMgrCenterWindow", BaseWindow)

local _tinsert = table.insert

local maxShowDeviceCount = 3 
function PartnerMgrCenterWindow:__init()
	self:SetAsset("Prefabs/UI/PartnerMgrCenter/PartnerMgrCenterWindow.prefab")
    self.showDevices = {}
    self.deviceObjList = {}
    self.partnerObjList = {}
end

function PartnerMgrCenterWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn)
    EventMgr.Instance:AddListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("UpdatePartnerWorkInAsset"))
    EventMgr.Instance:AddListener(EventName.OnSetPartnerWorkInAsset, self:ToFunc("UpdatePartnerWorkInAsset"))
    self.TeachBtn_btn.onClick:AddListener(self:ToFunc("ClickTeachBtn"))
    self.LeftTab_btn.onClick:AddListener(self:ToFunc("ClickLeftTabBtn"))
    self.RightTab_btn.onClick:AddListener(self:ToFunc("ClickRightTabBtn"))
end

function PartnerMgrCenterWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerMgrCenterWindow:__Create()

end

function PartnerMgrCenterWindow:UpdatePartnerWorkInAsset()
    self:UpdateData()
    self:GetShowDevices()
    self:SetMidPart()
    self:SetBottomPart()
end

function PartnerMgrCenterWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("UpdatePartnerWorkInAsset"))
    EventMgr.Instance:RemoveListener(EventName.OnSetPartnerWorkInAsset, self:ToFunc("UpdatePartnerWorkInAsset"))


    self.showDevices = {}
    for k, v in pairs(self.deviceObjList) do
        PoolManager.Instance:Push(PoolType.class, "DeviceItem", v.deviceItem)
    end
    for k, v in pairs(self.partnerObjList) do
        PoolManager.Instance:Push(PoolType.class, "PartnerSingleItem", v.partnerItem)
    end
    self.deviceObjList = {}
    self.partnerObjList = {}
end

function PartnerMgrCenterWindow:__ShowComplete()

end

function PartnerMgrCenterWindow:__Hide()

end

function PartnerMgrCenterWindow:__Show()
    self:SetBlurBack()
    self:UpdateData()
    self:GetShowDevices()
    self:SetMidPart()
    self:SetBottomPart()
end

function PartnerMgrCenterWindow:UpdateData()
    self.curAssetInfo = TableUtils.CopyTable(mod.AssetPurchaseCtrl:GetCurAssetInfo())
    self.nowAssetId = self.curAssetInfo.asset_id
    -- 资产中上阵的月灵列表
    self.nowPartners = mod.AssetPurchaseCtrl:GetAssetPartnerList(self.nowAssetId)
    self.devices = mod.AssetPurchaseCtrl:GetDeviceListById(self.nowAssetId)
end

function PartnerMgrCenterWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function PartnerMgrCenterWindow:GetShowDevices()
    local tempDevices = mod.AssetPurchaseCtrl:GetDeviceListById(self.nowAssetId)

    self.showDevices = {}
    for k, deviceInfo in pairs(tempDevices) do
        local templateId = deviceInfo.template_id
        local deviceConfig = AssetPurchaseConfig.GetAssetDeviceInfoById(templateId)
        if deviceConfig and (deviceConfig.type == PartnerCenterConfig.DeviceType.Produce or deviceConfig.type == PartnerCenterConfig.DeviceType.Basic)  then -- 只有类型为1/2的物件才能显示在管理中心
            _tinsert(self.showDevices, {info = deviceInfo, config = deviceConfig})
        end
    end
    table.sort(self.showDevices, function(a, b)
        return a.config.id < b.config.id
    end)

    UtilsUI.SetActive(self.HaveDevicePanel, #self.showDevices ~= 0) 
    UtilsUI.SetActive(self.NullPanel, #self.showDevices == 0) 
    self:ResetPivot()
    
end

function PartnerMgrCenterWindow:ResetPivot()
    self.nowDeviceFirstPivot = 1
    self.nowDevicePivot = #self.showDevices <= 3 and #self.showDevices or 3
end

function PartnerMgrCenterWindow:SetDevicePartnerList()
    mod.PartnerCenterCtrl:ClearUnrealPartnerList()
    local assetLev = mod.AssetPurchaseCtrl:GetAssetLevel(self.nowAssetId)
    local assetPartnerNum = PartnerCenterConfig.GetAssetPartnerLimit(self.nowAssetId, assetLev)
    local canWorkPartnerList = {}  --待分配的月灵
    local usePartnerList = {}
    self.devicePartnerList = {}
    self.unrealDeviceData = {}
    --服务端数据处理
    for index, v in pairs(self.showDevices) do
        self.devicePartnerList[index] = self.devicePartnerList[index] or {}
        local devicePartnerLimit = PartnerCenterConfig.GetAssetDeviceNumLimit(v.info.template_id, assetLev)
        if v.config.type == PartnerCenterConfig.DeviceType.Produce and devicePartnerLimit > #self.devicePartnerList[index] then
            canWorkPartnerList[index] = mod.PartnerCenterCtrl:CanWorkPartnerList(self.nowAssetId, v.info.template_id)
            local partnerList = v.info.work_info.partner_list
            if  v.info.work_info.work_id ~= 0 and #partnerList > 0 then
                for k, partnerUniqueId in pairs(partnerList) do
                    usePartnerList[partnerUniqueId] = true
                end
                self.devicePartnerList[index] = partnerList
            else
                self.unrealDeviceData[index] = v
            end 
        end
    end
    
    --客户端假数据
    for index, v in pairs(self.unrealDeviceData) do
        local devicePartnerLimit = PartnerCenterConfig.GetAssetDeviceNumLimit(v.info.template_id, assetLev)
        canWorkPartnerList[index] = canWorkPartnerList[index] or {}
        local num = 0
        for _, id in ipairs(canWorkPartnerList[index]) do
            if num >= devicePartnerLimit then
                break
            end
            if not usePartnerList[id] then
                num = num + 1
                _tinsert(self.devicePartnerList[index], id)
                usePartnerList[id] = true
            end
        end
    end
end

function PartnerMgrCenterWindow:SetMidPart()
    self:SetDevicePartnerList()
    self:ResetLeftRightBtn()
    for k, v in pairs(self.deviceObjList) do
        PoolManager.Instance:Push(PoolType.class, "DeviceItem", v.deviceItem)
    end
    self.deviceObjList = {}
    self:PushAllUITmpObject("DeviceItem", self.Cache_rect)
    for index = self.nowDeviceFirstPivot, self.nowDevicePivot, 1 do
        local deviceItem
        local deviceObj
        if not self.deviceObjList[index] then
            deviceItem = PoolManager.Instance:Pop(PoolType.class, "DeviceItem")
            if not deviceItem then
                deviceItem = DeviceItem.New()
            end
            self.deviceObjList[index] = 
            {
                deviceItem = deviceItem, 
                deviceObj = nil
            }
        end

        deviceObj = self:PopUITmpObject("DeviceItem", self.DeviceList.transform)
        self.deviceObjList[index].deviceObj = deviceObj
        deviceItem = self.deviceObjList[index].deviceItem
        deviceItem:InitItem(deviceObj, self.showDevices[index], self.devicePartnerList[index])
    end
end

function PartnerMgrCenterWindow:ResetLeftRightBtn()
    UtilsUI.SetActive(self.LeftTab, self.nowDeviceFirstPivot > maxShowDeviceCount)
    UtilsUI.SetActive(self.RightTab, #self.showDevices > self.nowDevicePivot)
end

function PartnerMgrCenterWindow:SetBottomPart()
    local assetLev = mod.AssetPurchaseCtrl:GetAssetLevel(self.nowAssetId)
    local partnerNum = PartnerCenterConfig.GetAssetPartnerLimit(self.nowAssetId, assetLev)
    self.PartnerLimit_txt.text = string.format(TI18N("员工上限： %s/%s"), #self.nowPartners, partnerNum)
    self:PushAllUITmpObject("PartnerSingleItem", self.Cache_rect)
    local indexMap = {}
    for k, v in pairs(self.nowPartners) do
        indexMap[v] = k
    end
    for index, uniqueId in ipairs(self.nowPartners) do
        local partnerSingleItem
        local partnerSingObj
        if not self.partnerObjList[index] then
            partnerSingleItem = PoolManager.Instance:Pop(PoolType.class, "PartnerSingleItem")
            if not partnerSingleItem then
                partnerSingleItem = PartnerSingleItem.New()
            end
            self.partnerObjList[index] = {partnerItem = partnerSingleItem, partnerObj = nil}
        end
        self.partnerObjList[index].partnerObj = self:PopUITmpObject("PartnerSingleItem", self.PartnerContent.transform)
        partnerSingObj = self.partnerObjList[index].partnerObj
        partnerSingleItem = self.partnerObjList[index].partnerItem
        local partnerInfo = mod.BagCtrl:GetPartnerData(uniqueId)
        partnerSingleItem:InitItem(partnerSingObj, partnerInfo, indexMap)
    end
    if #self.nowPartners < partnerNum then
        local partnerSingleItem = PoolManager.Instance:Pop(PoolType.class, "PartnerSingleItem")
        if not partnerSingleItem then
            partnerSingleItem = PartnerSingleItem.New()
        end
        self.partnerObjList[#self.nowPartners + 1] = {
            partnerItem = partnerSingleItem, 
            partnerObj = self:PopUITmpObject("PartnerSingleItem", self.PartnerContent.transform),
            emptyItem = true,
        }
        partnerSingleItem:InitItem(self.partnerObjList[#self.nowPartners + 1].partnerObj, nil, indexMap)
    end
end

function PartnerMgrCenterWindow:ClickTeachBtn()
    CurtainManager.Instance:EnterWait()
    BehaviorFunctions.ShowGuideImageTips(AssetPurchaseConfig.GetGameplayTeachId("AssetPartnerContrlUiTeach"))
    LuaTimerManager.Instance:AddTimer(1, 0.1, function()
        CurtainManager.Instance:ExitWait()
    end)
    
end

function PartnerMgrCenterWindow:ClickLeftTabBtn()
    if #self.showDevices <= maxShowDeviceCount then
        return
    end
    self.nowDevicePivot = self.nowDevicePivot - maxShowDeviceCount < maxShowDeviceCount and maxShowDeviceCount or self.nowDevicePivot - maxShowDeviceCount
    self.nowDeviceFirstPivot = self.nowDeviceFirstPivot - maxShowDeviceCount
    self:SetMidPart()
end

function PartnerMgrCenterWindow:ClickRightTabBtn()
    if #self.showDevices <= maxShowDeviceCount then
        return
    end
    self.nowDevicePivot = self.nowDevicePivot + maxShowDeviceCount > #self.showDevices and #self.showDevices or self.nowDevicePivot + maxShowDeviceCount
    self.nowDeviceFirstPivot = self.nowDeviceFirstPivot + maxShowDeviceCount
    self:SetMidPart()
end