AssetPurchaseCtrl = BaseClass("AssetPurchaseCtrl", Controller)

function AssetPurchaseCtrl:__init()
    EventMgr.Instance:AddListener(EventName.EnterMap, self:ToFunc("UpdataCurAssetId"))
    self.interactMap = {}
    self.existingAssetMap = {}
    self.assetId = nil

    EventMgr.Instance:AddListener(EventName.StartFight, self:ToFunc("InitDecorationInteractEvent"))
    EventMgr.Instance:AddListener(EventName.ExitFight, self:ToFunc("UnInitDecorationInteractEvent"))
    EventMgr.Instance:AddListener(EventName.RemoveDeviceInteract, self:ToFunc("RemoveDeviceInteract"))
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("OnPartnerInfoChange"))
    self.triggerFuns = {}
    self.triggerFuns[1001001] = {
        func = self.OpenPartnerMgrCenter
    }
    self.triggerFuns[1001006] = {
        func = self.OpenPartnerSkillUnlockPanel
    }
    self.triggerFuns[1001005] = {
        func = self.OpenDiningTableWindow
    }
    self.triggerFuns[1001002] = {
        func = self.PartnerStoreWindow
    }
    self.triggerFuns[1001003] = {
        func = self.OpenPartnerBallWindow
    }
    self.deviceTriggerUniqueList = {}
end

-- **初始化资产信息 (主协议)
function AssetPurchaseCtrl:UpdataAssetInfo(data)
    for i, v in ipairs(data) do
        local severData = v
        local decorationList = {}
        local decorationCountList = {}

        for _, deviceInfo in pairs(v.decoration_list) do
            decorationList[deviceInfo.id] = deviceInfo
        end
        for _, deviceCountInfo in pairs(v.decoration_count_list) do
            decorationCountList[deviceCountInfo.key] = deviceCountInfo.value
        end

        severData.decoration_list = decorationList
        severData.decoration_count_list = decorationCountList

        self.existingAssetMap[v.asset_id] = severData
    end
end

-- **物件更新协议
function AssetPurchaseCtrl:UpdataAssetWorkUpdate(data)
    for i, v in ipairs(data.update_list) do
        self:UpdataAssetDecorationList(v)
    end
end

function AssetPurchaseCtrl:UpdataAssetDecorationList(data)
    local assetInfo = self.existingAssetMap[data.asset_id]
    if not assetInfo then
        return
    end

    -- 更新物件list
    for _, v in pairs(data.decoration_list) do
        assetInfo.decoration_list[v.id] = v
        self:AssetDecorationInfoUpdate(data.asset_id, v.id)

        EventMgr.Instance:Fire(EventName.UpdateBuildingPanelData, v)
        EventMgr.Instance:Fire(EventName.AssetDecorationInfoUpdate, data.asset_id, v.id)
    end
end

function AssetPurchaseCtrl:AssetDecorationInfoUpdate(assetId, deviceUniqueId)
    if not self.existingAssetMap[assetId] then
        return
    end

    local deviceInfo = self.existingAssetMap[assetId].decoration_list[deviceUniqueId]
    if not deviceInfo then
        return
    end

    local deviceCfg = PartnerCenterConfig.GetAssetDeviceCfg(deviceInfo.template_id)
    if not deviceCfg then
        return
    end
    
    --分情况添加触发器
    if deviceCfg.type == PartnerCenterConfig.DeviceType.Produce and deviceInfo.work_info.finish_amount > 0 then
        local cb  = function()
            self:OnClickDecorationInteract(assetId, deviceUniqueId)
        end
        
        self:AddDecorationInteractEvent(deviceUniqueId, PartnerCenterConfig.DeviceIcon[PartnerCenterConfig.DeviceType.Produce], TI18N("收集原料"), cb)
    end

    -- 月灵球制作台任务完成后，增加收集产物选项框
    local isPartnerBallDevice = PartnerCenterConfig.GetPartnerBallDataById(deviceInfo.work_info.product_id) ~= nil
    if deviceCfg.type == PartnerCenterConfig.DeviceType.Basic and isPartnerBallDevice then
        local cb  = function()
            -- 发送协议领取奖励
            mod.PartnerCenterCtrl:SendMessageAssetCenterWorkCancel(assetId, deviceUniqueId)
        end

        if deviceInfo.work_info.work_amount == deviceInfo.work_info.finish_amount and deviceInfo.work_info.work_amount ~= 0 then
            self:AddDecorationInteractEvent(deviceUniqueId, PartnerCenterConfig.DeviceIcon[PartnerCenterConfig.DeviceType.Basic], TI18N("收集产物"), cb)
        else
            self:RemoveDecorationInteractEvent(deviceUniqueId)
        end
        
    end
