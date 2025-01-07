---@class TaskCtrl : Controller
TaskCtrl = BaseClass("TaskCtrl", Controller)

local _tInsert = table.insert
local _tRemove = table.remove

local DataTask = Config.DataTask.data_task_Shifted
local DataTaskStepCount = Config.DataTask.data_task_Countbyid
local DataTaskType = Config.DataTaskType.Find
local NodeToType = Config.DataTaskType.FindNodesInfo
local DataTaskNode = Config.DataTaskNode.data_task_node
local TaskToNode = Config.DataTaskNode.FindTasksInfo
local DataTaskReward = Config.DataTaskReward.Find --奖励弹窗任务表
local DataTaskNpcOccupy = Config.DataTaskNpcOccupy.Shifted

function TaskCtrl:__init()
    -- 总任务数据
    self.taskMap = {}

    -- 总任务数据 按照章节集合
    self.taskTypeMap = {}

    -- 总任务数据 按节点集合
    self.taskNodeMap = {}

    -- 当前的梦回ID 如果是0就在现实
    self.dreamId = 0

    -- 现实数据线 章节ID 当前节点位置 节点路径信息
    self.realTaskRoute = {}

    -- 回溯数据线 现实数据线结构 开启节点 继承存档index
    self.dreamTaskRoute = {}

    -- 给更新任务状态的时候加个判断 代表服务器当前的指引任务
    self.guideTaskId = nil

    -- 已经完成的任务数据
    self.finishTask = {}
    self.finishTaskNode = {}

    -- 区域正在任务占用
    self.areaInTask = {}

    -- 任务占用记录
    self.areaOccupyTask = {}
    self.npcOccupyTask = {}

    -- NPC接取占用
    self.npcAcceptTask = {}

    -- 已经领取奖励的任务id
    self.ReceivedTaskID = {}

    -- startFight会触发的任务
    self.startTask = {}

    --多目标任务当前选择的下表
    self.targetConfig = nil

    --当前选中的任务节点
    self.selectTaskInfo = nil
    --当前章节
    self.curSecType = {}

    --退出的任务
    self.exitTask = {}
    

    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryDialogEnd"))
end

function TaskCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryDialogEnd"))
end

--#region 上线初始化任务信息
function TaskCtrl:InitTaskInfo(data)
    self.dreamId = data.dream_id or 0

    -- 获取完成任务信息
    if data.task_node_finished then
        -- self:_AddNodeListInfo(data.task_node_finished, nil, nil, true)
        for k, v in pairs(data.task_node_finished) do
            self.finishTaskNode[k] = true
            for i = 1, #v do
                self.finishTask[v[i]] = true
            end
        end
    end

    -- 更新当前的路线
    if data.task_group then
        for i = 1, #data.task_group do
            self:InitRealRoute(data.task_group[i])
        end
    end

    -- 更新梦回存档
    if data.task_dream then
        for i = 1, #data.task_dream do
            self:InitDreamRoute(data.task_dream[i])
        end
    end


    -- 设置追踪中的任务
    self:SetGuideTaskId(data.task_trace)
end

function TaskCtrl:InitRealRoute(route)
    local mType = route.type
    local sType = route.sec_type

    -- 一些保护措施
    if not self.realTaskRoute[mType] then
        self.realTaskRoute[mType] = {}
    end

    if not self.realTaskRoute[mType][sType] then
        self.realTaskRoute[mType][sType] = {}
    end

    if not self.taskTypeMap[mType] then
        self.taskTypeMap[mType] = {}
    end

    if not self.taskTypeMap[mType][sType] then
        self.taskTypeMap[mType][sType] = {}
    end

    self.realTaskRoute[mType][sType].curNode = route.current_node
    self.realTaskRoute[mType][sType].nodes = self:_AddNodeListInfo(route.task_node, mType, sType)
end

function TaskCtrl:InitDreamRoute(route)
    local mType = route.type
    local sType = route.sec_type

    -- 一些保护措施
    if not self.dreamTaskRoute[route.dream_id] then
        self.dreamTaskRoute[route.dream_id] = {}
    end

    if not self.taskTypeMap[mType] then
        self.taskTypeMap[mType] = {}
    end

    if not self.taskTypeMap[mType][sType] then
        self.taskTypeMap[mType][sType] = {}
    end

    self.dreamTaskRoute[route.dream_id].startNode = route.start_node
    self.dreamTaskRoute[route.dream_id].curNode = route.current_node
    self.dreamTaskRoute[route.dream_id].nodes = self:_AddNodeListInfo(route.task_node, mType, sType)
    self.dreamTaskRoute[route.dream_id].type = mType
    self.dreamTaskRoute[route.dream_id].sType = sType
