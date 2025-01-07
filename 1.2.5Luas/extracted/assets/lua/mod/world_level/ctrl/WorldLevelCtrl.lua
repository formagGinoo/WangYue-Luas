WorldLevelCtrl = BaseClass("WorldLevelCtrl",Controller)

function WorldLevelCtrl:__init()
    self.maxWorldLevel = 0
    self.curWorldLevel = 0
    self.adventureInfo = {}
end

function WorldLevelCtrl:UpdatePlayerAdventure(info)
    local oldInfo = {lev = self.adventureInfo.lev, exp = self.adventureInfo.exp}
    if info.lev then
        self.adventureInfo.lev = info.lev
    end
    if info.exp then
        self.adventureInfo.exp = info.exp
    end

    if Fight.Instance and oldInfo and oldInfo.lev then
        local addExp = 0
        if oldInfo.lev == info.lev then
            addExp = info.exp - oldInfo.exp
            EventMgr.Instance:Fire(EventName.AdventureChange, addExp)
        else
            for i = oldInfo.lev, info.lev do
                if i == oldInfo.lev then
                    addExp = addExp + InformationConfig.AdventureConfig[i].limit_exp - oldInfo.exp
                elseif i == info.lev then
                    addExp = addExp + info.exp
                else
                    addExp = addExp + InformationConfig.AdventureConfig[i].limit_exp
                end
            end
            EventMgr.Instance:Fire(EventName.AdventureChange, addExp, oldInfo.lev)
        end
    else
        EventMgr.Instance:Fire(EventName.AdventureChange)
    end
end

function WorldLevelCtrl:GetAdventureInfo()
    return self.adventureInfo
end

function WorldLevelCtrl:UpdateWorldLevel(lev, maxLev)
    local odlMaxWorldLevel = self.maxWorldLevel
    self.maxWorldLevel = maxLev
    self.curWorldLevel = lev
    if odlMaxWorldLevel ~= maxLev and maxLev ~= 0 then
        EventMgr.Instance:Fire(EventName.AddCenterContent, WorldLevelChangeTipPanel, TipQueueManger.TipPriority.CommonTip, {level = maxLev})
    elseif Fight.Instance then
        local player = Fight.Instance.playerManager:GetPlayer()
        local position = player:GetCtrlEntityObject().transformComponent:GetPosition()
        local mapId = self.fight:GetFightMap()
        mod.WorldMapFacade:SendMsg("map_enter", mapId, position.x, position.y, position.z)
    end
    EventMgr.Instance:Fire(EventName.WorldLevelChange)
end

function WorldLevelCtrl:GetWorldLevel()
    return self.curWorldLevel, self.maxWorldLevel
end

function WorldLevelCtrl:WorldLevelUpgrade()
    mod.WorldLevelFacade:SendMsg("world_level_upgrade")
end

function WorldLevelCtrl:WorldLevelDegrade()
    mod.WorldLevelFacade:SendMsg("world_level_degrade")
end

function WorldLevelCtrl:GetEcoEntityLevel(type)
    return WorldLevelConfig.GetEcoLev(self.curWorldLevel,type)
end

function WorldLevelCtrl:CheckWorldLevFinish()
    local targetLev = self.maxWorldLevel + 1
    if targetLev > WorldLevelConfig.GetMaxLev() then
        return false
    end

    local taskMap = WorldLevelConfig.GetWorldLevelTaskMap(targetLev)
    for key, taskId in pairs(taskMap) do
        if mod.SystemTaskCtrl:CheckTaskCanFinish(taskId) then
            return true
        end
    end
    
    return false
end

function WorldLevelCtrl:CheckAdvLevLimit()
    if self.maxWorldLevel == WorldLevelConfig.GetMaxLev() then
        return false
    end
    local config = WorldLevelConfig.GetAdvLevConfig(self.adventureInfo.lev)
    if not config then
        return false
    end
    if self.adventureInfo.exp >= config.limit_exp then
        return true
    end
    return false
end

function WorldLevelCtrl:CheckWorldLevBreak()
    local targetLev = self.maxWorldLevel + 1
    if targetLev > WorldLevelConfig.GetMaxLev() then
        return false
    end

    local taskMap = WorldLevelConfig.GetWorldLevelTaskMap(targetLev)
    for key, taskId in pairs(taskMap) do
        if not mod.SystemTaskCtrl:CheckTaskFinished(taskId) then
            return false
        end
    end
    return true
end