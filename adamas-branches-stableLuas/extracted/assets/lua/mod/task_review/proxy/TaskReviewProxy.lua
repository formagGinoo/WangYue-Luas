TaskReviewProxy = BaseClass("TaskReviewProxy",Proxy)

function TaskReviewProxy:__init()
    self:BindMsg("task_finish_statistic")
end

function TaskReviewProxy:__InitProxy()

end

function TaskReviewProxy:Send_task_finish_statistic(type,sec_type)
    return { type = type, sec_type = sec_type }
end

function TaskReviewProxy:Recv_task_finish_statistic(data)
    mod.TaskReviewCtrl:UpdataTaskStatistic(data)
end