LevelEventConfig = LevelEventConfig or {}

local LevelEventCfg = Config.DataLevelEvent.data_level_event

function LevelEventConfig.GetLevelEventConfig(eventId)
	local config = LevelEventCfg[eventId]
	if not config then
		return 
	end
	
	return config
end

function LevelEventConfig.GetAllLevelEventConfig()
	return LevelEventCfg
end