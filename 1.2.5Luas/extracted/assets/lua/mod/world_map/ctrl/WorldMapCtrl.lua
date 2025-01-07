---@class WorldMapCtrl : Controller
WorldMapCtrl = BaseClass("WorldMapCtrl", Controller)

local MAP_AREA_SIZE = 2048
local MapConfig = Config.DataMap.data_map

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
    self.defaultHideMarks = {}
    self.marksBindEcoId = {}
    self.svrChangeStateJumpIds = {}
    self.traceMarks = {}
    self.playerMark = nil
    self.initJumpIds = true

    self.waitSvrList = {}

    self.movingMarks = {}

    self.player = nil

    self.checkDone = {
        [FightEnum.CreateEntityType.Ecosystem] = false,
        [FightEnum.CreateEntityType.Npc] = false,
        [FightEnum.CreateEntityType.Mercenary] = false,
    }

    EventMgr.Instance:AddListener(EventName.EcosystemInitDone, self:ToFunc("OnWorldEntityInitDone"))
    EventMgr.Instance:AddListener(EventName.TransportPointActive, self:ToFunc("TransportPointActive"))
end

function WorldMapCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.EcosystemInitDone, self:ToFunc("OnWorldEntityInitDone"))
    EventMgr.Instance:RemoveListener(EventName.TransportPointActive, self:ToFunc("TransportPointActive"))
end

function WorldMapCtrl:SetLoginMapAndPos(mapId, pos)
    self.loginMapID = mapId
    self.loginMapPos = pos
end

function WorldMapCtrl:SetDuplicateInfo(duplicateId, levelId)
    self.duplicateId = duplicateId
    self.dupLevelId = levelId
end

function WorldMapCtrl:GetDuplicateInfo()
    return self.duplicateId, self.dupLevelId
end

function WorldMapCtrl:EnterMap(mapId, position, heroList)
    local map = self.loginMapID and self.loginMapID or mapId
    local pos = self.loginMapPos and self.loginMapPos or position
    if not self.mapId or self.mapId ~= map then
        EventMgr.Instance:Fire(EventName.EnterMap, mapId)
    end

    self.player = nil
    self.loginMapID = nil
    self.loginMapPos = nil
    self:SetCurMap(map)
    self:CreateFight(heroList, pos)
end

function WorldMapCtrl:CreateFight(heroList, enterPos)
	if not heroList then
		local curFormation = mod.FormationCtrl:GetCurFormationInfo()
		heroList = {}
		local index = 0
		for i = 1, #curFormation.roleList do
			if curFormation.roleList[i] ~= 0 then
				index = index + 1
				heroList[index] = curFormation.roleList[i]
			end
		end
	end

	local fightData = FightData.New()
	fightData:BuildFightData(heroList, self.mapId)
	if Fight.Instance then
		Network.Instance:SetStopRecv(true)
		Fight.Instance:Clear()
	end

	Fight.New()

	if self.debugDuplicate then
		Fight.Instance:SetDebugFormation(heroList)
		self.debugDuplicate = false
	end
	Fight.Instance:EnterFight(fightData:GetFightData(), enterPos)
end

function WorldMapCtrl:EnterDebugDuplicate(duplicateId, heroList)
	self.debugDuplicate = true

	self.duplicateId = duplicateId
	local duplicateConfig = Config.DataDuplicate.data_duplicate[duplicateId]
	self.dupLevelId = duplicateConfig.level_id

	mod.WorldMapCtrl:EnterMap(duplicateConfig.map_id, Vector3.zero, heroList)
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

    EventMgr.Instance:Fire(EventName.LeaveDuplicate)
	self.duplicateId = nil
	self.dupLevelId = nil
end

function WorldMapCtrl:AfterUpdate()
    if not Fight.Instance or mod.WorldMapCtrl:CheckIsDup() or not self.defaultHideMarks or not next(self.defaultHideMarks) then
        if not Fight.Instance and self.player then
            self.player = nil
        end
        return
    end

    if not self.player then
        self.player = Fight.Instance.playerManager:GetPlayer()
    end

    local position = self.player:GetCtrlEntityObject().transformComponent:GetPosition()
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

-- 小地图动态点位刷新
function WorldMapCtrl:LowUpdate()
    if not self.mapCfg or self.mapCfg.mini_map == "" then
        return
    end

    if not Fight.Instance or mod.WorldMapCtrl:CheckIsDup() or not self.movingMarks or not next(self.movingMarks) then
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

        local position
		local isNpc = Fight.Instance.entityManager.npcEntityManager:CheckEcoIdIsNpc(ecoId)
		local entity
		if isNpc then
			entity = BehaviorFunctions.GetNpcEntity(ecoId)
		else
			local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
			if instanceId then
				entity = BehaviorFunctions.GetEntity(instanceId)
			end
		end

        if not entity or not entity.transformComponent then
            position = BehaviorFunctions.GetEcoEntityBornPosition(ecoId)
        else
            position = entity.transformComponent:GetPosition()
        end

        local posX, posY, areaBlock = self:TransWorldPosToUIPos(position.x, position.z, self.mapId)
        self.marks[k].posX = posX
        self.marks[k].posY = posY
        self.marks[k].areaBlock = areaBlock
        EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, k)
    end
