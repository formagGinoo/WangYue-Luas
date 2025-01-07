DeviceItem = BaseClass("DeviceItem", Module)

function DeviceItem:__init()

end

function DeviceItem:__delete()
    self:ResetItem()
end

function DeviceItem:InitItem(object, deviceData, partnerlist)
	-- 获取对应的组件
	self.node = object
    self:ResetItem()
    UtilsUI.SetActive(self.node.object, true)
    self:SetData(deviceData, partnerlist)
	self:Show()
end

function DeviceItem:HideItem()
    UtilsUI.SetActive(self.node.object, false)
end

function DeviceItem:SetData(deviceData, partnerlist)
    self.deviceData = deviceData
    self.deviceInfo = self.deviceData.info
    self.deviceConfig = self.deviceData.config
    self.partnerlist = partnerlist
    self.assetLevel = mod.AssetPurchaseCtrl:GetAssetLevel(self.deviceConfig.asset_id)
    self.devicePartnerLimit = PartnerCenterConfig.GetAssetDeviceNumLimit(self.deviceConfig.id, self.assetLevel)
    self.assetPartnerList = mod.AssetPurchaseCtrl:GetAssetPartnerList(self.deviceConfig.asset_id)
end

function DeviceItem:Show()
    SingleIconLoader.Load(self.node.DeviceIcon, self.deviceConfig.icon)
    self.node.DeviceName_txt.text = self.deviceConfig.name
    UtilsUI.SetActive(self.node.WorkerNum, self.deviceConfig.type == PartnerCenterConfig.DeviceType.Produce)
    UtilsUI.SetActive(self.node.WorkSpeed, self.deviceConfig.type == PartnerCenterConfig.DeviceType.Produce)

    local careerConfig = PartnerBagConfig.GetPartnerWorkCareerCfgById(self.deviceConfig.career)
    UtilsUI.SetActive(self.node.Job, true)
    SingleIconLoader.Load(self.node.JobIcon, careerConfig.icon)
    self.node.JobText_txt.text = careerConfig.name
    self:ResetPartnerList()

    if self.deviceConfig.type == PartnerCenterConfig.DeviceType.Produce then
        local partnerNum = TableUtils.GetTabelLen(self.partnerlist)
        self.node.WorkerNum_txt.text = string.format(TI18N("工作人限： %s/%s"), partnerNum, self.devicePartnerLimit)
        local productivity = mod.PartnerCenterCtrl:GetProductivityByPartnerList(self.deviceInfo.id, self.partnerlist)
        if self.deviceInfo.work_info.work_id == 0 then
            UtilsUI.SetActive(self.node.Unused, true)
            self.node.WorkSpeed_txt.text = string.format(TI18N("预计生成速率:   %d个/小时"), productivity)
            if partnerNum > 0 then
                UtilsUI.SetTextColor(self.node.WorkSpeed_txt, "#178C05")
                return
            end
        else
            UtilsUI.SetTextColor(self.node.WorkSpeed_txt, "#393F4A")
            UtilsUI.SetActive(self.node.Unused, false)
        end
        self.node.WorkSpeed_txt.text = string.format(TI18N("生成速率:   %d个/小时"), productivity)
    else
        UtilsUI.SetActive(self.node.Unused, false)
    end
end

function DeviceItem:ResetPartnerList()
    self:ResetItem()
    if self.deviceConfig.type ~= PartnerCenterConfig.DeviceType.Produce then
        return
    end
    for k, uniqueId in pairs(self.partnerlist) do
        local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
        if partnerData then
            local go = GameObject.Instantiate(self.node.SingleItem, self.node.PartnerListContent.transform)
            UtilsUI.SetActive(go, true)
            local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
            if not commonItem then
                commonItem = CommonItem.New()
            end
            commonItem:InitItem(go, partnerData)
            table.insert(self.partnerObjList, {obj = go, item = commonItem})
        end
    end
end

function DeviceItem:ResetItem()
    if not self.partnerObjList then
        self.partnerObjList = {}
        return 
    end
    for k, v in pairs(self.partnerObjList) do
        PoolManager.Instance:Push(PoolType.class, "CommonItem", v.item)
        GameObject.Destroy(v.obj)
    end
    self.partnerObjList = {}
end

function DeviceItem:OnReset()
    self:ResetItem()
end