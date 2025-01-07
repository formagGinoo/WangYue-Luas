CameraOffset = BaseClass("CameraOffset",PoolBaseClass)
local CameraOffsetType = FightEnum.CameraOffsetType
local CameraOffsetReferType = FightEnum.CameraOffsetReferType
function CameraOffset:__init(cameraManager)
	self.offsets = {}
	self.lastValue = {}
end

function CameraOffset:Init(cameraOffsets,instanceId,groupId,cameraOffsetManager,durationTime,entityId,easeInTime,easeOutTime,useTimescale)
	self.cameraManager = cameraOffsetManager.cameraManager
	self.fight = cameraOffsetManager.cameraManager.clientFight.fight
	self.instanceId = instanceId
	self.entityId = entityId
	self.groupId = groupId
	self.cameraOffsetManager = cameraOffsetManager
	self.durationTime = durationTime
	self.useTimescale = useTimescale
	self.time = 0
	for k, v in pairs(cameraOffsets) do
		local offset = self.fight.objectPool:Get(Offset)
		offset:Init(k,v,self)
		table.insert(self.offsets,offset)
	end
	self.outState = false
	self.curOutTime = 0
	self.OutTime = easeOutTime or 0.1
end

function CameraOffset:Update(lerpTime)
	if self.outState then
		self:UpdateOutState(lerpTime)
		return
	end
	local time = Time.deltaTime * self.cameraManager:GetMainRoleTimeScale()
	self.time = self.time + time 
	if self.time >= self.durationTime then
		--self.cameraOffsetManager:RealRemove(self.instanceId)
		self:ChangeOutState()
		return
	end
	for i, v in ipairs(self.offsets) do
		v:Update(lerpTime)
	end
end

function CameraOffset:ChangeOutState()
	self.outState = true
	for i, v in ipairs(self.offsets) do
		v:ChangeOutState()
	end
end

function CameraOffset:UpdateOutState(lerpTime)
	--self.cameraOffsetManager:RealRemove(self.instanceId)
	--do return end
	local time = Time.deltaTime --* self.cameraManager:GetMainRoleTimeScale()
	self.curOutTime = self.curOutTime + time
	if self.curOutTime >= self.OutTime then
		for offsetTypeK, offsetTypeV in pairs(self.lastValue) do
			for cameraOffsetReferTypeK, cameraOffsetReferTypeV in pairs(offsetTypeV) do
				self:UpdateValue(offsetTypeK,cameraOffsetReferTypeK,-cameraOffsetReferTypeV.remainValue)
			end
		end
		self.cameraOffsetManager:RealRemove(self.instanceId)
		return
	end

	for offsetTypeK, offsetTypeV in pairs(self.lastValue) do
		for cameraOffsetReferTypeK, cameraOffsetReferTypeV in pairs(offsetTypeV) do
			self:UpdateValue(offsetTypeK,cameraOffsetReferTypeK,cameraOffsetReferTypeV.lastValue)
			local p = self.curOutTime / self.OutTime
			local value = Mathf.Lerp(0,cameraOffsetReferTypeV.totalValue,p)
			cameraOffsetReferTypeV.remainValue = cameraOffsetReferTypeV.remainValue + cameraOffsetReferTypeV.lastValue - value
			cameraOffsetReferTypeV.lastValue = value
			self:UpdateValue(offsetTypeK,cameraOffsetReferTypeK,-value)
		end
	end
end

function CameraOffset:UpdateValue(offsetType,cameraOffsetReferType,value)
	if offsetType == CameraOffsetType.PositionX then
		if cameraOffsetReferType == CameraOffsetReferType.Camera then
			self.cameraManager:OffsetPositionXByCamera(value)
		elseif cameraOffsetReferType == CameraOffsetReferType.Target then
			self.cameraManager:OffsetPositionXByTarget(value)
		end
	elseif offsetType == CameraOffsetType.PositionY then
		if cameraOffsetReferType == CameraOffsetReferType.Camera then
			self.cameraManager:OffsetPositionYByCamera(value)
		elseif cameraOffsetReferType == CameraOffsetReferType.Target then
			self.cameraManager:OffsetPositionYByTarget(value)
		end
	elseif offsetType == CameraOffsetType.PositionZ then
		if cameraOffsetReferType == CameraOffsetReferType.Camera then
			self.cameraManager:OffsetPositionZByCamera(value)
		elseif cameraOffsetReferType == CameraOffsetReferType.Target then
			self.cameraManager:OffsetPositionZByTarget(value)
		end
	elseif offsetType == CameraOffsetType.RotationX then
		if cameraOffsetReferType == CameraOffsetReferType.Camera then
			self.cameraManager:OffsetRotationXByCamera(value)
		elseif cameraOffsetReferType == CameraOffsetReferType.Target then
			self.cameraManager:OffsetRotationXByTarget(value)
		end
	elseif offsetType == CameraOffsetType.RotationY then
		if cameraOffsetReferType == CameraOffsetReferType.Camera then
			self.cameraManager:OffsetRotationYByCamera(value)
		elseif cameraOffsetReferType == CameraOffsetReferType.Target then
			self.cameraManager:OffsetRotationYByTarget(value)
		end
	elseif offsetType == CameraOffsetType.RotationZ then
		if cameraOffsetReferType == CameraOffsetReferType.Camera then
			self.cameraManager:OffsetRotationZByCamera(value)
		elseif cameraOffsetReferType == CameraOffsetReferType.Target then
			self.cameraManager:OffsetRotationZByTarget(value)
		end
	end
end 

function CameraOffset:UpdateLastValue(offsetType,cameraOffsetReferType,lastValue)
	if not self.lastValue[offsetType] then
		self.lastValue[offsetType] = {}
	end
	self.lastValue[offsetType][cameraOffsetReferType] = {lastValue = 0,totalValue = lastValue,remainValue = lastValue}
end

function CameraOffset:__cache()
	for i, v in ipairs(self.offsets) do
		self.fight.objectPool:Cache(Offset,v)
		self.offsets[i] = nil
	end
	self.lastValue = {}
end

function CameraOffset:__delete()
end