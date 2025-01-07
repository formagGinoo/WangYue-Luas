---@class MoveComponent
MoveComponent = BaseClass("MoveComponent",PoolBaseClass)
local Vec3 = Vec3
local DefaultSurface = -9999
local Sqrt 	= math.sqrt
local minMoveVector = 0.002
local EntityCommonConfig = Config.EntityCommonConfig

function MoveComponent:__init()
	self.followedMovePlatformId = nil
	self.moveVector = Vec3.New()
	self.moveOffset = Vec3.New()
	self.deathTerrainOffset = Vec3.New()
	self.followedMoveVector = Vec3.New()
end

function MoveComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Move)
	self.defaultConfig = {}
	for k, v in pairs(self.config) do
		self.defaultConfig[k] = self.config[k]
	end

	self.transformComponent = self.entity.transformComponent
	self.collisionComponent = self.entity.collistionComponent
	self:CreateMoveComponent()
	self.forceMoveOffset = false
	self.isAloft = false 
	self.surfaceOfWater = DefaultSurface
	if self.collisionComponent then
		self.radius = self.collisionComponent.radius
		self.height = self.collisionComponent.height
		self.checkRadius = self.radius * 0.2
	end
	self.moveType = self.config.MoveType
	self.isFlyEntity = self.config.isFlyEntity
	self.flyHeight = self.config.flyHeight
	self.minFlyHeight = self.config.minFlyHeight
	self.fallRecoverTime = self.config.fallRecoverTime
	self.bornFlyHeight = self.config.bornFlyHeight or 0
	self.hitStateMinHeight = self.config.hitStateMinHeight or 0

	self.flyTargetPos = nil
	self.flyTargetInstance = nil

	self.checkGroundRadius = 0.2
	self.CheckMovePlatform = false

	self.repeatFlag = false
	EventMgr.Instance:AddListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
end


function MoveComponent:LateInit()
	if self.config.MoveType == FightEnum.MoveType.AnimatorMoveData then
		self.animatorMoveState = true
	end

	if self.moveComponent.LateInit then
		self.moveComponent:LateInit()
	end
end

function MoveComponent:ChangeCollistionParam()
	self.radius = self.collisionComponent.radius
	self.height = self.collisionComponent.height
end

function MoveComponent:CreateMoveComponent()
	local moveType = self.config.MoveType
	self.createFrame = self.fight.fightFrame

	if moveType == FightEnum.MoveType.AnimatorMoveData then
		self.moveComponent = self.fight.objectPool:Get(AnimatorMoveComponent)
	elseif moveType == FightEnum.MoveType.Linera then
		self.moveComponent = self.fight.objectPool:Get(LineraMoveComponent)
	elseif moveType == FightEnum.MoveType.Bind then
		self.moveComponent = self.fight.objectPool:Get(BindMoveComponent)
	elseif moveType == FightEnum.MoveType.Track then
		self.moveComponent = self.fight.objectPool:Get(TrackMoveComponent)
	elseif moveType == FightEnum.MoveType.Curve then
		self.moveComponent = self.fight.objectPool:Get(CurveMoveComponent)
	elseif moveType == FightEnum.MoveType.TrackPoint then
		self.moveComponent = self.fight.objectPool:Get(TrackPointMoveComponent)
	elseif moveType == FightEnum.MoveType.Throw then
		self.moveComponent = self.fight.objectPool:Get(ThrowMoveComponent)
	end
	self.moveComponent:Init(self,self.config)

	if not self.yMoveComponent then
		self.yMoveComponent = self.fight.objectPool:Get(YAxisMoveComponent)
		self.yMoveComponent:Init(self)
	end

	self.findPathComponent = self.entity.findPathComponent
