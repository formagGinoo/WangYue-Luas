---@class SwimComponent
SwimComponent = BaseClass("SwimComponent",PoolBaseClass)
local Vec3 = Vec3
local LayerBit = FightEnum.LayerBit
local EntityCommonConfig = Config.EntityCommonConfig

local Stage = {
	None = 0,
	Swim = 1,
	FallDown = 2,
	Float = 3,
}

local DefaultSurface = -9999 --需保持跟movecomponent的一致

function SwimComponent:__init()
	self.moveVector = Vec3.New()
	--临时的Vec3，减少变量创建
	self.tempVec = Vec3.New()
end

function SwimComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Swim)
	self.transformComponent = self.entity.transformComponent
	self.stateComponent = self.entity.stateComponent
	self.collisionComponent = self.entity.collistionComponent
	self.moveComponent = self.entity.moveComponent

	self.radius = self.collisionComponent.radius
	self.height = self.collisionComponent.height
	self.checkRadius = self.radius * 0.2
	self.param = EntityCommonConfig.SwimParam
	
	self.surfaceOfWater = DefaultSurface
	self.stopSwimOffset = 0.05
	self.stage = Stage.None

	self.ySpeed = 0
	self.maxFallSpeed = EntityCommonConfig.JumpParam.MaxFallSpeed
	self.rotateSpeed = self.param.SwimmingRotateSpeed
	self.acc = 0
	self.accOffset = 0
	self.maxAcc = 0
	self.maxSpeed = 0.01

	--下沉加速度相关
	self.fallDownAcc = self.param.FallDownAcc
	self.fallDownAccOffset = self.param.FallDownAccOffset
	self.fallDownMaxAcc = self.param.FallDownMaxAcc
	self.fallDownMaxSpeed = 1
	self.fallDownMaxDistance = self.param.FallDownMaxDistance

	--上浮加速度相关
	self.floatAcc = self.param.FloatAcc
	self.floatAccOffset = self.param.FloatAccOffset
	self.floatMaxAcc = self.param.FloatMaxAcc
	self.floatMaxSpeed = self.param.FloatMaxSpeed

	self.effectInterval = self.param.WaterWalkEffectPlayInterval
	self.timeToPlay = self.effectInterval
	
	self.onLand = false

    EventMgr.Instance:AddListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
    EventMgr.Instance:AddListener(EventName.OnEntityLand, self:ToFunc("OnEntityLand"))
end

function SwimComponent:ChangeCollistionParam()
	self.radius = self.collisionComponent.radius
	self.height = self.collisionComponent.height
end

function SwimComponent:LateInit()
	self.surfaceOfWater = self.moveComponent:GetSurfaceOfWater()
end

function SwimComponent:SetStage(stage)
	self.stage = stage
	if stage == Stage.FallDown then
		local speed = self.moveComponent.yMoveComponent:GetSpeed() or self.fallDownMaxSpeed
		self.ySpeed = -self.param.JumpIntoSpeed * (speed / self.maxFallSpeed) --向下的取负
		self.acc = self.fallDownAcc
		self.accOffset = self.fallDownAccOffset
		self.maxAcc = self.fallDownMaxAcc
		self.maxSpeed = self.fallDownMaxSpeed
	elseif stage == Stage.Float then
		self.ySpeed = 0.01
		self.acc = self.floatAcc
		self.accOffset = self.floatAccOffset
		self.maxAcc = self.floatMaxAcc
		self.maxSpeed = self.floatMaxSpeed
	else
		self.ySpeed = 0
		self.acc = 0
		self.accOffset = 0
		self.maxAcc = 0
		self.maxSpeed = 0.01
	end
end

function SwimComponent:UpdateRotateSpeed(isFast)
	self.rotateSpeed = isFast and self.param.FastSwimmingRotateSpeed or self.param.SwimmingRotateSpeed
	self.entity.rotateComponent:InitRotateSpeed()
end

function SwimComponent:DoMoveForward(speed)
	local forward = self.transformComponent.rotation * Vec3.forward
	self:SetPositionOffset(forward.x * speed,forward.y * speed,forward.z * speed)
end

