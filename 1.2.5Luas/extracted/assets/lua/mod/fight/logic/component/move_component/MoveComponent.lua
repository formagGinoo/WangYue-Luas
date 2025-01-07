---@class MoveComponent
MoveComponent = BaseClass("MoveComponent",PoolBaseClass)
local Vec3 = Vec3
local DefaultSurface = -9999
local Sqrt 	= math.sqrt
local minMoveVector = 0.002

function MoveComponent:__init()
	self.followTarget = nil
	self.moveVector = Vec3.New()
	self.moveOffset = Vec3.New()
	self.deathTerrainOffset = Vec3.New()
end

function MoveComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Move)
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
	self.checkGroundRadius = 0

	self.repeatFlag = false
    EventMgr.Instance:AddListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
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

	self.config = config
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
	end
	self.moveComponent:Init(self, self.config)

	if not self.yMoveComponent then
		self.yMoveComponent = self.fight.objectPool:Get(YAxisMoveComponent)
		self.yMoveComponent:Init(self)
	end
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
	end
	self.moveComponent:Init(self,self.config)
end

function MoveComponent:Update()
	if self.createFrame == self.fight.fightFrame then
		return
	end
	
	UnityUtils.BeginSample("MoveComponent:WaterCheck")
	if self.entity.tagComponent and self.entity.tagComponent.tag == FightEnum.EntityTag.Npc and self.entity.clientEntity.clientTransformComponent.moveFlag then
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
	UnityUtils.EndSample()
	
	UnityUtils.BeginSample("MoveComponent:mUpdate")
	self.moveComponent:Update()
	UnityUtils.EndSample()
	UnityUtils.BeginSample("MoveComponent:yUpdate")
	if self.yMoveComponent and self.isAloft then
		self.yMoveComponent:Update()
	end
	UnityUtils.EndSample()
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

function MoveComponent:ApplyAnimation()
	if self.config.MoveType ~= FightEnum.MoveType.AnimatorMoveData then
		return
	end

	self.moveComponent:ApplyAnimation()
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
	
	if not self.entity.updateComponentEnable then
		local x, y, z = Quat.MulVec3A(self.transformComponent.rotation, Vec3.forward)
		self.transformComponent:SetPositionOffset(x * speed, y * speed, z * speed)
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

function MoveComponent:DoMoveUp(speed)
	--self.isAloft = speed > 0
	self.isAloft = true--speed > 0
	self.yMoveComponent:SetAnimatorMove(speed)
end

function MoveComponent:DoMoveDown(speed)
	--self.yMoveComponent:SetAnimatorMove(speed)
	--self:SetPositionOffset(0,speed,0)
	self.isAloft = true
	self.yMoveComponent:SetAnimatorMove(speed)
end

function MoveComponent:ResetPositionY()
	self.yMoveComponent:ResetAnimatorMove()
end

function MoveComponent:SetPositionOffset(x,y,z)
	if self.forceMoveOffset then
		return
	end
	self.moveVector.x = self.moveVector.x + x
	self.moveVector.y = self.moveVector.y + y
	self.moveVector.z = self.moveVector.z + z
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

function MoveComponent:IsAfterUpdate()
	local cfg = self.config
	if cfg.MoveType == FightEnum.MoveType.Bind then
		return false
	end
	return true
end