end

--#endregion

-- 初始化的时候批量添加节点信息
function TaskCtrl:_AddNodeListInfo(nodes, mType, sType, isFinished)
    local typeNodes = {}
    for nodeId, nodeInfo in pairs(nodes) do
        local nodeTaskInfo = self:_AddNodeInfo(nodeInfo, mType, sType, isFinished)
        typeNodes[nodeId] = nodeTaskInfo
    end
    return typeNodes
end

-- 添加单个节点信息
function TaskCtrl:_AddNodeInfo(node, mType, sType)
    local nodeId = node.node_id
    local nodeTaskInfo = {}
    if not self.taskNodeMap[nodeId] then
        self.taskNodeMap[nodeId] = {}
    end

    local curNode = self.realTaskRoute[mType][sType].curNode
    -- 节点添加的时候是把所有任务都接取到的
    for i = 1, #node.task_list do
        local task = node.task_list[i]
        -- 过去的节点 只有完成了才要记录到节点里面
        if task.finish or nodeId == curNode then
            self:_AddTask(task, nodeId, mType, sType)
            _tInsert(nodeTaskInfo, task.id)
        end
    end

    return nodeTaskInfo
end

-- 更新节点信息 只有在收到新节点的时候才会更新 所以要把老的节点信息给去掉
function TaskCtrl:UpdateTaskNodeInfo(node)
    local nodeType = NodeToType[node.node_id]
    if not nodeType then
        return
    end
    local mType = nodeType.type
    local sType = nodeType.sec_type

    if not self.dreamId or self.dreamId == 0 then
        local isNewType = not self.realTaskRoute[mType] or not self.realTaskRoute[mType][sType]
        if isNewType then
            if not self.realTaskRoute[mType] then
                self.realTaskRoute[mType] = {}
            end

            if not self.realTaskRoute[mType][sType] then
                self.realTaskRoute[mType][sType] = {}
            end

            if not self.realTaskRoute[mType][sType].nodes then
                self.realTaskRoute[mType][sType].nodes = {}
            end

            if not self.taskTypeMap[mType] then
                self.taskTypeMap[mType] = {}
            end

            if not self.taskTypeMap[mType][sType] then
                self.taskTypeMap[mType][sType] = {}
            end

            self.realTaskRoute[mType][sType].nodes = {}
            self.realTaskRoute[mType][sType].curNode = node.node_id
        end

        if not isNewType then
            -- 清除老节点的任务（未完成的）
            local curNode = self.realTaskRoute[mType][sType].curNode
            if not curNode or not self.realTaskRoute[mType][sType].nodes then
                return
            end

            for i = #self.realTaskRoute[mType][sType].nodes[curNode], 1, -1 do
                local taskId = self.realTaskRoute[mType][sType].nodes[curNode][i]
                if not self:CheckTaskIsFinish(taskId) then
                    self:RemoveTask(taskId)
                    self.realTaskRoute[mType][sType].nodes[curNode][i] = nil
                end
            end

            -- 记录老的节点已经完成了
            self.finishTaskNode[curNode] = true
            -- 更换当前节点
            self.realTaskRoute[mType][sType].curNode = node.node_id
        end

        -- 把这个新节点的信息加上
        self.realTaskRoute[mType][sType].nodes[node.node_id] = self:_AddNodeInfo(node, mType, sType)
    else
        -- TODO 梦回的再说吧
    end
end

-- 只是更新单个任务的步骤、状态信息了
function TaskCtrl:UpdateTaskStateList(data)
    for i = 1, #data.task_list do
        self:_updateSingleTaskState(data.task_list[i])
    end
end

