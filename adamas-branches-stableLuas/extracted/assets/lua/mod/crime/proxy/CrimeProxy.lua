CrimeProxy = BaseClass("CrimeProxy", Proxy)

function CrimeProxy:__InitProxy()
    self:BindMsg("crime_add_bounty")
    self:BindMsg("crime_bounty")
    self:BindMsg("crime_prison_info")
    self:BindMsg("crime_prison_game_finish")
end

function CrimeProxy:Send_crime_add_bounty(id)
    return {crime_type = id}
end

function CrimeProxy:Recv_crime_bounty(data)
    mod.CrimeCtrl:UpdataBounty(data.bounty_info)
end

function CrimeProxy:Send_crime_prison_info(state,prisonId)
    return {state = state,prison_id = prisonId}
end

function CrimeProxy:Recv_crime_prison_info(data)
    mod.CrimeCtrl:UpdataPrisonInfo(data)
end

function CrimeProxy:Send_crime_prison_game_finish(gameId)
    return {game_id = gameId}
end