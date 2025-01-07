RoguelikeCtrl = BaseClass("RoguelikeCtrl",Controller)

local _tinsert = table.insert

function RoguelikeCtrl:__init()
    self.windowManager = WindowManager.Instance
    self.eventList = {}

    -- 世界轮数
    self.gameRoundId = 0
    -- 区域版本id，对应rogue_area_version
    self.areaVersionId = 0
    -- 本赛季所有已发现或者完成的事件列表
    self.season_event_list = {}
    -- 区域的事件列表
    self.areaLogicMaps = {}
    --赛季版本id
    self.season_version_id = 0
    --目前的卡牌库
    self.card_bag = {} --key->CardId  value = Count
    --装备中的卡牌
    self.card_equip = {}
    --本轮卡牌
    self.current_round_card_bag = {}
    --新获得的卡牌
    self.newCards = {}--客户端本地红点用
    --赛季进度值
    self.season_schedule = 0
    -- 赛季衍化等级奖励领取记录
    self.seasonScheduleRewardMap = {}
    
    --当前完成的事件
    self.currentEvent = nil
    
    --可刷新次数
    self.game_refresh_times = 0
    --上一次刷新时间
    self.game_last_refresh_ts = 0

    -- 本次进度的得到的卡牌数据
    self.areaCardList = nil
    -- 本次进度的得到的区域id
    self.currentAreaLogic = nil

    -- 所有事件列表，方便处理
    self.allEventList = {}
    -- 所有已发现的事件列表，方便处理
    self.allDiscoverEventList = {}

    -- 本次主控id,
    self.mainId = 1
end

function RoguelikeCtrl:__InitCtrl()
end

function RoguelikeCtrl:ClearRoguelikeData()
    self.seasonScheduleRewardMap = {}
    self.allDiscoverEventList = {}
    self.season_event_list = {}
    self.areaLogicMaps = {}
    self.allEventList = {}
end

-- 同步后端数据
function RoguelikeCtrl:AsyncRoguelikeData(data)
    self:ClearRoguelikeData() --清空下
    
    self.gameRoundId = data.game_round and data.game_round or self.gameRoundId
    self.areaVersionId = data.area_version_id and data.area_version_id or self.areaVersionId
    self.season_version_id = data.season_version_id
    self.season_schedule = data.season_schedule
    self.game_refresh_times = data.game_refresh_times
    self.game_last_refresh_ts = data.game_last_refresh_ts

    for _, lv in ipairs(data.season_schedule_reward_list) do
        self.seasonScheduleRewardMap[lv] = true --lv级的已经领取
    end

    for _, discoverEventId in pairs(data.game_discovered_event_list) do
        self.allDiscoverEventList[discoverEventId] = true
    end

    for _, seasonEvent in pairs(data.season_event_list) do
        self.season_event_list[seasonEvent.event_id] = self.season_event_list[seasonEvent.event_id] or {}
        self.season_event_list[seasonEvent.event_id].event_id = seasonEvent.event_id
        self.season_event_list[seasonEvent.event_id].is_discovered = seasonEvent.is_discovered
        self.season_event_list[seasonEvent.event_id].finish_ts = seasonEvent.finish_ts
    end

    for areaId, info in pairs(data.rogue_area_logic_maps) do
        self.areaLogicMaps[areaId] = self.areaLogicMaps[areaId] or {}

        local data = self.areaLogicMaps[areaId]
        data.area_logic_id = info.area_logic_id
        data.current_event_maps = data.current_event_maps or {}

        for eventId, isOk in pairs(info.current_event_maps) do
            data.current_event_maps[eventId] = isOk
            self.allEventList[eventId] = {areaId = data.area_logic_id, isComplete = isOk}
        end
    end
    --如果manager初始化完成才去重置
    if Fight.Instance and Fight.Instance.rouguelikeManager then
        Fight.Instance.rouguelikeManager:ResetRogueLikeManager()
    end
    --刷新Rogue红点
    EventMgr.Instance:Fire(EventName.CheckRogueRed)
