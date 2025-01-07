TaskManager = BaseClass("TaskManager")

function TaskManager:__init(fight)
    self.fight = fight

    self.guideTask = nil
    self.curGuideMarks = {}
    self.curGuidePointer = {}

    self.taskBehavior = {}

    self.canAcceptNpc = {}

    self.inited = false

    -- 添加对taskCtrl的监听
    EventMgr.Instance:AddListener(EventName.RefreshNpcAcceptTask, self:ToFunc("RefreshNpcAcceptTask"))
    EventMgr.Instance:AddListener(EventName.AddTask, self:ToFunc("AddTask"))
    EventMgr.Instance:AddListener(EventName.GuideTaskChange, self:ToFunc("SetGuideTask"))
    EventMgr.Instance:AddListener(EventName.RemoveTaskProgressGuide, self:ToFunc("RemoveTaskProgressGuide"))
    EventMgr.Instance:AddListener(EventName.OccupyTaskChange, self:ToFunc("ChangeOccupyTask"))
    EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("RemoveTask"))
    EventMgr.Instance:AddListener(EventName.TaskPreFinish, self:ToFunc("OnTaskFinished"))
end

function TaskManager:StartFight()
    if self.fight:IsDebugMode() then
        return
    end

    self:InitTaskBehavior()
    self:SetNpcOccupyTaskInfo()
    self:SetNpcAcceptTaskInfo()
    -- 检测是否有完成的任务等待播放timeline
    local guideTaskId = mod.TaskCtrl:GetGuideTaskId()
    local guideProgress = mod.TaskCtrl:GetCurNeedGuideProgress(guideTaskId)
    self:SetGuideTask(guideTaskId, guideProgress)

    self.inited = true
end

function TaskManager:Update()
    local mapId = self.fight:GetFightMap()
    for _, v in pairs(self.taskBehavior) do
        if v.pause or v.map ~= mapId then
            goto continue
        end
        v.behavior:Update()
        ::continue::
    end
end

function TaskManager:InitTaskBehavior()
    local taskList = mod.TaskCtrl:GetAllTask()
    for k, v in pairs(taskList) do
        self:BindBehavior(v.taskId)
        self.fight.taskConditionManager:AddTask(v.taskId, true)
    end
end

function TaskManager:BindBehavior(taskId)
    local taskInfo = mod.TaskCtrl:GetTask(taskId)
    local taskConfig = taskInfo.taskConfig
    if not taskConfig or self.taskBehavior[taskId] then
        return
    end

    local behavior = taskConfig.behavior
    if not behavior or behavior == "" then
        return
    end

    behavior = _G[behavior].New(taskInfo)

    self.taskBehavior[taskId] = {}
    self.taskBehavior[taskId].behavior = behavior
    self.taskBehavior[taskId].map = taskInfo.mapId
end

function TaskManager:UnBindBehavior(taskId)
    if not taskId or not self.taskBehavior[taskId] then
        return
    end

    self.taskBehavior[taskId].behavior:DeleteMe()
    self.taskBehavior[taskId] = nil
end

function TaskManager:SetBehaviorPauseState(taskId, state)
    if not taskId or not self.taskBehavior[taskId] then
        return
    end

    self.taskBehavior[taskId].pause = state
end

function TaskManager:CallBehaviorFun(funcName, ...)
    for k, v in pairs(self.taskBehavior) do
        v.behavior.SuperFunc(v.behavior, funcName, true, ...)
    end
end

function TaskManager:AddTask(taskId, isNewTask)
    if not isNewTask then
        return
    end

    local taskCfg = mod.TaskCtrl:GetTaskConfig(taskId)
    local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(taskId)
    self:BindBehavior(taskId)
    if occupyCfg then
        self.fight.entityManager.npcEntityManager:BindTask(taskId)
    end

    if taskCfg.show_start_tips then
        local taskIcon = AssetConfig.GetTaskTypeIcon(taskCfg.type)
        BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.Task, taskCfg.task_name, nil, taskIcon)
    end
end

function TaskManager:ChangeOccupyTask(taskId)
    -- 暂停冲突的任务行为
    local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId)
    local occupyConfig = mod.TaskCtrl:GetTaskOccupyConfig(taskId)
    for k, v in pairs(taskConfig.proceed_area) do
        local areaOccupyTask = mod.TaskCtrl:GetAreaOccupyTask(v)
        if areaOccupyTask then
            for _, occupyTaskId in pairs(areaOccupyTask) do
                local task = mod.TaskCtrl:GetTask(occupyTaskId)
                if occupyTaskId == taskId or not task.inProgress then
                    goto continue
                end
                self:SetBehaviorPauseState(occupyTaskId, true)
                ::continue::
            end
        end
    end

    if occupyConfig then
        for k, npcId in pairs(occupyConfig.occupy_list) do
            local npcOccupyTask = mod.TaskCtrl:GetNpcOccupyTask(npcId)
            if npcOccupyTask then
                for _, occupyTaskId in pairs(npcOccupyTask) do
                    local task = mod.TaskCtrl:GetTask(occupyTaskId)
                    if occupyTaskId == taskId or not task.inProgress then
                        goto continue
                    end
                    self:SetBehaviorPauseState(occupyTaskId, true)
                    ::continue::
                end
            end
        end
    end

    self.fight.entityManager.npcEntityManager:BindTask(taskId)
    self:SetBehaviorPauseState(taskId, false)
