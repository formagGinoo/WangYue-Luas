PartnerBallWindow = BaseClass("PartnerBallWindow", BaseWindow)
PartnerBallWindow.active = true

function PartnerBallWindow:__init()
    self:SetAsset("Prefabs/UI/PartnerCenter/PartnerBallWindow.prefab")
end

function PartnerBallWindow:__BindListener()
    self.GameplayBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenTeachPanel"))
    self.DecreaseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_DecreaseBuildNum"))
    self.IncreaseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_IncreaseBuildNum"))
    self.ConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmBuild"))
    self.GetRewardBtn_btn.onClick:AddListener(self:ToFunc("OnClick_GetReward"))
    self.StopBuildingBtn_btn.onClick:AddListener(self:ToFunc("OnClick_StopBuilding"))
    self.Slider_sld.onValueChanged:AddListener(self:ToFunc("OnDragSliderEvent"))
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))

    EventMgr.Instance:AddListener(EventName.UpdateSelectedPartnerBallItem, self:ToFunc("UpdateSelectedItem"))
    EventMgr.Instance:AddListener(EventName.SetPartnerBallWindowState, self:ToFunc("RecProto_UpdateWindow"))
    EventMgr.Instance:AddListener(EventName.UpdateBuildingPanelData, self:ToFunc("RecProto_UpdateBuildingPanelData"))
end

function PartnerBallWindow:__Show(args)
    self.partnerBallData = {}
    self.partnerBallItemDic = {}
    self.commonItemData = {}
    self.commonItemDic = {}
    self.currPartnerBallData = {}
    self.uniqueId = args and args.uniqueId or self.args.uniqueId
    self.assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    self.deviceId = mod.AssetPurchaseCtrl:GetDecorationListByAssetId(self.assetId)[self.uniqueId].template_id
    self.isBuilding = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(self.assetId, self.uniqueId).work_id ~= 0
    self.partnerList = mod.AssetPurchaseCtrl:GetPartnerBallPartnerList(self.assetId, self.uniqueId)
    self.employeeNum = #self.partnerList
    self.careerId = PartnerCenterConfig.GetAssetDeviceCfg(self.deviceId).career
    self.careerName = PartnerBagConfig.GetPartnerWorkCareerCfgById(self.careerId).name
    self.leaveSecond = 0
    self.timer = 0
    
    -- 打开界面时有奖励可以领取时，领取奖励
    self:TryGetReward()
    
    self:ShowPanel()

    self:SetBlurBack()
end

function PartnerBallWindow:__Hide()
    
end

function PartnerBallWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.UpdateSelectedPartnerBallItem, self:ToFunc("UpdateSelectedItem"))
    EventMgr.Instance:RemoveListener(EventName.SetPartnerBallWindowState, self:ToFunc("RecProto_UpdateWindow"))
    EventMgr.Instance:RemoveListener(EventName.UpdateBuildingPanelData, self:ToFunc("RecProto_UpdateBuildingPanelData"))
end

function PartnerBallWindow:CacheBar()
    
end

function PartnerBallWindow:Update()
    if self.isBuilding then
        if self.leaveSecond == -1 then
            self.LeaveTimeText_txt.text = string.format("工作暂停，请至少安排一名%s员工进行工作", self.careerName)
            return
        end
        
        if self.leaveSecond > 0 then
            if self.timer < 1 then
                self.timer = self.timer + Global.deltaTime

            else
                self.timer = 0

                local hours = math.floor(self.leaveSecond / 3600)
                local minutes = math.floor((self.leaveSecond % 3600) / 60)
                local seconds = math.floor(self.leaveSecond - 3600 * hours - 60 * minutes)
                self.leaveSecond = self.leaveSecond - 1

                if minutes < 1 then
                    self.LeaveTimeText_txt.text = string.format("剩余结束时间：%s秒", seconds)
                elseif hours < 1 then
                    self.LeaveTimeText_txt.text = string.format("剩余结束时间：%s分 %s秒", minutes, seconds)
                else
                    self.LeaveTimeText_txt.text = string.format("剩余结束时间：%s小时 %s分 %s秒", hours, minutes, seconds)
                end
            end
        end
        
    end
end

