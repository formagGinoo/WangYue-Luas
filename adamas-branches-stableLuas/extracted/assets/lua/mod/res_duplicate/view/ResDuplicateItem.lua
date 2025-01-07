ResDuplicateItem = BaseClass("ResDuplicateItem")

local colorVal = {
    [1] = Color(77/255, 82/255, 87/255, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
}

function ResDuplicateItem:__init()

end

function ResDuplicateItem:Destory()
    for k, data in pairs(self.awardItemMap) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", data.awardItem)
        GameObject.Destroy(data.obj)
	end
	self.awardItemMap = {}
end

function ResDuplicateItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    if not data.cfg then
        return
    end
    self.costVal = 0
	self.awardItemMap = {}
    self.parent = parent
    self.cfg = data.cfg
    self.index = data.index
    self.item:SetActive(true)
    self:UpdateView()
end

function ResDuplicateItem:UpdateView()
    local cfg = self.cfg
    self.FightBtn_btn.onClick:AddListener(self:ToFunc("GoDuplicate"))

    self.ResName_txt.text = cfg.name
    SingleIconLoader.Load(self.ResIcon, cfg.icon)

    self.CostInfo:SetActive(false)
    
    if cfg.type == ResDuplicateConfig.ResType.defRes then
        self:UpdateDefResInfo()
    elseif cfg.type == ResDuplicateConfig.ResType.bossRes then
        self:UpdateBossResInfo()
    end

    local curCostVal = mod.BagCtrl:GetItemCountById(ResDuplicateConfig.FightCostResId)
    local color = curCostVal >= self.costVal and colorVal[1] or colorVal[2]
    self.CostVal_txt.color = color
end

function ResDuplicateItem:UpdateDefResInfo()
    local cfg = self.cfg
    local resDupCtrl = mod.ResDuplicateCtrl
    local selectDupId = resDupCtrl:GetCurResOpenMaxDuplicateId(cfg.id)
    if not selectDupId then return end
    local dupCfg = ResDuplicateConfig.GetDuplicateInfo(selectDupId)
    if not dupCfg then return end
    local costVal = dupCfg.cost
    self.costVal = costVal
    self.CostVal_txt.text = costVal

    local costId = ResDuplicateConfig.FightCostResId
    local itemIcon = ItemConfig.GetItemIcon(costId)
    SingleIconLoader.Load(self.CostIcon, itemIcon, function ()
        self.CostInfo:SetActive(true)
    end)
    self:UpdateDropItemView(dupCfg)
end

function ResDuplicateItem:UpdateBossResInfo()
    local bossCfg = ResDuplicateConfig.GetBossDupLinkConfig(self.cfg.eco_id)
    if not bossCfg then return end

    local costVal = bossCfg.cost_energy
    self.CostVal_txt.text = costVal
    self.costVal = costVal

    local costId = ResDuplicateConfig.FightCostResId
    local itemIcon = ItemConfig.GetItemIcon(costId)
    SingleIconLoader.Load(self.CostIcon, itemIcon, function ()
        self.CostInfo:SetActive(true)
    end)

    self:UpdateDropItemView(bossCfg)
end

function ResDuplicateItem:UpdateDropItemView(cfg)
    local showRewardId = cfg.show_reward
    local rewardList = ItemConfig.GetReward2(showRewardId)
    for _, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward)
    end
end

function ResDuplicateItem:UpdateRewardInfo(reward)
    local obj = GameObject.Instantiate(self.DropItem)
    obj.transform:SetParent(self.DropContent.transform)
    
    local awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not awardItem then
        awardItem = CommonItem.New()
    end 

    local itemId = reward[1]
    local num = reward[2]
    local itemInfo = {template_id = itemId, count = num or 0, scale = 0.7}
    awardItem:InitItem(obj, itemInfo, true)
    table.insert(self.awardItemMap, {awardItem = awardItem, obj = obj})
end

function ResDuplicateItem:GoDuplicate()
    if not mod.ResDuplicateCtrl:CheckFightCost(self.costVal) then
        return
    end
    local cfg = self.cfg
    local mapId = cfg.trans_map_id
    local MapPos = BehaviorFunctions.GetTerrainPositionP(cfg.trans_position[2], cfg.trans_map_id, cfg.trans_position[1])
    WindowManager.Instance:CloseWindow(AdvMainWindowV2)
    mod.WorldMapCtrl:CacheTpRotation(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW)
    BehaviorFunctions.Transport(mapId, MapPos.x, MapPos.y, MapPos.z)
    -- local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    -- player.rotateComponent:SetRotation(Quat.New(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW))
end
