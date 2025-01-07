HitFSM = BaseClass("HitFSM",FSM)
local EntityHitState = FightEnum.EntityHitState

function HitFSM:__init()
	self.speedZ = 0
	self.speedZAcceleration = 0
	--self.speedZVector = Vector3.zero --TODO
	self.speedZTime = 0
	self.curReboundTimes = 0

	self.curAttackData = {
		hitType = 0,
		addTime = 0
	}
end

function HitFSM:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.attributesComponent = self.entity.attrComponent
	self.transformComponent = self.entity.transformComponent

	self.hitConfig = entity:GetComponentConfig(FightEnum.ComponentType.Hit)
	self.hitTime = entity:GetComponentConfig(FightEnum.ComponentType.State).HitTime
	self.HitStateRandomMapping = entity:GetComponentConfig(FightEnum.ComponentType.State).HitStateRandomMapping
	self:InitStates()
end

function HitFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(EntityHitState.None, objectPool:Get(HitNoneMachine))
	self:AddState(EntityHitState.LeftLightHit, objectPool:Get(LeftLightMachine))
	self:AddState(EntityHitState.RightLightHit, objectPool:Get(RightLightMachine))
	self:AddState(EntityHitState.LeftHeavyHit, objectPool:Get(LeftHeavyMachine))
	self:AddState(EntityHitState.RightHeavyHit, objectPool:Get(RightHeavyMachine))
	self:AddState(EntityHitState.HitDown, objectPool:Get(HitDownMachine))
	self:AddState(EntityHitState.PressDown, objectPool:Get(PressDownMachine))
	--self:AddState(EntityHitState.HitFly, objectPool:Get(FlyMachine))
	self:AddState(EntityHitState.HitFlyUp, objectPool:Get(FlyUpMachine))
	self:AddState(EntityHitState.HitFlyUpLoop, objectPool:Get(FlyUpLoopMachine))
	self:AddState(EntityHitState.HitFlyFall, objectPool:Get(FlyFallMachine))
	self:AddState(EntityHitState.HitFlyFallLoop, objectPool:Get(FlyFallLoopMachine))
	self:AddState(EntityHitState.HitFlyLand, objectPool:Get(FlyLandMachine))
	self:AddState(EntityHitState.HitFlyHover, objectPool:Get(FlyHoverMachine))
	self:AddState(EntityHitState.Lie, objectPool:Get(LieMachine))
	self:AddState(EntityHitState.StandUp, objectPool:Get(StandUpMachine))

	for k, v in pairs(self.states) do
		v:Init(self.fight,self.entity,self)
	end
	self:SwitchState(EntityHitState.None)
end

function HitFSM:Reset()
	self:SwitchState(EntityHitState.None)
end

function HitFSM:SetHitType(type)
	self:SwitchState(type)
end

function HitFSM:GetLieTime(curTime)
	local curData = self.curAttackData
	local hitType = curData.hitType
	if hitType ~= EntityHitState.HitDown and
	hitType ~= EntityHitState.HitFly then
		return curTime
	end
	if curData.switchTime == 0 then
		return curTime
	end
	return curData.switchTime
end

