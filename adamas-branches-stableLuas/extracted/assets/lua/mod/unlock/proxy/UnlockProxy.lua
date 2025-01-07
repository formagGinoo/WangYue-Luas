UnlockProxy = BaseClass("UnlockProxy",Proxy)

function UnlockProxy:__init()

end

function UnlockProxy:__InitProxy()
    self:BindMsg("unlock_begin")
    self:BindMsg("unlock_success")
    self:BindMsg("unlock_list")
end

function UnlockProxy:Recv_unlock_list(data)
end

function UnlockProxy:Send_unlock_begin(id)
    return { id = id }
end

function UnlockProxy:Send_unlock_success(id)
    return { id = id }
end
