LevelEventProxy = BaseClass("LevelEventProxy",Proxy)

function LevelEventProxy:__init()

end

function LevelEventProxy:__InitProxy()
    self:BindMsg("level_event_get_award")
    self:BindMsg("level_event_info_list")
    self:BindMsg("level_event_trigger")
    self:BindMsg("level_event_trigger_list")
    
end

function LevelEventProxy:Send_level_event_get_award(id)
    return {event_id = id}
end


function LevelEventProxy:Send_level_event_trigger(id)
    return {event_id = id}
end

function LevelEventProxy:Recv_level_event_info_list(data)

    mod.LevelEventCtrl:UpdateFinishLevelEventInfo(data);
    mod.WorldMapTipCtrl:UpdateLevelEventList(data)
end

function LevelEventProxy:Recv_level_event_trigger_list(data)

    mod.LevelEventCtrl:UpdateActiveLevelEventInfo(data);
    mod.WorldMapTipCtrl:UpdateActiveLevelEventInfo(data);
end


