EcosystemEntityManager = BaseClass("EcosystemEntityManager")
local _floor = math.floor

local DataDrop = Config.DataDropBase.Find
local HitTime = 10

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

local minPosX = {-1, 1}
local minPosZ = {-1, 1}
local gridLoadState = {
    onLoad = 2,
    waitUnLoad = 3,
    UnLoad = 4,
}

function EcosystemEntityManager:__init(fight, entityManager)
    self.fight = fight
    self.entityManager = entityManager

    self.sysEntityMap = {}
	self.sysEntityGroup = {}
	self.sysEntityRefreshList = {}
	self.dropEntityRemoveList = {}
    self.ecoEntityRecordByMap = {}
	self.loadedBlock = {}
	self.ecoEntityRecordByPosIndex = {}
	self.oldCenterPos = Vec3.New(0,0,0)
	self.ImmediateUpdate = false

    self.gridMap = {
        {size = 16, data = {} },
        {size = 64, data = {} },
        {size = 128, data = {} },
        {size = 512, data = {} },
        {size = 1024, data = {} },
        {size = 0, data = {0} },
    }

	--互相索引
	self.runTimeGridList = {}
	self.runTimeEcoList = {}

	-- 保存的掉落物 服务器缓存 考虑切地图 所以存下来
	self.dropList = {}
	self.waitRemoveList = {}
	self.sysEntityStateRecord = {} -- 策划定义的默认创建状态,1-999
	self.sysEntityCreateState = {} -- 默认创建状态,true/false

	--由服务端随机的等级偏移
	self.ecoMonsterLevBias = {}
	-- 佣兵实体列表
	self.mercenaryEcoMap = {}

	self.entityHitRecordMap = {}
end

function EcosystemEntityManager:StartFight()
    self.ecoEntityConfigs = {
		[FightEnum.EcoEntityType.Transport] = Config.DataEcosystem.data_eco_system_grid_transport_index,
		[FightEnum.EcoEntityType.Gear] = Config.DataEcosystem.data_eco_system_grid_object_index,
		[FightEnum.EcoEntityType.Monster] = Config.DataEcosystem.data_eco_system_grid_monster_index,
		[FightEnum.EcoEntityType.Collect] = Config.DataEcosystem.data_eco_system_grid_collect_index,
		[FightEnum.EcoEntityType.Npc] = Config.DataNpcEntity.data_eco_system_grid_npc_index,
	}

	self.ecoEntityGroupConfigs = {
		[FightEnum.EcoEntityType.Transport] = Config.DataEcosystem.data_entity_transport_FindbyGroup,
		[FightEnum.EcoEntityType.Gear] = Config.DataEcosystem.data_entity_object_FindbyGroup,
		[FightEnum.EcoEntityType.Monster] = Config.DataEcosystem.data_entity_monster_FindbyGroup,
		[FightEnum.EcoEntityType.Collect] = Config.DataEcosystem.data_entity_collect_FindbyGroup
	}


	EventMgr.Instance:AddListener(EventName.EntityHit, self:ToFunc("EntityHit"))
	EventMgr.Instance:AddListener(EventName.EntityHitEnd, self:ToFunc("EntityHitEnd"))
end

--计算当前在每个Level要激活的格子(除了无限远的level)
function EcosystemEntityManager:CalculateGridIndexTables(pos)
    for i, v in ipairs(self.gridMap) do
		if v.size ~= 0 then
			TableUtils.ClearTable(v.data)
			local half =  v.size / 2
			for _, addX in pairs(minPosX) do
				for _, addZ in pairs(minPosZ) do
					local Index = math.floor(((pos.x + half * addX) + 100000) / v.size + v.size) * 10000 + math.floor((pos.z + half * addZ) / v.size + v.size)
					if not TableUtils.ContainValue(v.data, Index) then
						table.insert(v.data, Index)
					end
				end
			end
		end
    end
end

local _unityUtils = UnityUtils
-- 实体刷新倒计时/掉落物消失倒计时
function EcosystemEntityManager:Update()
	if DebugClientInvoke.Cache.IsDisableEcoAndCar then
		return
	end

    local curTime = os.time()
	local curCenterEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	if curCenterEntity and curCenterEntity.transformComponent then
		self:OnCenterMove(curCenterEntity.transformComponent.position)
	end
	_unityUtils.BeginSample("EcosystemEntityManager:UpdateSysEntityRefresh")
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
	_unityUtils.EndSample()
	self:CheckForceRemoveEntity()
end