end

function AssetPurchaseCtrl:UpdataCurAssetId(mapId)
    for k, v in pairs(AssetPurchaseConfig.GetAssetConfig()) do
        if v.asset_scene == mapId then
            self.assetId = v.id
            mod.AssetTaskCtrl:InitTaskInfo(self.assetId)
            EventMgr.Instance:Fire(EventName.EnterAsset, self.assetId)
            return
        end
    end
    self.assetId = nil
end

function AssetPurchaseCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.StartFight, self:ToFunc("InitDecorationInteractEvent"))
    EventMgr.Instance:RemoveListener(EventName.ExitFight, self:ToFunc("UnInitDecorationInteractEvent"))
    EventMgr.Instance:RemoveListener(EventName.RemoveDeviceInteract, self:ToFunc("RemoveDeviceInteract"))
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("OnPartnerInfoChange"))
end

function AssetPurchaseCtrl:__InitComplete()

end

function AssetPurchaseCtrl:OnPartnerInfoChange(oldData, newData)
    --佩丛上下阵添加触发器
    if oldData.work_info.asset_id ~= newData.work_info.asset_id and newData.work_info.asset_id ~= 0 then
        self:AddPartnerInteractEvent(newData.unique_id)
    end
end

function AssetPurchaseCtrl:CheckDeviceIsAddTrigger(deviceUniqueId)
    if self.deviceTriggerUniqueList and self.deviceTriggerUniqueList[deviceUniqueId] then
        return true
    end
    return false
end

function AssetPurchaseCtrl:AddDeviceTriggerList(deviceUniqueId)
    self.deviceTriggerUniqueList[deviceUniqueId] = true
end

function AssetPurchaseCtrl:RemoveDeviceTriggerList(deviceUniqueId)
    self.deviceTriggerUniqueList[deviceUniqueId] = false
end
-- 添加触发器
function AssetPurchaseCtrl:InitDecorationInteractEvent()
    if not self.existingAssetMap then
        return
    end
    
    for assetId, assetInfo in pairs(self.existingAssetMap) do
        local devices = mod.AssetPurchaseCtrl:GetDeviceListById(assetId)
        for k, info in pairs(devices) do
            if self.triggerFuns[info.template_id] then
                local icon = PartnerCenterConfig.GetAssetDeviceCfg(info.template_id).icon_tauch
                local text = PartnerCenterConfig.GetAssetDeviceCfg(info.template_id).name
                self:AddSingleDecorationInteractEvent(info.template_id, info.id, icon, text)
            end
            --设备动态触发器添加
            self:AssetDecorationInfoUpdate(assetId, info.id)
        end
        
        if assetId == self.assetId then
            for num, uniqueId in pairs(assetInfo.partner_list) do
                self:AddPartnerInteractEvent(uniqueId)
            end
        end
    end
end

function AssetPurchaseCtrl:UnInitDecorationInteractEvent()
    TableUtils.ClearTable(self.deviceTriggerUniqueList)
    TableUtils.ClearTable(self.interactMap)
end

function AssetPurchaseCtrl:RemoveDeviceInteract(deviceUniqueId)
    self:RemoveDecorationInteractEvent(deviceUniqueId)
end

