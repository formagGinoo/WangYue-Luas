MercenaryHuntCtrl = BaseClass("MercenaryHuntCtrl",Controller)

local ChaseState = MercenaryHuntConfig.MercenaryChaseState

function MercenaryHuntCtrl:__init()
    self.windowManager = WindowManager.Instance

    self.mainId = 0
    self.getRewardTime = 0
    self.alertValue = 0
    self.rankExpVal = 0
    self.rankLev = 0
    self.getRankRewardMap = {}

    -- 加这个是为了防止多次创建相同的怪
    self.createMap = {}
    -- 佣兵列表
    self.mercenaryMap = {}
    -- 佣兵标记列表
    self.mercenatyMarkMap = {}

    EventMgr.Instance:AddListener(EventName.MercenaryMarkAdded, self:ToFunc("OnMapMarkInited"))
end

function MercenaryHuntCtrl:InitMercenaryHuntMainInfo(data)
    self.getRewardTime = data.reward_time
    if self.mainId ~= data.main_id then
        self.mainId = data.main_id
        EventMgr.Instance:Fire(EventName.UpdateMainId)
    end
end

function MercenaryHuntCtrl:GetMainId()
   return self.mainId
end

function MercenaryHuntCtrl:GetRewardTime()
    return self.getRewardTime
end

function MercenaryHuntCtrl:UpdateMercenaryList(newData)
    --  跨天的时候清除所有的佣兵
    if newData.is_refresh then
        self:ClearMercenaryEntity()
    end

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
    end

    -- 创建佣兵
    if Fight.Instance then
        Fight.Instance.entityManager.ecosystemEntityManager:CreateMercenaryEntity()
    end

    if next(changMap) then
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

    if fixedMap then
        for ecoId, state in pairs(fixedMap) do
            local ctrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
            if ctrl then
                ctrl:UpdateMercenaryChaseState(state == ChaseState.Chase)
            end
        end
        EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid)
        return
    end

    for ecoId, data in pairs(self.mercenaryMap) do
        local ctrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
        if ctrl then
            ctrl:UpdateMercenaryChaseState(data.chase_state == ChaseState.Chase)
        end
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
    self.mercenaryMap[ecoId] = nil
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

function MercenaryHuntCtrl:CheckCreateMercenary(ecoId)
    return not self.createMap[ecoId]
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

function MercenaryHuntCtrl:UpdateMercenaryRankVal(rankExp)
    self.rankExpVal = rankExp
    self.rankLev = MercenaryHuntConfig.GetRankLvByExp(rankExp)
    EventMgr.Instance:Fire(EventName.UpdateMercenaryRankVal, self.rankLev, self.rankExpVal)
end

function MercenaryHuntCtrl:UpdateGetMercenaryRankRewardMap(stateList)
    for _, val in pairs(stateList) do
        self.getRankRewardMap[val] = true
    end
    EventMgr.Instance:Fire(EventName.GetRankReward)
end

function MercenaryHuntCtrl:GetRankRewardMap()
    return self.getRankRewardMap
end

function MercenaryHuntCtrl:CheckCanGetRankReward()
    for i = 1, self.rankLev, 1 do
        if self.getRankRewardMap[i] == nil then
            return true
        end
    end
    return false
end