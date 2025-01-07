CitySimulationProxy = BaseClass("CitySimulationProxy",Proxy)

function CitySimulationProxy:__init()
end 

function CitySimulationProxy:__InitProxy()
    self:BindMsg("city_operate_info")
    self:BindMsg("city_operate_entrust_level_setting")
    self:BindMsg("city_operate_entrust_enter")
    self:BindMsg("city_operate_entrust_finish")
    self:BindMsg("duplicate_city_operate_finish")
end

function CitySimulationProxy:Recv_city_operate_info(data)
    mod.CitySimulationCtrl:RecvCityOperateInfo(data)
end 

function CitySimulationProxy:Send_city_operate_entrust_level_setting(_shopID, _entrustmentLevel, _maxEntrustLevel)
    return {store_id = _shopID, entrust_level = _entrustmentLevel, max_entrust_level = _maxEntrustLevel}
end 

function CitySimulationProxy:Send_city_operate_entrust_enter(_shopID, _enstructmentID, _use_hero_id_list)
    return {store_id = _shopID, entrust_id = _enstructmentID, use_hero_id_list = _use_hero_id_list}
end

function CitySimulationProxy:Send_city_operate_entrust_finish(_id, _isWin)
    return {system_duplicate_id = _id, is_win = _isWin}
end

function CitySimulationProxy:Recv_duplicate_city_operate_finish(data)
    if Fight.Instance then
        Fight.Instance.duplicateManager:RecvFinishedDuplicate(data)
    end
end 