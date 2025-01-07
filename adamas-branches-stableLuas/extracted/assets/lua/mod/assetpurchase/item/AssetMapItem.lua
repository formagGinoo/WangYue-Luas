
AssetMapItem = BaseClass("AssetMapItem", Module)

function AssetMapItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.isSelect = false
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function AssetMapItem:InitItem(object, assetInfo, defaultShow)
	self.object = object
	UtilsUI.SetActive(self.object,true)
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.assetInfo = assetInfo
	self.assetConfig = AssetPurchaseConfig.GetAssetConfigById(self.assetInfo.asset_id)
	self.assetPurchase = AssetPurchaseConfig.GetAssetPurchaseConfigById(self.assetInfo.asset_id)
	self:Show()
end

function AssetMapItem:Show()
	self:SetShowIcon()
	self:SetMainInfo()
	self:SetStateIcon()
	self:SetSelectBox(self.isSelect)
end

function AssetMapItem:SetShowIcon()
	SingleIconLoader.Load(self.node.Pic,self.assetPurchase.asset_basic_icon)
end

function AssetMapItem:SetMainInfo()
	self.node.Name_txt.text = self.assetConfig.name
	self.node.LvText_txt.text = "Lv.".. self.assetInfo.level
end

function AssetMapItem:SetStateIcon()
	local partCount = #self.assetInfo.partner_list
	if partCount == 0 then
		UtilsUI.SetActive(self.node.StateIcon,false)
		return
	end
	local badCount = 0
	for i, v in ipairs(self.assetInfo.partner_list) do
		local state = mod.PartnerBagCtrl:GetAssetPartnerState(v) 
		if state == FightEnum.PartnerStatusEnum.Hunger 
		    or state == FightEnum.PartnerStatusEnum.Sad
			or state == FightEnum.PartnerStatusEnum.HungerAndSad then
				badCount = badCount + 1
		end
	end
	local persent = badCount / partCount * 100
	SingleIconLoader.Load(self.node.StateIcon,AssetPurchaseConfig.GetAssetStateIcon(persent))
end

function AssetMapItem:SetSelectBox(state)
	UtilsUI.SetActive(self.node.SelectBox,state)
end

function AssetMapItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.ClickBtn_btn
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

function AssetMapItem:OnReset()

end