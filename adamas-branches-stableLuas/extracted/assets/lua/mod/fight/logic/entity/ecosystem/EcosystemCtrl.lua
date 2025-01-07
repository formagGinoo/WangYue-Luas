EcosystemCtrl = BaseClass("EcosystemCtrl",PoolBaseClass)
--生态实体刷新控制器
--用于管理生态实体的刷新
function EcosystemCtrl:__init()
	self.activityTimeArea = {}
	self.historyLoadCondition = {}
end

function EcosystemCtrl:Init(ecosystemCtrlManager, ecosystemConfig, createEntityType, waitCreate, isGm)
	-- 用来获取的位置
	self.clonePosition = Vec3.New()

	self.ecosystemCtrlManager = ecosystemCtrlManager
	self.fight = ecosystemCtrlManager.fight
	self.entityManager = ecosystemCtrlManager.entityManager
	self.npcManager = self.entityManager.npcEntityManager
	self.player = self.fight.playerManager:GetPlayer()

	self.createEntityType = createEntityType

	self.ecosystemConfig = ecosystemConfig

	local radius = math.abs(math.abs(ecosystemConfig.load_radius) - 100) <= 0.5 and 80 or ecosystemConfig.load_radius
	self.loadRadius = radius * radius
	self.unloadRadius = (radius + 5) * (radius + 5)
	if not self:SetBornPosition(isGm) then return end

	-- 这里没有处理旋转信息
	if createEntityType == FightEnum.CreateEntityType.Drop then
		if ecosystemConfig.vecPos then
			self.position = ecosystemConfig.vecPos
		end
	end
	local ecosystemEntityManager = self.entityManager.ecosystemEntityManager
	self.waitCreate = waitCreate
	if ecosystemConfig.default_create == nil then
		self.waitCreate = false
	else
		local change = ecosystemEntityManager:GetEcoEntitySvrCreateState(ecosystemConfig.id)
		self.waitCreate = not ecosystemConfig.default_create
		if change then
			self.waitCreate = ecosystemConfig.default_create
		end
	end

	self.isLoad = false
	self.isLoading = false

	--昼夜系统需求
	self.waitUnLoadTime = 0
	TableUtils.ClearTable(self.activityTimeArea)
	self.ecoType = nil
	self.ecoConfig = nil
	self.inFightDirty = nil
	TableUtils.ClearTable(self.historyLoadCondition)

	self:UpdateTaskOccupy()

	self.initComplete = false
	if createEntityType == FightEnum.CreateEntityType.Ecosystem then
		local ecoId = ecosystemConfig.id
		local cfg, ecoType = ecosystemEntityManager:GetEcoEntityConfig(ecoId)
		self.activityTimeArea = EcoSystemConfig.GetEcoActiveTime(cfg)
		self.ecoConfig = cfg
		self.ecoType = ecoType
		if ecoType == FightEnum.EcoEntityType.Monster then
			local bias, res = ecosystemEntityManager:GetEcoMonsterLevelBias(ecoId)
			if not res then
				self.eventDirty = true
				EventMgr.Instance:AddListener(EventName.EcoMonsterLevBiasUpdate, self:ToFunc("EcoMonsterLevBiasUpdate"))
				mod.WorldFacade:SendMsg("ecosystem_monster_level_bias", ecoId)
				return
			end
		end
	elseif createEntityType == FightEnum.CreateEntityType.Npc then
		local ecoId = ecosystemConfig.id
		local cfg, ecoType = ecosystemEntityManager:GetEcoEntityConfig(ecoId)
		self.activityTimeArea = EcoSystemConfig.GetEcoActiveTime(cfg)
		self.ecoConfig = cfg
		self.ecoType = ecoType
	end
	self:InitComplete()
end

function EcosystemCtrl:EcoMonsterLevBiasUpdate(ecoId)
	if ecoId == self.ecosystemConfig.id then
		self.eventDirty = false
		EventMgr.Instance:RemoveListener(EventName.EcoMonsterLevBiasUpdate, self:ToFunc("EcoMonsterLevBiasUpdate"))
		self:InitComplete()
	end
end

function EcosystemCtrl:InitComplete()
	self.initComplete = true
end