end

function WorldMapCtrl:ClearPlayer()
    self.player = nil
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
    self:InitWorldMap()
end

function WorldMapCtrl:SetCurMap(mapId)
    self.mapId = mapId
    self.mapCfg = MapConfig[mapId]
    if next(self.mapCfg.anchor_pos) then
        self.anchorPosition = self:GetMapPositionConfig(self.mapCfg.level_id, self.mapCfg.anchor_pos[2], self.mapCfg.anchor_pos[1])
    end
end

function WorldMapCtrl:InitWorldMap()
    self:LoadEcosystemMark()
    self:LoadNpcMark()
    self:LoadMercenaryMark()
end

function WorldMapCtrl:LoadEcosystemMark(mapId)
    local map = mapId and mapId or self.mapId
    local mapEntityCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEntityBornConfigByMap(map)
    if not mapEntityCfg then
        return
    end

    for _, v in pairs(mapEntityCfg) do
        if not self.marksBindEcoId[v] then
            local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(v)
            if ecoCfg.jump_system_id and next(ecoCfg.jump_system_id) then
                for k, id in ipairs(ecoCfg.jump_system_id) do
                    local jumpCfg = Config.DataNpcSystemJump.Find[id]
                    if not jumpCfg or not next(jumpCfg) then
                        goto continue
                    end

                    if not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) or not jumpCfg.icon then
                        goto continue
                    end

                    local instanceId = self:AddEcoMark(ecoCfg, jumpCfg, map)
                    self.marksBindEcoId[v] = instanceId
                    if not jumpCfg.is_show and not self.svrChangeStateJumpIds[ecoCfg.id] then
                        self.defaultHideMarks[instanceId] = true
                    end

                    ::continue::
                end
            end
        end
    end
end

function WorldMapCtrl:LoadNpcMark(mapId)
    local map = mapId and mapId or self.mapId
    local npcList = Fight.Instance.entityManager.npcEntityManager:GetNpcRecordList()
    if not npcList or not next(npcList) then
        return
    end

    for k, v in pairs(npcList) do
        if not self.marksBindEcoId[v] then
            local npcCfg = Fight.Instance.entityManager.npcEntityManager:GetNpcConfig(v)
            if npcCfg.map_id ~= map then
                goto continue
            end

            local jumpCfg
            local taskAcceptJumpId = mod.TaskCtrl:GetNpcAcceptJumpId(v)
            if taskAcceptJumpId then
                jumpCfg = Config.DataNpcSystemJump.Find[taskAcceptJumpId]
            elseif npcCfg.jump_system_id and next(npcCfg.jump_system_id) then
                for _, id in ipairs(npcCfg.jump_system_id) do
                    jumpCfg = Config.DataNpcSystemJump.Find[id]
                    if jumpCfg and jumpCfg.icon ~= "" and Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
                        break
                    end
                end
            end

            if not jumpCfg then
                goto continue
            end

            local instanceId = self:AddEcoMark(npcCfg, jumpCfg, map)
            self.marksBindEcoId[v] = instanceId
            if not jumpCfg.is_show and not self.svrChangeStateJumpIds[npcCfg.id] then
                self.defaultHideMarks[instanceId] = true
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

    EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Add, mark.instanceId)
end

