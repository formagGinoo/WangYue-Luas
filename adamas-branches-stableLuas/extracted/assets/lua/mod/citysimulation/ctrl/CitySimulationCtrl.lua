CitySimulationCtrl = BaseClass("CitySimulationCtrl",Controller)

function CitySimulationCtrl:__init()
end

-- 接受协议 -> 获取店铺委托评级数据(登录获取)
function CitySimulationCtrl:RecvCityOperateInfo(data)
    self.shopEntrustmentLevelDic = {}
    self.shopMaxLevelDic = {}
    if #data.store_list == 0 then
        return
    end
    
    for i = 1, #data.store_list do
        self.shopEntrustmentLevelDic[data.store_list[i].store_id] = data.store_list[i].entrust_level
        self.shopMaxLevelDic[data.store_list[i].store_id] = data.store_list[i].max_entrust_level
    end
end 

-- 发送协议 -> 设置委托评级
function CitySimulationCtrl:SendMsg_SetEntrustmentLevel(_shopID, _entrustmentLevel, _maxEntrustmentLevel)
    local orderId, protoId = mod.CitySimulationFacade:SendMsg("city_operate_entrust_level_setting", _shopID, _entrustmentLevel, _maxEntrustmentLevel)
    
    SystemConfig.WaitProcessing(orderId, protoId, function(noticeCode)
        if noticeCode == 0 then
            -- 更新前端等级数据
            self.shopEntrustmentLevelDic[_shopID] = _entrustmentLevel
            
            -- 刷新GradePanel面板
            EventMgr.Instance:Fire(EventName.RefreshEntrustmentGradePanel, _entrustmentLevel)
            
            -- 刷新window面板
            EventMgr.Instance:Fire(EventName.RefreshEntrustmentChoiceWindow, _entrustmentLevel)
            
            -- 弹出提示
            local data = CitySimulationConfig:GetEntrustmentLevelInfoByShopID(_shopID)
            MsgBoxManager.Instance:ShowTips(TI18N("已成功变更为") .. data[_entrustmentLevel].des)
        else
            print("失败: ", noticeCode)
        end
    end)
end

-- 发送协议 -> 设置最大委托等级
function CitySimulationCtrl:SendMsg_SetMaxEntrustmentLevel(_shopID, _entrustmentLevel, _maxEntrustmentLevel)
    local orderId, protoId = mod.CitySimulationFacade:SendMsg("city_operate_entrust_level_setting", _shopID, _entrustmentLevel, _maxEntrustmentLevel)

    SystemConfig.WaitProcessing(orderId, protoId, function(noticeCode)
        if noticeCode == 0 then
            self.shopMaxLevelDic[_shopID] = _maxEntrustmentLevel
            self.shopEntrustmentLevelDic[_shopID] = _maxEntrustmentLevel
        else
            print("设置最大委托等级失败: ", noticeCode)
        end
    end)
end

-- 发送协议 -> 进入副本
function CitySimulationCtrl:SendMsg_EnterEntrustment(_shopID, _entrustmentID)
    mod.CitySimulationFacade:SendMsg("city_operate_entrust_enter", _shopID, _entrustmentID)
end 

-- 获取店铺委托评级
function CitySimulationCtrl:GetCurrEntrustmentLevel(_shopID)
    -- 获取可以达到的委托等级，如果比后端发送的最大委托等级要高，说明可能提升了世界等级，需要定位到最大等级
    local table = CitySimulationConfig:GetEntrustmentLevelInfoByShopID(_shopID)
    local maxEntrustLevel = 0;
    for i = 1, #table do
        local conditionID = table[i].conditon
        local state = Fight.Instance.conditionManager:CheckConditionByConfig(conditionID)

        if state then
            maxEntrustLevel = table[i].entrust_level > maxEntrustLevel and table[i].entrust_level or maxEntrustLevel;      -- 防止不是顺序遍历
        end
    end

    local maxLevelFromBackend = self.shopMaxLevelDic[_shopID] or 0;
    if maxEntrustLevel > maxLevelFromBackend then
        -- 向后端发送数据更新最大等级
        self:SendMsg_SetMaxEntrustmentLevel(_shopID, maxEntrustLevel, maxEntrustLevel)

        return maxEntrustLevel
    end
    
    if self.shopEntrustmentLevelDic and self.shopEntrustmentLevelDic[_shopID] then
        return self.shopEntrustmentLevelDic[_shopID]
    end

    -- 没有数据时，根据配置表，默认评级为1
    return 1
end

-- 获取店铺职员信息
function CitySimulationCtrl:GetShopEmployeeList(_shopID)
    
end

-- 获取店铺当前等级
function CitySimulationCtrl:GetShopLevel(_shopID)
    return 1       -- todo 临时测试数据,需要从后端获取
end
