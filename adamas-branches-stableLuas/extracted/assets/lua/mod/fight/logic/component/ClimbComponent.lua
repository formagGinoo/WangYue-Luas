---@class ClimbComponent
ClimbComponent = BaseClass("ClimbComponent",PoolBaseClass)
local Vec3 = Vec3
local UpDir = Vec3.New(0, 1, 0)
local ClimbState = FightEnum.EntityClimbState

function ClimbComponent:__init()
	self.moveVector = Vec3.New()
	self.forceCheckDir = Vec3.New()
	self.lastClimbRunVector = Vec3.New()
	self.position = Vec3.New()
end

function ClimbComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Climb)
	self.transformComponent = self.entity.transformComponent
	self.stateComponent = self.entity.stateComponent
	self.collisionComponent = self.entity.collistionComponent
	self.clientTransformComponent = self.entity.clientTransformComponent
	self.moveComponent = self.entity.moveComponent
	self.strideOverY = 0
	self.climbFSM = self.stateComponent.stateFSM.states[FightEnum.EntityState.Climb].climbFSM
	self.climbToStrideOver = false
	self.inRoom = false

	EventMgr.Instance:AddListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:AddListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end

function ClimbComponent:TryStartClimb()
	if not self.stateComponent:CanClimb() or self.inRoom then
		return false
	end

	local dodgeValue = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurStaminaValue)
	if dodgeValue < 50 then
		return 
	end
	
	self.stateComponent:SetState(FightEnum.EntityState.Climb)

	-- 取消重力
	if self.moveComponent.isAloft then
		self.moveComponent.yMoveComponent:OnLand()
	end
	
	return true
end

-- 切换攀爬状态时的初始攀越检测
function ClimbComponent:TryClimbToLedge(animationYOffset)
	local canClimbLedge, ledgeOffset = self.fight.physicsTerrain:TryClimbToLedge(self.entity, animationYOffset, self.moveVector)	-- moveVector没有经过PhysicsClimb处理，后续要看表现是否有问题
	
	return canClimbLedge, ledgeOffset
end

-- 攀越检测（目前废弃）
function ClimbComponent:TryStrideOver(heightOffset, climbToStrideOver)
	self.climbToStrideOver = climbToStrideOver or false
	local canStrideOver, toPos, strideOverY, strideOverZ = self.fight.physicsTerrain:StrideOver(self.entity, heightOffset)
	if canStrideOver then
		self.strideOverY = strideOverY
		self.strideOverZ = strideOverZ
		self.entity.moveComponent.yMoveComponent:OnLand()
		
		if toPos.x ~= 0 or toPos.y ~= 0 or toPos.z ~= 0 then							-- 调整实体位置
			self.transformComponent:SetPositionOffset(toPos.x,toPos.y,toPos.z)
		end
		
		if self.stateComponent:IsClimbingRun() then										-- 攀跑触顶
			self.stateComponent:SetClimbState(FightEnum.EntityClimbState.ClimbRunOver)
		elseif self.climbFSM:IsState(ClimbState.ClimbingJump) or self.climbFSM:IsState(ClimbState.ClimbJump) then
			self.stateComponent:SetClimbState(FightEnum.EntityClimbState.ClimbJumpOver)	-- 攀跳触顶
		else
			self.stateComponent:SetClimbState(FightEnum.EntityClimbState.StrideOver)	-- 普通触顶
		end
	else
		self.climbToStrideOver = false
	end
	
	return canStrideOver
end

function ClimbComponent:GetStrideOverOffset()
	return self.strideOverY, self.strideOverZ
end

function ClimbComponent:UpdateRotAndPos(heightCheck)
	local dir, offsetPos = self.fight.physicsTerrain:UpdateClimbRotAndPos(self.entity, heightCheck)
	
	-- if offsetPos ~= Vec3.zero then
	-- 	self.entity.transformComponent:SetPositionOffset(offsetPos.x, offsetPos.y, offsetPos.z)
	-- end
	
	if dir == Vec3.zero then
		self.stateComponent:SetState(FightEnum.EntityState.Idle)
		return
	end
	
	local rotation = Quat.LookRotationA(dir.x, dir.y, dir.z)
	self.entity.transformComponent:SetRotation(rotation)
	--self.entity.clientTransformComponent:Async()
