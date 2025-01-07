
DeviceInfoItem = BaseClass("DeviceInfoItem", Module)

function DeviceInfoItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.isSelect = false
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function DeviceInfoItem:InitItem(object, deviceInfo, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.deviceInfo = deviceInfo
	self:Show()
end

function DeviceInfoItem:Show()
	self:SetShowIcon()
	self:SetMainInfo()
end

function DeviceInfoItem:SetShowIcon()
	SingleIconLoader.Load(self.node.DeviceIcon,self.deviceInfo.asset_basic_icon)
end

function DeviceInfoItem:SetMainInfo()
	self.node.DeviceName_txt.text = self.deviceInfo.name
	self.node.DeviceDesc_txt.text = self.deviceInfo.des
	if self.deviceInfo.unlock_des then
		self.node.TipsText_txt.text = self.deviceInfo.unlock_des
	else
		UtilsUI.SetActive(self.node.Tips,false)
	end
end

function DeviceInfoItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.MoreInfoBtn_btn
	if noShowPanel and not btnFunc then
		itemBtn.enabled = false
	else
		itemBtn.enabled = true
		local onclickFunc = function()
			if btnFunc then
				btnFunc()
				if onClickRefresh then
					self:Show()
				end
				return
			end
			if not noShowPanel then ItemManager.Instance:ShowItemTipsPanel(self.itemInfo) end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end

function DeviceInfoItem:OnReset()

end