function AssetPurchaseCtrl:RemoveDecorationEntity(uniqueId)
    Fight.Instance.entityManager.partnerDisplayManager:RemoveDecorationEntity(uniqueId)
    self:RemoveDeviceTriggerList(uniqueId)
end

function AssetPurchaseCtrl:AddSingleDecorationInteractEvent(templateId, uniqueId, icon, text)
    if not self.triggerFuns[templateId] then
        LogError("传进来的资产设备templateid是空的,配置下吧")
        return
    end

    if self:CheckDeviceIsAddTrigger(uniqueId) then
        return
    end

    self:AddDeviceTriggerList(uniqueId)
    Fight.Instance.entityManager.partnerDisplayManager:AddDecorationInteract(uniqueId, icon, text, function()
        self.triggerFuns[templateId].func(self, uniqueId)
    end)
end

function AssetPurchaseCtrl:AddDecorationInteractEvent(uniqueId, icon, text, callback)
    if not self.interactMap[uniqueId] and Fight.Instance then
        self.interactMap[uniqueId] = Fight.Instance.entityManager.partnerDisplayManager:AddDecorationInteract(uniqueId, icon, text, callback)
    end
end

function AssetPurchaseCtrl:RemoveDecorationInteractEvent(uniqueId)
    if self.interactMap[uniqueId] and Fight.Instance then
        Fight.Instance.entityManager.partnerDisplayManager:RemoveDecorationInteract(uniqueId, self.interactMap[uniqueId])
        self.interactMap[uniqueId] = nil
    end
end

function AssetPurchaseCtrl:AddPartnerInteractEvent(uniqueId)
    local callback = function()
        self:PartnerQuickWorkWindow(uniqueId)
    end
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local icon = PartnerConfig.GetPartnerConfig(partnerData.template_id).head_icon
    local desc = PartnerConfig.GetPartnerConfig(partnerData.template_id).name
    local text = string.format(TI18N("%s-工作替换"), desc)
    Fight.Instance.entityManager.partnerDisplayManager:AddDisplayInteract(uniqueId, icon, text, callback)
end

function AssetPurchaseCtrl:OnClickDecorationInteract(assetId, uniqueId)
    mod.PartnerCenterCtrl:SendMessageAssetCenterWorkFetch(assetId, uniqueId)
end

function AssetPurchaseCtrl:OpenPartnerMgrCenter(uniqueId)
    WindowManager.Instance:OpenWindow(PartnerMgrCenterWindow)
end

function AssetPurchaseCtrl:OpenPartnerSkillUnlockPanel(uniqueId)
    WindowManager.Instance:OpenWindow(PartnerUnlockSkillWindow, {uniqueId = uniqueId})
end

function AssetPurchaseCtrl:OpenDiningTableWindow(uniqueId)
    WindowManager.Instance:OpenWindow(DiningTableWindow, {uniqueId = uniqueId})
end

function AssetPurchaseCtrl:OpenPartnerBallWindow(uniqueId)
    WindowManager.Instance:OpenWindow(PartnerBallWindow, {uniqueId = uniqueId})
end

function AssetPurchaseCtrl:PartnerStoreWindow(uniqueId)
    WindowManager.Instance:OpenWindow(PartnerStoreWindow, {
        uniqueId = uniqueId
    })
end

function AssetPurchaseCtrl:PartnerQuickWorkWindow(uniqueId)
    WindowManager.Instance:OpenWindow(PartnerQuickWorkWindow, {
        uniqueId = uniqueId
    })
end

function AssetPurchaseCtrl:SetAssetPartnerList(assetId, partnerList)
    if not self.existingAssetMap[assetId] then
        return
    end
    self.existingAssetMap[assetId].partner_list = partnerList
end

-- 设置设备下的工作信息的佩丛列表
function AssetPurchaseCtrl:SetDevicePartnerList(assetId, deviceUniqueId, partnerList)
    if not self.existingAssetMap[assetId] then
        return
    end
    local deviceInfo = self.existingAssetMap[assetId].decoration_list[deviceUniqueId]
    deviceInfo.work_info.partner_list = partnerList
end

