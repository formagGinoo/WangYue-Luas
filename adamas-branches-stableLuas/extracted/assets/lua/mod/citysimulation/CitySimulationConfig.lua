CitySimulationConfig = CitySimulationConfig or {}

local CityOperateCommonConfig = Config.DataCityOperateCommon.Find   -- 模块Icon信息
local CityOperateEntrustShowConfig = Config.DataCityOperateEntrustShow.Find  -- 委托入口展示信息
local CityOperateMainConfig = Config.DataCityOperateMain.Find   -- 店铺列表展示信息
local CityOperateTagConfig = Config.DataCityOperateTag.Find     -- 店铺传送点信息
local CityOperateUpConfig = Config.DataCityOperateUp.Find       --
local StoreEntrustMainConfig = Config.DataStoreEntrustMain.Find
local StoreEntrustDuplicate = Config.DataStoreEntrustDuplicate.Find
local SystemDuplicateMainConfig = Config.DataSystemDuplicateMain.Find
local ShowMonsterIconConfig = Config.DataShowMonster.Find
local StoreEntrustLevelConfig = Config.DataStoreEntrustLevel.Find
local ShowElementConfig = Config.DataShowElement.Find
local ShowMonsterConfig = Config.DataShowMonster.Find

-- 获取满足开启条件的店铺位置列表 -> city_operate_tag
function CitySimulationConfig:GetShopPositionList()
    local result = {}
    local index = 1

    for _, data in pairs(CityOperateTagConfig) do
        local check = Fight.Instance.conditionManager:CheckConditionByConfig(data.conditon)
        if check then 
            result[index] = data
            index = index + 1
        end
    end
    
    return self:SortTableByKey(result, true)
end 

-- 获取店铺基础信息 -> city_operate_tag
function CitySimulationConfig:GetCityOperateTagData(_index)
    return CityOperateTagConfig[_index]
end

-- 获取店铺紧急委托信息 -> city_operate_main
function CitySimulationConfig:GetCityOperateMainData(_shopID)
    return CityOperateMainConfig[_shopID]
end

-- 获取委托描述信息 -> store_entrust_main
function CitySimulationConfig:GetStoreEntrustMainData(_entrustmentID)
    return StoreEntrustMainConfig[_entrustmentID]
end

-- 获取店铺等级提升相关信息 -> data_city_operate_up
function CitySimulationConfig:GetCityOperateUpData(_shopID, _level)
    local key = _shopID .. "_" .. _level
    local data = CityOperateUpConfig[key]

    return data
end

-- 获取委托位置信息列表 -> city_operate_entrust_show
function CitySimulationConfig:GetEntrustmentPositionList()
    return self:SortTableByKey(CityOperateEntrustShowConfig, true)
end

-- 获取普通委托列表 -> store_entrust_main
function CitySimulationConfig:GetCommonEntrustmentJumpInfoByShopID(_shopID)
    local entrustmentIDList = {}
    
    for k, v in pairs(StoreEntrustMainConfig) do
        if v.store_id == _shopID and v.entrust_type == 1 then
            table.insert(entrustmentIDList, k)
        end
    end
    
    table.sort(entrustmentIDList, function(a, b) return a < b end)

    local result = {}
    local num = 1
    for i = 1, #entrustmentIDList do
        for _, v in pairs(CityOperateEntrustShowConfig) do
            if entrustmentIDList[i] == v.entrust_id then
                result[num] = v
                num = num + 1
            end
        end
    end
    
    return result
end

-- 获取普通委托列表 -> store_entrust_main
function CitySimulationConfig:GetCommonEntrustmentDescInfoByShopID(_shopID)
    local entrustmentList = {}
    
    for k, v in pairs(StoreEntrustMainConfig) do
        if v.store_id == _shopID and v.entrust_type == 1 then
            entrustmentList[k] = v
        end
    end
    
    return entrustmentList
end

-- 获取委托副本信息 -> {entrust_id = 1001101, entrust_level = 1, ..}
function CitySimulationConfig:GetEntrustmentDuplicateInfoByID(_id, _level, _rewardLevel)
    local key = _id .. "_" .. _level .. "_" .. _rewardLevel
    local result = {}

    if StoreEntrustDuplicate[key] then
        result =  StoreEntrustDuplicate[key]
    end
    
    return result
end

-- 获取副本敌人信息 -> {{.. show_element_id = int[3], show_monster_id = int[3]},...}
function CitySimulationConfig:GetDuplicateEnemyInfoByID(_entrustmentID, _entrustmentLevel)
    local id = _entrustmentID .. "0" .. _entrustmentLevel
    id = tonumber(id)

    local data = SystemDuplicateMainConfig[id]
    
    return data
end

-- 获取评级解锁条件和显示奖励 -> {{.. condition = 250101, entrust_tag_id = {101, 102, 103, 0, 0}}
function CitySimulationConfig:GetEntrustmentLevelInfoByShopID(_shopID)
    local result = {}

    for _, value in pairs(StoreEntrustLevelConfig) do
        if value.store_id == _shopID then
            table.insert(result, value)
        end
    end
    
    -- 升序排序
    table.sort(result, function(a, b ) 
        return a.entrust_level < b.entrust_level
    end)
    
    return result
end

function CitySimulationConfig:GetGoldIconID()
    return CityOperateCommonConfig["GoldIcon"].int_val
end

function CitySimulationConfig:GetVITIconID()
    return CityOperateCommonConfig["VITIcon"].int_val
end

function CitySimulationConfig:GetElementIconPath(_id)
    return ShowElementConfig[_id].icon
end

function CitySimulationConfig:GetMonsterIconPath(_id)
    return ShowMonsterConfig[_id].icon
end

function CitySimulationConfig:GetEnemyIconInfoByID(_monsterID)
    return ShowMonsterIconConfig[_monsterID]
end

-- 按照Key值大小给字典排序, Key为number
function CitySimulationConfig:SortTableByKey(_table, _isAscending)
    local keys = {}
    for k, v in pairs(_table) do
        table.insert(keys,k)
    end

    if _isAscending then
        -- 对key进行升序
        table.sort(keys,function(a,b) return (a < b) end)
    else
        --对key进行降序
        table.sort(keys,function(a,b) return (a > b) end)
    end
    
    -- 结果数据
    local result = { }
    for i = 1, #keys do
        result[keys[i]] = _table[keys[i]]
    end
    
    return result
end

