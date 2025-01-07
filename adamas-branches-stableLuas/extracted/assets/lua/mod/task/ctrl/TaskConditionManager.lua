TaskConditionManager = BaseClass("TaskConditionManager")

TaskConditionEnum = {
    CheckPosition = 1,
    EnterArea = 2,
    ExitArea = 3,
    StoryDialogEnd = 4,
    MessageEnd = 5,
    GuideEnd = 6,
    CheckEntityState = 7,
    FinishDialogOption = 8,
    FinishLevel = 9,
    BargainEnd = 10,
    WaitTime = 11,
}

TaskConditionTrans = {
    ["check_position"] = TaskConditionEnum.CheckPosition,
    ["enter_area"] = TaskConditionEnum.EnterArea,
    ["exit_area"] = TaskConditionEnum.ExitArea,
    ["storydialog_end"] = TaskConditionEnum.StoryDialogEnd,
    ["message_end"] = TaskConditionEnum.MessageEnd,
    -- 引导结束是服务器在监听的，不需要客户端监听
    ["guide_end"] = TaskConditionEnum.GuideEnd,
    ["check_entity_state"] = TaskConditionEnum.CheckEntityState,
    ["finish_dialog_option"] = TaskConditionEnum.FinishDialogOption,
    ["finish_level"] = TaskConditionEnum.FinishLevel,
    ["bargain_end"] = TaskConditionEnum.BargainEnd,
    ["wait_time"] = TaskConditionEnum.WaitTime,
}

function TaskConditionManager:__init(fight)
    self.fight = fight
    self.checkSubTasks = {}
    self.checkTasks = {}

    --不在可进行时段的任务
    self.notInTimeArea = {}
    self.checkInTimeArea = {}

    self.mapCfg = nil
    self.curCtrlEntity = nil

    -- CWB = check when bind
    self.TaskCondition_CWB = {
        [TaskConditionEnum.EnterArea] = self:ToFunc("EnterArea"),
        [TaskConditionEnum.ExitArea] = self:ToFunc("ExitArea"),
        [TaskConditionEnum.CheckEntityState] = self:ToFunc("CheckEcoEntityState"),
        [TaskConditionEnum.FinishDialogOption] = self:ToFunc("CheckDialogFinish")
    }

    self:BindListener()
end

function TaskConditionManager:BindListener()
    EventMgr.Instance:AddListener(EventName.AddTask, self:ToFunc("AddTask"))
    -- base data
    EventMgr.Instance:AddListener(EventName.EnterMap, self:ToFunc("EnterMap"))
    EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("PlayerUpdate"))
    -- condition
    EventMgr.Instance:AddListener(EventName.EnterLogicArea, self:ToFunc("EnterArea"))
    EventMgr.Instance:AddListener(EventName.ExitLogicArea, self:ToFunc("ExitArea"))
    EventMgr.Instance:AddListener(EventName.EntityHit, self:ToFunc("EntityHit"))
    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
    EventMgr.Instance:AddListener(EventName.MessageEnd, self:ToFunc("MessageEnd"))
    EventMgr.Instance:AddListener(EventName.BargainEnd, self:ToFunc("BargainEnd"))

    EventMgr.Instance:AddListener(EventName.FinishLevel, self:ToFunc("CheckLevelFinish"))
    EventMgr.Instance:AddListener(EventName.DayNightTimeChanged, self:ToFunc("DayNightTimeChanged"))
end

