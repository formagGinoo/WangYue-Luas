---@class WorldMapCtrl : Controller
WorldMapCtrl = BaseClass("WorldMapCtrl", Controller)

local MAP_AREA_SIZE = 2048
local DataNpcSystemJump = Config.DataNpcSystemJump
local MapConfig = Config.DataMap.data_map
local MapSceneConfig = Config.DataMap.data_scene
local MapTrackDisappear = Config.DataCommonCfg.Find["MapTrackDisappear"].int_val

function WorldMapCtrl:__init()
    self.mapId = nil
    self.mapCfg = {}
    self.anchorPosition = Vec3.zero

    self.uiMapSize = {}

    self.marks = {}
    self.markInstance = {}
    self.customMarkInstance = {}
    self.markBlock = {}
    self.markInstanceId = 0
    self.customMarkInstanceId = 0

    self.defaultHideMarks = {}      -- 生态的默认隐藏图标 用服务器判断
    self.hideMarks = {}             -- 走本地的隐藏图标 用距离判断
    self.removeHideMarkList = {}

    self.marksBindEcoId = {}
    self.svrChangeStateJumpIds = {}
    self.traceMarks = {}
    self.playerMark = nil
    self.initJumpIds = true
    self.marksBindEvent = {}
    self.marksLevelEvent = {}

    self.waitSvrList = {}

    self.movingMarks = {}

    self.player = nil

    self.NavMeshId2Marks = {}   -- navmeshId映射路径markid
    self.NavRoadDrawId2Marks = {}   -- 路径id映射路径markid
    
    self.NavDrawId2TraceMarks = {} --画线id映射追踪markid
    self.TargetMarks2NavDrawId = {} -- 目标markid映射路径id
    self.TargetPointer2NavDrawId = {} 
    
    self.jumpParamIdToEcoId = {} --jumpParamId对应ecoId

    self.checkDone = {
        [FightEnum.CreateEntityType.Ecosystem] = false,
        [FightEnum.CreateEntityType.Npc] = false,
        [FightEnum.CreateEntityType.Mercenary] = false,
    }
    -- 用来做没去过的地图的标记记录
    self.mapMarkInitDone = {}

    -- 存还没初始化的时候 如果有实体触发了进入区域的缓存列表
    self.enterCache = {}
    self.exitCache = {}
    self.isInRoom = false
    self.targetPointerWithNav2NavDrawId = {}    -- 多段追踪的

    EventMgr.Instance:AddListener(EventName.EcosystemInitDone, self:ToFunc("OnWorldEntityInitDone"))
    EventMgr.Instance:AddListener(EventName.ExitFight, self:ToFunc("OnExitFight"))
    EventMgr.Instance:AddListener(EventName.TransportPointActive, self:ToFunc("TransportPointActive"))
    EventMgr.Instance:AddListener(EventName.UpdateRoadPath, self:ToFunc("OnUpdateRoadPath"))
    EventMgr.Instance:AddListener(EventName.RemoveRoadPath, self:ToFunc("OnRemoveRoadPath"))
    EventMgr.Instance:AddListener(EventName.UpdateNavMeshPath, self:ToFunc("OnUpdateNavMeshPath"))
    EventMgr.Instance:AddListener(EventName.RemoveNavMeshPath, self:ToFunc("OnRemoveNavMeshPath"))
    EventMgr.Instance:AddListener(EventName.RemoveDrawPath, self:ToFunc("OnRemoveNavDrawPath"))

    EventMgr.Instance:AddListener(EventName.ExitInRoomArea, self:ToFunc("OnExitInRoomArea"))
    EventMgr.Instance:AddListener(EventName.EnterInRoomArea, self:ToFunc("OnEnterInRoomArea"))
    EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("OnPlayerUpdate"))

    --EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnEntityRemove"))
    EventMgr.Instance:AddListener(EventName.EntityHitEnd, self:ToFunc("OnEntityHitEnd"))
    EventMgr.Instance:AddListener(EventName.MailingExchangeResult, self:ToFunc("OnMailingNpcRemove"))
end

function WorldMapCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.EcosystemInitDone, self:ToFunc("OnWorldEntityInitDone"))
    EventMgr.Instance:RemoveListener(EventName.ExitFight, self:ToFunc("OnExitFight"))
    EventMgr.Instance:RemoveListener(EventName.TransportPointActive, self:ToFunc("TransportPointActive"))
    EventMgr.Instance:RemoveListener(EventName.UpdateRoadPath, self:ToFunc("OnUpdateRoadPath"))
    EventMgr.Instance:RemoveListener(EventName.RemoveRoadPath, self:ToFunc("OnRemoveRoadPath"))
    EventMgr.Instance:RemoveListener(EventName.UpdateNavMeshPath, self:ToFunc("OnUpdateNavMeshPath"))
    EventMgr.Instance:RemoveListener(EventName.RemoveNavMeshPath, self:ToFunc("OnRemoveNavMeshPath"))
    EventMgr.Instance:RemoveListener(EventName.RemoveDrawPath, self:ToFunc("OnRemoveNavDrawPath"))

    EventMgr.Instance:RemoveListener(EventName.ExitInRoomArea, self:ToFunc("OnExitInRoomArea"))
    EventMgr.Instance:RemoveListener(EventName.EnterInRoomArea, self:ToFunc("OnEnterInRoomArea"))
    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("OnPlayerUpdate"))

    --EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnEntityRemove"))
    EventMgr.Instance:RemoveListener(EventName.EntityHitEnd, self:ToFunc("OnEntityHitEnd"))
    EventMgr.Instance:RemoveListener(EventName.MailingExchangeResult, self:ToFunc("OnMailingNpcRemove"))
end

function WorldMapCtrl:SetLoginMapAndPos(mapId, pos, rot)
    self.loginMapID = mapId
    self.loginMapPos = pos
    self.loginMapRot = rot
end

function WorldMapCtrl:SetDuplicateInfo(duplicateId, levelId)
    self.duplicateId = duplicateId
    self.dupLevelId = levelId
end

function WorldMapCtrl:GetDuplicateInfo()
    return self.duplicateId, self.dupLevelId
end

function WorldMapCtrl:CacheTpRotation(rotX, rotY, rotZ ,rotW)
    self.cacheRotation = {rotX = rotX, rotY = rotY, rotZ = rotZ,rotW = rotW}
end

function WorldMapCtrl:GetCacheTpRotation()
    if not self.cacheRotation then return end
    local rotX = self.cacheRotation.rotX
    local rotY = self.cacheRotation.rotY
    local rotZ = self.cacheRotation.rotZ
    local rotW = self.cacheRotation.rotW
    self.cacheRotation = nil
    return rotX, rotY, rotZ, rotW
end

function WorldMapCtrl:CacheEnterMapCallback(callback)
    self.cacheEnterMapCallback = callback
end

function WorldMapCtrl:DoCacheEnterMapCallback()
    if not self.cacheEnterMapCallback then return end
    self.cacheEnterMapCallback()
    self.cacheEnterMapCallback = nil
end

function WorldMapCtrl:EnterMap(mapId, position, rotate, heroList, isLogin)
    local map = self.loginMapID and self.loginMapID or mapId
    local pos = self.loginMapPos and self.loginMapPos or position
    local rot = self.loginMapRot and self.loginMapRot or rotate
    if not self.mapId or self.mapId ~= map then
        EventMgr.Instance:Fire(EventName.EnterMap, map)
    end

    for k, v in pairs(self.checkDone) do
        self.checkDone[k] = false
    end
    -- 同步属性
    mod.LoginCtrl:SetPlayerSyncPropery()
    if self.player then 
        for i, roldId in ipairs(mod.FormationCtrl:GetCurFormationInfo().roleList) do
            mod.FormationCtrl:SyncServerProperty(self.player:GetInstanceIdByHeroId(roldId))
        end
    end

    self.player = nil
    self.loginMapID = nil
    self.loginMapPos = nil
	self.loginMapRot = nil
    self:SetCurMap(map)
    self:CreateFight(heroList, pos, rot, isLogin)
