SystemTaskProxy = BaseClass("SystemTaskProxy",Proxy)

function SystemTaskProxy:__init()

end

function SystemTaskProxy:__InitProxy()
    self:BindMsg("system_task_list")
    self:BindMsg("system_task_finished_list")
    self:BindMsg("system_task_commit")
    self:BindMsg("system_task_client_event")
    self:BindMsg("system_task_cancel_list")
end

function SystemTaskProxy:Recv_system_task_list(data)
    mod.SystemTaskCtrl:UpdateTaskList(data)
end

function SystemTaskProxy:Recv_system_task_finished_list(data)
    mod.SystemTaskCtrl:UpdataFinishedList(data)
end

function SystemTaskProxy:Send_system_task_commit(id)
    return {id = id}
end

local nullTable = {}
function SystemTaskProxy:Send_system_task_client_event(event_type, arg_list)
    return {event_type = event_type, arg_list = arg_list or nullTable}
end

function SystemTaskProxy:Recv_system_task_cancel_list(data)
	mod.SystemTaskCtrl:CancelSystemTask(data)
end