function TaskConditionManager:RemoveListener()
    EventMgr.Instance:RemoveListener(EventName.AddTask, self:ToFunc("AddTask"))
    EventMgr.Instance:RemoveListener(EventName.EnterMap, self:ToFunc("EnterMap"))
    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("PlayerUpdate"))

    EventMgr.Instance:RemoveListener(EventName.EnterLogicArea, self:ToFunc("EnterArea"))
    EventMgr.Instance:RemoveListener(EventName.ExitLogicArea, self:ToFunc("ExitArea"))
    EventMgr.Instance:RemoveListener(EventName.EntityHit, self:ToFunc("EntityHit"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
    EventMgr.Instance:RemoveListener(EventName.MessageEnd, self:ToFunc("MessageEnd"))
    EventMgr.Instance:RemoveListener(EventName.BargainEnd, self:ToFunc("BargainEnd"))

    EventMgr.Instance:RemoveListener(EventName.FinishLevel, self:ToFunc("CheckLevelFinish"))
    EventMgr.Instance:RemoveListener(EventName.DayNightTimeChanged, self:ToFunc("DayNightTimeChanged"))
end

function TaskConditionManager:AddTask(taskId, isNewTask)
    if not isNewTask then
        return
    end

    local taskInfo = mod.TaskCtrl:GetTask(taskId)

    self:BindCondition(taskInfo)
end

function TaskConditionManager:BindCondition(taskInfo)
    local taskCfg = mod.TaskCtrl:GetTaskConfig(taskInfo.taskId, taskInfo.stepId)
    if not taskCfg then
        return
    end

    if not taskCfg.goal then
        return
    end

    local goal = taskCfg.goal
    local taskId = taskInfo.taskId
    -- for k, v in ipairs(taskInfo.taskConfig.goal) do
    local condition = TaskConditionTrans[goal[1]]
    -- if not condition or taskInfo.condition[k] == 1 then
    --     goto continue
    -- end

	if not condition then
		goto continue
	end

    if not self.checkSubTasks[condition] then
        self.checkSubTasks[condition] = {}
    end

    if not self.checkSubTasks[condition][taskId] then
        self.checkSubTasks[condition][taskId] = {}
    end

    self.checkSubTasks[condition][taskId] = goal[2]

    -- if not self.checkTasks[taskId] then
    --     self.checkTasks[taskId] = 0
    -- end
    -- self.checkTasks[taskId] = self.checkTasks[taskId] + 1

    ::continue::
    -- end
    local time = DayNightMgr.Instance:GetTime()
    mod.TaskCtrl:SetDayNightTime(taskId, time)

    local timeArea = TaskConfig.GetTaskActionableTimeArea(taskId, taskInfo.stepId)
    if next(timeArea) then
        self.checkInTimeArea[taskId] = taskInfo.stepId
        self:CheckInTimeArea(taskId, taskInfo.stepId)
    else
        self.checkInTimeArea[taskId] = nil
        self.notInTimeArea[taskId] = nil
    end

    self:CheckConditionIsDone()
end

-- 有一部分条件在接取的时候已经满足了 需要在接取的时候直接判断
function TaskConditionManager:CheckConditionIsDone()
    for k, v in pairs(self.TaskCondition_CWB) do
        v()
    end
end

function TaskConditionManager:StartFight()
    local mapId = self.fight:GetFightMap()
    self.mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
    self.checkEntity = self.checkSubTasks
end

function TaskConditionManager:PlayerUpdate()
    self.curCtrlEntity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
end

function TaskConditionManager:Update()

end

function TaskConditionManager:LowUpdate()
    if not self.curCtrlEntity then
        return
    end

    local curPosition = self.curCtrlEntity.transformComponent.position
    self:CheckPosition(curPosition)
    self:CheckEcoEntityState()
end

function TaskConditionManager:SubConditionPass(taskId, progress_id, conditionType, callback)
    if not self.checkSubTasks[conditionType] or not self.checkSubTasks[conditionType][taskId] then
        return
    end

    --不在可进行时间内
    if self.notInTimeArea[taskId] then
        return
    end

    local task = mod.TaskCtrl:GetTask(taskId)
    if not task then
        return
    end

    -- self.checkSubTasks[conditionType][taskId][progress_id] = nil
    self.checkSubTasks[conditionType][taskId] = nil
    self:RemoveTimeAera(taskId)

    -- if not self.checkTasks[taskId] then
    --     return
    -- end
    -- self.checkTasks[taskId] = self.checkTasks[taskId] - 1
    -- mod.TaskCtrl:SendTaskProgress(taskId, progress_id, 1, conditionType)

    mod.TaskCtrl:SendTaskProgress(taskId, task.stepId, 1, callback)
end

function TaskConditionManager:__delete()
    self:RemoveListener()
end

function TaskConditionManager:CheckPosition(position)
    if not self.mapCfg or not next(self.mapCfg) then
        return
    end

    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.CheckPosition] then
        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.CheckPosition]) do
        local param = v
        if self.mapCfg.id ~= tonumber(param[1]) then
            goto continue
        end

        local taskPos = BehaviorFunctions.GetTerrainPositionP(param[2], self.mapCfg.level_id, param[3])
        if not taskPos then
            goto continue
        end

        local distance = (taskPos.x - position.x) ^ 2 + (taskPos.y - position.y) ^ 2 + (taskPos.z - position.z) ^ 2
        local targetDistance = tonumber(param[4]) ^ 2
        if distance <= targetDistance then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.CheckPosition)
        end

        ::continue::
    end
