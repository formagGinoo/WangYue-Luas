ResDuplicateWindow = BaseClass("ResDuplicateWindow", BaseWindow)

local colorVal = {
    [1] = Color(1, 1, 1, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
}

function ResDuplicateWindow:__init()
    self:SetAsset("Prefabs/UI/ResDuplicate/ResDuplicateWindow.prefab")
end

function ResDuplicateWindow:__CacheObject()

end

function ResDuplicateWindow:__ShowComplete()

end

function ResDuplicateWindow:__BindListener()

    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClickClose"))
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self.GoFight_btn.onClick:AddListener(self:ToFunc("GoDuplicate"))
end

function ResDuplicateWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function ResDuplicateWindow:__Show()
    self.resDupId = self.args[1]
    self.dupItemMap = {}
    self.showMonsterMap = {}

    self.selectIdx = nil
    self.awardItemMap = {}
    self.monsterItemMap = {}

    self:UpdateDupList()
    self:InitCurrencyBar()
    
    local idx = self:GetCurOpenMaxIdx()
    self:SelectDup(idx)
    Fight.Instance.entityManager:CallBehaviorFun("OpenResDuplicateWindow")
end

function ResDuplicateWindow:__Hide()
    self:CacheCurrencyBar()

    self:ResetDupInfo()
    Fight.Instance.entityManager:CallBehaviorFun("CloseResDuplicateWindow")
end

function ResDuplicateWindow:__delete()

end

function ResDuplicateWindow:GetCurOpenMaxIdx()
    local conditionMgr = Fight.Instance.conditionManager
    local selectIdx = 1
    for idx, id in ipairs(self.dupList) do
        if id ~= 0 then
            local dupCfg = ResDuplicateConfig.GetDuplicateInfo(id)
            if conditionMgr:CheckConditionByConfig(dupCfg.condition) then
                selectIdx = idx
            end
        end
    end

    return selectIdx
end

-- 初始化货币栏
function ResDuplicateWindow:InitCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.CurrencyBar, ResDuplicateConfig.FightCostResId)
end

-- 移除货币栏
function ResDuplicateWindow:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end

function ResDuplicateWindow:UpdateDupList()
    local dupList = ResDuplicateConfig.GetResourceDuplicateMainById(self.resDupId)
    self.dupList = dupList
    for key, id in ipairs(dupList) do
        if id ~= 0 then
            local obj = GameObject.Instantiate(self.DuplicateItem)
            obj.transform:SetParent(self.List.transform)
            obj:SetActive(true)
            UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)

            self:UpdateDupItemInfo(key, obj)
        end
    end
end

function ResDuplicateWindow:UpdateDupItemInfo(key, obj)
    local dupItem = DuplicateItem.New()
    dupItem:SetData(self, {obj = obj, index = key, dupId = self.dupList[key]})
    self.dupItemMap[key] = dupItem
end

function ResDuplicateWindow:ResetDupInfo()
    for k, data in pairs(self.awardItemMap) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", data.awardItem)
        GameObject.Destroy(data.obj)
	end
	self.awardItemMap = {}

    for _, data in pairs(self.monsterItemMap) do
        GameObject.Destroy(data.obj)
        data.item:DeleteMe()
    end
    self.monsterItemMap = {}
end

function ResDuplicateWindow:SelectDup(index)
    if self.selectIdx == index then return end

    self:ResetDupInfo()

    for key, item in ipairs(self.dupItemMap) do
        item:UpdateSelectState(key == index)
    end
    self.selectIdx = index
    self:UpdateSelectDupInfo()
end

function ResDuplicateWindow:UpdateSelectDupInfo()
    local selectDupId = self.dupList[self.selectIdx]
    if not selectDupId or selectDupId == 0 then return end
    local dupCfg = ResDuplicateConfig.GetDuplicateInfo(selectDupId)
    if not dupCfg then return end
    
    self.DuplicateName_txt.text = dupCfg.name
    local lvDesc = TI18N("难度："..self.selectIdx)
    self.Lv_txt.text = lvDesc
    self.dupCfg = dupCfg
    self:UpdateCostInfo(dupCfg)
    self:UpdateMonsterItem(dupCfg.show_monster_id)
    self:UpdateDropItem(dupCfg.show_reward)
end

function ResDuplicateWindow:UpdateMonsterItem(showList)
    for index, id in ipairs(showList) do
        if id ~= 0 then
            self:UpdateMonsterInfo(index, id)
        end
    end
end

function ResDuplicateWindow:UpdateMonsterInfo(index, showId)
    local monsterCfg = ResDuplicateConfig.GetShowMonsterInfo(showId)
    local obj = GameObject.Instantiate(self.MonsterItem)
    obj.transform:SetParent(self.MonsterList.transform)
    UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)
    local item = MonsterItem.New()
    local data = {obj = obj, index = index, cfg = monsterCfg}
    item:SetData(self, data)
    self.monsterItemMap[index] = {item = item, obj = obj}
end

function ResDuplicateWindow:UpdateDropItem(rewardId)
    local rewardList = ItemConfig.GetReward2(rewardId)
    for _, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward)
    end
end

function ResDuplicateWindow:UpdateRewardInfo(reward)
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

function ResDuplicateWindow:UpdateCostInfo(dupCfg)
    self.CostInfo:SetActive(false)
    local costVal = dupCfg.cost
    self.CostVal_txt.text = costVal
    self.costVal = costVal

    local curCostVal = mod.BagCtrl:GetItemCountById(ResDuplicateConfig.FightCostResId)
    local color = curCostVal >= costVal and colorVal[1] or colorVal[2]
    self.CostVal_txt.color = color
    
    local costId = ResDuplicateConfig.FightCostResId
    local itemIcon = ItemConfig.GetItemIcon(costId)
    SingleIconLoader.Load(self.CostIcon, itemIcon, function ()
        self.CostInfo:SetActive(true)
    end)
end

function ResDuplicateWindow:GoDuplicate()
    if not mod.ResDuplicateCtrl:CheckFightCost(self.costVal) then
        return
    end

    if not self.dupCfg then return end
    if Fight.Instance then
        Fight.Instance.duplicateManager:CreateDuplicate(self.dupCfg.id)
    end
end
