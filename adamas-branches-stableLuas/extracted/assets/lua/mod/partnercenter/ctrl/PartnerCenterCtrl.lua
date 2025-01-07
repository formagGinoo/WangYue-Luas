PartnerCenterCtrl = BaseClass("PartnerCenterCtrl", Controller)

function PartnerCenterCtrl:__init()
    self.unrealPartnerList = {}
end

function PartnerCenterCtrl:__delete()
    self.unrealPartnerList = {}
end

-- 设置月灵到当前资产的设备中去工作(究极手逻辑)
function PartnerCenterCtrl:SetPartnerWorkInDevice(uniqueId, deviceUniqueId)
    local curAssetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    local curAssetLv = mod.AssetPurchaseCtrl:GetAssetLevel(curAssetId)
    -- 读取资产对应的物件list
    local deviceWorkInfo = mod.AssetPurchaseCtrl:GetDeviceWorkData(curAssetId, deviceUniqueId) -- 物件信息
    if not deviceWorkInfo then
        return
    end

    --如果没有设置工作内容
    if deviceWorkInfo.work_info.work_id == 0 then
        return false
    end

    local curNum = #deviceWorkInfo.work_info.partner_list
    local maxNum = AssetDeviceConfig.GetStaffNum(deviceWorkInfo.template_id, curAssetLv)

    -- 没位置了
    if curNum >= maxNum then
        -- 筛选逻辑，做替换操作(选出职业等级最低的，替换掉)
        local targetUniqueId = self:PickPartnerByCareerlv(deviceWorkInfo)
        self:ReplacePartnerWorkDevice(uniqueId, targetUniqueId)
        return true
    else
        local partner_list = TableUtils.CopyTable(deviceWorkInfo.work_info.partner_list)
        table.insert(partner_list, uniqueId)
        local id, cmd = mod.PartnerCenterFacade:SendMsg("asset_center_work_partner_set", curAssetId, deviceUniqueId,
                partner_list)
        mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
            if ERRORCODE == 0 then
                -- 更新数据
                EventMgr.Instance:Fire(EventName.OnSetPartnerWorkInDevice, curAssetId, deviceUniqueId, partner_list)
                --todo
            end
        end)
        return true
    end
end

function PartnerCenterCtrl:PickPartnerByCareerlv(deviceWorkInfo)
    local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(deviceWorkInfo.template_id)
    if not deviceCfg then
        return false
    end
    --获取设备下的佩丛list
    local partnerList = deviceWorkInfo.work_info.partner_list
    local minCareerLv
    local minPartnerUniqueId
    --选出谁的职业等级最低
    for i, partnerUniqueId in ipairs(partnerList) do
        local careerLv = mod.PartnerBagCtrl:GetPartnerCareerLvById(partnerUniqueId, deviceCfg.career)
        if not minCareerLv then
            minCareerLv = careerLv
            minPartnerUniqueId = partnerUniqueId
        else
            if careerLv < minCareerLv then
                minCareerLv = careerLv
                minPartnerUniqueId = partnerUniqueId
            end
        end
    end
   
    return minPartnerUniqueId
end

-- 设置月灵到指定资产去工作
function PartnerCenterCtrl:SetPartnerWorkInAsset(assetId, partnerList)
    local assetLev = mod.AssetPurchaseCtrl:GetAssetLevel(assetId)
    local partnerNum = PartnerCenterConfig.GetAssetPartnerLimit(assetId, assetLev)
    local assetPatnerList = mod.AssetPurchaseCtrl:GetAssetPartnerList(assetId)
    if #assetPatnerList > partnerNum then -- 超过资产人数上限了
        return false
    end
    local id, cmd = mod.PartnerCenterFacade:SendMsg("asset_center_partner_set", assetId, partnerList)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
        if ERRORCODE == 0 then
            -- 更新数据
            mod.AssetPurchaseCtrl:SetAssetPartnerList(assetId, partnerList)
            EventMgr.Instance:Fire(EventName.OnSetPartnerWorkInAsset, assetId, partnerList)
            for k, uniqueId in pairs(self.partnerInAssetChangeList) do
                EventMgr.Instance:Fire(EventName.PartnerWorkUpdate, uniqueId)
            end
        end
    end)
    return true
