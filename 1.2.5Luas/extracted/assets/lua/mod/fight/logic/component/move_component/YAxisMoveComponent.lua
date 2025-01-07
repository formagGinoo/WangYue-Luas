YAxisMoveComponent = BaseClass("YAxisMoveComponent", PoolBaseClass)

local JumpHurt = Config.EntityCommonConfig.JumpHurt
local YAxisConfig = Config.EntityCommonConfig.JumpParam

function YAxisMoveComponent:__init()
	self.params = {}
end

function YAxisMoveComponent:Init(moveComponent)
    self.moveComponent = moveComponent
    self.fight = moveComponent.fight
    self.entity = moveComponent.entity
    self.transformComponent = self.entity.transformComponent

	self.halfHeight = self.entity.collistionComponent and self.entity.collistionComponent.height * 0.5 or 0
	self.checkRadius = self.entity.collistionComponent and self.entity.collistionComponent.radius * 0.2 or 0

    -- 跳跃参数设置 常量设置
    self.params.speedY = 0
    self.params.gravity = 0
    self.params.accelerationY = 0
    self.params.accelerationTime = 0
    self.params.maxFallSpeed = 0

    -- 额外的累计加速度
    self.addupAcceleration = 0
    self.addupAccelerationBase = 0

    -- 帧事件参数设置
    self.forceParamTable = {}
    self.forceParamTablePool = {}
    self.forceParamInstance = 0
    self.removeInstanceList = {}

    -- 位移使用参数
    self.speed = nil
    self.lastSpeed = 0
    self.useGravity = true
    self.changeSpeed = false

    -- 二段跳状态
    self.doDoubleJump = false
    self.doubleJumpState = false

    -- 滑翔状态
    self.glideState = false
    self.canGlideState = true
    self.glideStarted = false

    self.passDuration = 0

    -- 当前相对地形高度
    self.relativeHeight = 0
    -- 动作高度
    self.animatorHeight = 0
    -- 总动作高度
    self.totalAnimatorHeight = 0
    self.lastTotalAnimatorHeight = 0

    self.cAnimatorHeight = 0
    self.lastCAnimatorHeight = 0
    -- 当前偏移高度
    self.offsetHeight = 0
    -- 当前状态偏移高度
    self.totalOffsetHeight = 0

    -- 撞头了吗
    self.isHitHead = false
    -- 落地了吗
    self.isLand = false

    self.moveStartY = 0
    self.moveDownMaxSpeed = false

    EventMgr.Instance:AddListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
end

function YAxisMoveComponent:ChangeCollistionParam()
	self.halfHeight = self.entity.collistionComponent and self.entity.collistionComponent.height * 0.5 or 0
	self.checkRadius = self.entity.collistionComponent and self.entity.collistionComponent.radius * 0.2 or 0
end

function YAxisMoveComponent:SetConfig(paramTable, changeSpeed)
    for k, v in pairs(paramTable) do
        if self.params[k] ~= nil then
            self.params[k] = v
        end
    end

    self.changeSpeed = changeSpeed
    self.moveStartY = self.entity.transformComponent:GetRealPositionY()
end

function YAxisMoveComponent:AddForceParam(paramTable, changeSpeed)
    local origin
    if next(self.forceParamTablePool) then
        origin = table.remove(self.forceParamTablePool)
        for k, v in pairs(self.params) do
            origin[k] = v
        end
    else
        origin = UtilsBase.copytab(self.params)
    end

    for k, v in pairs(paramTable) do
        origin[k] = v
    end

    self.forceParamInstance = self.forceParamInstance + 1
    self.changeSpeed = changeSpeed
    origin.instanceId = self.forceParamInstance
    table.insert(self.forceParamTable, origin)
end

function YAxisMoveComponent:RemoveForceParam(instanceId)
    if not instanceId then
        return
    end

    for i = 1, #self.forceParamTable do
        if self.forceParamTable[i].instanceId == instanceId then
            local t = table.remove(self.forceParamTable, i)
            table.insert(self.forceParamTablePool, t)
            break
        end
    end
end

function YAxisMoveComponent:SetDoubleJumpState(state)
    self.doubleJumpState = state
end

function YAxisMoveComponent:SetGlideState(state, glideEnd)
    self.glideState = state
    if state then
        self.glideStarted = true
    elseif glideEnd then
        self.glideStarted = false
    end
end

function YAxisMoveComponent:SetGravityState(state)
    self.useGravity = state
end

function YAxisMoveComponent:SetAddupAcceleration(baseAcceleration)
    self.addupAcceleration = 0
    self.addupAccelerationBase = baseAcceleration
end

function YAxisMoveComponent:ResetAddupAcceleration()
    self.addupAcceleration = 0
    self.addupAccelerationBase = 0
end

function YAxisMoveComponent:CheckHasAddupAcceleration()
    return self.addupAccelerationBase ~= 0
