WorldMapTipConfig = {}

local DataMap = Config.DataMap.data_map
local DataArea = Config.DataMap.data_map_area
local DataMapTipsMain = Config.DataMapTipsMain.Find
local DataMapTipsMainById = Config.DataMapTipsMain.GroupingByTwo
local DataMapTipsType = Config.DataMapTipsType.Find

local DataMapLegendType = Config.DataMapLegendType.Find
local DataMapLegendMain = Config.DataMapLegendMain.Find

WorldMapTipConfig.MapTipType = {
    MapTipLevelEvent = 1, --随机事件
    MapTipEco = 2, --生态
    MapTipNpcEntity = 3, --Npc实体
    MapTipTask = 4, --任务
}

function WorldMapTipConfig.GetMapTipCfgByMapIdAndAreaId(mapId, AreaId)
    if not DataMapTipsMainById[mapId] then
        return 
    end
    return DataMapTipsMainById[mapId][AreaId]
end

function WorldMapTipConfig.GetMapTipCfg(tipId)
    return DataMapTipsMain[tipId]
end

function WorldMapTipConfig.GetMapCfg(mapId)
    return DataMap[mapId]
end

function WorldMapTipConfig.GetMapAreaCfg(areaId, mapId)
    local key = UtilsBase.GetDoubleKeys(areaId, mapId)
    return DataArea[key]
end

function WorldMapTipConfig.GetDataMapTipsType(tipsId)
    return DataMapTipsType[tipsId]
end

function WorldMapTipConfig.GetLegendName(type)
    return DataMapLegendType[type].name
end

function WorldMapTipConfig.GetLegendConfig(id)
    return DataMapLegendMain[id]
end

function WorldMapTipConfig.GetAllLegendConfig()
    return DataMapLegendMain
end