end

function PartnerCenterCtrl:SetAssetPartnerChangeList(list)
    self.partnerInAssetChangeList = list
end

-- 替换佩丛工作（互相交换）
function PartnerCenterCtrl:ReplacePartnerWorkDevice(uniqueId, targetUniqueId)
    local curAssetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    
    local curPartnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local targetPartnerData = mod.BagCtrl:GetPartnerData(targetUniqueId)
    local curDeviceId = curPartnerData.work_info.work_decoration_id
    local targetDeviceId = targetPartnerData.work_info.work_decoration_id
    
    --协议规则 哪个设备id不为0使用谁
    local old_decoration_id = curDeviceId ~= 0 and curDeviceId or targetDeviceId
    local new_decoration_id = curDeviceId ~= 0 and targetDeviceId or curDeviceId
    local old_partner_id = curDeviceId ~= 0 and uniqueId or targetUniqueId
    local new_partner_id = curDeviceId ~= 0 and targetUniqueId or uniqueId
    
    self:SendMessagePartnerReplaceWork(curAssetId, old_decoration_id, new_decoration_id, old_partner_id, new_partner_id)
end

-- 通过月灵列表，获取设备的生产效率(如果月灵去吃饭睡觉了 也算他在工作)
function PartnerCenterCtrl:GetProductivityByPartnerList(deviceUniqueId, partnerList)
    local deviceWorkInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(deviceUniqueId)
    local partnerNum = #partnerList
    if partnerNum == 0 then
        return 0
    end
    local productivity = 0 -- 生产效率

    -- 获得对应产物
    local productId = deviceWorkInfo.work_info.work_id
    if productId or productId == 0 then
        -- 针对1001003 这个物件 他的计算规则 需要特化逻辑
        if deviceWorkInfo.template_id == 1001003 then
            for k, v in pairs(PartnerCenterConfig.GetPartnerCenterConfig()) do
                productId = v.asset_product_id
                if not Fight.Instance.conditionManager:CheckConditionByConfig(v.condition) then
                    break
                end
            end
        end

    end
    local productCfg = PartnerCenterConfig.GetAssetDeviceProductCfg(productId)
    if not productCfg then
        return productivity
    end
    local deviceCareer = PartnerCenterConfig.GetAssetDeviceCfg(deviceWorkInfo.template_id).career
    -- 多人系数
    local multiplayer = PartnerCenterConfig.GetDataStaffTeamProgrammeCfg(productCfg.staff_team_programme, partnerNum)
    -- 当前工作数量/((x1+x2+x3)/3)*多人合作系数）
    -- 平均效率
    local averageSpeed = 0
    local totalSpeed = 0
    for i, partnerUniqueId in pairs(partnerList) do
        local workSpeed = mod.PartnerBagCtrl:GetPartnerWorkSpeed(partnerUniqueId, deviceCareer)
        totalSpeed = totalSpeed + workSpeed
    end
    averageSpeed = totalSpeed / partnerNum
    productivity = productCfg.workload / (averageSpeed * multiplayer)
    return math.floor(AssetPurchaseConfig.GetPartnerCollectTime() / productivity)
end

