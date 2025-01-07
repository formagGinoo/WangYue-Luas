EcosystemEntityManager = BaseClass("EcosystemEntityManager")
local _floor = math.floor

local DataDrop = Config.DataDropBase.Find
local HitTime = 10

function EcosystemEntityManager:__init(fight, entityManager)
    self.fight = fight
    self.entityManager = entityManager

    self.sysEntityMap = {}
	self.sysEntityGroup = {}
	self.sysEntityRefreshList = {}
	self.dropEntityRemoveList = {}
    self.ecoEntityRecordByMap = {}

	-- 保存的掉落物 服务器缓存 考虑切地图 所以存下来
	self.dropList = {}
	self.waitRemoveList = {}
	self.sysEntityStateRecord = {}
	self.sysEntityCreateState = {}

	-- 佣兵实体列表
	self.mercenaryEcoMap = {}

	self.entityHitRecordMap = {}
end

function EcosystemEntityManager:StartFight()
    self.ecoEntityConfigs = {
		[FightEnum.EcoEntityType.Transport] = Config.DataEcosystem.data_entity_transport,
		[FightEnum.EcoEntityType.Gear] = Config.DataEcosystem.data_entity_object,
		[FightEnum.EcoEntityType.Monster] = Config.DataEcosystem.data_entity_monster,
		[FightEnum.EcoEntityType.Collect] = Config.DataEcosystem.data_entity_collect
	}

	self.ecoEntityGroupConfigs = {
		[FightEnum.EcoEntityType.Transport] = Config.DataEcosystem.data_entity_transport_FindbyGroup,
		[FightEnum.EcoEntityType.Gear] = Config.DataEcosystem.data_entity_object_FindbyGroup,
		[FightEnum.EcoEntityType.Monster] = Config.DataEcosystem.data_entity_monster_FindbyGroup,
		[FightEnum.EcoEntityType.Collect] = Config.DataEcosystem.data_entity_collect_FindbyGroup
	}

    self:GroupConfigByMap()

	EventMgr.Instance:AddListener(EventName.EntityHit, self:ToFunc("EntityHit"))
	EventMgr.Instance:AddListener(EventName.EntityHitEnd, self:ToFunc("EntityHitEnd"))
end

-- 实体刷新倒计时/掉落物消失倒计时
function EcosystemEntityManager:Update()
    local curTime = os.time()
    for k, v in pairs(self.sysEntityRefreshList) do
        local ecoCfg, ecoCfgType = self:GetEcoEntityConfig(v.id)
        if v.reborn_time <= curTime and (v.reborn_time ~= -1 or ecoCfgType == FightEnum.EcoEntityType.Transport) then
            self.entityManager:CreateSysEntityCtrl(ecoCfg, FightEnum.CreateEntityType.Ecosystem)
            self.sysEntityRefreshList[k] = nil
        end
    end

	for k, v in pairs(self.dropEntityRemoveList) do
		if v < curTime then
			self.entityManager:RemoveEntity(self.sysEntityMap[k].instanceId,true)
		end
	end

	self:CheckForceRemoveEntity()
end

-- 根据地图划分生态配置
-- TODO 后续修改为按照空间（九宫格）划分
function EcosystemEntityManager:GroupConfigByMap()
    for k, v in pairs(self.ecoEntityConfigs) do
		for m, n in pairs(v) do
			if not n.map_id then
				LogTable("not n.map_id", n)
			end

			if not self.ecoEntityRecordByMap[n.map_id] then
				self.ecoEntityRecordByMap[n.map_id] = {}
			end

			table.insert(self.ecoEntityRecordByMap[n.map_id], m)
		end
	end
end

-- 服务器数据代表在刷新周期内的生态实体 不生成
-- 全量数据
function EcosystemEntityManager:InitEntityBornData(data)
	self:UpdateEntityBorn(data)
	self:CreateMercenaryEntity()
	self:InitEcoEntityBorn()
end

-- 增量数据
function EcosystemEntityManager:AddEntityBornData(data)
	self:UpdateEntityBorn(data)
end

