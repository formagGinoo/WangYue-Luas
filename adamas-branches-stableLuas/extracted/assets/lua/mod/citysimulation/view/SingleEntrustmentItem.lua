SingleEntrustmentItem = BaseClass("SingleEntrustmentItem")

function SingleEntrustmentItem:UpdateData(data)
    self.transform = data.object.transform
    self.data = data
    self.parentWindow = data.parentWindow
    self.transform:SetActive(true)
    UnityUtils.SetLocalScale(self.transform, 1,1,1)
    UnityUtils.SetAnchored3DPosition(self.transform, 0,0,0)
    UtilsUI.GetContainerObject(self.transform, self)

    local costIconID = CitySimulationConfig:GetVITIconID()  
    self.ItemIcon_img.color = Color(1,1,1,0)              -- 防止默认贴图白屏
    SingleIconLoader.Load(self.ItemIcon, data.icon, function()
        self.ItemIcon_img.color = Color(1,1,1,1)
    end)
    SingleIconLoader.Load(self.VITCostIcon, ItemConfig.GetItemIcon(costIconID))
    self.DesText_txt.text = TI18N(data.name)
    self.VITCostAmount_txt.text = data.cost
    self.rewardItemDic = {}
    
    -- 生成通用物品组件
    self:UpdateRewardList(data.rewardID)

    self.GoButton_btn.onClick:RemoveAllListeners()
    self.GoButton_btn.onClick:AddListener(function()
        -- 注册跳转事件
        mod.WorldMapCtrl:CacheEnterMapCallback(function()
            WindowManager.Instance:OpenWindow(EntrustmentChoiceWindow, {shopId = data.shopID})
        end)

        WindowManager.Instance:CloseWindow(self.parentWindow)

        local mapID = self.data.trans_map_id
        local mapPos = BehaviorFunctions.GetTerrainPositionP(self.data.trans_position[2], mapID, self.data.trans_position[1])
        mod.WorldMapCtrl:CacheTpRotation(mapPos.rotX, mapPos.rotY, mapPos.rotZ, mapPos.rotW)

        BehaviorFunctions.Transport(mapID, mapPos.x, mapPos.y, mapPos.z)
    end)
    
    self.GoText_txt.text = TI18N("前往")
end

function SingleEntrustmentItem:Delete()
    for _, data in pairs(self.rewardItemDic) do
        PoolManager.Instance:Push(PoolType.class, "CommonItem", data.rewardItem)
        GameObject.Destroy(data.object)
    end
    self.rewardItemDic = {}
end

function SingleEntrustmentItem:UpdateRewardList(_rewardID)
    local rewardList = ItemConfig.GetReward2(_rewardID)     -- 获取奖励列表
    for _, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward)
    end
end

function SingleEntrustmentItem:UpdateRewardInfo(_reward)
    local obj = GameObject.Instantiate(self.CommonItem)
    obj.transform:SetParent(self.Content.transform)

    local rewardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not rewardItem then
        rewardItem = CommonItem.New()
    end

    local itemId = _reward[1]
    local num = _reward[2]
    local itemInfo = {template_id = itemId, count = num or 0, scale = 0.8}
    rewardItem:InitItem(obj, itemInfo, true)
    table.insert(self.rewardItemDic, {rewardItem = rewardItem, object = obj})
end