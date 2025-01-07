TaskProxy = BaseClass("TaskProxy",Proxy)

local DataTaskStage = Config.DataTask.data_task_stage

function TaskProxy:__init()

end

function TaskProxy:__InitProxy()
    self:BindMsg("task_client_add_progress")
    self:BindMsg("task_reset_progress")
    self:BindMsg("task_trace")
    self:BindMsg("task_reward")

    self:BindMsg("task_info")
    self:BindMsg("task_node_update")
	self:BindMsg("task_update")
end

function TaskProxy:__InitComplete()

end

-- 上线的批量任务、章节、节点信息
function TaskProxy:Recv_task_info(data)
    mod.TaskCtrl:InitTaskInfo(data)
end

-- 节点切换信息
function TaskProxy:Recv_task_node_update(data)
    mod.TaskCtrl:UpdateTaskNodeInfo(data.task_node)
end

function TaskProxy:Recv_task_update(data)
    mod.TaskCtrl:UpdateTaskStateList(data)
end

function TaskProxy:Send_task_reset_progress(task_id)
    return {task_id = task_id}
end

function TaskProxy:Send_task_client_add_progress(task_id, step_id, add_num)
    return { task_id = task_id, step_id = step_id, add_num = add_num }
end

function TaskProxy:Recv_task_client_add_progress(data)
    if data.error_code ~= 0 then
        LogError("Recv_task_client_add_progress Error code = "..data.error_code)
        return
    end
end

-- 主动切换任务追踪
function TaskProxy:Send_task_trace(taskId)
    return { task_id = taskId }
end

-- 收到任务追踪
function TaskProxy:Recv_task_trace(data)
    mod.TaskCtrl:ChangeOccupyTask(data.task_id)
    mod.TaskCtrl:SetGuideTaskId(data.task_id)
end

function TaskProxy:Send_task_reward(taskId)
    return { task_id = taskId }
end

function TaskProxy:Recv_task_reward(data)
    mod.TaskCtrl:UpdateReceivedTaskID(data.task_id)
end