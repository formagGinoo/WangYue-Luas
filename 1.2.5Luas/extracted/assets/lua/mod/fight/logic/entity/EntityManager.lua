---@class EntityManager
---@field entites Entity[]
EntityManager = BaseClass("EntityManager")

local _tinsert = table.insert
local _tremove = table.remove

function EntityManager:__init(fight)
	self.fight = fight
	self.instanceId = 0
	self.entites = {}
	self.bioEntites = {}
	self.levelEntites = {}
	self.entityLevel = {}
	self.entityInstances = {}
	self.assembler = Assembler.New(self.fight)
	self.entitySearch = EntitySearch.New(self)
	self.ecosystemCtrlManager = EcosystemCtrlManager.New()
	self.ecosystemCtrlManager:Init(fight,self)
	self.addQueue = FixedQueue.New()
	self.removeQueue = {}
	self.tpEntityMap = {}

	--#region 敌方的全局速度
	self.timeScaleCurveInstance = 1
	self.enemyCommonTimeCurves = {}
	self.enemyCommonTimeScaleWithTime = {}
	self.enemyCommonTimeScales = {} --敌方使用的全局速度，常用于超算，解决超算时间内出生的敌方没有被减速
	self.enemyCommonTimeScale = 1
	self.enemyCommonTimeScaleBuff = 1
	self.enemyCommonTimeScaleCurve = 1
	--#endregion

	-- 生态实体管理器
	self.ecosystemEntityManager = EcosystemEntityManager.New(fight, self)

	-- NPC实体管理器
	self.npcEntityManager = NpcManager.New(fight, self)

	self.deadEntites = {}

	self.colliderInstanceIds = {}
end

function EntityManager:StartFight()
	self.ecosystemEntityManager:StartFight()
	self.npcEntityManager:StartFight()

	self.queryEntityConfig = {
		[FightEnum.CreateEntityType.Ecosystem] = function (sInstanceId) 
			return self.ecosystemEntityManager:GetEcoEntityConfig(sInstanceId)
		end,

		[FightEnum.CreateEntityType.Npc] = function (sInstanceId)
			return self.npcEntityManager:GetNpcConfig(sInstanceId)
		end,

		[FightEnum.CreateEntityType.Mercenary] = function (sInstanceId)
			return self.ecosystemEntityManager:GetMercenaryEcoConfig(sInstanceId)
		end
	}
end

function EntityManager:Update()
	

	if self.enemyCommonTimeScaleWithTime then
		for k, v in pairs(self.enemyCommonTimeScaleWithTime) do
			self.enemyCommonTimeScaleWithTime[k].frame = self.enemyCommonTimeScaleWithTime[k].frame - 1
			if self.enemyCommonTimeScaleWithTime[k].frame <= 0 then
				self:RemoveEnemyCommonTimeScale(v.timeScale)
				self.enemyCommonTimeScaleWithTime[k] = nil
			end
		end
	end

	self:UpdateEnemyCommonTimeScaleCurve()
	if self.enemyCommonTimeScaleChange then
		for i = 1, #self.entityInstances do
			local entity = self.entites[self.entityInstances[i]]
			if entity and entity.timeComponent then
				entity.timeComponent:UpdateEnemyCommonTimeScale()
			end
		end
	end

	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
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
			
			if entity.stateComponent then
				entity.stateComponent:SetState(FightEnum.EntityState.Born)
			end
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
	self.npcEntityManager:Update()
end

function EntityManager:BeforeUpdate()
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			entity:BeforeUpdate()
		end
	end
end

function EntityManager:AfterUpdate()
	UnityUtils.BeginSample("EntityManager:AfterUpdate")
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			UnityUtils.BeginSample("EntityManager:AfterUpdate_"..entity.entityId)
			entity:AfterUpdate()
			UnityUtils.EndSample()
		end
	end
	UnityUtils.EndSample()
end

