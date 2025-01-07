MercenaryHuntManager = BaseClass("MercenaryHuntManager")

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

local DiscoverState = MercenaryHuntConfig.MercenaryDiscoverState
local ChaseState = MercenaryHuntConfig.MercenaryChaseState
local AlertState = MercenaryHuntConfig.AlertState

local createTimeCD = 5

function MercenaryHuntManager:__init(fight)
	self.fight = fight
    self.clientFight = fight.clientFight
    self.mercenaryHuntCtrl = mod.MercenaryHuntCtrl
    self.mercenaryFacade = mod.MercenaryHuntFacade

    self.nearbyMap = {}
    self.fightMercenaryMap = {}
    self.mercenaryEcoCtrlMgr = MercenaryEcoCtrlManager.New(self)
    self.showHuntTipList = {}

    -- 追击范围内的列表
    self.chaseRadiusMap = {}

    -- 发现佣兵列表
    self.DiscoverCacheMap = {}

    self.createTimeCD = createTimeCD

    self:InitData()
    self:BindListener()
end

function MercenaryHuntManager:BindListener()
    EventMgr.Instance:AddListener(EventName.FightPause, self:ToFunc("FightPause"))
    EventMgr.Instance:AddListener(EventName.UpdateMainId, self:ToFunc("InitData"))
    EventMgr.Instance:AddListener(EventName.CloseHuntTip, self:ToFunc("CloseHuntTip"))
    EventMgr.Instance:AddListener(EventName.OnDoDamage, self:ToFunc("TriggerDamage"))
end

function MercenaryHuntManager:__delete()
    if self.mercenaryCtrlMgr then
        self.mercenaryCtrlMgr:DeleteMe()
    end

    if self.mercenaryHuntCtrl then
        self.mercenaryHuntCtrl:ClearMercenaryCreateMap()
    end
end

function MercenaryHuntManager:Update()
    if self.mercenaryEcoCtrlMgr then
        self.mercenaryEcoCtrlMgr:Update()
    end

    if self.mercenaryAlertTime and self:CheckDecAlertTime() then
        if self.mercenaryAlertTime > 0 then
            self.mercenaryAlertTime = self.mercenaryAlertTime - Time.deltaTime
        end
        if self.mercenaryAlertTime <= 0 and self.alertState ~= AlertState.Dec then
            self:ChangePlayerFightState(AlertState.Dec)
        end
    end

    self:UpdateMercenaryCreateTime()
end

function MercenaryHuntManager:CheckDecAlertTime()
    if BehaviorFunctions.fight:CheckFightPause() or
        TableUtils.GetTabelLen(self.fightMercenaryMap) > 0 or
        TableUtils.GetTabelLen(self.chaseRadiusMap) > 0 then
            return false
    end

    return true
end

function MercenaryHuntManager:UpdateMercenaryCreateTime()
    if self.createTimeCD and self.createTimeCD <= 0 then
        self.createTimeCD = createTimeCD
        if Fight.Instance then
            Fight.Instance.entityManager.ecosystemEntityManager:CreateMercenaryEntity()
        end
        return
    end
    self.createTimeCD = self.createTimeCD - Time.deltaTime
end

--[[
    在游戏暂停时，停止计时
    如果当前处于递减的状态则改变状态，在停止时停后还原
]]
function MercenaryHuntManager:FightPause(isPause)
    local state = isPause and AlertState.Stop or AlertState.Dec
    if not self.mainId or self.mainId == 0 then return end
    if self.mercenaryAlertTime > 0 then return end
    self:ChangePlayerFightState(state)
end

function MercenaryHuntManager:InitData()
    local mainId = self.mercenaryHuntCtrl:GetMainId()
    if self.mainId == mainId then return end
    local cfg = MercenaryHuntConfig.GetMercenaryHuntMainConfig(mainId)
    if not cfg then return end
    self.mainId = mainId
    self.mainCfg = cfg
    self.mercenaryAlertTime = cfg.dec_alert_time
end

function MercenaryHuntManager:IsMercenaryEntityByEcoId(ecoId)
    local mercenaryData = self.mercenaryHuntCtrl:GetMercenaryData(ecoId)
    if mercenaryData then
        return true
    end
    return false
end

