DrawCtrl = BaseClass("DrawCtrl", Controller)

local _tinsert = table.insert
local _tsort = table.sort

function DrawCtrl:__init()
    self.curPools = TableUtils.NewTable()
    self.poolCount = {}
    self.poolHistroy = {}
    self.drawGroupGuarantee = {}
end

function DrawCtrl:__delete()
    
end

function DrawCtrl:OpenDrawWindow()
    self:UpdatePool()
    WindowManager.Instance:OpenWindow(DrawMainWindow, nil, nil, self:GetPreLoadWindowList())
    self:SetWaitReward(false)
end

function DrawCtrl:CloseDrawWindow()
    WindowManager.Instance:CloseWindow(DrawMainWindow)
    self:SetWaitReward(false)
end

function DrawCtrl:UpdatePool()
    TableUtils.ClearTable(self.curPools)
    local tempPools = TableUtils.NewTable()

    local pools = DrawConfig.GetAllPools()
    for _, pool in pairs(pools) do
        if self:CheckPoolIsOpen(pool) then
            local pageId = DrawConfig.GetPoolPageId(pool)
            local pl = tempPools[pageId]
            if not pl then
                tempPools[pageId] = {}
                pl = tempPools[pageId]
            end
            _tinsert(pl, pool)
        end
    end

    for tagId, tagPoolList in pairs(tempPools) do
        _tsort(tagPoolList, DrawConfig.PoolSortFunc)
        _tinsert(self.curPools, {tagId = tagId, tagPoolList = tagPoolList})
    end

    _tsort(self.curPools, DrawConfig.TagPoolSortFunc)

    EventMgr.Instance:Fire(EventName.UpdateDraw)
end

function DrawCtrl:CheckPoolIsOpen(pool)
    if pool.type == DrawEnum.DrawPoolType.Novice then
        local poolCountInfo = self.poolCount[pool.id]
        if not poolCountInfo then
            return true
        end
        return poolCountInfo.accumulateCount < pool.count
    end
    return true
end

function DrawCtrl:GetPreLoadWindowList()
    local preList = TableUtils.NewTable()
    for _, group in ipairs(self.curPools) do
        for _, pool in ipairs(group.tagPoolList) do
            _tinsert(preList, {path = DrawConfig.GetDrawPrefabPath(pool), type = AssetType.Prefab})
        end
    end
    return preList
end

function DrawCtrl:GetCurPoolList()
    return self.curPools
end

function DrawCtrl:SetWaitReward(flag)
    self.waitReward = flag
end

function DrawCtrl:CanDraw()
    return not self.waitReward
end

function DrawCtrl:RunDraw(poolId, btnEnum)
    if not self:CanDraw() then
        return
    end
    local result, needCount = self:CheckCanDraw(poolId, btnEnum)
    if not result then
        return
    end

    self:SetWaitReward(true)
    EventMgr.Instance:Fire(EventName.NoticeQueueActive, false)

    LogInfo("向服务器发送抽卡请求")
    mod.DrawFacade:SendMsg("draw", poolId, btnEnum)
end

function DrawCtrl:CheckCanDraw(poolId, btnEnum)
    local poolInfo = DrawConfig.GetPoolInfo(poolId)
    local drawItemId = poolInfo.cost_id
    local hasItem = mod.BagCtrl:GetItemCountById(drawItemId)

    local drawCount = nil

    if btnEnum == DrawEnum.DrawButton.Draw1 then
        drawCount = poolInfo.draw_cnt1
    elseif btnEnum == DrawEnum.DrawButton.Draw2 then
        drawCount = poolInfo.draw_cnt2
    end

    if not drawCount then
        LogError("抽卡检查失败")
        return false
    end

    local drawItemNeedNum = poolInfo.cost_num * drawCount
    if drawItemNeedNum > hasItem then
        return false, drawItemNeedNum - hasItem
    end

    -- 每日抽卡次数限制检测
    if poolInfo.daily_limit_count and poolInfo.daily_limit_count > 0 then
        local poolCountInfo = self:GetPoolDrawCount(poolId)
        if (poolCountInfo.dailyCount + drawCount) > poolInfo.daily_limit_count then
            MsgBoxManager.Instance:ShowTips(TI18N("该卡池已达本日次数上限"))
            return false
        end
    end

    return true, 0
