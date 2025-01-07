MapPositionConfig = MapPositionConfig or {}

local MapPositionConfigMap = {}
local MapAreaBoundsInfo = {}
local MapAreaEdgeInfo = {}
local InRoomPosInfo = {}
local MAP_AREA_TYPE = {
	Block = 0,
	Small = 1,
	Mid = 2,
	Big = 3,
	Mercenary = 4,
	Bgm = 5, 
}

function MapPositionConfig.GetMapPositionData(id)
	if not id then
		return
	end

	if MapPositionConfigMap[id] then
		return MapPositionConfigMap[id]
	end

	local fileName = "MapPosition"..id
	local config = Config[fileName]
	if not config then
		return
	end
	
	MapPositionConfigMap[id] = config

	return MapPositionConfigMap[id]
end

function MapPositionConfig.GetAreaBoundsInfo(areaType, areaId, mapId)
	local name
	if areaType == MAP_AREA_TYPE.Mid then
		name = string.format("MidArea_%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Block then
		name = string.format("BlockArea__%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Small then
		name = string.format("SmallArea_%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Mercenary then
		name = string.format("Mercenary_%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Bgm then
		name = string.format("BgmArea_%s_%s", areaId, mapId)
	end

	local cfg = MapPositionConfig.DoGetAreaBoundsInfo(name)
	return cfg
end

function MapPositionConfig.DoGetAreaBoundsInfo(name)
	if MapAreaBoundsInfo and next(MapAreaBoundsInfo) then
		return MapAreaBoundsInfo[name]
	end

	local config = Config["AreaBoundsInfo"]
	if not config then
		return
	end

	MapAreaBoundsInfo = config

	return MapAreaBoundsInfo[name]
end

function MapPositionConfig.GetAreaEdgeInfo(areaType, areaId, mapId)
	local name
	if areaType == MAP_AREA_TYPE.Mid then
		name = string.format("MidArea_%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Block then
		name = string.format("BlockArea__%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Small then
		name = string.format("SmallArea_%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Mercenary then
		name = string.format("Mercenary_%s_%s", areaId, mapId)
	elseif areaType == MAP_AREA_TYPE.Bgm then
		name = string.format("BgmArea_%s_%s", areaId, mapId)
	end

	local cfg = MapPositionConfig.DoGetAreaEdgeInfo(name)
	return cfg
end

function MapPositionConfig.DoGetAreaEdgeInfo(name)
	if MapAreaEdgeInfo and next(MapAreaEdgeInfo) then
		return MapAreaEdgeInfo[name]
	end

	local config = Config["AreaEdgeInfo"]
	if not config then
		return
	end

	MapAreaEdgeInfo = config

	return MapAreaEdgeInfo[name]
end

function MapPositionConfig.GetBgmAreaInfo()
	local config = Config["BgmAreaInfo"]
	if not config then
		return
	end
	return config     
end

function MapPositionConfig.GetInRoomPosition(id)
	if InRoomPosInfo and InRoomPosInfo[id] then
		return InRoomPosInfo[id]
	end

	local name = "InroomPosition"..id
	local config = Config[name]
	if not config then
		return
	end

	InRoomPosInfo[id] = config

	return config
end