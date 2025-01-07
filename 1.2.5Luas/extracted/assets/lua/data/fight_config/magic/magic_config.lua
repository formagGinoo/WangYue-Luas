MagicConfig = MagicConfig or {}

local magicConfigMap = {}
local buffConfigMap = {}

function MagicConfig.GetMagic(id, entityId, kind, parentInstanceId)
	if not id then
		return
	end

	local kindId = entityId
	if kind then
		kindId = FightEnum.MagicConfigName[kind]
	end

	if kindId and magicConfigMap[kindId] then
		if magicConfigMap[kindId][id] then
			return magicConfigMap[kindId][id]
		end
	else
		magicConfigMap[kindId] = {}
	end

	local config = Config["Magic"..kindId]
	if not config then
		if parentInstanceId then
			local entity = BehaviorFunctions.GetEntity(parentInstanceId)
			local instanceId
			if entity.owner and entity.owner.instanceId ~= parentInstanceId then
				instanceId = entity.owner.instanceId
			end
			return MagicConfig.GetMagic(id, entity.entityId, kind, instanceId)
		end
		LogError("can't find magic config file name = Magic"..kindId)
		return
	end

	local needFindInComm = true
	for k, v in pairs(config.Magics) do
		magicConfigMap[kindId][k] = v
		if k == id then
			needFindInComm = false
			break
		end
	end

	if needFindInComm then
		if parentInstanceId then
			local entity = BehaviorFunctions.GetEntity(parentInstanceId)
			local instanceId
			if entity.owner and entity.owner.instanceId ~= parentInstanceId then
				instanceId = entity.owner.instanceId
			end
			return MagicConfig.GetMagic(id, entity.entityId, kind, instanceId)
		elseif not kind then
			for k, v in pairs(FightEnum.MagicConfigFormType) do
				if MagicConfig.GetMagic(id, nil, v) then
					return MagicConfig.GetMagic(id, nil, v)
				end
			end
		end
	end

	return magicConfigMap[kindId][id]
end

function MagicConfig.GetBuff(id, entityId, kind, parentInstanceId)
	if not id then
		return
	end

	local kindId = entityId
	if kind then
		kindId = FightEnum.MagicConfigName[kind]
	end

	if kindId and buffConfigMap[kindId] then
		if buffConfigMap[kindId][id] then
			return buffConfigMap[kindId][id]
		end
	else
		buffConfigMap[kindId] = {}
	end

	local config = Config["Magic"..kindId]
	if not config then
		if parentInstanceId then
			local entity = BehaviorFunctions.GetEntity(parentInstanceId)
			local instanceId
			if entity.owner and entity.owner.instanceId ~= parentInstanceId then
				instanceId = entity.owner.instanceId
			end
			return MagicConfig.GetBuff(id, entity.entityId, kind, instanceId)
		end
		LogError("can't find magic config file name = Magic"..kindId)
		return
	end

	local needFindInComm = true
	for k, v in pairs(config.Buffs) do
		buffConfigMap[kindId][k] = v
		if k == id then
			needFindInComm = false
			break
		end
	end

	if needFindInComm then
		if parentInstanceId then
			local entity = BehaviorFunctions.GetEntity(parentInstanceId)
			local instanceId
			if entity.owner and entity.owner.instanceId ~= parentInstanceId then
				instanceId = entity.owner.instanceId
			end
			return MagicConfig.GetBuff(id, entity.entityId, kind, instanceId)
		elseif not kind then
			for k, v in pairs(FightEnum.MagicConfigFormType) do
				if MagicConfig.GetBuff(id, nil, v) then
					return MagicConfig.GetBuff(id, nil, v)
				end
			end
		end
	end

	return buffConfigMap[kindId][id]
end
