TaskReviewCtrl = BaseClass("TaskReviewCtrl",Controller)


function TaskReviewCtrl:__init()
    self.TaskStatisticDic = {}
end

function TaskReviewCtrl:GetNodeStatistic(pageId,nodeId)
    local taskId = TaskReviewConfig.GetStatisticTaskId(pageId,nodeId)
    if self.TaskStatisticDic[pageId] and taskId > 0 then
        return self.TaskStatisticDic[pageId][taskId]
    end
end

function TaskReviewCtrl:UpdataTaskStatistic(data)
    local reviewid= TaskReviewConfig.GetPageId(data.type,data.sec_type)
    self.TaskStatisticDic[reviewid] = {}
    for _, v in pairs(data.choice_list) do
        local sum = 0
        for _, val in pairs(v.task_choice_count_maps) do
            sum = sum + val 
        end
        for key, val in pairs(v.task_choice_count_maps) do
            val = math.floor(val / sum * 100)
            self.TaskStatisticDic[reviewid][key] = val
        end
    end
end

function TaskReviewCtrl:RequestTaskStatistic(type,sec_type)
    mod.TaskReviewFacade:SendMsg("task_finish_statistic", type,sec_type)
end