---@return Entity
function EntityManager:CreateEntity(entityId, owner, masterId, sInstanceId, levelId, params)
	if not EntityConfig.GetEntity(entityId) then
		LogError("找不到Entity配置！"..entityId)
		return
	end

	self.instanceId = self.instanceId + 1
	local entity = self.assembler:CreateEntity(self.instanceId, entityId, owner, sInstanceId, params)
	entity.masterId = masterId
	self.entites[entity.instanceId] = entity

	if entity:IsTpEntity() then
		self.tpEntityMap[entity.instanceId] = entity
	end

	--_tinsert(self.entityInstances,entity.instanceId)
	--_tinsert(self.addQueue,entity.instanceId)
	if levelId then
		self.levelEntites[levelId] = self.levelEntites[levelId] or {}
		self.levelEntites[levelId][entity.instanceId] = entity.instanceId
		self.entityLevel[entity.instanceId] = levelId
	end
	self.addQueue:Push(entity.instanceId)

	UnityUtils.BeginSample("LateInitComponents_"..entityId)
	--插入完再LateInit，这里策划开始调用Behaivor接口了
	entity:LateInitComponents()
	UnityUtils.EndSample()
	return entity
end

function EntityManager:RemoveEntity(instanceId, noCache)
	local entity = self.entites[instanceId]
	if not entity then
		return
	end

	local noCache = noCache or false
	local entityId = entity.entityId
	local sInstanceId = entity.sInstanceId

	if ctx then
		self.fight.clientFight.clientEntityManager:RemoveClientEntity(instanceId, noCache, entityId)
	end

	self:CallBehaviorFun("RemoveEntity", instanceId)
	self.fight.taskManager:CallBehaviorFun("RemoveEntity", instanceId)
	EventMgr.Instance:Fire(EventName.RemoveEntity, instanceId)
	self.entites[instanceId] = nil
	self.fight.objectPool:Cache(Entity,entity)

	self.entityLevel[instanceId] = nil
	self.bioEntites[instanceId] = nil
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
end

function EntityManager:RemoveLevelEntity(levelId)
	if self.levelEntites[levelId] then
		for key, instanceId in pairs(self.levelEntites[levelId]) do
			self:RemoveEntity(instanceId)
		end
	end
	self.levelEntites[levelId] = nil
end

function EntityManager:AddBioEntity(entity)
	self.bioEntites[entity.instanceId] = entity
end

---@return Entity
function EntityManager:GetEntity(instanceId)
	return self.entites[instanceId]
end

---@return Entity[]
function EntityManager:GetEntites()
	return self.entites
end

function EntityManager:AddEnemyCommonTimeScale(timeScale, frame, isCanBreak)
	if frame then
		_tinsert(self.enemyCommonTimeScaleWithTime, { timeScale = timeScale, frame = frame, isCanBreak = isCanBreak })
	end

	if not self.enemyCommonTimeScales[timeScale] then
		self.enemyCommonTimeScales[timeScale] = 0
	end
	self.enemyCommonTimeScales[timeScale] = self.enemyCommonTimeScales[timeScale] + 1
	self:UpdateEnemyCommonTimeScale()
end

function EntityManager:RemoveEnemyCommonTimeScale(timeScale)
	self.enemyCommonTimeScales[timeScale] = self.enemyCommonTimeScales[timeScale] - 1
	self:UpdateEnemyCommonTimeScale()
end

function EntityManager:UpdateEnemyCommonTimeScale() 
	local timeScale = 1

	for i, v in pairs(self.enemyCommonTimeScales) do
		if i < timeScale and v > 0 then
			timeScale = i
		end
	end
	self.enemyCommonTimeScaleBuff = timeScale
	self.enemyCommonTimeScale = self.enemyCommonTimeScaleBuff < self.enemyCommonTimeScaleCurve and self.enemyCommonTimeScaleBuff or self.enemyCommonTimeScaleCurve
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateEnemyCommonTimeScale()
		end
	end
end

function EntityManager:AddEnemyCommonTimeScaleCurve(entity, curveId, isCanBreak)
	local curve = CurveConfig.GetCurve(entity.entityId, curveId)
	if not curve then
		LogError("找不到曲线,id = "..curveId)
		return
	end

	self.timeScaleCurveInstance = self.timeScaleCurveInstance + 1
	local curveInfo = { curve = curve, startFrame = self.fight.fightFrame - 1, isCanBreak = isCanBreak }
	self.enemyCommonTimeCurves[self.timeScaleCurveInstance] = curveInfo
	self:UpdateEnemyCommonTimeScaleCurve()

	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateEnemyCommonTimeScale()
		end
	end
	return self.timeScaleCurveInstance
end

