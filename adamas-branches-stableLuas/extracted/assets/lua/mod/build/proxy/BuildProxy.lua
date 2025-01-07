BuildProxy = BaseClass("BuildProxy", Proxy)

function BuildProxy:__init()

end

function BuildProxy:__InitProxy()
    self:BindMsg("hacking_build")
    self:BindMsg("hacking_build_unlock")
    self:BindMsg("hacking_build_unlock_progress")

    self:BindMsg("blueprint_unlock")    --「蓝图-解锁」返回走通用回包
    self:BindMsg("blueprint_custom_save")      --「蓝图-自定义保存」返回走通用回包
    self:BindMsg("blueprint_info")      --「蓝图-信息」是上线的时候全量同步
    self:BindMsg("blueprint_custom_delete") --「蓝图-信息」删除自定义蓝图
    self:BindMsg("blueprint_set")       --「蓝图-放置」放置蓝图  1: 预制蓝图;2: 玩家自定义蓝图
end

function BuildProxy:__InitComplete() end

function BuildProxy:Send_hacking_build(build_id)
    return { build_id = build_id }
end

function BuildProxy:Recv_hacking_build_unlock(data)
    local unlockId
    for k, v in pairs(data.build_id or {}) do
        table.insert(mod.HackingCtrl.unlock_build_list, v)
        unlockId = v
    end
    EventMgr.Instance:Fire(EventName.BuildUnlock, unlockId)
end

function BuildProxy:Recv_hacking_build_unlock_progress(data)
    for k, v in pairs(data.unlock_progress_list or {}) do
        table.insert(mod.HackingCtrl.unlock_progress_list, v)
    end
end

function BuildProxy:Send_hacking_build_unlock(build_id)
    return { build_id = build_id }
end

function BuildProxy:Recv_blueprint_info(data)
    mod.BuildCtrl:AddPreBlueprint(data.unlock_list)
    mod.BuildCtrl:AddCustomBlueprint(data.custom_list)
    mod.BuildCtrl:SetUseTime(data.use_time or {})
    mod.BuildCtrl:SetUseHistory(data.history or {})
end

function BuildProxy:Send_blueprint_unlock(blueprint_id)
    return { blueprint_id = blueprint_id }
end

--message  struct_blueprint_node{
--      int32 build_id = 1
--      string  node_name = 2
--      string  connect_node = 3
--      struct_position offset = 4
--      struct_position rotate = 5
--      struct_blueprint_node  child_list = 6
--  }
--message struct_blueprint {
--      int64 blueprint_id = 1
--      string name = 1
--      string image_path = 2
--      struct_blueprint_node  child_list = 3
--  }
function BuildProxy:Send_blueprint_custom_save(data)
    return {blueprint = data}
end

function BuildProxy:Send_blueprint_custom_delete(blueprint_id)
    return { blueprint_id = blueprint_id }
end

function BuildProxy:Send_blueprint_set(data)
    return {type = data.type, blueprint_id = data.blueprint_id}
end