end

function WorldMapCtrl:CreateFight(heroList, enterPos, enterRot, isLogin)
	if not heroList then
		local curFormation = mod.FormationCtrl:GetCurFormationInfo()
		heroList = {}
		local index = 0
		for i = 1, #curFormation.roleList do
			if curFormation.roleList[i] ~= 0 and curFormation.roleList[i] ~= -1 then
				index = index + 1
				heroList[index] = curFormation.roleList[i]
			end
		end
	end

	local fightData = FightData.New()
	fightData:BuildFightData(heroList, self.mapId, isLogin)
	if Fight.Instance then
		Network.Instance:SetStopRecv(true)
		Fight.Instance:Clear()
	end

	Fight.New()

	if self.debugDuplicate then
		Fight.Instance:SetDebugFormation(heroList)
		self.debugDuplicate = false
	end
	Fight.Instance:EnterFight(fightData:GetFightData(), enterPos, enterRot)
end

function WorldMapCtrl:EnterDebugDuplicate(duplicateId, heroList)
	self.debugDuplicate = true

	self.duplicateId = duplicateId
	local duplicateConfig = Config.DataDuplicate.data_duplicate[duplicateId]
	self.dupLevelId = duplicateConfig.level_id

	mod.WorldMapCtrl:EnterMap(duplicateConfig.map_id, Vec3.zero, Vec3.zero, heroList)
end

function WorldMapCtrl:CheckIsDup()
	return self.duplicateId ~= nil
end

function WorldMapCtrl:IsDebugDuplicate()
	return self.debugDuplicate
end

function WorldMapCtrl:LeaveDuplicate()
    if not self.duplicateId then
        return
    end

    if Fight.Instance then
        Fight.Instance:LeaveDuplicate()
    end
    
    self.duplicateId = nil
    self.dupLevelId = nil
    EventMgr.Instance:Fire(EventName.LeaveDuplicate)
end

function WorldMapCtrl:AfterUpdate()
    if not Fight.Instance or mod.WorldMapCtrl:CheckIsDup() then
        if not Fight.Instance and self.player then
            self.player = nil
        end
        return
    end

    if not self.player then
        self.player = Fight.Instance.playerManager:GetPlayer()
        self.curCtrlEntity = self.player:GetCtrlEntityObject()
    end
    
    self:UpdateDefaultHideMarks()
end

function WorldMapCtrl:UpdateDefaultHideMarks()
    if not self.defaultHideMarks or not next(self.defaultHideMarks) then
        return
    end

    local position = self.curCtrlEntity.transformComponent:GetPosition()
    for k, v in pairs(self.defaultHideMarks) do
		local dis = BehaviorFunctions.GetDistanceFromPos(self.marks[k].position, position)
        local isCanActive = dis <= self.marks[k].jumpCfg.show_distance
        local ecoId = self.marks[k].ecoCfg.id
        if isCanActive and not self.waitSvrList[ecoId] then
            self:SendMapMarkActive({ecoId})
            self.waitSvrList[ecoId] = true
        end
    end
end

function WorldMapCtrl:UpdateSvrChangeStateJumpIds()
    if not self.svrChangeStateJumpIds or not next(self.svrChangeStateJumpIds) then
        return
    end
    
    local position = self.curCtrlEntity.transformComponent:GetPosition()
    for ecoId, v in pairs(self.svrChangeStateJumpIds) do
        if not self.marksBindEcoId[ecoId] and not BehaviorFunctions.CheckEcoEntityState(nil, ecoId) then
            local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
            if not ecoCfg or (ecoCfg.map_id ~= self.mapId) then
                goto continue
            end 
            for k, id in ipairs(ecoCfg and ecoCfg.jump_system_id or {}) do
                local jumpCfg = DataNpcSystemJump.Find[id]
                local singleMap = MapSceneConfig[self.mapId] or self.mapCfg
                local ecoPosition = self:GetMapPositionConfigByPositionId(singleMap.position_id, ecoCfg.position[2], ecoCfg.position[1])

                local dis = BehaviorFunctions.GetDistanceFromPos(ecoPosition, position)
                local isCanActive = dis <= jumpCfg.show_distance

                if isCanActive then
                    local instanceId = self:AddEcoMark(ecoCfg, jumpCfg, self.mapId)
                    self.marksBindEcoId[ecoId] = instanceId
                    EventMgr.Instance:Fire(EventName.MapMarkDefaultShow, ecoId)
                end
            end
            
            ::continue::
        end
    end
end

function WorldMapCtrl:UpdateHideMarks()
    if not self.hideMarks or not next(self.hideMarks) then
        return
    end

    local position = self.curCtrlEntity.transformComponent:GetPosition()
    for k, v in pairs(self.hideMarks) do
        local mark = self.marks[k]
        if not mark.jumpCfg then
            goto continue
        end

        local dis = BehaviorFunctions.GetDistanceFromPos(mark.position, position)
        if mark.jumpCfg.show_distance >= dis then
            self.hideMarks[k] = nil
            EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Add, k)
            -- table.insert(self.removeHideMarkList, k)
        end

        ::continue::
    end

    -- for k, v in pairs(self.removeHideMarkList) do
    --     self.hideMarks[k] = nil
    -- end
    -- TableUtils.ClearTable(self.removeHideMarkList)
end

-- 小地图动态点位刷新
function WorldMapCtrl:LowUpdate()
    if not self.mapCfg or self.mapCfg.mini_map == "" then
        return
    end
	
    if not Fight.Instance or mod.WorldMapCtrl:CheckIsDup() then
        return
    end
    
    -- 追踪点位刷新
    self:RefreshTraceMarks()
    self:UpdateHideMarks()

    if not self.movingMarks or not next(self.movingMarks) then
        return
    end

    for k, v in pairs(self.movingMarks) do
        local mark = self.marks[k]
        local ecoId
        if mark.type == FightEnum.MapMarkType.Ecosystem then
            ecoId = mark.ecoCfg.id
        elseif mark.type == FightEnum.MapMarkType.Task then
            ecoId = mark.traceEcoId
        end
        local entityInstanceId = mark.entityInstanceId

        local position

        if entityInstanceId then
            local entity = BehaviorFunctions.GetEntity(entityInstanceId)
            if not entity then
                self:RemoveMapMark(k)
            else
                position = entity.transformComponent:GetPosition()
            end
        else
            local isNpc = Fight.Instance.entityManager.npcEntityManager:CheckEcoIdIsNpc(ecoId)
            local entity
            if isNpc then
                entity = BehaviorFunctions.GetNpcEntity(ecoId)
            else
                if ecoId then
                    local ecoInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
                    if ecoInstanceId then
                        entity = BehaviorFunctions.GetEntity(ecoInstanceId)
                    end
                end
            end

            if not entity or not entity.transformComponent then
                position = BehaviorFunctions.GetEcoEntityPosition(ecoId)
            else
                position = entity.transformComponent:GetPosition()
            end

        end

        if position then
            local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, self.mapId)
            local needRefresh = math.abs(posX - self.marks[k].posX) > 5 or math.abs(posY - self.marks[k].posY) > 5
                                or self.marks[k].areaBlock ~= areaBlock
            self.marks[k].posX = posX
            self.marks[k].posY = posY

			local curMark = self.marks[k]
			self.markBlock[curMark.map][curMark.areaBlock][curMark.instanceId] = nil
			curMark.areaBlock = areaBlock
			if not self.markBlock[curMark.map][curMark.areaBlock] then
				self.markBlock[curMark.map][curMark.areaBlock] = {}
			end
            --这里如果是换区，得把mark加回来
            self.markBlock[curMark.map][curMark.areaBlock][curMark.instanceId] = true

            if needRefresh then
                EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, k)
            end
        end

    end
end

