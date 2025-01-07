
SimpleDeviceItem = BaseClass("SimpleDeviceItem", Module)

function SimpleDeviceItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.isSelect = false
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function SimpleDeviceItem:InitItem(object, deviceInfo, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.deviceInfo = deviceInfo
	self:Show()
end

function SimpleDeviceItem:Show()
	self:SetShowIcon()
	self:SetMainInfo()
end

function SimpleDeviceItem:SetShowIcon()
	SingleIconLoader.Load(self.node.Icon,self.deviceInfo.icon)
end

function SimpleDeviceItem:SetMainInfo()
	self.node.Name_txt.text = self.deviceInfo.name
	if self.deviceInfo.unlock_des and self.deviceInfo.unlock_des ~= "" then
		self.node.UnLockTips_txt.text = self.deviceInfo.unlock_des
	else
		UtilsUI.SetActive(self.node.UnLockTip,false)
	end
end

function SimpleDeviceItem:OnReset()

end