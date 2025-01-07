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
    self.curEntityCheckPos = nil
    self.curEntityPos = nil
    self.lastEntityPos = nil

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

    local mAreaId, sAreaId
    local position = self.curEntity.transformComponent:GetPosition()
    self.lastEntityPos = self.curEntityPos
    self.curEntityPos = position
    self.curEntityCheckPos = { x = position.x, y = position.z }
    for k, v in pairs(DataArea) do
        if BehaviorFunctions.CheckPointInArea(self.curEntityCheckPos, v.id, FightEnum.AreaType.Mid) then
            mAreaId = v.id
            break
        end
    end

    for k, v in pairs(DataSmallArea) do
        if BehaviorFunctions.CheckPointInArea(self.curEntityCheckPos, v.id, FightEnum.AreaType.Small) then
            sAreaId = v.id
            break
        end
    end

    if mAreaId ~= self.curEntity.values["mAreaId"] then
        if not mAreaId then
            EventMgr.Instance:Fire(EventName.ExitMapArea, FightEnum.AreaType.Mid, self.curEntity.values["mAreaId"])
        else
            EventMgr.Instance:Fire(EventName.EnterMapArea, FightEnum.AreaType.Mid, mAreaId)
        end
        self.curEntity.values["mAreaId"] = mAreaId
    end

    if sAreaId ~= self.curEntity.values["sAreaId"] then
        if not sAreaId then
            EventMgr.Instance:Fire(EventName.ExitMapArea, FightEnum.AreaType.Small, self.curEntity.values["sAreaId"])
        else
            EventMgr.Instance:Fire(EventName.EnterMapArea, FightEnum.AreaType.Small, sAreaId)
        end
        self.curEntity.values["sAreaId"] = sAreaId
    end

    for k, v in pairs(self.blockArea) do
        local isIn = BehaviorFunctions.CheckPointInArea(self.curEntityCheckPos, v.id, FightEnum.AreaType.Block)
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

        local areaData = DataArea[v.mid_area]
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
            self.blockArea[k] = v
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

function MapAreaManager:GetAreaConfig(areaId)
    if DataArea[areaId] then
        return DataArea[areaId]
    elseif DataBigArea[areaId] then
        return DataBigArea[areaId]
    elseif DataSmallArea[areaId] then
        return DataSmallArea[areaId]
    elseif DataBlockArea[areaId] then
        return DataBlockArea[areaId]
    end
end

function MapAreaManager:OnCurEntityChange()
    if not self.fight or not self.fight.playerManager then
        return
    end

    self.curEntity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
end

function MapAreaManager:GetAreaInfoByPosition(position)
    local areaInfo, areaType, bigAreaInfo
    local checkPos = {x = position.x, y = position.z}
    for k, v in pairs(DataSmallArea) do
        if BehaviorFunctions.CheckPointInArea(checkPos, v.id, FightEnum.AreaType.Small) then
            areaInfo = v
            areaType = FightEnum.AreaType.Small
            break
        end
    end

    for k, v in pairs(DataArea) do
        if BehaviorFunctions.CheckPointInArea(checkPos, v.id, FightEnum.AreaType.Mid) then
            bigAreaInfo = DataBigArea[v.parent]
            if areaInfo then
                break
            else
                areaInfo = v
                areaType = FightEnum.AreaType.Mid
            end
        end
    end

    return areaInfo, areaType, bigAreaInfo
end

function MapAreaManager:GetAreaCenter_All()
    local mCenter = {}
    local sCenter = {}
    for k, v in pairs(DataArea) do
        local edgeInfo = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Mid, k)
        local x = (edgeInfo.maxX + edgeInfo.minX) / 2
        local y = (edgeInfo.maxY + edgeInfo.minY) / 2

        mCenter[k] = {x = x, y = y}
    end

    for k, v in pairs(DataSmallArea) do
        local edgeInfo = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Small, k)
        local x = (edgeInfo.maxX + edgeInfo.minX) / 2
        local y = (edgeInfo.maxY + edgeInfo.minY) / 2

        sCenter[k] = {x = x, y = y}
    end

    return mCenter, sCenter
end

function MapAreaManager:GetAreaCenterById()

end

function MapAreaManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("OnCurEntityChange"))
end