function WorldMapCtrl:RefreshTraceMarks()
    if not next(self.traceMarks) then
        return
    end
    
    --local moveEvent = Fight.Instance.operationManager:GetMoveEvent()
    --if not moveEvent then
        --return 
    --end
    
    
    local roleInstanceId = BehaviorFunctions.GetCtrlEntity()
    -- 角色的位置
    local rolePos = BehaviorFunctions.GetPositionP(roleInstanceId)
    
    for instanceId, v in pairs(self.traceMarks) do
        if self.movingMarks[instanceId] then --对移动的追踪点位，不刷新
            goto continue
        end
        
        local mark = self.marks[instanceId]
        if mark then
            if mark.jumpCfg and mark.jumpCfg.over_track then --如果是持续追踪，则靠近后不消失
                goto continue
            end
            local targetPos = mark.position
            --如果靠近
            if Vec3.Distance(rolePos, targetPos) < MapTrackDisappear then
                --销毁追踪，切换追踪状态
                self:ChangeMarkTraceState(instanceId, false)
            end
        end
        ::continue::
    end
end

function WorldMapCtrl:ClearPlayer()
    self.player = nil
end

function WorldMapCtrl:__Clear()
    self:ClearPlayer()
end

function WorldMapCtrl:OnExitFight()
    
end


function WorldMapCtrl:OnWorldEntityInitDone(type)
    -- 避免重复Load
    if self.checkDone[type] then
        return
    end

    self.checkDone[type] = true
    for _, v in pairs(self.checkDone) do
        if not v then
            return
        end
    end

    self:InitPlayerMark()
    self:InitMapMark(self.mapId)

	local sendPos = {
		pos_x = 0,
		pos_y = 0,
		pos_z = 0,
	}
	for k, v in pairs(Config.DataMap.data_map_transport) do
        local ecoCfg = Fight.Instance.entityManager:GetEntityConfigByID(k)
        if not ecoCfg or not next(ecoCfg) then
            goto continue
        end

		if not mod.WorldCtrl:CheckIsTransportPointActive(k) and v.default_active then
			mod.WorldFacade:SendMsg("ecosystem_hit", v.id, sendPos)
		end

        ::continue::
	end
end

function WorldMapCtrl:CheckWorldEntityInitDone()
    for _, v in pairs(self.checkDone) do
        if not v then
            return false
        end
    end

    return true
end

function WorldMapCtrl:CheckMapMarkInitDone(mapId)
    return self.mapMarkInitDone[mapId]
end

function WorldMapCtrl:InitMapMark(mapId)
    self:LoadEcosystemMark(mapId)
    self:LoadNpcMark(mapId)
    self:LoadMercenaryMark(mapId)
    self:LoadRogueEventMark(mapId)
    self:LoadLevelEventMark(mapId)
    self.mapMarkInitDone[mapId] = true
    EventMgr.Instance:Fire(EventName.WorldMapCtrlEntityLoadDone)
end

function WorldMapCtrl:SetCurMap(mapId)
    self.mapId = mapId
    self.mapCfg = MapSceneConfig[mapId]
    if next(self.mapCfg.anchor_pos) then
        self.anchorPosition = self:GetMapPositionConfigByPositionId(self.mapCfg.position_id, self.mapCfg.anchor_pos[2], self.mapCfg.anchor_pos[1])
    end
end

function WorldMapCtrl:LoadEcosystemMark(mapId)
    local map = mapId and mapId or self.mapId
    local mapEntityCfg = EcoSystemConfig.GetEcosystemMark(map)
    if not mapEntityCfg then
        return
    end

    for ecoId, jump_system_id in pairs(mapEntityCfg) do
        if not self.marksBindEcoId[ecoId] then
            local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
            for k, id in ipairs(ecoCfg and ecoCfg.jump_system_id or {}) do
                local jumpCfg = DataNpcSystemJump.Find[id]
                if not jumpCfg or not next(jumpCfg) then
                    goto continue
                end

                if not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) or not jumpCfg.icon or jumpCfg.icon == '' then
                    goto continue
                end

                --初始化时这里做下过滤，在unable_reborn中的eco不给添加mark
                if not ecoCfg.is_transport and not BehaviorFunctions.CheckEntityEcoState(nil, ecoId) then
                    goto continue
                end

                local instanceId = self:AddEcoMark(ecoCfg, jumpCfg, map)
                self.marksBindEcoId[ecoId] = instanceId
                if not jumpCfg.is_show and not self.svrChangeStateJumpIds[ecoCfg.id] then
                    self.defaultHideMarks[instanceId] = true
                end

                ::continue::
            end
        end
    end
end


function WorldMapCtrl:LoadNpcMark(mapId)
    local map = mapId and mapId or self.mapId
    local npcList = EcoSystemConfig.GetNPCMark(map)
    for ecoId, _ in pairs(npcList) do
        self:_AddNpcMark(ecoId, map)
    end

    local taskNpcList = mod.TaskCtrl:GetAllNpcOccupyTask()
    for ecoId, v in pairs(taskNpcList) do
        self:_AddNpcMark(ecoId, map)
    end
end

function WorldMapCtrl:_AddNpcMark(ecoId, map)
    if self.marksBindEcoId[ecoId] then
        return
    end

    local npcCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
    local jumpCfg = Fight.Instance.entityManager.npcEntityManager:GetNpcJumpCfg(ecoId)

    if not jumpCfg then
        return
    end

    --npc相关的记录下参数id
    local jumpParamId = jumpCfg.param[1]
    --检查下是不是脉灵，如果是则校验下是不是已经完成的状态
    if jumpParamId then
        local mailingState = false
        self.jumpParamIdToEcoId[jumpParamId] = ecoId
        mailingState = mod.MailingCtrl:CheckMailingState(jumpParamId, FightEnum.MailingState.Finished)
        
        if mailingState then
            return
        end
    end
    
    local instanceId = self:AddEcoMark(npcCfg, jumpCfg, map)
    self.marksBindEcoId[ecoId] = instanceId
    if not jumpCfg.is_show and not self.svrChangeStateJumpIds[npcCfg.id] then
        self.defaultHideMarks[instanceId] = true
    end
end

--加载rogue的图标
function WorldMapCtrl:LoadRogueEventMark(mapId)
    local map = mapId and mapId or self.mapId
    if not Fight.Instance then return end
    --获取被发现的事件
    local findEventList = mod.RoguelikeCtrl:GetDiscoverEventList()
    if not findEventList or not next(findEventList) then
        return
    end

    for eventId, v in pairs(findEventList) do
        local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
        local isFinished = mod.RoguelikeCtrl:GetAreaEventById(eventCfg.area, eventId)
        --遍历，如果是属于该地图的，则加入到mark中
        if not self.marksBindEvent[eventId] and not isFinished then
            if eventCfg.map_id ~= map then
                goto continue
            end
            local eventTypeCfg = RoguelikeConfig.GetRougelikeEventTypeConfig(eventCfg.event_type)
            
            local jumpCfg = DataNpcSystemJump.Find[eventTypeCfg.jump_id]
            if not jumpCfg or jumpCfg == "" or not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
                return
            end

            if not jumpCfg then
                goto continue
            end

            local instanceId = self:AddEventMark(eventCfg, jumpCfg, map, true)
            self.marksBindEvent[eventId] = instanceId
            --if not jumpCfg.is_show and not self.svrChangeStateJumpIds[eventId] then
            --    self.defaultHideMarks[instanceId] = true
            --end
            if not jumpCfg.is_show then
                self.hideMarks[instanceId] = true
            end

            ::continue::
        end
    end
end