function TaskCtrl:_updateSingleTaskState(task)
    local originTask = self:GetTask(task.id)
    -- 更新任务的地方不做添加任务的事情 在节点更新的时候会把所有的任务都添加进来的
    if not originTask then
        return
    end

    local isSameStep = originTask.stepId == task.stepId
    local isSameProgress = task.in_progress == originTask.inProgress
    -- 任务完成了呗
    if (not originTask.isFinish or not isSameStep) and task.finish then
        self.taskMap[task.id].stepId = task.step
        self.taskMap[task.id].isFinish = true
        if task.step == DataTaskStepCount[task.id] then
            self:OnTaskFinish(task.id)
        else
            self:OnTaskStepFinish(task.id, originTask.stepId)
        end
        return
    end

    -- 任务不进行了也处理一下就算了 占用和运行相关的会有其他地方处理的
    if not task.in_progress then
        self.taskMap[task.id].inProgress = task.in_progress
        return
    end

    local taskInfo = {}
    taskInfo.taskId = task.id
    taskInfo.stepId = task.step
    taskInfo.inProgress = task.in_progress
    taskInfo.isFinish = task.finish

    taskInfo.progress = {}
    taskInfo.progress[task.progress.id] = task.progress.current

    self.taskMap[task.id] = taskInfo

    -- 如果不是同一步也要刷新一下指引目标点捏 当然要得是当前正在指引的任务才更新
    if not isSameStep or not isSameProgress then
        EventMgr.Instance:Fire(EventName.AddTask, task.id, true)
        local taskCfg = self:GetTaskConfig(task.id, task.step)
        if not taskCfg then
            return
        end
        if self.exitTask[taskCfg.id] then--如果是退出的任务就不进行加载
            return
        end
        if self.guideTaskId == taskCfg.id and not taskCfg.is_hide_task then
            self:SetGuideTaskId(task.id)
        end
    end
end

-- 添加任务
function TaskCtrl:_AddTask(task, nodeId, mType, sType)
    -- 如果任务做完了做一下记录
    if task.finish then
        self.finishTask[task.id] = true
        if not self:CheckTaskIsFinishAhead(task) then
            return
        end
    end

    local taskInfo = {}
    taskInfo.taskId = task.id
    taskInfo.stepId = task.step
    taskInfo.isFinish = task.finish
    taskInfo.inProgress = task.in_progress

    taskInfo.progress = {}
    taskInfo.progress[task.progress.id] = task.progress.current

    -- 做任务记录
    self.taskMap[task.id] = taskInfo
    self.taskNodeMap[nodeId][task.id] = true
    self.taskTypeMap[mType][sType][task.id] = true

    if not task.in_progress then
        return taskInfo
    end

    if task.in_progress and not Fight.Instance then
        self.startTask[task.id] = true
    end

    -- TODO 如果当前没有指引的任务的话 指引一下 临时方案
    local taskCfg = self:GetTaskConfig(task.id, task.step)
    local canGuide = not self.guideTaskId and taskCfg.auto_trace and not taskCfg.is_hide_task
    if canGuide then
        self:SetGuideTaskId(task.id)
    end

    -- 添加任务占用记录
    self:AddOccupyTaskRecord(taskCfg)
    EventMgr.Instance:Fire(EventName.AddTask, task.id, true)

    return taskInfo
end

-- 添加任务绑定队列
function TaskCtrl:AddOccupyTaskRecord(taskCfg, inProgress)
    if not taskCfg then
        return
    end
    local taskId = taskCfg.id
    local stepId = taskCfg.step
    -- 区域占用
    for _, areaId in pairs(taskCfg.proceed_area) do
        if not self.areaOccupyTask[areaId] then
            self.areaOccupyTask[areaId] = {}
        end

        if inProgress then
            self.areaInTask[areaId] = taskId
        end

        -- table.insert(self.areaOccupyTask[areaId], taskId)
        self.areaOccupyTask[areaId][taskId] = true
    end

    -- NPC占用
    local occupyCfg = self:GetTaskOccupyConfig(taskId, stepId)
    if not occupyCfg then
        return
    end

    for npcId, v in pairs(occupyCfg.occupy_list) do
        if not self.npcOccupyTask[npcId] then
            self.npcOccupyTask[npcId] = {}
        end

        self.npcOccupyTask[npcId][taskId] = true
    end
end

-- 取消任务占用 置为空
function TaskCtrl:CancelOccupyTask(taskId, stepId)
    local taskCfg = self:GetTaskConfig(taskId, stepId)
    if not taskCfg then
        return
    end

    -- 区域占用
    for _, areaId in pairs(taskCfg.proceed_area) do
        if self.areaInTask[areaId] == taskId then
            self.areaInTask[areaId] = nil
        end
    end

    -- NPC占用
    -- 取消占用也要刷新一下可接取任务的npc
    -- self:RefreshNpcAcceptTask()

    -- EventMgr.Instance:Fire(EventName.OccupyTaskChange)
