---@class EntityManager
---@field entites Entity[]
EntityManager = BaseClass("EntityManager")

local _tinsert = table.insert
local _tremove = table.remove
local _unityUtils = UnityUtils
local _eventMgr = EventMgr
local _fightEnum = FightEnum
local _eventName = EventName
local _luaEntityProfiler = LuaEntityProfiler
function EntityManager:__init(fight)
	self.fight = fight
	self.instanceId = 0
	self.entites = {}
	self.tagEntites = {}
	self.levelEntites = {}
	self.levelEntitesMark = {}
	self.entityLevel = {}
	self.entityInstances = {}
	self.assembler = Assembler.New(self.fight)
	self.entitySearch = EntitySearch.New(self)
	self.ecosystemCtrlManager = EcosystemCtrlManager.New(fight, self)
	self.addQueue = FixedQueue.New()
	self.removeQueue = {}
	self.waitRemoveList = {}
	self.tpEntityMap = {}

	--#endregion

	-- 生态实体管理器
	self.ecosystemEntityManager = EcosystemEntityManager.New(fight, self)

	-- 本地实体管理器
	self.localEntityManager = LocalEntityManager.New(fight,self)

	-- NPC实体管理器
	self.npcEntityManager = NpcManager.New(fight, self)

	-- 打工中心演出实体管理器
	self.partnerDisplayManager = PartnerDisplayManager.New(fight, self)

	-- 汽车实体管理器
	self.trafficManager = TrafficManager.New(fight, self)
	
	--全局时间
	self.commonTimeScaleManager = CommonTimeScaleManager.New(fight,self)
	
	--实体交通记录表
	self.trafficCtrlMap = {}
	
	self.deadEntites = {}

	self.colliderInstanceIds = {}

	self.entityBehaviorMgr = EntityBehaviorMgr.New(self)

	self.queryEntityConfig = {
		[_fightEnum.CreateEntityType.Ecosystem] = function (sInstanceId) 
			return self.ecosystemEntityManager:GetEcoEntityConfig(sInstanceId)
		end,

		[_fightEnum.CreateEntityType.Mercenary] = function (sInstanceId)
			return self.ecosystemEntityManager:GetMercenaryEcoConfig(sInstanceId)
		end
	}

	self.triggerEntityInteractCfg = {}
end

function EntityManager:StartFight()
	self.ecosystemEntityManager:StartFight()
	self.npcEntityManager:StartFight()
	self.partnerDisplayManager:StartFight()
	self.trafficManager:StartFight()
	self.localEntityManager:StartFight()
end

function EntityManager:Update()
	-- Fight.Instance.entityManager:FireTriggerEntityInteract()
	--_luaEntityProfiler:UpdateRecord()
	self.commonTimeScaleManager:Update()
	local entityInstancesCount = #self.entityInstances
	for i = 1, entityInstancesCount do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			self.commonTimeScaleManager:UpdateCommonTimeScale(entity)
			entity:Update()
		else
			_tinsert(self.removeQueue,i)
		end
	end

	while self.addQueue:GetTop() do
		local instanceId = self.addQueue:Pop()
		local entity = self.entites[instanceId]
		if entity then
			_tinsert(self.entityInstances,entity.instanceId)
			entity:Update()
		end
	end

	if next(self.removeQueue) then
		for i = #self.removeQueue, 1, -1 do
			local pos = self.removeQueue[i]
			_tremove(self.entityInstances,pos)
		end

		for i = #self.removeQueue, 1, -1 do
			_tremove(self.removeQueue)
		end
	end
	self.ecosystemCtrlManager:Update()
	self.ecosystemEntityManager:Update()
	self.localEntityManager:Update()
	self.npcEntityManager:Update()
	self.partnerDisplayManager:Update()
	self.trafficManager:Update()
end

function EntityManager:BeforeUpdate()
	local player = self.fight.playerManager:GetPlayer()
	local centerPos = player and player.lodCenterPoint or nil
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			entity:BeforeUpdate(centerPos)
		end
	end
end

function EntityManager:AfterUpdate()
	_unityUtils.BeginSample("EntityManager:AfterUpdate")
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			local s = entity.entityId * 10000 + entity.instanceId
			_unityUtils.BeginSample(s)
			entity:AfterUpdate()
			_unityUtils.EndSample()
		end
	end
	_unityUtils.EndSample()
end

