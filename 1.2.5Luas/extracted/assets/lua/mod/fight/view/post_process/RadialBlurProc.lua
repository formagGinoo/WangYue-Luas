RadialBlurProc = BaseClass("RadialBlurProc", PostProcBase)

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
		transform = self.entity.clientEntity.clientTransformComponent:GetTransform(self.params.FollowTransform)
	end
	
	self.invokeCmp:AddPostProcess(self.procType, self.params.ID or 0)
	self.invokeCmp:SetRadialBlurParams(self.params.Strength, self.params.Dir, self.params.Radius, self.params.Count,
		self.params.Center[1], self.params.Center[2], self.params.Alpha, self.params.Direction, transform)
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

function RadialBlurProc:CanStart()
	return self.forceClose or not self.isWork
end

function RadialBlurProc:OnReset()
	self.invokeCmp:UpdateRadialBlurAlpha(DefaultAlpha)

	self.curve = nil
	self.duration = 0
end