end

-- 删除任务占用
function TaskCtrl:DeleteOccupyTask(taskId, stepId)
    local taskCfg = self:GetTaskConfig(taskId, stepId)
    if not taskCfg then
        return
    end

    -- 区域占用
    for _, areaId in pairs(taskCfg.proceed_area) do
        if self.areaInTask[areaId] == taskId then
            self.areaInTask[areaId] = nil
        end

        self.areaOccupyTask[areaId][taskId] = nil
    end

    -- NPC占用
    local occupyCfg = self:GetTaskOccupyConfig(taskId, stepId)
    if not occupyCfg then
        return
    end

    for npcId, v in pairs(occupyCfg.occupy_list) do
        if self.npcOccupyTask[npcId] then
            self.npcOccupyTask[npcId][taskId] = nil
        end
    end
end

-- 更换任务占用
function TaskCtrl:ChangeOccupyTask(taskId, stepId)
    local taskCfg = self:GetTaskConfig(taskId, stepId)
    if not taskCfg then
        return
    end

    for k, v in pairs(taskCfg.proceed_area) do
        self.areaInTask[v] = taskId
    end

    EventMgr.Instance:Fire(EventName.OccupyTaskChange, taskId, true)
end

-- 获取所有被任务占用的区域
function TaskCtrl:GetAllAreaOccupyTask()
    return self.areaOccupyTask
end

-- 获取目标区域有多少任务占用
function TaskCtrl:GetAreaOccupyTask(areaId)
    return self.areaOccupyTask[areaId]
end

-- 获取所有被任务占用的NPC信息
function TaskCtrl:GetAllNpcOccupyTask()
    return self.npcOccupyTask
end

-- 获取目标NPC有多少任务占用
function TaskCtrl:GetNpcOccupyTask(npcId)
    return self.npcOccupyTask[npcId]
end

-- 移除任务
function TaskCtrl:RemoveTask(taskId)
    if not self.taskMap[taskId] then
        return
    end

    self.taskMap[taskId] = nil
    local nodeId = self:GetNodeOfTask(taskId)
    if not nodeId then
        LogError("任务不在任何节点内 taskId = "..taskId)
        return
    end

    self.taskNodeMap[nodeId][taskId] = nil

    local nodeType = NodeToType[nodeId]
    self.taskTypeMap[nodeType.type][nodeType.sec_type][taskId] = nil
end

-- 检查任务完成了吗
function TaskCtrl:CheckTaskIsFinish(taskId)
    if not taskId or taskId == 0 then return true end
    return self.finishTask[taskId]
end

function TaskCtrl:ShowTaskFinishList()
    for k, v in pairs(self.finishTask) do
        print(k)
    end
end

function TaskCtrl:ShowTaskNodeFinishList()
    for k, v in pairs(self.finishTaskNode) do
        print(k)
    end
end

-- 检查任务节点完成了吗
function TaskCtrl:CheckTaskNodeIsFinish(nodeId)
    if nodeId == 0 then return true end
    return self.finishTaskNode[nodeId]
end


-- 检查任务步骤完成了吗
function TaskCtrl:CheckTaskStepIsFinish(taskId, stepId)
    if not taskId or taskId == 0 then
        return true
    end

    if self.finishTask[taskId] then
        return true
    end

    local task = self:GetTask(taskId)
    return task and (task.stepId > stepId or (task.stepId == stepId and task.isFinish))
end

-- 检查任务在不在做
function TaskCtrl:CheckTaskIsInProgress(taskId)
    if not self.taskMap[taskId] then
        return false
    end

    return self.taskMap[taskId].inProgress
end

-- 检查目标区域是否正在被任务占用
function TaskCtrl:CheckAreaIsInTask(areaId)
    return self.areaInTask[areaId] ~= nil
end

function TaskCtrl:GetTastTypeMap()
    return self.taskTypeMap
end