---@return Entity
function EntityManager:CreateEntity(entityId, parent, masterId, sInstanceId, levelId, params)
	if not EntityConfig.GetEntity(entityId) then
		LogError("找不到Entity配置！"..entityId)
		return
	end
	self.instanceId = self.instanceId + 1
	--_luaEntityProfiler:OnEntityCreate(self.instanceId, entityId)
	local entity = self.assembler:CreateEntity(self.instanceId, entityId, parent, sInstanceId, params)
	entity.masterId = masterId
	self.entites[entity.instanceId] = entity

	if entity:IsTpEntity() then
		self.tpEntityMap[entity.instanceId] = entity
	end

	if levelId then
		self.levelEntites[levelId] = self.levelEntites[levelId] or {}
		self.levelEntites[levelId][entity.instanceId] = entity.instanceId
		self.entityLevel[entity.instanceId] = levelId
	end
	self.addQueue:Push(entity.instanceId)

	_unityUtils.BeginSample("LateInitComponents_"..entityId)
	--插入完再LateInit，这里策划开始调用Behaivor接口了
	entity:LateInitComponents()
	for k, v in pairs(entity.clientEntity.clientComponents) do
		if v.LateInit then
			v:LateInit()
		end
	end

	if parent then
		local skillLevel = BehaviorFunctions.GetEntityLevelByEntity(parent.instanceId, entityId)
		skillLevel = skillLevel or parent:GetDefaultSkillLevel()
		if skillLevel then
			entity:SetDefaultSkillLevel(skillLevel)
		end
		local skillType = parent:GetDefaultSkillType()
		if skillType then
			entity:SetDefaultSkillType(skillType)
		end
	end

	if entity.stateComponent then
		entity.stateComponent:SetState(_fightEnum.EntityState.Born)
	end
	_unityUtils.EndSample()

	--if entity.tagComponent then
		-- 副本fight_event添加magic
		self:SetFightEvent(entity,levelId)
	--end

	_eventMgr.Instance:Fire(_eventName.CreateEntity, entity.instanceId)
	entity:SetComponentLodInfo()
	return entity
end

function EntityManager:RemoveEntity(instanceId, noCache)
	local entity = self.entites[instanceId]
	if not entity or self.waitRemoveList[instanceId] then
		return
	end

	self.waitRemoveList[instanceId] = true

	local noCache = noCache or false
	local entityId = entity.entityId
	local sInstanceId = entity.sInstanceId

	self:CallBehaviorFun("RemoveEntity", instanceId, sInstanceId)
	_eventMgr.Instance:Fire(_eventName.RemoveEntity, instanceId, sInstanceId)

	self.fight.clientFight.clientEntityManager:RemoveClientEntity(instanceId, noCache, entityId)
	self.entites[instanceId] = nil
	self.fight.objectPool:Cache(Entity,entity)

	local levelId = self.entityLevel[instanceId]
	if levelId then
		self.levelEntites[levelId][instanceId] = nil
		if self.levelEntitesMark[levelId] and self.levelEntitesMark[levelId][instanceId] then
			mod.WorldMapCtrl:RemoveMapMark(self.levelEntitesMark[levelId][instanceId])
			self.levelEntitesMark[levelId][instanceId] = nil
		end
		self.entityLevel[instanceId] = nil
	end
	self.tpEntityMap[instanceId] = nil

	-- 如果是生态 把距离控制和对应的数据也清空掉
	if sInstanceId then
		local isNpc = self.npcEntityManager:CheckEcoIdIsNpc(sInstanceId)
		if isNpc then
			self.npcEntityManager:RemoveNpc(sInstanceId)
		else
			self.ecosystemEntityManager:RemoveSysEntity(sInstanceId)
		end
		self.ecosystemCtrlManager:RemoveEcosystemEntityByID(sInstanceId)
	end
	BehaviorFunctions.fight.clientFight.headInfoManager:HideCharacterHeadTips(instanceId)
	--_luaEntityProfiler:OnEntityDestroy(instanceId, entityId)

	self.waitRemoveList[instanceId] = nil
end

function EntityManager:CheckEntityIsBelongLevel(instanceId)
	return self.entityLevel[instanceId]
end

