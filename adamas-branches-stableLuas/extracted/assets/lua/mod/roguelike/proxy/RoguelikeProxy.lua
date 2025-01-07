RoguelikeProxy = BaseClass("RoguelikeProxy",Proxy)

function RoguelikeProxy:__init()

end

function RoguelikeProxy:__InitProxy()
    self:BindMsg("rogue_info")
    self:BindMsg("rogue_event_finish")
    self:BindMsg("rogue_event_reward")
    self:BindMsg("rogue_card_info")
    self:BindMsg("rogue_card_choose")
    self:BindMsg("rogue_card_choice_list")
    self:BindMsg("rogue_card_equip")
    self:BindMsg("rogue_season_schedule_reward")
    self:BindMsg("rogue_restart")
    self:BindMsg("rogue_event_discover")
    self:BindMsg("rogue_info_refresh")
end

-- 初始信息/增量修改数据
function RoguelikeProxy:Recv_rogue_info(data)
    mod.RoguelikeCtrl:AsyncRoguelikeData(data)
end

function RoguelikeProxy:Recv_rogue_card_info(data)
    mod.RoguelikeCtrl:AsyncRoguelikeCartData(data)
end

function RoguelikeProxy:Recv_rogue_card_choice_list(data)
    mod.RoguelikeCtrl:AsyncRoguelikeCardData(data)
end

function RoguelikeProxy:Recv_rogue_event_finish(data)
    mod.RoguelikeCtrl:AsyncRoguelikeEventFinishData(data)
end

function RoguelikeProxy:Recv_rogue_info_refresh(data)
    mod.RoguelikeCtrl:AsyncRoguelikeInfoRefresh(data)
end

function RoguelikeProxy:Send_rogue_info()
    return {}
end

function RoguelikeProxy:Send_rogue_event_finish(logic_id, event_id)
    return {area_logic_id = logic_id, event_id = event_id}
end

function RoguelikeProxy:Send_rogue_event_reward(event_id)
    return {event_id = event_id}
end

function RoguelikeProxy:Send_rogue_card_choose(card_id)
    return {card_id = card_id}
end

function RoguelikeProxy:Send_rogue_card_equip(data)
    return {card_equip = data}
end

function RoguelikeProxy:Send_rogue_season_schedule_reward(rewardLvList)
    return {reward_level_list = rewardLvList}
end

function RoguelikeProxy:Send_rogue_restart(remove_card_id_list)
    return {remove_card_id_list = remove_card_id_list}
end

function RoguelikeProxy:Send_rogue_event_discover(logic_id, eventId)
    return {area_logic_id = logic_id, event_id = eventId}
end