-- 更新生态待刷新列表
function EcosystemEntityManager:UpdateEntityBorn(svrData)
	local updateList = svrData.entity_born_list
	local curTime = os.time()
	for k, v in ipairs(updateList) do
		local ecoCfg, type = self:GetEcoEntityConfig(v.id)
		if ecoCfg then
			if curTime <= v.reborn_time or (v.reborn_time == -1 and type ~= FightEnum.EcoEntityType.Transport) then
				if not self.sysEntityRefreshList[v.id] then
					self.sysEntityRefreshList[v.id] = {}
				end
				self.sysEntityRefreshList[v.id] = v
			end
		else
			LogError("ecoCfg not found "..v.id)
		end
	end

	if svrData.unable_reborn_entity_list and next(svrData.unable_reborn_entity_list) then
		for k, v in pairs(svrData.unable_reborn_entity_list) do
			self.sysEntityRefreshList[v] = { reborn_time = -1, id = v }
		end
	end

	if svrData.drop_list and next(svrData.drop_list) then
		self.dropList = svrData.drop_list
	end
end

-- 初始化生态创建
function EcosystemEntityManager:InitEcoEntityBorn()
    local mapId = self.fight:GetFightMap()
	if not self.ecoEntityRecordByMap[mapId] then
		return
	end
	for k, v in ipairs(self.ecoEntityRecordByMap[mapId]) do
        if not self.sysEntityRefreshList[v] then
			local ecoCfg, ecoType = self:GetEcoEntityConfig(v)
			local createType = FightEnum.CreateEntityType.Ecosystem

			self.entityManager:CreateSysEntityCtrl(ecoCfg, createType)
        end
	end

	for i = #self.dropList, 1, -1 do
		local v = self.dropList[i]
		if self.ecoEntityRecordByMap[mapId][v.form_entity_id] then
			goto continue
		end

		self:CreateDropEntityConfig(v)
		table.remove(self.dropList, i)

		::continue::
	end

    EventMgr.Instance:Fire(EventName.EcosystemInitDone, FightEnum.CreateEntityType.Ecosystem)
end

-- 创建佣兵，和普通的实体是一样的逻辑，只是这个数据是后端同步的
function EcosystemEntityManager:CreateMercenaryEntity()
	local merCtrl = mod.MercenaryHuntCtrl
	local merList = merCtrl:GetAllMercenaryData()
	-- if TableUtils.GetTabelLen(merList) <= 0 then return end
	-- 没有服务器时间就不需要执行了
	if not TimeUtils.serverTime then return end

	local curServerTime = TimeUtils.GetCurTimestamp()
    local mapId = self.fight:GetFightMap()
	local createType = FightEnum.CreateEntityType.Mercenary
	for _, data in pairs(merList) do
		local ecoId = data.ecosystem_id
		local ecoConfig = MercenaryHuntConfig:GetMercenaryEcoConfig(ecoId)
		if not ecoConfig or ecoConfig.map_id ~= mapId then
			goto continue
		end

		if not merCtrl:CheckCreateMercenary(ecoId) or self.mercenaryEcoMap[ecoId] then
			goto continue
		end
		local bornTime = _floor(data.reborn_time / 1000)
		if bornTime ~= 0 and bornTime > curServerTime then
			goto continue
		end
		self.mercenaryEcoMap[ecoId] = true
		merCtrl:AddCreateRecord(ecoId)
		self.entityManager:CreateSysEntityCtrl(ecoConfig, createType)
	    ::continue::
	end

	EventMgr.Instance:Fire(EventName.EcosystemInitDone, FightEnum.CreateEntityType.Mercenary)
end