end

-- 获取所有已完成事件数量
function RoguelikeCtrl:GetFinishedEventNum()
    local num = 0
    for _, data in pairs(self.allEventList) do
        if data.isComplete then
            num = num + 1
        end
    end
    
    return num
end

--同步卡牌数据
function RoguelikeCtrl:AsyncRoguelikeCartData(data)
    self.card_bag = data.card_bag
    self.card_equip = data.card_equip
    self.current_round_card_bag = data.current_round_card_bag
end

--同步事件完成数据
function RoguelikeCtrl:AsyncRoguelikeEventFinishData(data)
    self.season_schedule = data.season_schedule
    self:SetEventFinishedList(data.area_logic_id, data.event_id, data.ts)

    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(data.event_id)
    if not eventCfg then
        LogError("缺少事件配置"..data.event_id)
        return
    end
    BehaviorFunctions.RemoveLevel(eventCfg.duplicate_level)
    --移除地图事件图标
    mod.WorldMapCtrl:RemoveEventMark(data.event_id)
    EventMgr.Instance:Fire(EventName.AddSystemContent, RogueTipsPanel, { args = {areaId = data.area_logic_id, eventId = data.event_id, isShowProgress = true}, delayTime = 0.5 })
    --刷新Rogue红点
    EventMgr.Instance:Fire(EventName.CheckRogueRed)
end

--同步时间刷新数据
function RoguelikeCtrl:AsyncRoguelikeInfoRefresh(data)
    self.game_refresh_times = data.game_refresh_times
    self.game_last_refresh_ts = data.game_last_refresh_ts
    --刷新城市衍化界面
    EventMgr.Instance:Fire(EventName.RefreshEvolutionPanel)
    --刷新红点
    EventMgr.Instance:Fire(EventName.CheckRogueRed)
end

function RoguelikeCtrl:SetNewCardRed(cardId)
    self.newCards[cardId] = true
end

function RoguelikeCtrl:GetNewCardRed(cardId)
    return self.newCards[cardId]
end

function RoguelikeCtrl:ClearNewCardRedById(cardId)
    self.newCards[cardId] = nil
end

function RoguelikeCtrl:ClearNewCardRed()
    self.newCards = {}
end

function RoguelikeCtrl:SetDiscoverEvent(eventId)
    self.allDiscoverEventList[eventId] = true
    --赛季事件列表更新
    self:SetSeasonEventDiscovered(eventId)
end

function RoguelikeCtrl:GetMainId()
    return self.mainId
end

--更改装备卡牌库
function RoguelikeCtrl:SetEquipmentCard(data)
    self.card_equip = data
    -- 刷新当前的magic数据
    BehaviorFunctions.fight.rouguelikeManager:AddAllCardMagic()
end

function RoguelikeCtrl:GetSeasonVersionId()
    return self.season_version_id
end

function RoguelikeCtrl:SetCurrentEvent(eventId)
    local season_event = self.season_event_list[eventId]
    local time = 0
    if season_event then
        time = self.season_event_list[eventId].finish_ts
    end
    
    self.currentEvent = {
        eventId = eventId,
        finish_ts = time
    }
end

function RoguelikeCtrl:GetCurrentEvent()
    return self.currentEvent
end

--卡牌库
function RoguelikeCtrl:GetCardBag()
    return self.card_bag
end

--已经装备的卡牌
function RoguelikeCtrl:GetCardEquip()
    return self.card_equip
end

--设置本轮卡牌
function RoguelikeCtrl:SetCurrentRoundCardBagById(cardId)
    if self.current_round_card_bag[cardId] then
        self.current_round_card_bag[cardId] = self.current_round_card_bag[cardId] + 1
    else
        self.current_round_card_bag[cardId] = 1
    end