--立即更新一次网格
function EcosystemEntityManager:SetImmediateUpdate()
	self.ImmediateUpdate = true
end

function EcosystemEntityManager:OnCenterMove(newPos)
	--每移动8m更新一次
	if Vec3.SquareDistanceXZ(self.oldCenterPos, newPos) < 64 and not self.ImmediateUpdate then
		return
	end
	self.ImmediateUpdate = false
	_unityUtils.BeginSample("EcosystemEntityManager:OnCenterMove")

	self.oldCenterPos:SetA(newPos)

	self:CalculateGridIndexTables(newPos)

	--标脏
    for i, v in pairs(self.ecoEntityRecordByPosIndex) do
		if v.state == gridLoadState.onLoad then
			v.state = gridLoadState.waitUnLoad
		end
    end
	local mapId = self.fight:GetFightMap()
	--加载不同层的Grid的配置
    for _, grids in pairs(self.gridMap) do
        for _, index in pairs(grids.data) do
			index = index == 0 and 1 or index
            if not self.ecoEntityRecordByPosIndex[index] or self.ecoEntityRecordByPosIndex[index].state == gridLoadState.UnLoad then
				--加载静态Grid
				self.ecoEntityRecordByPosIndex[index] = { state = gridLoadState.onLoad , ecoIds = {}}
                for type, baseFilePrefix in pairs(EcoEntityTypeFilePrefix) do
                    local config = Config[baseFilePrefix .. grids.size .. index]
                    --加载base层的配置，并找到具体的参数
                    for k, v in pairs(config and config.data or {}) do
                        local baseConfig = Config[baseFilePrefix .. v[1]]
                        local rangeConfig = baseConfig[EcoEntityTypePrefix[type] .. v[2]]
						if not rangeConfig then
							LogError("找不到生态对应的配置， ecoId = ", k)
							goto continue
						end
                        local ecoConfig = rangeConfig[k]
						if not ecoConfig then
							LogError("区域找不到生态对应的配置， ecoId = ", k)
							goto continue
						end
						--该生态位于当前地图且目前不为动态加载
						if not self.sysEntityRefreshList[ecoConfig.id] and ecoConfig.map_id == mapId and not self.runTimeEcoList[ecoConfig.id] and not self.entityManager.ecosystemCtrlManager:IsEcoHaveCtrl(ecoConfig.id) then
							local createType = type == FightEnum.EcoEntityType.Npc and FightEnum.CreateEntityType.Npc or FightEnum.CreateEntityType.Ecosystem
							self.entityManager:CreateSysEntityCtrl(ecoConfig, createType)
							table.insert(self.ecoEntityRecordByPosIndex[index].ecoIds, ecoConfig.id)
						end
						::continue::
                    end
                end
            end
			--加载动态Grid
			if self.runTimeGridList[index] then
				for k, ecoId in pairs(self.runTimeGridList[index]) do
					local ecoConfig = self:GetEcoEntityConfig(ecoId)
					--该生态位于当前地图且目前为动态加载  并且未被创建
					if not self.sysEntityRefreshList[ecoConfig.id] and ecoConfig.map_id == mapId and self.runTimeEcoList[ecoConfig.id] and not self.entityManager.ecosystemCtrlManager:IsEcoHaveCtrl(ecoId) then
						local type = self:GetEcoType(ecoId)
						local createType = type == FightEnum.EcoEntityType.Npc and FightEnum.CreateEntityType.Npc or FightEnum.CreateEntityType.Ecosystem
						self.entityManager:CreateSysEntityCtrl(ecoConfig, createType)
						table.insert(self.ecoEntityRecordByPosIndex[index].ecoIds, ecoConfig.id)
					end
				end
			end
            self.ecoEntityRecordByPosIndex[index].state = gridLoadState.onLoad
        end
    end

    --卸载
    for i, v in pairs(self.ecoEntityRecordByPosIndex) do
        if v == gridLoadState.waitUnLoad then
            --卸载生态实体
			for _, id in pairs(self.ecoEntityRecordByPosIndex[i].ecoIds) do
				self:RemoveEcoEntity(id)
			end
			--TODO 卸载配置,需要增加计数逻辑
            self.ecoEntityRecordByPosIndex[i].state = gridLoadState.UnLoad
			TableUtils.ClearTable(self.ecoEntityRecordByPosIndex[i])
        end
    end
	_unityUtils.EndSample()
end

