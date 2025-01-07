YAxisMoveComponent = BaseClass("YAxisMoveComponent", PoolBaseClass)

local JumpHurt = Config.EntityCommonConfig.JumpHurt
local YAxisConfig = Config.EntityCommonConfig.JumpParam

function YAxisMoveComponent:__init()
	self.params = {}
	self.flyParams = {}
end

function YAxisMoveComponent:Init(moveComponent)
    self.moveComponent = moveComponent
    self.fight = moveComponent.fight
    self.entity = moveComponent.entity
    self.transformComponent = self.entity.transformComponent

	self.halfHeight = self.entity.collistionComponent and self.entity.collistionComponent.height * 0.5 or 0
	self.checkRadius = self.entity.collistionComponent and self.entity.collistionComponent.worldRadius or 0.5
    -- 跳跃参数设置 常量设置
    self.params.speedY = 0
    self.params.gravity = 0
    self.params.accelerationY = 0
    self.params.accelerationTime = 0
    self.params.maxFallSpeed = 0

    
    -- 飞行参数设置 常量设置
    self.flyParams.speedY = 0
    self.flyParams.gravity = 0
    self.flyParams.accelerationY = 0
    self.flyParams.accelerationTime = 0
    self.flyParams.maxFallSpeed = 0

    -- 风场用的参数 后续优化 TODO
    self.gliderAcc = nil
    self.gliderMaxUpSpeed = nil
    self.gliderMaxHeight = nil
    self.relativeGround = false
    self.groundEntity = nil
    self.gliderOffset = nil

    -- 额外的累计加速度
    self.addupAcceleration = 0
    self.addupAccelerationBase = 0

    -- Magic用的修改重力参数等 直接叠加
    self.additionGravity = 0
    self.additionMaxFallSpeed = 0
    -- Magic用的修改重力参数 覆盖
    self.coverGravity = nil
    self.coverMaxFallSpeed = nil
    -- Magic用修改跳跃参数 覆盖
    self.coverJumpUpSpeed = nil
    self.coverJumpAcc = nil

    -- 帧事件参数设置
    self.forceParamTable = {}
    self.forceParamInstance = 0
    self.removeInstanceList = {}

    -- 位移使用参数
    self.speed = nil
    self.lastSpeed = 0
    self.useGravity = true
    self.changeSpeed = false
	self.flyChangeSpeed = false

    -- 二段跳状态
    self.doDoubleJump = false
    self.doubleJumpState = false

    -- 滑翔状态
    self.glideState = false
    self.canGlideState = true
    self.glideStarted = false

    self.passDuration = 0
    -- 水平速度 有些可能需要在落地的时候把水平位移停止的 就在这里做update
    self.speedZ = 0
    self.accZ = 0
    self.durationZ = 0
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

function YAxisMoveComponent:SetFlyConfig(paramTable, flyChangeSpeed)
    for k, v in pairs(paramTable) do
        if self.flyParams[k] ~= nil then
            self.flyParams[k] = v
        end
    end

    self.flyChangeSpeed = flyChangeSpeed
    self.moveStartY = self.entity.transformComponent:GetRealPositionY()
end

function YAxisMoveComponent:ClearFlyConfig()
    for k, v in pairs(self.flyParams) do
        self.flyParams[k] = 0
    end

    self.moveStartY = 0
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

function YAxisMoveComponent:ClearConfig(changeSpeed)
    for k, v in pairs(self.params) do
        self.params[k] = 0
    end

    self.changeSpeed = changeSpeed
    self.moveStartY = 0
end

function YAxisMoveComponent:AddForceParam(paramTable, changeSpeed)
    local origin = UtilsBase.copytab(self.params)
    for k, v in pairs(paramTable) do
        origin[k] = v
    end

    self.forceParamInstance = self.forceParamInstance + 1
    self.changeSpeed = changeSpeed
    origin.instanceId = self.forceParamInstance
    table.insert(self.forceParamTable, origin)

    return self.forceParamInstance
end

function YAxisMoveComponent:RemoveForceParam(instanceId)
    if not instanceId then
        return
    end

    for i = 1, #self.forceParamTable do
        if self.forceParamTable[i].instanceId == instanceId then
            self.changeSpeed = not self.forceParamTable[i].saveSpeed
            table.remove(self.forceParamTable, i)
            break
        end
    end
end