--加载随机事件的图标
function WorldMapCtrl:LoadLevelEventMark(mapId)
    local map = mapId and mapId or self.mapId
    if not Fight.Instance then return end
    --获取被发现的事件
    local findEventList = mod.LevelEventCtrl:GetDiscoverEventList()
    if not findEventList or not next(findEventList) then
        return
    end

    for eventId, v in pairs(findEventList) do
        local eventCfg = LevelEventConfig.GetLevelEventConfig(eventId)
		local mapEventId = mod.LevelEventCtrl:GetMapEventId(eventId)
        --遍历，如果是属于该地图的，则加入到mark中
        if not self.marksLevelEvent[mapEventId] and eventCfg then
            if eventCfg.map_id ~= map then
                goto continue
            end
            
            local jumpCfg = DataNpcSystemJump.Find[eventCfg.jump_id]
            if not jumpCfg or jumpCfg == "" or not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
                return
            end

            if not jumpCfg then
                goto continue
            end

            local instanceId = self:AddLevelEventMark(eventCfg, jumpCfg, map, true)
            self.marksLevelEvent[mapEventId] = instanceId
            --if not jumpCfg.is_show and not self.svrChangeStateJumpIds[eventId] then
            --    self.defaultHideMarks[instanceId] = true
            --end

            if not jumpCfg.is_show then
                self.hideMarks[instanceId] = true
            end

            ::continue::
        end
    end
end
function WorldMapCtrl:LoadMercenaryMark(mapId)
    local map = mapId and mapId or self.mapId
    local mercenaryList = Fight.Instance.entityManager.ecosystemEntityManager:GetMercenaryEcoMap()
    if not mercenaryList or not next(mercenaryList) then
        return
    end

    for k, v in pairs(mercenaryList) do
        self:AddMercenaryMark(k)
    end
end

function WorldMapCtrl:AddMark(mark)
    if not self.markBlock[mark.map] then
        self.markBlock[mark.map] = {}
        self.markBlock[mark.map][mark.areaBlock] = {}
    elseif not self.markBlock[mark.map][mark.areaBlock] then
        self.markBlock[mark.map][mark.areaBlock] = {}
    end

    if not self.markInstance[mark.type] then
        self.markInstance[mark.type] = {}
    end

    self.markInstanceId = self.markInstanceId + 1
    mark.instanceId = self.markInstanceId

    if mark.canMove then
        self.movingMarks[mark.instanceId] = true
    end

    self.marks[mark.instanceId] = mark
    self.markInstance[mark.type][mark.instanceId] = true
    self.markBlock[mark.map][mark.areaBlock][mark.instanceId] = true
    if mark.jumpCfg and mark.jumpCfg.show_distance > 0 then

    else
        EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Add, mark.instanceId)
    end

    return mark.instanceId
end

function WorldMapCtrl:AddEcoMark(ecoCfg, jumpCfg, mapId, isMercenary)
    local singleMap = (mapId and mapId ~= self.mapId) and MapSceneConfig[mapId] or self.mapCfg
    local position = self:GetMapPositionConfigByPositionId(singleMap.position_id, ecoCfg.position[2], ecoCfg.position[1])
    if not position or not next(position) then
        -- 做错误提示
		if isMercenary then
			position = Vec3.zero
		else
        	return
		end
    end

    local mark = {}
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, mapId)
    mark.canMove = jumpCfg.can_move
    mark.position = position
    mark.map = mapId
    mark.name = jumpCfg.name ~= "" and jumpCfg.name or ecoCfg.name
    mark.posX = posX
    mark.posY = posY
    mark.type = FightEnum.MapMarkType.Ecosystem
    mark.areaBlock = areaBlock
    mark.jumpCfg = jumpCfg
    mark.icon = jumpCfg.icon
    mark.ecoCfg = ecoCfg

    self:AddMark(mark)

    return mark.instanceId
end

function WorldMapCtrl:AddEnemyMark(instanceId)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    if not entity or not entity.tagComponent or not entity.tagComponent:IsMonster() then
        return
    end

    local mark = {}
    local position = entity.transformComponent:GetPosition()
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, self.mapId)

    mark.canMove = true
    mark.position = position
    mark.map = self.mapId
    mark.posX = posX
    mark.posY = posY
    mark.type = FightEnum.MapMarkType.LevelEnemy
    mark.areaBlock = areaBlock
    mark.entityInstanceId = instanceId

    self:AddMark(mark)
    return mark.instanceId
end


function WorldMapCtrl:OnUpdateRoadPath(drawInstance, mapNavPathInstanceId)
    if self.mapId ~= 10020005 then
        return
    end
    local posList = self:GetCurDrawPointUI(drawInstance, mapNavPathInstanceId)
    local position = posList[1] or Vec3.New(0,0,0)
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, 10020005)

    if not self.NavRoadDrawId2Marks[mapNavPathInstanceId] then
        self.NavRoadDrawId2Marks[mapNavPathInstanceId] = {}
    end

    local mark
    local markInstanceId = self.NavRoadDrawId2Marks[mapNavPathInstanceId][drawInstance]
    if not markInstanceId then
        mark = {}
        mark.map = 10020005
        mark.showScale = 1
        mark.type = FightEnum.MapMarkType.RoadPath
        mark.drawInstance = drawInstance
        mark.mapNavPathInstanceId = mapNavPathInstanceId
		mark.areaBlock = areaBlock
    else
        mark = self.marks[markInstanceId]
    end
    mark.position = position
    mark.posX = posX
    mark.posY = posY
    
    if not markInstanceId then
        self.NavRoadDrawId2Marks[mapNavPathInstanceId][drawInstance] = self:AddMark(mark)
    else
        EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, markInstanceId)
    end
end

function WorldMapCtrl:OnUpdateNavMeshPath(drawInstance, mapNavPathInstanceId)
    
    local posList = Fight.Instance.mapNavPathManager:GetCurNavMeshPoint(drawInstance, mapNavPathInstanceId)
    local position = posList[1] or Vec3.New(0,0,0)
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, self.mapId)
    
    if not self.NavMeshId2Marks[mapNavPathInstanceId] then
        self.NavMeshId2Marks[mapNavPathInstanceId] = {}
    end
    
    local mark
    local markInstanceId = self.NavMeshId2Marks[mapNavPathInstanceId][drawInstance]
    if not markInstanceId then
        mark = {}
        mark.map = self.mapId
        mark.showScale = 1
        mark.type = FightEnum.MapMarkType.NavMeshPath
        mark.drawInstance = drawInstance
        mark.mapNavPathInstanceId = mapNavPathInstanceId
        mark.areaBlock = areaBlock
    else
        mark = self.marks[markInstanceId]
    end
    mark.position = position
    mark.posX = posX
    mark.posY = posY

    if not markInstanceId then
        self.NavMeshId2Marks[mapNavPathInstanceId][drawInstance] = self:AddMark(mark)
    else
        EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, markInstanceId)
    end
end

function WorldMapCtrl:OnRemoveRoadPath(drawInstance, mapNavPathInstanceId)
    if not self.NavRoadDrawId2Marks[mapNavPathInstanceId] then
        return
    end
    local markInstance = self.NavRoadDrawId2Marks[mapNavPathInstanceId][drawInstance]
    if markInstance then
        self:RemoveMapMark(markInstance)
        self.NavRoadDrawId2Marks[mapNavPathInstanceId][drawInstance] = nil
    end
end

function WorldMapCtrl:OnRemoveNavMeshPath(drawInstance, mapNavPathInstanceId)
    if not self.NavMeshId2Marks[mapNavPathInstanceId] then
        return
    end
    local markInstance = self.NavMeshId2Marks[mapNavPathInstanceId][drawInstance]
    if markInstance then
        self:RemoveMapMark(markInstance)
        self.NavMeshId2Marks[mapNavPathInstanceId][drawInstance] = nil
    end
end

--移除寻路线时，移除掉索引
function WorldMapCtrl:OnRemoveNavDrawPath(drawId)
    if not self.NavDrawId2TraceMarks[drawId] then
        return
    end
    local markInstance = self.NavDrawId2TraceMarks[drawId]
    
    if self.TargetPointer2NavDrawId[markInstance] then
        if Fight.Instance and Fight.Instance.clientFight.fightGuidePointerManager then
            Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.TargetPointer2NavDrawId[markInstance])
        end
        self.TargetPointer2NavDrawId[markInstance] = nil
    end
    
    self.TargetMarks2NavDrawId[markInstance] = nil
    self.TargetPointer2NavDrawId[markInstance] = nil
    self.NavDrawId2TraceMarks[drawId] = nil