-- 任务步骤完成
function TaskCtrl:OnTaskStepFinish(taskId, stepId)
    local taskConfig = self:GetTaskConfig(taskId, stepId)
    if not taskConfig or self.finishTask[taskId] then
        return
    end

    EventMgr.Instance:Fire(EventName.TaskFinish, taskId, stepId)

    -- 在TaskManager里面播放结束的旁白
    if taskConfig.ending_dialog ~= 0 then
        self.endingDialog = { taskId = taskId, dialogId = taskConfig.ending_dialog }
        EventMgr.Instance:Fire(EventName.TaskPreFinish, taskId, stepId)
    end

    self:DeleteOccupyTask(taskId, stepId)
end

-- 任务完成 默认处理最后一步任务步骤
function TaskCtrl:OnTaskFinish(taskId)
    if not self.taskMap[taskId] then
        return
    end

    local stepCount = DataTaskStepCount[taskId]
    if not stepCount then
        return
    end

    self:OnTaskStepFinish(taskId, stepCount)
    self.finishTask[taskId] = true


    self:RemoveTask(taskId)

    if mod.GmCtrl.autoClone then
        local name = string.format("%s_%s",mod.LoginCtrl.account,taskId)
        mod.GmFacade:SendMsg("gm_exec", "admin_clone_account", {name})
        Log("自动复制账号： "..name)
    end

    -- TODO 临时处理
    local taskCfg = self:GetTaskConfig(taskId, stepCount)
    if not taskCfg or taskCfg.show_id == 0 then
        return
    end

    local mulTask = self:GetMulTasks(taskCfg.show_id)
    for k, v in pairs(mulTask) do
        if self:CheckTaskIsFinish(v.id) then
            self:ChangeGuideTask(v.id)
            break
        end
    end

	--if self:CheckTaskInChapterProgress(taskId) then
    --    self:CheckIsChapterWindow(taskId)
    --	EventMgr.Instance:Fire(EventName.TaskRewardRed)
	--end
end

function TaskCtrl:OnStoryDialogEnd(dialogId)
    if self.endingDialog and self.endingDialog.dialogId == dialogId then
        TableUtils.ClearTable(self.endingDialog)
    end
end

function TaskCtrl:GetTaskList(taskType, subType)
    if not self.taskTypeMap[taskType] then
        return
    end

    local taskMap = self.taskTypeMap[taskType][subType]
    if not taskMap then
        return
    end

    local list = {}
    for k, v in pairs(taskMap) do
        table.insert(list, v)
    end
    
    return list
end

function TaskCtrl:GetAllTask()
    return self.taskMap
end

-- TODO 检查调用的地方
function TaskCtrl:GetTask(taskId)
    return self.taskMap[taskId]
end

-- 获取当前任务的步骤
function TaskCtrl:GetTaskStep(taskId)
    if not self.taskMap[taskId] then
        return
    end

    return self.taskMap[taskId].stepId
end

-- 获取任务总共有多少步
function TaskCtrl:GetTaskStepCount(taskId)
    return DataTaskStepCount[taskId]
end


function TaskCtrl:GetDataTaskType(taskId,stepId)
    local key = UtilsBase.GetDoubleKeys(taskId, stepId, 32)
    return DataTaskType[key]
end

function TaskCtrl:GetTaskType(taskId)
    local nodeId = self:GetNodeOfTask(taskId)
    if not nodeId then
        return
    end

    local nodeType = NodeToType[nodeId]
    local mType = nodeType.type
    local sType = nodeType.sec_type

    return mType, sType
end

function TaskCtrl:GetTaskConfig(taskId, stepId)
    if self:CheckTaskIsMultarget(taskId) and self.targetConfig then
        return self.targetConfig
    end

    if not stepId then
        stepId = self:GetTaskStep(taskId)
    end

    if not stepId then
        return
    end

    local key = UtilsBase.GetDoubleKeys(taskId, stepId, 32)
    return DataTask[key]
end

-- 获取节点配置
function TaskCtrl:GetTaskNodeConfig(nodeId)
    return DataTaskNode[nodeId]
end

function TaskCtrl:GetTaskOccupyConfig(taskId, stepId)
    local key = UtilsBase.GetDoubleKeys(taskId, stepId, 32)
    return DataTaskNpcOccupy[key]
end

function TaskCtrl:CheckIsTaskOccupyNpc(taskId, stepId, npcId)
    local occupyCfg = self:GetTaskOccupyConfig(taskId, stepId)
    if not occupyCfg then
        return false
    end

    for k, v in pairs(occupyCfg.occupy_list) do
        if npcId == k then
            return true
        end
    end

    return false
end