end

function YAxisMoveComponent:BeforeUpdate()
    if self.isLand then
        self:OnLand()
    end
end

function YAxisMoveComponent:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    local moveY = 0

    self.passDuration = self.passDuration + time

    local param = self.params
    if next(self.forceParamTable) then
        for i = 1, #self.forceParamTable do
            if self.forceParamTable[i].duration then
                self.forceParamTable[i].duration = self.forceParamTable[i].duration - (1 * self.entity.timeComponent:GetTimeScale())
                if self.forceParamTable[i].duration <= 0 then
                    table.insert(self.removeInstanceList, self.forceParamTable[i].instanceId)
                end
            end
        end

        param = self.forceParamTable[#self.forceParamTable]
    elseif self.params.accelerationTime > 0 then
        self.params.accelerationTime = self.params.accelerationTime - time
        self.params.accelerationY = (self.params.accelerationTime <= 0) and 0 or self.params.accelerationY
    end

    if self.addupAccelerationBase and self.addupAccelerationBase ~= 0 then
        self.addupAcceleration = self.addupAcceleration + self.addupAccelerationBase
    end

    if not self.speed or self.changeSpeed then
        self.changeSpeed = false
        self.speed = param.speedY
    end

    moveY = self.animatorHeight + (self.speed * time)

    if self.entity.partComponent then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
    end

    local position = self.transformComponent:GetPosition()
    if moveY <= 0 then
		position.y = position.y + self.halfHeight + self.checkRadius
		local checkOffset = moveY - self.halfHeight
        local offsetY, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
		if check then
			offsetY = offsetY + self.halfHeight + self.checkRadius --多出来的偏移有半个高度+半径
			self.isLand = time ~= 0
			moveY = offsetY
		end
    else
		position.y = position.y + self.halfHeight - self.checkRadius
		local checkOffset = moveY + self.halfHeight
        local offsetY, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
		if check then
			offsetY = offsetY - self.halfHeight - self.checkRadius --多出来的偏移有半个高度+半径
			self.isHitHead = time ~= 0
			moveY = offsetY
		end
    end

    self.animatorHeight = 0
    self.offsetHeight = moveY
    self.totalOffsetHeight = self.totalOffsetHeight + self.offsetHeight
    self:CalculateSpeed(time, param)

    if self.entity.partComponent then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.Entity)
    end
end

function YAxisMoveComponent:AfterUpdate()
    for k, v in pairs(self.removeInstanceList) do
        self:RemoveForceParam(v)
    end

    TableUtils.ClearTable(self.removeInstanceList)
    self.entity.transformComponent:SetPositionOffsetY(self.offsetHeight)

    if self.isHitHead then
        self:OnHitHead()
    end
end

function YAxisMoveComponent:ResetClientAnimatorHeight()
    self.cAnimatorHeight = 0
    self.lastCAnimatorHeight = 0
end

function YAxisMoveComponent:SetAnimatorMove(animatorY)
    self.animatorHeight = self.animatorHeight + animatorY
    self.lastTotalAnimatorHeight = self.totalAnimatorHeight
    self.totalAnimatorHeight = self.totalAnimatorHeight + animatorY

    self.lastCAnimatorHeight = self.lastTotalAnimatorHeight
    self.cAnimatorHeight = self.totalAnimatorHeight
end

function YAxisMoveComponent:ResetAnimatorMove()
	-- self.entity.transformComponent:SetPositionOffsetY(-self.totalAnimatorHeight)
    self.animatorHeight = 0
    self.lastTotalAnimatorHeight = 0
    self.totalAnimatorHeight = 0
end

function YAxisMoveComponent:CalculateSpeed(time, params)
    local useGravity = self.useGravity
    if params.useGravity ~= nil and useGravity then
        useGravity = params.useGravity
    end

    local gravity = useGravity and params.gravity or 0
    local acc = params.accelerationY + gravity + self.addupAcceleration

    if self.speed < params.maxFallSpeed then
        self.speed = params.maxFallSpeed
        self.moveDownMaxSpeed = true
    elseif self.speed > params.maxFallSpeed then
        self.speed = self.speed + (acc * time)
    end
end

function YAxisMoveComponent:OnHitHead()
    self.isHitHead = false
end

function YAxisMoveComponent:OnLand()
    self.moveComponent:SetAloft(false)
    self.isLand = false
    self.isHitHead = false
    self.useGravity = true
    self.doubleJumpState = false
	self.passDuration = 0
    self.offsetHeight = 0
    self.totalOffsetHeight = 0
    self:ResetAnimatorMove()
    self:ResetAddupAcceleration()

    self.lastSpeed = self.speed
    self.speed = nil
    for k, v in pairs(self.params) do
        self.params[k] = 0
    end

    for i = #self.forceParamTable, 1, -1 do
        self:RemoveForceParam(self.forceParamTable[i].instanceId)
    end

    if self.entity.behaviorComponent then
        self.fight.entityManager:CallBehaviorFun("OnLand", self.entity.instanceId)
    end