-- 替换设备下的工作信息的佩丛列表
function AssetPurchaseCtrl:ReplaceDevicePartnerList(assetId, old_deviceUniqueId, new_deviceUniqueId, old_partner_id, new_partner_id)
    if not self.existingAssetMap[assetId] then
        return
    end
    if old_deviceUniqueId ~= 0 then
        local old_deviceInfo = self.existingAssetMap[assetId].decoration_list[old_deviceUniqueId]
        local isReplace = false
        for i, v in pairs(old_deviceInfo.work_info.partner_list) do
            if v == old_partner_id then
                old_deviceInfo.work_info.partner_list[i] = new_partner_id
                isReplace = true 
                break
            end
        end
        if not isReplace then
            table.insert(old_deviceInfo.work_info.partner_list, new_partner_id)
        end
    end
    
    if new_deviceUniqueId ~= 0 then
        local new_deviceInfo = self.existingAssetMap[assetId].decoration_list[new_deviceUniqueId]
        local isReplace = false
        for i, v in pairs(new_deviceInfo.work_info.partner_list) do
            if v == new_deviceUniqueId then
                new_deviceInfo.work_info.partner_list[i] = old_partner_id
                isReplace = true
                break
            end
        end
        if not isReplace then
            table.insert(new_deviceInfo.work_info.partner_list, new_partner_id)
        end
    end
    
end

function AssetPurchaseCtrl:UpdataAssetLevel(assetId, level)
    self.existingAssetMap[assetId].level = level
    MsgBoxManager.Instance:ShowTips(string.format(TI18N("资产已提升至%d级"), level))
    EventMgr.Instance:Fire(EventName.AssetLevelUp, assetId)
end

function AssetPurchaseCtrl:UpdataAssetDecorationCountList(data)
    local assetId = data.asset_id
    if not self.existingAssetMap[assetId] then
        return
    end

    for i, v in pairs(data.decoration_count_list) do
        self.existingAssetMap[assetId].decoration_count_list[v.key] = v.value
    end
end

function AssetPurchaseCtrl:AddAssetDecorationBagList(data)
    self:UpdataAssetDecorationList(data)

    for i, v in pairs(data.decoration_list) do
        if self.triggerFuns[v.template_id] then
            local icon = PartnerCenterConfig.GetAssetDeviceCfg(v.template_id).icon_tauch
            local text = PartnerCenterConfig.GetAssetDeviceCfg(v.template_id).name
            self:AddSingleDecorationInteractEvent(v.template_id, v.id, icon, text)
        end
    end
end

function AssetPurchaseCtrl:DelDecorationBagList(assetId, data)
    if not self.existingAssetMap[assetId] then
        return
    end
    -- 删除设备信息
    self.existingAssetMap[assetId].decoration_list[data.id] = nil
    -- 删除设备数量
    local value = self.existingAssetMap[assetId].decoration_count_list[data.template_id]
    if value then
        value = value - 1
        if value <= 0 then
            self.existingAssetMap[assetId].decoration_count_list[data.template_id] = nil
        else
            self.existingAssetMap[assetId].decoration_count_list[data.template_id] = value
        end
    end
end

function AssetPurchaseCtrl:GetAssetPartnerList(asset_id)
    if self.existingAssetMap[asset_id] then
        return self.existingAssetMap[asset_id].partner_list
    end
end

-- 获取能参与月灵球制作月灵列表(在资产中，工种适配，且没有在其他地方工作)
function AssetPurchaseCtrl:GetPartnerBallPartnerList(asset_id, deviceId)
    local resultList = {}
    local assetPartnerList = mod.AssetPurchaseCtrl:GetAssetPartnerList(asset_id)

    for i = 1, #assetPartnerList do
        local curPartnerData = mod.BagCtrl:GetPartnerData(assetPartnerList[i])
        if PartnerCenterConfig.CheckPartnerCanWorkInDevice(curPartnerData.template_id, deviceId) then
            if curPartnerData.work_info.work_decoration_id == 0 then
                table.insert(resultList, assetPartnerList[i])
            end
        end
    end
    
    return resultList
