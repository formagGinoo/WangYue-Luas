TrackMoveComponent = BaseClass("TrackMoveComponent",PoolBaseClass)

local Vec3 = Vec3
local SectionSpeed = 25

function TrackMoveComponent:__init()
end

function TrackMoveComponent:Init(moveComponent, moveConfig)
	self.entity = moveComponent.entity
	
	if moveConfig.SpeedCurveId and moveConfig.SpeedCurveId ~= 0 then
		self.speedFrameData = CurveConfig.GetCurve(self.entity.parent.entityId, moveConfig.SpeedCurveId)
	end
	
	if moveConfig.RotateSpeedCurveId and moveConfig.RotateSpeedCurveId ~= 0 then
		self.rotateSpeedFrameData = CurveConfig.GetCurve(self.entity.parent.entityId, moveConfig.RotateSpeedCurveId)
	end
	
	self.alwaysUpdateTargetPos = moveConfig.AlwaysUpdateTargetPos
	self.rotationLockInterval = moveConfig.RotationLockInterval
	self.rotationLock = false
	
	self.frame = 1
	self.rotationLockDelay = moveConfig.RotationLockDelay or 0
	self.frameSpeed = self.speedFrameData and self.speedFrameData[self.frame] or 0
	self.frameRotateSpeed = self.rotateSpeedFrameData and self.rotateSpeedFrameData[self.frame] or 360
	
	self.lastFrameSpeed = self.frameSpeed
	self.lastFrameRotateSpeed = self.frameRotateSpeed
	
	self.moveComponent = moveComponent
	self.transformComponent = self.moveComponent.transformComponent
	
	self.enable = true
	self.frameToChangeEnable = 0
	self.toEnable = nil
end

function TrackMoveComponent:SetEnable(enable, delayFrame)
	if not delayFrame or delayFrame == 0 then
		self.enable = enable
	else
		self.frameToChangeEnable = delayFrame
		self.toEnable = enable
	end
end

function TrackMoveComponent:SetTarget(target)
	if target then
		self.targetEntity = target
		self.trackTransform = self.targetEntity.clientTransformComponent:GetTransform("HitCase")
		if self.trackTransform then
			self.trackPosition = Vec3.New(self.trackTransform.position.x, self.trackTransform.position.y, self.trackTransform.position.z)
		else
			self.trackPosition = self.targetEntity.transformComponent.position
		end
	end
end

function TrackMoveComponent:SetTrackPosition(x, y, z)
	self.trackPosition = Vec3.New(x, y, z)
end

function TrackMoveComponent:GetTrackPosition()
	if self.targetEntity and not UtilsBase.IsNull(self.trackTransform) and self.alwaysUpdateTargetPos then
		self.trackPosition:Set(self.trackTransform.position.x, self.trackTransform.position.y, self.trackTransform.position.z)
	end
	
	if not self.trackPosition then
		local pos = self.entity.transformComponent.position
		local forward = self.entity.transformComponent.rotation * Vec3.forward
		self.trackPosition = pos + forward * 100 --没有目标就往前飞
	end
	
	return self.trackPosition
end

function TrackMoveComponent:GetRotateSpeed(disVec)
	if self.rotationLock then
		return 0
	end
	
	if self.rotationLockInterval <= 0 or self.frame <= self.rotationLockDelay then
		return self.frameRotateSpeed
	end
	
	local dis = disVec:Magnitude()
	if dis <= self.rotationLockInterval then
		self.rotationLock = true
		return 0
	end
	
	return self.frameRotateSpeed
end

function TrackMoveComponent:GetSpeed(scale)
	self.frameSpeed = self.speedFrameData and self.speedFrameData[self.frame] or self.lastFrameSpeed
	self.frameRotateSpeed = self.rotateSpeedFrameData and self.rotateSpeedFrameData[self.frame] or self.lastFrameRotateSpeed
	self.checkTimes = math.ceil(self.frameSpeed / SectionSpeed)
	self.lastFrameSpeed = self.frameSpeed
	self.lastFrameRotateSpeed = self.frameRotateSpeed
	
	if self.frameSpeed == 0 then
		self.frame = self.frame + 1
	end

	return self.frameSpeed / self.checkTimes * scale * FightUtil.deltaTimeSecond
end

function TrackMoveComponent:Update()
	if self.frameToChangeEnable > 0 then
		self.frameToChangeEnable = self.frameToChangeEnable - 1
		if self.frameToChangeEnable == 0 then
			self.enable = self.toEnable
			self.toEnable = nil
		end
	end
	
	if not self.enable then
		return
	end
	
	local trackPosition = self:GetTrackPosition()		
	local dist = Vec3.Distance(trackPosition, self.entity.transformComponent.position)
	local scale = 1
	if self.entity.timeComponent then
		scale = self.entity.timeComponent:GetTimeScale()
	end
	
	local distPos = trackPosition - self.entity.transformComponent.position
	local rotateSpeed = self:GetRotateSpeed(distPos) * scale
	if not self.rotationLock then
		local targetQ = Quat.LookRotationA(distPos.x, distPos.y, distPos.z)
		local rotate = Quat.RotateTowards(self.transformComponent.rotation, targetQ, rotateSpeed)
		self.entity.transformComponent:SetRotation(rotate)
	end

	local speed = self:GetSpeed(scale)
	if speed > 0 then
		for i = 1, self.checkTimes do
			if not self.entity then
				return 
			end
			self.moveComponent:DoMoveForward(speed)
			if i < self.checkTimes then
				self.moveComponent:AfterUpdate()
				if not self.rotationLock and self.rotationLockInterval > 0 and self.frame > self.rotationLockDelay then
					local disVec = trackPosition - self.entity.transformComponent.position
					local dis = disVec:Magnitude()
					if dis <= self.rotationLockInterval then
						self.rotationLock = true
					end
				end
				
				if self.entity.attackComponent then
					self.entity.attackComponent:Update()
				end
			end
		end
	end
		
	if self.frame then
		self.frame = self.frame + 1
	end
end

function TrackMoveComponent:OnCache()
	self.targetEntity = nil
	self.trackPosition = nil
	self.trackTransform = nil
	self.entity = nil
	
	self.enable = true
	self.frameToChangeEnable = 0
	self.toEnable = nil
	
	self.moveComponent.fight.objectPool:Cache(TrackMoveComponent,self)
end

function TrackMoveComponent:__cache()
end

function TrackMoveComponent:__delete()
end