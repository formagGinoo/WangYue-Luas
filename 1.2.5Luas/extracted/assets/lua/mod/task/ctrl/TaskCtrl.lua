---@class TaskCtrl : Controller
TaskCtrl = BaseClass("TaskCtrl",Controller)

local DataTask = Config.DataTask.data_task
local DataTaskNpcOccupy = Config.DataTaskNpcOccupy

function TaskCtrl:__init()
    self.taskMap = {}
    self.taskTypeMap = {}
    local taskMainType = TaskConfig.GetAllTaskMainType()
    for i = 1, #taskMainType do
        self.taskTypeMap[i] = {}
    end
	self.lastMainTaskId = 0
    -- 给更新任务状态的时候加个判断 代表服务器当前的指引任务
    self.guideTaskId = nil
    self.finishTask = {}
    self.areaInTask = {}
    self.taskInited = false

    -- 任务占用
    self.areaOccupyTask = {}
    self.npcOccupyTask = {}
    -- NPC接取占用
    self.npcAcceptTask = {}

    -- 任务标记
    self.curGuideMarks = {}

    -- 任务指引
    self.curGuidePointer = {}

    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryDialogEnd"))
end

function TaskCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryDialogEnd"))
end

function TaskCtrl:UpdateTaskStateList(data)
    -- LogTable("svr task_list", data.task_list)
    -- data.task_list = { {id = 200100101}, {id = 10040001}, {id = 10030001}}
    local updateGuide = false
	local guideTaskId
    local guideTaskType = 999
    for k, v in pairs(data.task_list) do
        local taskId = v.id
        local taskInfo = self.taskMap[taskId]
        -- 更新任务指引
        if self.guideTaskId and self.guideTaskId == taskId and not v.finish then
            updateGuide = true
        end

        local isNewTask = false
        if not self.taskMap[taskId] then
            isNewTask = true
            taskInfo = self:_AddTask(taskId)
        end

        -- 刷新任务信息
        local condition = {}
        for _, progress in pairs(v.progress_list) do
            condition[progress.id] = progress.current
        end
        taskInfo.finish = v.finish
        taskInfo.condition = condition
        taskInfo.inProgress = v.in_progress
        if v.finish then
            self:OnTaskFinish(v.id)
        end

        if not taskInfo.inProgress and isNewTask then
            taskInfo.behavior.behaviorPause = true
        end

        -- 设置任务追踪
        local canTrace = taskInfo.taskConfig.auto_trace and not taskInfo.taskConfig.is_hide_task
        if not self.guideTaskId and canTrace and v.in_progress and not v.finish then
            if guideTaskType > taskInfo.taskConfig.type then
                guideTaskId = taskId
                guideTaskType = taskInfo.taskConfig.type
            end
        end

        if taskInfo.inProgress and taskInfo.taskConfig.proceed_area and next(taskInfo.taskConfig.proceed_area) then
            for _, areaId in ipairs(taskInfo.taskConfig.proceed_area) do
                if not self.areaInTask[areaId] then
                    self.areaInTask[areaId] = taskId
                end
            end
        end

        EventMgr.Instance:Fire(EventName.AddTask, taskId, isNewTask)
    end

    self.taskInited = true
    if updateGuide then
        self:UpdateGuideTask()
    end

    --追踪优先级最高的自动追踪任务
    if guideTaskId then
        self:SetGuideTaskId(guideTaskId)
    end
    -- 最后刷新一遍可接取NPC列表
    self:RefreshNpcAcceptTask()
end

function TaskCtrl:_AddTask(taskId)
    local taskInfo = {}
    taskInfo.taskId = taskId
    taskInfo.taskConfig = DataTask[taskId]
    if not taskInfo.taskConfig then
        LogError("找不到对应的任务配置 taskId = "..taskId)
        return
    end

    taskInfo.taskType = taskInfo.taskConfig.type
    taskInfo.mapId = taskInfo.taskConfig.map_id

    self.taskMap[taskId] = taskInfo
    local taskType = taskInfo.taskConfig.type
    self.taskTypeMap[taskType][taskId] = taskInfo

    self:AddOccupyTaskRecord(taskInfo)

    return taskInfo
end