function EcosystemEntityManager:AddRunTimeEcoData(ecoId, state, pos)
	local cfg = self:GetEcoEntityConfig(ecoId)
	if not cfg then
		LogError("找不到生态实体配置 ecoId = ", ecoId)
		return
	end
	local size = 0
	for i, v in ipairs(self.gridMap) do
		if cfg.load_radius <= v.size or v.size == 0 then
			size = v.size
			break
		end
	end
	local Index
	local position = pos
	if not position then
		local ecosystemConfig = self:GetEcoEntityConfig(ecoId)
		-- local MapPos = BehaviorFunctions.GetTerrainPositionP(ecosystemConfig.position[2], ecosystemConfig.map_id, ecosystemConfig.position[1])
		local MapPos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(ecosystemConfig.position_id, ecosystemConfig.position[2], ecosystemConfig.position[1])
		if not MapPos then
			if not ecosystemConfig.position[2] or not ecosystemConfig.position[1] then
				LogError("找不到该生态的点位信息 :ecoId = ", ecoId)
			end
			LogError("找不到生态出生点信息 :name = "..ecosystemConfig.position[2]..", belongId = "..ecosystemConfig.position[1])
			return
		end
		position = Vec3.New(MapPos.x, MapPos.y, MapPos.z)
	end
	Index = size == 0 and 1 or math.floor(((position.x) + 100000) / size + size) * 10000 + math.floor((position.z) / size + size)
	self.runTimeGridList[Index] = self.runTimeGridList[Index] or {}
	table.insert(self.runTimeGridList[Index], ecoId)
	self.runTimeEcoList[ecoId] = Index
end

function EcosystemEntityManager:RemoveRunTimeEcoData(ecoId)
	if not self.runTimeEcoList[ecoId] then
		return
	end

	for k, v in pairs(self.runTimeGridList[self.runTimeEcoList[ecoId]]) do
		if v == ecoId then
			table.remove(self.runTimeGridList[self.runTimeEcoList[ecoId]], k)
			break
		end
	end
	self.runTimeEcoList[ecoId] = nil
end

-- 服务器数据代表在刷新周期内的生态实体 不生成
-- 全量数据
function EcosystemEntityManager:InitEntityBornData(data)
	self:UpdateEntityBorn(data)
	self:CreateMercenaryEntity(true)
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

	for i = #self.dropList, 1, -1 do
		local v = self.dropList[i]
		if not self.ecoEntityRecordByMap[mapId] then
			self.ecoEntityRecordByMap[mapId] = {}
		end

		if self.ecoEntityRecordByMap[mapId][v.form_entity_id] then
			goto continue
		end

		self:CreateDropEntityConfig(v)
		table.remove(self.dropList, i)

		::continue::
	end

    EventMgr.Instance:Fire(EventName.EcosystemInitDone, FightEnum.CreateEntityType.Ecosystem)
end

--离开了原来的地块，移除生态
function EcosystemEntityManager:RemoveEcoEntity(ecoId)
	self.entityManager:RemoveEcosystemEntityByID(ecoId)
end

-- 创建佣兵，和普通的实体是一样的逻辑，只是这个数据是后端同步的
function EcosystemEntityManager:CreateMercenaryEntity(isStartCreate)
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
		if not ecoConfig then
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
		self.entityManager:CreateSysEntityCtrl(ecoConfig, createType)
		merCtrl:AddCreateRecord(ecoId)
	    ::continue::
	end

	EventMgr.Instance:Fire(EventName.EcosystemInitDone, FightEnum.CreateEntityType.Mercenary)
	if isStartCreate then
		merCtrl:UpdateMercenaryChaseEntity()
	end
end