end

function WorldMapCtrl:OnPlayerUpdate()
    if not self.player then
        self.player = Fight.Instance.playerManager:GetPlayer()
    end

    self.curCtrlEntity = self.player:GetCtrlEntityObject()
end

function WorldMapCtrl:OnEntityRemove(instanceId, ecoId)
    if not ecoId or not self.marksBindEcoId[ecoId] then
        return
    end
    
    self:RemoveMapMark(self.marksBindEcoId[ecoId])
end

function WorldMapCtrl:OnMailingNpcRemove(mailingId)
    if not mailingId or not self.jumpParamIdToEcoId[mailingId] then
        return
    end
    
    --如果已经激活且兑换了的话移除掉这个mark
    local mailingState = mod.MailingCtrl:CheckMailingState(mailingId, FightEnum.MailingState.Finished)
    if mailingState then
        self:OnEntityHitEnd({id = self.jumpParamIdToEcoId[mailingId]})
        mod.WorldMapTipCtrl:UpdateNpcMailing(mailingId)
        self.jumpParamIdToEcoId[mailingId] = nil
    end
end

function WorldMapCtrl:OnEntityHitEnd(data)
    local ecoId = data.id
    
    if not self.marksBindEcoId[ecoId] then
        return 
    end
    
    --非传送点才removeMark
    local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
    if ecoCfg.is_transport then
        return
    end
    
    self:RemoveMapMark(self.marksBindEcoId[ecoId])
end

function WorldMapCtrl:OnEnterInRoomArea(instanceId, name)
    if not next(self.traceMarks) or not Config.InroomPositionId then
        return
    end

    local roomId = Config.InroomPositionId[name]
    if not roomId then
        return
    end

    local config = MapPositionConfig.GetInRoomPosition(roomId)
    if not config then
        return
    end

    local checkPoints = {}
    for k, v in pairs(config) do
        table.insert(checkPoints, v)
    end

    if not self.curCtrlEntity then
        self.enterCache[instanceId] = true
        return
    end

    if self.curCtrlEntity.instanceId ~= instanceId then
        return
    end

    local setting = { hideOnSee = false, radius = radius }
	local extraSetting = { guideType = guideType }
    local mark
    self.isInRoom = true
    for k, v in pairs(self.traceMarks) do
        mark = self.marks[k]
        if not mark then
            goto continue
        end

        local traceInfo = FightEnum.MapMarkTraceInfo[mark.type]
        setting.radius = mark.radius or 50
        extraSetting.guideType = traceInfo and traceInfo.guideType or FightEnum.GuideType.Custom
        if self.TargetPointer2NavDrawId[k] then
            Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.TargetPointer2NavDrawId[k])
            self.TargetPointer2NavDrawId[k] = nil
        end

        self.targetPointerWithNav2NavDrawId[k] = Fight.Instance.clientFight.fightGuidePointerManager:AddGuidePositionWithNav(mark.position, setting, extraSetting, checkPoints, 2)
        ::continue::
    end
end

function WorldMapCtrl:OnExitInRoomArea(instanceId, name)
    if not next(self.traceMarks) then
        return
    end

    if not self.curCtrlEntity then
        self.enterCache[instanceId] = true
        return
    end

    if self.curCtrlEntity.instanceId ~= instanceId then
        return
    end

    self.isInRoom = false
    for k, v in pairs(self.traceMarks) do
        if self.targetPointerWithNav2NavDrawId[k] then
            Fight.Instance.clientFight.fightGuidePointerManager:RemoveNavGuide(self.TargetPointer2NavDrawId[k])
            self.targetPointerWithNav2NavDrawId[k] = nil
        end

        self:AddTraceGuideAndPath(k)
    end
end

function WorldMapCtrl:AddEventMark(eventCfg, jumpCfg, mapId, isMercenary)
    local singleMap = (mapId and mapId ~= self.mapId) and MapSceneConfig[mapId] or self.mapCfg
    local position = self:GetMapPositionConfigByPositionId(singleMap.position_id, eventCfg.position[2], eventCfg.position[1])
    if not position or not next(position) then
        -- 做错误提示
        if isMercenary then
            position = Vec3.zero
        else
            return
        end
    end

    local mark = {}
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, mapId)
    mark.canMove = jumpCfg.can_move
    mark.position = position
    mark.showScale = 1
    mark.eventId = eventCfg.event
    mark.map = mapId
    mark.name = eventCfg.name or ""
    mark.icon = jumpCfg.icon
    mark.posX = posX
    mark.posY = posY
    mark.type = FightEnum.MapMarkType.Event
    mark.areaBlock = areaBlock
    mark.jumpCfg = jumpCfg
    --mark.ecoCfg = ecoCfg

    self:AddMark(mark)

    return mark.instanceId
end

-- 随机事件，按照生态加载
function WorldMapCtrl:AddLevelEventMark(levelEventCfg, jumpCfg, mapId, isMercenary)
    local singleMap = (mapId and mapId ~= self.mapId) and MapSceneConfig[mapId] or self.mapCfg
    
    local position = self:GetMapPositionConfigByPositionId(singleMap.position_id, levelEventCfg.positing[2], levelEventCfg.positing[1])

    if not position or not next(position) then
        -- 做错误提示
        if isMercenary then
            position = Vec3.zero
        else
            return
        end
    end

    local mark = {}
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, mapId)
    mark.canMove = jumpCfg.can_move
    mark.position = position
    mark.showScale = 1
    mark.map = mapId
    mark.name = jumpCfg.name ~= "" and jumpCfg.name or ""
    mark.icon = jumpCfg.icon
    mark.levelEventId = levelEventCfg.id
    mark.posX = posX
    mark.posY = posY
    mark.type = FightEnum.MapMarkType.LevelEvent
    mark.areaBlock = areaBlock
    mark.jumpCfg = jumpCfg
    --mark.ecoCfg = ecoCfg

    self:AddMark(mark)

    return mark.instanceId
end

function WorldMapCtrl:AddCanMoveMark(instanceId, icon, mapId,type,name)
    local singleMap = (mapId and mapId ~= self.mapId) and MapSceneConfig[mapId] or self.mapCfg

    local entity = BehaviorFunctions.GetEntity(instanceId)
    local position = entity.transformComponent.position
    local mark = {}
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, mapId)
    mark.canMove = true
    mark.position = position
    mark.showScale = 1
    mark.map = mapId
    mark.name = name or  ""
    mark.icon = icon
    mark.posX = posX
    mark.posY = posY
    mark.type = type
    mark.entityInstanceId = instanceId
    mark.areaBlock = areaBlock

    self:AddMark(mark)
    return mark.instanceId
end

-- 服务器 真的加到标记中
function WorldMapCtrl:AddCustomMark(position, mapId, customType, name, customId)
    local mark = {}
    mark.map = mapId
    mark.name = name and name or ""
    mark.position = position
    mark.type = FightEnum.MapMarkType.Custom
    mark.customType = customType
    mark.showScale = 2
    mark.icon = "Textures/Icon/Single/MapIcon/mark.png"

    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, mapId)
    mark.posX = posX
    mark.posY = posY
    mark.areaBlock = areaBlock
    mark.showDis = 100

    self:AddMark(mark)

    mark.customId = customId
    self.customMarkInstance[customId] = mark.instanceId

    return mark.instanceId
end

