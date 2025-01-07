MercenaryEcoCtrl = BaseClass("MercenaryEcoCtrl",PoolBaseClass)


function MercenaryEcoCtrl:__init()
end

function MercenaryEcoCtrl:InitData(ecoCtrlMgr, ecoId)
    self.ecoCtrlMgr = ecoCtrlMgr
    self.ecoId = ecoId
    local ecosystemConfig = MercenaryHuntConfig:GetMercenaryEcoConfig(ecoId)
    self.ecosystemConfig = ecosystemConfig
	self.entityManager = BehaviorFunctions.fight.entityManager
    self.ecosystemEntityManager = self.entityManager.ecosystemEntityManager
    self.ecosystemCtrlManager = self.entityManager.ecosystemCtrlManager
    self.mercenaryMgr = Fight.Instance.mercenaryHuntManager

	self.transfirstPos = nil
    self:SetBornPosition()
	self:SetLevel(mod.MercenaryHuntCtrl:GetMercenaryData(ecoId).level)
	self:InitTransfirstPos()

    self.discoverRadius = ecosystemConfig.discover_radius * ecosystemConfig.discover_radius
    self.chaseRadius = MercenaryHuntConfig.ChaseRadius * MercenaryHuntConfig.ChaseRadius
    self.nearbyRadius = MercenaryHuntConfig.NearbyRadius * MercenaryHuntConfig.NearbyRadius
    self.mercenaryChaseData = {
        isChasePos = false, -- 是否找到了追击传送点
        cd = 0,
        isStartChase = false, -- 这个是决定是否开始获取传送点
    }

    self.chaseMaxRadius = MercenaryHuntConfig.ChaseMaxRadius * MercenaryHuntConfig.ChaseMaxRadius
    self.chaseMinRadius = MercenaryHuntConfig.ChaseMinRadius * MercenaryHuntConfig.ChaseMinRadius
	
    -- 处于追击状态
    self.mercenaryChaseData.isChase = self.mercenaryMgr:IsMercenaryChase(ecosystemConfig.id)
end

function MercenaryEcoCtrl:SetLevel(level)
	self.level = level
end

function MercenaryEcoCtrl:SetBornPosition()
	local ecosystemConfig = self.ecosystemConfig
	local mapPos = BehaviorFunctions.GetTerrainPositionP(ecosystemConfig.position[2], ecosystemConfig.map_id, ecosystemConfig.position[1])
	if not mapPos then
		LogError("找不到生态出生点信息 :name = "..ecosystemConfig.position[2]..", belongId = "..ecosystemConfig.position[1])
		return
	end
    -- 这样写是为了防止有别的地方改了这个mappos
    self.position = {}
	self.position.x = mapPos.x
	self.position.y = mapPos.y
	self.position.z = mapPos.z
    self.position.rotX = mapPos.rotX
    self.position.rotY = mapPos.rotY
    self.position.rotZ = mapPos.rotZ
    self.position.rotW = mapPos.rotW
end

function MercenaryEcoCtrl:Update()
    self:UpdateMercenaryChaseRadius()
    self:UpdateMercenaryChaseCD()

    local ecoId = self.ecosystemConfig.id
    -- 发现佣兵
    if self:IsContain(self.discoverRadius) then
        self.mercenaryMgr:DiscoverMercenary(ecoId)
    end

    -- 佣兵是否在玩家附近
    if self:IsContain(self.nearbyRadius) then
        self.mercenaryMgr:NearbyMercenary(ecoId)
    else
        self.mercenaryMgr:ClearNearbyMercenary(ecoId)
    end

    if not self:IsContain(30, true) then
        self.mercenaryMgr:ClearChaseRadius(ecoId)
    end
end