end
function MoveComponent:ChangeMoveComponent(moveType, config)
	if self.moveComponent then
		self.moveComponent:OnCache()
		self.moveComponent = nil
	end

	for k, v in pairs(config) do
		self.config[k] = config[k]
	end
	-- self.config = config
	self.moveType = self.config.MoveType
	self.createFrame = self.fight.fightFrame
	if moveType == FightEnum.MoveType.AnimatorMoveData then
		self.moveComponent = self.fight.objectPool:Get(AnimatorMoveComponent)
	elseif moveType == FightEnum.MoveType.Linera then
		self.moveComponent = self.fight.objectPool:Get(LineraMoveComponent)
	elseif moveType == FightEnum.MoveType.Bind then
		self.moveComponent = self.fight.objectPool:Get(BindMoveComponent)
	elseif moveType == FightEnum.MoveType.Track then
		self.moveComponent = self.fight.objectPool:Get(TrackMoveComponent)
	elseif moveType == FightEnum.MoveType.Curve then
		self.moveComponent = self.fight.objectPool:Get(CurveMoveComponent)
	elseif moveType == FightEnum.MoveType.TrackPoint then
		self.moveComponent = self.fight.objectPool:Get(TrackPointMoveComponent)
	elseif moveType == FightEnum.MoveType.Throw then
		self.moveComponent = self.fight.objectPool:Get(ThrowMoveComponent)
	end
	self.moveComponent:Init(self, self.config)

	if not self.yMoveComponent then
		self.yMoveComponent = self.fight.objectPool:Get(YAxisMoveComponent)
		self.yMoveComponent:Init(self)
	end
end

function MoveComponent:ResetDefaultMoveComponent()
	self:ChangeMoveComponent(self.defaultConfig.MoveType, self.defaultConfig)
end

function MoveComponent:ResetMoveComponent()
	if self.moveComponent then
		self.moveComponent:OnCache()
		self.moveComponent = nil
	end
	self.config = self.entity:GetComponentConfig(FightEnum.ComponentType.Move)
	self.moveType = self.config.MoveType
	local moveType = self.config.MoveType
	self.createFrame = self.fight.fightFrame
	if moveType == FightEnum.MoveType.AnimatorMoveData then
		self.moveComponent = self.fight.objectPool:Get(AnimatorMoveComponent)
	elseif moveType == FightEnum.MoveType.Linera then
		self.moveComponent = self.fight.objectPool:Get(LineraMoveComponent)
	elseif moveType == FightEnum.MoveType.Bind then
		self.moveComponent = self.fight.objectPool:Get(BindMoveComponent)
	elseif moveType == FightEnum.MoveType.Track then
		self.moveComponent = self.fight.objectPool:Get(TrackMoveComponent)
	elseif moveType == FightEnum.MoveType.Curve then
		self.moveComponent = self.fight.objectPool:Get(CurveMoveComponent)
	elseif moveType == FightEnum.MoveType.TrackPoint then
		self.moveComponent = self.fight.objectPool:Get(TrackPointMoveComponent)
	end
	self.moveComponent:Init(self,self.config)
end

function MoveComponent:Update()
	if self.createFrame == self.fight.fightFrame then
		return
	end

	UnityUtils.BeginSample("MoveComponent:WaterCheck")
	if self.entity.tagComponent and self.entity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.NPC  and self.entity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.Car then
		if self.entity.tagComponent.tag == FightEnum.EntityTag.Npc and self.entity.clientTransformComponent.moveFlag then
			--降低水面在常态的检测精度
			if not self.isAloft and self.surfaceOfWater == DefaultSurface then
				self.repeatFlag = not self.repeatFlag
				if not self.repeatFlag then
					goto continue
				end
			end

			if self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Death) and self.surfaceOfWater ~= DefaultSurface then
				EventMgr.Instance:Fire(EventName.EnterDeath, self.entity.instanceId, { deathReason = FightEnum.DeathCondition.Drown })
				self.surfaceOfWater = DefaultSurface
			else
				local pos = self.transformComponent.position
				local touchWater, surfaceOfWater = self.fight.physicsTerrain:GetSurfaceOfWater(self.entity)
				if touchWater then
					EventMgr.Instance:Fire(EventName.EnterDeath, self.entity.instanceId, { deathReason = FightEnum.DeathCondition.Drown })
					self.surfaceOfWater = surfaceOfWater
				else
					if self.surfaceOfWater ~= DefaultSurface and not (self.surfaceOfWater > DefaultSurface and CS.PhysicsTerrain.CheckSurfaceOfWater(pos.x, self.surfaceOfWater, pos.z, self.checkRadius, self.height)
							and pos.y < self.surfaceOfWater) then
						EventMgr.Instance:Fire(EventName.ExitDeath, self.entity.instanceId, FightEnum.DeathCondition.Drown)
						self.surfaceOfWater = DefaultSurface
					end
				end
			end
		end
		::continue::
	end
	UnityUtils.EndSample()

	self:UpdateFlyParam(self.fight.fightFrame)

	UnityUtils.BeginSample("MoveComponent:mUpdate moveType"..self.moveType)
	self.moveComponent:Update()
	UnityUtils.EndSample()
	UnityUtils.BeginSample("MoveComponent:yUpdate")
	-- 在子状态机中去查能不能做Y轴移动
	local canFall = self.isAloft
	if canFall and self.entity.stateComponent then
		canFall = self.entity.stateComponent:CanFall()
	end

	if self.yMoveComponent and canFall then
		self.yMoveComponent:Update()
	elseif self.isFlyEntity then
		self.yMoveComponent:UpdateFly()
	end
	UnityUtils.EndSample()

	UnityUtils.BeginSample("UpdateForceMove")
	self:UpdateForceMove()
	UnityUtils.EndSample()
	UnityUtils.BeginSample("UpdatePreciseMove")
	self:UpdatePreciseMove()
	UnityUtils.EndSample()
	UnityUtils.BeginSample("UpdatePreciseMoveTo")
	self:UpdatePreciseMoveTo()
	UnityUtils.EndSample()
	self:CheckGlideState()
