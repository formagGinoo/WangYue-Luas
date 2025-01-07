Fixed = BaseClass("Fixed",PoolBaseClass)

local CameraFixedType = FightEnum.CameraFixedType
local CameraFixedReferType = FightEnum.CameraFixedReferType

function Fixed:__init(cameraManager)
end

function Fixed:Init(type,cameraFixedConfig,cameraFixed)
	self.isEnd = false
	self.lastValue = 0
	self.cameraManager = cameraFixed.cameraManager
	self.fight = cameraFixed.cameraManager.clientFight.fight
	self.cameraFixed = cameraFixed
	self.curveId = cameraFixedConfig.CurveId
	self.fixedType = CameraFixedType[type]
	self.easeInTime = cameraFixedConfig.EaseInTime
	self.easeOutTime = cameraFixedConfig.EaseOutTime
	self.cameraFixedReferType = cameraFixedConfig.CameraOffsetReferType
	self.easeIn = false
	self.easeOut = false
	self.time = 0
	self.curve = CurveConfig.GetCurve(cameraFixed.entityId, self.curveId,1000)
	if not self.curve then
		LogError("找不到曲线,id = "..self.curveId.." entity "..cameraFixed.entityId)
	end
	self.outLast = nil
end

function Fixed:Update(lerpTime)
	--local time = Time.deltaTime
	if self.isEnd then return end
	local timeScale = self.cameraFixed.useTimescale and self.cameraManager:GetMainRoleTimeScale() or 1
	self.time = self.time + Global.deltaTime * timeScale
	local deltaTime = 1/30
	local roleLerpTime = (self.time % deltaTime) / deltaTime
	local frame = math.floor(self.time * 30) + 1
	if frame > #self.curve then
		self.isEnd = true
		--self:UpdateValue(0)
		--self.lastValue = 0
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
	self.lastValue = value
	self:UpdateValue(value)
	--self.cameraFixed:UpdateLastValue(self.fixedType,self.cameraFixedReferType,self.lastValue)
end

function Fixed:UpdateValue(value)
	self.cameraFixed:UpdateValue(self.fixedType,self.cameraFixedReferType,value)
end

function Fixed:EaseOut(p)
	if not self.outLast then
		self.outLast = self.lastValue
	end
	local value = self.lastValue * p
	self.cameraFixed:UpdateOffsetValue(self.fixedType,self.cameraFixedReferType,value - self.outLast)
	
	self.outLast = value
end

function Fixed:__cache()
	self:UpdateValue(self.outLast or 0)
	--self.cameraFixed:UpdateLastValue(self.fixedType,self.cameraFixedReferType,self.lastValue)
	self.lastValue = 0
	self.outLast = nil
end

function Fixed:__delete()
end