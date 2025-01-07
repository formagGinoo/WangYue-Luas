RadialBlurProc = BaseClass("RadialBlurProc", PostProcBase)

local _max = math.max
local _min = math.min

local DirectionType = 
{
	Custom = 0,
	Follow = 1,
}

function RadialBlurProc:DoStartFrame()
	self.curve = CurveConfig.GetCurve(self.entity.entityId, self.params.AlphaCurveId)
	self.duration = self.params.Duration
	self.alpha = self.params.Alpha
	self.curAlpha = self.alpha
	self.forceClose = false
	
	local transform
	if self.params.Direction == DirectionType.Follow then
		self.transform = self.entity.clientTransformComponent:GetTransform(self.params.FollowTransform)
	end
	
	local centerX = self.params.Center.x or self.params.Center[1]
	local centerY = self.params.Center.y or self.params.Center[2]
	
	self.invokeCmp:AddPostProcess(self.procType, self.params.ID or 0)
	self.invokeCmp:SetRadialBlurParams(self.params.Strength, self.params.Dir, self.params.Radius, self.params.Count,
		centerX, centerY, self.params.Alpha, self.params.Direction, transform)
end

local DefaultAlpha = 0
function RadialBlurProc:DoFrame(frame)
	if frame < self.duration then
		if not self.forceClose and not self.curve then
			return
		end
		
		local percent = frame / self.duration
		if not self.forceClose then
			local percentFrame = math.ceil(percent * #self.curve)
			self.curAlpha = self.curve[percentFrame] * self.alpha
		else
			percent = 1 - percent
			self.curAlpha = percent * self.alpha
		end
		
		self.curAlpha = _min(1, self.curAlpha)
		self.curAlpha = _max(0, self.curAlpha)
		self.invokeCmp:UpdateRadialBlurAlpha(self.curAlpha)
	else
		self:Reset()
	end
end

function RadialBlurProc:UpdateState(params)
	if params.instanceId ~= self.entity.instanceId then
		return 
	end
	
	self.frame = 0
	self.duration = params.frame
	self.alpha = self.curAlpha
	self.forceClose = true
end

function RadialBlurProc:UpdateRadialBlurParams(params)
	self.params = params
	if params.Strength then
		local centerX = self.params.Center.x or self.params.Center[1]
		local centerY = self.params.Center.y or self.params.Center[2]
		self.invokeCmp:SetRadialBlurParams(self.params.Strength, self.params.Dir, self.params.Radius, self.params.Count,
			centerX, centerY, self.params.Alpha, self.params.Direction, self.transform)
	end
	self.frame = 0
	self.duration = params.Duration
	self.alpha = params.Alpha
end

function RadialBlurProc:CanStart()
	return self.forceClose or not self.isWork
end

function RadialBlurProc:OnReset()
	self.invokeCmp:UpdateRadialBlurAlpha(DefaultAlpha)

	self.curve = nil
	self.duration = 0
end