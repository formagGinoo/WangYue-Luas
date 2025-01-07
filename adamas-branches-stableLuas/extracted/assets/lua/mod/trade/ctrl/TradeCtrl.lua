TradeCtrl = BaseClass("TradeCtrl", Controller)

function TradeCtrl:__init()
    --[[
        库表
        self.storeMap = 
        {
            [] = {[] = true, [] = true}
        }
    ]]
    EventMgr.Instance:AddListener(EventName.StartNPCDialog, self:ToFunc("StartNpcDialog"))
    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("EndNpcDialog"))
    self.waitActiveStoreList = {}

end

function TradeCtrl:__delete()
    
end

function TradeCtrl:RecvStoreInfo(data)
    if not self.storeMap then
        -- 登录收到
        self.storeMap = {}
        for _, storeInfo in ipairs(data) do
            self.storeMap[storeInfo.id] = storeInfo
        end
        return
    end

    for _, storeInfo in ipairs(data) do
        if not self.storeMap[storeInfo.id] then
            -- 订单库激活
            self.storeMap[storeInfo.id] = storeInfo
            self:StoreActive(storeInfo.id)
            self:UpdateBargainNum(storeInfo.id, storeInfo)
        else
            -- 订单库更新
            self.storeMap[storeInfo.id] = storeInfo
            self:UpdateBargainNum(storeInfo.id, storeInfo)
        end
    end
end

function TradeCtrl:StartNpcDialog(npcId)
    local storeId = self:CheckActiveStore(npcId)
    if storeId then
        self.curTradeDialoging = storeId
    end
end

function TradeCtrl:EndNpcDialog(dialogId)
    if self.curTradeDialoging then
        if self.showCoolTimer then
            LuaTimerManager.Instance:RemoveTimer(self.showCoolTimer)
            self.showCoolTimer = nil
        end
        self.curTradeDialoging = nil
    end
end

function TradeCtrl:SetNpcDialog(original)
    if self.showCoolTimer then
        LogError("冷却时间计时器 错误调用顺序")
        LuaTimerManager.Instance:RemoveTimer(self.showCoolTimer)
    end

    self.defaultDialog = original

    local subLog;
    original, subLog = self:GetCoolInfo()

    self.showCoolTimer = LuaTimerManager.Instance:AddTimer(0, 1, self:ToFunc("CoolTimer"))

    return original, subLog
end

function TradeCtrl:GetCoolInfo()
    local store = self.storeMap[self.curTradeDialoging]
    local storeInfo = TradeConfig.GetStoreInfo(self.curTradeDialoging)

    if not storeInfo then
        LogError(string.format("库Id:%d, 取不到配置数据", self.curTradeDialoging))
        return
    end

    local original = self.defaultDialog
    local subLog = ""

    if store then
        original = original .. string.format("<color=#fed78c>(订单数%d/%d)</color>", #store.order_list, storeInfo.max_order_num)
        local curTime = TimeUtils.GetCurTimestamp()
        if store.next_refresh_ts >= curTime then
            subLog = self:GetTimeDesc(store.next_refresh_ts - curTime)
        end
    else
        original = original .. string.format("<color=#fed78c>(订单数%d/%d)</color>", storeInfo.max_order_num, storeInfo.max_order_num)
    end
    
    return original, subLog
end

function TradeCtrl:GetTimeDesc(seconds)
    seconds = math.floor(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds - (hours * 3600)) / 60)
    local seconds = seconds - (hours * 3600) - (minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function TradeCtrl:CoolTimer()
    local original, subLog = self:GetCoolInfo()    

    EventMgr.Instance:Fire(EventName.UpdateOptionContent, StoryConfig.StoryTrigger.OpenTrade, original, subLog)
end

function TradeCtrl:TransformCameraToNpc(npcId)
    local npcEntity = BehaviorFunctions.GetNpcEntity(npcId)
    local CameraTarget = npcEntity.clientTransformComponent.gameObject.transform:Find("CameraTarget")
    if not CameraTarget then
        CameraTarget = GameObject("CameraTarget")
        npcEntity.clientTransformComponent:SetTransformChild(CameraTarget.transform)
    end
    
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.NpcShop)
    local cameraParams = TradeConfig.GetNpcCameraParams(npcId)
    if cameraParams then
        BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.NpcShop]:SetCameraParam(cameraParams[1],
        cameraParams[2], cameraParams[3], cameraParams[4], cameraParams[5])
    end

    BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.NpcShop]:SetMainTarget(CameraTarget.transform)
