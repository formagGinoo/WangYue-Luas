MercenaryHuntCtrl = BaseClass("MercenaryHuntCtrl",Controller)

local _tinsert = table.insert
local ChaseState = MercenaryHuntConfig.MercenaryChaseState
local DiscoverState = MercenaryHuntConfig.MercenaryDiscoverState

function MercenaryHuntCtrl:__init()
    self.windowManager = WindowManager.Instance

    self.mainId = 0
    -- self.getRewardTime = 0
    self.alertValue = 0
    -- self.rankExpVal = 0
    -- self.rankLev = 0
    self.getRankRewardMap = {}

    self.curRankId = 0
    self.curRankLv = 0

    -- 加这个是为了防止多次创建相同的怪
    self.createMap = {}
    -- 佣兵列表
    self.mercenaryMap = {}
    -- 佣兵标记列表
    self.mercenatyMarkMap = {}

    self.sortMercenaryMap = {}

    EventMgr.Instance:AddListener(EventName.MercenaryMarkAdded, self:ToFunc("OnMapMarkInited"))
end

function MercenaryHuntCtrl:InitMercenaryHuntMainInfo(data)
    -- self.getRewardTime = data.reward_time
    if self.mainId ~= data.main_id then
        self.mainId = data.main_id
        EventMgr.Instance:Fire(EventName.UpdateMainId)
    end
end

function MercenaryHuntCtrl:GetMainId()
   return self.mainId
end

-- TODO 删除
function MercenaryHuntCtrl:GetRewardTime()
    return 0
end

function MercenaryHuntCtrl:UpdateMercenaryList(newData)
    --  跨天的时候清除所有的佣兵
    -- if newData.is_refresh then
        -- self:ClearMercenaryEntity()
    -- end
    local lastChaseMap = {}
    for ecoId, info in pairs(self.mercenaryMap) do
        lastChaseMap[ecoId] = info.chase_state
    end

    local changMap = {}
    -- 初始化佣兵列表
    for _, data in pairs(newData.mercenary_list) do
        local ecoId = data.ecosystem_id
        self.mercenaryMap[ecoId] = data

        if not lastChaseMap[ecoId] or lastChaseMap[ecoId] ~= data.chase_state then
            changMap[ecoId] = data.chase_state
        end

        if data.chase_state ~= ChaseState.Chase and Fight.Instance then
            Fight.Instance.mercenaryHuntManager:ClearDiscoverState(ecoId)
        end
    end

    local removeKey = {}
    -- 因为可能是增量的，所以在下发同一个段位的数据移除掉其他相同段位的数据
    for id, _ in pairs(changMap) do
        local data = self.mercenaryMap[id]
        local rankId = data.rank_id
        local rankLv = data.rank_lv
        for _, mercenary in pairs(self.mercenaryMap) do
            if mercenary.rank_id == rankId and mercenary.rank_lv == rankLv and mercenary.ecosystem_id ~= id then
                removeKey[mercenary.ecosystem_id] = true
            end
        end
    end

    for _, id in pairs(removeKey) do
        self.mercenaryMap[id] = nil
    end

    self:SortMercenaryMap()

    -- 创建佣兵
    if Fight.Instance then
        Fight.Instance.entityManager.ecosystemEntityManager:CreateMercenaryEntity()
        self:UpdateMercenaryChaseEntity(changMap)
    end
end

-- 检查时间戳
function MercenaryHuntCtrl:CheckCreateMercenaryTime()
    
end

function MercenaryHuntCtrl:CheckHasMercenaryChase()
    local mercenaryMgr = Fight.Instance.mercenaryHuntManager
    for ecoId, info in pairs(self.mercenaryMap) do
        local ctrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
        if ctrl and info.chase_state == 1 then
            return true
        end
    end
    return false
end