end

function TaskManager:RemoveTask(taskId)
    local taskCfg = mod.TaskCtrl:GetTaskConfig(taskId)
    self:UnBindBehavior(taskId)
    if taskCfg.show_end_tips then
        BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.TaskEnd, taskCfg.task_name, true)
    end

    if self.guideTask and self.guideTask.taskId == taskId then
        self:SetGuideTask()
    end
end

function TaskManager:OnTaskFinished(taskId)
    local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId)
    if not taskConfig then
        return
    end

    BehaviorFunctions.StartStoryDialog(taskConfig.ending_dialog)
end

function TaskManager:SetGuideTask(taskId, guideProgress)
    if self.guideTask and self.guideTask.taskId == taskId then
        return
    end
    local taskConfig = nil
    if taskId then
        taskConfig = mod.TaskCtrl:GetTaskConfig(taskId)
    end

    if taskConfig and taskConfig.is_hide_task then
        return
    end

    if not taskId or taskId == 0 then
        self.guideTask = nil
    else
        local task = mod.TaskCtrl:GetTask(taskId)
        if task then
			self.guideTask = task
		else
			self.guideTask = { taskId = taskId, taskConfig = taskConfig }
		end
        self.guideTask.guideProgress = guideProgress
        if not self.guideTask.guideProgress then
            self.guideTask.guideProgress = mod.TaskCtrl:GetCurNeedGuideProgress()
        end
    end

    self:SetGuideTaskView()
    EventMgr.Instance:Fire(EventName.UIGuideTaskChange)
end

function TaskManager:SetNpcOccupyTaskInfo()
    local npcOccupyTask = mod.TaskCtrl:GetAllNpcAcceptTask()
    if not npcOccupyTask or not next(npcOccupyTask) then
        return
    end

    local npcManager = self.fight.entityManager.npcEntityManager
    for _, taskList in pairs(npcOccupyTask) do
        for k, v in pairs(taskList) do
            npcManager:BindTask(v)
        end
    end
end

function TaskManager:RefreshNpcAcceptTask()
    if not self.inited then
        return
    end

    self:SetNpcAcceptTaskInfo()
end

function TaskManager:SetNpcAcceptTaskInfo()
    local npcAcceptTask = mod.TaskCtrl:GetAllNpcAcceptTask()
    if not npcAcceptTask or not next(npcAcceptTask) then
        return
    end

    local npcManager = self.fight.entityManager.npcEntityManager
    for k, v in pairs(npcAcceptTask) do
        local npcCfg = npcManager:GetNpcConfig(k)
        self.canAcceptNpc[k] = true
        npcManager:SetNpcHeadIcon(k, v.icon)
        mod.WorldMapCtrl:ChangeEcosystemMark(npcCfg.map_id, k, v.jumpId)
    end

    for k, v in pairs(self.canAcceptNpc) do
        if not v then
            local npcCfg = npcManager:GetNpcConfig(k)
            npcManager:SetNpcHeadIcon(k, nil)
            mod.WorldMapCtrl:ChangeEcosystemMark(npcCfg.map_id, k, nil)
            self.canAcceptNpc[k] = nil
        end
    end
end

function TaskManager:SetGuideTaskView()
    if next(self.curGuidePointer) then
        local fightGuidePointerManager = self.fight.clientFight.fightGuidePointerManager
        for _, v in pairs(self.curGuidePointer) do
            fightGuidePointerManager:RemoveGuide(v)
        end
        TableUtils.ClearTable(self.curGuidePointer)
        self.fight.entityManager:RemoveTaskGuideLight()
    end

    if next(self.curGuideMarks) then
        for _, instanceId in pairs (self.curGuideMarks) do
            mod.WorldMapCtrl:RemoveMapMark(instanceId)
        end
        TableUtils.ClearTable(self.curGuideMarks)
    end

    if not self.guideTask then
        BehaviorFunctions.SetTaskGuideDisState(false)
        return
    end

    local taskConfig = self.guideTask.taskConfig
    local mapId = self.fight:GetFightMap()
    local haveNavPoint = next(taskConfig.task_position) or next(taskConfig.trace_eco_id)
    if not taskConfig or taskConfig.map_id ~= mapId or not haveNavPoint then
        BehaviorFunctions.SetTaskGuideDisState(false)
        return
    end

    BehaviorFunctions.SetTaskGuideDisState(true)
    BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, true)

    -- 多目标任务不一定有多个指引
    local guideTarget = taskConfig.task_position[1] and taskConfig.task_position or taskConfig.trace_eco_id
    local isMutli = #taskConfig.goal == #guideTarget
    if not isMutli then
        -- 判断是否有未完成的目标 直接指引对应位置
        for i = 1, #taskConfig.goal do
            local request = mod.TaskCtrl:GetTaskProgressRequest(self.guideTask.taskId, i)
            local cur = mod.TaskCtrl:GetTaskProgressNum(self.guideTask.taskId, i)
            if request > cur then
                break
            end

            if i == #taskConfig.goal then
                return
            end
        end

        self:AddTaskGoalGuide(1, taskConfig)
    else
        for i = 1, #taskConfig.goal do
            local request = mod.TaskCtrl:GetTaskProgressRequest(self.guideTask.taskId, i)
            local cur = mod.TaskCtrl:GetTaskProgressNum(self.guideTask.taskId, i)
            -- 添加任务追踪标点
            if request > cur and (taskConfig.trace_eco_id[i] or taskConfig.task_position[i]) then
                self:AddTaskGoalGuide(i, taskConfig)
            end
        end
    end
