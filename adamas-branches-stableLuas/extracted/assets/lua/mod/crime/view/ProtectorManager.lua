ProtectorManager = BaseClass("ProtectorManager")

function ProtectorManager:__init(fight)
	self.fight = fight
    self.clientFight = fight.clientFight
    self.ecosystemCtrlManager = Fight.Instance.entityManager.ecosystemCtrlManager
    self.ecosystemEntityManager = Fight.Instance.entityManager.ecosystemEntityManager
    self.bountyValue = mod.CrimeCtrl:GetBountyValue()
    self.bountyStar = mod.CrimeCtrl:GetBountyStar()
    self.protectorMap = {}

    self.createProtectorMap = {}

    self.waitForCreateList = {}

    self:InitData()
    self:BindListener()
end

function ProtectorManager:BindListener()
    EventMgr.Instance:AddListener(EventName.OnBountyValueChange, self:ToFunc("BountyValueChange"))
    EventMgr.Instance:AddListener(EventName.OnDoDamage, self:ToFunc("TriggerDamage"))
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("RemoveEntity"))
    EventMgr.Instance:AddListener(EventName.OutPrison,self:ToFunc("OutPrison"))
end

function ProtectorManager:__delete()
    self.protectorMap = nil

    self.createProtectorMap = nil

    self.waitForCreateList = nil
end

function ProtectorManager:Update()
    if mod.CrimeCtrl:CheckInPrison() then return end 
    for k, v in pairs(self.waitForCreateList) do
        if self:CreateProtetor(v) then
            self.waitForCreateList[k] = nil
        end
    end
end

function ProtectorManager:InitData()
    if self.bountyStar > 1 then
        for i = 2, self.bountyStar, 1 do
            table.insert(self.waitForCreateList,i)
        end
    end
end

function ProtectorManager:AddCreateProtetor(type)
    table.insert(self.waitForCreateList,type)
end

-- 创建守卫
function ProtectorManager:CreateProtetor(type)
    -- 先找附近的生态守卫
    local instanceId = self:FindNearEcoProtector()
    if instanceId then
        self.protectorMap[instanceId] = 1
        return true
    end

    local pos = self:GetChasePointPos()
    if pos then
        local lv = self:GetProtectorLv()
        local config = CrimeConfig.GetProtectConfig(self.bountyValue)
        local instanceId = BehaviorFunctions.CreateEntity(config.entity_id,nil,pos.x,pos.y,pos.z,nil,nil,nil,nil,lv)
        self.protectorMap[instanceId] = type
        return true
    end
    return false
end

-- 用于在受到守卫的最后一击时进监狱
function ProtectorManager:TriggerDamage(atkInstanceId, hitInstanceId)
    local tempEntity = BehaviorFunctions.GetEntity(atkInstanceId)
    local atkEntity = tempEntity.root
    if not self:IsProtectorEntity(atkEntity.sInstanceId) then
        return
    end

    local hitEntity = BehaviorFunctions.GetEntity(hitInstanceId)
    if not hitEntity.tagComponent or hitEntity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.Player then
        return
    end

    local player = Fight.Instance.playerManager:GetPlayer()
    -- 检查当前编队角色是否全部死亡
    local entityMap = player:GetEntityMap()
    for _, data in pairs(entityMap) do
        local entity = BehaviorFunctions.GetEntity(data.InstanceId)
        local isDeath = entity.stateComponent:IsState(FightEnum.EntityState.Death) and entity.stateComponent.stateFSM:CheckDeathAnimState()
        if not isDeath then
            return
        end
    end
    BehaviorFunctions.GoPrison()
end

function ProtectorManager:SetPlayersMaxHp()
    local player = Fight.Instance.playerManager:GetPlayer()
    --获取整个编队
    local entityList = player:GetEntityMap()
    for _, v in pairs(entityList) do
        local entity = BehaviorFunctions.GetEntity(v.InstanceId)
        entity:Revive()
    end
end

-- 获取守卫等级，动态获取
function ProtectorManager:GetProtectorLv()
    local info = mod.WorldLevelCtrl:GetAdventureInfo()
    local curLv = info.lev
    local bountyVal = mod.CrimeCtrl:GetBountyValue()
    local correctLv = CrimeConfig.GetProtectLvModify(bountyVal)
    local level = curLv + correctLv
    return level
end

-- 判断对应sInstanceI实体是否为守卫
function ProtectorManager:IsProtectorEntity(sInstanceId)
    if self.protectorMap[sInstanceId] then
        return true
    end
    return false
end

-- 更新悬赏星级
function ProtectorManager:BountyValueChange()
    self.bountyValue = mod.CrimeCtrl:GetBountyValue()
    local star = mod.CrimeCtrl:GetBountyStar()
    if self.bountyStar ~= star then
        self:AddCreateProtetor(star)
        self.bountyStar = star
    end
    
end

-- 获取追击点位
function ProtectorManager:GetChasePointPos()
    local ctrlEntity = BehaviorFunctions.fight.entityManager.ecosystemCtrlManager.ctrlEntity
    -- 角色的位置
	local rolePos = BehaviorFunctions.GetPositionP(ctrlEntity)
    
    -- 在50-100的范围内随机半径
	local val = math.random(10, 20)

	local newPos
	local Vec3Pos = Vec3.New()

	local circlePos = Random.insideUnitCircle * val
	Vec3Pos.x = circlePos.x
	Vec3Pos.y = circlePos.y
	Vec3Pos.z = 0

	local len = Vec3.Magnitude(Vec3Pos)

	-- 取到的点
	local randomPos = Vec3Pos:Normalize() * (val + len)

	-- 相对于角色的位置点
	newPos = randomPos + rolePos

	-- 保证这个点合法
	if not self:CheckPosLegal(rolePos, newPos) then
		return
	end

	-- 采样
	local x, y, z, isOk = CustomUnityUtils.GetNavmeshRandomPos(newPos.x, newPos.y, newPos.z, val)
	if not isOk then
        return 
    end
	Vec3Pos.x = x
	Vec3Pos.y = y
	Vec3Pos.z = z

	-- 路径
	if not self:CheckPosNav(Vec3Pos) then
        return 
	end

	return Vec3Pos
end

function ProtectorManager:CheckPosLegal(playerPos, pos)
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

-- 检查点位是否可以寻路到玩家
function ProtectorManager:CheckPosNav(pos)
	local curMapId = Fight.Instance:GetFightMap()

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

-- 守卫被击杀（重新创建）
function ProtectorManager:RemoveEntity(instanceId)
    if self.protectorMap[instanceId] then
        self:AddCreateProtetor(self.protectorMap[instanceId])
        self.protectorMap[instanceId] = nil
    end
end

function ProtectorManager:GetProtectorType(instanceId)
    return self.protectorMap[instanceId] and self.protectorMap[instanceId] or 0
end

function ProtectorManager:FindNearEcoProtector()
    return self.ecosystemEntityManager:GetNearProtector()
end

function ProtectorManager:OutPrison()
    self.waitForCreateList = {}
end