end

function YAxisMoveComponent:GetSpeed()
    local speed = self.speed
    if not speed then
        -- LogError("YAxisMoveComponent SPEED = nil")
        speed = 0
    end

    return speed
end

function YAxisMoveComponent:GetEndSpeed()
    return self.lastSpeed
end

function YAxisMoveComponent:GetOffsetHeight()
    return self.totalOffsetHeight
end

function YAxisMoveComponent:GetPassDuration()
    return self.passDuration
end

function YAxisMoveComponent:CheckDoDoubleJump()
    return self.doDoubleJump
end

function YAxisMoveComponent:GetDoubleJumpState()
    return self.doubleJumpState
end

function YAxisMoveComponent:GetGlideState()
    return self.glideState
end

function YAxisMoveComponent:GetObstaclesOverHead(offsetY)
    local position = self.transformComponent:GetPosition()
	position.y = position.y + self.halfHeight - self.checkRadius
	local checkOffset = offsetY + self.halfHeight
	local offsetY, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
	return offsetY - self.halfHeight - self.checkRadius, check
end

function YAxisMoveComponent:CanDoubleJump()
    if self.doubleJumpState then
        return false
    end

    local statesMachine = self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Jump].jumpFSM.statesMachine
    if not statesMachine:CanDoubleJump() or self:GetPassDuration() < YAxisConfig.DoubleJumpNeedTime then
        return false
    end

    local overHeadBlock, check = self:GetObstaclesOverHead(YAxisConfig.DoubleJumpStartHeight)
    if check and math.floor(YAxisConfig.DoubleJumpStartHeight * 10000) - math.floor(overHeadBlock * 10000) > 500 then
        return false
    end

	local position = self.transformComponent:GetPosition()
	position.y = position.y + self.halfHeight + self.checkRadius
	local checkOffset = -(YAxisConfig.DoubleJumpNeedHeight + self.halfHeight)
    local height, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
	if check then
		height = height + self.halfHeight + self.checkRadius
	    if math.floor((YAxisConfig.DoubleJumpNeedHeight - self.halfHeight) * 10000) - math.floor(height * 10000) > 500 then
	        return false
	    end
	end

    return true
end

function YAxisMoveComponent:CanGlide()
    if mod.WorldMapCtrl:CheckIsDup() then

    elseif not self.fight.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Fly) or self.glideState or not self.canGlideState then
        return false
    end

    if not self.moveComponent.config.canGlide then
        return
    end

    if self:GetPassDuration() < YAxisConfig.DoubleJumpNeedTime then
        return false
    end

    if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurStaminaValue) <= 0 then
        return false
    end

    if not self.glideStarted then
        local position = self.transformComponent:GetPosition()
        position.y = position.y + self.halfHeight + self.checkRadius
        local checkOffset = -(self.moveComponent.config.GlideHeight + self.halfHeight)
        local height, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
        if check then
            height = height + self.halfHeight + self.checkRadius
            if math.floor((self.moveComponent.config.GlideHeight - self.halfHeight) * 10000) - math.floor(height * 10000) > 500 then
                return false
            end
        end
    end

    return true
end

function YAxisMoveComponent:SetCanGlideState(state)
    self.canGlideState = state
end

function YAxisMoveComponent:OnCache()
	TableUtils.ClearTable(self.params)
    self.fight.objectPool:Cache(YAxisMoveComponent, self)
end

function YAxisMoveComponent:OnHardLandHurt(isMonster)
    if self.moveStartY == 0 then
        return
    end

    if self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneDownDmg) then
        return
    end

    local endMoveY = self.entity.transformComponent:GetRealPositionY()
    local jumpHeight = self.moveStartY - endMoveY
    local heightDist = jumpHeight - JumpHurt.CheckHeightHurt
    if heightDist > 0 then
        local hurtLife 
        if self.moveDownMaxSpeed then
            local maxLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
            local percent = math.min(JumpHurt.PercentHeightHurt + math.floor(heightDist * 10) * JumpHurt.HeightHurtParam, 100)
            hurtLife = maxLife * percent / 100
            if isMonster then
                hurtLife = hurtLife * 2
            end
        end
        if self.entity.masterId then
            hurtLife = hurtLife - hurtLife * BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.FallDamageReductionPercent)
        end

        self.entity.attrComponent:AddValue(EntityAttrsConfig.AttrType.Life, -hurtLife)
    end

    self.moveStartY = 0
end

function YAxisMoveComponent:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
end

function YAxisMoveComponent:__cache()
    self:RemoveListener()
end

function YAxisMoveComponent:__delete()
    self:RemoveListener()
end