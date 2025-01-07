SingleEntrustmentGradeItem = BaseClass("SingleEntrustmentGradeItem")

function SingleEntrustmentGradeItem:UpdateData(data)
    self.object = data.object
    self.transform = self.object.transform
    self.index = data.index
    self.rewardList = {}
    UtilsUI.GetContainerObject(self.transform, self)

    SingleIconLoader.Load(self.RewardIcon, data.icon)
    
    local name = CitySimulationConfig:GetStoreEntrustMainData(data.entrust_id).name
    self.RewardText_txt.text = TI18N(name)
    
    self:UpdateRewardList(data.show_reward)
end 

function SingleEntrustmentGradeItem:UpdateRewardList(_rewardID)
    local rewardList = ItemConfig.GetReward2(_rewardID)     -- 获取奖励列表
    for _, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward)
    end
end

function SingleEntrustmentGradeItem:UpdateRewardInfo(_reward)
    local obj = GameObject.Instantiate(self.Item)
    obj.transform:SetParent(self.CommonItemContent.transform)

    local rewardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not rewardItem then
        rewardItem = CommonItem.New()
    end

    local itemId = _reward[1]
    local num = _reward[2]
    local itemInfo = {template_id = itemId, count = num or 0, scale = 0.8}
    rewardItem:InitItem(obj, itemInfo, true)
    table.insert(self.rewardList, {rewardItem = rewardItem, object = obj})
end

function SingleEntrustmentGradeItem:Delete()
    for _, data in pairs(self.rewardList) do
        PoolManager.Instance:Push(PoolType.class, "CommonItem", data.rewardItem)
        GameObject.Destroy(data.object)
    end
    self.rewardList = {}
end 