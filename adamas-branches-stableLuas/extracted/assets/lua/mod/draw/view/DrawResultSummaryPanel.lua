DrawResultSummaryPanel = BaseClass("DrawResultSummaryPanel", BasePanel)

local _tinsert = table.insert

function DrawResultSummaryPanel:__init()
    self:SetAsset("Prefabs/UI/Draw/DrawResultSummaryPanel.prefab")
    self.infoMap = {}
    self.commonItemList = {}
end

function DrawResultSummaryPanel:__delete()
    for i, v in ipairs(self.commonItemList) do
        PoolManager.Instance:Push(PoolType.class, "CommonItem", v)
    end
    self.commonItemList = nil
end

function DrawResultSummaryPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DrawResultSummaryPanel:__Create()
end

function DrawResultSummaryPanel:__BindListener()
    self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("OnClickCloseBtn"))
end

function DrawResultSummaryPanel:__BindEvent()
end

function DrawResultSummaryPanel:__Show()
    self.itemList = self.args.itemList
    self.newMap = self.args.newMap

    self.periodItemCountMap = {}
    for i, historyInfo in ipairs(self.itemList) do
        local itemId = historyInfo.itemId
        local itemInfo = DrawConfig.GetItemInfo(itemId)
        if itemInfo.type == DrawEnum.DrawItemType.Hero and historyInfo.historyNum > 1 and historyInfo.historyNum <= 7 then
            -- 挂脉分析
            local periodItemId = RoleConfig.GetRolePeriodInfo(itemInfo.id, historyInfo.historyNum - 1).item
            local periodItemInfo = DrawConfig.GetItemInfo(periodItemId)
            if not self.periodItemCountMap[historyInfo.itemId] then
                self.periodItemCountMap[historyInfo.itemId] = { periodItemInfo = periodItemInfo, count = 1 }
            else
                self.periodItemCountMap[historyInfo.itemId].count = self.periodItemCountMap[historyInfo.itemId].count + 1
            end
        end    
        if not self.infoMap[itemId] then
            self.infoMap[itemId] = DrawConfig.GetItemInfo(itemId)
        end

        if self.newMap[itemId] then
            historyInfo.isNew = true
            self.newMap[itemId] = nil
        else
            historyInfo.isNew = false
        end
    end

    table.sort(self.itemList, function (a, b)
        return self.infoMap[a.itemId].quality > self.infoMap[b.itemId].quality
    end)

    for i, historyInfo in pairs(self.itemList) do
        local id = historyInfo.itemId
        local cardItem = self["CardItem" .. tostring(i)]
        local cardItemContainer = UtilsUI.GetContainerObject(cardItem)
        local info = self.infoMap[id]
        local isNew = historyInfo.isNew
        SingleIconLoader.Load(cardItemContainer.Portrait, info.stand_icon, function ()
            if info.quality == 3 then
                UtilsUI.SetActive(cardItemContainer.Blue, true)
                UtilsUI.SetActive(cardItemContainer.BlueBottom, true)
            elseif info.quality == 4 then
                UtilsUI.SetActive(cardItemContainer.Purple, true)
                UtilsUI.SetActive(cardItemContainer.PurpleBottom, true)
            elseif info.quality == 5 then
                UtilsUI.SetActive(cardItemContainer.Golden, true)
                UtilsUI.SetActive(cardItemContainer.GoldBottom, true)
            end
            local standInfo = info.standInfo
            if standInfo then
                UnityUtils.SetAnchoredPosition(cardItemContainer.Portrait_rect, standInfo.stand_position[1], standInfo.stand_position[2])
                UnityUtils.SetSizeDelata(cardItemContainer.Portrait_rect, standInfo.stand_size[1], standInfo.stand_size[2])
            end
            if isNew then
                UtilsUI.SetActive(cardItemContainer.NewIcon, true)
            end
            UtilsUI.SetActive(cardItemContainer.Bottom, true)
            UtilsUI.SetActive(cardItem, true)
        end)

        if not isNew then
            if self.periodItemCountMap[id] and self.periodItemCountMap[id].count > 0 then
                UtilsUI.SetActive(cardItemContainer.TransformIten, true)
                local commonItem = self:LoadCommonItem(self.periodItemCountMap[id].periodItemInfo.id, cardItemContainer.TransformIten)
                _tinsert(self.commonItemList, commonItem)
                self.periodItemCountMap[id].count = self.periodItemCountMap[id].count - 1
            end
        end
    end
end

function DrawResultSummaryPanel:__Hide()
end

function DrawResultSummaryPanel:__ShowComplete()
    UtilsUI.SetActive(self.CardItemList, true)

    LuaTimerManager.Instance:AddTimer(1, 1, function ()
        self.canClose = true
    end)
end

function DrawResultSummaryPanel:OnClickCloseBtn()
    if self.canClose then
        -- 弹出星辉奖励弹窗
        local rewardList = self:GetRewardList()
        if #rewardList > 0 then
            EventMgr.Instance:Fire(EventName.AddSystemContent, GetItemPanel, {args = {reward_list = rewardList}})
        end
        PanelManager.Instance:ClosePanel(self)
    end
end

function DrawResultSummaryPanel:GetRewardList()
    local resTmp = {}
    for i, v in ipairs(self.itemList) do
        local extraInfo = v.extraInfo
        if extraInfo then
            if not resTmp[extraInfo.extra_id] then
                resTmp[extraInfo.extra_id] = extraInfo.extra_num
            else
                resTmp[extraInfo.extra_id] = resTmp[extraInfo.extra_id] + extraInfo.extra_num
            end
        end
        --_tinsert(res, {template_id = v.extraInfo, count = })
    end

    local res = {}
    for templateId, Count in pairs(resTmp) do
        _tinsert(res, {template_id = templateId, count = Count})
    end

    return res
end

function DrawResultSummaryPanel:LoadCommonItem(itemId, go)
    local itemInfo = {template_id = itemId, count = 1, scale = 0.7}
    local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
    commonItem:InitItem(go, itemInfo, true)
    return commonItem
end
