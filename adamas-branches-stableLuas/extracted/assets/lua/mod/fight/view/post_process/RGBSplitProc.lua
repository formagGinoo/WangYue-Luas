RGBSplitProc = BaseClass("RGBSplitProc", PostProcBase)

function RGBSplitProc:DoStartFrame()
	self.curve = CurveConfig.GetCurve(self.entity.entityId, self.params.FadingCurveId)
	self.duration = self.params.Duration
	self.fading = self.params.Fading
	
	self.invokeCmp:AddPostProcess(self.procType, self.params.ID or 0)
	self.invokeCmp:SetRGBSplitParams(self.params.SplitDirection, self.params.Amount, self.params.Speed, 
		self.params.Fading, self.params.CenterFading, self.params.AmountR, self.params.AmountB)
end

local DefaultFading = 0
function RGBSplitProc:DoFrame(frame)
	if frame < self.duration then
		if not self.curve then
			return 
		end
		
		local percent = frame / self.duration
		local percentFrame = math.ceil(percent * #self.curve)
		local fading = self.curve[percentFrame] * self.fading
		self.invokeCmp:UpdateRGBSplitFading(fading)
	else
		self:Reset()
	end
end

function RGBSplitProc:OnReset()
	self.invokeCmp:UpdateRGBSplitFading(DefaultFading)

	self.curve = nil
	self.duration = 0
end