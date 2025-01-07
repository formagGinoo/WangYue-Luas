LevelEventCtrl = BaseClass("LevelEventCtrl",Controller)

local _tinsert = table.insert
function LevelEventCtrl:__init()
    self.FinishLevelEvents = {}
    self.ActiveLevelEvents = {}
    self.LoadedLevelEvents = {}
    
    self.DiscoverEvents = {}

    self.RewardList  = {}
    
    EventMgr.Instance:AddListener(EventName.FinishLevel, self:ToFunc("OnLevelFinish"))
end

function LevelEventCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.levelId, self:ToFunc("OnLevelFinish"))
end

function LevelEventCtrl:ClearFight()
    TableUtils.ClearTable(self.LoadedLevelEvents)
    TableUtils.ClearTable(self.DiscoverEvents)
    
	self:UpdateDiscoverEventList()
end
-- 同步后端的active数据
function LevelEventCtrl:UpdateActiveLevelEventInfo(data)

	for k, v in pairs(data.trigger_list) do
        self.ActiveLevelEvents[v] = true
    end
	self:UpdateDiscoverEventList()
end

function LevelEventCtrl:OnLevelFinish(levelid)

    for k, v in pairs(self.ActiveLevelEvents) do
        if LevelEventConfig.GetLevelEventConfig(k).level_id == levelid then
            local event_id = k
            self:SetLevelEventLoaded(event_id,false)
            -- 前端暂时设置完成，等待后端同步
            self:SetLevelEventFinished(event_id,true)
            
            mod.WorldMapCtrl:RemoveLevelEventMark(self:GetMapEventId(event_id))
            -- 领奖
            self:GetLevelEventReward(event_id)
            
            return
        end
    end
end

function LevelEventCtrl:UpdateDiscoverEventList()
    TableUtils.ClearTable(self.DiscoverEvents)

    for k, v in pairs(self.ActiveLevelEvents) do
        if not self:CheckLevelEventFinish(k) then
            self.DiscoverEvents[k] = true
        end
    end
end

function LevelEventCtrl:GetMapEventId(id)
    return "levelEvent"..id
end

function LevelEventCtrl:GetDiscoverEventList()
    return self.DiscoverEvents
end

function LevelEventCtrl:GetLevelEventReward(event_id)
    local orderId,protoId =  mod.LevelEventFacade:SendMsg("level_event_get_award", event_id)
    SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
        if LevelEventConfig.GetLevelEventConfig(event_id).show_reward then
            local setting = {
                args =  {reward_list = self.RewardList}
            }
            EventMgr.Instance:Fire(EventName.AddSystemContent, GetItemPanel, setting)
        end
    end)
end

function LevelEventCtrl:CheckLevelEventFinish(event_id)
    return self.FinishLevelEvents[event_id]
end

function LevelEventCtrl:CheckLevelEventActive(event_id)
    return self.ActiveLevelEvents[event_id]
end

function LevelEventCtrl:CheckLevelEventLoaded(event_id)
    return self.LoadedLevelEvents[event_id]
end

function LevelEventCtrl:SetLevelEventActive(event_id ,set)

    self.ActiveLevelEvents[event_id] = set

    if set then
        local orderId, protoId = mod.LevelEventFacade:SendMsg("level_event_trigger", event_id)
        
        SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
            if ERRORCODE == 0 then
                --加载发现事件的图标
                mod.WorldMapCtrl:LoadLevelEventMark()
            end
        end)
    end
    self:UpdateDiscoverEventList()
end

function LevelEventCtrl:SetLevelEventLoaded(event_id ,set)
    self.LoadedLevelEvents[event_id] = set
end

function LevelEventCtrl:SetLevelEventRewardList(list)
    self.RewardList = list
end

function LevelEventCtrl:SetLevelEventFinished(event_id ,set)
    self.FinishLevelEvents[event_id] = set
    self:UpdateDiscoverEventList()
end

function LevelEventCtrl:UpdateFinishLevelEventInfo(data)

	for k, v in pairs(data.level_event_list) do
		
		self.FinishLevelEvents[v.event_id] = v.first_finish_time
    end
	self:UpdateDiscoverEventList()
	--EventMgr.Instance:Fire(EventName.LevelEventFinish, self.FinishLevelEvents)
end