-- 创建生态实体 用不同的创建类型区别
function EcosystemEntityManager:CreateSysEntity(config, type)
	local entity
	local level
	local subjoinLev = 0
	local deafultDropId = 0
	local monsterCfg = Config.DataMonster.Find[config.entity_id]
	if type == FightEnum.CreateEntityType.Mercenary then
		local mercenaryEcoCtrl = self.fight.mercenaryHuntManager:GetMercenaryCtrl(config.id)
		-- level = mercenaryEcoCtrl.level
		-- 佣兵等级动态获取
		local info = mod.WorldLevelCtrl:GetAdventureInfo()
		local curLv = info.lev
		local correctLv = MercenaryHuntConfig.GetMercenaryEcoCorrectLv(config.id)
		level = curLv + correctLv
	elseif type == FightEnum.CreateEntityType.Ecosystem then
		local cfg, ecoType = self:GetEcoEntityConfig(config.id)
		if ecoType == FightEnum.EcoEntityType.Monster then
			subjoinLev = self:GetEcoMonsterLevelBias(config.id)
		end
		--默认掉落id
		if ecoType == FightEnum.EcoEntityType.Transport 
		or ecoType == FightEnum.EcoEntityType.Gear 
		or ecoType == FightEnum.EcoEntityType.Collect then
			local dataEntityDrop = Config.DataEntityDrop.Find[config.entity_id]
			deafultDropId = dataEntityDrop and dataEntityDrop.drop_id or 0
		end
	end

	local parms = {}
	parms.level = level
	parms.subjoinLev = subjoinLev

	-- GM修改属性
	if config.gmCfg then
		parms.level = config.gmCfg.level or parms.level
	end
	
	if not monsterCfg or not next(monsterCfg) then
		entity = self.entityManager:CreateEntity(config.entity_id, nil, nil, config.id, nil, parms)
	else
		entity = self.entityManager:CreateEntity(monsterCfg.entity_id, nil, monsterCfg.id, config.id, nil, parms)
	end

	local position 
	-- 佣兵
	if self.mercenaryEcoMap[config.id] then
		local mercenaryEcoCtrl = self.fight.mercenaryHuntManager:GetMercenaryCtrl(config.id)
		if mercenaryEcoCtrl.position then
			position = mercenaryEcoCtrl.position
		end
	else
		-- position = BehaviorFunctions.GetTerrainPositionP(config.position[2], config.position_id, config.position[1])
		position = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(config.position_id, config.position[2], config.position[1])
		--[[if config.isGm then
			position = BehaviorFunctions.GetPositionOffsetBySelf(BehaviorFunctions.GetCtrlEntity(), 5, 0)
		else
			position = BehaviorFunctions.GetTerrainPositionP(config.position[2], config.position_id, config.position[1])
		end]]
	end

	if not position then
		LogError("config.position null :"..config.entity_id)
		return
	end
	
	local bornRadius = config.radius or 0
	local createPos = self.entityManager:GetEntityBornPos(position, bornRadius)
	local bornFlyHeight = 0
	if entity.moveComponent and entity.moveComponent.isFlyEntity then
		bornFlyHeight = entity.moveComponent.bornFlyHeight
	end
	entity.transformComponent:SetPosition(createPos.x, createPos.y + bornFlyHeight, createPos.z)
	entity.rotateComponent:SetRotation(Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW))
	if entity.clientTransformComponent.lodRes then
		local gameObject = entity.clientTransformComponent:GetGameObject()
		CustomUnityUtils.SetSceneUnityTransform(gameObject, createPos.x, createPos.y, createPos.z,
			position.rotX, position.rotY, position.rotZ, position.rotW)
	end

	if config.drop_id then
		if config.drop_id ~= 0 then
			entity.itemInfo = self:GetDropItemInfo(config.drop_id)
		elseif config.drop_id == 0 and monsterCfg and monsterCfg.drop_id then
			entity.itemInfo = self:GetDropItemInfo(monsterCfg.drop_id)
		elseif config.drop_id == 0 and deafultDropId ~= 0 then
			entity.itemInfo = self:GetDropItemInfo(deafultDropId)
		elseif config.drop_id == 0 and deafultDropId == 0 and type == FightEnum.CreateEntityType.Ecosystem then
			local cfg, ecoType = self:GetEcoEntityConfig(config.id)
			if ecoType == FightEnum.EcoEntityType.Transport or ecoType == FightEnum.EcoEntityType.Collect  then
				LogError(string.format("生态id%s没有填掉落id哦，查查看吧",config.id))
			end
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
		self.entityManager:CallBehaviorFun("CreateEcoGroupEntity", entity.sInstanceId, entity.instanceId, groupId)
	end

	return entity
end

-- 获取掉落信息
function EcosystemEntityManager:GetDropItemInfo(dropId)
	local dropCfg = DataDrop[dropId]
	if dropCfg then
		return ItemConfig.GetItemConfig(dropCfg.item_id)
	end
end

-- 先处理需要生成的掉落物数据
function EcosystemEntityManager:CreateDropEntityConfig(data)
	local ecoConfig = self:GetEcoEntityConfig(data.form_entity_id)

	local isGm = false
	if data.form_entity_id == 0 then
		ecoConfig = 
		{
			load_radius = 50,
			map_id = mod.WorldMapCtrl:GetCurMap(),
		}
		isGm = true
	end

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

	local fakeConfig = {
		load_radius = ecoConfig.load_radius,
		map_id = ecoConfig.map_id,
		position = ecoConfig.position,
		entity_id = item.drop_entity_id,
		id = data.id, item = item,
		deadTime = data.dead_time,
		vecPos = position
	}
	self.entityManager:CreateSysEntityCtrl(fakeConfig, FightEnum.CreateEntityType.Drop, nil, isGm)