end

--本轮卡牌
function RoguelikeCtrl:GetCurrentRoundCardBag()
    return self.current_round_card_bag
end

function RoguelikeCtrl:SetCardBagById(cardId)
    if self.card_bag[cardId] then
        self.card_bag[cardId] = self.card_bag[cardId] + 1
    else
        self.card_bag[cardId] = 1
    end
end

function RoguelikeCtrl:SetEventFinishedList(areaId, eventId, time)
    self.allEventList[eventId] = {areaId = areaId, isComplete = true}
    local data = self.areaLogicMaps[areaId]
    data.area_logic_id = areaId
    data.current_event_maps = data.current_event_maps or {}
    data.current_event_maps[eventId] = true
    --如果第一次完成时间不存在才去赋值
    self:SetSeasonEventFinished(eventId, time)
end

function RoguelikeCtrl:SetSeasonEventFinished(eventId, time)
    self:CheckSeasonEvent(eventId)
    if self.season_event_list[eventId].finish_ts == 0 then
        self.season_event_list[eventId].finish_ts = time
    end
end

function RoguelikeCtrl:SetSeasonEventDiscovered(eventId)
    self:CheckSeasonEvent(eventId)
    self.season_event_list[eventId].is_discovered = true
end

function RoguelikeCtrl:CheckSeasonEvent(eventId)
    if not self.season_event_list[eventId] then
        self.season_event_list[eventId] = {}
        self.season_event_list[eventId].event_id = eventId
        self.season_event_list[eventId].is_discovered = false
        self.season_event_list[eventId].finish_ts = 0
    end
end

function RoguelikeCtrl:GetCardBagById(cardId)
    return self.card_bag[cardId]
end

function RoguelikeCtrl:GetCardEquipById(cardEquipId)
    return self.card_equip[cardEquipId]
end

function RoguelikeCtrl:GetAllEventList()
   return self.allEventList
end

function RoguelikeCtrl:GetDiscoverEventList()
    return self.allDiscoverEventList
end

function RoguelikeCtrl:GetGameRoundId()
    return self.gameRoundId
end

function RoguelikeCtrl:GetAreaVersionId()
    return self.areaVersionId
end

function RoguelikeCtrl:GetGameRefreshTimes()
    return self.game_refresh_times
end

function RoguelikeCtrl:GetGameLastRefreshTs()
    return self.game_last_refresh_ts
end

function RoguelikeCtrl:GetSeasonEventMaps()
    return self.season_event_list
end

function RoguelikeCtrl:GetSeasonEventCompleteTime(eventId)
    return self.season_event_list[eventId]
end

function RoguelikeCtrl:GetAreaEventList(areaId)
    local allData = self.areaLogicMaps[areaId]
    if not allData then return end

    local allEventList = allData.current_event_maps
    return allEventList
end

function RoguelikeCtrl:GetAreaLogicMaps()
    return self.areaLogicMaps
end

function RoguelikeCtrl:GetAreaEventById(areaId, eventId)
    local eventList = self:GetAreaEventList(areaId)
    if not eventList then return end
    return eventList[eventId]
end

function RoguelikeCtrl:CheckAreaEventCompleteState(areaId, eventId)
    local eventData = self:GetAreaEventById(areaId, eventId)
    return eventData
end

function RoguelikeCtrl:CheckGetSeasonScheduleReward(rewardLv)
    return self.seasonScheduleRewardMap[rewardLv]
end

function RoguelikeCtrl:SetSeasonScheduleReward(rewardLvTb)
    for i, lv in ipairs(rewardLvTb) do
        self.seasonScheduleRewardMap[lv] = true
    end
end

function RoguelikeCtrl:CheckIsSeasonScheduleRewardCanGet(rewardLv)
    return rewardLv <= self.season_schedule
end

