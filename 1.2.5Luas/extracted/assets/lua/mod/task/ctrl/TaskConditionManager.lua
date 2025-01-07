TaskConditionManager = BaseClass("TaskConditionManager")

TaskConditionEnum = {
    CheckPosition = 1,
    EnterArea = 2,
    ExitArea = 3,
    StoryDialogEnd = 4,
}

TaskConditionTrans = {
    ["check_position"] = TaskConditionEnum.CheckPosition,
    ["enter_area"] = TaskConditionEnum.EnterArea,
    ["exit_area"] = TaskConditionEnum.ExitArea,
    ["storydialog_end"] = TaskConditionEnum.StoryDialogEnd
}

function TaskConditionManager:__init(fight)
    self.fight = fight
    self.checkSubTasks = {}
    self.checkTasks = {}

    self.mapCfg = nil
    self.curCtrlEntity = nil

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
end

function TaskConditionManager:RemoveListener()
    EventMgr.Instance:RemoveListener(EventName.AddTask, self:ToFunc("AddTask"))
    EventMgr.Instance:RemoveListener(EventName.EnterMap, self:ToFunc("EnterMap"))
    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("PlayerUpdate"))

    EventMgr.Instance:RemoveListener(EventName.EnterLogicArea, self:ToFunc("EnterArea"))
    EventMgr.Instance:RemoveListener(EventName.ExitLogicArea, self:ToFunc("ExitArea"))
    EventMgr.Instance:RemoveListener(EventName.EntityHit, self:ToFunc("EntityHit"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
end

function TaskConditionManager:AddTask(taskId, isNewTask)
    if not isNewTask then
        return
    end

    local taskInfo = mod.TaskCtrl:GetTask(taskId)
    self:BindCondition(taskInfo)
end

function TaskConditionManager:BindCondition(taskInfo)
    if not taskInfo.taskConfig.goal then
        return
    end

    for k, v in ipairs(taskInfo.taskConfig.goal) do
        local condition = TaskConditionTrans[v[1]]
        if not condition or taskInfo.condition[k] == 1 then
            goto continue
        end

        if not self.checkSubTasks[condition] then
            self.checkSubTasks[condition] = {}
        end

        self.checkSubTasks[condition][taskInfo.taskConfig.id] = { progress_id = k, param = v[2] }

        if not self.checkTasks[taskInfo.taskConfig.id] then
            self.checkTasks[taskInfo.taskConfig.id] = 0
        end
        self.checkTasks[taskInfo.taskConfig.id] = self.checkTasks[taskInfo.taskConfig.id] + 1

        ::continue::
    end
end

function TaskConditionManager:StartFight()
    local mapId = self.fight:GetFightMap()
    self.mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
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
end

function TaskConditionManager:SubConditionPass(taskId, progress_id, conditionType)
    if not self.checkSubTasks[conditionType] then
        return
    end
    self.checkSubTasks[conditionType][taskId] = nil

    if not self.checkTasks[taskId] then
        return
    end
    self.checkTasks[taskId] = self.checkTasks[taskId] - 1
    if self.checkTasks[taskId] <= 0 then
        mod.TaskCtrl:SendTaskProgress(taskId, progress_id, 1, conditionType)
    end
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

    for k, v in pairs(self.checkSubTasks[TaskConditionEnum.CheckPosition]) do
        local param = v.param
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
            self:SubConditionPass(k, v.progress_id, TaskConditionEnum.CheckPosition)
        end

        ::continue::
    end
end

function TaskConditionManager:EnterArea(instanceId, areaName, logicName)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.EnterArea] then
        return
    end

    for k, v in pairs(self.checkSubTasks[TaskConditionEnum.EnterArea]) do
        local param = v.param
        if instanceId ~= self.curCtrlEntity.instanceId or self.mapCfg.id ~= tonumber(param[1]) then
            goto continue
        end

        if areaName ~= param[2] or logicName ~= param[3] then
            goto continue
        end

        self:SubConditionPass(k, v.progress_id, TaskConditionEnum.EnterArea)

        ::continue::
    end
end

function TaskConditionManager:ExitArea(instanceId, areaName, logicName)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.ExitArea] then
        return
    end

    for k, v in pairs(self.checkSubTasks[TaskConditionEnum.ExitArea]) do
        local param = v.param
        if instanceId ~= self.curCtrlEntity.instanceId or self.mapCfg.id ~= tonumber(param[1]) then
            goto continue
        end

        if areaName ~= param[2] or logicName ~= param[3] then
            goto continue
        end

        self:SubConditionPass(k, v.progress_id, TaskConditionEnum.ExitArea)

        ::continue::
    end
end

function TaskConditionManager:StoryDialogEnd(dialogId)
    if not self.checkSubTasks or not self.checkSubTasks[TaskConditionEnum.StoryDialogEnd] then
        return
    end

    for k, v in pairs(self.checkSubTasks[TaskConditionEnum.StoryDialogEnd]) do
        local param = v.param
        if dialogId == tonumber(param[1]) then
            self:SubConditionPass(k, v.progress_id, TaskConditionEnum.StoryDialogEnd)
        end
    end
end