function YAxisMoveComponent:SetGliderConfig(accParam, maxUpSpeed, maxHeight, relativeGround, groundEntity, offset)
    self.gliderAcc = accParam
    self.gliderMaxUpSpeed = maxUpSpeed
    self.gliderMaxHeight = maxHeight
    self.relativeGround = relativeGround or false
    self.groundEntity = groundEntity
    self.gliderOffset = offset
end

function YAxisMoveComponent:SetDoubleJumpState(state)
    self.doubleJumpState = state
end

function YAxisMoveComponent:SetDoDoubleJump(state)
    self.doDoubleJump = state
end

function YAxisMoveComponent:SetGlideState(state, glideEnd)
    self.glideState = state
    if state then
        self.glideStarted = true
    elseif glideEnd then
        self.glideStarted = false
    end

    self.moveComponent:SetAloft(state)
end

function YAxisMoveComponent:SetGravityState(state)
    self.useGravity = state
end

function YAxisMoveComponent:SetAdditionParam(params)
    self.additionGravity = self.additionGravity + params.gravity
    self.additionMaxFallSpeed = self.additionMaxFallSpeed + params.FSM
    self.aRemoveWhenLand = params.RemoveWhenLand
end

function YAxisMoveComponent:SetCoverParam(params)
    self.coverGravity = params.gravity
    self.coverMaxFallSpeed = params.FSM
    self.cRemoveWhenLand = params.RemoveWhenLand
end

function YAxisMoveComponent:SetCoverJumpUpSpeed(speed)
    self.coverJumpUpSpeed = speed
end

function YAxisMoveComponent:SetCoverJumpAcc(acc)
    self.coverJumpAcc = acc
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

end

function YAxisMoveComponent:Update()
    local timeScale = self.entity.timeComponent:GetTimeScale()
    timeScale = timeScale > 1 and 1 or timeScale
    local time = FightUtil.deltaTimeSecond * timeScale
    local moveY = 0

    self.passDuration = self.passDuration + time

    local param = self.params
    if next(self.forceParamTable) then
        for i = 1, #self.forceParamTable do
            if self.forceParamTable[i].duration then
                self.forceParamTable[i].duration = self.forceParamTable[i].duration - timeScale
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
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)
    end

    moveY = self:CheckYBySphere(moveY,time)

    self.animatorHeight = 0
    self.offsetHeight = moveY
    self.totalOffsetHeight = self.totalOffsetHeight + self.offsetHeight
    self:CalculateSpeed(time, param)

    if self.entity.partComponent then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.Entity)
    end

    -- 落地就不走Y轴的平面速度了
    if self.speedZ ~= 0 and not self.isLand then
        self.moveComponent:DoMoveForward(self.speedZ * time)
    end
end

-- 飞行怪常驻的Update，用来处理非isAloft状态时的y位移需求
function YAxisMoveComponent:UpdateFly()
    local timeScale = self.entity.timeComponent:GetTimeScale()
    timeScale = timeScale > 1 and 1 or timeScale
    local time = FightUtil.deltaTimeSecond * timeScale
    local moveY = 0

    self.passDuration = self.passDuration + time

    local param = self.flyParams
    
	local newSet = self.flyChangeSpeed
	if not self.speed or self.flyChangeSpeed then
		self.flyChangeSpeed = false
		self.speed = param.speedY
	end

    if self.flyParams.accelerationTime > 0 then
        self.flyParams.accelerationTime = self.flyParams.accelerationTime - time
        self.flyParams.accelerationY = (self.flyParams.accelerationTime <= 0) and 0 or self.flyParams.accelerationY
    else
        self.speed = 0
    end

    if self.addupAccelerationBase and self.addupAccelerationBase ~= 0 then
        self.addupAcceleration = self.addupAcceleration + self.addupAccelerationBase
    end

    moveY = self.animatorHeight + (self.speed * time)

    if self.entity.partComponent then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)
    end

    local position = self.transformComponent:GetPosition()

    position.y = position.y + 0.2
    local height = BehaviorFunctions.CheckPosHeight(position) or 0
    height = height - 0.2

	if moveY > 0 or  height + moveY >= self.entity.moveComponent.hitStateMinHeight then
		moveY = self:CheckYBySphere(moveY,time)
	else-- 如果是hit新设置的param，会从地上拉起来
		if newSet then
			moveY = self.entity.moveComponent.hitStateMinHeight - height
		else
			moveY = 0
		end
	end 


	-- self.isLand = false

    self.animatorHeight = 0

	self.moveComponent:SetPositionOffset(0, moveY, 0)

    self:CalculateSpeed(time, param)

    if self.entity.partComponent then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.Entity)
    end

    -- 落地就不走Y轴的平面速度了
    if self.speedZ ~= 0 and not self.isLand then
        self.moveComponent:DoMoveForward(self.speedZ * time)
    end