-- 创建生态实体 用不同的创建类型区别
function EcosystemEntityManager:CreateSysEntity(config)
	local entity
	local level
	if self.mercenaryEcoMap[config.id] then
		local mercenaryEcoCtrl = self.fight.mercenaryHuntManager:GetMercenaryCtrl(config.id)
		level = mercenaryEcoCtrl.level
	end

	local parms = {}
	parms.level = level

	local monsterCfg = Config.DataMonster.Find[config.entity_id]
	if not monsterCfg or not next(monsterCfg) then
		entity = self.entityManager:CreateEntity(config.entity_id, nil, nil, config.id, nil, parms)
	else
		entity = self.entityManager:CreateEntity(monsterCfg.entity_id, nil, monsterCfg.id, config.id, nil, parms)
	end

	local mapPos = BehaviorFunctions.GetTerrainPositionP(config.position[2], nil, config.position[1])
	if not mapPos then
		LogError("config.position null :"..config.entity_id)
		return
	end
	
	local position = mapPos
	-- 佣兵
	if self.mercenaryEcoMap[config.id] then
		local mercenaryEcoCtrl = self.fight.mercenaryHuntManager:GetMercenaryCtrl(config.id)
		if mercenaryEcoCtrl.position then
			position = mercenaryEcoCtrl.position
			position.rotX = mapPos.rotX
			position.rotY = mapPos.rotY
			position.rotZ = mapPos.rotZ
			position.rotW = mapPos.rotW
		end
	end

	local bornRadius = config.radius or 0
	local createPos = self.entityManager:GetEntityBornPos(position, bornRadius)
	entity.transformComponent:SetPosition(createPos.x, createPos.y, createPos.z)
	entity.rotateComponent:SetRotation(Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW))
	-- entity.sInstanceId = config.id

	if config.drop_id and config.drop_id ~= 0 then
		local dropCfg = DataDrop[config.drop_id]
		if dropCfg then
			entity.itemInfo = ItemConfig.GetItemConfig(dropCfg.item_id)
		end
	end

	self.sysEntityMap[entity.sInstanceId] = entity
	if config.group and next(config.group) then
		local groupId = config.group[1]
		local inGroupId = config.group[2]
		if not self.sysEntityGroup[groupId] then
			self.sysEntityGroup[groupId] = {}
		end

		entity.sGroup = groupId
		self.sysEntityGroup[groupId][inGroupId] = { ecoId = entity.sInstanceId, instanceId = entity.instanceId }
	end

	return entity
end

-- 先处理需要生成的掉落物数据
function EcosystemEntityManager:CreateDropEntityConfig(data)
	local ecoConfig = self:GetEcoEntityConfig(data.form_entity_id)
	if not ecoConfig or not next(ecoConfig) then
		LogError("掉落数据错误 form_entity_id = "..data.form_entity_id)
		return
	end

	local item = ItemConfig.GetItemConfig(data.item_template_id)
	if not item or not item.drop_entity_id or item.drop_entity_id == 0 then
		return
	end

	local fixedPos = data.position
	local position
	if fixedPos and (fixedPos.pos_x ~= 0 or fixedPos.pos_y ~= 0 or fixedPos.pos_z ~= 0) then
		position = {}
		position.x = fixedPos.pos_x / 10000
		position.y = fixedPos.pos_y / 10000
		position.z = fixedPos.pos_z / 10000
	end

	local fakeConfig = { load_radius = ecoConfig.load_radius, position = ecoConfig.position, entity_id = item.drop_entity_id, id = data.id, item = item, deadTime = data.dead_time, vecPos = position }
	self.entityManager:CreateSysEntityCtrl(fakeConfig, FightEnum.CreateEntityType.Drop)
end

-- 再创建掉落实体
function EcosystemEntityManager:CreateDropEntity(config)
	local entity = self.entityManager:CreateEntity(config.entity_id)
	local position = config.vecPos
	if not position then
		position = BehaviorFunctions.GetTerrainPositionP(config.position[2], nil, config.position[1])
	end

	local createPos = self.entityManager:GetEntityBornPos(position, 5)
	entity.transformComponent:SetPosition(createPos.x, createPos.y, createPos.z)
	entity.sInstanceId = config.id
	entity.itemInfo = config.item

	self.sysEntityMap[config.id] = entity
	self.dropEntityRemoveList[config.id] = config.deadTime

	return entity
end

function EcosystemEntityManager:RemoveSysEntity(ecoId)
	self.sysEntityMap[ecoId] = nil
	self.dropEntityRemoveList[ecoId] = nil
	local ecoCfg = self:GetEcoEntityConfig(ecoId)
	if ecoCfg and ecoCfg.group and next(ecoCfg.group) then
		local group = ecoCfg.group[1]
		local inGroupId = ecoCfg.group[2]
		self.sysEntityGroup[group][inGroupId] = nil
	end
end

function EcosystemEntityManager:GetEcoEntity(ecoId)
    return self.sysEntityMap[ecoId]
end