-- 经营算法1 设备的生产效率(如果月灵去吃饭睡觉了 也算他在工作)
function PartnerCenterCtrl:GetDeviceProductivity(deviceUniqueId, fixPartnerList, fixWorkId, isGetProductivity)
    if not deviceUniqueId or deviceUniqueId == 0 then
        return 0
    end
    local deviceWorkInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(deviceUniqueId)
    local partnerList = fixPartnerList or deviceWorkInfo.work_info.partner_list
    local partnerNum = #partnerList
    if partnerNum == 0 then
        return 0
    end

    local productivity = 0 -- 生产效率
    local workId = fixWorkId or deviceWorkInfo.work_info.work_id
    local productCfg = PartnerCenterConfig.GetAssetDeviceProductCfg(workId)
    if not productCfg then
        return productivity
    end
    local deviceCareer = PartnerCenterConfig.GetAssetDeviceCfg(deviceWorkInfo.template_id).career
    -- 多人系数
    local multiplayer = PartnerCenterConfig.GetDataStaffTeamProgrammeCfg(productCfg.staff_team_programme, partnerNum)
    -- 当前工作数量/((x1+x2+x3)/3)*多人合作系数）
    -- 平均效率
    local averageSpeed = 0
    local totalSpeed = 0
    for i, partnerUniqueId in pairs(partnerList) do
        local workSpeed = mod.PartnerBagCtrl:GetPartnerWorkSpeed(partnerUniqueId, deviceCareer)
        totalSpeed = totalSpeed + workSpeed
    end
    averageSpeed = totalSpeed / partnerNum
    productivity = productCfg.workload / (averageSpeed * multiplayer)

    if isGetProductivity then
        return productivity
    end
    
    return math.floor(AssetPurchaseConfig.GetPartnerCollectTime() / productivity)
end

-- 经营算法2 适用于材料返还
function PartnerCenterCtrl:GetMaterialReturnProductivity(assetProductId, partnerList, deviceCareer)
    local productCfg = PartnerCenterConfig.GetAssetDeviceProductCfg(assetProductId)
    if not productCfg then
        return 0
    end
    
    local productivity = 0 -- 生产效率
  
    -- 多人系数
    local multiplayer = PartnerCenterConfig.GetDataStaffTeamProgrammeCfg(productCfg.staff_team_programme, #partnerList)
    -- ((x1+x2+x3)/3)*多人合作系数）/当前工作数量
    -- 平均效率
    local averageSpeed = 0
    local totalSpeed = 0
    for i, partnerUniqueId in pairs(partnerList) do
        local workSpeed = mod.PartnerBagCtrl:GetPartnerWorkSpeed(partnerUniqueId, deviceCareer)
        totalSpeed = totalSpeed + workSpeed
    end
    averageSpeed = totalSpeed / #partnerList
    productivity = (averageSpeed * multiplayer) / productCfg.workload

    return productivity
end

-- 经营算法2 制作多个月灵球需要花费的预计时间
function PartnerCenterCtrl:GetPartnerBallProductivityTime(assetProductId, deviceId, buildNum, partnerIdList)
    -- 总时间 = 总工作量/((x1+x2+x3)/3)*多人合作系数）
    local assetProductData = PartnerCenterConfig.GetAssetDeviceProductCfg(assetProductId)
    local totalWorkload = assetProductData.workload * buildNum
    local partnerNum = #partnerIdList
    local productRatio = partnerNum
    if partnerNum > 0 then
        productRatio = PartnerCenterConfig.GetDataStaffTeamProgrammeCfg(assetProductData.staff_team_programme, partnerNum)
    end
    local deviceCareer = PartnerCenterConfig.GetAssetDeviceCfg(deviceId).career

    -- 平均效率
    local averageSpeed = 0
    local totalSpeed = 0
    for i = 1, #partnerIdList do
        local workSpeed = mod.PartnerBagCtrl:GetPartnerWorkSpeed(partnerIdList[i], deviceCareer)
        totalSpeed = totalSpeed + workSpeed
    end
    averageSpeed = totalSpeed / partnerNum

    local totalCost = totalWorkload / (averageSpeed * productRatio)

    return totalCost
end

function PartnerCenterCtrl:GetDiningTableFoodList(assetId, itemId)
    local workInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(assetId, itemId)
	
    return workInfo.food_list
end

-----------------sendMessage

function PartnerCenterCtrl:SendMessagePartnerToWorkDevice(assetId, deviceId, partnerList)
    local id, cmd = mod.PartnerCenterFacade:SendMsg("asset_center_work_partner_set", assetId, deviceId, partnerList)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
        if ERRORCODE == 0 then
            -- 更新数据
            EventMgr.Instance:Fire(EventName.OnSetPartnerWorkInDevice, assetId, deviceId, partnerList)
            mod.AssetPurchaseCtrl:SetDevicePartnerList(assetId, deviceId, partnerList)
        end
    end)
