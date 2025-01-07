CameraFixed = BaseClass("CameraFixed",PoolBaseClass)
local CameraFixedType = FightEnum.CameraFixedType
local CameraFixedReferType = FightEnum.CameraFixedReferType
function CameraFixed:__init(cameraManager)
	self.fixeds = {}
	self.lastValue = {}
end

function CameraFixed:Init(cameraFixeds,instanceId,groupId,cameraFixedManager,durationTime,entityId,easeInTime,easeOutTime,useTimescale)
	self.cameraManager = cameraFixedManager.cameraManager
	self.fight = cameraFixedManager.cameraManager.clientFight.fight
	self.instanceId = instanceId
	self.entityId = entityId
	self.groupId = groupId
	self.cameraFixedManager = cameraFixedManager
	self.durationTime = durationTime
	self.useTimescale = useTimescale
	self.time = 0
	for k, v in pairs(cameraFixeds) do
		local fixed = self.fight.objectPool:Get(Fixed)
		fixed:Init(k,v,self)
		table.insert(self.fixeds,fixed)
	end
	self.outState = false
	self.OutTime = easeOutTime or 1
	self.curOutTime = self.OutTime
end

function CameraFixed:Update(lerpTime)
	if self.outState then
		self:UpdateOutState(lerpTime)
		return
	end
	local time = Time.deltaTime * self.cameraManager:GetMainRoleTimeScale()
	self.time = self.time + time 
	if self.time >= self.durationTime then
		--self.cameraFixedManager:RealRemove(self.instanceId)
		self:ChangeOutState()
		return
	end
	for i, v in ipairs(self.fixeds) do
		v:Update(lerpTime)
	end
end

function CameraFixed:ChangeOutState()
	self.outState = true
	--for i, v in ipairs(self.fixeds) do
		--v:ChangeOutState()
	--end
end

function CameraFixed:UpdateOutState(lerpTime)
	--self.cameraFixedManager:RealRemove(self.instanceId)
	--do return end
	local time = Global.deltaTime --* self.cameraManager:GetMainRoleTimeScale()
	self.curOutTime = self.curOutTime - time
	if self.curOutTime<0 then
		for i, v in ipairs(self.fixeds) do
			local p = self.curOutTime / self.OutTime
			v:EaseOut(0)
			self.cameraFixedManager:RealRemove(self.instanceId)
		end
		return
	end
	local p = self.curOutTime / self.OutTime
	--Log("p = "..p)
	for i, v in ipairs(self.fixeds) do
		v:EaseOut(p)
	end
	
end

function CameraFixed:UpdateValue(fixedType,cameraFixedReferType,value)
	if fixedType == CameraFixedType.PositionX then
		if self.cameraFixedReferType == CameraFixedReferType.Camera then
			self.cameraManager:FixedPositionXByCamera(value)
		elseif self.cameraFixedReferType == CameraFixedReferType.Target then
			self.cameraManager:FixedPositionXByTarget(value)
		end
	elseif fixedType == CameraFixedType.PositionY then
		if cameraFixedReferType == CameraFixedReferType.Camera then
			self.cameraManager:FixedPositionYByCamera(value)
		elseif cameraFixedReferType == CameraFixedReferType.Target then
			self.cameraManager:FixedPositionYByTarget(value)
		end
	elseif fixedType == CameraFixedType.PositionZ then
		if cameraFixedReferType == CameraFixedReferType.Camera then
			self.cameraManager:FixedPositionZByCamera(value)
		elseif cameraFixedReferType == CameraFixedReferType.Target then
			self.cameraManager:FixedPositionZByTarget(value)
		end
	elseif fixedType == CameraFixedType.RotationX then
		if cameraFixedReferType == CameraFixedReferType.Camera then
			self.cameraManager:FixedRotationXByCamera(value)
		elseif cameraFixedReferType == CameraFixedReferType.Target then
			self.cameraManager:FixedRotationXByTarget(value)
		end
	elseif fixedType == CameraFixedType.RotationY then
		if cameraFixedReferType == CameraFixedReferType.Camera then
			self.cameraManager:FixedRotationYByCamera(value)
		elseif cameraFixedReferType == CameraFixedReferType.Target then
			self.cameraManager:FixedRotationYByTarget(value)
		end
	elseif fixedType == CameraFixedType.RotationZ then
		if cameraFixedReferType == CameraFixedReferType.Camera then
			self.cameraManager:FixedRotationZByCamera(value)
		elseif cameraFixedReferType == CameraFixedReferType.Target then
			self.cameraManager:FixedRotationZByTarget(value)
		end
	end
end

function CameraFixed:UpdateOffsetValue(offsetType,cameraOffsetReferType,value)
	if offsetType == CameraFixedType.PositionX then
		if self.cameraOffsetReferType == CameraFixedReferType.Camera then
			self.cameraManager:OffsetPositionXByCamera(value)
		elseif self.cameraOffsetReferType == CameraFixedReferType.Target then
			self.cameraManager:OffsetPositionXByTarget(value)
		end
	elseif offsetType == CameraFixedType.PositionY then
		if cameraOffsetReferType == CameraFixedReferType.Camera then
			self.cameraManager:OffsetPositionYByCamera(value)
		elseif cameraOffsetReferType == CameraFixedReferType.Target then
			self.cameraManager:OffsetPositionYByTarget(value)
		end
	elseif offsetType == CameraFixedType.PositionZ then
		if cameraOffsetReferType == CameraFixedReferType.Camera then
			self.cameraManager:OffsetPositionZByCamera(value)
		elseif cameraOffsetReferType == CameraFixedReferType.Target then
			self.cameraManager:OffsetPositionZByTarget(value)
		end
	elseif offsetType == CameraFixedType.RotationX then
		if cameraOffsetReferType == CameraFixedReferType.Camera then
			self.cameraManager:OffsetRotationXByCamera(value)
		elseif cameraOffsetReferType == CameraFixedReferType.Target then
			self.cameraManager:OffsetRotationXByTarget(value)
		end
	elseif offsetType == CameraFixedType.RotationY then
		if cameraOffsetReferType == CameraFixedReferType.Camera then
			self.cameraManager:OffsetRotationYByCamera(value)
		elseif cameraOffsetReferType == CameraFixedReferType.Target then
			self.cameraManager:OffsetRotationYByTarget(value)
		end
	elseif offsetType == CameraFixedType.RotationZ then
		if cameraOffsetReferType == CameraFixedReferType.Camera then
			self.cameraManager:OffsetRotationZByCamera(value)
		elseif cameraOffsetReferType == CameraFixedReferType.Target then
			self.cameraManager:OffsetRotationZByTarget(value)
		end
	end
end


function CameraFixed:__cache()
	for i, v in ipairs(self.fixeds) do
		self.fight.objectPool:Cache(Fixed,v)
		self.fixeds[i] = nil
	end
	self.lastValue = {}
end

function CameraFixed:__delete()
end