function HitFSM:OnEnter(attackConfig,attackEntity,headHit)
	if not attackConfig then
		return
	end
	local hitParams = attackConfig.HitParams
	if headHit then
		hitParams = attackConfig.HeadHitParams
	end
	if not hitParams.SpeedZ then
		return
	end

	if not self.yMoveComponent or not self.moveComponent then
		self.moveComponent = self.entity.moveComponent
		if self.moveComponent then
			self.yMoveComponent = self.moveComponent.yMoveComponent
		end
	end

	local transformComponent = attackEntity.transformComponent
	--self.SpeedZVector = self.transformComponent.position - transformComponent.position
	--self.SpeedZVector.y = 0
	--self.SpeedZVector = Vector3.Normalize(self.SpeedZVector)

	local stateRandomMapping = self.HitStateRandomMapping and self.HitStateRandomMapping[Config.EntityCommonConfig.HitState[attackConfig.HitType]]
	local realHitType = stateRandomMapping and stateRandomMapping[math.random(#stateRandomMapping)] or attackConfig.HitType
	self.curAttackData.hitType = realHitType
	self.curAttackData.switchTime = attackConfig.SwtichLieAnimTime or 0

	local forceNormalHit = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForceNormalHit)
	local canHitFlyCover = true
	if self.hitConfig.HitFlyHeight and self.hitConfig.HitFlyHeight > 0 then
		canHitFlyCover = self.hitConfig.HitFlyHeight <= self.fight.physicsTerrain:CheckTerrainHeight(self.entity.transformComponent.position)
	end
	if forceNormalHit then
		self:SwitchState(FightEnum.EntityHitState.LeftLightHit)
		self.speedZ = hitParams.SpeedZ
		self.speedZAcceleration = hitParams.SpeedZAcceleration
		self.speedZTime = hitParams.SpeedZTime
	elseif self.moveComponent and self.moveComponent.isAloft and canHitFlyCover then
		self:SwitchState(EntityHitState.HitFlyHover,attackConfig)
		self.speedZ = hitParams.SpeedZAloft
		self.speedZTime = hitParams.SpeedZTime
		self.speedZAcceleration = 0

		local params = {
			speedY = hitParams.SpeedYAloft,
			accelerationY = hitParams.SpeedYAccelerationAloft or 0,
			accelerationTime = hitParams.SpeedYAccelerationTimeAloft or 0,
			maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed,
			gravity = Config.FightConfig.Gravity,
		}
		self.yMoveComponent:SetGravityState(true)
		self.yMoveComponent:SetConfig(params, true)
		if not self.yMoveComponent:CheckHasAddupAcceleration() then
			self.yMoveComponent:SetAddupAcceleration(self.hitConfig.GravityAcceleration)
		end
	else
		if realHitType == EntityHitState.HitFly then
			self:SwitchState(EntityHitState.HitFlyUp, attackConfig)

			local params = {
				speedY = hitParams.SpeedY,
				accelerationY = hitParams.SpeedYAcceleration,
				accelerationTime = hitParams.SpeedYAccelerationTime,
				gravity = Config.FightConfig.Gravity,
				maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed
			}
			self.yMoveComponent:SetGravityState(true)
			self.yMoveComponent:SetAddupAcceleration(self.hitConfig.GravityAcceleration)
			self.yMoveComponent:SetConfig(params, true)
			self.moveComponent:SetAloft(true)

			self.speedZ = hitParams.SpeedZHitFly
			self.speedZTime = hitParams.SpeedZTime
			self.speedZAcceleration = 0
		else
			self:SwitchState(realHitType, attackConfig)
			self.speedZ = hitParams.SpeedZ
			self.speedZAcceleration = hitParams.SpeedZAcceleration
			self.speedZTime = hitParams.SpeedZTime
		end
	end
end

function HitFSM:Update()
	if not self.statesMachine then return end
	self.statesMachine:Update()
	local time = self.entity.timeComponent:GetTimeScale()* FightUtil.deltaTime / 10000
	self.speedZTime = self.speedZTime - time

	if self.moveComponent and self.moveComponent.isAloft then
		self.speedZ = self.speedZ + self.speedZAcceleration * time
		--local moveZ = self.SpeedZVector * self.speedZ * time
		self.moveComponent:DoMoveForward(-self.speedZ * time)
	else
		if self.yMoveComponent then
			local params = {speedY = 0, gravity = Config.FightConfig.Gravity, maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed}
			if self.yMoveComponent.entity.entityId == 0 then
				LogError("entityId wrong")
			end
			self.yMoveComponent:SetGravityState(true)
			self.yMoveComponent:SetConfig(params, true)
		end

		if self.speedZTime > 0 then
			self.speedZ = self.speedZ + self.speedZAcceleration * time
			--local moveZ = self.SpeedZVector * self.speedZ * time
			if self.moveComponent then
				self.moveComponent:DoMoveForward(-self.speedZ * time)
			end
		end
	end
end

function HitFSM:OnLand()
	if self.curReboundTimes < self.hitConfig.ReboundTimes then
		local speed = -(self.yMoveComponent:GetEndSpeed()) * self.hitConfig.ReboundCoefficient
		if speed >= self.hitConfig.MinSpeed then
			self.curReboundTimes = self.curReboundTimes + 1
			self:SwitchState(EntityHitState.HitFlyHover)

			local params = {speedY = speed, maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed}
			self.yMoveComponent:SetGravityState(true)
			self.yMoveComponent:SetConfig(params, true)
			self.speedZ = self.speedZ * self.hitConfig.SpeedZCoefficient
			return
		end
	end
	self.curReboundTimes = 0
	self.speedZ = 0
	self:SwitchState(EntityHitState.HitFlyLand)
end

function HitFSM:CanHit()
	--TODO 地形检测
	return self.statesMachine:CanHit()
end

function HitFSM:CanMove()
	return self.statesMachine:CanMove()
end

function HitFSM:CanCastSkill()
	return self.statesMachine:CanCastSkill()
end

function HitFSM:CanChangeRole()
	return self.statesMachine:CanChangeRole()
end

function HitFSM:CheckBuff()
	local immuneHit = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit)
	local immnueStun = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneStun)
	if not immuneHit and not immnueStun and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.Stun) then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Stun)
		return true
	end

	return false
end

function HitFSM:HitStateEnd()
	local immnueStun = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneStun)
	local immuneHit = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit) and
					not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForbiddenImmuneHit)
	if not immuneHit and not immnueStun and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.Stun) then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Stun)
	else
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function HitFSM:OnCache()
	self:CacheStates()
	self.moveComponent = nil
	self.yMoveComponent = nil
	self.fight.objectPool:Cache(HitFSM,self)
end

function HitFSM:__delete()
end