function RoguelikeCtrl:AsyncRoguelikeCardData(data)
    self.areaCardList = data.card_list
    self.currentAreaLogic = data.area_logic
	
    --弹出卡牌选择界面
    EventMgr.Instance:Fire(EventName.AddSystemContent, RogueSelectRewardWindow, { args = { cardList = self.areaCardList, areaLogicId = self.currentAreaLogic }, isWindow = true})
end

function RoguelikeCtrl:GetAreaCardData()
    return self.areaCardList
end

function RoguelikeCtrl:ClearAreaCardData()
    self.areaCardList = nil
end

function RoguelikeCtrl:SelectLvMagic()
end

function RoguelikeCtrl:GetMagicList()
end

function RoguelikeCtrl:GetSeasonSchedule()
    return self.season_schedule
end

function RoguelikeCtrl:CheckRogueChoiceList()
    --游戏初始化时直接弹
    if self.areaCardList then
        --弹出卡牌选择界面
        EventMgr.Instance:Fire(EventName.AddSystemContent, RogueSelectRewardWindow, { args = { cardList = self.areaCardList, areaLogicId = self.currentAreaLogic }, isWindow = true})
    end
end

function RoguelikeCtrl:GetAreaDoneEventNum(logicAreaId)
    --获取目前的进度
    local areaAllEvent = self:GetAreaEventList(logicAreaId)
    local index = 0 --该区域已经完成的事件数
    for _, state in pairs(areaAllEvent) do
        if state then
            index = index + 1
        end
    end
    return index
end

--获取该区域的进度值(通过完成事件的数量判断)
function RoguelikeCtrl:GetAreaEventProgress(logicAreaId)
    local index = self:GetAreaDoneEventNum(logicAreaId)
    local logicConfig = RoguelikeConfig.GetWorldRougeAreaLogic(logicAreaId)
    
    return index/logicConfig.over_num
end

--获取该卡牌在当前赛季最大的值
function RoguelikeCtrl:GetRogueCardVersionMaxNum(cardId)
    local seasonConfig = RoguelikeConfig.GetSeasonData(self.season_version_id)
    local cardVersionConfig = RoguelikeConfig.GetRogueCardVersion(seasonConfig.card_version, cardId)
    
    return cardVersionConfig.card_num_max
end

----红点检测

--肉鸽气脉赐福红点
function RoguelikeCtrl:CheckRogueBlessRedPoint()
    return TableUtils.GetTabelLen(self.newCards) > 0
end

--肉鸽奖励红点
function RoguelikeCtrl:CheckRogueRewardRedPoint()
    --检测衍化奖励是否有可领取的红点

    --当前的衍化等级和奖励列表领取的等级对比（是否领取列表里的所有等级小于当前衍化等级）
    --self.season_schedule = 2  1, 2,3 ,4 5
    if self.season_schedule == 0 then
        return false
    end
    
    return not self.seasonScheduleRewardMap[self.season_schedule]
end

--肉鸽衍化红点
function RoguelikeCtrl:CheckRogueEvolutionRedPoint()
    --检测是否有可重启的红点(获取当前所有区域的logicMap，每一个区域都是100%，且满足重启条件，即显示红点)
    local isRed = false
    local gameReplayConfig = RoguelikeConfig.GetRogueGameReplay(self.gameRoundId)
    if gameReplayConfig then
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(gameReplayConfig.condition)
        isRed = isPass
    else
        isRed = self.game_refresh_times > 0
    end
    
    if not isRed then --这里如果是false直接return
        return false
    end
    
    local nowSchedule = 0
    for areaId, v in pairs(self.areaLogicMaps) do
        local progress = self:GetAreaEventProgress(areaId)
        if progress >= 1 then
            nowSchedule = nowSchedule + 1
        else
            return false
        end
    end
    
    return true
end