function MercenaryHuntCtrl:UpdateMercenaryChaseEntity(fixedMap)
    if not Fight.Instance then return end
    local mercenaryMgr = Fight.Instance.mercenaryHuntManager

    if fixedMap and next(fixedMap) then
        for ecoId, state in pairs(fixedMap) do
            local ctrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
            if ctrl then
                ctrl:UpdateMercenaryChaseState(state == ChaseState.Chase)
            end
            mod.WorldMapCtrl:AddMercenaryMark(ecoId)
        end
        EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid)
        return
    end

    for ecoId, data in pairs(self.mercenaryMap) do
        local ctrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
        if ctrl then
            ctrl:UpdateMercenaryChaseState(data.chase_state == ChaseState.Chase)
        end
        mod.WorldMapCtrl:AddMercenaryMark(ecoId)
    end
end

function MercenaryHuntCtrl:ClearMercenaryEntity()
    for ecoId, _ in pairs(self.mercenaryMap) do
        local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
        if instanceId then
            BehaviorFunctions.RemoveEntity(instanceId)
        end
    end
    self.mercenaryMap = {}
    self.createMap = {}
end

function MercenaryHuntCtrl:GetAllMercenaryData()
    return self.mercenaryMap
end

function MercenaryHuntCtrl:GetCurCreateMercenaryMap()
    local mercenaryMgr = Fight.Instance.mercenaryHuntManager
    local map = {}
    for ecoId, data in pairs(self.mercenaryMap) do
        local ctrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
        if ctrl then
            map[ecoId] = data
        end
    end
    return map
end

function MercenaryHuntCtrl:GetMercenaryData(ecoId)
    return self.mercenaryMap[ecoId]
end

function MercenaryHuntCtrl:KillMercenary(ecoId)
    local data = self.mercenaryMap[ecoId]
    data.chase_state = 0

    self.createMap[ecoId] = nil

    mod.WorldMapCtrl:RemoveMapMark(self.mercenatyMarkMap[ecoId])
    self.mercenatyMarkMap[ecoId] = nil
end

function MercenaryHuntCtrl:AddCreateRecord(ecoId)
    self.createMap[ecoId] = true
    Fight.Instance.mercenaryHuntManager:AddMercenaryCtrl(ecoId)

    self:AddMercenaryMark(ecoId)
end

function MercenaryHuntCtrl:AddMercenaryMark(ecoId)
    if not self.mercenatyMarkMap[ecoId] then
        mod.WorldMapCtrl:AddMercenaryMark(ecoId)
    end
end

function MercenaryHuntCtrl:SortMercenaryMap()
    local newMap = {}
    for _, data in pairs(self.mercenaryMap) do
        _tinsert(newMap, data)
    end

    table.sort(newMap, function (a, b)
        if a.rank_id == b.rank_id then
            return a.rank_lv < b.rank_lv
        end
        return a.rank_id < b.rank_id
    end)

    self.sortMercenaryMap = newMap
end

function MercenaryHuntCtrl:CheckCreateMercenary(ecoId)
    local isCreate = self.createMap[ecoId]
    local mercenaryData = self.mercenaryMap[ecoId]
    if mercenaryData.chase_state ~= ChaseState.Chase and mercenaryData.discover_state ~= DiscoverState.Discover then
        return false
    end

    local curRankId, curRankLv = self:GetCurRankInfo()
    local rankCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig()
    local maxRankLv = #rankCfg
    if curRankId >= maxRankLv and not isCreate then
        return true
    end

    local selcetIdx
    local sortMap = self.sortMercenaryMap
    for idx, data in ipairs(sortMap) do
        if data.rank_id == curRankId and data.rank_lv == curRankLv then
            selcetIdx = idx
            break
        end
    end

    local selectData = sortMap[selcetIdx + 1] and sortMap[selcetIdx + 1] or sortMap[selcetIdx]
    if selectData.ecosystem_id == ecoId and not isCreate then
        return true
    end

    return false
end

function MercenaryHuntCtrl:CheckAddMapMark(ecoId)
    -- 发现
    if self:CheckMercenaryIsDiscover(ecoId) then
        return true
    end
    
    local mercenaryMgr = Fight.Instance.mercenaryHuntManager
    if mercenaryMgr:IsMercenaryChase(ecoId) then
        return true
    end

    return false
end

function MercenaryHuntCtrl:CheckMercenaryIsDiscover(ecoId)
    return self.createMap[ecoId] and self.mercenaryMap[ecoId].discover_state ~= 0
end