end

function ClimbComponent:UpdateRot(heightCheck)
	local dir, offset, targetDir = self.fight.physicsTerrain:UpdateClimbRotAndPos(self.entity, heightCheck)
	local rotation = Quat.LookRotationA(targetDir.x, targetDir.y, targetDir.z)
	self.entity.transformComponent:SetRotation(rotation)
	--self.entity.clientTransformComponent:Async()
end

function ClimbComponent:DoMoveUp(speed)
	local up = self.transformComponent.rotation * Vec3.up
	self:SetPositionOffset(up.x * speed,up.y * speed,up.z * speed)
end

function ClimbComponent:DoMoveRight(speed)
	local right = self.transformComponent.rotation * Vec3.right
	self:SetPositionOffset(right.x * speed,right.y * speed,right.z * speed)
end

function ClimbComponent:DoMoveLeft(speed)
	local left = self.transformComponent.rotation * Vec3.left
	self:SetPositionOffset(left.x * speed,left.y * speed,left.z * speed)
end

-- 攀爬状态设置KCC胶囊体半径和高度
function ClimbComponent:SetClimbCapsuleRadiusAndHeight()
	if self.clientTransformComponent then
		self.clientTransformComponent:SetKCCProxyHeight(self.config.ClimbCapsuleHeight or 1.65)
		self.clientTransformComponent:SetKCCProxyRadius(self.config.ClimbCapsuleRadius or 0.25)
		self.clientTransformComponent:SetKCCProxyYOffset(self.config.ClimbCapsuleOffsetY or 1)
	end
end

-- 恢复设置KCC胶囊体半径和高度
function ClimbComponent:ResetClimbCapsuleRadiusAndHeight()
	if self.clientTransformComponent then
		self.clientTransformComponent:SetKCCProxyHeight(self.collisionComponent.height)
		self.clientTransformComponent:SetKCCProxyRadius(self.collisionComponent.radius)
		self.clientTransformComponent:SetKCCProxyYOffset(self.collisionComponent.offsetY)
	end
end

function ClimbComponent:GetClimbCharacterHeight()
	if self.config.ClimbCharacterHeight == 0 then
		LogError("角色攀爬数据获取失败，请在实体编辑器攀爬组件中设置相关数据")
		return 165
	end
	
	local characterHeight = self.config.ClimbCharacterHeight > 1000 and self.config.ClimbCharacterHeight * 0.001 or self.config.ClimbCharacterHeight * 0.01
	
	return characterHeight == 0 and 165 or characterHeight
end

function ClimbComponent:GetClimbCapsuleRadius()
	local radius = self.config.ClimbCapsuleRadius
	
	return radius == 0 and 0.25 or radius
end

function ClimbComponent:SetForceCheckDirection(x, y, z)
	self.forceCheckDir:Set(x, y, z)
end

-- 使用动画位移期间覆盖玩家输入
function ClimbComponent:SetPositionOffset(x,y,z)
	self.moveVector.x = self.moveVector.x + x
	self.moveVector.y = self.moveVector.y + y
	self.moveVector.z = self.moveVector.z + z
end

function ClimbComponent:SetAdjustCheckOffset(offset)
	local checkOffset = offset or self.entity.collistionComponent.height * 0.3
	self.adjustCheckOffset = checkOffset
end

function ClimbComponent:UpdateLastClimbRunVector(x, y)
	if self.lastClimbRunVector then
		self.lastClimbRunVector.x = x
		self.lastClimbRunVector.y = y
	end
end

function ClimbComponent:GetLastClimbRunVector()
	if self.lastClimbRunVector then
		return self.lastClimbRunVector
	end
end

function ClimbComponent:Update()
end

