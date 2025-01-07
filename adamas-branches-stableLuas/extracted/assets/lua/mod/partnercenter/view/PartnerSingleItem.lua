PartnerSingleItem = BaseClass("PartnerSingleItem", Module)

function PartnerSingleItem:__init()

end

function PartnerSingleItem:__delete()
    if self.partnerItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.partnerItem)
    end
end

function PartnerSingleItem:InitItem(object, partnerData, indexMap)
	-- 获取对应的组件
	self.node = object
    UtilsUI.SetActive(self.node.object, true)
    self:SetData(partnerData, indexMap)
	self:Show()
end

function PartnerSingleItem:SetData(partnerData, indexMap)
    self.partnerData = partnerData
    self.indexMap = indexMap
    self.partnerItem = nil

    self.partnerId = partnerData and self.partnerData.template_id
    self.uniqueId = partnerData and self.partnerData.unique_id
    self.partnerConfig = partnerData and RoleConfig.GetPartnerConfig(self.partnerId)
end

function PartnerSingleItem:Show()
    self.node.AddBtn_btn.onClick:RemoveAllListeners()
    UtilsUI.SetActive(self.node.CommonItem, self.partnerData ~= nil)
    UtilsUI.SetActive(self.node.AddItem, self.partnerData == nil)
    self:UpdatePartnerState()
    if self.partnerData then
        self.partnerItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not self.partnerItem then
            self.partnerItem = CommonItem.New()
        end
        local partnerItemData = TableUtils.CopyTable(self.partnerData)
        partnerItemData.hero_id = nil   -- 不先显示在哪个角色上
        partnerItemData.work_info = nil -- 不显示来源哪个资产
        self.partnerItem:InitItem(self.node.CommonItem, partnerItemData)
        self.partnerItem:SetBtnEvent(false, self:ToFunc("OnClickPartnerBtn"))
    else
        self.node.AddBtn_btn.onClick:AddListener(self:ToFunc("OnClickPartnerBtn"))
    end
end

function PartnerSingleItem:UpdatePartnerState()
    local state = mod.PartnerBagCtrl:GetAssetPartnerState(self.uniqueId)
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
end

function PartnerSingleItem:OnClickPartnerBtn()
    PartnerWorkMgrWindow.OpenWindow(self.uniqueId, self.indexMap)
end

function PartnerSingleItem:OnReset()
end