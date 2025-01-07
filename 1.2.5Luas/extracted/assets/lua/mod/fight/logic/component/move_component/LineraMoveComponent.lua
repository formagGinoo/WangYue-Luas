LineraMoveComponent = BaseClass("LineraMoveComponent",PoolBaseClass)

local SectionSpeed = 25

local SpeedType = {
	Fixed = 1,
	Curve = 2,
}

function LineraMoveComponent:__init()
end

function LineraMoveComponent:Init(moveComponent, moveConfig)
	self.entity = moveComponent.entity
	self.moveComponent = moveComponent
	self.transformComponent = self.moveComponent.transformComponent
	if self.entity.owner then
		self.transformComponent:SetRotation(self.entity.owner.transformComponent.rotation)
	end
	
	if moveConfig.LineraSpeedType == SpeedType.Curve and moveConfig.SpeedCurveId and moveConfig.SpeedCurveId ~= 0 then
		self.speedFrameData = CurveConfig.GetCurve(self.entity.owner.entityId, moveConfig.SpeedCurveId)
		
		self.frame = 1
		self.frameSpeed = self.speedFrameData and self.speedFrameData[self.frame] or 0
		self.lastFrameSpeed = self.frameSpeed
		self.checkTimes = 1
	end

	if moveConfig.LineraSpeedType == SpeedType.Fixed then
		self.checkTimes = math.ceil(moveConfig.Speed / SectionSpeed)
		self.fixedSpeed = moveConfig.Speed / self.checkTimes
	end
	
	self.target = nil
	self.signId = moveConfig.SignId or 0
	self.earlyWarningFrame = moveConfig.EarlyWarningFrame or 0
	self.warningDurationFrame = moveConfig.WarningDurationFrame or 1
	self.warning = false
end

function LineraMoveComponent:SetTarget(target)
	self.target = target
end

function LineraMoveComponent:GetTargetDistance()
	if not self.target then
		return -1
	end
	
	if self.target and not BehaviorFunctions.CheckEntity(self.target.instanceId) then
		self.target = nil
		return -1
	end
	
	local myPos = self.transformComponent.position
	local targetPos = self.target.transformComponent.position
	return Vec3.Distance(myPos, targetPos)
end

function LineraMoveComponent:TryEarlyWarning()
	if self.signId == 0 then
		return 
	end
	
	if self.warning and self.warningDurationFrame > 0 then
		self.warningDurationFrame = self.warningDurationFrame - 1
		if self.warningDurationFrame <= 0 then
			local instancId = self.entity.owner and self.entity.owner.instanceId or self.entity.instanceId
			Fight.Instance.entityManager:CallBehaviorFun("Warning", instancId, self.target.instanceId, self.signId, true)
			self.signId = 0
		end
		return
	end
	
	local dis = self:GetTargetDistance()
	if dis == -1 then
		return 
	end
	
	local scale = 1
	if self.entity.timeComponent then
		scale = self.entity.timeComponent:GetTimeScale()
	end
	
	local calcDis = 0
	if self.fixedSpeed then
		calcDis = self.earlyWarningFrame * self.fixedSpeed * scale * FightUtil.deltaTimeSecond
	elseif self.frameSpeed then
		local endFrame = self.frame + self.earlyWarningFrame
		for i = self.frame, endFrame do
			local frameSpeed = self.speedFrameData and self.speedFrameData[self.frame] or self.lastFrameSpeed
			calcDis = calcDis + frameSpeed
		end
		calcDis = calcDis * scale * FightUtil.deltaTimeSecond
	end
	
	if calcDis >= dis then
		local instancId = self.entity.owner and self.entity.owner.instanceId or self.entity.instanceId
		Fight.Instance.entityManager:CallBehaviorFun("Warning", instancId, self.target.instanceId, self.signId)
		self.warning = true
	end
end

function LineraMoveComponent:GetSpeed()
	local scale = 1
	if self.entity.timeComponent then
		scale = self.entity.timeComponent:GetTimeScale()
	end
	
	if self.fixedSpeed then
		return self.fixedSpeed * scale * FightUtil.deltaTimeSecond
	end
	
	if self.frameSpeed then
		self.frameSpeed = self.speedFrameData and self.speedFrameData[self.frame] or self.lastFrameSpeed
		self.checkTimes = math.ceil(self.frameSpeed / SectionSpeed)
		local speed = self.frameSpeed / self.checkTimes
		self.lastFrameSpeed = self.frameSpeed
		
		return speed * scale * FightUtil.deltaTimeSecond
	end
	
	return 0
end

function LineraMoveComponent:Update()
	self:TryEarlyWarning()
	local speed = self:GetSpeed()
	if speed > 0 then
		for i = 1, self.checkTimes do
			if not self.entity then
				return 
			end
			self.moveComponent:DoMoveForward(speed)
			if i < self.checkTimes then
				self.moveComponent:AfterUpdate()
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

function LineraMoveComponent:OnCache()
	if self.signId and self.warning and self.warningDurationFrame > 0 then
		local instancId = self.entity.owner and self.entity.owner.instanceId or self.entity.instanceId
		Fight.Instance.entityManager:CallBehaviorFun("Warning", instancId, self.target.instanceId, self.signId, true)
	end
	
	self.fixedSpeed = nil
	self.frameSpeed = nil
	self.frame = nil
	self.target = nil
	self.entity = nil
	
	self.moveComponent.fight.objectPool:Cache(LineraMoveComponent,self)
end

function LineraMoveComponent:__cache()
end

function LineraMoveComponent:__delete()
end