end

-- 创建掉落实体
function EcosystemEntityManager:CreateDropEntity(config)
	local entity = self.entityManager:CreateEntity(config.entity_id)
	local position = config.vecPos
	if not position then
		-- position = BehaviorFunctions.GetTerrainPositionP(config.position[2], nil, config.position[1])
		position = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(config.position_id, config.position[2], config.position[1])
	end

	local createPos = self.entityManager:GetEntityBornPos(position, 5)
	entity.transformComponent:SetPosition(createPos.x, createPos.y, createPos.z)
	entity.sInstanceId = config.id
	entity.itemInfo = config.item
	entity.values["create_type"] = FightEnum.CreateEntityType.Drop

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
	if not self.ecoEntityGroupConfigs[type] then
		return
	end

	return self.ecoEntityGroupConfigs[type][groupId]
end

function EcosystemEntityManager:GetEcoEntityConfig(ecoId)
	-- 判断是否是佣兵的
	local mercenaryCfg = self:GetMercenaryEcoConfig(ecoId)
	if mercenaryCfg then
		return mercenaryCfg, FightEnum.CreateEntityType.Mercenary
	end

	for k, v in pairs(self.ecoEntityConfigs) do
		if v[ecoId] then
			local fileIndex, tableIndex = v[ecoId][1],v[ecoId][2]
			local config1 =  Config[EcoEntityTypeFilePrefix[k] .. fileIndex]
			if not config1 then
				LogError("未找到生态怪物,请检查生态配置 ecoId = ".. ecoId)
				return
			end
			local config2 = config1[EcoEntityTypePrefix[k] .. tableIndex]
			if not config2 then
				LogError("未找到生态怪物,请检查生态配置 ecoId = ".. ecoId)
				return
			end
			return config2[ecoId], k
		end
	end
end

function EcosystemEntityManager:GetEcoType(ecoId)
	for k, v in pairs(self.ecoEntityConfigs) do
		if v[ecoId] then
			return k
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
	return ecoConfig, FightEnum.CreateEntityType.Mercenary
end

function EcosystemEntityManager:GetEntityBornConfigByMap(mapId)
	return self.ecoEntityRecordByMap[mapId]
end

function EcosystemEntityManager:GetMercenaryEcoMap()
	return self.mercenaryEcoMap
end

-- 判断生态实体类型
function EcosystemEntityManager:CheckEcoEntityType(ecoId, type)
    for k, v in pairs(self.ecoEntityConfigs) do
		if v[ecoId] then
			return k == type
		end
	end

    return false
end

-- 检查生态中的实体是否有组
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

-- 查询生态实体的实体是否存在，刷新状态，是传送点的话传送点是否开启
function EcosystemEntityManager:CheckEntityEcoState(instanceId, ecoId)
	local sInstanceId = ecoId
	if not sInstanceId then
		local entity = self.entityManager:GetEntity(instanceId)
		if not entity or not entity.sInstanceId then
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

-- 是传送点就忽略移出
function EcosystemEntityManager:CheckEntityRemove(ecoId)
	local ecoCfg, entityType = self:GetEcoEntityConfig(ecoId)
	return entityType == FightEnum.EcoEntityType.Transport
end

-- 更新生态实体状态(给服务器发包)
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

-- 服务端驱动 更新生态实体状态
function EcosystemEntityManager:UpdateSysEntityState(data)
	for k, v in pairs(data.entity_state_list) do
		if v.state >= 1000 then
			self.sysEntityCreateState[v.entity_born_id] = true
		end

		self.sysEntityStateRecord[v.entity_born_id] = v.state % 1000
		self.entityManager:CallBehaviorFun("EcoEntityStateUpdate", v.entity_born_id)
	end
end

-- 获取生态实体状态
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

-- 重置回默认状态 
function EcosystemEntityManager:ResetEcoEntityCreateState(ecoId)
	if not self.sysEntityCreateState[ecoId] then return end
	local ecoCfg = self:GetEcoEntityConfig(ecoId)
	if not ecoCfg or not next(ecoCfg) then
		return
	end
	self.sysEntityCreateState[ecoId] = false
	local createState = ecoCfg.default_create
	self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(ecoId, createState)