function MoveComponent:AfterUpdate()
	if not self:IsAfterUpdate()  then return end
	if self:ResetMoveCheck() then
		self:ResetMoveVector()
		return
	end
	
	local newTo = self.moveVector
	local detechGround = true
	local haveCollistion = false

	---性能优化，无水平移动时使用消耗更小的方法
	local ignoreHorizontalMoveVector = math.abs(newTo.x) < minMoveVector and math.abs(newTo.y) < minMoveVector and math.abs(newTo.z) < minMoveVector
	if not self.entity.stateComponent or (self.entity.stateComponent and not self.entity.stateComponent:IsState(FightEnum.EntityState.StrideOver)) then
		if ignoreHorizontalMoveVector then
			newTo = self.collisionComponent:CheckCollistion(newTo)
			UnityUtils.BeginSample("MoveComponent:CheckYBySphere")
			---只进行垂直方向的检测，避免浮空
			local toY = self.fight.physicsTerrain:CheckGround(self.transformComponent.position, self.entity)
			newTo.y = newTo.y + toY
			UnityUtils.EndSample()
		else
			UnityUtils.BeginSample("MoveComponent:CheckCollistion")
			newTo = self.collisionComponent:CheckCollistion(newTo)
			UnityUtils.EndSample()
			if not self.moveVector:Equals(newTo) then
				haveCollistion = true
			end

			if not self.entity.buffComponent or (self.entity.buffComponent and not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneWorldCollision)) then
				local toStartClimb = false
				local stickWithTerrain = self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.StickWithTerrain)
				UnityUtils.BeginSample("MoveComponent:Move")
				toStartClimb, newTo, detechGround = self.fight.physicsTerrain:Move(self.transformComponent.position, newTo.x, newTo.y, newTo.z, self.entity, haveCollistion, self.checkGroundRadius, stickWithTerrain)
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

	if self.followTarget then
		local followTarget = self.fight.entityManager:GetEntity(self.followTarget)
		if followTarget and followTarget.moveComponent then
			--临时处理，后续要检查在地面时过滤掉y轴
			if followTarget.moveComponent.moveVector.y ~= 0 and math.abs(newTo.y) < 0.3 and
					(not self.entity.stateComponent or (self.entity.stateComponent and not self.entity.stateComponent:IsState(FightEnum.EntityState.StrideOver))) then
				newTo.y = 0
			end
			--临时处理
			if self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Idle) then
				newTo.x = 0
				newTo.z = 0
			end
			if self.transformComponent.position.y > followTarget.transformComponent.position.y then
				newTo = newTo + followTarget.moveComponent.moveVector
				--要跟随旋转的情况下，计算旋转位移
				if self.entity.rotateComponent.followRotation then
					local oldVec = self.entity.transformComponent.position - followTarget.transformComponent.position
					local newPosVec = oldVec * self.entity.rotateComponent.followRotation
					newTo = newTo + (newPosVec - oldVec)
				end
			end
		else
			self.followTarget = nil
			LogError("------MoveComponent self.followTarget = nil ")
		end
	end

	self.transformComponent:SetPositionOffset(newTo.x,newTo.y,newTo.z)
	self.moveOffset = self.moveVector - newTo


	self:ResetMoveVector()
	if self.yMoveComponent and self.isAloft then
		UnityUtils.BeginSample("MoveComponent:YAfterUpdate")
		self.yMoveComponent:AfterUpdate()
		UnityUtils.EndSample()
	end
end

function MoveComponent:ResetMoveCheck()
	if self.entity.stateComponent and (self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) or 
			self.entity.stateComponent:IsState(FightEnum.EntityState.Swim)or
			self.entity.stateComponent:IsState(FightEnum.EntityState.Perform) or
			self.entity.stateComponent:IsState(FightEnum.EntityState.Death)) then
		return true
	end

	if not self.collisionComponent then
		self.transformComponent:SetPositionOffset(self.moveVector.x,self.moveVector.y,self.moveVector.z)
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
end

function MoveComponent:StartJump(forceJump)
	local forceJump = forceJump or false
	if not self.entity.stateComponent:CanJump() then
		if self.entity.stateComponent:IsState(FightEnum.EntityState.Jump) then
			if self.yMoveComponent:CanDoubleJump() then
				self.yMoveComponent.doDoubleJump = true
			elseif self.yMoveComponent:CanGlide() then
				self.yMoveComponent:SetGlideState(true)
				self.entity.stateComponent:SetState(FightEnum.EntityState.Glide)
			end

			return true
		elseif self.entity.stateComponent:IsState(FightEnum.EntityState.Glide) then
			self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, false, true)
			return true
		end

		return false
	end

	self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, forceJump)
	return true
end

function MoveComponent:SetExtraMoveCheckDistance(radius)
	self.checkGroundRadius = radius
end

function MoveComponent:SetFollowTarget(instanceId)
	self.followTarget = instanceId
end

function MoveComponent:RemoveFollowTarget()
	self.followTarget = nil
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
	self.followTarget = nil

	self.moveVector:Set(0,0,0)
	self.moveOffset:Set(0,0,0)
	self.deathTerrainOffset:Set(0,0,0)
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