function EntityManager:RemoveLevelEntity(levelId)
	if self.levelEntites[levelId] then
		for key, instanceId in pairs(self.levelEntites[levelId]) do
			self:RemoveEntity(instanceId)
		end
	end

	if self.levelEntitesMark[levelId] then
		for k, v in pairs(self.levelEntitesMark[levelId]) do
			mod.WorldMapCtrl:RemoveMapMark(v)
		end
	end

	self.levelEntites[levelId] = nil
end

function EntityManager:ShowLevelEnemyOnMap(levelId, isShow)
	if not self.levelEntites[levelId] then
		return
	end

	if isShow then
		self.levelEntitesMark[levelId] = {}
		for k, v in pairs(self.levelEntites[levelId]) do
			self.levelEntitesMark[levelId][v] = mod.WorldMapCtrl:AddEnemyMark(v)
		end
	else
		for k, v in pairs(self.levelEntitesMark[levelId]) do
			mod.WorldMapCtrl:RemoveMapMark(v)
		end
		self.levelEntitesMark[levelId] = nil
	end
end

function EntityManager:AddTagEntity(tag, entity)
	if not self.tagEntites[tag] then
		self.tagEntites[tag] = {}
	end
	self.tagEntites[tag][entity.instanceId] = entity
end

function EntityManager:RemoveTagEntity(tag, entity)
	if not self.tagEntites[tag] then
		return
	end
	self.tagEntites[tag][entity.instanceId] = nil
end

---@return Entity
function EntityManager:GetEntity(instanceId)
	return self.entites[instanceId]
end

---@return Entity[]
function EntityManager:GetEntites()
	return self.entites
end

function EntityManager:GetEntityConfig(instanceId)
	local entity = self:GetEntity(instanceId)
	if not entity or not entity.sInstanceId then
		return
	end

	return self:GetEntityConfigByID(entity.sInstanceId)
end

function EntityManager:GetEntityConfigByID(sInstanceId)
	local entityCfg, type
	for k, v in pairs(self.queryEntityConfig) do
		entityCfg, type = v(sInstanceId)
		if entityCfg and next(entityCfg) then
			return entityCfg, type
		end
	end
end

function EntityManager:GetEntitysByTags(tags)
	local result = {}
	for _, v in pairs(tags) do
		if self.tagEntites[v] then
			for __, vv in pairs(self.tagEntites[v]) do
				_tinsert(result, vv)
			end
		end
	end
	return result
end

function EntityManager:SetFightEvent(entity,levelId)
	if not entity.tagComponent and entity.entityId ~= 2000 then return end
	if entity.entityId == 2000 then
		local fightEventIdList = mod.DuplicateCtrl:GetFightEventIdList()
		if fightEventIdList and next(fightEventIdList) then
			for _, fightEventId in ipairs(fightEventIdList) do
				if fightEventId ~= 0 then
					local fightEvent = DuplicateConfig.GetFightEvent(fightEventId)
					if fightEvent.effect_type == 3 then
						for i, v in ipairs(fightEvent.magic_id) do
							if v ~= 0 then
								BehaviorFunctions.DoMagic(self.instanceId,self.instanceId,v)
							end
						end
					end
				end
			end
		end
		return 
	end
	if entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player and not levelId then
		local fightEventIdList = mod.DuplicateCtrl:GetFightEventIdList()
		if fightEventIdList and next(fightEventIdList) then
			for _, fightEventId in ipairs(fightEventIdList) do
				if fightEventId ~= 0 then
					local fightEvent = DuplicateConfig.GetFightEvent(fightEventId)
					if fightEvent.effect_type == 1 then
						for i, v in ipairs(fightEvent.magic_id) do
							if v ~= 0 then
								BehaviorFunctions.DoMagic(self.instanceId,self.instanceId,v)
							end
						end
					end
				end
			end
		end
		return 
	end

	if levelId then
		local fightEventIdList = mod.DuplicateCtrl:GetFightEventIdList()
		if fightEventIdList and next(fightEventIdList) then
			local npctag = entity.tagComponent.npcTag
			for _, fightEventId in ipairs(fightEventIdList) do
				if fightEventId ~= 0 then
					local fightEvent = DuplicateConfig.GetFightEvent(fightEventId)
					if fightEvent.effect_type == 21 and npctag == FightEnum.EntityNpcTag.Boss then
						for i, v in ipairs(fightEvent.magic_id) do
							if v ~= 0 then
								BehaviorFunctions.DoMagic(self.instanceId,self.instanceId,v)
							end
						end
					elseif fightEvent.effect_type == 22 and npctag == FightEnum.EntityNpcTag.Elite then
						for i, v in ipairs(fightEvent.magic_id) do
							if v ~= 0 then
								BehaviorFunctions.DoMagic(self.instanceId,self.instanceId,v)
							end
						end
					elseif fightEvent.effect_type == 23 and npctag == FightEnum.EntityNpcTag.Monster then
						for i, v in ipairs(fightEvent.magic_id) do
							if v ~= 0 then
								BehaviorFunctions.DoMagic(self.instanceId,self.instanceId,v)
							end
						end
					elseif fightEvent.effect_type == 2 and (npctag == FightEnum.EntityNpcTag.Boss or npctag == FightEnum.EntityNpcTag.Monster or npctag == FightEnum.EntityNpcTag.Elite) then		
						for i, v in ipairs(fightEvent.magic_id) do
							if v ~= 0 then
								BehaviorFunctions.DoMagic(self.instanceId,self.instanceId,v)
							end
						end
					end
				end
			end
		end
	end
