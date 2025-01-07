CoreUILogic1005 = BaseClass("CoreUILogic1005", CoreUIBase)

local MaxProcess = 3

function CoreUILogic1005:OnInit()
	self.activeProcess = {}
	self.nextIdx = 1
	self.nowValue = 0

	for i = 1, MaxProcess do
		self:SetObjActive(self.ui["Process"..i], false)
	end
	-- self:SetObjActive(self.ui.ActiveBg, false)
end

function CoreUILogic1005:UpdatePercent(value, maxValue)
	if value == 0 and self.nowValue then
		for i = 1, self.nowValue, 1 do
			self:SetObjActive(self.ui["CoreUI1005_xiaoshi"..i], true)
		end
	end
	self.nowValue = value
	value = math.min(value, MaxProcess)
	local offset = value - #self.activeProcess

	if offset == 0 then return end

	if offset < 0 then
		offset = -offset
		for i = 1, offset do
			if #self.activeProcess == 0 then
				break
			end
			--self.nextIdx = self.nextIdx > self.activeProcess[1] and self.activeProcess[1] or self.nextIdx
			table.remove(self.activeProcess, 1)
		end
	else
		for i = 1, offset do
			table.insert(self.activeProcess, self.nextIdx)
			self.nextIdx = (self.nextIdx % MaxProcess) + 1
		end
	end

	for i = 1, MaxProcess do
		local showIcon = false
		for j = 1, #self.activeProcess do
			showIcon = self.activeProcess[j] == i
			if showIcon then break end
		end
		self:SetObjActive(self.ui["Process"..i], showIcon)
	end

	-- self:SetObjActive(self.ui.ActiveBg, #self.activeProcess == MaxProcess)

	if #self.activeProcess == 0 then
		self.nextIdx = 1
	end
end

function CoreUILogic1005:Cache()
	self.activeProcess = {}
	Fight.Instance.objectPool:Cache(CoreUILogic1005,self)
end