-------------------------------------协议交互部分
function RoguelikeCtrl:GetRoguelikeLvReward()
    -- 获取肉鸽等级奖励 (从目前的衍化等级开始，往下遍历)
    local scheduleRewardLv = self:GetSeasonSchedule()
    local rewardLvTb = {}
    for i = 1, scheduleRewardLv do
        if not self:CheckGetSeasonScheduleReward(i) then
            _tinsert(rewardLvTb, i)
        end
    end

    if not next(rewardLvTb) then
        return
    end

    local orderId, protoId = mod.RoguelikeFacade:SendMsg("rogue_season_schedule_reward", rewardLvTb)
    SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
        if ERRORCODE == 0 then
            self:SetSeasonScheduleReward(rewardLvTb)
            --更新赛季奖励列表
            EventMgr.Instance:Fire(EventName.GetSeasonReward)
            --刷新Rogue红点
            EventMgr.Instance:Fire(EventName.CheckRogueRed)
        end
    end)
end

function RoguelikeCtrl:ChoseCardList(cardId)
    local orderId, protoId = mod.RoguelikeFacade:SendMsg("rogue_card_choose", cardId)
    SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
        if ERRORCODE == 0 then
            --更新卡牌库
            self:SetCardBagById(cardId)
            --更新本轮卡牌
            self:SetCurrentRoundCardBagById(cardId)
            --清楚本轮选择的卡牌数据
            self:ClearAreaCardData()
            --卡牌标记为新卡牌
            self:SetNewCardRed(cardId)
            --自动装载卡牌
            self:IsAutoEquipCardList(cardId)
            --刷新红点
            EventMgr.Instance:Fire(EventName.CheckRogueRed)
        end
    end)
end

--自动装载卡牌
function RoguelikeCtrl:IsAutoEquipCardList(cardId)
    local seasonVersionId = self:GetSeasonVersionId()
    local seasonCfg = RoguelikeConfig.GetSeasonData(seasonVersionId)

    local equipCardList = TableUtils.CopyTable(self.card_equip)
    local nowNum = TableUtils.GetTabelLen(equipCardList)
    local maxNum = seasonCfg.card_buff_max
    
    --如果小于最大数量自动装备 或已经装备该卡牌了也自动加1
    if (nowNum < maxNum) or equipCardList[cardId] then
        equipCardList = self:AutoEquipCardList(equipCardList, cardId)
        self:EquipCardList(equipCardList)
    end
end

--自动装备卡牌
function RoguelikeCtrl:AutoEquipCardList(equipCardList, selectCardId)
    local cardList = equipCardList or {}
    if not cardList[selectCardId] then
        --从卡牌库里面获取数量(装载肯定是装一组的)
        cardList[selectCardId] = self:GetCardBagById(selectCardId)
    else
        cardList[selectCardId] = cardList[selectCardId] + 1
    end

    return cardList
end

--装备卡牌 data-> CardId = Count
function RoguelikeCtrl:EquipCardList(data)
    local orderId, protoId = mod.RoguelikeFacade:SendMsg("rogue_card_equip", data)
    SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
        if ERRORCODE == 0 then
            --更新装备的卡牌库
            self:SetEquipmentCard(data)
            EventMgr.Instance:Fire(EventName.EquipCardUpdate)
        end
    end)
end

--重启
function RoguelikeCtrl:RoguelikeRestart(removeCardList)
    local list = {}
    for _, id in pairs(removeCardList) do
        _tinsert(list, id)
    end
    local maxNum = self:GetDiscardBlessedUp()
    if #list < maxNum then return end
    mod.RoguelikeFacade:SendMsg("rogue_restart", list)
end


function RoguelikeCtrl:GetDiscardBlessedUp()
    local id = self:GetSeasonVersionId()
    local restartNum = self:GetGameRoundId()
    local seasonCfg = RoguelikeConfig.GetSeasonData(id)
    local maxNum = RoguelikeConfig.GetCardLoseNumByRestartNum(seasonCfg.card_reserve_rule, restartNum)
    return maxNum
end