end

function EntityManager:__delete()
	EntityLODManager.Instance:OnReLoad()
	if self.ecosystemEntityManager then
		self.ecosystemEntityManager:DeleteMe()
	end

	if self.ecosystemCtrlManager then
		self.ecosystemCtrlManager:DeleteMe()
	end

	if self.npcEntityManager then
		self.npcEntityManager:DeleteMe()
	end
	
	if self.partnerDisplayManager then
		self.partnerDisplayManager:DeleteMe()
	end
	if self.trafficManager then
		self.trafficManager:DeleteMe()
	end

	if self.localEntityManager then
		self.localEntityManager:DeleteMe()
	end

	if self.commonTimeScaleManager then
		self.commonTimeScaleManager:DeleteMe()
	end
	self.removing = true
	for k, v in pairs(self.entites) do
		v:DeleteMe()
	end
	self.entites = nil
	self.tagEntites = nil
	TableUtils.ClearTable(self.waitRemoveList)

	if self.assembler then
		self.assembler:DeleteMe()
		self.assembler = nil
	end

	if self.entitySearch then
		self.entitySearch:DeleteMe()
		self.entitySearch = nil
	end

	self.entityBehaviorMgr:DeleteMe()
	self.trafficCtrlMap = {}
end

function EntityManager:CreateBehavior(...)
	return self.entityBehaviorMgr:CreateBehavior(...)
end
function EntityManager:CheckTriggerComponnet(instanceId)
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity and entity.triggerComponent then
			entity.triggerComponent:CheckTriggerEntityOut(instanceId)
		end
	end
end

-- TODO 改成一个统一的behaviorManager吧 合并Task Entity Level
function EntityManager:CallBehaviorFun(funName, ...)
	-- if self.fight.behaviorMgr:CallEventFun(funcName, ...) then
	-- 	return
	-- end
	self.fight.levelManager:CallBehaviorFun(funName, ...)
	self.fight.taskManager:CallBehaviorFun(funName, ...)
	if self.entityBehaviorMgr:CallEventFun(funName, ...) then
	 	return
	end
	LogError("BehaviorEvent.EventName Missing Register "..funName)

	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity and entity.behaviorComponent then
			entity.behaviorComponent:CallFunc(funName, ...)
		end
		if entity and entity.commonBehaviorComponent then
			entity.commonBehaviorComponent:CallFunc(funName, ...)
		end
	end
end

function EntityManager:CallEntityFun(funName, ...)
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			entity[funName](entity, ...)
		end
	end
end

function EntityManager:AddResultDeadEntity(entity)
	self.deadEntites[entity.entityId] = self.deadEntites[entity.entityId] or 0
	self.deadEntites[entity.entityId] = self.deadEntites[entity.entityId] + 1
end

function EntityManager:GetResutDeadEnity()
	local list = {}
	for entityId, count in pairs(self.deadEntites) do
		_tinsert(list, {key = entityId, value = count })
	end

	return list
end

function EntityManager:CreateSysEntityCtrl(config, createEntityType, waitCreate, isGm)
	self.ecosystemCtrlManager:AddEcosystemEntity(config, createEntityType, waitCreate, isGm)
end

function EntityManager:RemoveEcosystemEntityByID(ecoId)
	self.ecosystemCtrlManager:RemoveEcosystemEntityByID(ecoId)
end

