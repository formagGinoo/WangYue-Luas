---@class BgmAreaManager
BgmAreaManager = BaseClass("BgmAreaManager")

local DataBgmArea

local BgmSpecialAreaState = Config.MusicState.specicalStateList

function BgmAreaManager:__init(fight)
    self.fight = fight
    self.curEntity = nil
    self.curEntityPos = nil
    self.lastEntityPos = nil
    
    self.curBgmAreaId = nil
    self.curSpecialArea = nil

    EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("OnCurEntityChange"))
    EventMgr.Instance:AddListener(EventName.EnterLogicArea, self:ToFunc("OnEnterArea"))
    EventMgr.Instance:AddListener(EventName.ExitLogicArea, self:ToFunc("OnExitArea"))
end

function BgmAreaManager:StartFight()
	self:InitBgmAreaState()
end

function BgmAreaManager:LowUpdate()
    if not self.curEntity then
        return
    end

    if not DataBgmArea then
        DataBgmArea = MapPositionConfig.GetBgmAreaInfo()
    end

    if not DataBgmArea then
        return 
    end

    local mapId = self.fight:GetFightMap()
    local bgmAreaId
    local position = self.curEntity.transformComponent:GetPosition()
    self.lastEntityPos = self.curEntityPos
    self.curEntityPos = position

    for k, v in pairs(DataBgmArea) do
        if self:CheckPointInBgmArea(position, v.id, mapId) then
            bgmAreaId = v.id
            break
        end
    end

    if not bgmAreaId then return end

    if not self.curBgmAreaId or self.curBgmAreaId ~= bgmAreaId then
        BgmManager.Instance:SetBgmState("Area","Area" .. bgmAreaId)
        self.curBgmAreaId = bgmAreaId
    end
end

function BgmAreaManager:CheckPointInBgmArea(point, areaId, mapId)
	local bounds = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Bgm, areaId, mapId)
	local areaPointList = MapPositionConfig.GetAreaBoundsInfo(FightEnum.AreaType.Bgm, areaId, mapId)

	if not bounds or not areaPointList then
		return
	end

	if point.x > bounds.maxX or point.x < bounds.minX or point.z > bounds.maxY or point.z < bounds.minY then
		return false
	end

	local isInArea = false
	for i = 1, #areaPointList do
		if i == 1 and
			not (areaPointList[#areaPointList].y > point.z and areaPointList[1].y > point.z) and
			not (areaPointList[#areaPointList].y < point.z and areaPointList[1].y < point.z) and
			point.x < (areaPointList[#areaPointList].x - areaPointList[1].x) * (point.z - areaPointList[1].y) / (areaPointList[#areaPointList].y - areaPointList[1].y) + areaPointList[1].x then
			isInArea = not isInArea
		elseif i > 1 and
				not (areaPointList[i - 1].y > point.z and areaPointList[i].y > point.z) and
				not (areaPointList[i - 1].y < point.z and areaPointList[i].y < point.z) and
				point.x < (areaPointList[i - 1].x - areaPointList[i].x) * (point.z - areaPointList[i].y) / (areaPointList[i - 1].y - areaPointList[i].y) + areaPointList[i].x then
			isInArea = not isInArea
		end
	end

	return isInArea
end

function BgmAreaManager:InitBgmAreaState()
    BgmManager.Instance:SetBgmState("Area","default")
end

function BgmAreaManager:OnCurEntityChange()
    if not self.fight or not self.fight.playerManager then
        return
    end

    self.curEntity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
end

function BgmAreaManager:OnEnterArea(instanceId, areaName, logicName)
    if self.curEntity and self.curEntity.instanceId == instanceId and self:CheckIsSpecialArea(areaName) then
        BgmManager.Instance:SetBgmState("SpecialArea",areaName)
    end
end

function BgmAreaManager:OnExitArea(instanceId, areaName, logicName)
    if self.curEntity and self.curEntity.instanceId == instanceId and self.curSpecialArea == areaName then
        BgmManager.Instance:SetBgmState("SpecialArea","default")
    end
end

function BgmAreaManager:CheckIsSpecialArea(areaName)
    for i, v in ipairs(BgmSpecialAreaState) do
        if areaName == v then
            return true
        end
    end
    return false
end

function BgmAreaManager:__delete()
    self.fight = nil
    self.curEntityPos = nil
    self.lastEntityPos = nil
    self.curBgmAreaId = nil

    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("OnCurEntityChange"))
    EventMgr.Instance:RemoveListener(EventName.EnterLogicArea, self:ToFunc("OnEnterArea"))
    EventMgr.Instance:RemoveListener(EventName.ExitLogicArea, self:ToFunc("OnExitArea"))
end