--暂时是事件监听，也可以改到update中
function EcosystemCtrl:CheckInTimeArea()
	if next(self.activityTimeArea) then
		local totalTime, singleTime = DayNightMgr.Instance:GetTime()
		for index, v in ipairs(self.activityTimeArea) do
			if v.startTime <= singleTime and v.endTime >= singleTime then
				local isEnterBorder
				if index == 1 then
					isEnterBorder = v.startTime == singleTime
				end
				return true, isEnterBorder
			end
		end
		local value = self.activityTimeArea[#self.activityTimeArea]
		local isExitBorder = math.abs(singleTime - value.endTime) == 1
		return false, nil, isExitBorder
	end
	return true
end

function EcosystemCtrl:SetBornPosition(isGm)
	local ecosystemConfig = self.ecosystemConfig
	local positionName
	local levelId
	local belongId
	local bindTask = self.npcManager:GetNpcBindTask(ecosystemConfig.id)
	if bindTask then
		local task = mod.TaskCtrl:GetTask(bindTask.taskId)
        if task then
            local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(task.taskId, task.stepId)
			if not occupyCfg then
				return
			end

            for k, v in pairs(occupyCfg.occupy_list) do
                if k == ecosystemConfig.id then
                    levelId = v[3] ~= 0 and v[3] or levelId
					positionName = v[6] ~= "" and v[6] or positionName
					belongId = v[5] ~= "" and v[5] or belongId
					break
                end
            end
        end
	end

	if not isGm then
		if not levelId or not positionName then
			levelId = ecosystemConfig.map_id
			positionName = ecosystemConfig.position[2]
			belongId = ecosystemConfig.position[1]
		end
		-- local mapPos = BehaviorFunctions.GetTerrainPositionP(ecosystemConfig.position[2], ecosystemConfig.position_id, ecosystemConfig.position[1])
		local mapPos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(ecosystemConfig.position_id, positionName, belongId)
		if ecosystemConfig.deadTime then
			--TODO 不知道怎么回事，先加个保底
			mapPos = ecosystemConfig.vecPos or {x = 0, y = 0, z = 0}
		elseif not mapPos then
			LogError("找不到生态出生点信息 :name = "..positionName..", belongId = "..belongId.." levelId = "..ecosystemConfig.position_id)
			return
		end
	
		self.position = Vec3.New(mapPos.x, mapPos.y, mapPos.z)
	else
		self.position = BehaviorFunctions.GetPositionOffsetBySelf(BehaviorFunctions.GetCtrlEntity(), 5, 0)
	end

	return true
end

function EcosystemCtrl:Update(lodCenter)
	if not self.initComplete then return end
	if self.entity and self.entity.transformComponent then
		local position = self.entity.transformComponent:GetPosition()

		self.position.x = position.x
		self.position.y = position.y
		self.position.z = position.z
	end

	if not self.position then return end
	-- 如果是隐藏中的生态实体 那就不进行距离判断
	if self.isLoading or self.waitCreate then
		return
	end

	--这个判断不能被降频
	if self.waitUnLoadTime > 0 then
		self.waitUnLoadTime = self.waitUnLoadTime - FightUtil.deltaTimeSecond
		if self.waitUnLoadTime <= 0 then
			self:Unload()
		else
			return
		end
	end

	--在加载范围并且处于活动时间才能加载
	local inTimeArea, isEnterBorder, isExitBorder = self:IsInTimeArea()
	if self.isLoad then
		local isContain = self:IsContain(self.unloadRadius, lodCenter)
		if not isContain or not inTimeArea then
			self:TryUnload(isContain, inTimeArea, isExitBorder)
		end
	elseif not self.isLoad then
		local isContain = self:IsContain(self.unloadRadius, lodCenter)
		if isContain and inTimeArea then
			self:Load()
		else
			self.historyLoadCondition.isContain = isContain
			self.historyLoadCondition.inTimeArea = inTimeArea
		end
	end
end

function EcosystemCtrl:IsInTimeArea()
	local inTimeArea, isEnterBorder, isExitBorder = self:CheckInTimeArea()
	if self.ecoType == FightEnum.EcoEntityType.Npc then
		local ecoId = self.ecosystemConfig.id
		inTimeArea = inTimeArea or self.npcManager:CheckNpcIsBind(ecoId)
	end
	return inTimeArea, isEnterBorder, isExitBorder
end

--获取距离平方，开方速度慢
function EcosystemCtrl:IsContain(radiusSquare, lodCenter)
	local pos = self.position
	local radiusSquare2 = (pos.x - lodCenter.x) * (pos.x - lodCenter.x) +
				(pos.y - lodCenter.y) * (pos.y - lodCenter.y) + (pos.z - lodCenter.z) * (pos.z - lodCenter.z)
	return radiusSquare2 <= radiusSquare
end

function EcosystemCtrl:Load()
	local loadCount = 2
	local callBack = function()
		loadCount = loadCount - 1
		if loadCount > 0 then
			return
		end
		self.ecosystemCtrlManager:AddInstanceQueue(self)
	end

	local entityId = self.ecosystemConfig.entity_id
	local monsterCfg = Config.DataMonster.Find[entityId]
	if monsterCfg and next(monsterCfg) then
		entityId = monsterCfg.entity_id
	end

	local levelId = self.ecosystemConfig.level_id or 0

	self.isLoading = true
	if levelId ~= 0 then
		loadCount = loadCount + 1
		self.ecosystemCtrlManager.assetsNodeManager:LoadLevel(levelId, callBack)
	end

	self.ecosystemCtrlManager.assetsNodeManager:LoadEntity(entityId, callBack)
	callBack();
end

function EcosystemCtrl:SetEntity(entity)
	self.isLoading = false
	self.isLoad = true
	self.entity = entity
	if not self.entity then
		LogError("create error "..self.ecosystemConfig.entity_id)
	end
	--只有因进入活动时间触发加载时才需要透明变化
	local info = self.historyLoadCondition
	if info.isContain and not info.inTimeArea then
		--local entity = BehaviorFunctions.GetEntity(3)
		entity.clientTransformComponent:SetEntityTranslucent(1)
		entity.clientTransformComponent:SetEntityTranslucent(1, 1.5)
	end
	TableUtils.ClearTable(info)
end

local waitTime = EcoSystemConfig.WaitTime
function EcosystemCtrl:TryUnload(inArea, inTimeArea, isExitBorder)
	--不在范围直接卸载
	if not inArea then
		self:Unload()
		return
	end
	local entity = self.entity
	if self.ecoType == FightEnum.EcoEntityType.Monster then
		--怪物死亡状态不让卸载
		local state = entity.stateComponent:GetState()
		if state == FightEnum.EntityState.Death then
			return
		end
		--怪物有仇恨时不让卸载
		local player = self.player
		if player.fightPlayer:IsFightTarget(entity.instanceId) then
			self.inFightDirty = true
			return
		end
		--只有没有处于仇恨状态的怪物在非时间边界才直接卸载
		if not self.inFightDirty and not isExitBorder then
			self.inFightDirty = false
			self:Unload()
			return
		end
		--免疫受击和伤害
		entity.buffComponent:AddBuff(entity, 900000067)
	elseif not isExitBorder then
		--除了怪物，非时间边界都直接卸载
		self:Unload()
		return
	end

	self.waitUnLoadTime = waitTime
	entity.clientTransformComponent:SetEntityTranslucent(2, waitTime)
	entity:SetWorldInteractState(false)
end

function EcosystemCtrl:Unload()
	self.waitUnLoadTime = 0
	self.isLoading = false
	self.isLoad = false
	if self.entity then
		self.entityManager:RemoveEntity(self.entity.instanceId,true)
		self.entity = nil
	end

	local levelId = self.ecosystemConfig.level_id or 0
	if levelId ~= 0 then
		Fight.Instance.levelManager:RemoveLevel(levelId)
	end
end

function EcosystemCtrl:ChangeCreateState(state)
	self.waitCreate = not state

	-- 不隐藏了就加载 隐藏了就卸载
	if not state then
		self:Unload()
	end
end

function EcosystemCtrl:UpdateTaskOccupy()
	if self.createEntityType ~= FightEnum.CreateEntityType.Npc then
		return
	end

	local occupyTaskInfo = self.npcManager:GetNpcBindTask(self.ecosystemConfig.id)
	if not occupyTaskInfo then
		return
	end

	local task = mod.TaskCtrl:GetTask(occupyTaskInfo.taskId)
	if not task then
		return
	end

	local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(task.taskId, task.stepId)
	if not occupyCfg then
		return
	end

	for k, v in pairs(occupyCfg.occupy_list) do
		if k ~= self.ecosystemConfig.id then
			goto continue
		end

		self:ChangeCreateState(v[2])
		if v[6] ~= "" and v[5] ~= "" then
			local position = BehaviorFunctions.GetTerrainPositionP(v[6], v[4], v[5])
			self:ChangePosition(position)
		end

		::continue::
	end
end

function EcosystemCtrl:ChangePosition(position)
	self.position.x = position.x
	self.position.y = position.y
	self.position.z = position.z
end

function EcosystemCtrl:GetPosition()
	if not self.position then
		return
	end

	self.clonePosition:SetA(self.position)
	return self.clonePosition
end

function EcosystemCtrl:__cache()
	if self.eventDirty then
		self.eventDirty = false
		EventMgr.Instance:RemoveListener(EventName.EcoMonsterLevBiasUpdate, self:ToFunc("EcoMonsterLevBiasUpdate"))
	end
	if self.entity then
		self:Unload()
	end
	--cache
	self.entity = nil
	self.isLoad = false
	self.isLoading = false
	self.position = nil
end

function EcosystemCtrl:__delete()

end