end

function MoveComponent:UpdateFlyParam(frame)

	
	if not self.flyTargetSpeed  then
		return
	end
	if frame - self.setFlyParamFrame >= self.flyDuration then
		self:SetFlyParams()
	end
	if self.flyTargetSpeed and self.flyTargetInstance and BehaviorFunctions.CheckEntity(self.flyTargetInstance) then
		if frame - self.lastSetFlyTarget > self.flyInterval then
			self.lastSetFlyTarget = frame
			self:SetFlyTargetPos(BehaviorFunctions.GetPositionP(self.flyTargetInstance))
		end
	end
end

function MoveComponent:CheckGlideState()
	-- 屏蔽长按滑翔
	do return end
	if self.setGlideState == true then
		if BehaviorFunctions.HasEntitySign(self.entity.instanceId,10000019) then
			self.setGlideState = false
			return
		end
		local canGlide = self.yMoveComponent:CanGlide()
		if self:ResetMoveCheck()  then
			self.setGlideState = false
		end
		local jumpPressFrame = self.fight.operationManager:GetKeyPressFrame(FightEnum.KeyEvent.Jump)
		-- LogError(string.format("............%s %s",jumpPressFrame,self.yMoveComponent.doubleJumpState))
		if self.yMoveComponent:GetDoubleJumpState() == true then
			jumpPressFrame = jumpPressFrame - EntityCommonConfig.GlideDoubleJumpPressFrame
		end
		if canGlide and jumpPressFrame >= EntityCommonConfig.GlideJumpPressFrame then
			self.entity.stateComponent:SetState(FightEnum.EntityState.Glide)
			self.setGlideState = false
		end
	end
end

function MoveComponent:UpdateForceMove()
	if self.forcedMove and self.forcedMove.speedZTime and self.forcedMove.speedZTime > 0 then
		local time = self.entity.timeComponent:GetTimeScale()* FightUtil.deltaTime / 10000
		if not self.forcedMove.directionX and not self.forcedMove.directionX then
			self:DoMoveForward(-self.forcedMove.speedZ * time)
		else
			self:DoMove(self.forcedMove.speedZ * self.forcedMove.directionX * time, self.forcedMove.speedZ * self.forcedMove.directionZ * time)
		end
		self.forcedMove.speedZTime = self.forcedMove.speedZTime - time
		if self.forcedMove.speedZTime > 0 then
			self.forcedMove.speedZ = self.forcedMove.speedZ + self.forcedMove.speedZAcceleration * time
		end
	end
end

function MoveComponent:UpdatePreciseMove()
	if self.preciseMove then
		if self.preciseMove.frame <= 0 or not BehaviorFunctions.CheckEntity(self.preciseMove.targetId) then
			if self.preciseMove.callback then
				self.preciseMove.callback()
			end
			self.preciseMove = nil
			return
		end

		local scale = self.entity.timeComponent:GetTimeScale()

		local dest = self.preciseMove.precisePosition
		if self.preciseMove.updateTargetFrame > 0 then
			local target = BehaviorFunctions.GetEntity(self.preciseMove.targetId)
			local targetTransfrom = target.transformComponent

			dest = targetTransfrom.position + targetTransfrom.rotation * self.preciseMove.offset
			self.preciseMove.precisePosition = dest

			self.preciseMove.updateTargetFrame = self.preciseMove.updateTargetFrame - 1
		end

		local moveVec = dest - self.transformComponent.position
		local dis = moveVec:Magnitude()
		local dir = Vec3.Normalize(moveVec)

		local speed = dis / self.preciseMove.frame
		--local animationMoveZ = self.entity.animationMoveZ or 0
		--speed = speed - animationMoveZ

		local move = dir * speed * scale
		self:DoMove(move.x,move.z)
		self:DoMoveUp(move.y)

		self.preciseMove.frame = self.preciseMove.frame - 1
	end
