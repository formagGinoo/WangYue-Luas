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
			if entity and entity.parent and entity.parent.instanceId ~= parentInstanceId then
				instanceId = entity.parent.instanceId
			end
			return MagicConfig.GetMagic(id, entity.entityId, kind, instanceId)
		end
	end

	local needFindInComm = true
	if config and next(config) then
		for k, v in pairs(config.Magics) do
			magicConfigMap[kindId][k] = v
			magicConfigMap[kindId][k].kindId = kindId
			if k == id then
				needFindInComm = false
				break
			end
		end
	end

	if needFindInComm then
		if parentInstanceId then
			local entity = BehaviorFunctions.GetEntity(parentInstanceId)
			local instanceId
			local parentEntityId
			if entity then
				parentEntityId = entityId
				if entity.parent and entity.parent.instanceId ~= parentInstanceId then
					instanceId = entity.parent.instanceId
				end
			end

			return MagicConfig.GetMagic(id, parentEntityId, kind, instanceId)
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
			local parentEntityId = entityId
			if entity then
				parentEntityId = entity.entityId
				if entity.parent and entity.parent.instanceId ~= parentInstanceId then
					instanceId = entity.parent.instanceId
				end
			end

			return MagicConfig.GetBuff(id, parentEntityId, kind, instanceId)
		end
	end

	local needFindInComm = true
	if config and next(config) then
		for k, v in pairs(config.Buffs) do
			buffConfigMap[kindId][k] = v
			buffConfigMap[kindId][k].kindId = kindId
			if k == id then
				needFindInComm = false
				break
			end
		end
	end

	if needFindInComm then
		if parentInstanceId then
			local entity = BehaviorFunctions.GetEntity(parentInstanceId)
			local instanceId
			if entity.parent and entity.parent.instanceId ~= parentInstanceId then
				instanceId = entity.parent.instanceId
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

--获取数值配置
function MagicConfig.GetConfig(magicId, lev, kind)
	local key = UtilsBase.GetStringKeys(magicId, lev, kind)
	return Config.DataMagic.data_magic[key]
end

function MagicConfig.GetConstConfig(magicId, kind)
	local key = UtilsBase.GetStringKeys(magicId, FightEnum.MagicConfigName[kind])
	return Config.DataMagic.data_const_magic[key]
end