function TaskCtrl:GetGuideTaskId()
    return self.guideTaskId
end

function TaskCtrl:GetGuideTaskPosition()
    if not self.guideTaskId then
        return
    end

    return self:GetTaskPositionById(self.guideTaskId)
end

function TaskCtrl:GetTaskPositionById(taskId)
    local stepId = self:GetTaskStep(taskId)
    if not stepId then
        return
    end

    local taskConfig = self:GetTaskConfig(taskId, stepId)
    if not Fight.Instance or not taskConfig or taskConfig.map_id ~= Fight.Instance:GetFightMap() then
        return
    end

    local taskPos = taskConfig.task_position
    local mapPositionCfg
    if taskPos and next(taskPos) then
        mapPositionCfg = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(taskConfig.position_id, taskPos[2], taskPos[1])
    elseif taskConfig.trace_eco_id and taskConfig.trace_eco_id~=0 then
        return BehaviorFunctions.GetEcoEntityPosition(taskConfig.trace_eco_id)
    end

    if not mapPositionCfg then
        return
    end

    return Vec3.New(mapPositionCfg.x, mapPositionCfg.y, mapPositionCfg.z)
end

-- 获取区域是否正在被任务占用
function TaskCtrl:GetAreaTask(areaId)
    return self.areaInTask[areaId]
end

-- 更换当前追踪的任务
function TaskCtrl:ChangeGuideTask(taskId)
    return mod.TaskFacade:SendMsg("task_trace", taskId)
end

--TODO施工中
function TaskCtrl:SetGuideTaskId(taskId)

    local orgainTaskInfo = self:GetTaskConfig(self.guideTaskId)

    if orgainTaskInfo then --如果追踪的任务是多目标任务的子类任务就返回
        if orgainTaskInfo.show_id == taskId and not self.exitTask[taskId] then
            return
        end
    end
    if taskId ~=0 and taskId then
        self:ResExitTask(taskId)
        self.guideTaskId = taskId
    end
    EventMgr.Instance:Fire(EventName.GuideTaskChange, taskId)

	-- if self:CheckTaskIsFinish(taskId) then
    -- 	return
	-- end
    
	--if self:CheckTaskInChapterProgress(taskId) then
    --    self:CheckIsChapterWindow(taskId, true)
	--end
end

function TaskCtrl:SetExitTask(taskId)
    self.exitTask[taskId] = true
end

function TaskCtrl:GetExitTask(taskId)
    return self.exitTask[taskId]
end

--检测任务是否是退出的任务
function TaskCtrl:ResExitTask(taskId)
    local taskConfig = self:GetTaskConfig(taskId)
    if not taskConfig then
        return
    end
    if taskConfig.exit_task and self.exitTask[taskId] then
        local stepId = mod.TaskCtrl:GetTaskStep(taskId)
        EventMgr.Instance:Fire(EventName.TaskBehaviorStateChange, taskId,stepId,true)
        local levelId = taskConfig.trigger[2][1]
        if levelId then
            BehaviorFunctions.AddLevel(tonumber(levelId), taskId)
        end
        self.exitTask[taskId] = nil
    end
end

-- 判断是否弹出章节开启窗口/结束窗口
function TaskCtrl:CheckIsChapterWindow(taskId, checkOpen)
    local nodeId = self:GetNodeOfTask(taskId)
    if not nodeId then
        return
    end

    local nodeType = NodeToType[nodeId]
    local mType = nodeType.type
    local sType = nodeType.sec_type
    -- 拿到该章节信息
    -- local taskChapterInfo = TaskConfig.GetTaskChapterInfo(taskInfo.type, taskInfo.sec_type)
    local taskChapterInfo = TaskConfig.GetTaskChapterInfo(mType, sType)
    if not taskChapterInfo then
        return
    end

    local checkId = checkOpen and taskChapterInfo.chapter_start or taskChapterInfo.chapter_end
    if taskId == checkId then
        local window = checkOpen and TaskChapterOpenWindow or TaskChapterCloseWindow
        local setting = {
            isWindow = true,
            args =  { taskId = taskId }
        }
        EventMgr.Instance:Fire(EventName.AddSystemContent, window, setting)
    end
end

-- 判断是否弹出章节结束窗口
-- function TaskCtrl:CheckIsChapterEndWindow(taskId)
--     local nodeId = TaskToNode[taskId]
--     if not nodeId then
--         return
--     end