end

function MoveComponent:UpdatePreciseMoveTo()
	if self.preciseMoveTo then
		if self.preciseMoveTo.frame <= 0 then
			if self.preciseMoveTo.callback then
				self.preciseMoveTo.callback()
			end
			self.preciseMoveTo = nil
			return
		end
		local scale = self.entity.timeComponent:GetTimeScale()
		--时间
		--地点
		local moveVec = self.preciseMoveTo.position - self.transformComponent.position
		local dis = Vec3.Distance(self.preciseMoveTo.position, self.transformComponent.position)

		local dir = Vec3.Normalize(moveVec)
		local speed = dis / self.preciseMoveTo.frame
		local move = dir * speed * scale
		self:DoMove(move.x,move.z)
		self:DoMoveUp(move.y)

		self.preciseMoveTo.frame = self.preciseMoveTo.frame - 1
	end
end

function MoveComponent:GetSurfaceOfWater()
	return self.surfaceOfWater, self.surfaceOfWater == DefaultSurface
end

function MoveComponent:IsTouchWater()
	return self.surfaceOfWater ~= DefaultSurface
end

function MoveComponent:SetAloft(state)
	self.isAloft = state
end

function MoveComponent:GetOffsetHeight()
	return self.yMoveComponent and self.yMoveComponent:GetOffsetHeight() or 0
end

function MoveComponent:ApplyAnimation()
	if self.config.MoveType ~= FightEnum.MoveType.AnimatorMoveData then
		return
	end

	self.moveComponent:ApplyAnimation()
	self.animatorMoveState = true
end

function MoveComponent:SetAnimatorMoveState(state)
	if self.config.MoveType ~= FightEnum.MoveType.AnimatorMoveData then
		return
	end

	self.animatorMoveState = state
end

function MoveComponent:DoMove(x,z)
	self:SetPositionOffset(x,0,z)
end

function MoveComponent:DoMove3(offset)
	local move = self.transformComponent.rotation * offset
	self:SetPositionOffset(move.x,move.y,move.z)
end

function MoveComponent:DoMoveForward(speed)
	if self.findPathComponent then
		self.findPathComponent:UpdatePathFinding(speed)
	end

	if not self.entity.updateComponentEnable then--AI lod 不跑movecpm，所以直接执行
		local x, y, z = Quat.MulVec3A(self.transformComponent.rotation, Vec3.forward)
		--self.transformComponent:SetPositionOffset(x * speed, y * speed, z * speed)
		local kCCCharacterProxy
		if not self.entity.clientEntity.clientTransformComponent.banKccMove then
			kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
		end
		if kCCCharacterProxy then
			kCCCharacterProxy:SetMoveVector(x * speed, y * speed, z * speed)
			kCCCharacterProxy:ApplyMoveVector()
		end
		return
	end

	local x, y, z = Quat.MulVec3A(self.transformComponent.rotation, Vec3.forward)

	self:SetPositionOffset(x * speed, y * speed, z * speed)
end

function MoveComponent:DoMoveBack(speed)
	local x, y, z = Quat.MulVec3A(self.transformComponent.rotation, Vec3.back)

	self:SetPositionOffset(x * speed, y * speed, z * speed)
end

function MoveComponent:DoMoveLeft(speed)
	local x, y, z = Quat.MulVec3A(self.transformComponent.rotation, Vec3.left)

	self:SetPositionOffset(x * speed, y * speed, z * speed)
end

function MoveComponent:DoMoveRight(speed)
	local x, y, z = Quat.MulVec3A(self.transformComponent.rotation, Vec3.right)

	self:SetPositionOffset(x * speed, y * speed, z * speed)
end

function MoveComponent:DoMoveByMoveEvent(moveEvent, speed)
	local x, y, z = Quat.MulVec3A(Quat.LookRotationA(moveEvent.x, 0, moveEvent.y), Vec3.forward)
	self:SetPositionOffset(x * speed, y * speed, z * speed)