function PartnerBallWindow:ShowPanel()
    if self.isBuilding then
        self.PartnerBallScrollView:SetActive(false)
        self.NullState:SetActive(true)
        self.PrebuildPanel:SetActive(false)
        self.BuildingPanel:SetActive(true)
        
        self:UpdateBuildingPanel()
    else
        self.PartnerBallScrollView:SetActive(true)
        self.NullState:SetActive(false)
        self.PrebuildPanel:SetActive(true)
        self.BuildingPanel:SetActive(false)
        
        self:UpdatePrebuildPanel()
    end
end

function PartnerBallWindow:UpdatePrebuildPanel()
    self:InitPartnerBallData()

    self:InitPartnerBallScrollView()

    -- 默认选中第一个道具
    if #self.partnerBallData ~= 0 then
        self:UpdateSelectedItem(self.partnerBallData[1])
    end
end

function PartnerBallWindow:UpdateBuildingPanel()
    self:InitPartnerBallData()
    
    local workInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(self.assetId, self.uniqueId)
    local partnerBallData
    for i = 1, #self.partnerBallData do
        if self.partnerBallData[i].id == workInfo.product_id then
            partnerBallData = self.partnerBallData[i]
            break
        end
    end
    
    -- 更新基础显示
    self:UpdatePartnerBaseInfo(partnerBallData)

    -- 有奖励可以领取时，显示获取按钮
    if workInfo.finish_amount ~= 0 then
        self.GetRewardBtn:SetActive(true)
        self.StopBuildingBtn:SetActive(false)
    else
        self.GetRewardBtn:SetActive(false)
        self.StopBuildingBtn:SetActive(true)
    end

    self.partnerList = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(self.assetId, self.uniqueId).partner_list
    if #self.partnerList ~= 0 then
        -- 计算剩余时间
        local leaveWorkNum = workInfo.work_amount - workInfo.finish_amount
        self.leaveSecond = mod.PartnerCenterCtrl:GetPartnerBallProductivityTime(partnerBallData.asset_product_id, self.deviceId, leaveWorkNum, workInfo.partner_list)
    
    -- 月灵列表数量为0，代表月灵被从部件中下阵或者移除
    else
        self.leaveSecond = -1
    end

    self.FinishText_txt.text = string.format("已完成数量: %d/%d", workInfo.finish_amount, workInfo.work_amount)
end

function PartnerBallWindow:InitPartnerBallData()
    self.partnerBallData = PartnerCenterConfig.GetPartnerBallData()

    for i = 1, #self.partnerBallData do
        local data = self.partnerBallData[i]
        
        data.quality = ItemConfig.GetItemConfig(data.item).quality
        data.icon = ItemConfig.GetItemConfig(data.item).icon
        data.name = ItemConfig.GetItemConfig(data.item).name
        data.desc = ItemConfig.GetItemConfig(data.item).desc
    end
end

function PartnerBallWindow:UpdateSelectedItem(partnerBallData)
    self.currPartnerBallData = partnerBallData

    local item
    for i = 1, #self.partnerBallItemDic do
        item = self.partnerBallItemDic[i]
        item:UpdateSelectedState(item.item == partnerBallData.item)
    end

    -- 更新基础显示
    self:UpdatePartnerBaseInfo(partnerBallData)

    self:UpdateCommonItemData(partnerBallData)

    self:UpdateBuildArea()
    
    self:GenerateCommonItem()   -- 设置Slider最大值会触发OnValueChange，所以要放在Slider初始化后面
end

function PartnerBallWindow:UpdatePartnerBaseInfo(partnerBallData)
    SingleIconLoader.Load(self.MainIcon, partnerBallData.icon)
    self.PartnerBallName_txt.text = partnerBallData.name
    self.PartnerBallDesc_txt.text = partnerBallData.desc

    for i = 1, 5, 1 do
        UtilsUI.SetActive(self["QualityBack".. i], i == partnerBallData.quality)
    end
    
    local itemNum = mod.BagCtrl:GetItemCountById(partnerBallData.item)
    self.PartnerBallNum_txt.text = string.format("持有数 %d", itemNum)
end