end

function YAxisMoveComponent:CheckYBySphere(moveY,time)

    local position = self.transformComponent:GetPosition()
    if moveY <= 0 then
		-- position.y = position.y + self.halfHeight + self.checkRadius
		-- local checkOffset = moveY - self.halfHeight - self.checkRadius
        -- local offsetY, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
        local height, haveGround = self.fight.physicsTerrain:CheckTerrainHeight(position)
        -- LogError("height = "..height.." haveGround = "..tostring(haveGround).." time = "..time)
        local check = haveGround and height <= math.abs(moveY)
		if check then
			-- offsetY = offsetY + self.halfHeight + self.checkRadius --多出来的偏移有半个高度+半径
			self.isLand = time ~= 0
            -- LogError("self.isLand = "..tostring(self.isLand))
			--moveY = offsetY
		end
    else
		position.y = position.y + self.halfHeight - self.checkRadius
		local checkOffset = moveY + self.halfHeight
        local offsetY, check = self.fight.physicsTerrain:CheckYBySphere(position, checkOffset, self.checkRadius)
		if check then
			offsetY = offsetY - self.halfHeight - self.checkRadius --多出来的偏移有半个高度+半径
			self.isHitHead = time ~= 0
			--moveY = offsetY
		end
    end
    return moveY
end
function YAxisMoveComponent:AfterUpdate()
    for k, v in pairs(self.removeInstanceList) do
        self:RemoveForceParam(v)
    end

    TableUtils.ClearTable(self.removeInstanceList)
    --self.entity.transformComponent:SetPositionOffsetY(self.offsetHeight)
    local kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
	if kCCCharacterProxy then
		kCCCharacterProxy:SetMoveVector(0, self.offsetHeight, 0)
        self.kccLand = kCCCharacterProxy:GetIsLand()
	end
    if ( self.kccLand ) and self.offsetHeight < 0 then
        self:OnLand()
    elseif self.isHitHead then
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

function YAxisMoveComponent:GetAnimatorHeight()
    if not self.animatorHeight then
        return 0
    end
    
    return self.animatorHeight
end

function YAxisMoveComponent:ResetAnimatorMove()
	-- self.entity.transformComponent:SetPositionOffsetY(-self.totalAnimatorHeight)
    self.animatorHeight = 0
    self.lastTotalAnimatorHeight = 0
    self.totalAnimatorHeight = 0
end

function YAxisMoveComponent:CalculateSpeed(time, params)
    if self.durationZ > 0 then
        self.speedZ = self.speedZ + (self.accZ * time)
    end

    local useGravity = self.useGravity
    if params.useGravity ~= nil and useGravity then
        useGravity = params.useGravity
    end

    local isGlider = BehaviorFunctions.CheckEntityState(self.entity.instanceId, FightEnum.EntityState.Glide)
    local gravity = useGravity and (self.coverGravity and self.coverGravity or params.gravity) or 0
    ----非击飞状态下，飞行怪不受重力影响
    if self.moveComponent.isFlyEntity then
        if not (self.entity.stateComponent:IsState(FightEnum.EntityState.Hit)) then
            gravity = 0
        else
            local hitFSM = self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM
            if not hitFSM or not (hitFSM:IsState(FightEnum.EntityHitState.HitFly) or hitFSM:IsState(FightEnum.EntityHitState.PressDown)
                    or hitFSM:IsState(FightEnum.EntityHitState.HitFlyUp) or hitFSM:IsState(FightEnum.EntityHitState.HitFlyUpLoop) or hitFSM:IsState(FightEnum.EntityHitState.HitFlyFall)
                    or hitFSM:IsState(FightEnum.EntityHitState.HitFlyFallLoop) or hitFSM:IsState(FightEnum.EntityHitState.HitFlyHover)) then
                gravity = 0
            end
        end
    end
    local acc = params.accelerationY + gravity + self.addupAcceleration + self.additionGravity

    local maxFallSpeed = self.coverMaxFallSpeed and self.coverMaxFallSpeed or params.maxFallSpeed
    if isGlider and self.gliderMaxHeight then
        local gliderAcc = 0
        local height = 0
        if self.relativeGround then
            height = BehaviorFunctions.CheckEntityHeight(self.entity.instanceId)
        else
            local pos = BehaviorFunctions.GetPositionP(self.groundEntity)
            if pos then
                height = self.entity.transformComponent:GetPosition().y + self.entity.collistionComponent.height - (pos.y + self.gliderOffset[2])
            end
        end

        maxFallSpeed = 0
        gliderAcc = (height / self.gliderMaxHeight) * (self.gliderAcc.minAcc - self.gliderAcc.maxAcc) + self.gliderAcc.maxAcc
        -- LogError("acc = "..acc.." gAcc = "..gliderAcc.." height = "..height)
        acc = acc + gliderAcc

        if height >= self.gliderMaxHeight and acc > 0 and self.speed >= 0 then
            self.speed = 0
            return
        end
    end

	self.speed = self.speed + (acc * time)
    if self.speed <= maxFallSpeed + self.additionMaxFallSpeed then
        self.speed = maxFallSpeed + self.additionMaxFallSpeed
        self.moveDownMaxSpeed = true
	elseif isGlider then
		self.speed = (not self.gliderMaxUpSpeed or self.speed < self.gliderMaxUpSpeed) and self.speed or self.gliderMaxUpSpeed
    end