end

function MoveComponent:SetFlyTargetPos(targetPos)
	self.flyTargetPos = targetPos
end

function MoveComponent:SetFlyParams(flyTargetSpeed,heightOffset,duration,interval)
	self.flyTargetSpeed = flyTargetSpeed
	self.flyHeightOffset = heightOffset
	self.flyDuration = duration
	self.flyInterval = interval
	if flyTargetSpeed then
		self.lastSetFlyTarget = -99
		self.setFlyParamFrame = self.fight.fightFrame
	else
		self:SetFlyTargetPos()
	end
end
function MoveComponent:SetFlyMoveTarget(targetInstance)
	self.flyTargetInstance = targetInstance
end

function MoveComponent:ResetFlyMoveSpeed(x, y, z)
	--先检查有无目标点
	--目标点则根据目标点高度，修正速度
	--无目标点时，修正自己的离地高度
	if self.flyTargetPos then
		local self_position = self.entity.transformComponent.position:Clone()

		--检查当前状态,如果是run/walk则降低对高度修正的敏感度
		self_position.y = self_position.y + 0.2
		local height = BehaviorFunctions.CheckPosHeight(self_position) or 0
		--如果当前距离地面太近，一定向上飞，否则根据终点位置调整上下移动方向
		local timeScale = self.entity.timeComponent:GetTimeScale()
		local flySpeed = self.flyTargetSpeed * FightUtil.deltaTimeSecond * timeScale
		if height - 0.2 < self.minFlyHeight then
			y = flySpeed
			return x, y, z
		end

		local targetY = self.flyTargetPos.y + self.flyHeightOffset
		local diffY = math.abs(self.entity.transformComponent.position.y - targetY)
		local sign = self.entity.transformComponent.position.y < targetY and 1 or -1

		diffY = math.min(0.01,diffY)
		flySpeed = math.min(flySpeed,diffY)
		y = sign * flySpeed

	end
	return x, y, z
end

-- 做Y轴上的位置 如果不能应用Y轴组件的话做直接的位移
function MoveComponent:DoMoveUp(speed)
	local canMoveUpTag = self.entity.tagComponent and self.entity.tagComponent:CheckIsCanMoveUpTag()
	if (self.entity.stateComponent and self.entity.stateComponent:CanFall()) or (speed > 0 and canMoveUpTag) then
		self.isAloft = not self.isFlyEntity
		self.yMoveComponent:SetAnimatorMove(speed)
	else
		self:SetPositionOffset(0, speed, 0)
	end
end

function MoveComponent:ResetPositionY()
	self.yMoveComponent:ResetAnimatorMove()
end

function MoveComponent:SetPositionOffset(x,y,z)
	if self.forceMoveOffset then
		return
	end
	x = self.moveVector.x + x
	y = self.moveVector.y + y
	z = self.moveVector.z + z
	if self.isFlyEntity then
		-- 除了yMoveComponent的update处理击飞外，飞行怪的其他y轴位移全部会受到这个影响
		x, y, z = self:ResetFlyMoveSpeed(x, y, z)
	end

	self.moveVector.x = x
	self.moveVector.y = y
	self.moveVector.z = z
end

function MoveComponent:SetForcePositionOffset(x, y, z)
	self.moveVector.x = x
	self.moveVector.y = y
	self.moveVector.z = z
	self.forceMoveOffset = true
end

function MoveComponent:BeforeUpdate()
	if self.yMoveComponent then
		self.yMoveComponent:BeforeUpdate()
	end
end

function MoveComponent:ResetMoveVector()
	self.moveVector.x = 0
	self.moveVector.y = 0
	self.moveVector.z = 0
end

-- 绑定移动需要在AfterUpdate里面去做移动
function MoveComponent:IsAfterUpdate()
	local cfg = self.config
	if cfg.MoveType == FightEnum.MoveType.Bind then
		return false
	end
	return true
end

function MoveComponent:NeedTerrainAndCollisionCheck()
	if self.entity.stateComponent and (self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) or
			self.entity.stateComponent:IsState(FightEnum.EntityState.Swim)) then
		return false
	end
	if self.entity.tagComponent and self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Car then
		return false
	end

	if self.isFlyEntity then
		return
	end

	if self.entity.collistionComponent and
		self.entity.collistionComponent.collisionCheckType == FightEnum.CollisionCheckType.GenerateOnly then
		return false
	end