-- 添加任务绑定队列
function TaskCtrl:AddOccupyTaskRecord(taskInfo)
    local taskCfg = taskInfo.taskConfig
    for k, v in pairs(taskCfg.proceed_area) do
        if not self.areaOccupyTask[v] then
            self.areaOccupyTask[v] = {}
        end

        if taskInfo.inProgress then
            self.areaInTask[v] = taskCfg.id
        end

        table.insert(self.areaOccupyTask[v], taskCfg.id)
    end

    local occupyCfg = self:GetTaskOccupyConfig(taskCfg.id)
    if not occupyCfg or not next(occupyCfg) then
        return
    end

    for k, v in pairs(occupyCfg.occupy_list) do
        if not self.npcOccupyTask[k] then
            self.npcOccupyTask[k] = {}
        end

        table.insert(self.npcOccupyTask[k], taskCfg.id)
    end
end

function TaskCtrl:ChangeOccupyTask(taskId)
    local task = self:GetTask(taskId)
	if not task then
        return
    end

    for k, v in pairs(task.taskConfig.proceed_area) do
        self.areaInTask[v] = taskId
    end

    EventMgr.Instance:Fire(EventName.OccupyTaskChange, taskId)

    -- 切换占用也要刷新一下可接取任务的npc
    self:RefreshNpcAcceptTask()
end

function TaskCtrl:GetAllAreaOccupyTask()
    return self.areaOccupyTask
end

function TaskCtrl:GetAreaOccupyTask(areaId)
    return self.areaOccupyTask[areaId]
end

function TaskCtrl:GetAllNpcOccupyTask()
    return self.npcOccupyTask
end

function TaskCtrl:GetNpcOccupyTask(npcId)
    return self.npcOccupyTask[npcId]
end

function TaskCtrl:RemoveTask(taskId)
    local taskInfo = self.taskMap[taskId]
    if not taskInfo then
        return
    end

    mod.TaskFacade:SendMsg("task_commit", taskId)
    self.taskMap[taskId] = nil
    local taskType = taskInfo.taskConfig.type
    self.taskTypeMap[taskType][taskId] = nil
    EventMgr.Instance:Fire(EventName.TaskFinish, taskId)
end

function TaskCtrl:AddToFinishTask(taskId)
    if self.finishTask[taskId] then
        return
    end

    self.finishTask[taskId] = true
end

function TaskCtrl:CheckTaskIsFinish(taskId)
    return self.finishTask[taskId]
end

function TaskCtrl:CheckTaskIsInProgress(taskId)
    if not self.taskMap[taskId] then
        return false
    end

    return self.taskMap[taskId].inProgress
end

function TaskCtrl:CheckAreaIsInTask(areaId)
    return self.areaInTask[areaId] ~= nil
end

function TaskCtrl:CheckTaskInited()
    return self.taskInited
end

function TaskCtrl:GetTastTypeMap(taskType)
    return self.taskTypeMap
end

-- Manager
function TaskCtrl:OnTaskFinish(taskId)
    local taskConfig = self:GetTaskConfig(taskId)
    if not taskConfig or self.finishTask[taskId] then
        return
    end

    self:AddToFinishTask(taskId)
    if not self.taskMap[taskId] then
        return
    end

    if taskConfig.ending_dialog == 0 then
        self:RemoveTask(taskId)
    else
        self.endingDialog = { taskId = taskId, dialogId = taskConfig.ending_dialog }
        EventMgr.Instance:Fire(EventName.TaskPreFinish, taskId)
    end
end

function TaskCtrl:OnCommitSuc(taskId)

end

function TaskCtrl:OnStoryDialogEnd(dialogId)
    if not self.endingDialog or not next(self.endingDialog) or self.endingDialog.dialogId ~= dialogId then
        return
    end

    self:RemoveTask(self.endingDialog.taskId)
    TableUtils.ClearTable(self.endingDialog)
end

function TaskCtrl:SetMainTaskLastId(lastMainTaskId)
    self.lastMainTaskId = lastMainTaskId
    self.lastMainTask = DataTask[self.lastMainTaskId]
end

function TaskCtrl:GetMainTask()
    for k, v in pairs(self.taskTypeMap[1]) do
        return v
    end
end

function TaskCtrl:GetLastMainTask()
    return self.lastMainTask
end

function TaskCtrl:GetTaskList(taskType, order)
    local taskMap = self.taskTypeMap[taskType]
    if not taskMap then
        return
    end

    local list = {}
    for k, v in pairs(taskMap) do
        table.insert(list, v)
    end

    if order and #list > 1 then
        local onSort = function (a, b)
            return a.data.taskConfig.order > b.data.taskConfig.order
        end
        table.sort(list, onSort)
    end

    return list
end

function TaskCtrl:GetAllTask()
    return self.taskMap
end

function TaskCtrl:GetTask(taskId)
    return self.taskMap[taskId]
end

function TaskCtrl:GetTaskConfig(taskId)
    return DataTask[taskId]
end