end

-- 把在空中的水平速度也放到Y轴组件里面来,落地那一帧不计算对应的位移
function YAxisMoveComponent:SetPlaneSpeed(speed, acceleration, duration)
    if self.isLand or not self.moveComponent.isAloft then
        return
    end

    self.speedZ = speed or 0
    self.accZ = acceleration or 0
    self.durationZ = duration or 0
end

function YAxisMoveComponent:ResetPlaneSpeed()
    self.speedZ = 0
    self.accZ = 0
    self.durationZ = 0
end

function YAxisMoveComponent:OnHitHead()
    self.isHitHead = false
end

function YAxisMoveComponent:OnLand(ingoreHurt)
    local kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
	if kCCCharacterProxy then
		kccLand = kCCCharacterProxy:SetLand()
	end
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
    self:ResetPlaneSpeed()

    self.lastSpeed = self.speed
    self.speed = nil
    for k, v in pairs(self.params) do
        self.params[k] = 0
    end

    for i = #self.forceParamTable, 1, -1 do
        self:RemoveForceParam(self.forceParamTable[i].instanceId)
    end

    if self.cRemoveWhenLand then
        self.coverGravity = nil
        self.coverMaxFallSpeed = nil
        self.aRemoveWhenLand = false
    elseif self.aRemoveWhenLand then
        self.additionGravity = 0
        self.additionMaxFallSpeed = 0
        self.aRemoveWhenLand = false
    end

    if self.entity.behaviorComponent then
        self.fight.entityManager:CallBehaviorFun("OnLand", self.entity.instanceId)
    end

    EventMgr.Instance:Fire(EventName.OnEntityLand, self.entity.instanceId)

    ingoreHurt = ingoreHurt or (self.entity.stateComponent and self.entity.stateComponent:CanIngoreLandHurt())
    if not ingoreHurt then
        self:OnHardLandHurt()
    else
        self.moveStartY = 0
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
    return self.lastSpeed or 0
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
	TableUtils.ClearTable(self.flyParams)
    self.fight.objectPool:Cache(YAxisMoveComponent, self)
end

function YAxisMoveComponent:OnHardLandHurt()
    local startY = self.moveStartY
    if startY == 0 then
        return
    end
    if not self.entity.attrComponent then
        return
    end
    if self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneDownDmg) then
        return
    end

    local isMonster = self.entity.tagComponent and self.entity.tagComponent:IsMonster()
    local endMoveY = self.entity.transformComponent:GetRealPositionY()
    local jumpHeight = startY - endMoveY
    local heightDist = jumpHeight - JumpHurt.CheckHeightHurt
    if heightDist > 0 then
        local hurtLife = 0
        if self.moveDownMaxSpeed then
            local maxLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
            local percent = math.min(JumpHurt.PercentHeightHurt + math.floor(heightDist * 10) * JumpHurt.HeightHurtParam, 100)
            hurtLife = maxLife * percent / 100
            if isMonster then
                hurtLife = hurtLife * 2
            end
        end
        if self.entity.masterId then
            local reductionP = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.FallDamageReductionPercent) or 0
            hurtLife = hurtLife - hurtLife * reductionP
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