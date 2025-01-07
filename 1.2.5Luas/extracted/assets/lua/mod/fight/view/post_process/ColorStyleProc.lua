ColorStyleProc = BaseClass("ColorStyleProc", PostProcBase)

function ColorStyleProc:DoStartFrame()
	self.curve = CurveConfig.GetCurve(self.entity.entityId, self.params.GrayOffsetCurveId)
	self.duration = self.params.Duration
	self.grayOffset = self.params.GrayOffset

	local blackColor = self.params.BlackAreaColor
	local whiteColor = self.params.WhiteAreaColor
	local blackAreaColor = Color(blackColor[1], blackColor[2], blackColor[3], blackColor[4])
	local whiteAreaColor = Color(whiteColor[1], whiteColor[2], whiteColor[3], whiteColor[4])
	
	self.invokeCmp:AddPostProcess(self.procType, self.params.ID or 0)
	self.invokeCmp:SetColorStyleParams(self.params.ColorStyleAlpha, self.params.GrayOffset,
		blackAreaColor, whiteAreaColor, self.params.ColorInvert)
end

local DefaultGrayOffset = 0
function ColorStyleProc:DoFrame(frame)
	if frame < self.duration then
		if not self.curve then
			return
		end
		
		local percent = frame / self.duration
		local percentFrame = math.ceil(percent * #self.curve)
		local grayOffset = self.curve[percentFrame] * self.grayOffset
		self.invokeCmp:UpdateColorStyleGrayOffset(grayOffset)
	else
		self:Reset()
	end
end

function ColorStyleProc:OnReset()
	self.invokeCmp:UpdateColorStyleGrayOffset(DefaultGrayOffset)

	self.curve = nil
	self.duration = 0
	self.radius = DefaultGrayOffset
end