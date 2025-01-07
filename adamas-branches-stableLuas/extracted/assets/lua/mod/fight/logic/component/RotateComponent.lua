---@class RotateComponent
RotateComponent = BaseClass("RotateComponent",PoolBaseClass)
--TODO
local Vec3 = Vec3
local Quat = Quat
function RotateComponent:__init()
end

function RotateComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.rotateConfig = entity:GetComponentConfig(FightEnum.ComponentType.Rotate)
	self.transformComponent = self.entity.transformComponent
	--self.rotateSpeed = self.rotateConfig.RotateSpeed

	self.followTarget = nil
	self.followRotation = Quat.New()
	self.isLookAt = false
	self.lookAtRotate = nil
	self.lookAtInstanceId = nil
	self.lookAtLastTime = nil
	self.lookAtInitSpeed = nil
	self.lookAtNowSpeed = nil
	self.lookAtAccelSpeed = nil
	self.followTargetLastRotation = Quat.New()
	self.followTargetRotation = Quat.New()
	self.accelTime = 0
end

function RotateComponent:LateInit()
	self:InitRotateSpeed()
end

function RotateComponent:InitRotateSpeed()
	local attributesComponent = self.entity.attrComponent
	local swimComponent = self.entity.swimComponent
	local stateComponent = self.entity.stateComponent
	if swimComponent and stateComponent and stateComponent:IsState(FightEnum.EntityState.Swim) then
		self.rotateSpeed = swimComponent.rotateSpeed
	elseif attributesComponent then
		self.rotateSpeed = attributesComponent:GetValue(EntityAttrsConfig.AttrType.RotationSpeed)
		-- self.rotateSpeed = self.rotateConfig.RotateSpeed
	else
		self.rotateSpeed = self.rotateConfig.RotateSpeed
	end
end

function RotateComponent:SetRotateSpeed(speed)
	if speed then
		self.rotateSpeed = speed
	else
		self:InitRotateSpeed()
	end
end

function RotateComponent:SetRotation(rotate)
	self.rotateTo = nil
	self.transformComponent:SetRotation(rotate)
	--self.transformComponent.rotation = rotate
	--self.transformComponent.lastRotation = rotate
end

function RotateComponent:SetRotationBlend(rotate)
	self.rotateTo = nil
	self.transformComponent:SetRotationBlend(rotate)
end

function RotateComponent:Async()
	self.rotateTo = nil
	self.transformComponent:AsyncRotate()
end

function RotateComponent:SetEuler(x,y,z)
	self.rotateTo = nil
	self.transformComponent.rotation:SetEuler(x,y,z)
	--self.transformComponent.lastRotation:CopyValue(self.transformComponent.rotation)
end

function RotateComponent:SetRotateOffset(offsetY)
	self.rotateTo = nil
	local rotation = self.transformComponent.rotation
	local eulerAngles = self.transformComponent.rotation:ToEulerAngles()
	self.transformComponent.rotation:SetEuler(eulerAngles.x, eulerAngles.y + offsetY, eulerAngles.z)
	--self.transformComponent.lastRotation:CopyValue(rotation)
end

function RotateComponent:DoRotate(offsetX, offsetY, offsetZ)
	local rotation = self.transformComponent.rotation
	--self.transformComponent.lastRotation:CopyValue(rotation)
	local eulerAngles = self.transformComponent.rotation:ToEulerAngles()
	self.transformComponent.rotation:SetEuler(eulerAngles.x + offsetX, eulerAngles.y + offsetY, eulerAngles.z + offsetZ)
end

function RotateComponent:DoModelXZRotate(x, z)
	self.entity.clientTransformComponent:SetOffsetRot(x, z)
end

--includeX指包含绕X轴旋转（默认人形只会转Y轴）
function RotateComponent:LookAtTarget(entity, transformName, includeX)
	local pos1
	if transformName then 
		pos1 = entity.clientTransformComponent:GetTransform(transformName).position
		if not pos1 then
			LogError("GetPartPosition error "..transformName)
			return
		end
	else
		pos1 = entity.transformComponent.position
	end
	
	local pos2 = self.transformComponent.position
	local x = pos1.x - pos2.x
	local y = includeX and pos1.y - pos2.y or 0
	local z = pos1.z - pos2.z
	local rotate = Quat.LookRotationA(x, y, z)
	
	self.transformComponent.rotation = rotate
	--self.transformComponent.lastRotation:CopyValue(self.transformComponent.rotation)
	self.entity.clientTransformComponent:Async()
end

function RotateComponent:LookAtPosition(x,z)
	local pos2 = self.transformComponent.position
	local newX = x - pos2.x
	local newZ = z - pos2.z
	if newX == 0 and newZ == 0 then
		return	
	end
	local rotate = Quat.LookRotationA(newX,0,newZ)
	--self.transformComponent.lastRotation = Quat(self.transformComponent.rotation.x,self.transformComponent.rotation.y,self.transformComponent.rotation.z,self.transformComponent.rotation.w)
	self.transformComponent.rotation = rotate
	--self.transformComponent.lastRotation:CopyValue(self.transformComponent.rotation)
	self.entity.clientTransformComponent:Async()