function MercenaryHuntManager:IsMercenaryChase(ecoId)
    local mercenaryData = self.mercenaryHuntCtrl:GetMercenaryData(ecoId)
    if not mercenaryData then return end
    return mercenaryData.chase_state == ChaseState.Chase
end

function MercenaryHuntManager:IsMercenaryChasePos(ecoId)
	local mercenaryCtrl = self:GetMercenaryCtrl(ecoId)
    if not mercenaryCtrl then return end
    return mercenaryCtrl:CheckMercenaryChasePos()
end

-- 发现佣兵
function MercenaryHuntManager:DiscoverMercenary(ecoId)
    local mercenaryData = self.mercenaryHuntCtrl:GetMercenaryData(ecoId)
    if not mercenaryData then return end

    if mercenaryData.discover_state == DiscoverState.Discover and
        mercenaryData.chase_state == ChaseState.Chase and self.DiscoverCacheMap[ecoId] then
        if not self.chaseRadiusMap[ecoId] then
            self.chaseRadiusMap[ecoId] = true
        end
        self:ResetAlertTime()
        return
    end

    if self.DiscoverCacheMap[ecoId] then return end
	mercenaryData.discover_state = DiscoverState.Discover
    self.DiscoverCacheMap[ecoId] = true

    -- 添加队列
    _tInsert(self.showHuntTipList, {MercenaryHuntConfig.ShowTipType.Discover, 5, Fight.Instance.mercenaryHuntManager:GetMercenaryName(ecoId)})

    self.mercenaryHuntCtrl:AddMercenaryMark(ecoId)

    self:CheckShowHunTip()
    self:ClearChaseRadius(ecoId)
    self.mercenaryFacade:SendMsg("mercenary_discover_state", ecoId)
end

function MercenaryHuntManager:ClearDiscoverState(ecoId)
    self.DiscoverCacheMap[ecoId] = nil
end

-- 击杀佣兵
function MercenaryHuntManager:KillMercenary(ecoId)
    local mercenaryData = self.mercenaryHuntCtrl:GetMercenaryData(ecoId)
    if not mercenaryData then return end

    -- 添加队列
    _tInsert(self.showHuntTipList, {MercenaryHuntConfig.ShowTipType.Fight, 1, Fight.Instance.mercenaryHuntManager:GetMercenaryName(ecoId)})
    self:CheckShowHunTip()

    self.mercenaryHuntCtrl:KillMercenary(ecoId)

    if self.mercenaryEcoCtrlMgr then
        self.mercenaryEcoCtrlMgr:KillMercenary(ecoId)
    end
    
    -- 清除附近的数据
    self:ClearNearbyMercenary(ecoId)
    self:ClearChaseRadius(ecoId)
    self:ClearDiscoverState(ecoId)
    
    Fight.Instance.entityManager.ecosystemEntityManager:KillMercenary(ecoId)

    EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid)
end

function MercenaryHuntManager:CheckShowHunTip()
    if not next(self.showHuntTipList) then return end
    if self.isShowHutTip then return end
    local data = self.showHuntTipList[1]
	PanelManager.Instance:OpenPanel(FindHuntTipPanel, data)
    _tRemove(self.showHuntTipList, 1)
    self.isShowHutTip = true
end

function MercenaryHuntManager:CloseHuntTip()
    self.isShowHutTip = false
    self:CheckShowHunTip()
end

-- 记录佣兵在玩家的附近
function MercenaryHuntManager:NearbyMercenary(ecoId)
    -- 分发事件
    if not self.nearbyMap[ecoId] then
        self.nearbyMap[ecoId] = true
        EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid)
    end
end

function MercenaryHuntManager:ClearNearbyMercenary(ecoId)
    if self.nearbyMap[ecoId] then
        self.nearbyMap[ecoId] = nil
        EventMgr.Instance:Fire(EventName.UpdateMercenaryGuid)
    end
end

function MercenaryHuntManager:CheckNearbyMercenary()
    return next(self.nearbyMap)
end

function MercenaryHuntManager:PlayerAddTarget(instanceId)
    local entityMgr = Fight.Instance.entityManager
    local ecoEntityManager = entityMgr.ecosystemEntityManager
    local ecoId = BehaviorFunctions.GetEntityEcoId(instanceId)
    -- 是佣兵战斗重置时间
    if ecoEntityManager:IsMercenaryEntity(ecoId) then
        self.fightMercenaryMap[instanceId] = true
        self:ResetAlertTime()
    end
