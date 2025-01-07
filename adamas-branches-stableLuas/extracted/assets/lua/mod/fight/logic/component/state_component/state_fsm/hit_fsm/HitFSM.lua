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
	self.hitComponent = self.entity.hitComponent
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
	self:AddState(EntityHitState.HitFlyFallRecover, objectPool:Get(FlyFallRecoverMachine))

	for k, v in pairs(self.states) do
		v:Init(self.fight,self.entity,self)
	end
	self:SwitchState(EntityHitState.None)
end

function HitFSM:Reset()
	self.setYParam = false
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

	if not self.yMoveComponent or not self.moveComponent then
		self.moveComponent = self.entity.moveComponent
		if self.moveComponent then
			self.yMoveComponent = self.moveComponent.yMoveComponent
		end
	end

	local hitModified = self.hitComponent.hitModified

	-- local transformComponent = attackEntity.transformComponent
	-- self.SpeedZVector = self.transformComponent.position - transformComponent.position
	-- self.SpeedZVector.y = 0
	-- self.SpeedZVector = Vector3.Normalize(self.SpeedZVector)

	local realHitType = self.entity.stateComponent:GetIncomingHitType()
	if not realHitType then
		local stateRandomMapping = self.HitStateRandomMapping and self.HitStateRandomMapping[Config.EntityCommonConfig.HitState[attackConfig.HitType]]
		realHitType = stateRandomMapping and stateRandomMapping[math.random(#stateRandomMapping)] or attackConfig.HitType
	end

	self.curAttackData.hitType = realHitType
	self.curAttackData.switchTime = attackConfig.SwtichLieAnimTime or 0

	local forceNormalHit = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForceNormalHit)
	local forceHitDown = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForceHitDown)

	local hoverRandomMapping = self.HitStateRandomMapping and self.HitStateRandomMapping[Config.EntityCommonConfig.HitState[FightEnum.EntityHitState.HitFlyHover]]
	local canHitFlyCover = not hoverRandomMapping or not next(hoverRandomMapping)
	-- local canHitFlyCover = true
	if canHitFlyCover and self.hitConfig.HitFlyHeight and self.hitConfig.HitFlyHeight > 0 then
		canHitFlyCover = self.hitConfig.HitFlyHeight <= self.fight.physicsTerrain:CheckTerrainHeight(self.entity.transformComponent.position)
	end

	--强制击倒受击
	if forceHitDown then
		self:SwitchState(FightEnum.EntityHitState.HitDown)
		self.speedZ = hitParams.SpeedZ and hitParams.SpeedZ * (hitModified and hitModified.SpeedZ or 1) or 0
		self.speedZAcceleration = hitParams.SpeedZAcceleration and hitParams.SpeedZAcceleration * (hitModified and hitModified.SpeedZAcceleration or 1) or 0
		self.speedZTime = hitParams.SpeedZTime and hitParams.SpeedZTime or 0
	--所有受击强制变为普通受击
	elseif forceNormalHit then
		self:SwitchState(FightEnum.EntityHitState.LeftLightHit)
		self.speedZ = hitParams.SpeedZ and hitParams.SpeedZ * (hitModified and hitModified.SpeedZ or 1) or 0
		self.speedZAcceleration = hitParams.SpeedZAcceleration and hitParams.SpeedZAcceleration * (hitModified and hitModified.SpeedZAcceleration or 1) or 0
		self.speedZTime = hitParams.SpeedZTime and hitParams.SpeedZTime or 0
	--浮空受击
	--进入条件1：地面怪物或飞行怪物处于"浮空"状态，子弹受击类型无论何种
	--进入条件2：飞行怪物处于"飞行"状态，子弹受击类型无论何种
	elseif self.moveComponent and ((not self.moveComponent.isFlyEntity and self.moveComponent.isAloft) or (self.moveComponent.isFlyEntity and
			(self.curState == EntityHitState.HitFlyUp or self.curState == EntityHitState.HitFlyFall or self.curState == EntityHitState.HitFlyUpLoop or self.curState == EntityHitState.HitFlyFallLoop)))
			and canHitFlyCover then
		self:SwitchState(EntityHitState.HitFlyHover,attackConfig)
		self.speedZ = hitParams.SpeedZAloft and hitParams.SpeedZAloft * (hitModified and hitModified.SpeedZAloft or 1) or 0
		self.speedZTime = (hitParams.SpeedZAloftTime and hitParams.SpeedZAloftTime > 0) and hitParams.SpeedZAloftTime or 0
		self.speedZAcceleration = 0

		local params = {
			speedY = hitParams.SpeedYAloft and hitParams.SpeedYAloft * (hitModified and hitModified.SpeedYAloft or 1) or 0,
			accelerationY = hitParams.SpeedYAccelerationAloft and hitParams.SpeedYAccelerationAloft * (hitModified and hitModified.SpeedYAloftAcceleration or 1) or 0,
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
		-- 地面怪物是否能被击飞状态判断
		local canHitFly = not self.moveComponent.isAloft or (self.moveComponent.isAloft and not canHitFlyCover)
		--首次击飞
		--进入条件1：地面怪物处于"地面"状态 或者 "空中"状态但是不满足Hover条件 且子弹受击类型为"击飞"时，或地面怪物处于"浮空"状态且子弹受击类型为"击倒"时
		--进入条件2：飞行怪物处于"飞行"状态且子弹受击类型为"击飞"时，或飞行怪物处于"任意"状态且子弹受击类型为"击倒"时
		if (not self.moveComponent.isFlyEntity and ((canHitFly and realHitType == EntityHitState.HitFly) or (self.moveComponent.isAloft and realHitType == EntityHitState.HitDown)))
		or (self.moveComponent.isFlyEntity and (((self.curState ~= EntityHitState.HitFlyUp and self.curState ~= EntityHitState.HitFlyFall and self.curState ~= EntityHitState.HitFlyUpLoop and self.curState ~= EntityHitState.HitFlyFallLoop) and
				realHitType == EntityHitState.HitFly) or realHitType == EntityHitState.HitDown)) then

			if realHitType == EntityHitState.HitFly then
				self:SwitchState(EntityHitState.HitFlyUp, attackConfig)
			elseif realHitType == EntityHitState.HitDown then
				self:SwitchState(EntityHitState.HitDown, attackConfig)
			end

			local speedY,accelerationY,accelerationTime,SpeedZHitFly,SpeedZHitFlyTime
			if self.moveComponent.isFlyEntity then
				speedY = hitParams.FlyHitSpeedYAloft and hitParams.FlyHitSpeedYAloft * (hitModified and hitModified.FlyHitSpeedYAloft or 1) or 0
				accelerationY = hitParams.FlyHitSpeedYAccelerationAloft and hitParams.FlyHitSpeedYAccelerationAloft * (hitModified and hitModified.FlyHitSpeedYAccelerationAloft or 1) or 0
				accelerationTime = hitParams.FlyHitSpeedYTimeAloft
				SpeedZHitFly = hitParams.FlyHitSpeedZAloft and hitParams.FlyHitSpeedZAloft * (hitModified and hitModified.FlyHitSpeedZAloft or 1) or 0
				SpeedZHitFlyTime = (hitParams.FlyHitSpeedZAccelerationAloft and hitParams.FlyHitSpeedZAccelerationAloft > 0) and hitParams.FlyHitSpeedZAccelerationAloft or 0
			else
				speedY = hitParams.SpeedY and hitParams.SpeedY * (hitModified and hitModified.SpeedY or 1) or 0
				accelerationY = hitParams.SpeedYAcceleration and hitParams.SpeedYAcceleration * (hitModified and hitModified.SpeedYAcceleration or 1) or 0
				accelerationTime = hitParams.SpeedYAccelerationTime
				SpeedZHitFly = hitParams.SpeedZHitFly and hitParams.SpeedZHitFly * (hitModified and hitModified.SpeedZHitFly or 1) or 0
				SpeedZHitFlyTime = (hitParams.SpeedZHitFlyTime and hitParams.SpeedZHitFlyTime > 0) and hitParams.SpeedZHitFlyTime or 0
			end
			local params = {
				speedY = speedY,
				accelerationY = accelerationY,
				accelerationTime = accelerationTime,
				gravity = Config.FightConfig.Gravity,
				maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed
			}
			self.yMoveComponent:SetGravityState(true)
			self.yMoveComponent:SetAddupAcceleration(self.hitConfig.GravityAcceleration)
			self.yMoveComponent:SetConfig(params, true)
			self.moveComponent:SetAloft(true)

			self.speedZ = SpeedZHitFly
			self.speedZTime = SpeedZHitFlyTime
			self.speedZAcceleration = 0
		else
			--其他受击类型
			local SpeedZ,SpeedZAcceleration,SpeedZTime
			if self.moveComponent.isFlyEntity then
				SpeedZ = hitParams.FlyHitSpeedZ and hitParams.FlyHitSpeedZ * (hitModified and hitModified.FlyHitSpeedZ or 1) or 0
				SpeedZAcceleration = hitParams.FlyHitSpeedZAcceleration and hitParams.FlyHitSpeedZAcceleration * (hitModified and hitModified.FlyHitSpeedZAcceleration or 1) or 0
				SpeedZTime = hitParams.FlyHitSpeedZTime or 0
				local params = {
					speedY = hitParams.FlyHitSpeedY and hitParams.FlyHitSpeedY * (hitModified and hitModified.FlyHitSpeedY or 1) or 0,
					accelerationY = hitParams.FlyHitSpeedYAcceleration and hitParams.FlyHitSpeedYAcceleration * (hitModified and hitModified.FlyHitSpeedYAcceleration or 1) or 0,
					accelerationTime = hitParams.FlyHitSpeedYTime and hitParams.FlyHitSpeedYTime * (hitModified and hitModified.FlyHitSpeedYTime or 1) or 0,
					gravity = Config.FightConfig.Gravity,
					maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed
				}
				self.yMoveComponent:SetGravityState(true)
				self.yMoveComponent:SetFlyConfig(params, true)
			else
				SpeedZ = hitParams.SpeedZ and hitParams.SpeedZ * (hitModified and hitModified.SpeedZ or 1) or 0
				SpeedZAcceleration = hitParams.SpeedZAcceleration and hitParams.SpeedZAcceleration * (hitModified and hitModified.SpeedZAcceleration or 1) or 0
				SpeedZTime = hitParams.SpeedZTime or 0
			end

			if realHitType == EntityHitState.HitFly then
				self:SwitchState(EntityHitState.HitFlyUp, attackConfig)
			else
				self:SwitchState(realHitType, attackConfig)
			end

			self.speedZ = SpeedZ
			self.speedZAcceleration = SpeedZAcceleration
			self.speedZTime = SpeedZTime
		end
	end
end

function HitFSM:Update()
	if not self.statesMachine then return end
	self.statesMachine:Update()
	local time = self.entity.timeComponent:GetTimeScale()* FightUtil.deltaTime / 10000

	if self.moveComponent and self.moveComponent.isAloft then
		self.moveComponent:DoMoveForward(-self.speedZ * time)
	else
		-- TODO 临时做法
		local checkGround = self.fight.physicsTerrain:CheckGround(self.entity.transformComponent:GetPosition(), self.entity, true)
		if checkGround and self.yMoveComponent and not self.setYParam then
			local JumpParam = Config.EntityCommonConfig.JumpParam
			local paramsTable = {
				speedY = -2,
				gravity = JumpParam.Gravity,
				accelerationY = JumpParam.JumpSpeedAcceleration,
				maxFallSpeed = JumpParam.MaxFallSpeed,
			}
			self.setYParam = true
			self.yMoveComponent:SetGravityState(true)
			self.yMoveComponent:SetConfig(paramsTable, true)
			self.yMoveComponent:SetPlaneSpeed(0)
		end

		-- if self.yMoveComponent then
		-- 	self.yMoveComponent:SetGravityState(true)
		-- 	if self.yMoveComponent then
		-- 		local params = {speedY = -2, gravity = Config.FightConfig.Gravity, maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed}
		-- 		self.yMoveComponent:SetConfig(params, true)
		-- 	end
		-- end

		if self.speedZTime > 0 and self.moveComponent then
			self.moveComponent:DoMoveForward(-self.speedZ * time)
		end
	end

	self.speedZTime = self.speedZTime - time
	if self.speedZTime > 0 then
		self.speedZ = self.speedZ + self.speedZAcceleration * time
	end
end

function HitFSM:OnLand()
	if self.hitConfig.ReboundTimes and self.curReboundTimes < self.hitConfig.ReboundTimes then
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

function HitFSM:CanFall()
	if self.statesMachine.CanFall then
		return self.statesMachine:CanFall()
	end

	return true
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
