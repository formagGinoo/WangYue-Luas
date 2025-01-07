---@class MapAreaManager
MapAreaManager = BaseClass("MapAreaManager")

local DataArea = Config.DataMap.data_map_area
local DataBlockArea = Config.DataMap.data_map_block_area
local DataSmallArea = Config.DataMap.data_map_small_area
local DataBigArea = Config.DataMap.data_map_big_area
local DataTransport = Config.DataMap.data_map_transport

function MapAreaManager:__init(fight)
    self.fight = fight
    self.curEntity = nil
    self.curEntityPos = nil
    self.lastEntityPos = nil

    self.areaMaskCfg = {}
    self.lockMidArea = {}
    self.unLockMidArea = {}

    self.blockArea = {}
    self.blockCondition = {}

    EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("OnCurEntityChange"))
end

function MapAreaManager:StartFight()
    self:InitBlockArea()
	self:InitAreaState()
end

function MapAreaManager:LowUpdate()
    if not self.curEntity then
        return
    end

    local mapId = self.fight:GetFightMap()
    local mAreaId, sAreaId
    local position = self.curEntity.transformComponent:GetPosition()
    self.lastEntityPos = self.curEntityPos
    self.curEntityPos = position

    self:UpdateLevelArea()

    for k, v in pairs(DataArea) do
        if BehaviorFunctions.CheckPointInArea(position, v.id, FightEnum.AreaType.Mid, mapId) then
            mAreaId = v.id
            break
        end
    end

    for k, v in pairs(DataSmallArea) do
        if BehaviorFunctions.CheckPointInArea(position, v.id, FightEnum.AreaType.Small, mapId) then
            sAreaId = v.id
            break
        end
    end

    if mAreaId ~= self.curEntity.values["mAreaId"] then
        if not mAreaId then
            EventMgr.Instance:Fire(EventName.ExitMapArea, FightEnum.AreaType.Mid, self.curEntity.values["mAreaId"], mapId)
        else
            EventMgr.Instance:Fire(EventName.EnterMapArea, FightEnum.AreaType.Mid, mAreaId, mapId)
        end
        self.curEntity.values["mAreaId"] = mAreaId
    end

    if sAreaId ~= self.curEntity.values["sAreaId"] then
        if not sAreaId then
            EventMgr.Instance:Fire(EventName.ExitMapArea, FightEnum.AreaType.Small, self.curEntity.values["sAreaId"], mapId)
        else
            EventMgr.Instance:Fire(EventName.EnterMapArea, FightEnum.AreaType.Small, sAreaId, mapId)
        end
        self.curEntity.values["sAreaId"] = sAreaId
    end

    for k, v in pairs(self.blockArea) do
        local isIn = BehaviorFunctions.CheckPointInArea(position, v.id, FightEnum.AreaType.Block, mapId)
		if isIn == nil then
			goto continue
		end

        if (isIn and v.block_type == FightEnum.BlockType.WhiteHole) or (not isIn and v.block_type == FightEnum.BlockType.BlackHole) then
            if self.lastEntityPos and next(self.lastEntityPos) then
                mod.WorldCtrl:InMapTransport(self.lastEntityPos)
            end
        end

		::continue::
    end
end

function MapAreaManager:InitAreaState()
    self.unLockMidArea = {}
    self.lockMidArea = {}

    for k, v in pairs(DataTransport) do
        if v.mid_area == 0 then
            goto continue
        end

        local ecoCfg = self.fight.entityManager:GetEntityConfigByID(v.id)
        if not ecoCfg then
            LogError("找不到传送点配置 , ecoId = "..v.id)
            goto continue
        end
        local key = UtilsBase.GetDoubleKeys(v.mid_area, ecoCfg.map_id, 32)
        local areaData = DataArea[key]
        if mod.WorldCtrl:CheckIsTransportPointActive(k) then
            self.unLockMidArea[v.mid_area] = areaData
        else
            self.lockMidArea[v.mid_area] = areaData
        end

        ::continue::
    end

    EventMgr.Instance:Fire(EventName.MapAreaUpdate)
end

function MapAreaManager:InitBlockArea()
    for k, v in pairs(DataBlockArea) do
        if not Fight.Instance.conditionManager:CheckConditionByConfig(v.condition) then
            self.blockArea[v.id] = v
            if not self.blockCondition[v.condition] then
                self.blockCondition[v.condition] = {}
            end
            table.insert(self.blockCondition[v.condition], v.id)
            self.fight.conditionManager:AddListener(v.condition, self:ToFunc("BlockConditionUpdate"))
        end
    end
end

function MapAreaManager:BlockConditionUpdate(conditionId)
    if not self.blockCondition[conditionId] then
        return
    end

    for k, v in pairs(self.blockArea) do
        if v.condition == conditionId then
            self.blockArea[k] = nil
        end
    end

    EventMgr.Instance:Fire(EventName.BlockAreaUpdate)
end

function MapAreaManager:GetLockMidArea()
   return self.lockMidArea
end

function MapAreaManager:GetUnlockMidArea()
   return self.unLockMidArea
end