end

function TaskConditionManager:EnterArea(instanceId, areaName, logicName)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.EnterArea] then
        return
    end

    -- 没有instanceId说明是绑定的时候检测的
    if not instanceId then
        for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.EnterArea]) do
            local param = v
            if self.curCtrlEntity:CheckIsInArea(param[2], param[3]) then
                self:SubConditionPass(taskId, 1, TaskConditionEnum.EnterArea)
            end
        end

        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.EnterArea]) do
        local param = v
        if instanceId ~= self.curCtrlEntity.instanceId or self.mapCfg.id ~= tonumber(param[1]) then
            goto continue
        end

        if areaName ~= param[2] or logicName ~= param[3] then
            goto continue
        end

        self:SubConditionPass(taskId, 1, TaskConditionEnum.EnterArea)

        ::continue::
    end
end

function TaskConditionManager:ExitArea(instanceId, areaName, logicName)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.ExitArea] then
        return
    end

    -- 没有instanceId说明是绑定的时候检测的
    if not instanceId then
        for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.ExitArea]) do
            local param = v
            if not self.curCtrlEntity:CheckIsInArea(param[2], param[3]) then
                self:SubConditionPass(taskId, 1, TaskConditionEnum.ExitArea)
            end
        end

        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.ExitArea]) do
        local param = v
        if instanceId ~= self.curCtrlEntity.instanceId or self.mapCfg.id ~= tonumber(param[1]) then
            goto continue
        end

        if areaName ~= param[2] or logicName ~= param[3] then
            goto continue
        end

        self:SubConditionPass(taskId, 1, TaskConditionEnum.ExitArea)

        ::continue::
    end
end

function TaskConditionManager:StoryDialogEnd(dialogId, selectList)
    if not self.checkSubTasks then
        return
    end
    local count = 0
    local func = function()
        count = count - 1
        if count == 0 then
            Story.Instance:ExitViewState() 
        end
    end
    if self.checkSubTasks[TaskConditionEnum.StoryDialogEnd] then
        for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.StoryDialogEnd]) do
            local param = v
            if dialogId == tonumber(param[1]) then
                count = count + 1
                self:SubConditionPass(taskId, 1, TaskConditionEnum.StoryDialogEnd, func)
            end
        end
    end

    if self.checkSubTasks[TaskConditionEnum.FinishDialogOption] then
        for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.FinishDialogOption]) do
            local param = v
            local checkOption = tonumber(param[2])
            local checkDialog = tonumber(param[1])

            if checkDialog ~= dialogId then
                goto continue
            end

            for i = 1, #selectList do
                if selectList[i] == checkOption then
                    count = count + 1
                    self:SubConditionPass(taskId, 1, TaskConditionEnum.FinishDialogOption, func)
                    goto continue
                end
            end

            ::continue::
        end
    end
end

function TaskConditionManager:GetStoryEndCondition(dialogId)
    if not self.checkSubTasks then
        return false
    end

    if self.checkSubTasks[TaskConditionEnum.StoryDialogEnd] then
        for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.StoryDialogEnd]) do
            local param = v
            if dialogId == tonumber(param[1]) then
                return true
            end
        end
    end

    local mark, optionMap
    if self.checkSubTasks[TaskConditionEnum.FinishDialogOption] then
        for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.FinishDialogOption]) do
            local param = v
            local checkOption = tonumber(param[2])
            local checkDialog = tonumber(param[1])
            if checkDialog == dialogId then
                mark = true
                optionMap = optionMap or {}
                optionMap[checkOption] = true
            end
        end
        return mark, optionMap
    end
    return false