end

function RotateComponent:LookAtPositionWithY(x,y,z)
	local pos2 = self.transformComponent.position
	local newX = x - pos2.x
	local newY = (y ~= nil) and (y - pos2.y) or 0
	local newZ = z - pos2.z
	if newX == 0 and newZ == 0 then
		return	
	end
	local rotate = Quat.LookRotationA(newX,newY,newZ)
	self.transformComponent.rotation = rotate
	--self.transformComponent.lastRotation:CopyValue(self.transformComponent.rotation)
	self.entity.clientTransformComponent:Async()
end

function RotateComponent:LookAtTargetByLerp(entity,useBase,extraSpeed,accelSpeed,lastTime, includeX)
	self.isLookAt = true
	self.lookAtAccelSpeed = accelSpeed
	self.lookAtLastTime = lastTime
	self.lookAtIncludeX = includeX
	self.lookAtInstanceId = entity.instanceId

	local baseSpeed = useBase and self.rotateSpeed or 0
	self.lookAtInitSpeed = baseSpeed + extraSpeed
	-- self.lookAtNowSpeed = self.lookAtInitSpeed

	local pos1 = entity.transformComponent.position
	local pos2 = self.transformComponent.position
	local x = pos1.x - pos2.x
	local y = includeX and pos1.y - pos2.y or 0
	local z = pos1.z - pos2.z
	local rotate = Quat.LookRotationA(x,y,z)
	self.lookAtRotate = rotate
end

function RotateComponent:LookAtPositionByLerp(x,z,useBase,extraSpeed,accelSpeed)
	self.isLookAt = true
	self.lookAtAccelSpeed = accelSpeed
	self.lookAtLastTime = nil
	self.lookAtIncludeX = nil
	self.lookAtInstanceId = nil

	local baseSpeed = useBase and self.rotateSpeed or 0
	self.lookAtInitSpeed = baseSpeed + extraSpeed
	--self.lookAtNowSpeed = self.lookAtInitSpeed

	local pos2 = self.transformComponent.position
	local x = x - pos2.x
	local z = z - pos2.z
	local rotate = Quat.LookRotationA(x,0,z)
	self.lookAtRotate = rotate
end

function RotateComponent:LookAtPositionByLerpWithY(x,y,z,useBase,extraSpeed,accelSpeed)
	self.isLookAt = true
	self.lookAtAccelSpeed = accelSpeed
	self.lookAtLastTime = nil
	self.lookAtIncludeX = nil
	self.lookAtInstanceId = nil

	local baseSpeed = useBase and self.rotateSpeed or 0
	self.lookAtInitSpeed = baseSpeed + extraSpeed
	--self.lookAtNowSpeed = self.lookAtInitSpeed

	local pos2 = self.transformComponent.position
	local x = x - pos2.x
	local y = (y ~= nil) and y - pos2.y or 0
	local z = z - pos2.z
	local rotate = Quat.LookRotationA(x,y,z)
	self.lookAtRotate = rotate
end

function RotateComponent:CancelLookAt()
	self.isLookAt = false
end

function RotateComponent:Update()
	UnityUtils.BeginSample("RotateComponent:Update")
	if self.isLookAt then
		if self.lookAtInstanceId then
			local targetEntity = self.fight.entityManager:GetEntity(self.lookAtInstanceId)
			if targetEntity then
				local pos = targetEntity.transformComponent.position
				local y = self.lookAtIncludeX and pos.y
				local newRotate = self:GetLookAtRotate(pos.x, y, pos.z)
				if self.lookAtRotate ~= newRotate then
					self.lookAtRotate = newRotate
				end
			else
				self.lookAtInstanceId = nil
			end
		end

		if self.lookAtLastTime and self.lookAtLastTime ~= -1 and self.lookAtLastTime ~= -2 then
			self.lookAtLastTime = self.lookAtLastTime - FightUtil.deltaTime
			if self.lookAtLastTime < 0 then self.lookAtLastTime = 0 end
		end
		
		if not self.lookAtNowSpeed or self.lookAtInitSpeed ~= self.lookAtNowSpeed then
			self.lookAtNowSpeed = self.lookAtInitSpeed + (self.lookAtAccelSpeed or 0)
		end
		local rotateSpeed = self.lookAtNowSpeed * FightUtil.deltaTimeSecond
		local curForward = self.transformComponent.rotation * Vec3.forward
		local lookAtForward = self.lookAtRotate * Vec3.forward
		local needSpeed = Vec3.Angle(curForward, lookAtForward)
		if rotateSpeed < needSpeed then
			if self.accelTime > 10000 then
				self.lookAtNowSpeed = self.lookAtNowSpeed + self.lookAtAccelSpeed
				--self.accelTime = 0
			else
				self.accelTime = self.accelTime + FightUtil.deltaTime
			end

			local timeScale = self.entity.timeComponent:GetTimeScale()
			rotateSpeed = self.lookAtNowSpeed * timeScale * FightUtil.deltaTimeSecond
			self.transformComponent:SetRotation(Quat.RotateTowards(self.transformComponent.rotation, self.lookAtRotate, rotateSpeed))
		else
			self.lookAtNowSpeed = self.lookAtInitSpeed
			self.transformComponent:SetRotation(self.lookAtRotate)
			UnityUtils.SetRotation(self.entity.clientTransformComponent.transform, self.lookAtRotate.x, self.lookAtRotate.y, self.lookAtRotate.z, self.lookAtRotate.w)
			if not self.lookAtInstanceId then
				self.isLookAt = false	
				self.accelTime = 0	
			elseif self.lookAtLastTime and self.lookAtLastTime == -2 then
				self.isLookAt = false	
				self.accelTime = 0	
			end
		end

		if self.isLookAt and self.lookAtLastTime 
			and self.lookAtLastTime ~= -1 and  self.lookAtLastTime ~= -2 and self.lookAtLastTime <= 0 then
			self.isLookAt = false
			self.accelTime = 0		
		end
	end
	

	if self.rotateTo and self.entity.stateComponent and self.entity.stateComponent:CanMove() then
		local rotateSpeed = self.rotateSpeed * FightUtil.deltaTimeSecond
		self.transformComponent:SetRotation(Quat.RotateTowards(self.transformComponent.rotation, self.rotateTo, rotateSpeed))
	
		if self.rotateTo == self.transformComponent.rotation then
			self.rotateTo = nil
		end
	else
		self.rotateTo = nil
	end
	UnityUtils.EndSample()