function WorldMapCtrl:AddEcoMark(ecoCfg, jumpCfg, mapId)
    local singleMap = (mapId and mapId ~= self.mapId) and MapConfig[mapId] or self.mapCfg
    local position = self:GetMapPositionConfig(singleMap.level_id, ecoCfg.position[2], ecoCfg.position[1])
    if not position or not next(position) then
        -- 做错误提示
        return
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
    mark.ecoCfg = ecoCfg

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

    local taskConfig = subTaskInfo.taskConfig
    local mark = {}
    local singleMap = MapConfig[taskConfig.map_id]
    local position
    if subTaskInfo.position then
        position = self:GetMapPositionConfig(singleMap.level_id, subTaskInfo.position[2], subTaskInfo.position[1])
    elseif subTaskInfo.traceEcoId then
        mark.canMove = true
        position = BehaviorFunctions.GetEcoEntityBornPosition(subTaskInfo.traceEcoId)
    end

    mark.taskId = taskConfig.id
    mark.progressId = subTaskInfo.progress
	mark.traceEcoId = subTaskInfo.traceEcoId
    mark.position = position
    mark.radius = subTaskInfo.radius
    mark.map = taskConfig.map_id
    mark.type = FightEnum.MapMarkType.Task
    mark.icon = AssetConfig.GetTaskTypeIcon(taskConfig.type)
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
    if self.marksBindEcoId[ecoId] or not mod.MercenaryHuntCtrl:CheckMercenaryIsDiscover(ecoId) then
        return
    end

    local mercenaryCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
    if not mercenaryCfg then
        return
    end

    if mercenaryCfg.jump_id then
        local jumpCfg = Config.DataNpcSystemJump.Find[mercenaryCfg.jump_id]
        if not jumpCfg or not next(jumpCfg) then
            goto continue
        end

        if not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) or not jumpCfg.icon then
            goto continue
        end

        -- 佣兵要特殊处理一下 要把标记绑定到对应的佣兵上
        local instanceId = self:AddEcoMark(mercenaryCfg, jumpCfg, mercenaryCfg.map_id)
        self.marksBindEcoId[ecoId] = instanceId
        if not jumpCfg.is_show and not self.svrChangeStateJumpIds[mercenaryCfg.id] then
            self.defaultHideMarks[instanceId] = true
        end

        EventMgr.Instance:Fire(EventName.MercenaryMarkAdded, instanceId, ecoId)

        ::continue::
    end
end

function WorldMapCtrl:ChangeMarkTraceState(instanceId, state)
    if not self.marks[instanceId] then
        return
    end

    self.marks[instanceId].inTrace = state
    if state then
        local conflict
        for markInstance, _ in pairs(self.traceMarks) do
            if self.marks[markInstance].type == self.marks[instanceId].type then
                conflict = markInstance
                break
            end
        end

        self.traceMarks[instanceId] = true
        if conflict then
            self.traceMarks[conflict] = nil
            self.marks[conflict].inTrace = false
            EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, conflict)
            EventMgr.Instance:Fire(EventName.CancelMapMarkTrace, conflict)
        end
    else
        self.traceMarks[instanceId] = nil
        EventMgr.Instance:Fire(EventName.CancelMapMarkTrace, instanceId)
    end

    EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Refresh, instanceId)
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
    end

    if self.movingMarks[instanceId] then
        self.movingMarks[instanceId] = nil
    end

    self.marks[instanceId] = nil
    self.markInstance[type][instanceId] = nil
    self.markBlock[map][areaBlock][instanceId] = nil
    self.defaultHideMarks[instanceId] = nil

    EventMgr.Instance:Fire(EventName.MarkUpdate, WorldEnum.MarkOpera.Remove, instanceId)
end

function WorldMapCtrl:RemoveCustomMark(customId)
    if not self.customMarkInstance[customId] then
        return
    end

    self:RemoveMapMark(self.customMarkInstance[customId])
    self.customMarkInstance[customId] = nil
end

function WorldMapCtrl:ChangeEcosystemMark(mapId, ecosystemId, jumpId)
    local lastInstanceId = self.marksBindEcoId[ecosystemId]
    if lastInstanceId then
        self:RemoveMapMark(lastInstanceId)
    end

    local jumpCfg
    local ecosystemCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecosystemId)
    if jumpId then
        jumpCfg = Config.DataNpcSystemJump.Find[jumpId]
        if not jumpCfg or jumpCfg == "" or not Fight.Instance.conditionManager:CheckConditionByConfig(jumpCfg.condition) then
            return
        end
    elseif ecosystemCfg.jump_system_id and next(ecosystemCfg.jump_system_id) then
        for k, v in ipairs(ecosystemCfg.jump_system_id) do
            jumpCfg = Config.DataNpcSystemJump.Find[v]
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
    local singleMap = isCurMap and self.mapCfg or MapConfig[map]
    local uiSize = isCurMap and self:GetUISize(self.mapId) or self:GetUISize(map)
    local anchorPosition = self.anchorPosition
    if not isCurMap then
        anchorPosition = self:GetMapPositionConfig(singleMap.level_id, singleMap.anchor_pos[2], singleMap.anchor_pos[1])
        if not anchorPosition or not next(anchorPosition) then
            return
        end
    end

    local anchorPosX = anchorPosition.x
    local anchorPosZ = anchorPosition.z
    local mapWidth = singleMap.width
    local mapLength = singleMap.length

    local uiWidth = uiSize.widthScale * (posX - anchorPosX)
    local uiHeight = uiSize.lengthScale * (posZ - anchorPosZ)
    local areaBlock = math.ceil(uiWidth / mapWidth) + math.floor(uiHeight / mapLength)

    return uiWidth, uiHeight, areaBlock
end

