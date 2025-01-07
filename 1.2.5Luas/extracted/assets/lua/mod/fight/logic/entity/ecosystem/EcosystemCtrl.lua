EcosystemCtrl = BaseClass("EcosystemCtrl",PoolBaseClass)
--生态实体刷新控制器
--用于管理生态实体的刷新
function EcosystemCtrl:__init()

end

function EcosystemCtrl:Init(ecosystemCtrlManager, ecosystemConfig, createEntityType, waitCreate)
	self.ecosystemCtrlManager = ecosystemCtrlManager
	self.fight = ecosystemCtrlManager.fight
	self.entityManager = ecosystemCtrlManager.entityManager

	self.createEntityType = createEntityType

	self.ecosystemConfig = ecosystemConfig
	self.loadRadius = ecosystemConfig.load_radius * ecosystemConfig.load_radius
	self.unloadRadius = (ecosystemConfig.load_radius + 5) * (ecosystemConfig.load_radius + 5)
	if not self:SetBornPosition() then return end

	-- 这里没有处理旋转信息
	if createEntityType == FightEnum.CreateEntityType.Drop then
		if ecosystemConfig.vecPos then
			self.position = ecosystemConfig.vecPos
		end
	end

	self.waitCreate = waitCreate
	if ecosystemConfig.default_create == nil then
		self.waitCreate = false
	else
		local change = self.entityManager.ecosystemEntityManager:GetEcoEntitySvrCreateState(ecosystemConfig.id)
		self.waitCreate = not ecosystemConfig.default_create
		if change then
			self.waitCreate = ecosystemConfig.default_create
		end
	end

	self.isLoad = false
	self.isLoading = false
end

function EcosystemCtrl:SetBornPosition()
	local ecosystemConfig = self.ecosystemConfig
	local MapPos = BehaviorFunctions.GetTerrainPositionP(ecosystemConfig.position[2], nil, ecosystemConfig.position[1])
	if not MapPos then
		LogError("找不到生态出生点信息 :name = "..ecosystemConfig.position[2]..", belongId = "..ecosystemConfig.position[1])
		return
	end
	self.position = Vec3.New(MapPos.x, MapPos.y, MapPos.z)
	return true
end

function EcosystemCtrl:Update()
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

	if self.isLoad then
		if not self:IsContain(self.unloadRadius) then
			self:Unload()
		end
	elseif not self.isLoad then
		if self:IsContain(self.loadRadius) then
			self:Load()
		end
	end
end

--获取距离平方，开方速度慢
function EcosystemCtrl:IsContain(radiusSquare)
	local pos = self.position
	local x,y,z = BehaviorFunctions.GetPosition(self.ecosystemCtrlManager.ctrlEntity)
	local radiusSquare2 = (pos.x - x) * (pos.x - x) + 
	(pos.y - y) * (pos.y - y) + (pos.z - z) * (pos.z - z)
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

	if levelId ~= 0 then
		loadCount = loadCount + 1
		self.ecosystemCtrlManager.assetsNodeManager:LoadLevel(levelId, callBack)
	end

	self.isLoading = true
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
end

function EcosystemCtrl:Unload()
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

function EcosystemCtrl:ChangePosition(position)
	self.position.x = position.x
	self.position.y = position.y
	self.position.z = position.z
end

function EcosystemCtrl:__cache()
	--cache
	self.entity = nil
	self.isLoad = false
	self.isLoading = false
end

function EcosystemCtrl:__delete()

end