end

function AssetPurchaseCtrl:GetAssetLevel(asset_id)
    if self.existingAssetMap[asset_id] then
        return self.existingAssetMap[asset_id].level
    end
end

function AssetPurchaseCtrl:GetCurAssetInfo()
    if self.assetId == nil then
        return nil
    end
    return self.existingAssetMap[self.assetId]
end

function AssetPurchaseCtrl:GetExistingAssetInfoById(asset_id)
    if self.existingAssetMap[asset_id] then
        return self.existingAssetMap[asset_id]
    end
end

function AssetPurchaseCtrl:GetDeviceListById(asset_id)
    if self.existingAssetMap[asset_id] then
        return self.existingAssetMap[asset_id].decoration_list
    end
end

function AssetPurchaseCtrl:GetExistingAssetInfo()
    return self.existingAssetMap
end

function AssetPurchaseCtrl:CheckPartnerInAssetPartnerList(assetId, partnerUniqueId)
    if not self.existingAssetMap[assetId] then
        return false
    end
    for k, uniqueId in pairs(self.existingAssetMap[assetId].partner_list) do
        if uniqueId == partnerUniqueId then
            return true
        end
    end
    return false
end

function AssetPurchaseCtrl:CheckDeviceInAsset(assetId, deviceId)
    if not self.existingAssetMap[assetId] then
        return false
    end

    if self.existingAssetMap[assetId].decoration_count_list[deviceId] then
        return true
    end

    return false
end

function AssetPurchaseCtrl:GetCurAssetInfo()
    return self.existingAssetMap[self.assetId]
end

function AssetPurchaseCtrl:CheckPartnerInDevice(assetId, partnerId, deviceUniqueId)
    if not self.existingAssetMap[assetId] then
        return false
    end

    local partnerData = mod.BagCtrl:GetPartnerData(partnerId)
    if not partnerData then
        return false
    end

    if partnerData.work_info.work_decoration_id == deviceUniqueId then
        return true
    end

    return false
end

function AssetPurchaseCtrl:GetDevicePartnerList(assetId, deviceUniqueId)
    if not self.existingAssetMap[assetId] then
        return
    end

    if self.existingAssetMap[assetId].decoration_list[deviceUniqueId] then
        return self.existingAssetMap[assetId].decoration_list[deviceUniqueId].work_info.partner_list
    end
end

function AssetPurchaseCtrl:GetDecorationTotalCount(deviceId)
    local bagCount = mod.DecorationCtrl:GetDecorationCount(deviceId)
    for k, v in pairs(self.existingAssetMap) do
        if v.decoration_count_list[deviceId] then
            bagCount = bagCount + v.decoration_count_list[deviceId]
        end
    end
    return bagCount
end

function AssetPurchaseCtrl:GetDecorationListByAssetId(assetId)
    if not self.existingAssetMap[assetId] then
        return
    end

    return self.existingAssetMap[assetId].decoration_list
end

function AssetPurchaseCtrl:GetDeviceWorkInfo(assetId, deviceUniqueId)
    if not self.existingAssetMap[assetId] then
        return
    end

    if self.existingAssetMap[assetId].decoration_list[deviceUniqueId] then
        return self.existingAssetMap[assetId].decoration_list[deviceUniqueId].work_info
    end
end

function AssetPurchaseCtrl:SetDeviceWorkInfo(assetId, uniqueId, partner_list, work_id, work_amount, product_id, finish_amount)
    if not self.existingAssetMap[assetId] then
        return
    end
    
    if self.existingAssetMap[assetId].decoration_list[uniqueId] then
        local workInfo = self.existingAssetMap[assetId].decoration_list[uniqueId].work_info
        workInfo.partner_list = partner_list or workInfo.partner_list
        workInfo.work_id = work_id or workInfo.work_id
        workInfo.work_amount = work_amount or workInfo.work_amount
        workInfo.product_id = product_id or workInfo.product_id
        workInfo.finish_amount = finish_amount or workInfo.finish_amount
    end
