AnimatorMoveComponent = BaseClass("AnimatorMoveComponent",PoolBaseClass)
local moveX = 2
local moveY = 4
local rotateY = 8

function AnimatorMoveComponent:__init()
	
end

function AnimatorMoveComponent:Init(moveComponent, moveConfig)
	self.moveComponent = moveComponent
	self.fight = self.moveComponent.entity.fight
	self.entity = self.moveComponent.entity
	self.timeComponent = self.moveComponent.entity.timeComponent
	self.transformComponent = self.moveComponent.entity.transformComponent
	self.animatorComponent = self.moveComponent.entity.animatorComponent
	self.rotateComponent = self.moveComponent.entity.rotateComponent
	
	self.moveConfig = 0
	self.moveConfigs = moveConfig.LogicMoveConfigs
	self:InitAnimationData(moveConfig.ConfigName)
	self.time = 0
	self.offset = Vec3.New()
	self.offsetRotateY = 0
	self.lastFrame = 1
	self.enabled = true
	self.yAxisMoveEnable = true
	self.xzAxisMoveEnable = true
	if ctx then
		self.clientTransformComponent = self.entity.clientEntity.clientTransformComponent
	end
end

function AnimatorMoveComponent:InitAnimationData(name)
	local posZ = name.."PositionZ"
	local posX = name.."PositionX"
	local posY = name.."PositionY"
	local rotateY = name.."RotateY"
	local pivotY = name.."PivotY"
	self.animationPositionZs = Config[posZ]
	self.animationPositionXs = Config[posX]
	self.animationPositionYs = Config[posY]
	self.animationRotationYs = Config[rotateY]
	self.animationPivotYs = Config[pivotY]
	self.pivotPos = 0
	if self.moveComponent.config.pivot then
		self.pivotPos = self.moveComponent.config.pivot
	end
end

function AnimatorMoveComponent:ApplyAnimation()
	--TODO 临时使用layer 0, 数据导出分层后再从对应的layer读取数据
	local layer = self.animatorComponent.animatorLayer
	layer = 0
	local frame = self.animatorComponent.frame + 1
	self.time = 0
	local animName = self.animatorComponent:GetAnimName()
	if self.animationPositionZs then
		self.animationPositionZ = self.animationPositionZs[layer][animName]
		self.lastOffsetZ = self.animationPositionZ and self.animationPositionZ[frame] or 0
	end
	if self.animationPositionXs then
		self.animationPositionX = self.animationPositionXs[layer][animName]
		self.lastOffsetX = self.animationPositionX and self.animationPositionX[frame] or 0
	end
	if self.animationPositionYs then
		self.animationPositionY = self.animationPositionYs[layer][animName]
		self.lastOffsetY = self.animationPositionY and self.animationPositionY[frame] or 0
	end
	if self.animationRotationYs then
		self.animationRotationY = self.animationRotationYs[layer][animName]
		self.lastOffsetRY = self.animationRotationY and self.animationRotationY[frame] or 0
	end
	if self.animationPivotYs then
		self.animationPivotY = self.animationPivotYs[layer][animName]
	end
	if self.moveConfigs and self.moveConfigs[animName] then
		self.moveConfig = self.moveConfigs[animName]
	else
		self.moveConfig = 0
	end
	if self.moveConfig & rotateY > 0 then
		self.applyRotateY = true
		self.forward = self.entity.transformComponent.rotation * Vec3.forward
		self.right = self.entity.transformComponent.rotation * Vec3.right
	else
		self.applyRotateY = nil
	end

	self.moveComponent:ResetPositionY()
	self.transformComponent.lastRotation:CopyValue(self.transformComponent.rotation)
	--self.clientTransformComponent:DoMoveX(0)
	--self.clientTransformComponent:ClearMoveX()
end

function AnimatorMoveComponent:ClearAnimation()
	if self.lastOffsetX and self.moveConfig & moveX == 0 then
		self.clientTransformComponent:DoAnimationXFusion(self.lastOffsetX)
	end
	self.clientTransformComponent:ClearMoveX()

	self.animationPositionZ = nil
	self.animationPositionX = nil
	self.animationPositionY = nil
end

function AnimatorMoveComponent:UseAnimatorMove()
	return not self.entity.logicMove and not self.entity.stateComponent:IsState(FightEnum.EntityState.Perform) and self.enabled
end

function AnimatorMoveComponent:SetYAxisMoveEnable(state)
	self.yAxisMoveEnable = state
end

function AnimatorMoveComponent:SetXZMoveEnable(state)
	self.xzAxisMoveEnable = state
end

function AnimatorMoveComponent:MoveX(speed)
	if self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) then
		self.entity.climbComponent:DoMoveRight(speed)
	else
		if self.applyRotateY then
			self.moveComponent:SetPositionOffset(self.right.x * speed,self.right.y * speed,self.right.z * speed)
			--self.moveComponent:DoMoveRight(offset.x*scale)
		else
			self.moveComponent:DoMoveRight(speed)
		end
	end
end

function AnimatorMoveComponent:MoveY(speed)
	if self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) then
		self.entity.climbComponent:DoMoveUp(speed)
	else
		self.moveComponent:DoMoveUp(speed)
	end
end

function AnimatorMoveComponent:MoveZ(speed)
	if self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) then
		self.moveComponent:DoMoveForward(speed)
	else
		if self.applyRotateY then
			self.moveComponent:SetPositionOffset(self.forward.x * speed,self.forward.y * speed,self.forward.z * speed)
		else
			self.moveComponent:DoMoveForward(speed)
		end
	end