function EntityManager:RemoveEnemyCommonTimeScaleCurve(instanceId)
	if not instanceId then
		return
	end

	self.enemyCommonTimeCurves[instanceId] = nil
	self:UpdateEnemyCommonTimeScaleCurve()

	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateEnemyCommonTimeScale()
		end
	end
end

function EntityManager:UpdateEnemyCommonTimeScaleCurve()
	local timeScale = 1
	local before = self.enemyCommonTimeScale
	for k, v in pairs(self.enemyCommonTimeCurves) do
		local index = self.fight.fightFrame - v.startFrame
		local ts = v.curve[index]
		if ts and ts < timeScale then
			timeScale = ts
		end
	end
	self.enemyCommonTimeScaleCurve = timeScale
	self.enemyCommonTimeScale = self.enemyCommonTimeScaleBuff < self.enemyCommonTimeScaleCurve and self.enemyCommonTimeScaleBuff or self.enemyCommonTimeScaleCurve

	self.enemyCommonTimeScaleChange = before ~= self.enemyCommonTimeScale
end

function EntityManager:RemoveCanBreakPauseFrame()
	if not self.enemyCommonTimeScaleWithTime or not next(self.enemyCommonTimeScaleWithTime) then
		return
	end
	for k, v in pairs(self.enemyCommonTimeScaleWithTime) do
		if v.isCanBreak then
			self:RemoveEnemyCommonTimeScale(v.timeScale)
			self.enemyCommonTimeScaleWithTime[k] = nil
		end
	end

	if not self.enemyCommonTimeCurves or not next(self.enemyCommonTimeCurves) then
		return
	end
	for k, v in pairs(self.enemyCommonTimeCurves) do
		if v.isCanBreak then
			self:RemoveEnemyCommonTimeScaleCurve(k)
		end
	end
end

function EntityManager:GetEntityConfig(instanceId)
	local entity = self:GetEntity(instanceId)
	if not entity or not entity.sInstanceId then
		return
	end

	return self:GetEntityConfigByID(entity.sInstanceId)
end

function EntityManager:GetEntityConfigByID(sInstanceId)
	local entityCfg
	for k, v in pairs(self.queryEntityConfig) do
		entityCfg = v(sInstanceId)
		if entityCfg and next(entityCfg) then
			return entityCfg, k
		end
	end
end

function EntityManager:__delete()
	if self.ecosystemEntityManager then
		self.ecosystemEntityManager:DeleteMe()
	end

	if self.ecosystemCtrlManager then
		self.ecosystemCtrlManager:DeleteMe()
	end

	if self.npcEntityManager then
		self.npcEntityManager:DeleteMe()
	end

	self.removing = true
	for k, v in pairs(self.entites) do
		v:DeleteMe()
	end
	self.entites = nil
	TableUtils.ClearTable(self.waitRemoveList)

	if self.assembler then
		self.assembler:DeleteMe()
		self.assembler = nil
	end

	if self.entitySearch then
		self.entitySearch:DeleteMe()
		self.entitySearch = nil
	end
end

function EntityManager:CallBehaviorFun(funName, ...)
	UnityUtils.BeginSample("CallBehaviorFun_"..funName)
	self.fight.levelManager:CallBehaviorFun(funName, ...)
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity and entity.behaviorComponent then
			entity.behaviorComponent:CallFunc(funName, ...)
		end
		if entity and entity.commonBehaviorComponent then
			entity.commonBehaviorComponent:CallFunc(funName, ...)
		end
	end

	if TaskConfig.BehaviorFun[funName] then
		self.fight.taskManager:CallBehaviorFun(funName, ...)
	end
	UnityUtils.EndSample()
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

function EntityManager:CreateSysEntityCtrl(config, createEntityType, waitCreate)
	self.ecosystemCtrlManager:AddEcosystemEntity(config, createEntityType, waitCreate)
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
function EntityManager:HideAllEntity(ignoreInstanceMap)
	ignoreInstanceMap = ignoreInstanceMap or {}
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

	for instanceId, entity in pairs(self.entites) do
		local ignoreData = ignoreInstanceMap[instanceId]
		if not ignoreData or not ignoreData.isIgnoreHide then
			local clientEntity = entity.clientEntity
			if clientEntity.clientTransformComponent and clientEntity.clientTransformComponent:SetActivity(false) then
				_tinsert(self.hideEntityInstances, instanceId)
			end
		end

		if not ignoreData or not ignoreData.isIgnoreTime then
			if entity.timeComponent then
				self.entityTimeScales[instanceId] = entity.timeComponent.timeScale
				entity.timeComponent.timeScale = 0
			end
		end
	end

	self.fight.clientFight.lifeBarManager:SetLiftBarRootVisibleState(false)

	self.ecosystemCtrlManager:Pause()
