BlurMaskProc = BaseClass("BlurMaskProc", PostProcBase)

function BlurMaskProc:DoStartFrame()
	self.curve = CurveConfig.GetCurve(self.entity.entityId, self.params.StrengthCurveId)
	self.duration = self.params.Duration
	self.radius = self.params.Radius

	self.invokeCmp:AddPostProcess(self.procType, self.params.ID or 0)
	self.invokeCmp:SetBlurMaskParams(self.params.Radius, nil, self.params.EnableAreaCtrl,
		self.params.Pos[1], self.params.Pos[2], self.params.Pos[3], self.params.Pos[4], self.params.Distance)
end

local DefaultRadius = 0
function BlurMaskProc:DoFrame(frame)
	if frame < self.duration then
		if not self.curve then
			return
		end

		local percent = frame / self.duration
		local percentFrame = math.ceil(percent * #self.curve)
		local radius = self.curve[percentFrame] * self.radius
		self.invokeCmp:UpdateBlurMaskRadius(radius)
	else
		self:Reset()
	end
end

function BlurMaskProc:OnReset()
	self.invokeCmp:UpdateBlurMaskRadius(DefaultRadius)

	self.curve = nil
	self.duration = 0
	self.radius = DefaultRadius
end