end

-- 佩丛工作替换
function PartnerCenterCtrl:SendMessagePartnerReplaceWork(asset_id, deviceUniqueId, new_deviceUniqueId, old_partner_id, new_partner_id)
    local id, cmd = mod.PartnerCenterFacade:SendMsg("asset_center_work_partner_replace", asset_id, deviceUniqueId,
        old_partner_id, new_partner_id)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
        if ERRORCODE == 0 then
            --更新数据
            mod.AssetPurchaseCtrl:ReplaceDevicePartnerList(asset_id, deviceUniqueId, new_deviceUniqueId, old_partner_id, new_partner_id)
        end
    end)
end

-- 设置餐桌食物数量
function PartnerCenterCtrl:SetDiningTableItemNum(assetId, uniqueId, foodList)
    local orderId, protoId = mod.PartnerCenterFacade:SendMsg("asset_center_food_set", assetId, uniqueId, foodList)

    mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function(noticeCode)
        if noticeCode == 0 then
            MsgBoxManager.Instance:ShowTips(TI18N("月灵食物已添加完毕"))
            
            mod.AssetPurchaseCtrl:UpdateAssetFoodList(assetId, uniqueId, foodList)

            EventMgr.Instance:Fire(EventName.UpdateDiningTableItemNum, foodList)
        else
            LogError("协议发送失败: ", noticeCode)
        end
    end)
end

-- 设置物件工作
function PartnerCenterCtrl:SendMessageAssetCenterWorkSet(asset_id, decoration_id, partner_list, work_id, work_amount,
    product_id)
    local orderId, protoId = mod.PartnerCenterFacade:SendMsg("asset_center_work_set", asset_id, decoration_id,
        partner_list, work_id, work_amount, product_id)

    mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function(noticeCode)
        if noticeCode == 0 then
            MsgBoxManager.Instance:ShowTips("成功发布任务")

            -- 更新本地数据: assetId, uniqueId, partner_list, work_id, work_amount, product_id, finish_amount
            mod.AssetPurchaseCtrl:SetDeviceWorkInfo(asset_id, decoration_id, partner_list, work_id, work_amount,
                product_id, 0)

            EventMgr.Instance:Fire(EventName.SetPartnerBallWindowState)
        else
            LogError("协议发送失败: ", noticeCode)
        end
    end)
end

-- 取消物件产物
function PartnerCenterCtrl:SendMessageAssetCenterWorkCancel(asset_id, decoration_id)
    local orderId, protoId = mod.PartnerCenterFacade:SendMsg("asset_center_work_cancel", asset_id, decoration_id)

    mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function(noticeCode)
        if noticeCode == 0 then
            -- 更新本地数据: assetId, uniqueId, partner_list, work_id, work_amount, product_id, finish_amount
            local partnerList = mod.AssetPurchaseCtrl:GetPartnerBallPartnerList(asset_id, decoration_id)
            
            mod.AssetPurchaseCtrl:SetDeviceWorkInfo(asset_id, decoration_id, partnerList, 0, 0, 0, 0)
            
            -- 移除收集产物的触发器
            EventMgr.Instance:Fire(EventName.RemoveDeviceInteract, decoration_id)

            EventMgr.Instance:Fire(EventName.SetPartnerBallWindowState)
        else
            LogError("协议发送失败: ", noticeCode)
        end
    end)
end