end

--恢复由HideAllEntity隐藏的全部实体
function EntityManager:ShowAllEntity()
	for key, instanceId in pairs(self.hideEntityInstances) do
		if self.entites[instanceId] then
			local clientEntity = self.entites[instanceId].clientEntity
			clientEntity.clientTransformComponent:SetActivity(true)
		else
			LogError(string.format("恢复隐藏中的实体，但是实体%s已被移除", instanceId))
		end
	end
	for instanceId, timeScale in pairs(self.entityTimeScales) do
		if self.entites[instanceId] then
			local entity = self.entites[instanceId]
			entity.timeComponent.timeScale = timeScale
		end
	end
	TableUtils.ClearTable(self.hideEntityInstances)
	TableUtils.ClearTable(self.entityTimeScales)
	self.fight.clientFight.lifeBarManager:SetLiftBarRootVisibleState(true)
	self.ecosystemCtrlManager:Resume()
end

function EntityManager:OnTriggerColliderEntityEnter(triggerType, objInsId, enterObjInsId, layer, name, param0)
	local entity = self:GetColliderEntity(objInsId)
	local enterEntity = self:GetColliderEntity(enterObjInsId)

	if entity then
		if FightEnum.DeadLayer[layer] then
			EventMgr.Instance:Fire(EventName.EnterDeath, entity.instanceId,
				{ deathReason = FightEnum.DeathCondition.Terrain, extraParam = { layer = layer } })
		elseif layer == FightEnum.Layer.Area then
			entity:TriggerEnterArea(name, param0)
		else

		end

		local enterInsId = enterEntity and enterEntity.instanceId or 0
		EventMgr.Instance:Fire(EventName.EnterTriggerLayer, entity.instanceId, layer, enterInsId)
		entity:OnTriggerEnter(triggerType, objInsId, enterObjInsId, layer)
	end
end

function EntityManager:OnTriggerColliderEntityExit(triggerType, objInsId, exitObjInsId, layer, name, param0)
	local entity = self:GetColliderEntity(objInsId)
	if entity then
		if FightEnum.DeadLayer[layer] then
			EventMgr.Instance:Fire(EventName.ExitDeath, entity.instanceId, FightEnum.DeathCondition.Terrain)
		elseif layer == FightEnum.Layer.Area then
			entity:TriggerExitArea(name, param0)
		else

		end

		EventMgr.Instance:Fire(EventName.ExitTriggerLayer, entity.instanceId, layer)
		entity:OnTriggerExit(triggerType, objInsId, exitObjInsId)
	end
end

function EntityManager:OnTriggerColliderRemove(triggerType, objInsId, layer, name, param0)
	if layer == FightEnum.Layer.IgonreRayCastLayer then
		return
	end
	for i = 1, #self.entityInstances do
		local entity = self.entites[self.entityInstances[i]]
		if entity then
			local hadTrigger = entity:OnTriggerRemove(triggerType, objInsId)
			if hadTrigger then
				if FightEnum.DeadLayer[layer] then
					EventMgr.Instance:Fire(EventName.ExitDeath, entity.instanceId, FightEnum.DeathCondition.Terrain)
				elseif layer == FightEnum.Layer.Area then
					entity:TriggerExitArea(name, param0)
				else

				end
			end
		end
	end
	
	local colEntity = self:GetColliderEntity(objInsId)
	if colEntity then
		EventMgr.Instance:Fire(EventName.ExitTriggerLayer, colEntity.instanceId, layer)
		self:RemoveEntity(objInsId)
	end
end

function EntityManager:GetTpEntityMapByTpType(tpType, instanceId)
	local tpList = {}
	for key, entity in pairs(self.tpEntityMap) do
		if not entity:IsTpEntity() or entity.instanceId == instanceId then
			goto continue
		end

		local tpCfg = entity:GetComponentConfig(FightEnum.ComponentType.Tp)
		if tpCfg.TpType == tpType then
			_tinsert(tpList, entity.instanceId)
		end
		
		::continue::
	end

	return tpList
end