function EcosystemEntityManager:GetTotalEcoEntity()
	return self.sysEntityMap
end

function EcosystemEntityManager:GetEcoEntityGroup(groupId)
	return self.sysEntityGroup[groupId] or {}
end

function EcosystemEntityManager:GetEcoEntityGroupByEcoId(ecoId)
	local ecoCfg = self:GetEcoEntityConfig(ecoId)
    if not ecoCfg or not next(ecoCfg) or not ecoCfg.group or not next(ecoCfg.group) then
        return {}
    end

	return self.sysEntityGroup[ecoCfg.group[1]]
end

function EcosystemEntityManager:GetEcoEntityGroupMember(groupId, type)
	return self.ecoEntityGroupConfigs[type][groupId]
end

function EcosystemEntityManager:GetEcoEntityConfig(ecoId)
	-- 判断是否是佣兵的
	local mercenaryCfg = self:GetMercenaryEcoConfig(ecoId)
	if mercenaryCfg then
		return mercenaryCfg
	end

    for k, v in pairs(self.ecoEntityConfigs) do
		if v[ecoId] then
			return v[ecoId], k
		end
	end
end

function EcosystemEntityManager:IsMercenaryEntity(ecoId)
	return self.mercenaryEcoMap[ecoId]
end

function EcosystemEntityManager:KillMercenary(ecoId)
	self.mercenaryEcoMap[ecoId] = nil
end

function EcosystemEntityManager:GetMercenaryEcoConfig(ecoId)
	local ecoConfig = MercenaryHuntConfig:GetMercenaryEcoConfig(ecoId)
	return ecoConfig
end

function EcosystemEntityManager:GetEntityBornConfigByMap(mapId)
	return self.ecoEntityRecordByMap[mapId]
end

function EcosystemEntityManager:GetMercenaryEcoMap()
	return self.mercenaryEcoMap
end

function EcosystemEntityManager:CheckEcoEntityType(ecoId, type)
    for k, v in pairs(self.ecoEntityConfigs) do
		if v[ecoId] then
			return k == type
		end
	end

    return false
end

function EcosystemEntityManager:CheckEntityHasGroup(ecoId)
	local ecoCfg = self:GetEcoEntityConfig(ecoId)
    if not ecoCfg then
        return false
    end

	if not ecoCfg.group or not next(ecoCfg.group) then
		return false
	end

	return ecoCfg.group[1] and ecoCfg.group[1] ~= 0
end

function EcosystemEntityManager:CheckEntityEcoState(instanceId, ecoId)
	local sInstanceId = ecoId
	if not sInstanceId then
		local entity = self.entityManager:GetEntity(instanceId)
		if not entity.sInstanceId then
			return false
		end

		sInstanceId = entity.sInstanceId
	end

	local ecoCfg = self:GetEcoEntityConfig(sInstanceId)
	if not ecoCfg then
		return false
	end

	if ecoCfg.is_transport then
		return mod.WorldCtrl:CheckIsTransportPointActive(sInstanceId)
	else
		return not self.sysEntityRefreshList[sInstanceId]
	end
end

function EcosystemEntityManager:CheckEntityRemove(ecoId)
	local ecoCfg, entityType = self:GetEcoEntityConfig(ecoId)
	return entityType == FightEnum.EcoEntityType.Transport
end

function EcosystemEntityManager:SendSysEntityStateChange(ecoId, state)
	-- 判断是否有修改出生状态 对state做修改
	local createState = self.sysEntityCreateState[ecoId]
	if createState then
		state = state + 1000
	end

	local mapId = self.fight:GetFightMap()
	local stateList = { {entity_born_id = ecoId, state = state} }
	mod.WorldFacade:SendMsg("ecosystem_entity_state", mapId, stateList)
end

function EcosystemEntityManager:UpdateSysEntityState(data)
	for k, v in pairs(data.entity_state_list) do
		if v.state >= 1000 then
			self.sysEntityCreateState[v.entity_born_id] = true
		end

		self.sysEntityStateRecord[v.entity_born_id] = v.state % 1000
	end
end

function EcosystemEntityManager:GetSysEntityState(ecoId)
	if self.sysEntityStateRecord[ecoId] then
		return self.sysEntityStateRecord[ecoId] % 1000
	end

	local ecoCfg = self:GetEcoEntityConfig(ecoId)
	if not ecoCfg then
		return
	end

	return ecoCfg.state
