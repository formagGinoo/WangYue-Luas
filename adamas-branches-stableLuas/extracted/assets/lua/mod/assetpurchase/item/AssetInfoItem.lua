AssetInfoItem = BaseClass("AssetInfoItem", Module)
function AssetInfoItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.isSelect = false
	self.isExisting = false
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function AssetInfoItem:InitItem(object, assetInfo, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.assetInfo = assetInfo
	self.isExisting = mod.AssetPurchaseCtrl:GetExistingAssetInfoById(self.assetInfo.asset_id)
	self:Show()
end

function AssetInfoItem:Show()
	self:SetShowIcon()
	self:SetCost()
	self:SetMainInfo()
	self:SetBtnState()
end

function AssetInfoItem:SetShowIcon()
	SingleIconLoader.Load(self.node.ShowIcon,self.assetInfo.asset_basic_icon)
end

function AssetInfoItem:SetCost()
	if self.isExisting then
		UtilsUI.SetActiveByScale(self.node.Cost,false)
		return
	end
	UtilsUI.SetActiveByScale(self.node.Cost,true)
	local showCost = AssetPurchaseConfig.GetAssetAgreementById(self.assetInfo.id).show_cost
	SingleIconLoader.Load(self.node.CostIcon, ItemConfig.GetItemIcon(showCost[1][1]))
	self.node.CostCount_txt.text = showCost[1][2]
end

function AssetInfoItem:SetMainInfo()
	local assetConfig = AssetPurchaseConfig.GetAssetConfigById(self.assetInfo.asset_id)
	self.node.NameText_txt.text = assetConfig.name
	self.node.DescText_txt.text = assetConfig.des
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.node.DescText.transform.parent)
end

function AssetInfoItem:SetBtnState()
	if self.isExisting then
		UtilsUI.SetActive(self.node.Lv,true)
		UtilsUI.SetActive(self.node.MoreInfoBtn,true)
		self.node.MoreInfoText_txt.text = TI18N("前往资产")
		self.node.LvTxt_txt.text = "Lv."..self.isExisting.level
		UtilsUI.SetActive(self.node.UnLockTips,false)
		return 
	end

	UtilsUI.SetActive(self.node.Lv,false)
	local isPass,desc = Fight.Instance.conditionManager:CheckConditionByConfig(self.assetInfo.condition)
	if isPass then
		UtilsUI.SetActive(self.node.MoreInfoBtn,true)
		self.node.MoreInfoText_txt.text = TI18N("进一步了解")
		UtilsUI.SetActive(self.node.UnLockTips,false)
	else
		desc = Fight.Instance.conditionManager:GetConditionDesc(self.assetInfo.condition)
		UtilsUI.SetActive(self.node.MoreInfoBtn,false)
		UtilsUI.SetActive(self.node.UnLockTips,true)
		self.node.UnLockText_txt.text = desc
	end
end

function AssetInfoItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
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

function AssetInfoItem:OnReset()

end