function SwimComponent:SetPositionOffset(x,y,z)
	self.moveVector.x = self.moveVector.x + x
	self.moveVector.y = self.moveVector.y + y
	self.moveVector.z = self.moveVector.z + z
end

function SwimComponent:Reset(state)
	self:SetStage(Stage.None)
	
	self.splashId = nil
	if state then
		self.stateComponent:SetState(state)
	end
	self.entity.rotateComponent:InitRotateSpeed()
	
	self.entity.climbComponent:ResetClimbCapsuleRadiusAndHeight()
end

function SwimComponent:CanStartSwim()
	return self.stage == Stage.Float or self.stage == Stage.Swim
end

function SwimComponent:ToSwim()
	--跳入水的情况
	if self.moveComponent.isAloft then
		self:SetStage(Stage.FallDown)
		self.moveComponent.yMoveComponent:OnLand(true)
	else
		self:SetStage(Stage.Swim)
	end

	self.splashId = nil

	--self.entity.rotateComponent:SetRotateSpeed(self.param.SwimmingRotateSpeed)
	self.stateComponent:SetState(FightEnum.EntityState.Swim)
	self.entity.rotateComponent:InitRotateSpeed()
	
	self.entity.climbComponent:SetClimbCapsuleRadiusAndHeight()
end

function SwimComponent:OnEntityLand(instanceId)
	if self.entity.instanceId == instanceId then
		self.onLand = true
	end
end 

function SwimComponent:TryPlayEffect(pos)
	if self.fight.operationManager:CheckMove() and self.timeToPlay >= self.effectInterval then
		
		self.timeToPlay = 0
		local forward = pos + self.transformComponent.rotation * Vec3.forward
		BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.WaterWalk, nil, pos.x, self.surfaceOfWater, pos.z, forward.x, self.surfaceOfWater - 0.1, forward.z)
	end
	
	--跳入水中，播水花特效
	if ctx and ((self.moveComponent.isAloft and not self.splashId) or self.onLand) then
		self.splashId = BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.SwimJumpTo, nil, pos.x, self.surfaceOfWater - 0.1, pos.z)
		if self.onLand then
			self.splashId = nil
			self.onLand = false
		end
	end
end

function SwimComponent:Update()
	if ctx then
		self.timeToPlay = self.timeToPlay + FightUtil.deltaTimeSecond
	end

	if self.stateComponent:IsState(FightEnum.EntityState.Death) then
		return
	end

	if self.stateComponent:IsState(FightEnum.EntityState.Climb) then
		local climbState = self.stateComponent.stateFSM:GetSubClimbState()
		if climbState == FightEnum.EntityClimbState.StartClimb or climbState == FightEnum.EntityClimbState.StrideOver then
			return
		end
	end

	local pos = self.transformComponent:GetPosition()
	if self.stateComponent:IsState(FightEnum.EntityState.Swim) then
		local surfaceOfWater, noCheck = self.moveComponent:GetSurfaceOfWater()
		if not noCheck then
			self.surfaceOfWater = surfaceOfWater
		end
		
		--检查位置是否合法
		if pos.y > self.surfaceOfWater or not CS.PhysicsTerrain.CheckSurfaceOfWater(pos.x, self.surfaceOfWater, pos.z, self.checkRadius, self.height) then
			self:Reset(FightEnum.EntityState.Jump)
			self.surfaceOfWater = DefaultSurface
			return
		end
		--水面上
		if self.ySpeed >= 0 and self.surfaceOfWater - pos.y <= self.config.SwimHeightInterval + 0.1 then
			--是否可以上岸
			self.tempVec:Set(pos.x, pos.y - self.height * 0.5, pos.z)
			local check, _, terrainHeight, _ = CS.PhysicsTerrain.SimpleCheckBySphere(pos.x, pos.y + self.height, pos.z, self.tempVec.x, self.tempVec.y, self.tempVec.z, self.checkRadius, PhysicsTerrain.TerrainCheckLayer)
			--print(check, terrainHeight, pos.y, terrainHeight - pos.y, self.stopSwimOffset)
			--if check and terrainHeight - pos.y > self.stopSwimOffset then
			if surfaceOfWater - pos.y < self.config.SwimHeightInterval - 0.05 then
				self:Reset(FightEnum.EntityState.Idle)
				return
			end
		--水下
		else

		end
	else
		local surfaceOfWater = self.moveComponent:GetSurfaceOfWater()
		--踩到水
		if surfaceOfWater ~= DefaultSurface then
			--水平面，特效播放，其他计算基准
			self.surfaceOfWater = surfaceOfWater
			self:TryPlayEffect(pos)
			--开始入水
			if surfaceOfWater - pos.y >= self.config.SwimHeightInterval then
				self:ToSwim()
			end
		else
			if self.surfaceOfWater == DefaultSurface then
				return 
			end
			
			--保底，速度过快可能导致检测失败，根据上次检查结果判断下是否入水
			--if self.surfaceOfWater > DefaultSurface and CS.PhysicsTerrain.CheckSurfaceOfWater(pos.x, self.surfaceOfWater, pos.z, self.checkRadius, self.height)
				--and self.surfaceOfWater - pos.y >= self.config.SwimHeightInterval then
				--self:ToSwim()
			--else
				--self:Reset()
			--end
			self:Reset()
			self.surfaceOfWater = DefaultSurface
		end
	end