function WorldMapCtrl:AddTaskMark(subTaskInfo)
    if not subTaskInfo then
        return
    end

	local taskId = subTaskInfo.taskConfig.id
    local mark = {}
    local position
    if subTaskInfo.position then
        position = subTaskInfo.position
    elseif subTaskInfo.traceEcoId then
        mark.canMove = true
        position = BehaviorFunctions.GetEcoEntityPosition(subTaskInfo.traceEcoId)
    elseif subTaskInfo.entityInstanceId then
        mark.canMove = true
        position = BehaviorFunctions.GetPositionP(subTaskInfo.entityInstanceId)
    end

    mark.taskId = taskId
	mark.traceEcoId = subTaskInfo.traceEcoId
    mark.entityInstanceId = subTaskInfo.entityInstanceId

    mark.position = position
    mark.radius = subTaskInfo.radius
    mark.unloadDis = subTaskInfo.unloadDis
    mark.map = subTaskInfo.mapId
    mark.type = FightEnum.MapMarkType.Task
	
	local taskType = mod.TaskCtrl:GetTaskType(taskId)
    mark.icon = AssetConfig.GetTaskTypeIcon(taskType)
    mark.showScale = 1
    mark.inTrace = true

    local posX, posY, areaBlock = self:TransWorldPosToUIPos(mark.position.x, mark.position.z, mark.map)
    mark.posX = posX
    mark.posY = posY
    mark.areaBlock = areaBlock

    self:AddMark(mark)

    return mark.instanceId
end

function WorldMapCtrl:AddMercenaryMark(ecoId)
    if self.marksBindEcoId[ecoId] or not mod.MercenaryHuntCtrl:CheckAddMapMark(ecoId) then
        return
    end

    local mercenaryCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
    if not mercenaryCfg then
        return
    end

    if mercenaryCfg.jump_id then
        local jumpCfg = DataNpcSystemJump.Find[mercenaryCfg.jump_id]
        if not jumpCfg or not next(jumpCfg) then
            goto continue
        end

        if not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) or not jumpCfg.icon or jumpCfg.icon == '' then
            goto continue
        end

        -- 佣兵要特殊处理一下 要把标记绑定到对应的佣兵上
        local instanceId = self:AddEcoMark(mercenaryCfg, jumpCfg, self.mapId, true)
        self.marksBindEcoId[ecoId] = instanceId
        if not jumpCfg.is_show and not self.svrChangeStateJumpIds[mercenaryCfg.id] then
            self.defaultHideMarks[instanceId] = true
        end

        EventMgr.Instance:Fire(EventName.MercenaryMarkAdded, instanceId, ecoId)

        ::continue::
    end
end

--- 获取当前画线
---@param instanceId any
function WorldMapCtrl:GetCurDrawPointUI(instanceId, mapNavPathInstanceId)
    return Fight.Instance.mapNavPathManager:GetCurDrawPointUI(instanceId, mapNavPathInstanceId)
end

--- 获取当前画线
---@param instanceId any
function WorldMapCtrl:GetCurDrawPoint3D(instanceId, mapNavPathInstanceId)
    return Fight.Instance.mapNavPathManager:GetCurDrawPoint3D(instanceId, mapNavPathInstanceId)
end
--- 获取当前画线颜色
---@param instanceId any
function WorldMapCtrl:GetCurDrawPointColor(instanceId, mapNavPathInstanceId)
    return Fight.Instance.mapNavPathManager:GetCurDrawPointColor(instanceId, mapNavPathInstanceId)
end

function WorldMapCtrl:GetTraceMarks()
    return self.traceMarks
end

function WorldMapCtrl:GetMarkInTrace(instanceId)
    if not self.marks[instanceId] then
        return
    end

    return self.marks[instanceId].inTrace
end

-- TODO 改到Fight的MapManager里面去 （MapManager还没有）
function WorldMapCtrl:ChangeMarkTraceState(instanceId, state)
    if not self.marks[instanceId] then
        return
    end

    self.marks[instanceId].inTrace = state
    if state then
        
        local conflict = self:GetConflict(instanceId)
        
        self.traceMarks[instanceId] = true
        if conflict then
            self.traceMarks[conflict] = nil
            self.marks[conflict].inTrace = false
            EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, conflict)
            EventMgr.Instance:Fire(EventName.CancelMapMarkTrace, conflict)

            if self.TargetPointer2NavDrawId[conflict] then
                Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.TargetPointer2NavDrawId[conflict])
                self.TargetPointer2NavDrawId[conflict] = nil
            end
            
            if self.TargetMarks2NavDrawId[conflict] then
                BehaviorFunctions.UnloadRoadPath(self.TargetMarks2NavDrawId[conflict])
                self.TargetMarks2NavDrawId[conflict] = nil
            end
        end

        self:AddTraceGuideAndPath(instanceId)
    else
        self.traceMarks[instanceId] = nil
        EventMgr.Instance:Fire(EventName.CancelMapMarkTrace, instanceId)

        if self.TargetPointer2NavDrawId[instanceId] then
            Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.TargetPointer2NavDrawId[instanceId])
            self.TargetPointer2NavDrawId[instanceId] = nil
        end
        
        if self.TargetMarks2NavDrawId[instanceId] then
            BehaviorFunctions.UnloadRoadPath(self.TargetMarks2NavDrawId[instanceId])
            self.TargetMarks2NavDrawId[instanceId] = nil
        end
    end

    EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, instanceId)
end

function WorldMapCtrl:GetConflict(instanceId)
    --将追踪分为俩种类型: 地图追踪 、 任务追踪
    --俩种追踪可同时存在，但同类型只能有一个
    local conflict
    for markInstance, _ in pairs(self.traceMarks) do
        if not self.marks[markInstance] then
            goto continue
        end
        if self.marks[markInstance].type == FightEnum.MapMarkType.Task then
            if self.marks[markInstance].type == self.marks[instanceId].type then
                conflict = markInstance
            end
        else
            conflict = markInstance
        end

        if conflict then
            break
        end
        
        ::continue::
    end
    return conflict
end

--添加追踪线以及追踪图标
function WorldMapCtrl:AddTraceGuideAndPath(instanceId)
    if not self.marks[instanceId] or (self.marks[instanceId] and self.marks[instanceId].map ~= self.mapId) then
        return
    end

    local mark = self.marks[instanceId]
    local traceInfo = FightEnum.MapMarkTraceInfo[mark.type]
    local color = traceInfo and traceInfo.color or FightEnum.NavDrawColor.White

    if not self.TargetMarks2NavDrawId[instanceId] then
        local setting = { hideOnSee = false, radius = mark.radius and mark.radius or 50 }
        if mark.entityInstanceId then
            local entity = BehaviorFunctions.GetEntity(mark.entityInstanceId)
            local drawId = BehaviorFunctions.DrawRoadPath3(mark.entityInstanceId, mark.unloadDis, color)
            local guidePointer = Fight.Instance.clientFight.fightGuidePointerManager:AddGuideEntity(entity, setting, traceInfo and traceInfo.guideType or FightEnum.GuideType.SummonCar)
            self.TargetMarks2NavDrawId[instanceId] = drawId
            self.TargetPointer2NavDrawId[instanceId] = guidePointer
            self.NavDrawId2TraceMarks[drawId] = instanceId
        else
            local guideType = traceInfo and traceInfo.guideType or FightEnum.GuideType.Custom
            local extraSetting = { guideType = guideType, radius = 50, guideIcon = mark.icon }
            local guidePointer = Fight.Instance.clientFight.fightGuidePointerManager:AddGuidePosition(mark.position, nil, extraSetting)
            local drawId = BehaviorFunctions.DrawRoadPath2(mark.position, mark.unloadDis, color)
            self.TargetMarks2NavDrawId[instanceId] = drawId
            self.TargetPointer2NavDrawId[instanceId] = guidePointer
            self.NavDrawId2TraceMarks[drawId] = instanceId
        end
    end
end

function WorldMapCtrl:ChangeCustomMark(instanceId, name, customType)
    if not self.marks[instanceId] or self.marks[instanceId].type ~= FightEnum.MapMarkType.Custom then
        return
    end

    local mark = {}
    mark.type = customType and customType or self.marks[instanceId].customType
    mark.name = name and name or self.marks[instanceId].name
    mark.map_id = self.marks[instanceId].map
    mark.mark_id = self.marks[instanceId].customId
    mark.position = { pos_x = math.ceil(self.marks[instanceId].position.x * 10000), pos_y = 0, pos_z = math.ceil(self.marks[instanceId].position.z * 10000) }

    mod.WorldMapFacade:SendMsg("map_mark", mark)