--获取距离平方，开方速度慢
function MercenaryEcoCtrl:IsContain(targetDis, isVec3Dis)
    local entity = self:GetEntity()
	local pos = self.position
    if entity and entity.transformComponent then
        pos = entity.transformComponent:GetPosition()
		self.position.x = pos.x
		self.position.y = pos.y
		self.position.z = pos.z
    end
	local rolePos = BehaviorFunctions.GetPositionP(self.ecosystemCtrlManager.ctrlEntity)
	
	if isVec3Dis then
		local distance = Vec3.Distance(pos, rolePos)
		return distance < targetDis
	end
	return UtilsBase.IsPosContain(pos, rolePos, targetDis)
end

function MercenaryEcoCtrl:IsMercenaryChase()
	local chaseData = self.mercenaryChaseData
	if not chaseData then return end
	return chaseData.isChase
end

function MercenaryEcoCtrl:GetEntity()
    local entity = self.ecosystemEntityManager:GetEcoEntity(self.ecosystemConfig.id)
    return entity
end

function MercenaryEcoCtrl:UpdateMercenaryChaseState(isStart)
    local ecoId = self.ecosystemConfig.id
	local chaseData = self.mercenaryChaseData
	chaseData.isStartChase = isStart
	chaseData.isChase = self.mercenaryMgr:IsMercenaryChase(ecoId)

	if isStart and not chaseData.isChasePos then
		self:GetMercenaryChasePointPos()
	elseif not isStart and chaseData.isChasePos then
		chaseData.isChasePos = false
		-- 回到出生点，等待下一次开始追击
		self:SetBornPosition()
        local entity = self:GetEntity()
		if entity then
			entity.transformComponent:SetPosition(self.position.x, self.position.y, self.position.z)
		end
        self:UpdateEcoCtrlPos()
	end
end

function MercenaryEcoCtrl:UpdateMercenaryChaseRadius()
	local chaseData = self.mercenaryChaseData
	if not chaseData.isChasePos then return end
	if not self:IsContain(self.chaseRadius) then
		chaseData.isChasePos = false
		self:UpdateMercenaryChaseState(true)
	end
end

-- 佣兵追击采样cd
function MercenaryEcoCtrl:UpdateMercenaryChaseCD()
	local chaseData = self.mercenaryChaseData
	if not chaseData.isChase or not chaseData.isStartChase or chaseData.isChasePos then return end
	if chaseData.cd <= 0 then return end
	chaseData.cd = chaseData.cd - Time.deltaTime
	if chaseData.cd <= 0 then
		self:GetMercenaryChasePointPos()
	end
end

function MercenaryEcoCtrl:GetMercenaryChasePointPos()
	local chaseData = self.mercenaryChaseData
	chaseData.cd = MercenaryHuntConfig.ChaseCD
	
	-- 非追击状态/已经找到传送点
	if not chaseData.isChase or chaseData.isChasePos then return end

	-- 出生点即满足
	if self:CheckBornPosChase() then
		chaseData.isChasePos = true
		return
	end

	local ctrlEntity = self.ecosystemCtrlManager.ctrlEntity
	-- 角色的位置
	local rolePos = BehaviorFunctions.GetPositionP(ctrlEntity)
	-- 在50-100的范围内随机半径
	local val = math.random(MercenaryHuntConfig.ChaseMinRadius, MercenaryHuntConfig.ChaseMaxRadius)

	local newPos
	local Vec3Pos = Vec3.New()

	if self.transfirstPos then
		newPos = Vec3.New()
		newPos.x = self.transfirstPos.x
		newPos.y = self.transfirstPos.y
		newPos.z = self.transfirstPos.z
		local radius = UtilsBase.GetPosRadius(rolePos, newPos)
		if radius > self.chaseMaxRadius then
			newPos = nil
		end
	end

	if not newPos then

		local circlePos = Random.insideUnitCircle * val
		Vec3Pos.x = circlePos.x
		Vec3Pos.y = circlePos.y
		Vec3Pos.z = 0

		local len = Vec3.Magnitude(Vec3Pos)
	
		-- 取到的点
		local randomPos = Vec3Pos:Normalize() * (val + len)

		-- 相对于角色的位置点
		newPos = randomPos + rolePos
	end

	-- 判断这个点是否合法
	if not self:CheckPosLegal(rolePos, newPos) then
		return
	end

	-- 采样
	local x, y, z, isOk = CustomUnityUtils.GetNavmeshRandomPos(newPos.x, newPos.y, newPos.z, val)
	if not isOk then return end
	Vec3Pos.x = x
	Vec3Pos.y = y
	Vec3Pos.z = z

	-- 路径
	if not self:CheckMercenaryNav(Vec3Pos) then
		return
	end

	if self:SetEntityPos(x, y, z) then
		chaseData.isChasePos = true
		self.position.x = x
		self.position.y = y
		self.position.z = z
	end