end

function TaskManager:AddTaskGoalGuide(index, taskConfig)
    local pos
    local radius = taskConfig.radius and taskConfig.radius[index] or 0
    local subTaskInfo = { radius = radius, taskConfig = taskConfig, progress = index }
    if taskConfig.task_position[index] then
        local posCfg = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(taskConfig.position_id, taskConfig.task_position[index][2], taskConfig.task_position[index][1])
        local extraSetting = { taskId = self.guideTask.taskId, progress = index, guideType = FightEnum.GuideType.Task, radius = radius }
        pos = Vec3.New(posCfg.x, posCfg.y, posCfg.z)
        subTaskInfo.position = taskConfig.task_position[index]
        -- 添加任务追踪光
        self.fight.entityManager:CreateTaskGuideLight(pos)
        -- 地图也添加任务追踪
        self.curGuidePointer[index] = self.fight.clientFight.fightGuidePointerManager:AddGuidePosition(pos, nil, extraSetting)
    elseif taskConfig.trace_eco_id[index] then
        local setting = { hideOnSee = true, radius = radius }
        subTaskInfo.traceEcoId = taskConfig.trace_eco_id[index]
        self.curGuidePointer[index] = self.fight.clientFight.fightGuidePointerManager:AddGuideEcoEntity(taskConfig.trace_eco_id[index], setting, FightEnum.GuideType.Task, self.guideTask.taskId)
    end

    self.curGuideMarks[index] = mod.WorldMapCtrl:AddTaskMark(subTaskInfo)
end

function TaskManager:RemoveTaskProgressGuide(progress)
    if not next(self.curGuidePointer) or not next(self.curGuideMarks) then
        return
    end

    self.fight.clientFight.fightGuidePointerManager:RemoveGuide(self.curGuidePointer[progress])
    self.curGuidePointer[progress] = nil

    -- 后续改到另外的Manager去做
    mod.WorldMapCtrl:RemoveMapMark(self.curGuideMarks[progress])
    self.curGuideMark[progress] = nil
end

function TaskManager:BindTaskEntity(instanceId, radius)
    if not instanceId then
        return
    end

    local entity = self.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    local setting = { hideOnSee = true, radius = radius }
    local guidePointer = self.fight.clientFight.fightGuidePointerManager:AddGuideEntity(entity, setting, FightEnum.GuideType.Task, self.guideTask.taskId)

    self.curGuidePointer[1] = guidePointer
end

function TaskManager:ChangeTaskGuidePoint(pos, progressId)
    if not self.guideTask or not self.curGuidePointer[progressId] then
        return
    end

    self.fight.clientFight.fightGuidePointerManager:UpdatePositionGuide(self.curGuidePointer[progressId], pos.x, pos.y, pos.z)
end

function TaskManager:GetGuideTask()
    return self.guideTask
end

function TaskManager:__delete()
    for k, v in pairs(self.taskBehavior) do
        v.behavior:DeleteMe()
        self.taskBehavior[k] = nil
    end

    self.guideTask = nil

    EventMgr.Instance:RemoveListener(EventName.RefreshNpcAcceptTask, self:ToFunc("RefreshNpcAcceptTask"))
    EventMgr.Instance:RemoveListener(EventName.AddTask, self:ToFunc("AddTask"))
    EventMgr.Instance:RemoveListener(EventName.GuideTaskChange, self:ToFunc("SetGuideTask"))
    EventMgr.Instance:RemoveListener(EventName.RemoveTaskProgressGuide, self:ToFunc("RemoveTaskProgressGuide"))
    EventMgr.Instance:RemoveListener(EventName.OccupyTaskChange, self:ToFunc("ChangeOccupyTask"))
    EventMgr.Instance:RemoveListener(EventName.TaskFinish, self:ToFunc("RemoveTask"))
    EventMgr.Instance:RemoveListener(EventName.TaskPreFinish, self:ToFunc("OnTaskFinished"))
end