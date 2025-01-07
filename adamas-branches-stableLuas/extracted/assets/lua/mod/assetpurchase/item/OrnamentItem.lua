
OrnamentItem = BaseClass("OrnamentItem", Module)

function OrnamentItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.isSelect = false
	self.loadDone = false
	self.defaultShow = true
end

function OrnamentItem:InitItem(object, ornamentInfo, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.ornamentInfo = ornamentInfo
	self:Show()
end

function OrnamentItem:Show()
	self:SetShowIcon()
	self:SetSelect(self.isSelect)
end

function OrnamentItem:SetShowIcon()
	SingleIconLoader.Load(self.node.OrnamentItem,self.ornamentInfo.icon)
end

function OrnamentItem:SetSelect(state)
	UtilsUI.SetActive(self.node.Select,state)
end

function OrnamentItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.OrnamentItem_btn
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

function OrnamentItem:OnReset()

end