-- 添加condition更新的通知，这里可以修改成self.blockArea
function MapAreaManager:GetBlockArea()
    return self.blockArea
end

function MapAreaManager:GetAreaConfig(areaId, mapId)
    local key = UtilsBase.GetDoubleKeys(areaId, mapId, 32)
    if DataArea[key] then
        return DataArea[key]
    elseif DataBigArea[key] then
        return DataBigArea[key]
    elseif DataSmallArea[key] then
        return DataSmallArea[key]
    elseif DataBlockArea[key] then
        return DataBlockArea[key]
    end
end

function MapAreaManager:GetAreaMaskPos(areaId, mapId)
    local areaMaskCfg
    if self.areaMaskCfg[mapId] then
        areaMaskCfg = self.areaMaskCfg[mapId]
    else
        local key = string.format("AreaInfo%s", mapId)
        areaMaskCfg = Config[key]
        if not areaMaskCfg then
            return
        end

        self.areaMaskCfg[mapId] = areaMaskCfg
    end

    if not areaMaskCfg or not areaMaskCfg[areaId] then
        return
    end

    return areaMaskCfg[areaId].positionX, areaMaskCfg[areaId].positionY
end

function MapAreaManager:OnCurEntityChange()
    if not self.fight or not self.fight.playerManager then
        return
    end

    self.curEntity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
end

function MapAreaManager:GetAreaInfoByPosition(position, mapId)
    local areaInfo, areaType, bigAreaInfo
    for k, v in pairs(DataSmallArea) do
        if mapId ~= v.map_id then
            goto continue
        end

        if BehaviorFunctions.CheckPointInArea(position, v.id, FightEnum.AreaType.Small, v.map_id) then
            areaInfo = v
            areaType = FightEnum.AreaType.Small
            break
        end

        ::continue::
    end

    for k, v in pairs(DataArea) do
        if mapId ~= v.map_id then
            goto continue
        end

        if BehaviorFunctions.CheckPointInArea(position, v.id, FightEnum.AreaType.Mid, v.map_id) then
            local key = UtilsBase.GetDoubleKeys(v.parent, v.map_id, 32)
            bigAreaInfo = DataBigArea[key]
            if areaInfo then
                break
            else
                areaInfo = v
                areaType = FightEnum.AreaType.Mid
            end
        end

        ::continue::
    end

    return areaInfo, areaType, bigAreaInfo
end

function MapAreaManager:GetAreaCenter_All(mapId)
    local mCenter = {}
    local sCenter = {}
    for k, v in pairs(DataArea) do
        if mapId ~= v.map_id then
            goto continue
        end
        local edgeInfo = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Mid, v.id, mapId)
        local x = (edgeInfo.maxX + edgeInfo.minX) / 2
        local y = (edgeInfo.maxY + edgeInfo.minY) / 2

        mCenter[v.id] = {x = x, y = y}
        ::continue::
    end

    for k, v in pairs(DataSmallArea) do
        if mapId ~= v.map_id then
            goto continue
        end
        local edgeInfo = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Small, v.id, mapId)
        local x = (edgeInfo.maxX + edgeInfo.minX) / 2
        local y = (edgeInfo.maxY + edgeInfo.minY) / 2

        sCenter[v.id] = {x = x, y = y}
        ::continue::
    end

    return mCenter, sCenter
end


function MapAreaManager:GetArea_All(mapId)
    local mCenter = {}
    for k, v in pairs(DataArea) do
        if mapId ~= v.map_id then
            goto continue
        end
        
        local boundsInfo = MapPositionConfig.GetAreaBoundsInfo(FightEnum.AreaType.Mid, v.id, mapId)
        mCenter[v.id] = boundsInfo
        
        ::continue::
    end
    
    return mCenter
end

function MapAreaManager:GetAreaCenterById()

end

function MapAreaManager:AddLevelArea(levelId)
    local levelArea = self.fight.levelManager:GetLevelOccupancyData(levelId)
    if not levelArea then
        return
    end

    self.levelAreaList = self.levelAreaList or {}
    self.levelAreaList[levelId] = levelArea
end

function MapAreaManager:RemoveLevelArea(levelId)
    if not self.levelAreaList or not self.levelAreaList[levelId] then
        return
    end

    self.levelAreaList[levelId] = nil
end

function MapAreaManager:UpdateLevelArea()
    if not self.levelAreaList or not next(self.levelAreaList) then
        return
    end

    local levelId
    for k, v in pairs(self.levelAreaList) do
        if BehaviorFunctions.IsPointInsidePolygon(self.curEntityPos, v) then
            levelId = k
        end
    end

    if levelId ~= self.curEntity.values["levelAreaId"] then
        if not levelId then
            EventMgr.Instance:Fire(EventName.ExitMapArea, FightEnum.AreaType.Level, self.curEntity.values["levelAreaId"], mapId)
        else
            EventMgr.Instance:Fire(EventName.EnterMapArea, FightEnum.AreaType.Level, levelId, mapId)
        end
        self.curEntity.values["levelAreaId"] = levelId
    end
end

function MapAreaManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("OnCurEntityChange"))
end