end

function DrawCtrl:RecvDrawResult(poolId, itemList)
    LogInfo("收到服务器抽卡回包")
    local itemHasList = {}
    local tmpHistory = {}
    
    --服务器发来的列表 首部是最后获得的 要反转列表
    local i, j = 1, #itemList
    while i < j do
        itemList[i], itemList[j] = itemList[j], itemList[i]
        i = i + 1
        j = j - 1
    end

    for i, itemId in ipairs(itemList) do
        --计算这个卡对应的物品是第几次获得
        local num
        if tmpHistory[itemId] then
            num = tmpHistory[itemId] + 1
        else
            num = (mod.BagCtrl:GetItemObtainedCount(itemId) or 0) + 1
        end
        tmpHistory[itemId] = num

        --计算额外产物
        local extraInfo = DrawConfig.GetItemExtraInfo(itemId, num)

        _tinsert(itemHasList, {itemId = itemId, historyNum = num, extraInfo = extraInfo})
    end

    PanelManager.Instance:OpenPanel(DrawResultPanel, {historyNumList = itemHasList})
end

function DrawCtrl:RequestDrawHistory(groupId)
    local tb = self.drawGroupGuarantee[groupId]
    if tb then
        EventMgr.Instance:Fire(EventName.UpdateDrawHistory, groupId, tb.historyList)
    end
    mod.DrawFacade:SendMsg("draw_history", groupId)
end

function DrawCtrl:RecvDrawHistory(drawGroupId, historyList)
    self.poolHistroy[drawGroupId] = 
    {
        historyList = historyList,
    }
    --LogTable("抽卡历史记录", historyList)
    EventMgr.Instance:Fire(EventName.UpdateDrawHistory, drawGroupId, historyList)
end

function DrawCtrl:RecvDrawDrawCount(poolId, poolCount, poolDailyCount)
    local poolCountInfo = self.poolCount[poolId]
    if not poolCountInfo then
        self.poolCount[poolId] = { accumulateCount = poolCount, dailyCount = poolDailyCount }
    else
        poolCountInfo.accumulateCount = poolCount
        poolCountInfo.dailyCount = poolCount
    end
    self:UpdatePool()
end

function DrawCtrl:RecvDrawGuarantee(drawGroupId, currentCount, maxCount)
    self.drawGroupGuarantee[drawGroupId] = 
    {
        currentCount = currentCount,
        maxCount = maxCount,
    }
    EventMgr.Instance:Fire(EventName.UpdateDrawGuarantee, drawGroupId, currentCount, maxCount)
end

function DrawCtrl:GetDrawGuarantee(groupId)
    local info = self.drawGroupGuarantee[groupId]
    if not info then
        LogError(string.format("不存在卡池组 %d 的保底信息", groupId))
        return
    end

    return info.currentCount, info.maxCount
end

function DrawCtrl:DrawItemExchange(exchangeId, count, isShow)
    --mod.BagFacade:SendMsg("item_exchange", nil, nil, exchangeList)
    mod.BagCtrl:ExchangeItem({{key = exchangeId, value = count}}, isShow)
    LogInfo(string.format("兑换Id %d, 兑换数量 %d", exchangeId, count))
end

function DrawCtrl:GetPoolGroupGuarantee(groupId)
    local info = self.drawGroupGuarantee[groupId]
    if not info then
        LogError(string.format("卡池组 %d 没有找到保底次数", groupId))
        return
    end
    return info.currentCount, info.maxCount
end

function DrawCtrl:GetPoolDrawCount(poolId)
    local poolCountInfo = self.poolCount[poolId]
    if poolCountInfo then
        return poolCountInfo
    end
    return { accumulateCount = 0, dailyCount = 0 }
end