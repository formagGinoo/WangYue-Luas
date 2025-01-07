SystemProxy = BaseClass("SystemProxy",Proxy)

function SystemProxy:__init()

end

function SystemProxy:__InitProxy()
    self:BindMsg("sys_open_add")
end

function SystemProxy:Recv_sys_open_add(data)
    local idMap = data.id
    mod.SystemCtrl:OnRecv_SystemInitData(idMap)
end

function SystemProxy:Send_sys_open_add(id)
    return { id = id }
end