function EntityManager:GetEntityBornPos(position, radius)
	local x, z, createPos
	for i = 1, 5 do
		x = math.random(-radius, radius) * 0.1
		z = math.random(-radius, radius) * 0.1
		createPos = Vec3.New(position.x + x, position.y, position.z + z)
		-- todo 检查合理性
		break
	end

	return createPos or position
end

local GuideLightEntityId = 2020201
function EntityManager:CreateTaskGuideLight(position)
	if not self.lightEntity then
		self.lightEntity = self:CreateEntity(GuideLightEntityId)
	end
	self.lightEntity.transformComponent:SetPosition(position.x, position.y, position.z)
end

function EntityManager:RemoveTaskGuideLight()
	if self.lightEntity then
		self:RemoveEntity(self.lightEntity.instanceId)
		self.lightEntity = nil
	end
end

function EntityManager:SetColliderEntity(colliderInstanceId, entityInstanceId)
	self.colliderInstanceIds[colliderInstanceId] = entityInstanceId
	
	local entity = self:GetEntity(entityInstanceId)
	if entity then
		entity:TriggerInitialClear(colliderInstanceId)
	end
end

function EntityManager:RemoveColliderEntity(colliderInstanceId, triggerRemove)
	if triggerRemove then
		local entity = self:GetColliderEntity(colliderInstanceId)
		if entity then
			entity:OnTriggerRemove(nil, colliderInstanceId)
		end
	end
	
	if colliderInstanceId then
		self.colliderInstanceIds[colliderInstanceId] = nil
	end
end

function EntityManager:GetColliderEntity(colliderInstanceId)
	local instanceId = self.colliderInstanceIds[colliderInstanceId]
	local entity = self:GetEntity(instanceId)
	if not entity then
		self:RemoveColliderEntity(colliderInstanceId)
	end

	return entity
end

--隐藏当前显示的实体并且暂停生态实体的实例化
function EntityManager:HideAllEntity(ignoreInstanceMap, ignoreTagMap)
	ignoreInstanceMap = ignoreInstanceMap or {}
	ignoreTagMap = ignoreTagMap or {}
	if not self.hideEntityInstances then
		self.hideEntityInstances = {}
	elseif next(self.hideEntityInstances) then
		Log("已经隐藏过全部实体了！")
		return
	end

	if not self.entityTimeScales then
		self.entityTimeScales = {}
	elseif next(self.entityTimeScales) then
		Log("已经隐藏过全部实体了！")
		return
	end
	BehaviorFunctions.SetTrafficEnable(false)
	for instanceId, entity in pairs(self.entites) do
		local ignoreData = ignoreInstanceMap[instanceId]
		if (not ignoreData or not ignoreData.isIgnoreHide) and self:CheckHideTagEntity(instanceId, ignoreTagMap) then
			local clientEntity = entity.clientEntity
			if clientEntity.clientTransformComponent then
				clientEntity.clientTransformComponent:SetActivity(false)
				_tinsert(self.hideEntityInstances, instanceId)
			end
		end

		if not ignoreData or not ignoreData.isIgnoreTime then
			if entity.timeComponent then
				self.entityTimeScales[instanceId] = entity.timeComponent.timeScale
				-- entity.timeComponent.timeScale = 0
				entity.timeComponent:AddTimeScale(0)
			end
		end
	end

	self.fight.clientFight.lifeBarManager:SetLiftBarRootVisibleState(false)

	self.ecosystemCtrlManager:Pause()
end

function EntityManager:CheckHideTagEntity(instanceId, map)
	local entity = self.entites[instanceId]
	if not entity or not entity.tagComponent then
		return true
	end

	local entityTag = entity.tagComponent.tag
	if map[entityTag] then
		return false
	end

	return true
end

--恢复由HideAllEntity隐藏的全部实体
function EntityManager:ShowAllEntity()
	self.hideEntityInstances = self.hideEntityInstances or {}
	for key, instanceId in pairs(self.hideEntityInstances) do
		if self.entites[instanceId] then
			local clientEntity = self.entites[instanceId].clientEntity
			clientEntity.clientTransformComponent:SetActivity(true)
		else
			Log(string.format("恢复隐藏中的实体，但是实体%s已被移除", instanceId))
		end
	end
	for instanceId, timeScale in pairs(self.entityTimeScales) do
		if self.entites[instanceId] then
			local entity = self.entites[instanceId]
			-- entity.timeComponent.timeScale = timeScale
			entity.timeComponent:RemoveTimeScale(0)
		end
	end
	TableUtils.ClearTable(self.hideEntityInstances)
	TableUtils.ClearTable(self.entityTimeScales)
	self.fight.clientFight.lifeBarManager:SetLiftBarRootVisibleState(true)
	self.ecosystemCtrlManager:Resume()
	BehaviorFunctions.SetTrafficEnable(true)