--     local nodeType = NodeToType[nodeId]
--     local mType = nodeType[1]
--     local sType = nodeType[2]
--     -- 拿到该章节信息
--     -- local taskChapterInfo = TaskConfig.GetTaskChapterInfo(taskInfo.type, taskInfo.sec_type)
--     local taskChapterInfo = TaskConfig.GetTaskChapterInfo(mType, sType)
--     if taskChapterInfo and taskId == taskChapterInfo.chapter_end then
--         local setting = {
--             isWindow = true,
--             args =  {taskId = taskId}
--         }
--         EventMgr.Instance:Fire(EventName.AddSystemContent, TaskChapterCloseWindow, setting)
--     end
-- end

--判断该任务是否属于task_reward并且在章节进行中
function TaskCtrl:CheckTaskInChapterProgress(taskId)
    --仅当正在追踪主线任务时，追踪栏右侧会显示进度，点击该按钮可以进入章节弹窗
    -- local taskInfo = DataTask[taskId]
    -- if taskInfo and taskInfo.type == 1 then 
    --     return true 
    -- end
    -- return false
    if not taskId then
        return false
    end

    local nodeId = self:GetNodeOfTask(taskId)
    if not nodeId then
        return
    end

    local nodeType = NodeToType[nodeId]
    local mType
    if nodeType  then
         mType = nodeType.type
    end

    -- 要改成枚举
    return mType == 1
end

--判断章节弹窗有没有红点
function TaskCtrl:CheckTaskChapterIsRed()
    --遍历所有的章节
    for _, rewardInfo in pairs(DataTaskReward) do
        for i, v in pairs(rewardInfo.task_reward) do
            if v[1] ~= 0 then
                local isRed = self:CheckChapterIsRedByTaskId(v[1])
                if isRed then
                    return isRed
                end
            end
        end
    end
    return false
end

--判断该章节有没有红点
function TaskCtrl:CheckNowTaskChapterIsRed(selectTbId)
    local chapterInfo = DataTaskReward[selectTbId]
	if chapterInfo then
	    for i, v in pairs(chapterInfo.task_reward) do
	        if v[1] ~= 0 then
                local isRed = self:CheckChapterIsRedByTaskId(v[1])
	            if isRed then
	                return isRed
	            end
	        end
	    end
	end
    return false
end

--判断章节任务的红点
function TaskCtrl:CheckChapterIsRedByTaskId(taskId)
    if not self:CheckTaskIsFinish(taskId) then
        return false
    end

    return not self:CheckTaskIsReceived(taskId)
end

-- TODO 没有修改指引目标的必要了 只支持修改指引任务
-- function TaskCtrl:ChangeCurGuideProgress(progressId)
--     if not self.guideTaskId or self.guideTaskId == 0 then
--         return
--     end

--     local task = self:GetTask(self.guideTaskId)
--     task.guideProgress = progressId
-- 	EventMgr.Instance:Fire(EventName.GuideTaskChange, self.guideTaskId, progressId)
-- end

-- 获得当前指引的任务描述
function TaskCtrl:GetGuideTaskDesc()
    if not self.guideTaskId or self.guideTaskId == 0 then
        return
    end

    local step = self:GetTaskStep(self.guideTaskId)
    local taskConfig = self:GetTaskConfig(self.guideTaskId, step)
    if not taskConfig then
        return
    end

    if Fight.Instance then
        if not Fight.Instance.taskManager:IsInTimeArea(self.guideTaskId) then
            return taskConfig.no_task_time_desc or TI18N("不在任务时间")
        end
    end

    return taskConfig.task_goal
end

function TaskCtrl:GetGuideTaskConfig()
    if not self.guideTaskId or self.guideTaskId == 0 then
        return
    end

    local step = self:GetTaskStep(self.guideTaskId)
    local taskConfig = self:GetTaskConfig(self.guideTaskId, step)
    if not taskConfig then
        return
    end

    if Fight.Instance then
        if not Fight.Instance.taskManager:IsInTimeArea(self.guideTaskId) then
            return taskConfig.no_task_time_desc or TI18N("不在任务时间")
        end
    end

    return taskConfig
end



