Offset = BaseClass("Offset",PoolBaseClass)

local CameraOffsetType = FightEnum.CameraOffsetType
local CameraOffsetReferType = FightEnum.CameraOffsetReferType

function Offset:__init(cameraManager)
end

function Offset:Init(type,cameraOffsetConfig,cameraOffset)
	self.isEnd = false
	self.lastValue = 0
	self.cameraManager = cameraOffset.cameraManager
	self.fight = cameraOffset.cameraManager.clientFight.fight
	self.cameraOffset = cameraOffset
	self.curveId = cameraOffsetConfig.CurveId
	self.offsetType = CameraOffsetType[type]
	self.easeInTime = cameraOffsetConfig.EaseInTime
	self.easeOutTime = cameraOffsetConfig.EaseOutTime
	self.cameraOffsetReferType = cameraOffsetConfig.CameraOffsetReferType
	self.easeIn = false
	self.easeOut = false
	self.time = 0
	self.curve = CurveConfig.GetCurve(cameraOffset.entityId, self.curveId,1000)
	if not self.curve then
		LogError("找不到曲线,id = "..self.curveId.." entity "..cameraOffset.entityId)
	end
end

function Offset:Update(lerpTime)
	--local time = Time.deltaTime
	if self.isEnd then return end
	local timeScale = self.cameraOffset.useTimescale and self.cameraManager:GetMainRoleTimeScale() or 1
	self.time = self.time + Time.deltaTime * timeScale
	local deltaTime = 1/30
	local roleLerpTime = (self.time % deltaTime) / deltaTime
	local frame = math.floor(self.time * 30) + 1
	if frame > #self.curve then
		self.isEnd = true
		self:UpdateValue(-self.lastValue)
		self.lastValue = 0
		return
	end
	local lastValue = 0
	if frame > 1 then
		lastValue = self.curve[frame-1]
	end
	local curValue = self.curve[frame]
	--self:UpdateValue(-self.lastValue)
	--local timescale = self.cameraManager:GetMainRoleTimeScale()
	local value = lastValue + (curValue - lastValue) * timeScale * roleLerpTime
	self:UpdateValue(value-self.lastValue)
	self.lastValue = value
	
	self.cameraOffset:UpdateLastValue(self.offsetType,self.cameraOffsetReferType,self.lastValue)
end

function Offset:ChangeOutState()
	self.cameraOffset:UpdateLastValue(self.offsetType,self.cameraOffsetReferType,self.lastValue)
	self.lastValue = 0
end

function Offset:UpdateValue(value)
	self.cameraOffset:UpdateValue(self.offsetType,self.cameraOffsetReferType,value)
end


function Offset:__cache()
	self:UpdateValue(-self.lastValue)
	--self.cameraOffset:UpdateLastValue(self.offsetType,self.cameraOffsetReferType,self.lastValue)
	self.lastValue = 0
end

function Offset:__delete()
end