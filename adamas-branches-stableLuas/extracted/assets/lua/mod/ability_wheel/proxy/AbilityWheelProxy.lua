AbilityWheelProxy = BaseClass("AbilityWheelProxy", Proxy)

function AbilityWheelProxy:__init()

end

function AbilityWheelProxy:__InitProxy()
    self:BindMsg("ability_roulette_info")
    self:BindMsg("ability_roulette_use")
    self:BindMsg("ability_roulette_change")
    self:BindMsg("ability_roulette_partner_change")
end

function AbilityWheelProxy:Recv_ability_roulette_info(data)
    mod.AbilityWheelCtrl:RecvAbilityInfo(data)
end

function AbilityWheelProxy:Send_ability_roulette_use(use_id)
    return {use_id = use_id}
end

function AbilityWheelProxy:Send_ability_roulette_change(tb)
    return {ability_list = tb}
end

function AbilityWheelProxy:Send_ability_roulette_partner_change(tb)
    return {partner = tb}
end