--[[	if self.entity.stateComponent and self.entity.stateComponent:IsClimbState(FightEnum.EntityState.StrideOver) then
		return false
	end

	if self.entity.stateComponent and self.entity.stateComponent:IsClimbState(FightEnum.EntityClimbState.ClimbRunOver) then
		return false
	end

	if self.entity.stateComponent and self.entity.stateComponent:IsClimbState(FightEnum.EntityClimbState.ClimbJumpOver) then
		return false
	end]]

	return true
end

function MoveComponent:AfterUpdate()
	-- if not self:IsAfterUpdate() then return end
	if self.config.MoveType == FightEnum.MoveType.Bind then
		self.moveComponent:AfterUpdate()
		return
	end

	if self:ResetMoveCheck() then
		self:ResetMoveVector()
		return
	end
	local newTo = self.moveVector
	-- local tempX = newTo.x
	-- local tempY = newTo.y
	-- local tempZ = newTo.z
	local detechGround = true
	local haveCollistion = false
	local ignoreHorizontalMoveVector = false
	--y轴平滑插值会影响跟随平台移动时y轴的表现，所以禁用
	local isLerpY = not self:isOnMovePlatform()

	if self:NeedTerrainAndCollisionCheck() then
		--TODO 为了性能先这么写，后续要优化
		if self.entity.tagComponent and self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.NPC then
			---只进行垂直方向的检测，避免浮空
			local toY
			toY = self.fight.physicsTerrain:CheckGround(self.transformComponent.position, self.entity, isLerpY)
			newTo.y = newTo.y + toY
		else
			--newTo = self.collisionComponent:CheckCollistion(newTo)
			---性能优化，无水平移动时使用消耗更小的方法
			ignoreHorizontalMoveVector = math.abs(newTo.x) < minMoveVector and math.abs(newTo.y) < minMoveVector and math.abs(newTo.z) < minMoveVector
			if ignoreHorizontalMoveVector  then
				---只进行垂直方向的检测，避免浮空
				if not self.isFlyEntity then
					local toY
					toY = self.fight.physicsTerrain:CheckGround(self.transformComponent.position, self.entity, isLerpY)
					newTo.y = newTo.y + toY
				end
			else
				if not self.moveVector:Equals(newTo) then
					haveCollistion = true 
				end

				if not self.entity.buffComponent or (self.entity.buffComponent and
						not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneWorldCollision)) then
					local toStartClimb = false
					local stickWithTerrain = self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.StickWithTerrain)
					UnityUtils.BeginSample("MoveComponent:Move")
					local newTo1
					toStartClimb, newTo1, detechGround = self.fight.physicsTerrain:Move(self.transformComponent.position, newTo.x, newTo.y, newTo.z, self.entity, haveCollistion, self.checkGroundRadius, stickWithTerrain, isLerpY)
					if self.entity.stateComponent and not self.entity.stateComponent:CanFall() then
						newTo = newTo1
					end
					newTo.y = newTo1.y
					UnityUtils.EndSample()
					if toStartClimb and self.entity.climbComponent then
						UnityUtils.BeginSample("MoveComponent:TryStartClimb")
						if self.entity.climbComponent:TryStartClimb() then
							return
						end
						UnityUtils.EndSample()
					end
				end
			end
		end
	end
	if self.entity.stateComponent and (self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) or
			self.entity.stateComponent:IsState(FightEnum.EntityState.Swim)) then
	else
		-- tempY = newTo.y
	end
	-- 判断是不是在致死地形上等死 后续改成特殊地形移动
	if self.entity.deathComponent and self.entity.deathComponent:IsInJudge(FightEnum.DeathCondition.Terrain) then
		local deathInfo = self.entity.deathComponent:GetJudgeInfo(FightEnum.DeathCondition.Terrain)
		local yAcc = TableUtils.GetParam(deathInfo, 0, "checkConfig", "AccelerationY")
		if yAcc ~= 0 and (newTo.y < 0 or not detechGround) then
			local yOffset = yAcc * FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
			newTo.y = (newTo.y < yOffset or not detechGround) and yOffset or newTo.y
		end
	end
	self.forceMoveOffset = false

	--判断是不是在动态地形/物体上
	if self.followedMovePlatformId then
		local movePlatform = Fight.Instance.entityManager:GetEntity(self.followedMovePlatformId)
		if movePlatform then
			self.followedMoveVector:Set()
			if not movePlatform.clientTransformComponent:GetIsLuaControlEntityMove() then
				self.followedMoveVector.x = movePlatform.clientTransformComponent.presentationMoveVector.x
				self.followedMoveVector.z = movePlatform.clientTransformComponent.presentationMoveVector.z
				self.followedMoveVector.y = movePlatform.clientTransformComponent.presentationMoveVector.y
			elseif movePlatform.moveComponent then
				self.followedMoveVector = movePlatform.moveComponent.moveVector
			end
			--要跟随旋转的情况下，计算旋转位移
			if self.entity.rotateComponent.followRotation then
				local oldVec = self.entity.transformComponent.position - movePlatform.transformComponent.position
				local newPosVec = oldVec * self.entity.rotateComponent.followRotation
				self.followedMoveVector = self.followedMoveVector + newPosVec - oldVec
			end
			newTo = newTo + self.followedMoveVector
			-- tempX = tempX + self.followedMoveVector.x
			-- tempY = tempY + self.followedMoveVector.y
			-- tempZ = tempZ + self.followedMoveVector.z
		end
	end

	--self.transformComponent:SetPositionOffset(newTo.x,newTo.y,newTo.z)

	local kCCCharacterProxy
	if not self.entity.clientEntity.clientTransformComponent.banKccMove then
		kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
	end
	if kCCCharacterProxy  then
		-- kCCCharacterProxy:SetMoveVector(tempX, tempY, tempZ)
		kCCCharacterProxy:SetMoveVector(newTo.x,newTo.y,newTo.z)
	else
		self.transformComponent:SetPositionOffset(newTo.x,newTo.y,newTo.z)
	end
	self.moveOffset = self.moveVector - newTo
	self:ResetMoveVector()

	UnityUtils.BeginSample("MoveComponent:YAfterUpdate")
	local canFall = self.isAloft or self.isFlyEntity
	if canFall and self.entity.stateComponent then
		canFall = self.entity.stateComponent:CanFall()
	end
	if self.yMoveComponent and canFall then
		self.yMoveComponent:AfterUpdate()
	end
	if kCCCharacterProxy then
		kCCCharacterProxy:ApplyMoveVector()
	end
	UnityUtils.EndSample()