function ClimbComponent:AfterUpdate()
	if not self.stateComponent:IsState(FightEnum.EntityState.Climb) then 
		self.moveVector:Set(0, 0, 0)
		self.forceCheckDir:Set(0, 0, 0)
		return 
	end
	
	local offset = self.moveVector
	local direction, rotation, resultType

	if offset ~= Vec3.zero and self.climbFSM:ShouldForbidPhysicClimbing() == false then
		resultType, offset, direction = self.fight.physicsTerrain:Climb(self.entity, offset)

		-- resultType: 0: 失败，1: 成功，2: 可触顶，3: 可触底  4: 掉落
		if resultType == 1 then
			rotation = Quat.LookRotationA(direction.x, direction.y, direction.z)
			self.transformComponent:SetRotation(rotation)
			
		elseif resultType == 2 then
			if self.stateComponent:IsClimbingRun() then											-- 攀跑触顶
				local animationYOffset = self.config.ClimbRunOverOffset
				local canClimbLedge, correctOffset = self.fight.physicsTerrain:TryClimbToLedge(self.entity, animationYOffset, offset)
				offset:Set(correctOffset.x, correctOffset.y, correctOffset.z)
				
				if canClimbLedge then
					self.stateComponent:SetClimbState(FightEnum.EntityClimbState.ClimbRunOver)
				end
			elseif self.climbFSM:IsState(ClimbState.ClimbingJump) or self.climbFSM:IsState(ClimbState.ClimbJump) then 	-- 攀跳触顶
				local animationYOffset = self.config.ClimbJumpOverOffset
				local canClimbLedge, correctOffset = self.fight.physicsTerrain:TryClimbToLedge(self.entity, animationYOffset, offset)
				offset:Set(correctOffset.x, correctOffset.y, correctOffset.z)

				if canClimbLedge then
					self.stateComponent:SetClimbState(FightEnum.EntityClimbState.ClimbJumpOver)
				end
			else
				local animationYOffset = self.config.ClimbStrideOverOffset
				local canClimbLedge, correctOffset = self.fight.physicsTerrain:TryClimbToLedge(self.entity, animationYOffset, offset)
				offset:Set(correctOffset.x, correctOffset.y, correctOffset.z)

				if canClimbLedge then
					self.stateComponent:SetClimbState(FightEnum.EntityClimbState.StrideOver)	-- 普通触顶
				end
			end

			rotation = Quat.LookRotationA(direction.x, direction.y, direction.z)
			self.transformComponent:SetRotation(rotation)
			
		elseif resultType == 3 then
			rotation = Quat.LookRotationA(direction.x, direction.y, direction.z)
			self.transformComponent:SetRotation(rotation)
			
			self.stateComponent:SetClimbState(FightEnum.EntityClimbState.ClimbLand)
			
		elseif resultType == 4 then
			rotation = Quat.LookRotationA(Vec3.forward.x, Vec3.forward.y, Vec3.forward.z)
			self.transformComponent:SetRotation(rotation)
			
			self.stateComponent:SetState(FightEnum.EntityState.Idle)
		end
	end

	self.moveComponent:SetPositionOffset(offset.x,offset.y,offset.z)	-- 在MoveComponent里通过KCC统一控制位移
	
	self.moveVector:Set(0, 0, 0)
	self.forceCheckDir:Set(0, 0, 0)
end

function ClimbComponent:OnEnterTriggerLayer(instanceId, layer)
	if layer ~= FightEnum.Layer.InRoom or instanceId ~= self.entity.instanceId then
		return
	end

	self.inRoom = true
end

function ClimbComponent:OnExitTriggerLayer(instanceId, layer)
	if layer ~= FightEnum.Layer.InRoom or instanceId ~= self.entity.instanceId then
		return
	end

	self.inRoom = false
end

function ClimbComponent:ApplyAnimation()
end

function ClimbComponent:OnCache()
	self.fight.objectPool:Cache(ClimbComponent,self)
end

function ClimbComponent:__cache()
	self.inRoom = false
	self.moveVector:Set(0,0,0)
	self.forceCheckDir:Set(0,0,0)

	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:RemoveListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end

function ClimbComponent:__delete()
	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:RemoveListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end