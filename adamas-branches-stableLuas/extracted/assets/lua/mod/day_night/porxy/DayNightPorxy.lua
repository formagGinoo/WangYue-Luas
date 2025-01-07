DayNightPorxy = BaseClass("DayNightPorxy", Proxy)

function DayNightPorxy:__init()
    
end

function DayNightPorxy:__InitProxy()
    self:BindMsg("client_inner_time") 
end

function DayNightPorxy:Send_client_inner_time(time)
    return {inner_time = time}
end

function DayNightPorxy:Recv_client_inner_time(data)
    mod.DayNightCtrl:UpdataTime(data.inner_time)
end