function MercenaryHuntCtrl:ClearMercenaryCreateMap()
    self.createMap = {}
end

function MercenaryHuntCtrl:UpdateAlertVal(newVal)
	if Fight.Instance then
        if newVal > self.alertValue then
            Fight.Instance.mercenaryHuntManager:ResetAlertTime(true)
        end
    end
    
    if newVal < self.alertValue then
        self:UpdateMercenaryChaseEntity()
    end
	
    self.alertValue = newVal
    EventMgr.Instance:Fire(EventName.AlertValueUpdate)
end

function MercenaryHuntCtrl:OnMapMarkInited(markInstanceId, ecoId)
    if self:CheckCreateMercenary(ecoId) then
        -- 是不是错误的佣兵数据
        return
    end

    self.mercenatyMarkMap[ecoId] = markInstanceId
end

function MercenaryHuntCtrl:GetMercenaryMapMark(ecoId)
    return self.mercenatyMarkMap[ecoId]
end

function MercenaryHuntCtrl:GetAlertVal()
    return self.alertValue
end

function MercenaryHuntCtrl:UpdateMercenaryRankVal(rankData)
    self.curRankId = rankData.rank_id
    self.curRankLv = rankData.rank_lv
    -- EventMgr.Instance:Fire(EventName.UpdateMercenaryRankVal, self.rankLev, self.rankExpVal)
end

function MercenaryHuntCtrl:GetCurRankInfo()
    return self.curRankId, self.curRankLv
end

function MercenaryHuntCtrl:UpdateGetMercenaryRankRewardMap(stateList)
    local newState = {}
    for _, val in pairs(stateList) do
        if not newState[val] then
            newState[val] = true
        end
        self.getRankRewardMap[val] = true
    end
    EventMgr.Instance:Fire(EventName.GetRankReward, newState)
end

function MercenaryHuntCtrl:GetRankRewardMap()
    return self.getRankRewardMap
end

function MercenaryHuntCtrl:ISGetRankReward(rankId)
    if self.curRankId >= rankId and not self.getRankRewardMap[rankId] then 
        return true
    end
    return false
end

function MercenaryHuntCtrl:CheckGetRankRewardByRankId(rankId)
    return self.getRankRewardMap[rankId]
end

function MercenaryHuntCtrl:CheckCanGetRankReward()
    for i = 1, self.curRankId do
        if not self.getRankRewardMap[i] then
            return true
        end
    end

    if self:CheckGetDailyReward() then
        return true
    end

    return false
end

function MercenaryHuntCtrl:UpdatePromoteInfo(data)
    self.promoteData = data
    EventMgr.Instance:Fire(EventName.UpdatePromoteInfo)
end

function MercenaryHuntCtrl:GetLastPromoteRecoverTime()
    return self.promoteData.last_add_promote_time
end

function MercenaryHuntCtrl:GetCurPromoteNum()
    if not self.promoteData then
        return 0
    end
    return self.promoteData.promote_time
end

function MercenaryHuntCtrl:UpdateDailyRewardInfo(data)
    self.dailyRewardInfo = data
    EventMgr.Instance:Fire(EventName.UpdateDailyRewardInfo)
end

function MercenaryHuntCtrl:CheckGetDailyReward()
    local data = self.dailyRewardInfo
    if not data then
        return false
    end

    if data.daily_reward_rank_id == 0 then
        return false
    end

    if data.is_get_daily_reward ~= 0 then
        return false
    end

    return true
end

function MercenaryHuntCtrl:GetDailyRewardRankId()
    local curRankId = self:GetCurRankInfo()
    if not self.dailyRewardInfo or self.dailyRewardInfo.daily_reward_rank_id == 0 then
        return curRankId
    end

    return self.dailyRewardInfo.daily_reward_rank_id
end

function MercenaryHuntCtrl:CheckMercenaryEscape(ecoId)
    local data = self.mercenaryMap[ecoId]
    if not data then return end
    local curServerTime = TimeUtils.GetCurTimestamp()
    local bornTime = data.reborn_time / 1000

    local curPromoteNum = self:GetCurPromoteNum()

    if bornTime >= curServerTime and curPromoteNum <= 0 then 
        return true
    end

    return false
end