end

function RotateComponent:AfterUpdate()
	if self.entity.moveComponent and self.entity.moveComponent.followedMovePlatformId then
		local movePlatform = self.fight.entityManager:GetEntity(self.entity.moveComponent.followedMovePlatformId)
		if not movePlatform then
			return
		end
		self.followRotation:Set()
		if self.transformComponent.position.y > movePlatform.transformComponent.position.y then
			if Quat.Equals(self.followTargetLastRotation, movePlatform.transformComponent.lastRotation) and
					Quat.Equals(self.followTargetRotation, movePlatform.transformComponent.rotation)  then
				self.followTargetLastRotation:CopyValue(movePlatform.transformComponent.lastRotation)
				self.followTargetRotation:CopyValue(movePlatform.transformComponent.rotation)
				return
			end
			self.followTargetLastRotation:CopyValue(movePlatform.transformComponent.lastRotation)
			self.followTargetRotation:CopyValue(movePlatform.transformComponent.rotation)

			local inverse = movePlatform.transformComponent.lastRotation:Normalize():Inverse()
			local followRotation = inverse * movePlatform.transformComponent.rotation:Normalize()
			local euler = followRotation:ToEulerAngles()
			local yRotation = Quat.Euler(0, euler.y, 0)
			self.followRotation = yRotation
			self.transformComponent:SetRotation(self.transformComponent.rotation * yRotation)
		end
	end
end

--TODO GC
function RotateComponent:GetLookAtRotate(x,y,z)
	local pos = self.transformComponent.position
	x = x - pos.x
	y = y and y - pos.y or 0
	z = z - pos.z
	return Quat.LookRotationA(x,y,z)
end

function RotateComponent:SetVector(x,y)
	if self.entity.stateComponent and 
		(self.entity.stateComponent:IsState(FightEnum.EntityState.Aim) or self.entity.stateComponent.stateFSM:IsSubBuildState(FightEnum.EntityBuildState.BuildMove))then
		return
	end

	if not self.rotateSpeed then
		self:InitRotateSpeed()
	end
	
	local rotateSpeed = self.rotateSpeed * FightUtil.deltaTimeSecond
	local rotate = Quat.LookRotationA(x,0,y)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	
	if self.entity.instanceId == ctrlId and self.entity.stateComponent and 
		(self.entity.stateComponent:IsState(FightEnum.EntityState.Move) or self.entity.stateComponent:IsState(FightEnum.EntityState.Idle)) then
		self.rotateTo = rotate
	else
		local transEuler = self.transformComponent.rotation:ToEulerAngles()
		local yRot = Quat.Euler(0, transEuler.y, 0)
		local zOffset = transEuler.z
		local xOffset = transEuler.x
		rotate = Quat.RotateTowards(yRot, rotate, rotateSpeed)

		local rotEuler = rotate:ToEulerAngles()
		local toRot = Quat.Euler(rotEuler.x + xOffset, rotEuler.y, rotEuler.z + zOffset)
		self.transformComponent:SetRotation(toRot)
	end
end

function RotateComponent:OnSetBackStage()
	self.rotateTo = nil
	self.isLookAt = false
end

function RotateComponent:OnCache()
	self.fight.objectPool:Cache(RotateComponent,self)
end

function RotateComponent:__cache()
	self.fight = nil
	self.entity = nil
	self.moveConfig = nil
	self.transformComponent = nil
	self.isLookAt = false
	self.followTarget = nil
	self.followRotation = nil
	self.followTargetLastRotation = nil
	self.followTargetRotation = nil
	self.accelTime = 0
end

function RotateComponent:__delete()
end