end

function AnimatorMoveComponent:Update()
	if not self:UseAnimatorMove() then
		return
	end
	--do return end
	local scale = self.timeComponent:GetTimeScale()
	--self.time = self.time + scale * FightUtil.deltaTime
	if not self.animatorComponent.animationName then
		return
	end	
	local offset, offsetRotateY, clientMoveX, pivotOffset = self:GetOffset()
	--local forward = self.transformComponent.rotation * Vec3.forward
	--self.transformComponent:SetPositionOffset(offset[1] * forward[1],offset[2]* forward[2],offset[3]* forward[3])
	
	if self.moveConfig & moveX > 0 then
		local speed = offset.x * scale
		self:MoveX(speed)
	else
		if ctx then
			if clientMoveX == 0 then
				self.clientTransformComponent:ClearMoveX()
			else
				self.clientTransformComponent:DoMoveX(clientMoveX * scale)
			end
		else
			self.clientTransformComponent:ClearMoveX()
		end
	end
	if self.moveConfig & moveY > 0 and self.yAxisMoveEnable then
		local speed = offset.y * scale
		self:MoveY(speed)
		self.clientTransformComponent:SetPivotYOffset(pivotOffset)
	end
	if self.moveConfig & rotateY > 0 then
		self.rotateComponent:DoRotate(0, offsetRotateY * scale, 0)
	end
	local speed = offset.z*scale
	self.entity.animationMoveZ = speed

	--self.moveComponent:DoMove3(offset*scale)
	if (self.entity.skillComponent and self.entity.skillComponent.pauseAnimationMove) or not self.xzAxisMoveEnable then
		--self.entity.animationMoveZ = 0
	else
		self:MoveZ(speed)
	end
	
end

function AnimatorMoveComponent:GetOffset()
	local frame = self.animatorComponent.frame
	if self.animationPositionZ and #self.animationPositionZ > 0 then
		if frame > #self.animationPositionZ and not self.animatorComponent.isLooping then
			self.offset.x = 0
			self.offset.y = 0
			self.offset.z = 0
			return self.offset, 0, 0
		end
	end
	
	if self.animationPositionZ and #self.animationPositionZ > 0 then
		frame = frame % #self.animationPositionZ
	end
	
	if frame == 0 then
		self.offset.x = 0
		self.offset.y = 0
		self.offset.z = 0
		self.offsetRotateY = 0
		self.lastFrame = 1
		self.lastOffsetX = self.animationPositionX and self.animationPositionX[1] or 0
		self.lastOffsetY = self.animationPositionY and self.animationPositionY[1] or 0
		self.lastOffsetZ = self.animationPositionZ and self.animationPositionZ[1] or 0
		self.lastOffsetRY = self.animationRotationY and self.animationRotationY[1] or 0
		
		local model = self.entity.clientEntity.clientTransformComponent.model
		local xOffset = self.lastOffsetX
		if model then
			xOffset = model.localPosition.x
		end
		return self.offset, self.offsetRotateY,xOffset
	end
	
	-- 处理anim从不同帧播放时偏移计算错误的问题
	if frame ~= self.lastFrame then
		self.lastOffsetX = self.animationPositionX and self.animationPositionX[frame] or self.lastOffsetX
		self.lastOffsetY = self.animationPositionY and self.animationPositionY[frame] or self.lastOffsetY
		self.lastOffsetZ = self.animationPositionZ and self.animationPositionZ[frame] or self.lastOffsetZ
		self.lastOffsetRY = self.animationRotationY and self.animationRotationY[frame] or self.lastOffsetRY
	end
	local f = 1--(self.time - (frame + 1) * FightUtil.deltaTime) / FightUtil.deltaTime
	frame = frame + 1
	if self.animationPositionZ then
		local offsetZ = self.animationPositionZ[frame] or self.lastOffsetZ
		self.offset.z = offsetZ - self.lastOffsetZ
		self.lastOffsetZ = offsetZ 
	else
		self.offset.z = 0
		self.lastOffsetZ = 0
	end
	if self.animationPositionX then
		local offsetX = self.animationPositionX[frame] or self.lastOffsetX
		self.offset.x = offsetX - self.lastOffsetX
		self.lastOffsetX = offsetX
	else
		self.offset.x = 0
		self.lastOffsetX = 0
	end

	local pivotOffset = 0
	if self.animationPositionY then
		local offsetY = self.animationPositionY[frame] or self.lastOffsetY
		self.offset.y = offsetY - self.lastOffsetY
		self.lastOffsetY = offsetY

		pivotOffset = 0
		if self.animationPivotY[frame] then
			pivotOffset = self.animationPivotY[frame] < self.pivotPos and self.pivotPos - self.animationPivotY[frame] or 0
		end
	else
		self.offset.y = 0
		self.lastOffsetY = 0
	end
	if self.animationRotationY then
		local offsetRY = self.animationRotationY[frame] or self.lastOffsetRY
		self.offsetRotateY = offsetRY - self.lastOffsetRY
		self.lastOffsetRY = offsetRY
	else
		self.offsetRotateY = 0
		self.lastOffsetRY = 0
	end
	self.lastFrame = frame
	return self.offset, self.offsetRotateY,self.lastOffsetX, pivotOffset
end

function AnimatorMoveComponent:OnCache()
	self.fight.objectPool:Cache(AnimatorMoveComponent,self)
end

function AnimatorMoveComponent:__cache()
end

function AnimatorMoveComponent:__delete()
end