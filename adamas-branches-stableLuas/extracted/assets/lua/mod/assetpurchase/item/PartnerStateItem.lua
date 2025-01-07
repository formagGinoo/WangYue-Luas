
PartnerStateItem = BaseClass("PartnerStateItem", Module)

function PartnerStateItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function PartnerStateItem:InitItem(object, partnerId, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")

	if self.commonItem == nil then
		self.commonItem = CommonItem.New()
	end

	self.partnerId = partnerId
	self.partnerInfo = mod.BagCtrl:GetPartnerData(partnerId)
	self.partnerWorkInfo = mod.PartnerBagCtrl:GetPartnerWorkInfo(partnerId)
	self:Show()
end

function PartnerStateItem:Show()
	self:SetShowIcon()
	self:SetMainInfo()
end

function PartnerStateItem:SetShowIcon()
	self.commonItem:InitItem(self.node.CommonItem,self.partnerInfo)
	self.commonItem:HideEquipedInfo()
end

function PartnerStateItem:SetMainInfo()
	local state = mod.PartnerBagCtrl:GetAssetPartnerState(self.partnerId)
	if state == FightEnum.PartnerStatusEnum.Sad or state == FightEnum.PartnerStatusEnum.HungerAndSad then
		UtilsUI.SetActive(self.node.Sad,true)
		UtilsUI.SetActive(self.node.Hunger,false)
	elseif state == FightEnum.PartnerStatusEnum.Hunger then
		UtilsUI.SetActive(self.node.Sad,false)
		UtilsUI.SetActive(self.node.Hunger,true)
	else
		UtilsUI.SetActive(self.node.Sad,false)
		UtilsUI.SetActive(self.node.Hunger,false)
	end

	local desc = mod.PartnerBagCtrl:GetPartnerStateText(self.partnerId)
	self.node.WorkInfo_txt.text = desc
	-- if self.partnerWorkInfo.status == 0 then -- 无
	-- 	self.node.WorkInfo_txt.text = TI18N("没有工作安排")
	-- elseif self.partnerWorkInfo.status == 1 then -- 工作
	-- 	local deviceName = AssetPurchaseConfig.GetAssetDeviceInfoById(mod.AssetPurchaseCtrl:GetAssetDeviceConfigId(self.partnerWorkInfo.asset_id, self.partnerWorkInfo.work_decoration_id)).name
	-- 	self.node.WorkInfo_txt.text = string.format(TI18N("【%s】工作中"),deviceName)
	-- elseif self.partnerWorkInfo.status == 2 then -- 吃饭
	-- 	self.node.WorkInfo_txt.text = TI18N("吃饭")
	-- elseif self.partnerWorkInfo.status == 3 then -- 睡觉
	-- 	self.node.WorkInfo_txt.text = TI18N("睡觉")
	-- end
end

function PartnerStateItem:OnReset()

end