end

function MoveComponent:ResetMoveCheck()
	

	if self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Perform) then
		return self.entity.stateComponent:CheckPerformMoveState()
	end

	if not self.collisionComponent then
		local ySpeed = self.yMoveComponent:GetAnimatorHeight()
		self.transformComponent:SetPositionOffset(self.moveVector.x, self.moveVector.y + ySpeed, self.moveVector.z)
		self.yMoveComponent:ResetAnimatorMove()
		return true
	end

	return false
end

function MoveComponent:GetDistanceFromTarget(targetEntity, checkRadius)
	if not targetEntity then
		return 0
	end

	local x1 = self.transformComponent.position.x
	local y1 = self.transformComponent.position.z
	local x2 = targetEntity.transformComponent.position.x
	local y2 = targetEntity.transformComponent.position.z
	local dist = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))

	if checkRadius then
		if self.entity.collistionComponent then
			dist = dist - self.entity.collistionComponent.radius
		end

		if targetEntity.collistionComponent then
			dist = dist - targetEntity.collistionComponent.radius
		end
	end

	return dist
end

function MoveComponent:IsBindMoveType()
	return self.moveType == FightEnum.MoveType.Bind
end

function MoveComponent:ClearAnimation()
	if self.moveComponent and self.moveComponent.ClearAnimation then
		self.moveComponent:ClearAnimation()
	end

	self.animatorMoveState = true
end

function MoveComponent:ForcedMove(speedZ,speedZAcceleration,speedZTime,directionX,directionZ)
	if not speedZTime or speedZTime <= 0 then return end
	self.forcedMove = {directionX = directionX,
		directionZ = directionZ,
		speedZ = speedZ,
		speedZAcceleration = speedZAcceleration,
		speedZTime = speedZTime}
end

function MoveComponent:PreciseMove(frame, targetId, offsetX, offsetY, offsetZ, updateTargetFrame, callback)
	if not frame or frame <= 0 then
		return
	end

	self.preciseMove = {
		frame = frame,
		targetId = targetId,
		updateTargetFrame = updateTargetFrame or frame,
		offset = Vec3.New(offsetX or 0, offsetY or 0, offsetZ or 0),
		callback = callback
	}