function PartnerBallWindow:UpdateCommonItemData(partnerBallData)
    self.commonItemData = {}
    local commonItemData = partnerBallData.item_consume

    for i = 1, #commonItemData do
        -- 配置表没有配置时ItemId为0
        if commonItemData[i][1] ~= 0 then
            local bagCount = mod.BagCtrl:GetItemCountById(commonItemData[i][1])
            table.insert(self.commonItemData, {itemId = commonItemData[i][1], cost = commonItemData[i][2], bagCount = bagCount})
        end
    end
end

function PartnerBallWindow:GenerateCommonItem()
    -- 清空原有数据
    for _, data in pairs(self.commonItemDic) do
        PoolManager.Instance:Push(PoolType.class, "CommonItem", data.commonItem)
        GameObject.Destroy(data.object)
    end
    self.commonItemDic = {}
    
    -- 生成CommonItem
    for i = 1, #self.commonItemData do
        local obj = GameObject.Instantiate(self.CommonItem)
        obj.transform:SetParent(self.ItemCostContent.transform)
        
        local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not commonItem then
            commonItem = CommonItem.New()
        end

        local itemInfo = {template_id = self.commonItemData[i].itemId, count = self.commonItemData[i].cost, scale = 0.8}    -- todo
        
        commonItem:InitItem(obj, itemInfo, true)
        commonItem:SetNum(string.format("%d/%d", self.commonItemData[i].bagCount, self.commonItemData[i].cost))
        
        table.insert(self.commonItemDic, {commonItem = commonItem, object = obj})
    end
end

-- 需要在更新CommonItemData后生效
function PartnerBallWindow:UpdateBuildArea()
    -- 初始化Slider
    self.Slider_sld.maxValue = self:GetMaxBuildNum()
    self.Slider_sld.minValue = self.Slider_sld.maxValue == 0 and 0 or 1
    self.Slider_sld.value = self.Slider_sld.maxValue == 0 and 0 or 1
    
    self.SliderMaxNum_txt.text = string.format("%d", self.Slider_sld.maxValue)
    self.SliderMinNum_txt.text = string.format("%d", self.Slider_sld.minValue)
    self.BuildNumText_txt.text = string.format("制作数量: %d", self.Slider_sld.value)

    -- 获取当前&最大员工数量
    local assetLevel = mod.AssetPurchaseCtrl:GetAssetLevel(self.assetId)
    local employeeLimit = AssetPurchaseConfig.GetPartnerBallStaffNum(self.deviceId, assetLevel)
    self.partnerList = mod.AssetPurchaseCtrl:GetPartnerBallPartnerList(self.assetId, self.uniqueId)
    self.employeeNum = #self.partnerList

    -- 材料充足但月灵不足
    if self.employeeNum == 0 and self.Slider_sld.minValue ~= 0 then
        self.BuildablePart:SetActive(false)
        self.UnbuildablePart:SetActive(true)
        self.ConfirmBtn:SetActive(true)
        self.FakeConfirmBtn:SetActive(false)

        self.UnbuildableText_txt.text = string.format("<color=#B52E20>员工分配 0/%d   建议至少安排1名%s职业员工</color>", employeeLimit, self.careerName)
        
    -- 材料不足时
    elseif self.Slider_sld.minValue == 0 then
        self.BuildablePart:SetActive(false)
        self.UnbuildablePart:SetActive(true)
        self.ConfirmBtn:SetActive(false)
        self.FakeConfirmBtn:SetActive(true)

        if self.employeeNum == 0 then
            self.UnbuildableText_txt.text = string.format("<color=#B52E20>员工分配 0/%d   建议至少安排1名%s职业员工</color>", employeeLimit, self.careerName)
        else
            self.UnbuildableText_txt.text = string.format("<color=#B52E20>员工分配 %d/%d   当前材料不足</color>", self.employeeNum, employeeLimit)
        end

    else
        self.BuildablePart:SetActive(true)
        self.UnbuildablePart:SetActive(false)
        self.ConfirmBtn:SetActive(true)
        self.FakeConfirmBtn:SetActive(false)

        -- 更新预计时间
        local totalSecond = mod.PartnerCenterCtrl:GetPartnerBallProductivityTime(self.currPartnerBallData.asset_product_id, self.deviceId, self.Slider_sld.value, self.partnerList)
        local hours = math.floor(totalSecond / 3600)
        local minutes = math.floor((totalSecond % 3600) / 60)
        local seconds = math.floor(totalSecond - 3600 * hours - 60 * minutes)
        self.BuildableEmployeeText_txt.text = string.format("员工分配 %d/%d", self.employeeNum, employeeLimit)
        if minutes < 1 then
            self.BuildableTimeText_txt.text = string.format("预计完成时间 %d秒", math.tointeger(seconds))
        elseif hours < 1 then
            self.BuildableTimeText_txt.text = string.format("预计完成时间 %d分%d秒", math.tointeger(minutes), math.tointeger(seconds))
        else
            self.BuildableTimeText_txt.text = string.format("预计完成时间 %d小时%d分%d秒", math.tointeger(hours), math.tointeger(minutes), math.tointeger(seconds))
        end
        self.BuildNumText_txt.text = string.format("制作数量: %d", self.Slider_sld.value)
    end