end

function MercenaryHuntManager:PlayerRemoveTarget(instanceId)
    self.fightMercenaryMap[instanceId] = nil
end

--[[ 
    期间只要增加了警戒值，就会重新倒计时 
    期间只要与佣兵进入战斗，就会重新倒计时 
    追击的佣兵被发现，重新倒计时 
]]
function MercenaryHuntManager:ResetAlertTime(isResetTime)
    if not self.mainCfg then return end
    
    if isResetTime then
        self.mercenaryAlertTime = self.mainCfg.dec_alert_time
    end
    self:ChangePlayerFightState(AlertState.Stop)
end

function MercenaryHuntManager:ClearChaseRadius(ecoId)
	if self.chaseRadiusMap[ecoId] then
    	self.chaseRadiusMap[ecoId] = nil
	end
end

-- 改变玩家状态，闲置，交互
function MercenaryHuntManager:ChangePlayerFightState(state)
    if self.alertState == state then
        return
    end

    self.alertState = state
    self.mercenaryFacade:SendMsg("mercenary_fight_state", state)
end

function MercenaryHuntManager:GMSetMercenaryChase(ecoId, state)
    local mercenaryData = self.mercenaryHuntCtrl:GetMercenaryData(ecoId)
    if not mercenaryData then return end
    mercenaryData.chase_state = state
    self.mercenaryHuntCtrl:UpdateMercenaryChaseEntity()
end

function MercenaryHuntManager:GetMercenaryName(ecoId)
    local mercenaryData = self.mercenaryHuntCtrl:GetMercenaryData(ecoId)
    if not mercenaryData then return end
    local nameData = mercenaryData.name_list
    local cfg = MercenaryHuntConfig:GetMercenaryEcoConfig(ecoId)
    
    local namePrefixId = cfg.name_prefix_id
    local nameId = cfg.name_id

    local prefix = MercenaryHuntConfig.GetMercenaryName(namePrefixId, nameData[1])
    local name = MercenaryHuntConfig.GetMercenaryName(nameId, nameData[2])
    return prefix..name
end

function MercenaryHuntManager:AddMercenaryCtrl(ecoId)
    if not self.mercenaryEcoCtrlMgr then return end
    self.mercenaryEcoCtrlMgr:AddMercenaryCtrl(ecoId)
end

function MercenaryHuntManager:GetMercenaryCtrlMgr()
    return self.mercenaryEcoCtrlMgr
end

function MercenaryHuntManager:GetMercenaryCtrl(ecoId)
    if not self.mercenaryEcoCtrlMgr then return end
    return self.mercenaryEcoCtrlMgr:GetMercenaryEco(ecoId)
end

function MercenaryHuntManager:TriggerDamage(atkInstanceId, hitInstanceId)
    local ecoEntityMgr = Fight.Instance.entityManager.ecosystemEntityManager
    local tempEntity = BehaviorFunctions.GetEntity(atkInstanceId)
    local atkEntity = tempEntity.root
    if not ecoEntityMgr:IsMercenaryEntity(atkEntity.sInstanceId) then
        return
    end

    local hitEntity = BehaviorFunctions.GetEntity(hitInstanceId)
    if not hitEntity.tagComponent or hitEntity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.Player then
        return
    end

    local player = Fight.Instance.playerManager:GetPlayer()
    -- 检查当前编队角色是否全部死亡
    local entityMap = player:GetEntityMap()
    for _, data in pairs(entityMap) do
        local entity = BehaviorFunctions.GetEntity(data.InstanceId)
        local isDeath = entity.stateComponent:IsState(FightEnum.EntityState.Death) and entity.stateComponent.stateFSM:CheckDeathAnimState()
        if not isDeath then
            return
        end
    end
    self.mercenaryFacade:SendMsg("mercenary_kill_player")
end

-- 获取佣兵等级，动态获取
function MercenaryHuntManager:GetMercenaryLv(ecoId)
    local info = mod.WorldLevelCtrl:GetAdventureInfo()
    local curLv = info.lev
    local correctLv = MercenaryHuntConfig.GetMercenaryEcoCorrectLv(ecoId)
    local level = curLv + correctLv
    return level
end