end

-- 服务器修改标记数据
function WorldMapCtrl:RefreshCustomMark(data, position)
    local instanceId = self.customMarkInstance[data.mark_id]
    if not instanceId or not self.marks[instanceId] then
        return
    end

    self.marks[instanceId].name = data.name
    self.marks[instanceId].position = position

    if self.marks[instanceId].customType ~= data.type then
        self.marks[instanceId].customType = data.type
        self.marks[instanceId].icon = string.format("path", data.type)
        self.marks[instanceId].showScale = 1
    end

    EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, instanceId)
end

function WorldMapCtrl:UpdateCustomMark(data)
    local tempInstanceId = 0
    for i = 1, #data do
        local pos = Vec3.New(data[i].position.pos_x / 10000, data[i].position.pos_y / 10000, data[i].position.pos_z / 10000)
        if not self.customMarkInstance[data[i].mark_id] then
            self:AddCustomMark(pos, data[i].map_id, data[i].type, data[i].name, data[i].mark_id)
        else
            self:RefreshCustomMark(data[i], pos)
        end

        if self.customMarkInstanceId == 0 and tempInstanceId < data[i].mark_id then
            tempInstanceId = data[i].mark_id
        end
    end

    self.customMarkInstanceId = tempInstanceId ~= 0 and tempInstanceId or self.customMarkInstanceId
end

function WorldMapCtrl:RemoveMapMark(instanceId)
    if not self.marks[instanceId] then
        return
    end

    local type = self.marks[instanceId].type
    local areaBlock = self.marks[instanceId].areaBlock
    local map = self.marks[instanceId].map

    if self.marks[instanceId].type == FightEnum.MapMarkType.Custom then
        mod.WorldMapFacade:SendMsg("map_mark_remove", self.marks[instanceId].customId)
    elseif self.marks[instanceId].type == FightEnum.MapMarkType.Ecosystem then
        local ecoId = self.marks[instanceId].ecoCfg.id
        if self.marksBindEcoId[ecoId] then
            self.marksBindEcoId[ecoId] = nil
        end
       
        
    elseif self.marks[instanceId].type == FightEnum.MapMarkType.Event then
        if self.marksBindEvent[self.marks[instanceId].eventId] then
            self.marksBindEvent[self.marks[instanceId].eventId] = nil
        end
    elseif self.marks[instanceId].type == FightEnum.MapMarkType.LevelEvent then
        if self.marksLevelEvent[self.marks[instanceId].eventId] then
            self.marksLevelEvent[self.marks[instanceId].eventId] = nil
        end
    end

    if self.movingMarks[instanceId] then
        self.movingMarks[instanceId] = nil
    end

    -- todo 这个要只有生态才执行
    self.marks[instanceId] = nil
    self.markInstance[type][instanceId] = nil
    self.markBlock[map][areaBlock][instanceId] = nil
    self.defaultHideMarks[instanceId] = nil
    self.hideMarks[instanceId] = nil
    
    if self.TargetPointer2NavDrawId[instanceId] then
		if Fight.Instance and Fight.Instance.clientFight and Fight.Instance.clientFight.fightGuidePointerManager then 
        	Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.TargetPointer2NavDrawId[instanceId])
		end
        self.TargetPointer2NavDrawId[instanceId] = nil
    end

    if self.TargetMarks2NavDrawId[instanceId] then
        BehaviorFunctions.UnloadRoadPath(self.TargetMarks2NavDrawId[instanceId])
        self.TargetMarks2NavDrawId[instanceId] = nil
    end

    EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Remove, instanceId)
end

function WorldMapCtrl:RemoveCustomMark(customId)
    if not self.customMarkInstance[customId] then
        return
    end

    self:RemoveMapMark(self.customMarkInstance[customId])
    self.customMarkInstance[customId] = nil
end

function WorldMapCtrl:RemoveEventMark(eventId)
    if not self.marksBindEvent[eventId] then
        return
    end

    self:RemoveMapMark(self.marksBindEvent[eventId])
    self.marksBindEvent[eventId] = nil
end

function WorldMapCtrl:RemoveLevelEventMark(eventId)
    if not self.marksLevelEvent[eventId] then
        return
    end

    self:RemoveMapMark(self.marksLevelEvent[eventId])
    self.marksLevelEvent[eventId] = nil
end

function WorldMapCtrl:GetLevelEventMark(eventId)
    if not self.marksLevelEvent[eventId] then
        return
    end
    
    return self.marksLevelEvent[eventId]
end

function WorldMapCtrl:ChangeEcosystemMark(mapId, ecosystemId, jumpId)
    local lastInstanceId = self.marksBindEcoId[ecosystemId]
    if lastInstanceId then
        self:RemoveMapMark(lastInstanceId)
    end

    local jumpCfg
    local ecosystemCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecosystemId)
    if jumpId then
        jumpCfg = DataNpcSystemJump.Find[jumpId]
        if not jumpCfg or jumpCfg == "" or not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
            return
        end
    elseif ecosystemCfg.jump_system_id and next(ecosystemCfg.jump_system_id) then
        for k, v in ipairs(ecosystemCfg.jump_system_id) do
            jumpCfg = DataNpcSystemJump.Find[v]
            if jumpCfg and jumpCfg ~= "" and Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
                break
            end
        end
    end

    if not jumpCfg or not next(jumpCfg) then
        return
    end

    local instanceId = self:AddEcoMark(ecosystemCfg, jumpCfg, mapId)
    self.marksBindEcoId[ecosystemId] = instanceId
    if not jumpCfg.is_show and not self.svrChangeStateJumpIds[ecosystemId] then
        self.defaultHideMarks[instanceId] = true
    end
end

function WorldMapCtrl:TransWorldPosToUIPos(posX, posZ, map)
    local isCurMap = not map or map == self.mapId
    local singleMap = isCurMap and self.mapCfg or MapSceneConfig[map]
    local uiSize = isCurMap and self:GetUISize(self.mapId) or self:GetUISize(map)
    local anchorPosition = self.anchorPosition
    if not isCurMap then
        anchorPosition = self:GetMapPositionConfigByPositionId(singleMap.position_id, singleMap.anchor_pos[2], singleMap.anchor_pos[1])
        if not anchorPosition or not next(anchorPosition) then
            return
        end
    end



    local anchorPosX = anchorPosition.x
    local anchorPosZ = anchorPosition.z

    local mapConfig = MapConfig[singleMap.map_id]

    local mapWidth = mapConfig.width
    local mapLength = mapConfig.length

    local uiWidth = uiSize.widthScale * (posX - anchorPosX)
    local uiHeight = uiSize.lengthScale * (posZ - anchorPosZ)
    local areaBlock = math.ceil(uiWidth / mapWidth) + math.floor(uiHeight / mapLength)

    return uiWidth, uiHeight, areaBlock
end

function WorldMapCtrl:TransUIPosToWorldPos(posX, posZ, map)
    local isCurMap = not map or map == self.mapId
    local singleScene = isCurMap and self.mapCfg or MapSceneConfig[map]
    local uiSize = isCurMap and self:GetUISize(self.mapId) or self:GetUISize(map)
    local anchorPosition = self.anchorPosition
    if not isCurMap then
        anchorPosition = self:GetMapPositionConfigByPositionId(singleScene.position_id, singleScene.anchor_pos[2], singleScene.anchor_pos[1])
        if not anchorPosition or not next(anchorPosition) then
            return
        end
    end

    local worldPosX = posX / uiSize.widthScale + anchorPosition.x
    local worldPosZ = posZ / uiSize.lengthScale + anchorPosition.z

    local uiWidth = uiSize.widthScale * (posX - anchorPosition.x)
    local uiHeight = uiSize.lengthScale * (posZ - anchorPosition.z)

    local singleMap = MapConfig[singleScene.map_id]
    local areaBlock = math.ceil(uiWidth / singleMap.width) + math.floor(uiHeight / singleMap.length)

    return worldPosX, worldPosZ, areaBlock
