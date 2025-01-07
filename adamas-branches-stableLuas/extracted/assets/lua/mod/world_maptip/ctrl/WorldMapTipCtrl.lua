---@class WorldMapTipCtrl : Controller
WorldMapTipCtrl = BaseClass("WorldMapTipCtrl", Controller)
local DataNpcSystemJump = Config.DataNpcSystemJump

local _tInsert = table.insert

function WorldMapTipCtrl:__init()
    self.finishedEvent = {} --已经完成的事件
    self.discoverEvent = {} --已经发现的事件
    self.defaultHideEvent = {} --默认隐藏的事件/生态/npc
    self.jumpParamIdToEcoId = {}
    self.mapAreaEvent = {}
    self:InitEventList()
    EventMgr.Instance:AddListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("EntityLoadDone"))
    EventMgr.Instance:AddListener(EventName.MapMarkDefaultShow, self:ToFunc("MapMarkDefaultShow"))
end

function WorldMapTipCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("EntityLoadDone"))
    EventMgr.Instance:RemoveListener(EventName.MapMarkDefaultShow, self:ToFunc("MapMarkDefaultShow"))
end

function WorldMapTipCtrl:InitEventList()
    for i, main_type in pairs(WorldMapTipConfig.MapTipType) do
        self.finishedEvent[main_type] = {}
        self.discoverEvent[main_type] = {}
        self.defaultHideEvent[main_type] = {}
    end
end

function WorldMapTipCtrl:EntityLoadDone()
    self:LoadEcosystemEvent()
    self:LoadNpcEvent()
    self:LoadMercenaryMark()
end

--  加载发现的生态  
function WorldMapTipCtrl:LoadEcosystemEvent()
    local mapId = mod.WorldMapCtrl:GetCurMap()
    local mapEntityCfg = EcoSystemConfig.GetEcosystemMark(mapId)
    if not mapEntityCfg then
        return
    end
    for ecoId, jump_system_id in pairs(mapEntityCfg) do
        local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)

        if not ecoCfg then
            goto continue
        end
        self:UpdateDiscoverEcosystemEvent(ecoCfg, ecoId)
        
        --如果处于不能出生的生态表内 定义为已完成
        if ecoCfg.is_transport then
            if mod.WorldCtrl:CheckIsTransportPointActive(ecoId) then
                self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = true
            end
        else
            if not BehaviorFunctions.CheckEntityEcoState(nil, ecoId) then
                self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = true
            end
        end
        
        ::continue::
    end
end

function WorldMapTipCtrl:UpdateDiscoverEcosystemEvent(ecoCfg, ecoId)
    if not self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] then
        for k, id in ipairs(ecoCfg and ecoCfg.jump_system_id or {}) do
            local jumpCfg = DataNpcSystemJump.Find[id]
            if not jumpCfg or not next(jumpCfg) then
                goto continue
            end

            if not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
                goto continue
            end

            if not jumpCfg.is_show then
                self.defaultHideEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = true
            else
                self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = true
            end

            ::continue::
        end
    end
end

-- 加载发现的Npc 
function WorldMapTipCtrl:LoadNpcEvent()
    local mapId = mod.WorldMapCtrl:GetCurMap()
    local npcList = EcoSystemConfig.GetNPCMark(mapId)
    for ecoId, _ in pairs(npcList) do
        self:_AddNpcEvent(ecoId, mapId)
    end

    local taskNpcList = mod.TaskCtrl:GetAllNpcOccupyTask()
    for ecoId, v in pairs(taskNpcList) do
        self:_AddNpcEvent(ecoId, mapId)
    end
end

-- 加载发现的佣兵 后续如果有需要 todo
function WorldMapTipCtrl:LoadMercenaryMark()
    
end


function WorldMapTipCtrl:_AddNpcEvent(ecoId, map)
    --local npcCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
    local jumpCfg = Fight.Instance.entityManager.npcEntityManager:GetNpcJumpCfg(ecoId)

    if not jumpCfg then
        return
    end

    local paramsId = jumpCfg.param[1]
    --如果该npc是脉灵则校验一下，记录到完成列表
    if paramsId then
        local mailingState = false
        self.jumpParamIdToEcoId[paramsId] = ecoId
        mailingState = mod.MailingCtrl:CheckMailingState(paramsId, FightEnum.MailingState.Finished)
        
        if mailingState then
            self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = true
            return
        end
    end

    if not jumpCfg.is_show then
        self.defaultHideEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = true
    else
        self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = true
    end