end

function TradeCtrl:TransformCameraToOperating()
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
end

function TradeCtrl:CheckActiveStore(npcId)
    local storeId = TradeConfig.GetStoreIdByNpcId(npcId)
    if storeId then
        local store = self.storeMap[storeId]
        if not store then
            local id, cmd = mod.TradeFacade:SendMsg("trade_store_activate", storeId)
            self:WaitActiveStore(storeId)
        end
        return storeId
    end
    return nil
end

function TradeCtrl:EntryTradeByNpcId(npcId, npcInstanceId)
    local storeId = TradeConfig.GetStoreIdByNpcId(npcId)
    if storeId then
        self.npcInstanceId = npcInstanceId
        self.curNpcId = npcId
        self:EntryTradeByStoreId(storeId)
    end
end

function TradeCtrl:EntryTradeByStoreId(storeId)
    local store = self.storeMap[storeId]
    if not store then
        -- Wait
        self:SetStoreActiveCallback(storeId, function ()
            self:EntryTradeByStoreId(storeId)
        end)
        return
    end

    local orderListCount = #store.order_list
    if orderListCount == 0 then
        if TradeConfig.GetStoreCool(storeId) == 0 then
            MsgBoxManager.Instance:ShowTips(TI18N("订单耗尽"))
            return
        end

        local curTime = TimeUtils.GetCurTimestamp()
        if store.next_refresh_ts >= curTime then
            MsgBoxManager.Instance:ShowTips(TI18N("新订单尚未到达"))
            return
        end

        LogError(string.format("收购系统, 数据错误, 订单库Id:%d, 剩余订单为%d, 下一单到来时间:%d, 当前游戏时间:%d", storeId, #store.order_list, store.next_refresh_ts, curTime))
        return
    end

    self.curStoreId = storeId

    self:EntryTradeByOrderId(store.order_list[1])
end

function TradeCtrl:EntryTradeByOrderId(orderInstance)
    local orderId = orderInstance.id
    self.curOrderId = orderId

    self.curOrderInfo = TradeConfig.GetTradeOrder(self.curOrderId)
    self.curBasicsRewardNum = 0
    self.curExtraRewardNum = 0

    if not self.curOrderInfo then
        LogError(string.format("订单Id:%d 没有配置对应的表", self.curOrderId))
        return
    end

    if orderInstance.bargain_result ~= 0 then
        self.curBargainCoefficient = orderInstance.discount / 10000
        self.curIsBargain = orderInstance.bargain_result
    else
        self.curBargainCoefficient = 1
        self.curIsBargain = false
    end

    self:TransformCameraToNpc(self.curNpcId)

    WindowManager.Instance:OpenWindow(TradeMainWindow, {orderId = orderId, storeId = self.curStoreId, orderInstance = orderInstance})
end

function TradeCtrl:ExitTrade()
    self:TransformCameraToOperating()

    WindowManager.Instance:CloseWindow(TradeMainWindow)
    self.placingItemId = nil
    self.curOrderId = nil
    self.curStoreId = nil
    self.curNpcId = nil

    self.curOrderInfo = nil
    self.curExtraRewardNum = 0
    self.curBasicsRewardNum = 0
    self.curBargainCoefficient = 0
    self.curIsBargain = nil
    self.npcInstanceId = nil
end

function TradeCtrl:WaitActiveStore(storeId)
    if self.waitActiveStoreList[storeId] then
        return
    end
    self.waitActiveStoreList[storeId] = {cb = nil}
end

function TradeCtrl:SetStoreActiveCallback(storeId, cb)
    if self.waitActiveStoreList[storeId] then
        if not self.waitActiveStoreList[storeId].cb then
            self.waitActiveStoreList[storeId].cb = cb
        end
        return
    end
    mod.TradeFacade:SendMsg("trade_store_activate", storeId)
    self.waitActiveStoreList[storeId] = {cb = cb}
end

function TradeCtrl:StoreActive(storeId)
    if self.waitActiveStoreList[storeId] then
        if self.waitActiveStoreList[storeId].cb then
            self.waitActiveStoreList[storeId].cb()
        end
        self.waitActiveStoreList[storeId] = nil
    else
        LogError("没有注册订单库激活回调")
    end
end

function TradeCtrl:GetBagItemByPageId(pageId)
    local tb = mod.BagCtrl:GetBagByType(BagEnum.BagType.Item, pageId)
    local ans = {}
    if tb then
        for k, v in pairs(tb) do
            table.insert(ans, {template_id = v.template_id, count = v.count})
        end
    end
    return ans
end

function TradeCtrl:SetPlacingItem(itemId)
    if self.placingItemId == itemId then
        return
    end
    self.placingItemId = itemId

    if itemId then
        local orderInfo = self.curOrderInfo
    
        self.curExtraRewardNum = 0
        self.curBasicsRewardNum = 0
        for _, v in ipairs(orderInfo.expect_item) do
            if itemId == v[1] then
                if v[2] and v[2] ~= 0 then
                    self.curExtraRewardNum = v[2]
                end
                self.curBasicsRewardNum = orderInfo.reward_item_count
            end
        end

    else
        self.curBasicsRewardNum = 0
        self.curExtraRewardNum = 0
    end
    
    EventMgr.Instance:Fire(EventName.SetPlacingItem, self.placingItemId)
end

function TradeCtrl:GetCurPlacingItem()
    return self.placingItemId
end

function TradeCtrl:GetCurOrderId()
    return self.curOrderId
end

function TradeCtrl:GetCurRewardNum()
    return self.curBasicsRewardNum, self.curExtraRewardNum, (self.curBargainCoefficient - 1) * (self.curBasicsRewardNum + self.curExtraRewardNum)
end

function TradeCtrl:SellItem()
    if not self.curStoreId or not self.curOrderId or not self.placingItemId then
        return
    end

    local id, cmd = mod.TradeFacade:SendMsg("trade_order", self.curStoreId, self.curOrderId, self.placingItemId)
    CurtainManager.Instance:EnterWait()
    self.willSell = self.curStoreId
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        CurtainManager.Instance:ExitWait()

        local panel = PanelManager.Instance:GetPanel(TradeConfirmPanel)
        if panel then
            panel:OnClickCloseBtn()
        end

        local window = WindowManager.Instance:GetWindow("TradeMainWindow")
        if window then
            window:OnClickCloseBtn()
        end

        self.willSell = nil

        Story.Instance:RePlayLastNPCDialog()
    end)
end

function TradeCtrl:GetOrderId(storeId)
    local store = self.storeMap[storeId]
    if not store then
        return nil
    end

    return store.order_list[1].id
end

function TradeCtrl:GetCurNegotiateIdByStoreId(storeId)
    local orderId = self:GetOrderId(storeId)
    local orderInfo = TradeConfig.GetTradeOrder(orderId)
    return orderInfo.negotiate_id
end

function TradeCtrl:EntryBargain()
    mod.BargainCtrl:EnterBargainNpc(BargainEnum.Type.Trade, self.curStoreId, self.curNpcId, self.npcInstanceId)
end

function TradeCtrl:UpdateBargainNum(storeId, storeInstance)
    if self.curStoreId ~= storeId or storeId == self.willSell then
        return
    end
    
    if #storeInstance.order_list == 0 or storeInstance.order_list[1].id ~= self.curOrderId then
        LogError("回购订单消失")
        return
    end

    local orderInstance = storeInstance.order_list[1]

    if orderInstance.bargain_result ~= 0 then
        self.curBargainCoefficient = orderInstance.discount / 10000
        self.curIsBargain = orderInstance.bargain_result
    else
        self.curBargainCoefficient = 1
        self.curIsBargain = false
    end

    EventMgr.Instance:Fire(EventName.TradeWindowBargainUpdate)
end

function TradeCtrl:CheckIsBargain()
    return self.curIsBargain
end