function WorldMapCtrl:TransUIPosToWorldPos(posX, posZ, map)
    local isCurMap = not map or map == self.mapId
    local singleMap = isCurMap and self.mapCfg or MapConfig[map]
    local uiSize = isCurMap and self:GetUISize(self.mapId) or self:GetUISize(map)
    local anchorPosition = self.anchorPosition
    if not isCurMap then
        anchorPosition = self:GetMapPositionConfig(singleMap.level_id, singleMap.anchor_pos[2], singleMap.anchor_pos[1])
        if not anchorPosition or not next(anchorPosition) then
            return
        end
    end

    local worldPosX = posX / uiSize.widthScale + anchorPosition.x
    local worldPosZ = posZ / uiSize.lengthScale + anchorPosition.z

    local uiWidth = uiSize.widthScale * (posX - anchorPosition.x)
    local uiHeight = uiSize.lengthScale * (posZ - anchorPosition.z)
    local areaBlock = math.ceil(uiWidth / singleMap.width) + math.floor(uiHeight / singleMap.length)

    return worldPosX, worldPosZ, areaBlock
end

function WorldMapCtrl:GetUISize(mapId)
    if self.uiMapSize[mapId] then
        return self.uiMapSize[mapId]
    end

    local singleMap = MapConfig[mapId]
    if not singleMap or not next(singleMap) then
        return
    end

    local anchorPosition = self:GetMapPositionConfig(singleMap.level_id, singleMap.anchor_pos[2], singleMap.anchor_pos[1])
    local endAnchorPos = self:GetMapPositionConfig(singleMap.level_id, singleMap.anchor_pos[3], singleMap.anchor_pos[1])

    local worldWidth = endAnchorPos.x - anchorPosition.x
    local worldLength = endAnchorPos.z - anchorPosition.z
    local uiMapSize = {
        widthScale =  singleMap.width / worldWidth,
        lengthScale = singleMap.length / worldLength,
        widthBlock =  singleMap.width / MAP_AREA_SIZE,
        lengthBlock = singleMap.length / MAP_AREA_SIZE,
        areaBlock = (singleMap.width / MAP_AREA_SIZE) * (singleMap.length / MAP_AREA_SIZE),
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
    return MapConfig[mapId]
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
    return self.defaultHideMarks[instanceId]
end

local DuplicateConfig = Config.DataDuplicate.data_duplicate_level
function WorldMapCtrl:GetMapPositionConfig(levelId, posName, belongId)
    if not DuplicateConfig[levelId] then
        return
    end

    return self:GetMapPositionConfigByPositionId(DuplicateConfig[levelId].position_id, posName, belongId)
end

function WorldMapCtrl:GetMapPositionConfigByPositionId(positionId, posName, belongId)
    local config = MapPositionConfig.GetMapPositionData(positionId)
    if not config or not next(config) then
        LogError("position config dont find")
        return
    end

    if not belongId and not config[posName] then
        LogError("找不到对应配置位置,尝试重新提取位置:belongId is nil, posName = "..posName)
        return
    elseif belongId and not config[belongId] then
        LogError("找不到对应配置位置,尝试重新提取位置:belongId = "..belongId)
        return
    end

    return config[posName] and config[posName] or config[belongId][posName]
end

function WorldMapCtrl:SendMapTransport(levelId, ecoId)
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup and not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
        return
    end

    local markCfg = Config.DataMap.data_map_transport[ecoId]
    local localPos = self:GetMapPositionConfig(levelId, markCfg.position[2], markCfg.position[1])
    if not localPos or not next(localPos) then
        return
    end

    local pos = { pos_x = math.floor(localPos.x * 10000), pos_y = math.floor(localPos.y * 10000), pos_z = math.floor(localPos.z * 10000) }
    mod.WorldMapFacade:SendMsg("map_to_transport_point", ecoId, pos)
    entity.rotateComponent:SetRotation(Quat.Euler(Vec3.New(0, markCfg.rot_y, 0)))
end

function WorldMapCtrl:SendCustomMapMark(position, customType, name, map)
    self.customMarkInstanceId = self.customMarkInstanceId + 1
    local posX, posZ = mod.WorldMapCtrl:TransUIPosToWorldPos(position.x, position.y, map)
    local svrPos = { pos_x = math.ceil(posX * 10000), pos_y = 0, pos_z = math.ceil(posZ * 10000) }
    local map_mark = { mark_id = self.customMarkInstanceId, type = customType, name = name, map_id = map, position = svrPos }

    mod.WorldMapFacade:SendMsg("map_mark", map_mark)
end

-- mod.WorldMapCtrl:SendMapMarkActive({4002020001})
function WorldMapCtrl:SendMapMarkActive(ids)
    mod.WorldMapFacade:SendMsg("map_system_jump", ids)
end