end

function AssetPurchaseCtrl:GetCurAssetDeviceWorkData(deviceUniqueId)
    if not self.existingAssetMap[self.assetId] then
        return
    end

    if self.existingAssetMap[self.assetId].decoration_list[deviceUniqueId] then
        return self.existingAssetMap[self.assetId].decoration_list[deviceUniqueId]
    end
end

function AssetPurchaseCtrl:GetDeviceWorkData(curAssetId, deviceUniqueId)
    if not self.existingAssetMap[curAssetId] then
        return
    end

    if self.existingAssetMap[curAssetId].decoration_list[deviceUniqueId] then
        return self.existingAssetMap[curAssetId].decoration_list[deviceUniqueId]
    end
end

function AssetPurchaseCtrl:GetDeviceListByType(deviceType)
    if not self.existingAssetMap[self.assetId] then
        return
    end
    local list = {}
    for k, v in pairs(self.existingAssetMap[self.assetId].decoration_list) do
        local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(v.template_id)
        if deviceCfg and deviceCfg.type == deviceType then
            table.insert(list, v)
        end
    end
    return list
end

function AssetPurchaseCtrl:GetAssetDeviceConfigId(assetId, deviceUniqueId)
    if not self.existingAssetMap[assetId] then
        return
    end

    if self.existingAssetMap[assetId].decoration_list[deviceUniqueId] then
        return self.existingAssetMap[assetId].decoration_list[deviceUniqueId].template_id
    end
end

function AssetPurchaseCtrl:GetCurAssetId()
    return self.assetId
end

function AssetPurchaseCtrl:GetAssetEnterPos(assetId)

    local cfg = AssetPurchaseConfig.GetAssetConfigById(assetId)
    local mapId = cfg.enter_trans_map_id
    local MapPos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(cfg.enter_position_id, cfg.enter_position[2],
        cfg.enter_position[1])
    return MapPos
end
function AssetPurchaseCtrl:GotoAsset(assetId)
    if not self.existingAssetMap[assetId] then
        MsgBoxManager.Instance:ShowTips(TI18N("请先购买资产"))
        return 
    end
    self.assetId = assetId

    local curMapId = Fight.Instance:GetFightMap()
    local cfg = AssetPurchaseConfig.GetAssetConfigById(assetId)
    local mapId = cfg.enter_trans_map_id
    local MapPos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(cfg.enter_position_id, cfg.enter_position[2],
        cfg.enter_position[1])

    BehaviorFunctions.Transport(mapId, MapPos.x, MapPos.y, MapPos.z)
    mod.WorldMapCtrl:CacheTpRotation(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW)
    EventMgr.Instance:Fire(EventName.EnterAsset, assetId)
end

function AssetPurchaseCtrl:LeaveAsset(assetId)
    self.assetId = nil

    local cfg = AssetPurchaseConfig.GetAssetConfigById(assetId)
    local curMapId = Fight.Instance:GetFightMap()
    local mapId = cfg.exit_trans_map_id
    local MapPos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(cfg.exit_trans_position_id,
        cfg.exit_trans_position[2], cfg.exit_trans_position[1])
    BehaviorFunctions.Transport(mapId, MapPos.x, MapPos.y, MapPos.z)
    mod.WorldMapCtrl:CacheTpRotation(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW)
    EventMgr.Instance:Fire(EventName.ExitAsset, assetId)
end

function AssetPurchaseCtrl.JumpToAssetInfo(assertId, needBlurBack)
    WindowManager.Instance:OpenWindow(AssetPurchaseMainWindow, {
        jumpAssetId = assertId,
        needBlurBack = needBlurBack
    })
end

function AssetPurchaseCtrl:UpdateAssetFoodList(assetId, deviceUniqueId, foodList)
    if not self.existingAssetMap[assetId] then
        return
    end

    if self.existingAssetMap[assetId].decoration_list[deviceUniqueId] then
        self.existingAssetMap[assetId].decoration_list[deviceUniqueId].work_info.food_list = foodList
    end
end
