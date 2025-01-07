CoreUILogic1006 = BaseClass("CoreUILogic1006", CoreUIBase)

local MaxProcess = 3
function CoreUILogic1006:OnInit()
	self.activeProcess = {}
	self.nextIdx = 1
	
	for i = 1, MaxProcess do
		self:SetObjActive(self.ui["Process"..i], false)
	end
	self:SetObjActive(self.ui.ActiveBg, false)
	self:SetObjActive(self.ui.NormalBg, false)
	UtilsUI.SetHideCallBack(self.ui.CoreUI1006_Open, self:ToFunc("SwitchStateToChongNeng"))
end

local AnimationState = {
	ChongNeng = 1,
	BaoFa = 2,
}

function CoreUILogic1006:UpdatePercent(value, maxValue)
	value = math.min(value, MaxProcess)
	local offset = value - #self.activeProcess

	if offset == 0 then return end

	if offset < 0 then
		offset = -offset
		for i = 1, offset do
			if #self.activeProcess == 0 then
				break
			end
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
		self:SetObjActive(self.ui["ProcessBg"..i], not showIcon and self.state ~= AnimationState.BaoFa)
	end

	self:SetObjActive(self.ui.NormalBg, value > 0 and #self.activeProcess ~= MaxProcess)
	self:SetObjActive(self.ui.OriginBg, value == 0 and self.state == AnimationState.ChongNeng)
	self:SetObjActive(self.ui.ActiveBg, #self.activeProcess == MaxProcess)

	if #self.activeProcess == 0 then
		self.nextIdx = 1
	end
end

function CoreUILogic1006:ShowEffect(entity, index)
	if entity.entityId ~= 1006 then
		return
	end
	if index == 1 then
		self:SetObjActive(self.ui.CoreUI1006_Open, true)
		self.state = AnimationState.BaoFa
	end
end

function CoreUILogic1006:SwitchStateToChongNeng()
	self.state = AnimationState.ChongNeng
	for i = 1, MaxProcess, 1 do
		self:SetObjActive(self.ui["ProcessBg"..i], true)
	end
	self:SetObjActive(self.ui.OriginBg, true)
end

function CoreUILogic1006:Cache()
	Fight.Instance.objectPool:Cache(CoreUILogic1006,self)
end