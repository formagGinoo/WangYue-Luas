EntityConfig = EntityConfig or {}

local configMap = {}

function EntityConfig.GetEntity(id)
	if not id then
		return
	end
	
	if configMap[id] then
		return configMap[id]
	end

	local fileName = Config.EntityIdConfig[id]
	if not fileName then
		LogError("entity id fileName null "..id)
		return
	end

	local config = Config["Entity"..fileName]
	if not config then
		LogError("entity id config null "..fileName)
		return
	end

	for k, v in pairs(config) do
		configMap[k] = v
	end

	return configMap[id]
end	

function EntityConfig.GetEntityConfigId(entityId)
	return Config.EntityIdConfig[entityId]
end