end

function MercenaryEcoCtrl:InitTransfirstPos()
	self.transfirstPos = nil
	local ecosystemConfig = self.ecosystemConfig
	local name, mapId, belongId
	
	if ecosystemConfig.transfirst_map_id and ecosystemConfig.transfirst_map_id ~= 0 then
		mapId = ecosystemConfig.transfirst_map_id
	end
	
	local transfirstPosition = ecosystemConfig.transfirst_position
	if transfirstPosition and #transfirstPosition > 0 then
		name = transfirstPosition[2]
		belongId = transfirstPosition[1]
	end

	if not name or not belongId then return end

	local mapPos = BehaviorFunctions.GetTerrainPositionP(name, mapId, belongId)
	if not mapPos then return end
	self.transfirstPos = mapPos
end

function MercenaryEcoCtrl:SetEntityPos(x, y, z)
	local pos = {x = x, y = y, z = z}
	local isSetOk = self:UpdateEcoCtrlPos(pos)
	local entity = self:GetEntity()
	if entity then
		entity.transformComponent:SetPosition(x, y, z)
		isSetOk = true
	end

	return isSetOk
end

function MercenaryEcoCtrl:UpdateEcoCtrlPos(pos)
    local ecoId = self.ecosystemConfig.id
    local ecoCtrl = self.ecosystemCtrlManager:GetEcosystemCtrl(ecoId)
	-- 这里的ctrl对象可能在下一帧才会创建出来
    if ecoCtrl then
        ecoCtrl:ChangePosition(pos or self.position)
		return true
    end

	return false
end

function MercenaryEcoCtrl:CheckMercenaryNav(pos)
	local curMapId = Fight.Instance:GetFightMap()
	-- 检查这个点所在的区域是否可以i用于佣兵的传送/追击
	local forbidAreaCfg = MercenaryHuntConfig.GetForbidHuntArea(curMapId)
	if forbidAreaCfg then
		for _, area_id in pairs(forbidAreaCfg) do
			if BehaviorFunctions.CheckPointInArea(pos, area_id, FightEnum.AreaType.Mercenary, curMapId) then
				return
			end
		end
	end

	local rolePos = BehaviorFunctions.GetPositionP(self.ecosystemCtrlManager.ctrlEntity)
	local posArray, count = CustomUnityUtils.NavCalculatePath(pos, rolePos, 1)
	if count <= 0 then
		return false
	end

	local lastPos = posArray[count - 1]
	if Vec3.SquareDistance(lastPos, rolePos) > 1 then
		return false
	end

	return true
end

function MercenaryEcoCtrl:CheckBornPosChase()
	if not self:IsContain(self.chaseRadius) then
		return
	end

	if not self:CheckMercenaryNav(self.position) then
		return
	end

	return true
end

function MercenaryEcoCtrl:CheckPosLegal(playerPos, pos)
	-- 高度差
	if math.abs(pos.y - playerPos.y) > 10 then
		return
	end
	-- 检查第一个碰撞对象层级
	local _, haveGround, _ = Fight.Instance.physicsTerrain:CheckTerrainHeight(playerPos)
	if not haveGround then
		return
	end

	return true
end

function MercenaryEcoCtrl:CheckMercenaryChasePos()
    local entity = self:GetEntity()
	if not entity then return end
	if not self.mercenaryChaseData then return end
	return 	self.mercenaryChaseData.isChasePos
end

function MercenaryEcoCtrl:GetPosition()
	return self.position
end