function TaskCtrl:GetTaskOccupyConfig(taskId)
    return DataTaskNpcOccupy.Find[taskId]
end

function TaskCtrl:GetGuideTaskPosition()
    local taskConfig = self:GetTaskConfig(self.guideTaskId)
    local mapId = mod.WorldMapCtrl.mapId
    if taskConfig.map_id ~= mapId then
        return
    end

    local guideProgress = self:GetCurNeedGuideProgress(self.guideTaskId)
    local taskPos = taskConfig.task_position[guideProgress]
    local mapPositionCfg = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(taskConfig.position_id, taskPos[2], taskPos[1])
    return Vec3.New(mapPositionCfg.x, mapPositionCfg.y, mapPositionCfg.z)
end

function TaskCtrl:GetTaskPositionById(taskId, progressId)
    local fight = Fight.Instance
    if not fight or not DataTask[taskId] then
        return
    end

    local mapId = mod.WorldMapCtrl.mapId
    local taskConfig = DataTask[taskId]
    if taskConfig.map_id ~= mapId then
        return
    end
    if not progressId then
        progressId = self:GetCurNeedGuideProgress(taskId)
    end

    if not taskConfig.task_position[progressId] and not taskConfig.trace_eco_id[progressId] then
        progressId = 1
    end

    local taskPos, mapPositionCfg
    if taskConfig.task_position[progressId] then
        taskPos = taskConfig.task_position[progressId]
        mapPositionCfg = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(taskConfig.position_id, taskPos[2], taskPos[1])
    elseif taskConfig.trace_eco_id[progressId] then
        taskPos = taskConfig.trace_eco_id[progressId]
        mapPositionCfg = BehaviorFunctions.GetEcoEntityBornPosition(taskConfig.trace_eco_id[progressId])
    else
        return
    end

    return Vec3.New(mapPositionCfg.x, mapPositionCfg.y, mapPositionCfg.z)
end

function TaskCtrl:GetAreaTask(areaId)
    return self.areaInTask[areaId]
end

function TaskCtrl:ChangeGuideTask(taskId)
    return mod.TaskFacade:SendMsg("task_trace", taskId)
end

function TaskCtrl:SetGuideTaskId(taskId, guideProgress)
    self.guideTaskId = taskId
    EventMgr.Instance:Fire(EventName.GuideTaskChange, taskId, guideProgress)
end

function TaskCtrl:GetGuideTaskId()
    return self.guideTaskId
end

function TaskCtrl:UpdateGuideTask()
    local taskId = self.guideTaskId
    local condition = self.taskMap[taskId].condition
    local taskConfig = self.taskMap[taskId].taskConfig
    local guideTarget = taskConfig.task_position[1] and taskConfig.task_position or taskConfig.trace_eco_id

    if #condition == 1 or #condition ~= #guideTarget then
        self:ChangeCurGuideProgress(1)
    else
        local changeGuide = false
        for i = 1, #condition do
            local request = self:GetTaskProgressRequest(taskId, i)
            if request and request > condition[i] and not changeGuide then
                changeGuide = true
                self:ChangeCurGuideProgress(i)
            elseif request and request <= condition[i] then
                EventMgr.Instance:Fire(EventName.RemoveTaskProgressGuide, i)
            end
        end
    end
end

function TaskCtrl:ChangeCurGuideProgress(progressId)
    if not self.guideTaskId or self.guideTaskId == 0 then
        return
    end

    local task = self:GetTask(self.guideTaskId)
    task.guideProgress = progressId
	EventMgr.Instance:Fire(EventName.GuideTaskChange, self.guideTaskId, progressId)
end

function TaskCtrl:GetGuideTaskDesc()
    if not self.guideTaskId or self.guideTaskId == 0 then
        return
    end

    local taskConfig = self:GetTaskConfig(self.guideTaskId)
    return self:GetTaskTargets(taskConfig, true)
end

-- 应该不会有没有任务的情况出现
function TaskCtrl:GetTaskTargets(config, needProgress)
    local targets = {}
    local task = self.taskMap[config.id]

    if needProgress and next(config.progress_desc) then
        table.insert(targets, config.progress_desc[task.guideProgress])
    elseif config.show_progress_desc then
        for i = 1, #config.progress_desc do
            local request = self:GetTaskProgressRequest(config.id, i)
            local cur = task.condition[i]
            if cur < request then
                table.insert(targets, config.progress_desc[i])
            end
        end
    elseif config.show_progress then
        local compelte = 0
        local total = #task.condition
        for i = 1, total do
            local cur = task.condition[i]
            local request = self:GetTaskProgressRequest(task.taskId, i)
            if request <= cur then
                compelte = compelte + 1
            end
        end
        table.insert(targets, string.format("%s(%s/%s)", config.task_goal, compelte, total))
    else
        table.insert(targets, config.task_goal)
    end

    return targets