end

--更新jumpCfg.is_show的发现数据
function WorldMapTipCtrl:MapMarkDefaultShow(ecoId)
    local cfg, type = EcoSystemConfig.GetEcoConfig(ecoId)
    if type == FightEnum.EcoEntityType.Npc then
        if not self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] then
            self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = true
        end
        if self.defaultHideEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] then
            self.defaultHideEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = nil
        end
    else
        if not self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] then
            self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = true
        end
        if self.defaultHideEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] then
            self.defaultHideEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = nil
        end
    end
end

--更新被移除的生态
function WorldMapTipCtrl:RemoveMarkEcoShow(ecoId)
    local cfg, type = EcoSystemConfig.GetEcoConfig(ecoId)
    if type == FightEnum.EcoEntityType.Npc then
        if self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] then
            self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = nil
        end
    else
        if self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] then
            self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = nil
        end
    end
end

function WorldMapTipCtrl:UpdateEcoBornState(data)
    for k, v in ipairs(data.entity_born_list or {}) do
        if not BehaviorFunctions.CheckEntityEcoState(nil, v.id) then
            self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipEco][v.id] = true
        end
    end

    for k, ecoId in pairs(data.unable_reborn_entity_list or {}) do
        if not BehaviorFunctions.CheckEntityEcoState(nil, ecoId) then
            self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipEco][ecoId] = true
        end
    end
end

-- 更新已经完成的随机事件
function WorldMapTipCtrl:UpdateLevelEventList(data)
    --更新已经完成的levelEvent
    for i, v in pairs(data.level_event_list) do
        self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipLevelEvent][v.event_id] = true
    end
end

-- 更新被发现的随机事件
function WorldMapTipCtrl:UpdateActiveLevelEventInfo(data)
    --更新已经完成的levelEvent
    for i, event_id in pairs(data.trigger_list) do
        self.discoverEvent[WorldMapTipConfig.MapTipType.MapTipLevelEvent][event_id] = true
    end
end

-- 更新已经激活的生态实体
function WorldMapTipCtrl:UpdateEcoEntityInfo(data)
    for i, v in pairs(data.entity_state_list) do
        if v.state >= 1000 then
            local cfg, type = EcoSystemConfig.GetEcoConfig(v.entity_born_id)
            if type == FightEnum.EcoEntityType.Npc then
                self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][v.entity_born_id] = true
            else
                self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipEco][v.entity_born_id] = true
            end
        end
    end
end

-- 更新已经激活的传送点
function WorldMapTipCtrl:UpdateEcoTransportPoints(data)
    for i, transPortId in pairs(data.entity_born_id) do
        self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipEco][transPortId] = true
    end
end

-- 更新已经激活的脉灵
function WorldMapTipCtrl:UpdateNpcMailing(mailingId)
    local ecoId = self.jumpParamIdToEcoId[mailingId]
    self.finishedEvent[WorldMapTipConfig.MapTipType.MapTipNpcEntity][ecoId] = true
	self.jumpParamIdToEcoId[mailingId] = nil
end

function WorldMapTipCtrl:InitMapAreaEvent(mapId, areaId)
    if not self.mapAreaEvent then
        self.mapAreaEvent = {}
    end
    if not self.mapAreaEvent[mapId] then
        self.mapAreaEvent[mapId] = {}
    end
    if not self.mapAreaEvent[mapId][areaId] then
        self.mapAreaEvent[mapId][areaId] = {}
    end
end

--获取该地图区域下所有事件（按玩法类型分类） -- [mapId][areaId][tipId]
function WorldMapTipCtrl:GetMapAreaAllEvent(mapId, areaId)
    self:InitMapAreaEvent(mapId, areaId)
    if next(self.mapAreaEvent[mapId][areaId]) then
        return self.mapAreaEvent[mapId][areaId]
    end
    local mapEvent = self.mapAreaEvent[mapId][areaId]
    
    local mapTipCfgByGroup = WorldMapTipConfig.GetMapTipCfgByMapIdAndAreaId(mapId, areaId)
    for _, tipId in pairs(mapTipCfgByGroup) do
        mapEvent[tipId] = tipId
    end
    
    return self.mapAreaEvent[mapId][areaId]