-- 获取多目标任务
function TaskCtrl:GetTaskTargets(taskId)
    if not taskId then
        if self.targetConfig  then
            taskId = self.targetConfig.show_id
        end
        if self.selectTaskInfo then
            taskId = self.selectTaskInfo.taskId
        end
    end

    local targets = {}
    for id, config in pairs(DataTask) do
        if not config.show_id or config.show_id == 0 then
            goto continue
        end
        if config.show_id == taskId and not self:CheckTaskIsFinish(config.id) then
            local step = self:GetTaskStep(config.id)
            if step == config.step then
                _tInsert(targets,config)
            end
        end
        ::continue::
    end
    local  sortByStep = function(a,b)
        return a.id<b.id
    end
    table.sort(targets,sortByStep)
    return targets
end

function TaskCtrl:GetStartTask()
    return self.startTask
end

function TaskCtrl:ClearStartTask()
    self.startTask = {}
end

function TaskCtrl:GetEndingDialog()
    return self.endingDialog
end

-- 背包给奖励的地方
function TaskCtrl:CheckIsShowReward(taskId, stepId)
    if not stepId then
        stepId = self:GetTaskStep(taskId)
    end

    local taskCfg = self:GetTaskConfig(taskId, stepId)
    if not taskCfg then
        return false
    end

    return taskCfg.show_award_window
end

-- TODO 确认是否还需要Progress
function TaskCtrl:SendTaskProgress(taskId, stepId, progress, callback)
    local orderId, protoId = mod.TaskFacade:SendMsg("task_client_add_progress", taskId, stepId, progress)
    mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function (noticeCode)
        if callback then callback(noticeCode) end
    end)
end

function TaskCtrl:CheckValueInList(List,value)
    for key, v in pairs(List) do
        if v == value then
            return true
        end
    end
    return false
end

-- 更新已经获得章节奖励的奖励节点信息
function TaskCtrl:UpdateReceivedTaskID(data)
    for i, taskId in pairs(data) do
        self.ReceivedTaskID[taskId] = taskId
    end
    EventMgr.Instance:Fire(EventName.RecivedTaskReward)
    EventMgr.Instance:Fire(EventName.TaskRewardRed)
end

function TaskCtrl:CheckTaskIsReceived(taskId)
    return self.ReceivedTaskID[taskId]
end

function TaskCtrl:GetNodeOfTask(taskId)
    if not TaskToNode[taskId] then
        return
    end

    local nodeId = TaskToNode[taskId].id
    return nodeId
end

function TaskCtrl:GetMulTasks(taskId)
    local tasks = {}
    if not DataTask then
       return tasks
    end
    for key, v in pairs(DataTask) do
        if v.show_id == taskId  then
            _tInsert(tasks,v)
        end
    end
    return tasks
end

function TaskCtrl:CheckTaskIsMultarget(taskId)
    for key, v in pairs(self:GetMulTasks(taskId)) do
        if v.show_id and v.show_id ~=0 and v.id~= taskId then
           return true
        end
    end
    return false
end

function TaskCtrl:SetSelectTaskInfo(taskInfo)
    self.selectTaskInfo = taskInfo
end

function TaskCtrl:SetMulTarget(config)
    self.targetConfig = config
end

function TaskCtrl:GetMulTarget()
    if self.targetConfig then
        return self.targetConfig
    end
    return nil
end

--检查任务是否是提前完成的（例如提前激活传送点等）
function TaskCtrl:CheckTaskIsFinishAhead(task)
   local nodeId = self:GetNodeOfTask(task.id)
   if not self.finishTaskNode[nodeId] and not self.taskMap[task.id] then
    return true
   end
   return false
end

--检查章节是否发生变化
function TaskCtrl:CheckTaskTypeChange(taskId)
    local taskConfig = self:GetTaskConfig(taskId)
    if not taskConfig then
        return false
    end
    -- if taskConfig.is_hide_task then
    --     return false
    -- end
    local secType,type = self:GetTaskType(taskId)
    local result = false
    if secType and type then
        if next(self.curSecType) then
            result = secType == self.curSecType.sec_type
            and type==self.curSecType.type
        end
        self.curSecType.sec_type = secType
        self.curSecType.type = type
    end
    return  not result
end

--任务的开始时间，存前端，用于做等待指定时间的任务
function TaskCtrl:SetDayNightTime(taskId, time)
    self.taskMap[taskId].dayNightTime = self.taskMap[taskId].dayNightTime or time
end

function TaskCtrl:GetDayNightTime(taskId)
    return self.taskMap[taskId].dayNightTime
end