-- 获取物件产物
function PartnerCenterCtrl:SendMessageAssetCenterWorkFetch(asset_id, decoration_id)
    local orderId, protoId = mod.PartnerCenterFacade:SendMsg("asset_center_work_fetch", asset_id, decoration_id)

    mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function(noticeCode)
        if noticeCode == 0 then
            local workInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(asset_id, decoration_id)

            -- 更新本地数据: assetId, uniqueId, partner_list, work_id, work_amount, product_id, finish_amount
            mod.AssetPurchaseCtrl:SetDeviceWorkInfo(asset_id, decoration_id, workInfo.partner_list, workInfo.work_id,
                workInfo.work_amount - workInfo.finish_amount, workInfo.product_id, 0)
            -- 移除收集产物的触发器
            EventMgr.Instance:Fire(EventName.RemoveDeviceInteract, decoration_id)
            
            EventMgr.Instance:Fire(EventName.SetPartnerBallWindowState)
        else
            LogError("协议发送失败: ", noticeCode)
        end
    end)
end

function PartnerCenterCtrl:SetUnrealPartner(partnerUniqueId)
    self.unrealPartnerList[partnerUniqueId] = true
end

function PartnerCenterCtrl:ClearUnrealPartnerList()
    TableUtils.ClearTable(self.unrealPartnerList)
end

function PartnerCenterCtrl:CanWorkPartnerList(assetId, devicesId)
    local partnerList = {}
    local assetPartnerList = {}

    -- 要求符合职业，不在unreal表中
    local career = AssetPurchaseConfig.GetAssetDeviceInfoById(devicesId).career
    for i, v in ipairs(mod.AssetPurchaseCtrl:GetExistingAssetInfo()[assetId].partner_list) do
        if mod.PartnerBagCtrl:CheckPartnerIsHaveCareer(v, career) and 
            not self.unrealPartnerList[v] then
            -- partnerList[v] = v
            table.insert(partnerList, v)
        end
    end

    table.sort(partnerList, function(a, b)
        local templateA = mod.BagCtrl:GetPartnerData(a).template_id
        local templateB = mod.BagCtrl:GetPartnerData(b).template_id
        local partnerWorkConfigA = PartnerBagConfig.GetPartnerWorkConfig(templateA)
        local partnerWorkConfigB = PartnerBagConfig.GetPartnerWorkConfig(templateB)
        local careerLevelA = 0
        local careerLevelB = 0
        for k, v in pairs(partnerWorkConfigA.career) do
            if v[1] == career then
                careerLevelA = math.max(careerLevelA, v[2])
            end
        end
        for k, v in pairs(partnerWorkConfigB.career) do
            if v[1] == career then
                careerLevelB = math.max(careerLevelB, v[2])
            end
        end

        return careerLevelA > careerLevelB
    end)
    return partnerList
end

function PartnerCenterCtrl:GetCanWorkBestPartner(assetId, devicesId)
    local partnerList = {}
    local assetPartnerList = {}

    -- 要求符合职业，不在unreal表中
    local career = AssetPurchaseConfig.GetAssetDeviceInfoById(devicesId).career
    for i, v in ipairs(mod.AssetPurchaseCtrl:GetExistingAssetInfo()[assetId].partner_list) do
        if mod.PartnerBagCtrl:CheckPartnerIsHaveCareer(v, career) and 
            not self.unrealPartnerList[v] then
            table.insert(partnerList, v)
        end
    end
    table.sort(partnerList, function(a, b)
        local partnerWorkConfigA = PartnerBagConfig.GetPartnerWorkConfig(mod.BagCtrl:GetPartnerData(a).template_id)
        local partnerWorkConfigB = PartnerBagConfig.GetPartnerWorkConfig(mod.BagCtrl:GetPartnerData(b).template_id)
        local careerLevelA = 0
        local careerLevelB = 0
        for k, v in pairs(partnerWorkConfigA.career) do
            if v[1] == career then
                careerLevelA = math.max(careerLevelA, v[2])
            end
        end
        for k, v in pairs(partnerWorkConfigB.career) do
            if v[1] == career then
                careerLevelB = math.max(careerLevelB, v[2])
            end
        end

        return careerLevelA > careerLevelB
    end)

    return partnerList and partnerList[1]
end