end

function WorldMapTipCtrl:GetMapAreaProgress(mapId, areaId)
    --已完成的数量/总数量
    local finishedNum = 0
    local maxNum = 0
    local areaAllEvent = self:GetMapAreaAllEvent(mapId, areaId)
    for i, tipId in pairs(areaAllEvent) do
        local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
        for _, event_id in pairs(mapTipCfg.property) do
            if self.finishedEvent[mapTipCfg.main_type][event_id] then
                finishedNum = finishedNum + 1
            end
            maxNum = maxNum + 1
        end
    end
    
    return math.floor((finishedNum / maxNum) * 100) 
end

--获取发现但是未完成的事件
function WorldMapTipCtrl:GetDiscoverEvent(tipId)
    local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
    local tipTb = {}
    for i, event_id in pairs(mapTipCfg.property) do
        if self.discoverEvent[mapTipCfg.main_type][event_id] and not self.finishedEvent[mapTipCfg.main_type][event_id] then
            _tInsert(tipTb, event_id)
        end
    end
    return tipTb
end

--获取未发现的事件
function WorldMapTipCtrl:GetNoDiscoverEvent(tipId)
    local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
    local tipTb = {}
    for i, event_id in pairs(mapTipCfg.property) do
        if not self.discoverEvent[mapTipCfg.main_type][event_id] then
            _tInsert(tipTb, event_id)
        end
    end
    return tipTb
end

--获取已经完成的事件
function WorldMapTipCtrl:GetFinishedEvent(tipId)
    local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
    local tipTb = {}
    for i, event_id in pairs(mapTipCfg.property) do
        if self.finishedEvent[mapTipCfg.main_type][event_id] then
            _tInsert(tipTb, event_id)
        end
    end
    return tipTb
end

--获取事件的一系列信息 (名字、距离、地图上mark的instanceId)
function WorldMapTipCtrl:GetTipEventInfo(tipId, eventId)
    local name = TI18N("")
    local dis = 0
    local instance
    
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local playerPos = player.transformComponent:GetPosition()
    
    local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
    if mapTipCfg.main_type == WorldMapTipConfig.MapTipType.MapTipLevelEvent then
        local eventCfg = LevelEventConfig.GetLevelEventConfig(eventId)
        name = eventCfg.event_name or ""
        local position = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(eventCfg.position_id, eventCfg.positing[2], eventCfg.positing[1])
        instance = self:GetTipEventToInstanceId(tipId, eventId)
        dis = Vec3.DistanceXZ(playerPos, position)
    elseif mapTipCfg.main_type == WorldMapTipConfig.MapTipType.MapTipEco or mapTipCfg.main_type == WorldMapTipConfig.MapTipType.MapTipNpcEntity then
        local cfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(eventId)
        local jumpId = cfg.jump_system_id[1]
        local jumpCfg
        if jumpId then
            jumpCfg = DataNpcSystemJump.Find[jumpId]
        end
        name = jumpCfg and jumpCfg.name or ""
        local position = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(cfg.position_id, cfg.position[2], cfg.position[1])
        instance = self:GetTipEventToInstanceId(tipId, eventId)
        dis = Vec3.DistanceXZ(playerPos, position)
    end
    
    return name, math.floor(dis), instance
end

--获取事件对应在地图上的mark的instanceId
function WorldMapTipCtrl:GetTipEventToInstanceId(tipId, eventId)
    local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
    local instance
    if mapTipCfg.main_type == WorldMapTipConfig.MapTipType.MapTipLevelEvent then
        local key = mod.LevelEventCtrl:GetMapEventId(eventId)
        instance = mod.WorldMapCtrl:GetLevelEventMark(key)
    elseif mapTipCfg.main_type == WorldMapTipConfig.MapTipType.MapTipEco or mapTipCfg.main_type == WorldMapTipConfig.MapTipType.MapTipNpcEntity then
        local marKInfo = mod.WorldMapCtrl:GetEcosystemMark(eventId)
        instance = marKInfo and marKInfo.instanceId
    end
    
    return instance
end
