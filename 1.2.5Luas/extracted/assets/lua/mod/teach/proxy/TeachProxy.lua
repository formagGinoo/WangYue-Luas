TeachProxy = BaseClass("TeachProxy",Proxy)

function TeachProxy:__init()
end

function TeachProxy:__InitProxy()
    self:BindMsg("teach_add")
    self:BindMsg("teach_reward")
    self:BindMsg("teach_last_id")
end

-- 发送需要保存的数据
function TeachProxy:Send_teach_add(teach_id)
    return { id = teach_id }
end

function TeachProxy:Send_teach_reward(teach_id)
    return { id = teach_id }
end

-- 返回的收录数据
function TeachProxy:Recv_teach_reward(data)
    local id = data.id
    mod.TeachCtrl:RecvTeachReward(id)
end

function TeachProxy:Recv_teach_last_id(data)
    mod.TeachCtrl:AddTeachRecentlyRecord(data.id_list)
end