end

function TaskCtrl:GetTaskProgressNum(taskId, progressId)
    if not self.taskMap[taskId] or not self.taskMap[taskId].condition then
        return 0
    end

    return self.taskMap[taskId].condition[progressId]
end

function TaskCtrl:GetTaskProgressRequest(taskId, progressId)
    if not DataTask[taskId] then
        return
    end

    local goal = DataTask[taskId].goal
    if not goal[progressId] then
        return
    end

    if goal[progressId][1] ~= "client_control" then
        return 1
    end

    if not goal[progressId][2][1] then
        return 1
    end

    return tonumber(goal[progressId][2][1])
end

function TaskCtrl:GetCurNeedGuideProgress(taskId)
    if not taskId  then
        taskId = self.guideTaskId
    end

	if not self.taskMap[taskId] then
        return
    end

    for k, v in pairs(self.taskMap[taskId].condition) do
        local request = self:GetTaskProgressRequest(taskId, k)
        if request and request > v then
            return k
        end
    end
end

function TaskCtrl:CheckIsGuideTask(taskId, progressId)
    if not self.guideTaskId or self.guideTaskId == 0 then
        return false
    end

    local task = self:GetTask(self.guideTaskId)
    return self.guideTaskId == taskId and task.guideProgress == progressId
end

-- 临时 后续修改成客户端接取任务 Balabala
function TaskCtrl:RefreshNpcAcceptTask()
    local info = mod.WorldLevelCtrl:GetAdventureInfo()
    local playerLvl = info.lev
    if not playerLvl then
        return
    end

    local acceptTask = {}
    for k, v in pairs(DataTask) do
        if self:CheckTaskIsFinish(k) or self.taskMap[k] or v.auto_accept or v.npc_id == 0 then
            goto continue
        end

        if playerLvl < v.accept_lev then
            goto continue
        end

        local isPreTaskDone = true
        for i = 1, #v.accept_pre_task do
            if not self:CheckTaskIsFinish(v.accept_pre_task[i]) then
                isPreTaskDone = false
                break
            end
        end

        if not isPreTaskDone then
            goto continue
        end

        if self.npcOccupyTask[v.npc_id] or (acceptTask[v.npc_id] and v.id < acceptTask[v.npc_id].id) then
            goto continue
        end

        local jumpCfg = Config.DataNpcSystemJump.Find[v.npc_accept_jumpid]
        acceptTask[v.npc_id] = { id = v.id, icon = jumpCfg.icon, dialogId = v.npc_accept_dialog, jumpId = v.npc_accept_jumpid }

        ::continue::
    end

    for k, v in pairs(self.npcAcceptTask) do
        if acceptTask[k] then
            self.npcAcceptTask[k] = acceptTask[k]
            acceptTask[k] = nil
        elseif not acceptTask[k] then
            self.npcAcceptTask[k] = nil
        end
    end

    for k, v in pairs(acceptTask) do
        self.npcAcceptTask[k] = v
    end

    EventMgr.Instance:Fire(EventName.RefreshNpcAcceptTask)
end

function TaskCtrl:GetAllNpcAcceptTask()
    return self.npcAcceptTask
end

function TaskCtrl:GetNpcAcceptDialog(npcId)
    if not self.npcAcceptTask[npcId] then
        return
    end

    return self.npcAcceptTask[npcId].dialogId
end

function TaskCtrl:GetNpcAcceptJumpId(npcId)
    if not self.npcAcceptTask[npcId] then
        return
    end

    return self.npcAcceptTask[npcId].jumpId
end

function TaskCtrl:GetNpcAcceptTask(npcId)
    if not self.npcAcceptTask[npcId] then
        return
    end

    return self.npcAcceptTask[npcId].id
end

function TaskCtrl:CheckIsShowReward(taskId)
    local taskCfg = self:GetTaskConfig(taskId)
    return taskCfg.show_award_window
end

function TaskCtrl:SendTaskProgress(taskId, progressId, progress, type)
    local customType = type and type or 0
    mod.TaskFacade:SendMsg("task_client_add_progress", taskId, progressId, progress, customType)
end

function TaskCtrl:ResetTaskProgress(taskId)
    mod.TaskFacade:SendMsg("task_reset_progress", taskId)
end

function TaskCtrl:AcceptTask(taskId)
    mod.TaskFacade:SendMsg("task_accept", taskId)
end