end

--更新生态怪物的等级偏移
function EcosystemEntityManager:UpdateEcoMonsterLevelBias(data)
	for k, v in pairs(data.level_bias_maps) do
		self.ecoMonsterLevBias[k] = v
		EventMgr.Instance:Fire(EventName.EcoMonsterLevBiasUpdate, k)
	end
end

--获取生态怪物的等级偏移
function EcosystemEntityManager:GetEcoMonsterLevelBias(ecoId)
	local cfg, ecoType = self:GetEcoEntityConfig(ecoId)
	local worldLev = mod.WorldLevelCtrl:GetWorldLevel()
	if cfg and next(cfg.level_bias) then
		return cfg.level_bias[worldLev + 1] or 0, true
	end
	
	return self.ecoMonsterLevBias[ecoId] or 0, self.ecoMonsterLevBias[ecoId]
end

--移除生态怪物的等级偏移数据
function EcosystemEntityManager:RemoveEcoMonsterLevelBias(ecoId)
	self.ecoMonsterLevBias[ecoId] = nil
end

-- 设置生态实体默认创建状态
function EcosystemEntityManager:SetEcoEntitySvrCreateState(ecoId, state, isNotCreateCtrl)
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
	self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(ecoId, createState, isNotCreateCtrl)
end


function EcosystemEntityManager:GetEcoEntitySvrCreateState(ecoId)
	return self.sysEntityCreateState[ecoId]
end

-- 生态实体命中 给服务器发包
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

-- 生态实体命中 服务器回包
function EcosystemEntityManager:EntityHitEnd(data)
	local ecoId = data.id
	self:RemoveEcoMonsterLevelBias(ecoId)
	if not self:GetEcoEntity(ecoId) then
		--0表示是从GM获取掉落物
		if ecoId == 0 then
			for _, itemInfo in pairs(data.drop_list) do
				self:CreateDropEntityConfig(itemInfo)
			end
		end
		return
	end
	local entity = self:GetEcoEntity(ecoId)
	local isMercenary = self:IsMercenaryEntity(ecoId)

	-- 缔结
	--local isConclude = entity:CheckConcludeBuffState()
	--if isConclude then
		self.fight.partnerManager:PartnerConcludeHitEnd(data.partner_conclude_info, entity)
		Fight.Instance.mercenaryHuntManager:PlayerRemoveTarget(entity.instanceId)
	--end

	if entity and entity.buffComponent then
		entity.buffComponent:RemoveAllBuff()
	end

	self.entityHitRecordMap[entity.instanceId] = nil
	if self.waitRemoveList and self.waitRemoveList[ecoId] then
		if entity.behaviorComponent then
			entity.behaviorComponent:CallFunc("EntityHitEnd", entity.instanceId)
			self.fight.taskManager:CallBehaviorFun("EntityHitEnd", entity.instanceId)
		end

		if self.waitRemoveList[ecoId] then
			self.waitRemoveList[ecoId] = nil
		end
	else
		self.entityManager:RemoveEntity(entity.instanceId,true)
	end

	for _, itemInfo in pairs(data.drop_list) do
		self:CreateDropEntityConfig(itemInfo)
	end

	local ecoCfg = self:GetEcoEntityConfig(ecoId)

	if ecoCfg and ecoCfg.alert_tips and ecoCfg.alert_tips ~= 0 then
		EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid,ecoCfg.alert_tips)
	end

	if isMercenary then
		self.fight.mercenaryHuntManager:KillMercenary(ecoId)
	end

	if ResDuplicateConfig.GetResourceEcoHitCost(ecoId) then
		self:ResetEcoEntityCreateState(ecoId)
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

function EcosystemEntityManager:GetNearProtector()
	local playerPos = BehaviorFunctions.GetPositionP(self.entityManager.ecosystemCtrlManager.ctrlEntity)
	for k, v in pairs(self.sysEntityMap) do
		if v.entityId == 900090 then
			local pos = BehaviorFunctions.GetPositionP(k)
			if Vec3.SquareDistance(playerPos,pos) <= 50 then
				return k
			end
		end
	end
end

function EcosystemEntityManager:__delete()
	EventMgr.Instance:RemoveListener(EventName.EntityHit, self:ToFunc("EntityHit"))
	EventMgr.Instance:RemoveListener(EventName.EntityHitEnd, self:ToFunc("EntityHitEnd"))
end