end

function EntityManager:OnTriggerColliderEntityEnter(triggerType, objInsId, enterObjInsId, layer, name, param0, param1, param2)
	local entity = self:GetColliderEntity(objInsId)
	local enterEntity = self:GetColliderEntity(enterObjInsId)

	if entity then
		if _fightEnum.DeadLayer[layer] then
			_eventMgr.Instance:Fire(_eventName.EnterDeath, entity.instanceId,
				{ deathReason = _fightEnum.DeathCondition.Terrain, extraParam = { layer = layer } })
		elseif layer == _fightEnum.Layer.Area then
			entity:TriggerEnterArea(name, param0)
		elseif layer == _fightEnum.Layer.InRoom then
			_eventMgr.Instance:Fire(_eventName.EnterInRoomArea, entity.instanceId, name)
		else

		end

		local enterInsId = enterEntity and enterEntity.instanceId or 0
		_eventMgr.Instance:Fire(_eventName.EnterTriggerLayer, entity.instanceId, layer, enterInsId,objInsId,param1,param2)
		entity:OnTriggerEnter(triggerType, objInsId, enterObjInsId, layer)
	end
end

function EntityManager:OnTriggerColliderEntityExit(triggerType, objInsId, exitObjInsId, layer, name, param0)
	local entity = self:GetColliderEntity(objInsId)
	if entity then
		if _fightEnum.DeadLayer[layer] then
			_eventMgr.Instance:Fire(_eventName.ExitDeath, entity.instanceId, _fightEnum.DeathCondition.Terrain)
		elseif layer == _fightEnum.Layer.Area then
			entity:TriggerExitArea(name, param0)
		elseif layer == _fightEnum.Layer.InRoom then
			_eventMgr.Instance:Fire(_eventName.ExitInRoomArea, entity.instanceId, name)
		else

		end

		_eventMgr.Instance:Fire(_eventName.ExitTriggerLayer, entity.instanceId, layer)
		entity:OnTriggerExit(triggerType, objInsId, exitObjInsId)
	end
end

function EntityManager:OnTriggerColliderRemove(triggerType, objInsId, layer, name, param0)
	if layer == _fightEnum.Layer.IgnoreRayCastLayer then
		return
	end
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			local hadTrigger = entity:OnTriggerRemove(triggerType, objInsId)
			if hadTrigger then
				if _fightEnum.DeadLayer[layer] then
					_eventMgr.Instance:Fire(_eventName.ExitDeath, entity.instanceId, _fightEnum.DeathCondition.Terrain)
				elseif layer == _fightEnum.Layer.Area then
					entity:TriggerExitArea(name, param0)
				else

				end
			end
		end
	end
	
	local colEntity = self:GetColliderEntity(objInsId)
	if colEntity then
		_eventMgr.Instance:Fire(_eventName.ExitTriggerLayer, colEntity.instanceId, layer)
		self:RemoveEntity(objInsId)
	end
end

function EntityManager:GetTpEntityMapByTpType(tpType, instanceId)
	local tpList = {}
	for key, entity in pairs(self.tpEntityMap) do
		if not entity:IsTpEntity() or entity.instanceId == instanceId then
			goto continue
		end

		local tpCfg = entity:GetComponentConfig(_fightEnum.ComponentType.Tp)
		if tpCfg.TpType == tpType then
			_tinsert(tpList, entity.instanceId)
		end
		
		::continue::
	end

	return tpList
end

function EntityManager:GetEntityTerrainCfgInfo(ecosystemConfig, isGetMapId)
	local name = ecosystemConfig.position[2]
	local belongId = ecosystemConfig.position[1]
	local mapId
	if isGetMapId then
		mapId = ecosystemConfig.map_id
	end
	local curMapId = self.fight:GetFightMap()

	if curMapId == ecosystemConfig.transfirst_map_id then
		mapId = ecosystemConfig.transfirst_map_id
		local transfirstPosition = ecosystemConfig.transfirst_position
		if transfirstPosition and #transfirstPosition > 0 then
			name = transfirstPosition[2]
			belongId = transfirstPosition[1]
		end
	end

	return name, mapId, belongId