end

function TaskConditionManager:CheckDialogFinish()
    if not self.checkSubTasks[TaskConditionEnum.FinishDialogOption] then
        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.FinishDialogOption]) do
        local param = v
        local checkOption = tonumber(param[2])
        local checkDialog = tonumber(param[1])
        local storyConfig = StoryConfig.GetStoryConfig(checkDialog)
        if not storyConfig or not next(storyConfig) then
            goto continue
        end

        local selectOption = mod.StoryCtrl:GetSaveDialog(storyConfig.group_id)
        if selectOption == checkOption then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.FinishDialogOption)
            goto continue
        end

        ::continue::
    end
end

function TaskConditionManager:MessageEnd(messageId)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.MessageEnd] then
        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.MessageEnd]) do
        local param = v
        if messageId == tonumber(param[1]) then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.MessageEnd)
        end
    end
end

function TaskConditionManager:CheckEcoEntityState()
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.CheckEntityState] then
        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.CheckEntityState]) do
        local param = v
        local state = tonumber(param[2])
        local ecoId = tonumber(param[1])
        local taskState =  BehaviorFunctions.CheckEcoEntityState(ecoId,state)
        if taskState then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.CheckEntityState)
        end
    end
end

function TaskConditionManager:CheckLevelFinish(levelId)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.FinishLevel] then
        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.FinishLevel]) do
        local param = v
        local checkLevel = tonumber(param[1])
        if checkLevel == levelId then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.FinishLevel)
        end
    end
end

function TaskConditionManager:BargainEnd(curType, curNegotiateId, bargainEndScore, curBargainResultType)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.BargainEnd] then
        return
    end

    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.BargainEnd]) do
        local param = v
        local checkbragainId = tonumber(param[1])
        
        local result
        if curBargainResultType == BargainEnum.ResultType.Success  then
            result = "true"
        else
            result = "false"
        end

        if checkbragainId == curNegotiateId and result == param[2] then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.BargainEnd)
        end
       
    end
end

function TaskConditionManager:DayNightTimeChanged(totalTime, singleTime, singleTimeSecond)
    local updateCheck = false
    if next(self.checkInTimeArea) then
        for k, v in pairs(self.checkInTimeArea) do
            local changed, inArea = self:CheckInTimeArea(k, v)
            updateCheck = changed or updateCheck
        end
    end

    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.WaitTime] then
        return
    end
    
    for taskId, v in pairs(self.checkSubTasks[TaskConditionEnum.WaitTime]) do
        local param = v
        local minute = tonumber(param[1]) * 60
        local startTime = mod.TaskCtrl:GetDayNightTime(taskId)
        if totalTime - startTime >= minute then
            self:SubConditionPass(taskId, 1, TaskConditionEnum.WaitTime)
        end
    end

    if updateCheck then
        --TODO 定向更新指定任务就行
        self:CheckConditionIsDone()
    end
end

function TaskConditionManager:CheckInTimeArea(taskId, stepId)
    local timeArea = TaskConfig.GetTaskActionableTimeArea(taskId, stepId)
    local _, curTime = DayNightMgr.Instance:GetTime()
    local inArea = false
    for k, v in pairs(timeArea) do
        if v.startTime <= curTime and v.endTime >= curTime then
            inArea = true
            break
        end
    end
    local changed = false
    if self.notInTimeArea[taskId] == inArea then
        changed = true
    end
    self.notInTimeArea[taskId] = not inArea
    if changed then
        if inArea then
            Fight.Instance.entityManager.npcEntityManager:BindTask(taskId, stepId)
        else
            Fight.Instance.entityManager.npcEntityManager:UnBindTaskOnShow(taskId, stepId)
        end
        EventMgr.Instance:Fire(EventName.EnterTaskTimeArea, inArea, taskId) 
    end
    return changed, inArea
end

function TaskConditionManager:IsInTimeArea(taskId)
    if self.checkInTimeArea[taskId] then
        return not self.notInTimeArea[taskId]
    end
    return true
end

function TaskConditionManager:RemoveTimeAera(taskId)
    self.checkInTimeArea[taskId] = nil
    self.notInTimeArea[taskId] = nil
end