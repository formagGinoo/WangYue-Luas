IdentityRewardItem = BaseClass("IdentityRewardItem", Module)

function IdentityRewardItem:__init()
	
end

function IdentityRewardItem:Destory()
	PoolManager.Instance:Push(PoolType.class, "CommonItem", self.commonItem)
end

function IdentityRewardItem:InitReward(object, rewardInfo)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.rewardInfo = rewardInfo

	--self.object:SetActive(false)
    
	self:Show()
end

function IdentityRewardItem:AddClickListener()
    if self.rewardInfo.state == IdentityConfig.RewardState.Reach then
        self.commonItem:SetBtnEvent(true,self:ToFunc("GetReward"))
    else
        self.commonItem:SetBtnEvent(false)
    end
end

function IdentityRewardItem:Show()
	self:SetRewardItem()
    self:UpdateReceiveInfo()
    self:AddClickListener()
	if self.defaultShow then
		self.object:SetActive(true)
	end
end

function IdentityRewardItem:UpdateReceiveInfo()
    if self.rewardInfo.state == IdentityConfig.RewardState.Reach then
        UtilsUI.SetActive(self.node.CanGet,true)
        UtilsUI.SetActive(self.node.Lock,false)
        UtilsUI.SetActive(self.node.Received,false)
    elseif self.rewardInfo.state == IdentityConfig.RewardState.UnReach then
        UtilsUI.SetActive(self.node.CanGet,false)
        UtilsUI.SetActive(self.node.Lock,true)
        self.node.LockTxt_txt.text = string.format(TI18N("%d级可领"),self.rewardInfo.lv)
        UtilsUI.SetActive(self.node.Received,false)
    elseif self.rewardInfo.state == IdentityConfig.RewardState.Received then
        UtilsUI.SetActive(self.node.CanGet,false)
        UtilsUI.SetActive(self.node.Lock,false)
        UtilsUI.SetActive(self.node.Received,true)
    end
end

function IdentityRewardItem:SetRewardItem()
	self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not self.commonItem then
        self.commonItem = CommonItem.New()
    end
    self.commonItem:InitItem(self.node.CommonItem, ItemConfig.GetItemConfig(self.rewardInfo[1]))
    self.commonItem:SetNum(self.rewardInfo[2])
end

function IdentityRewardItem:SetItemCount(item,count)
	item.node.Level:SetActive(true)
	item.node.Level_txt.text = "x" .. count
end

function IdentityRewardItem:GetReward()
    EventMgr.Instance:Fire(EventName.IdentityGetReward)
end

function IdentityRewardItem:OnReset()

end