end

function MoveComponent:PreciseMoveTo(frame, position, callback)
	if not frame or frame <= 0 then
		return
	end

	self.preciseMoveTo = {
		frame = frame,
		position = position,
		callback = callback,
	}
end

function MoveComponent:PreciseMoveToBySpeed(speed, position, callback)
	if not speed or speed <= 0 then
		return
	end

	local dis = Vec3.Distance(position, self.transformComponent.position)
	if dis <= 0.1 then
		return
	end
	local needFrame = dis / (speed * FightUtil.deltaTimeSecond)

	self.preciseMoveTo = {
		frame = needFrame,
		position = position,
		callback = callback,
	}
end

function MoveComponent:StartJump(forceJump)
	local forceJump = forceJump or false
	local hasSign = BehaviorFunctions.HasEntitySign(self.entity.instanceId,10000019)
	if not hasSign then
		self.setGlideState = true
	end
	if not self.entity.stateComponent:CanJump() then
		if self.entity.stateComponent:IsState(FightEnum.EntityState.Jump) then
			if BehaviorFunctions.GetEntityJumpState(self.entity.instanceId) == FightEnum.EntityJumpState.JumpDown then
				if self.yMoveComponent:CanDoubleJump() and self.entity.stateComponent:AllowDoubleJump() then
					self.yMoveComponent:SetDoDoubleJump(true)
				elseif self.yMoveComponent:CanGlide() and not hasSign then
					self.entity.stateComponent:SetState(FightEnum.EntityState.Glide)
					self.setGlideState = false
				end
			elseif self.yMoveComponent:CanDoubleJump() and self.entity.stateComponent:AllowDoubleJump() then
				local glideSubState = self.entity.stateComponent:ChangeRole_GetSubState()
				self.yMoveComponent:SetDoDoubleJump(true)
			elseif self.yMoveComponent:CanGlide() and not hasSign then
				self.entity.stateComponent:SetState(FightEnum.EntityState.Glide)
				self.setGlideState = false
			end
			return true
		elseif self.entity.stateComponent:IsState(FightEnum.EntityState.Glide) then
			self.setGlideState = false
			local glideSubState = self.entity.stateComponent:ChangeRole_GetSubState()
			if glideSubState == FightEnum.GlideState.GlideStart then
				if self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Glide].glideFSM.statesMachine.duration > EntityCommonConfig.GlideStartDuration then return true end
			end
			local isForceDown = glideSubState ~= FightEnum.GlideState.GlideLand and glideSubState ~= FightEnum.GlideState.GlideLandRoll
			self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, false, isForceDown)
			return true
		end
		self.setGlideState = false
		return false
	end
	self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, forceJump)
	return true
end

function MoveComponent:SetExtraMoveCheckDistance(radius)
	self.checkGroundRadius = radius
end

function MoveComponent:isOnMovePlatform()
	if self.CheckMovePlatform then
		local underEntityIds = self.fight.physicsTerrain:CheckUnderfootMovePlatform(self.transformComponent.position, self.entity)
		for _, Id in pairs(underEntityIds) do
			local entity = Fight.Instance.entityManager:GetEntity(Id)
			if entity and entity.movePlatformComponent then
				self.followedMovePlatformId = entity.instanceId
				return true
			end
		end
	end
	self.followedMovePlatformId = nil
	return false
end


function MoveComponent:OnCache()
	if self.moveComponent then
		self.moveComponent:OnCache()
		self.moveComponent = nil
	end

	if self.yMoveComponent then
		self.yMoveComponent:OnCache()
		self.yMoveComponent = nil
	end

	self.transform = nil
	self.config = nil
	self.entity = nil
	self.CheckMovePlatform = false

	self.moveVector:Set(0,0,0)
	self.moveOffset:Set(0,0,0)
	self.deathTerrainOffset:Set(0,0,0)
	self.followedMoveVector:Set(0,0,0)
	self.fight.objectPool:Cache(MoveComponent,self)
end

function MoveComponent:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
end

function MoveComponent:__cache()
	self:RemoveListener()
end

function MoveComponent:__delete()
	self:RemoveListener()
	if self.moveComponent then
		self.moveComponent:DeleteMe()
		self.moveComponent = nil
	end
end