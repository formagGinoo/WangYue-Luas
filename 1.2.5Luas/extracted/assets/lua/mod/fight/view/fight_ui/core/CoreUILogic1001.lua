CoreUILogic1001 = BaseClass("CoreUILogic1001", CoreUIBase)

local MaxProcess = 3

function CoreUILogic1001:OnInit()
	self.activeProcess = {}
	self.nextIdx = 1
	
	for i = 1, MaxProcess do
		self:SetObjActive(self.ui["Process"..i], false)
	end
	self:SetObjActive(self.ui.ActiveBg, false)
end

function CoreUILogic1001:UpdatePercent(value, maxValue)
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

	self:SetObjActive(self.ui.ActiveBg, #self.activeProcess == MaxProcess)

	if #self.activeProcess == 0 then
		self.nextIdx = 1
	end
end

function CoreUILogic1001:UpdateEffectVisible(percent)
	for _, v in pairs(self.effectUtils) do
		v:SetKeywordValue("_BaseColor", Color(1, 1, 1, percent))
	end
end

function CoreUILogic1001:Cache()
	self.activeProcess = {}
	Fight.Instance.objectPool:Cache(CoreUILogic1001,self)
end