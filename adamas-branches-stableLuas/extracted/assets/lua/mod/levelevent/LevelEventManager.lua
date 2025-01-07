LevelEventManager = BaseClass("LevelEventManager")

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

function LevelEventManager:__init(fight)
    self.fight = fight
    self.clientFight = fight.clientFight
    
    self.LevelEventCtrl = mod.LevelEventCtrl

    self.allEventList = {}

    -- TODO 这里后端应该会有个记录
    self.triggeredEvent = {}
    --发现的事件 
    self.triggeredDiscoverEvent = {}

    self.addMagicMap = {}

    self.checkCondition = {}

end


function LevelEventManager:StartFight()
	self.LevelEventCtrl:ClearFight()
end


function LevelEventManager:LowUpdate()
    self:CheckTriggerEvent()
end

function LevelEventManager:CheckTriggerEvent()

    local playerInsId = BehaviorFunctions.GetCtrlEntity()
    local rolePos = BehaviorFunctions.GetPositionP(playerInsId)
    
    local mapId = Fight.Instance:GetFightMap()

    for eventId, event in pairs(LevelEventConfig.GetAllLevelEventConfig()) do
        if not self.LevelEventCtrl:CheckLevelEventFinish(eventId) then

            if self.LevelEventCtrl:CheckLevelEventLoaded(eventId) then
                -- 判断卸载
                local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(event.position_id, event.positing[2], event.positing[1])
                local unloadRadius = (event.load_radius + 10) ^ 2
                local curRadius = UtilsBase.GetPosRadius(pos, rolePos)

                if curRadius >= unloadRadius then -- 卸载
                    BehaviorFunctions.RemoveLevel(event.level_id)
					self.LevelEventCtrl:SetLevelEventLoaded(eventId,false)
                    goto continue
                end

            elseif self.LevelEventCtrl:CheckLevelEventActive(eventId) then
                local targetMapId = event.map_id
                -- 地图不对
                if targetMapId ~= mapId then
                    goto continue
                end
                -- 判断加载
                local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(event.position_id, event.positing[2], event.positing[1])
                local loadRadius = event.load_radius ^ 2
                local curRadius = UtilsBase.GetPosRadius(pos, rolePos)

                if curRadius < loadRadius then --到达加载半径才加载关卡
                    local isCreated = self:TriggerEvent(event.level_id)
                    if isCreated then
						self.LevelEventCtrl:SetLevelEventLoaded(eventId,true)
                    end
                end
            else
                -- 判断解锁

                local targetMapId = event.map_id
                -- 地图不对
                if targetMapId ~= mapId then
                    goto continue
                end
                -- 条件未达到
				local condition = Fight.Instance.conditionManager:CheckConditionByConfig(event.condition,true)
                if not condition then
                    goto continue
                end
                local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(event.position_id, event.positing[2], event.positing[1])
                local unlockRadius = event.unlock_radius ^ 2
                local curRadius = UtilsBase.GetPosRadius(pos, rolePos)

                if curRadius < unlockRadius then
					self.LevelEventCtrl:SetLevelEventActive(eventId,true)
                end

            end
            ::continue::
            
        end
    end
end

function LevelEventManager:TriggerEvent(level_id)
    local levelOccupancyList = self.fight.levelManager.levelOccupancyList
    if levelOccupancyList then
        --检测有没有被区域占用
        for i, value in pairs(levelOccupancyList) do
            if value[level_id] then
                return false
            end
        end
    end
    -- 添加关卡行为脚本
    BehaviorFunctions.AddLevel(level_id)
    --检测是否加载成功
    return BehaviorFunctions.CheckLevelIsCreate(level_id)
end