end

function EcosystemEntityManager:SetEcoEntitySvrCreateState(ecoId, state)
	if self.sysEntityCreateState[ecoId] == state then
		return
	end

	local ecoCfg = self:GetEcoEntityConfig(ecoId)
	if not ecoCfg or not next(ecoCfg) then
		return
	end

	self.sysEntityCreateState[ecoId] = state
	local createState = ecoCfg.default_create
	if state then
		createState = not createState
	end

	local ecoState = self.sysEntityStateRecord[ecoId]
	if not ecoState then
		ecoState = 0
	end

	self:SendSysEntityStateChange(ecoId, ecoState)
	self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(ecoId, createState)
end

function EcosystemEntityManager:GetEcoEntitySvrCreateState(ecoId)
	return self.sysEntityCreateState[ecoId]
end

function EcosystemEntityManager:EntityHit(instanceId, ingoreRemove)
	local entity = self.entityManager:GetEntity(instanceId)
	local sInstanceId = entity.sInstanceId
	if not self:GetEcoEntity(sInstanceId) then
		return
	end

	local sendPos = {
		pos_x = 0,
		pos_y = 0,
		pos_z = 0,
	}

	if entity.transformComponent then
		local pos = entity.transformComponent.position
		sendPos.pos_x = math.floor(pos.x * 10000)
		sendPos.pos_y = math.floor(pos.y * 10000)
		sendPos.pos_z = math.floor(pos.z * 10000)
	end

	ingoreRemove = ingoreRemove or self:CheckEntityRemove(sInstanceId)
	if ingoreRemove then
		self.waitRemoveList[sInstanceId] = true
	else
		-- 需要直接移除的，添加交互记录
		self.entityHitRecordMap[instanceId] = {Time.realtimeSinceStartup, sInstanceId}
	end
	mod.WorldFacade:SendMsg("ecosystem_hit", sInstanceId, sendPos)
end

function EcosystemEntityManager:EntityHitEnd(data)
	if not self:GetEcoEntity(data.id) then
		return
	end
	local entity = self:GetEcoEntity(data.id)
	local isMercenary = self:IsMercenaryEntity(data.id)

	self.entityHitRecordMap[entity.instanceId] = nil

	if self.waitRemoveList and self.waitRemoveList[data.id] then
		if entity.behaviorComponent then
			entity.behaviorComponent:CallFunc("EntityHitEnd", entity.instanceId)
			self.fight.taskManager:CallBehaviorFun("EntityHitEnd", entity.instanceId)
		end

		if self.waitRemoveList[data.id] then
			self.waitRemoveList[data.id] = nil
		end
	else
		self.entityManager:RemoveEntity(entity.instanceId,true)
	end

	for _, itemInfo in pairs(data.drop_list) do
		self:CreateDropEntityConfig(itemInfo)
	end

	local ecoCfg = self:GetEcoEntityConfig(data.id)

	if ecoCfg and ecoCfg.alert_tips and ecoCfg.alert_tips ~= 0 then
		EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid,ecoCfg.alert_tips)
	end

	if isMercenary then
		self.fight.mercenaryHuntManager:KillMercenary(data.id)
	end
end

function EcosystemEntityManager:CheckForceRemoveEntity()
	if not next(self.entityHitRecordMap) then return end
	local curTime = Time.realtimeSinceStartup
	local remove = {}
	for insId, data in pairs(self.entityHitRecordMap) do
		local time = data[1]
		if curTime - time >= HitTime then
			remove[insId] = true
		end
	end

	for insId, _ in pairs(remove) do
		local data = self.entityHitRecordMap[insId]
		LogError("触发了强制移除交互角色，角色生态id = ", data[2])
		self.entityManager:RemoveEntity(insId)
		self.entityHitRecordMap[insId] = nil
	end
end

function EcosystemEntityManager:__delete()
	EventMgr.Instance:RemoveListener(EventName.EntityHit, self:ToFunc("EntityHit"))
	EventMgr.Instance:RemoveListener(EventName.EntityHitEnd, self:ToFunc("EntityHitEnd"))
end