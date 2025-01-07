SingleEntrustmentCardItem = BaseClass("SingleEntrustmentCardItem")

function SingleEntrustmentCardItem:UpdateData(data)
    self.object = data.object
    self.transform = self.object.transform
    self.transform:SetParent(data.parent)
    self.transform.localScale = Vector3.one
    self.object:SetActive(true)
    self.index = data.index
    self.isSelect = false
    self.entrustmentID = data.entrust_id
    UtilsUI.GetContainerObject(self.transform, self)

    -- 清空列表内对象
    self:Delete()
    
    -- 普通委托
    if data.entrust_type == 1 then
        if data.entrust_show_type == 2 then
            self:UpdateData_Fight(data)
        else
            self:UpdateData_Common(data)
        end
    end    
        
    -- 紧急委托    
    if data.entrust_type == 2 then
        self:UpdateData_Urgent(data)
    end
    
    self:UpdateRewardList(data.show_reward)
    
    -- 绑定点击按钮事件
    self:InitClickEvent()
end 

function SingleEntrustmentCardItem:UpdateData_Common(data)
    self.EnemyInfoArea.transform:SetActive(false)
    self.WuXingType.transform:SetActive(false)
    self.CommonType.transform:SetActive(true)
    self.UrgentType.transform:SetActive(false)

    local costIconID = CitySimulationConfig:GetVITIconID()
    SingleIconLoader.Load(self.VITIcon, ItemConfig.GetItemIcon(costIconID))
    SingleIconLoader.Load(self.CommonTitleIcon, data.icon)
    self.VITCostAmount_txt.text = data.cost
    
    self.EntrustmentTitleName_txt.text = TI18N(data.name)
    self.EntrustmentDesc_txt.text = TI18N(data.dec)
    self.RewardInfoText_txt.text = TI18N("可能获取")
end

function SingleEntrustmentCardItem:UpdateData_Fight(data)
    self.EnemyInfoArea.transform:SetActive(true)
    self.WuXingType.transform:SetActive(true)
    self.CommonType.transform:SetActive(false)
    self.UrgentType.transform:SetActive(false)

    -- 五行
    self.WuXingText_txt_text = TI18N("推荐五行")
    for i = 1, #data.show_element_id do
        if data.show_element_id[i] ~= 0 then
            local name = self["WuXingIcon" .. tostring(i) .. "_img"]
            name.color = Color(1, 1, 1, 1)
            SingleIconLoader.Load(self["WuXingIcon" .. tostring(i)], CitySimulationConfig:GetElementIconPath(data.show_element_id[i])) 
        end
    end
    
    local costIconID = CitySimulationConfig:GetVITIconID()
    SingleIconLoader.Load(self.VITIcon, ItemConfig.GetItemIcon(costIconID))
    SingleIconLoader.Load(self.WuXingTitleIcon, data.icon)
    self.VITCostAmount_txt.text = data.cost

    self.EntrustmentTitleName_txt.text = TI18N(data.name)
    self.EntrustmentDesc_txt.text = TI18N(data.dec)
    self.RewardInfoText_txt.text = TI18N("可能获取")
    
    self:UpdateEnemyInfoList(data)
end

function SingleEntrustmentCardItem:UpdateData_Urgent(data)

end

function SingleEntrustmentCardItem:InitClickEvent()
    self.isSelect = false
    self.Unselect:SetActive(true)
    self.Select:SetActive(false)

    self._btn.onClick:RemoveAllListeners()
    self._btn.onClick:AddListener(function() 
        EventMgr.Instance:Fire(EventName.RefreshCardsSelectState, self.index, self.entrustmentID)
    end)
end

-- 更新敌人信息列表
function SingleEntrustmentCardItem:UpdateEnemyInfoList(data)
    self.enemyItemList = {}
    
    local len = TableUtils.GetTabelLen(data.show_monster_id)
    for i = 1, len do
        if data.show_monster_id[i] ~= 0 then
            local go = GameObject.Instantiate(self.SingleEnemyItem)
            local item = SingleEnemyItem.New()
            table.insert(self.enemyItemList, { item = item, object = go })
            
            local enemyData = CitySimulationConfig:GetEnemyIconInfoByID(data.show_monster_id[i])
            enemyData.obj = go
            enemyData.parent = self.EnemyContent_rect
            item:UpdateData(enemyData)
        end
    end
end

-- 刷新奖励列表
function SingleEntrustmentCardItem:UpdateRewardList(_id)
    self.rewardItemList = {}
    
    local rewardList = ItemConfig.GetReward2(_id)
    for _, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward)
    end
end

function SingleEntrustmentCardItem:UpdateRewardInfo(_reward)
    local obj = GameObject.Instantiate(self.RewardItem)
    obj.transform:SetParent(self.RewardContent.transform)
    UnityUtils.SetAnchored3DPosition(obj.transform, 0, 0, 0)

    local awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not awardItem then
        awardItem = CommonItem.New()
    end

    local itemId = _reward[1]
    local num = _reward[2]
    local itemInfo = {template_id = itemId, count = num or 0, scale = 0.8}
    awardItem:InitItem(obj, itemInfo, true)
    table.insert(self.rewardItemList, {awardItem = awardItem, obj = obj})
end

function SingleEntrustmentCardItem:SetScrollRectActive(_handle)
    local rectView = self.ItemScrollView.transform:GetComponent(ScrollRect)
    rectView.enabled = _handle;
end

-- 删除实例化出来的对象
function SingleEntrustmentCardItem:Delete()
    -- 奖励列表
    if self.rewardItemList then
        for _, data in pairs(self.rewardItemList) do
            PoolManager.Instance:Push(PoolType.class, "CommonItem", data.awardItem)
            GameObject.Destroy(data.obj)
        end
        self.rewardItemList = {}
    end
    
    -- 敌人列表
    if self.enemyItemList then
        for _, data in pairs(self.enemyItemList) do
            data.item = nil
            GameObject.Destroy(data.object)
        end
        self.enemyItemList = {}
    end
end 