end

function SwimComponent:CalcYOffset()
	if self.stage == Stage.None or self.stage == Stage.Swim then
		return self.ySpeed
	end

	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()

	if self.ySpeed <= 0 and self.ySpeed + self.acc >= 0 then
		self:SetStage(Stage.Float)
	end

	self.ySpeed = math.min(self.ySpeed + self.acc, self.maxSpeed)
	self.acc = math.min(self.acc + self.accOffset, self.maxAcc)

	return self.ySpeed * time
end

function SwimComponent:AfterUpdate()
	if self.stateComponent and not self.stateComponent:IsState(FightEnum.EntityState.Swim) then
		self.moveVector.x = 0
		self.moveVector.y = 0
		self.moveVector.z = 0
		return
	end

	if not self.collisionComponent then
		self.transformComponent:SetPositionOffset(self.moveVector.x,self.moveVector.y,self.moveVector.z)
		self.moveVector.x = 0
		self.moveVector.y = 0
		self.moveVector.z = 0
		return
	end

	local newTo = self.moveVector
	local pos = self.transformComponent.position
	newTo.y = newTo.y + self:CalcYOffset()

	local toStartClimb, bottoming = false, false
	toStartClimb, bottoming, newTo = self.fight.physicsTerrain:SwimMove(pos, newTo.x, newTo.y, newTo.z, self.entity)
	if toStartClimb and self.entity.climbComponent:TryStartClimb() then
		self:Reset()
		self.moveVector.x = 0
		self.moveVector.y = 0
		self.moveVector.z = 0
		return
	end

	if self.ySpeed < 0 and newTo.y + pos.y < self.surfaceOfWater - self.fallDownMaxDistance then
		bottoming, newTo.y = true, 0
	end

	--触底 or 触顶
	if newTo.y == 0 then
		self.ySpeed = self.ySpeed - self.acc
	end

	--触底
	if bottoming and self.ySpeed < 0 then
		self.ySpeed = 0
	end

	--限制到阈值高度
	--[[if newTo.y > self.surfaceOfWater - self.config.SwimHeightInterval - pos.y then
		self:SetStage(Stage.Swim)
		newTo.y = self.surfaceOfWater - self.config.SwimHeightInterval - pos.y
	end]]
	newTo.y = self.surfaceOfWater - self.config.SwimHeightInterval - pos.y

	self.moveComponent:SetPositionOffset(newTo.x,newTo.y,newTo.z)

	--self.moveOffset = self.moveVector - newTo

	self.moveVector.x = 0
	self.moveVector.y = 0
	self.moveVector.z = 0
end

function SwimComponent:ApplyAnimation()

end

function SwimComponent:OnCache()
	self.fight.objectPool:Cache(SwimComponent,self)
end

function SwimComponent:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityLand, self:ToFunc("OnEntityLand"))
end

function SwimComponent:__cache()
	self:RemoveListener()
	self.moveVector:Set(0, 0, 0)
	self.tempVec:Set(0, 0, 0)
end

function SwimComponent:__delete()
	self:RemoveListener()
end