end

function WorldMapCtrl:GetUISize(mapId)
    if self.uiMapSize[mapId] then
        return self.uiMapSize[mapId]
    end

    local singleMap = MapSceneConfig[mapId]
    if not singleMap or not next(singleMap) then
        return
    end
    local mapConfig = MapConfig[singleMap.map_id]

    local anchorPosition = self:GetMapPositionConfigByPositionId(singleMap.position_id, singleMap.anchor_pos[2], singleMap.anchor_pos[1])
    local endAnchorPos = self:GetMapPositionConfigByPositionId(singleMap.position_id, singleMap.anchor_pos[3], singleMap.anchor_pos[1])

    local worldWidth = endAnchorPos.x - anchorPosition.x
    local worldLength = endAnchorPos.z - anchorPosition.z
    local uiMapSize = {
        widthScale =  mapConfig.width / worldWidth,
        lengthScale = mapConfig.length / worldLength,
        widthBlock =  mapConfig.width / MAP_AREA_SIZE,
        lengthBlock = mapConfig.length / MAP_AREA_SIZE,
        areaBlock = (mapConfig.width / MAP_AREA_SIZE) * (mapConfig.length / MAP_AREA_SIZE),
    }

    self.uiMapSize[mapId] = uiMapSize
    return uiMapSize
end

function WorldMapCtrl:InitPlayerMark()
    local player = Fight.Instance.playerManager:GetPlayer()
	local position = player:GetCtrlEntityObject().transformComponent:GetPosition()
    local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, self.mapId)
    local mark = {}
    mark.icon = "Textures/Icon/Single/MapIcon/player.png"
    mark.map = self.mapId
    mark.areaBlock = areaBlock
    mark.posX = posX
    mark.posY = posY
    mark.type = FightEnum.MapMarkType.Player
    mark.inTrace = true
    mark.showScale = 1
    mark.isPlayer = true

    if self.playerMark then
        self:RemoveMapMark(self.playerMark)
    end
    self.playerMark = self:AddMark(mark)
end

function WorldMapCtrl:UpdateMapMarkDefaultShow(data)
    for _, v in ipairs(data.show_list) do
        if not self.svrChangeStateJumpIds[v] then
            self.svrChangeStateJumpIds[v] = true
        end

        if self.waitSvrList[v] then
            self.waitSvrList[v] = nil
        end
        EventMgr.Instance:Fire(EventName.MapMarkDefaultShow, v)
    end

    if self.initJumpIds then
        self.initJumpIds = false
        return
    end

    for instanceId, _ in pairs(self.defaultHideMarks) do
        local mark = self.marks[instanceId]
        if self.svrChangeStateJumpIds[mark.ecoCfg.id] then
            self.defaultHideMarks[instanceId] = nil

            -- 因为原来是没有的mark 所以是新加
            EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Add, instanceId)
        end
    end
end

function WorldMapCtrl:GetMapConfig(mapId)
    if MapSceneConfig[mapId] then
        if MapSceneConfig[mapId].map_id and MapSceneConfig[mapId].map_id ~= 0 then
            return MapSceneConfig[mapId], MapConfig[MapSceneConfig[mapId].map_id]
        else
            return MapSceneConfig[mapId]
        end
    else
        return nil
    end
end

function WorldMapCtrl:GetMark(instanceId)
    return self.marks[instanceId]
end

function WorldMapCtrl:GetMapMark(mapId)
    if not self.markBlock then
        return
    end

    return self.markBlock[mapId]
end

function WorldMapCtrl:GetMapAreaMark(mapId, areaBlock)
    if not self.markBlock or not self.markBlock[mapId] then
        return
    end

    return self.markBlock[mapId][areaBlock]
end

function WorldMapCtrl:GetPlayerMark()
    return self.playerMark
end

function WorldMapCtrl:GetEcosystemMark(ecosystemId)
    local instanceId = self.marksBindEcoId[ecosystemId]
    if not instanceId then
        return
    end

    return self.marks[instanceId]
end

function WorldMapCtrl:TransportPointActive(ecoId)
    if not self.marksBindEcoId[ecoId] then
        return
    end

    local instanceId = self.marksBindEcoId[ecoId]
    local mark = self.marks[instanceId]
    if mark.inTrace then
        self:ChangeMarkTraceState(instanceId, false)
    else
        EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, instanceId)
    end
end

function WorldMapCtrl:CheckMarkIsHide(instanceId)
    return self.defaultHideMarks[instanceId] or self.hideMarks[instanceId]
end

local DuplicateConfig = Config.DataDuplicate.data_duplicate_level
function WorldMapCtrl:GetMapPositionConfig(levelId, posName, belongId)
    if not DuplicateConfig[levelId] then
        return
    end

    return self:GetMapPositionConfigByPositionId(DuplicateConfig[levelId].position_id, posName, belongId)
end

function WorldMapCtrl:GetMapPositionConfigByPositionId(positionId, posName, belongId)
    if not posName or not positionId then
        return
    end

    local config = MapPositionConfig.GetMapPositionData(positionId)
    if not config or not next(config) then
        LogError("position config dont find")
        return
    end

    if not belongId and not config[posName] then
        LogError("找不到对应配置位置,尝试重新提取位置:belongId is nil, posName = "..posName)
        return
    elseif belongId ~= "" and belongId and not config[belongId] then
        LogError("找不到对应配置位置,尝试重新提取位置:belongId = "..belongId)
        return
    end

    return config[posName] and config[posName] or config[belongId][posName]
end

function WorldMapCtrl:SendMapTransport(positionId, ecoId)
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup and not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
        return
    end

    local markCfg = Config.DataMap.data_map_transport[ecoId]
    local localPos = self:GetMapPositionConfigByPositionId(positionId, markCfg.position[2], markCfg.position[1])
    if not localPos or not next(localPos) then
        return
    end

    local pos = { pos_x = math.floor(localPos.x * 10000), pos_y = math.floor(localPos.y * 10000), pos_z = math.floor(localPos.z * 10000) }
    local rot = Quat.New(localPos.rotX, localPos.rotY, localPos.rotZ, localPos.rotW):ToEulerAngles()
    local rotate = { pos_x = math.floor(rot.x * 10000), pos_y = math.floor(rot.y * 10000), pos_z = math.floor(rot.z * 10000) }
    mod.WorldMapFacade:SendMsg("map_to_transport_point", ecoId, pos, rotate)
    entity.rotateComponent:SetRotation(Quat.Euler(Vec3.New(0, markCfg.rot_y, 0)))
end

function WorldMapCtrl:SendCustomMapMark(position, customType, name, map)
    self.customMarkInstanceId = self.customMarkInstanceId + 1
    local posX, posZ = mod.WorldMapCtrl:TransUIPosToWorldPos(position.x, position.y, map)
    --y轴需要往下打射线，最顶上的坐标
    local _x, newy, _z = CustomUnityUtils.RaycastRefPosVal(position.x, 1000, position.y, position.x, 0, position.y, FightEnum.LayerBit.Default | FightEnum.LayerBit.Terrain)
    local svrPos = { pos_x = math.ceil(posX * 10000), pos_y = math.ceil(newy * 10000), pos_z = math.ceil(posZ * 10000) }
    local map_mark = { mark_id = self.customMarkInstanceId, type = customType, name = name, map_id = map, position = svrPos }

    mod.WorldMapFacade:SendMsg("map_mark", map_mark)
end

-- mod.WorldMapCtrl:SendMapMarkActive({4002020001})
function WorldMapCtrl:SendMapMarkActive(ids)
    mod.WorldMapFacade:SendMsg("map_system_jump", ids)
end

function WorldMapCtrl:GetCurMap()
    return self.mapId
end