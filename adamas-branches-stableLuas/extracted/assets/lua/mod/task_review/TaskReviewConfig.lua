TaskReviewConfig = TaskReviewConfig or {}

local DataTaskChapterReview = Config.DataTaskChapterReview.Find
local DataTaskChapterShow = Config.DataTaskChapterShow.Find
local DataTaskChapterMap = Config.DataTaskChapterMap.Find
local DataTaskChapterShow = Config.DataTaskChapterShow.Find
local DataTaskType = Config.DataTaskType.Find
local DataTaskGroupShow = Config.DataTaskGroupShow.Find
local DataTaskChooseWeight = Config.DataTaskChooseWeight.Find

TaskReviewConfig.TaskNodeType =
{
    [0] = "LockNode",
    [1] = "UnLockNode",
    [2] = "PhotoEventNode",
    [3] = "JumpNode",
    [4] = "NormalEventNode",
    [5] = "NormalEventNode",
    [6] = "PhotoEventNode",
    [7] = "ListNode",
    [8] = "LockEndingNode",
    [9] = "UnLockNode",
}

local PageTaskListDict = {}

function TaskReviewConfig.GetPageTaskList(pageId)
    if PageTaskListDict[pageId] then return PageTaskListDict[pageId] end
    PageTaskListDict[pageId] = {}
    for k, v in pairs(DataTaskChapterReview) do
        if pageId == v.review_id then
            table.insert(PageTaskListDict[pageId],v)
        end
    end
    local func = function(a,b)
        return a.node_id < b.node_id
    end
    table.sort(PageTaskListDict[pageId],func)
    return PageTaskListDict[pageId]
end

function TaskReviewConfig.GetPageContentSize(pageId)
    return DataTaskChapterMap[pageId] and DataTaskChapterMap[pageId].review_map or {100,100}
end

function TaskReviewConfig.GetNodeByType(type)
    return TaskReviewConfig.TaskNodeType[type]
end

function TaskReviewConfig.GetPageList()
    local TaskChapterShowList = {}
    for k, v in pairs(DataTaskChapterShow) do
        table.insert(TaskChapterShowList,v)
    end
    local sortfunc = function(a,b)
        return a.id < b.id
    end
    table.sort(TaskChapterShowList,sortfunc)
    return TaskChapterShowList
end

function TaskReviewConfig.GetPageTitle(type1, type2)
    for i, v in pairs(DataTaskChapterShow) do
        if v.type == type1 and v.sec_type == type2 then
            return v.chapter_name
        end
    end
end

function TaskReviewConfig.GetPageSmallTitle(type1, type2)
    for i, v in pairs(DataTaskChapterShow) do
        if v.type == type1 and v.sec_type == type2 then
            return v.chapter_name_pin
        end
    end
end

function TaskReviewConfig.GetPageId(type,secType)
    for i, v in pairs(DataTaskChapterShow) do
        if v.type == type and v.sec_type == secType then
            return v.review_id
        end
    end
end

function TaskReviewConfig.GetTaskGroup(key)
    local group = {}
    key = tonumber(key)
    for k, v in pairs(DataTaskGroupShow) do
        if v.group_show_id == key then
            table.insert(group,v)
        end
    end
    local sortfun = function(a,b)
        return a.order < b.order
    end
    table.sort(group,sortfun)
    return group
end


function TaskReviewConfig.GetStatisticTaskId(pageId,nodeId)
    for k, v in pairs(DataTaskChooseWeight) do
        if v.review_id == pageId then
            for i, v2 in ipairs(v.node_list) do
                if v2 == nodeId then
                    return v.task_list[i]
                end
            end
        end
    end
    return 0
end