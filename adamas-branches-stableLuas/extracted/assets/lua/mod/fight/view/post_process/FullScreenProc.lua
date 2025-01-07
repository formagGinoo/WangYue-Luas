FullScreenProc = BaseClass("FullScreenProc", PostProcBase)

local DefaultColorFilter = Color(1, 1, 1)
function FullScreenProc:DoStartFrame()
	self.enterTime = self.params.EnterTime
	self.duration = self.enterTime + self.params.Duration
	self.exitTime = self.params.ExitTime
	self.fullTime = self.duration + self.exitTime
	local r = self.params.ColorFilter.r or self.params.ColorFilter[1]
	local g = self.params.ColorFilter.g or self.params.ColorFilter[2]
	local b = self.params.ColorFilter.b or self.params.ColorFilter[3]
	local a = self.params.ColorFilter.a or self.params.ColorFilter[4]
	self.colorFilter = Color(r, g, b, a)
	
	self.invokeCmp:AddPostProcess(self.procType, self.params.ID or 0)
	self.invokeCmp:SetFullScreenParams(DefaultColorFilter, self.params.StencilRef, self.params.ReadMask,
		self.params.WriteMask, self.params.StencilCompare)
end

function FullScreenProc:DoFrame(frame)
	if frame < self.fullTime then
		local startColor, endColor, percent
		if frame <= self.enterTime then
			percent = frame / self.enterTime
			startColor = DefaultColorFilter
			endColor = self.colorFilter
		elseif frame >= self.duration and frame < self.fullTime then
			percent = (frame - self.duration) / self.exitTime
			startColor = self.colorFilter
			endColor = DefaultColorFilter
		end
		
		if percent then
			local color = Color.Lerp(startColor, endColor, percent)
			self.invokeCmp:UpdateFullScreenColorFilter(color)
		end
	else
		self.invokeCmp:UpdateFullScreenColorFilter(DefaultColorFilter)
		self:Reset()
	end
end

function FullScreenProc:EndProcess()
	self.frame = self.duration
end

function FullScreenProc:OnReset()
	self.invokeCmp:UpdateFullScreenColorFilter(DefaultColorFilter)

	self.enterTime = 0
	self.exitTime = 0
	self.duration = 0
	self.fullTime = 0
	self.colorFilter = nil
end