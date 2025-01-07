MercenaryHuntProxy = BaseClass("MercenaryHuntProxy",Proxy)

function MercenaryHuntProxy:__init()

end

function MercenaryHuntProxy:__InitProxy()
    self:BindMsg("mercenary_main_info")
    self:BindMsg("mercenary_alert_value")
    self:BindMsg("mercenary_clean_alert_value")
    self:BindMsg("mercenary_fight_state")
    self:BindMsg("mercenary_list")
    self:BindMsg("mercenary_discover_state")
    self:BindMsg("mercenary_rank")
    self:BindMsg("mercenary_reward_list")
end

function MercenaryHuntProxy:Recv_mercenary_main_info(data)
    mod.MercenaryHuntCtrl:InitMercenaryHuntMainInfo(data)
end

function MercenaryHuntProxy:Recv_mercenary_alert_value(data)
    mod.MercenaryHuntCtrl:UpdateAlertVal(data.value)
end

function MercenaryHuntProxy:Send_mercenary_clean_alert_value()
end

function MercenaryHuntProxy:Send_mercenary_fight_state(state)
    return {state = state}
end

-- 返回佣兵列表
function MercenaryHuntProxy:Recv_mercenary_list(data)
    mod.MercenaryHuntCtrl:UpdateMercenaryList(data)
end

function MercenaryHuntProxy:Send_mercenary_discover_state(ecoId)
    return {ecosystem_id = ecoId}
end

function MercenaryHuntProxy:Recv_mercenary_rank(data)
    mod.MercenaryHuntCtrl:UpdateMercenaryRankVal(data.exp)
end

function MercenaryHuntProxy:Send_mercenary_reward_list(rank)
    return {rank_level = rank}
end

function MercenaryHuntProxy:Recv_mercenary_reward_list(data)
    mod.MercenaryHuntCtrl:UpdateGetMercenaryRankRewardMap(data.rank_level_list)
end