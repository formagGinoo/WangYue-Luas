TrafficConfig = TrafficConfig or {}

local RoadDotConfigMap = {}
local RoadCrossConfigMap = {}
local LightConfigMap = {}

local NpcRoadDotConfigMap = {}
local NpcLightConfigMap = {}

function TrafficConfig.GetRoadDotConfig(id)
    if not id then
        return
    end

    if RoadDotConfigMap[id] then
        return RoadDotConfigMap[id]
    end

    local fileName = "Dots" .. id
    local config = Config[fileName]
    if not config then
        return
    end

    RoadDotConfigMap[id] = config

    return RoadDotConfigMap[id]
end

function TrafficConfig.GetRoadCrossConfig(id)
	if not id then
		return
	end

	if RoadCrossConfigMap[id] then
		return RoadCrossConfigMap[id]
	end

	local fileName = "Crosses" .. id
	local config = Config[fileName]
	if not config then
		return
	end

	RoadCrossConfigMap[id] = config

	return RoadCrossConfigMap[id]
end
function TrafficConfig.GetLightConfig(id)
    if not id then
        return
    end

    if LightConfigMap[id] then
        return LightConfigMap[id]
    end

    local fileName = "Lights" .. id
    local config = Config[fileName]
    if not config then
        return
    end

    LightConfigMap[id] = config

    return LightConfigMap[id]
end

function TrafficConfig.GetNpcRoadDotConfig(id)
    if not id then
        return
    end

    if NpcRoadDotConfigMap[id] then
        return NpcRoadDotConfigMap[id]
    end

    local fileName = "NpcDots" .. id
    local config = Config[fileName]
    if not config then
        return
    end

    local newConfig = {}
    newConfig.startIndex = config[1].id
    newConfig.dots = {}
    for i, v in ipairs(config) do
        newConfig.dots[v.id] = {
            id = v.id,
            pos = v.position,
            rotationY = v.rotationY,
            nextPoint = v.connectedIds,
            state = FightEnum.TrafficLightType.Green,
        }
    end

    NpcRoadDotConfigMap[id] = newConfig
    return NpcRoadDotConfigMap[id]
end

function TrafficConfig.GetNpcLightConfig(id)
    if not id then
        return
    end

    if NpcLightConfigMap[id] then
        return NpcLightConfigMap[id]
    end

    local fileName = "NpcLights" .. id
    local config = Config[fileName]
    if not config then
        return
    end

    local lights = {}
    for _, v in ipairs(config) do
        lights[v.lightid] = {
            id = v.lightid,
            state = v.state,
            controlPoints = {}
        }
        for i = 1, #v.controlList do
            for pointId, redPointIds in pairs(v.controlList[i]) do
                table.insert(lights[v.lightid].controlPoints, pointId)
                for _, redPointId in pairs(redPointIds) do
                    table.insert(lights[v.lightid].controlPoints, redPointId)
                end
            end
        end
    end
    NpcLightConfigMap[id] = lights
    return NpcLightConfigMap[id]
end