end

function EntityManager:SetTrafficCtrlEntity(roleInstanceId, targetInstanceId)
	self.trafficCtrlMap[roleInstanceId] = targetInstanceId
end

function EntityManager:GetTrafficCtrlEntity(instanceId)
	return self.trafficCtrlMap[instanceId]
end

function EntityManager:RemoveTrafficCtrlEntity(instanceId)
	self.trafficCtrlMap[instanceId] = nil
end

function EntityManager:GetTagByEntityId(entityId)
	-- 先判断一下是不是怪物吧
	local monsterCfg = Config.DataMonster.Find[entityId]
	if monsterCfg then
		entityId = monsterCfg.entity_id
	end

	local entityCfg = EntityConfig.GetEntity(entityId)
	if not entityCfg then
		return
	end

	local tagConfig = entityCfg.Components[_fightEnum.ComponentConfigName[_fightEnum.ComponentType.Tag]]
	if not tagConfig then
		return
	end

	return tagConfig.NpcTag
end

function EntityManager:AddTriggerEntityInteract(instanceId, interactId, type)
	if not instanceId or not interactId then
		return
	end
	self.triggerEntityInteractCfg = self.triggerEntityInteractCfg or {}
	self.triggerEntityInteractCfg[instanceId] = self.triggerEntityInteractCfg[instanceId] or {}
	self.triggerEntityInteractCfg[instanceId][interactId] = {state = true, type = type}
end

function EntityManager:ChangeTriggerEntityInteractState(instanceId, interactId, state)
	if not instanceId or not interactId then
		return
	end
	self.triggerEntityInteractCfg = self.triggerEntityInteractCfg or {}
	self.triggerEntityInteractCfg[instanceId] = self.triggerEntityInteractCfg[instanceId] or {}
	self.triggerEntityInteractCfg[instanceId][interactId].state = state
end

function EntityManager:RemoveTriggerEntityInteract(instanceId, interactId)
	if not instanceId or not interactId then
		return
	end
	self.triggerEntityInteractCfg = self.triggerEntityInteractCfg or {}
	self.triggerEntityInteractCfg[instanceId] = self.triggerEntityInteractCfg[instanceId] or {}
	self.triggerEntityInteractCfg[instanceId][interactId] = nil
end

function EntityManager:ClearTriggerEntityInteract(instanceId)
	self.triggerEntityInteractCfg[instanceId] = nil
end

function EntityManager:FireTriggerEntityInteractByInstanceId(instanceId)
	local entity = self:GetEntity(instanceId)
	local info = self.triggerEntityInteractCfg[instanceId]
	if not info then
		return
	end
	if not entity then
		self:ClearTriggerEntityInteract(instanceId)
	else
		for interactId, v in pairs(info) do
			if v.state ~= nil then
				if v.state == true and v.type then
					local interactCfg = Config.InteractConfig.InteractStateCfg[v.type] or {}
					for k, fun in pairs(interactCfg) do
						if fun() == true then
							entity:HideInteractItem(interactId, 1)
							self.triggerEntityInteractCfg[instanceId][interactId].state = false
							break
						end
					end
				elseif v.state == false and v.type then
					local interactCfg = Config.InteractConfig.InteractStateCfg[v.type] or {}
					local tempState = false
					for k, fun in pairs(interactCfg) do
						if fun() == true then
							tempState = true
						end
					end
					if tempState == false then
						entity:ShowInteractItem(interactId, 1)
						self.triggerEntityInteractCfg[instanceId][interactId].state = true
					end
				end
			end
		end
	end
end

function EntityManager:FireTriggerEntityInteract()
	for instanceId, info in pairs(self.triggerEntityInteractCfg) do
		self:FireTriggerEntityInteractByInstanceId(instanceId)
	end
end

-- show hide
function EntityManager:ChangeTriggerEntityStateById(instanceId, show)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local info = self.triggerEntityInteractCfg[instanceId]
	if not info or show == nil then
		return
	end
	for interactId, v in pairs(info) do
		if show == true then
			entity:ShowInteractItem(interactId, 2)
		elseif show == false then
			entity:HideInteractItem(interactId, 2)
		end
	end
end