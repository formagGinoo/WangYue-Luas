TaskProxy = BaseClass("TaskProxy",Proxy)

local DataTaskStage = Config.DataTask.data_task_stage

function TaskProxy:__init()

end

function TaskProxy:__InitProxy()
    self:BindMsg("task_state")
    self:BindMsg("task_commit")
    self:BindMsg("task_accept")
	self:BindMsg("task_finished")
    self:BindMsg("task_major_last_id")
    self:BindMsg("task_client_add_progress")
    self:BindMsg("task_reset_progress")
    self:BindMsg("task_trace")
end

function TaskProxy:__InitComplete()

end

function TaskProxy:Recv_task_state(data)
    mod.TaskCtrl:UpdateTaskStateList(data)
end

function TaskProxy:Send_task_accept(task_id)
    return {task_id = task_id}
end

-- 提交任务
function TaskProxy:Send_task_commit(task_id)
    return {task_id = task_id}
end

function TaskProxy:Send_task_reset_progress(task_id)
    return {task_id = task_id}
end

function TaskProxy:Recv_task_commit(data)
    -- LogTable("task commit", data)
	mod.TaskCtrl:OnCommitSuc(data.task_id)
end

function TaskProxy:Send_task_client_add_progress(task_id, progress_id, add_num, type)
    return {task_id = task_id, progress_id = progress_id, add_num = add_num, type = type}
end

function TaskProxy:Recv_task_client_add_progress(data)
    if data.error_code ~= 0 then
        LogError("Recv_task_client_add_progress Error code = "..data.error_code)
        return
    end
end

function TaskProxy:Recv_task_finished(data)
    -- LogTable("taskFinish", data)
	for k, v in pairs(data.task_id_list) do
    	mod.TaskCtrl:OnTaskFinish(v)
	end
end

function TaskProxy:Recv_task_major_last_id(data)
    mod.TaskCtrl:SetMainTaskLastId(data.task_id)
end

function TaskProxy:Send_task_trace(taskId)
    return { task_id = taskId }
end

function TaskProxy:Recv_task_trace(data)
    mod.TaskCtrl:ChangeOccupyTask(data.task_id)
    mod.TaskCtrl:SetGuideTaskId(data.task_id)
end