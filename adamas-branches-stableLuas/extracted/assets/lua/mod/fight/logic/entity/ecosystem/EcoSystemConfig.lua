EcoSystemConfig = EcoSystemConfig or {}

local DataEcosystem = Config.DataEcosystem
local ecoEntityConfigs = {
    [FightEnum.EcoEntityType.Transport] = Config.DataEcosystem.data_eco_system_grid_transport_index,
    [FightEnum.EcoEntityType.Gear] = Config.DataEcosystem.data_eco_system_grid_object_index,
    [FightEnum.EcoEntityType.Monster] = Config.DataEcosystem.data_eco_system_grid_monster_index,
    [FightEnum.EcoEntityType.Collect] = Config.DataEcosystem.data_eco_system_grid_collect_index,
    [FightEnum.EcoEntityType.Npc] = Config.DataNpcEntity.data_eco_system_grid_npc_index,
}

local EcoEntityTypePrefix = {
    [FightEnum.EcoEntityType.Transport] = "data_eco_system_grid_transport_",
    [FightEnum.EcoEntityType.Gear] = "data_eco_system_grid_object_",
    [FightEnum.EcoEntityType.Monster] = "data_eco_system_grid_monster_",
    [FightEnum.EcoEntityType.Collect] = "data_eco_system_grid_collect_",
    [FightEnum.EcoEntityType.Npc] = "data_eco_system_grid_npc_",
}

local EcoEntityTypeFilePrefix = {
    [FightEnum.EcoEntityType.Transport] = "DataEcoSystemGridTransport",
    [FightEnum.EcoEntityType.Gear] = "DataEcoSystemGridObject",
    [FightEnum.EcoEntityType.Monster] = "DataEcoSystemGridMonster",
    [FightEnum.EcoEntityType.Collect] = "DataEcoSystemGridCollect",
    [FightEnum.EcoEntityType.Npc] = "DataEcoSystemGridNpc",
}

local EcoSystemJumpCache = {}
function EcoSystemConfig.GetEcoConfig(ecoId)
    for k, v in pairs(ecoEntityConfigs) do
        if v[ecoId] then
            local fileIndex, tableIndex = v[ecoId][1],v[ecoId][2]
            local config1 =  Config[EcoEntityTypeFilePrefix[k] .. fileIndex]
            if not config1 then
                LogError("生态配置未找到,请检查map_grid文件夹是否及时提交 ,ecoId = " .. ecoId)
                return
            end
            local config2 = config1[EcoEntityTypePrefix[k] .. tableIndex]
			if config2 then
				return config2[ecoId], k
			else
				LogError("生态配置网格找不到,请检查,ecoId = ".. ecoId)
			end
            
        end
    end
end

local ecoSystemJumpName = {
    "data_eco_system_grid_object_jump_system",
    "data_eco_system_grid_monster_jump_system",
    "data_eco_system_grid_transport_jump_system",
    "data_eco_system_grid_collect_jump_system",
}


function EcoSystemConfig.GetEcosystemMark(mapId)
    if EcoSystemJumpCache[mapId] then
        return EcoSystemJumpCache[mapId]
    end
    EcoSystemJumpCache[mapId] = {}
    for _, name in pairs(ecoSystemJumpName) do
        if DataEcosystem[name] and DataEcosystem[name][mapId] then
            for i, v in pairs(DataEcosystem[name][mapId]) do
                EcoSystemJumpCache[mapId][i] = v
            end
        end
    end

    return EcoSystemJumpCache[mapId]
end

function EcoSystemConfig.GetNPCMark(mapId)
    return Config.DataNpcEntity.data_eco_system_grid_npc_jump_system[mapId] or {}
end

local _day2Second
local _ActiveTimeCache = {}
EcoSystemConfig.WaitTime = 3
function EcoSystemConfig.GetEcoActiveTime(cfg)
    if not cfg then return {} end
    local id = cfg.id
    if _ActiveTimeCache[id] then
        return _ActiveTimeCache[id]
    end
    local timeArea = {}
    if cfg.activity_time and next(cfg.activity_time) then
        for k, v in pairs(cfg.activity_time) do
            local key = "DayNightTime_" .. v
            local cv = SystemConfig.GetCommonValue(key)
            local startTime = cv.int_val
            local endTime = cv.int_val2
            if startTime > endTime then
                table.insert(timeArea,  {startTime = startTime, endTime = 24 * 60 - 1})
                table.insert(timeArea,  {startTime = 0, endTime = endTime})
            else
                table.insert(timeArea,  {startTime = startTime, endTime = endTime})
            end
        end
        --LogTable("timeArea"..id, timeArea)
        _ActiveTimeCache[id] = timeArea
    end
    return timeArea
end