end

function PartnerBallWindow:InitPartnerBallScrollView()
    if not self.PartnerBallScrollView_recyceList then
        return
    end

    self.PartnerBallScrollView_recyceList:CleanAllCell()
    self.PartnerBallScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdatePartnerBallItem"))
    self.PartnerBallScrollView_recyceList:SetCellNum(#self.partnerBallData)
end

function PartnerBallWindow:UpdatePartnerBallItem(_index, _obj)
    if not _obj then
        return
    end

    if not self.partnerBallItemDic[_index] then
        self.partnerBallItemDic[_index] = PartnerBallSingleItem.New()
    end

    local item = self.partnerBallItemDic[_index]
    local data = self.partnerBallData[_index]
    data.index = _index
    data.obj = _obj

    item:UpdateData(data)
end

function PartnerBallWindow:OnDragSliderEvent()
    -- 更新所需材料数量
    for i = 1, #self.commonItemDic do
        local commonItem = self.commonItemDic[i].commonItem
        
        for j = 1, #self.commonItemData do
            if self.commonItemData[j].itemId == commonItem.itemInfo.template_id then
                commonItem:SetNum(string.format("%d/%d", self.commonItemData[j].bagCount, self.Slider_sld.value * self.commonItemData[j].cost))
                break
            end
        end
    end

    -- 获取最大员工数量
    local assetLevel = mod.AssetPurchaseCtrl:GetAssetLevel(self.assetId)
    local employeeLimit = AssetPurchaseConfig.GetPartnerBallStaffNum(self.deviceId, assetLevel)

    if self.Slider_sld.minValue ~= 0 and self.employeeNum ~= 0 then
        -- 更新预计时间
        local totalSecond = mod.PartnerCenterCtrl:GetPartnerBallProductivityTime(self.currPartnerBallData.asset_product_id, self.deviceId, self.Slider_sld.value, self.partnerList)
        local hours = math.floor(totalSecond / 3600)
        local minutes = math.floor((totalSecond % 3600) / 60)
        local seconds = math.floor(totalSecond - 3600 * hours - 60 * minutes)
        self.BuildableEmployeeText_txt.text = string.format("员工分配 %d/%d", self.employeeNum, employeeLimit)
        if minutes < 1 then
            self.BuildableTimeText_txt.text = string.format("预计完成时间 %d秒", seconds)
        elseif hours < 1 then
            self.BuildableTimeText_txt.text = string.format("预计完成时间 %d分%d秒", minutes, seconds)
        else
            self.BuildableTimeText_txt.text = string.format("预计完成时间 %d小时%d分%d秒", hours, minutes, seconds)
        end
    end

    self.BuildNumText_txt.text = string.format("制作数量: %d", self.Slider_sld.value)
end

function PartnerBallWindow:OnClick_IncreaseBuildNum()
    if self.Slider_sld.value == self.Slider_sld.maxValue then
        return
    end
    
    self.Slider_sld.value = self.Slider_sld.value + 1
    
    self:OnDragSliderEvent()
end

function PartnerBallWindow:OnClick_DecreaseBuildNum()
    if self.Slider_sld.value == self.Slider_sld.minValue then
        return
    end
    
    self.Slider_sld.value = self.Slider_sld.value - 1
    
    self:OnDragSliderEvent()
end

-- 向后端发送协议：领取奖励
function PartnerBallWindow:OnClick_GetReward()
    local workInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(self.assetId, self.uniqueId)

    -- 当全部工作都完成可以领取全部奖励时，发送取消协议清空本地数据
    if workInfo.finish_amount == workInfo.work_amount then
        mod.PartnerCenterCtrl:SendMessageAssetCenterWorkCancel(self.assetId, self.uniqueId)
        
    -- 可以领取部分奖励时，发送领取奖励协议，只清空完成数量
    else
        mod.PartnerCenterCtrl:SendMessageAssetCenterWorkFetch(self.assetId, self.uniqueId)
    end
end

-- 向后端发送协议：中断任务
function PartnerBallWindow:OnClick_StopBuilding()
    mod.PartnerCenterCtrl:SendMessageAssetCenterWorkCancel(self.assetId, self.uniqueId)
end

-- 向后端发送协议：发布任务
function PartnerBallWindow:OnClick_ConfirmBuild()
    local workId = self.currPartnerBallData.asset_product_id
    local productId = self.currPartnerBallData.id
    local workAmount = self.Slider_sld.value
    
    mod.PartnerCenterCtrl:SendMessageAssetCenterWorkSet(self.assetId, self.uniqueId, self.partnerList, workId, workAmount, productId)
end

function PartnerBallWindow:OnClick_OpenTeachPanel()
    local id = AssetPurchaseConfig.GetGameplayTeachId("AssetPartnerCatchUiTeach")

    BehaviorFunctions.ShowGuideImageTips(id)
end

-- 成功收到回包后，更新面板
function PartnerBallWindow:RecProto_UpdateWindow()
    self.isBuilding = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(self.assetId, self.uniqueId).work_id ~= 0
    
    self:ShowPanel()
end

-- 收到10秒回包协议后，更新正在制作面板数据
function PartnerBallWindow:RecProto_UpdateBuildingPanelData(data)
    if data.id ~= self.uniqueId or self.deviceId ~= data.template_id then
        return
    end
    
    local workInfo = data.work_info
    if workInfo.work_amount == 0 then
        return
    end

    -- 全部完成时，关闭当前Window并弹出道具获奖界面
    if workInfo.finish_amount == workInfo.work_amount then
        mod.PartnerCenterCtrl:SendMessageAssetCenterWorkCancel(self.assetId, self.uniqueId)
        WindowManager.Instance:CloseWindow(self)
        return
    end

    -- 更新剩余时间
    local asset_product_id = PartnerCenterConfig.GetPartnerBallDataById(workInfo.product_id).asset_product_id
    if #workInfo.partner_list == 0 then
        self.leaveSecond = 0
    else
        self.leaveSecond = mod.PartnerCenterCtrl:GetPartnerBallProductivityTime(asset_product_id, self.deviceId, workInfo.work_amount - workInfo.finish_amount, workInfo.partner_list)
    end
    
    -- 有奖励可以领取时，显示获取按钮
    if workInfo.finish_amount ~= 0 then
        self.GetRewardBtn:SetActive(true)
        self.StopBuildingBtn:SetActive(false)
    else
        self.GetRewardBtn:SetActive(false)
        self.StopBuildingBtn:SetActive(true)
    end

    -- 更新完成数量
    self.FinishText_txt.text = string.format("已完成数量: %d/%d", workInfo.finish_amount, workInfo.work_amount)
end

function PartnerBallWindow:TryGetReward()
    local workInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(self.assetId, self.uniqueId)

    -- 当全部工作都完成可以领取全部奖励时，发送取消协议清空本地数据
    if workInfo.work_id ~= 0 and workInfo.finish_amount == workInfo.work_amount then
        mod.PartnerCenterCtrl:SendMessageAssetCenterWorkCancel(self.assetId, self.uniqueId)
    end
end

function PartnerBallWindow:GetMaxBuildNum()
    local minValue = math.maxinteger
    local num
    for i = 1, #self.commonItemData do
        num = math.floor(self.commonItemData[i].bagCount / self.commonItemData[i].cost)     -- 向下取整
        minValue = minValue > num and num or minValue
    end

    return minValue
end

function PartnerBallWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end
