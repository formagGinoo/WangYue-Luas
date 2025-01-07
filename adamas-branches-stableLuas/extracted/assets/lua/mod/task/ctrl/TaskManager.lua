TaskManager = BaseClass("TaskManager")

function TaskManager:__init(fight)
    self.fight = fight

    self.guideTask = nil
    -- 指引任务的参数
    self.guideTaskParam = nil

    self.curGuideMarks = {}
    self.markMap = {}

    -- self.curGuidePointer = {}
    -- 当前任务道路指引
    -- self.curGuideRoadPath = nil
    -- 现在指引的是一个会动的生态点吗
    -- self.curRoadPathIsEco = false
    -- 指引的生态点的生态ID
    -- self.curGuideEcoId = nil
    -- 指引的实体的实例ID
    self.curGuideEntityInstance = nil

    self.taskBehavior = {}

    self.canAcceptNpc = {}
    -- 交通系统
    self.trafficManager = nil

    self.inited = false

    self.preLoadSec = {}

    -- 相关的触发和条件监听管理器
    self.taskTriggerManager = TaskTriggerManager.New(self.fight, self)
    self.taskConditionManager = TaskConditionManager.New(self.fight, self)

    --任务对应的logic
    self.curSecType = {}
    self.taskTypeLogics = {}

     --提前加载关卡
     self.preLoadLevel = {}
 
    -- 添加对taskCtrl的监听
    EventMgr.Instance:AddListener(EventName.RefreshNpcAcceptTask, self:ToFunc("RefreshNpcAcceptTask"))
    EventMgr.Instance:AddListener(EventName.AddTask, self:ToFunc("AddTask"))
    EventMgr.Instance:AddListener(EventName.GuideTaskChange, self:ToFunc("SetGuideTask"))
    -- EventMgr.Instance:AddListener(EventName.RemoveTaskProgressGuide, self:ToFunc("RemoveTaskProgressGuide"))
    EventMgr.Instance:AddListener(EventName.OccupyTaskChange, self:ToFunc("ChangeOccupyTask"))
    EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("RemoveTask"))
    EventMgr.Instance:AddListener(EventName.TaskPreFinish, self:ToFunc("OnTaskFinished"))
    EventMgr.Instance:AddListener(EventName.TaskTypeChange, self:ToFunc("LoadTaskLogic"))
    EventMgr.Instance:AddListener(EventName.TaskBehaviorStateChange, self:ToFunc("SetBehaviorPauseState"))
    EventMgr.Instance:AddListener(EventName.EnterTaskTimeArea, self:ToFunc("EnterTaskTimeArea"))
end

function TaskManager:StartFight() --在开始战斗时初始化任务行为，设置NPC任务信息，并标记任务管理器已初始化。
    if self.fight:IsDebugMode() then
        return
    end

    self:InitTaskBehavior()
    self:SetNpcOccupyTaskInfo()

    -- 设置当前的指引任务
    local guideTaskId = mod.TaskCtrl:GetGuideTaskId()
    self:SetGuideTask(guideTaskId)
    -- 获取到当前的交通系统
    self.trafficManager = self.fight.entityManager.trafficManager

    -- 对应的管理器做一下处理
    self.taskConditionManager:StartFight()
    --
    self:InitTaskLogic()

    self.inited = true
end

function TaskManager:SetTaskInCurtain(state)
    -- 如果是有story在播的话 由task自己来解除这个黑幕 临时做法
    self.taskInCurtain = state
end

function TaskManager:OnFightStart()
    -- 检测是否有上次退出时正在进行中的任务
    -- 按照策划说的进Fight的时候如果有任务结束的就先播结束的 再播接到任务的那个timeline
    local endingDialog = mod.TaskCtrl:GetEndingDialog()
    if endingDialog and next(endingDialog) then
        self:OnTaskFinished(endingDialog.taskId)
        return
    end

    -- 做任务的trigger
    local startTaskList = mod.TaskCtrl:GetStartTask()
    if not startTaskList then
        return
    end

    for taskId, v in pairs(startTaskList) do
        self.taskTriggerManager:DoTrigger(taskId, true)
    end

    --角色死亡复活后激活正在进行的关卡
    if self.guideTask then
        self.taskTriggerManager:DoTrigger(self.guideTask.taskId, true)
    end
    -- 触发完了就给他清理一下呗
    mod.TaskCtrl:ClearStartTask()
end

-- 跑任务逻辑 不在当前地图就不跑 合理
function TaskManager:Update()
    local mapId = self.fight:GetFightMap()
    for taskId, steps in pairs(self.taskBehavior) do
        for stepId, v in pairs(steps) do
            if v.pause or v.map ~= mapId then
                goto continue
            end
            v.behavior:Update()
            ::continue::
        end
    end

    -- if self.trafficManager and self.curGuideRoadPath then
    --     -- 看看生态在不在
    --     local ecoInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.curGuideEcoId)
    --     if ecoInstanceId and not self.curRoadPathIsEco then
    --         self.curRoadPathIsEco = true
    --         self.curGuideRoadPath = BehaviorFunctions.DrawRoadPath3(ecoInstanceId, nil, FightEnum.NavDrawColor.Yellow)
    --         return
    --     end
    --     -- 如果生态没了就换成他的出生点
    --     if not ecoInstanceId and self.curRoadPathIsEco then
    --         self.curRoadPathIsEco = false
    --         local bornPos = BehaviorFunctions.GetEcoEntityPosition(self.curGuideEcoId)
    --         bornPos = Vec3.New(bornPos.x, bornPos.y, bornPos.z)
    --         self.curGuideRoadPath = BehaviorFunctions.DrawRoadPath2(bornPos, nil, FightEnum.NavDrawColor.Yellow)
    --     end
    -- end
end

function TaskManager:LowUpdate()
    self.taskConditionManager:LowUpdate()
    self.taskTriggerManager:LowUpdate()
end

-- 初始化任务行为，为每个任务绑定任务行为，并将任务添加到战斗任务管理器中
function TaskManager:InitTaskBehavior()
    local taskList = mod.TaskCtrl:GetAllTask()
    for k, v in pairs(taskList) do
        self:BindBehavior(v.taskId, v.stepId)
        self.taskConditionManager:AddTask(v.taskId, true)
    end
end

function TaskManager:InitTaskLogic()
    local taskId = mod.TaskCtrl:GetGuideTaskId()
    self:LoadTaskLogic(taskId)
end

-- TODO 后面要优化一下结构 还是只保留一层比较合理
function TaskManager:BindBehavior(taskId, stepId)
    local taskInfo = mod.TaskCtrl:GetTask(taskId)  -- 获取任务信息和配置
    local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId, stepId)
    if not taskConfig or (self.taskBehavior[taskId] and self.taskBehavior[taskId][stepId]) then  -- 如果任务配置不存在或者已经存在任务行为，则直接返回
        return
    end

	local tempBehavior = taskConfig.behavior  -- 获取任务行为脚本
	if not tempBehavior or tempBehavior == "" then -- 如果任务行为不存在，则直接返回
		return
	end

	if not _G[tempBehavior] then-- 如果任务行为不存在，则直接返回
		return
	end

	local callBack = function()  -- 加载任务行为资源并绑定
		local behavior = taskConfig.behavior
		if not behavior or behavior == "" then
			return
		end

		if not _G[behavior] then
			return
		end
		behavior = _G[behavior].New(taskInfo)

        if not self.taskBehavior[taskId] then
	        self.taskBehavior[taskId] = {} -- 绑定任务行为
        end

        self.taskBehavior[taskId][stepId] = {}
	    self.taskBehavior[taskId][stepId].behavior = behavior
	    self.taskBehavior[taskId][stepId].map = taskConfig.map_id

	end

	self.fight.clientFight.assetsNodeManager:LoadTask(taskId, callBack) -- 加载任务行为资源
end

function TaskManager:UnBindBehavior(taskId, stepId)
    if not taskId or not self.taskBehavior[taskId] or not self.taskBehavior[taskId][stepId] then
        return
    end

    self.taskBehavior[taskId][stepId].behavior:DeleteMe()
    self.taskBehavior[taskId][stepId] = nil
end

function TaskManager:SetBehaviorPauseState(taskId, stepId, state)
    if not taskId or not self.taskBehavior[taskId] or not self.taskBehavior[taskId][stepId] then
        return
    end

    self.taskBehavior[taskId][stepId].pause = state
end

--根据任务章节加载任务logic
function TaskManager:LoadTaskLogic(taskId)
    local callBack = function()
        local secType,type = mod.TaskCtrl:GetTaskType(taskId)
        local taskTypeConfig = mod.TaskCtrl:GetDataTaskType(secType,type)
        if taskTypeConfig then
            if not taskTypeConfig.task_type_logic then
                return
            end
            for k, path in pairs(taskTypeConfig.task_type_logic) do
                local logicObject
                local sceneObjectsCmp
                local logicPath = "Prefabs/Scene/"..path
                logicObject = self.fight.clientFight.assetsPool:Get(logicPath)
                if not logicObject then
                    return
                end
                logicObject.name = string.gsub(logicObject.name, "[(]Clone[)]", "")
                logicObject.transform:SetParent(self.fight.clientFight.clientMap.transform)
                local transform = logicObject.transform
                transform:ResetAttr()
                sceneObjectsCmp = logicObject:GetComponent(SceneObjects)
                if sceneObjectsCmp then
                    sceneObjectsCmp:Init()
                end
                local logicConfig = {}
                logicConfig.path = logicPath
                logicConfig.obj = logicObject
                table.insert(self.taskTypeLogics,logicConfig)
            end
        end
    end
    
    if taskId then
        self:UnLoadTaskLogic()
        self.fight.clientFight.assetsNodeManager:LoadTask(taskId, callBack)
    end
end

--清除章节的logic
function TaskManager:UnLoadTaskLogic()
    if #self.taskTypeLogics>0 then
        for k, v in pairs(self.taskTypeLogics) do
            self.fight.clientFight.assetsPool:Cache(v.path, v.obj)
        end
    end
    self.taskTypeLogics = {}
end

-- TODO 这个后续要改成和实体那样的注册类型
function TaskManager:CallBehaviorFun(funcName, ...)
    for taskId, steps in pairs(self.taskBehavior) do
        for stepId, v in pairs(steps) do
            v.behavior.SuperFunc(v.behavior, funcName, true, ...)
        end
    end
end

function TaskManager:AddTask(taskId, isNewTask)
    if not isNewTask then
        return
    end

    local task = mod.TaskCtrl:GetTask(taskId)
    if not task then
        return
    end

    local taskCfg = mod.TaskCtrl:GetTaskConfig(task.taskId, task.stepId)

    self:BindBehavior(taskId, task.stepId)
    if self:CheckTypeChange(taskId) then
        self:LoadTaskLogic(taskId)
    end
    -- 绑定NPC占用
    self:ChangeOccupyTask(taskId)

    -- 提前加载任务关卡
    self:PreAddLevel(taskId)
    -- 显示任务开始 如果有的话
    if taskCfg.show_start_tips then
        local taskType = mod.TaskCtrl:GetTaskType(taskId)
        if taskType then
            local taskIcon = AssetConfig.GetTaskTypeIcon(taskType)
            BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.Task, taskCfg.task_name, nil, taskIcon)
        end
    end
end

-- 暂停冲突的任务行为
function TaskManager:ChangeOccupyTask(taskId)
    local occupyTask = mod.TaskCtrl:GetTask(taskId)
    if not occupyTask or not occupyTask.inProgress then
        return
    end

    local taskConfig = mod.TaskCtrl:GetTaskConfig(occupyTask.taskId, occupyTask.stepId)
    if not taskConfig then
        return
    end
    local occupyConfig = mod.TaskCtrl:GetTaskOccupyConfig(occupyTask.taskId, occupyTask.stepId)
    for k, v in pairs(taskConfig.proceed_area) do
        local areaOccupyTask = mod.TaskCtrl:GetAreaOccupyTask(v)
        if areaOccupyTask then
            for _, occupyTaskId in pairs(areaOccupyTask) do
                local task = mod.TaskCtrl:GetTask(occupyTaskId)
                if not task then
                    goto continue
                end
                if occupyTaskId == taskId or not task.inProgress then
                    goto continue
                end
                local stepId = mod.TaskCtrl:GetTaskStep(occupyTaskId)
                self:SetBehaviorPauseState(occupyTaskId,stepId,true)
                EventMgr.Instance:Fire(EventName.TaskOccupy, taskId, task.stepId)
                ::continue::
            end
        end
    end

    if occupyConfig then
        for npcId, v in pairs(occupyConfig.occupy_list) do
            local npcOccupyTask = mod.TaskCtrl:GetNpcOccupyTask(npcId)
            if npcOccupyTask then
                for occupyTaskId, k in pairs(npcOccupyTask) do
                    local task = mod.TaskCtrl:GetTask(occupyTaskId)
                    if not task then
                        goto continue
                    end
                    if occupyTaskId == taskId or not task.inProgress then
                        goto continue
                    end
                    local stepId = mod.TaskCtrl:GetTaskStep(occupyTaskId)
                    self:SetBehaviorPauseState(occupyTaskId,stepId,true)
                    EventMgr.Instance:Fire(EventName.TaskOccupy, taskId, task.stepId)
                    ::continue::
                end
            end
        end
    end

    -- 做占用NPC的处理
    self.fight.entityManager.npcEntityManager:BindTask(taskId, occupyTask.stepId)
    local stepId = mod.TaskCtrl:GetTaskStep(taskId)
    self:SetBehaviorPauseState(taskId,stepId,false)
end

function TaskManager:RemoveTask(taskId, stepId)
    local taskCfg = mod.TaskCtrl:GetTaskConfig(taskId, stepId)
    self:UnBindBehavior(taskId, stepId)
    if taskCfg.show_end_tips then
        BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.TaskEnd, taskCfg.task_name, true)
    end

    if self.guideTask and self.guideTask.taskId == taskId then
        local task = mod.TaskCtrl:GetTask(taskId)
        local stepCount = mod.TaskCtrl:GetTaskStepCount(taskId)

        -- 如果没有任务了 或者 任务步骤等于当前步骤（任务做完了）就取消追踪
        local isCancelGuide = not task or task.stepId == stepCount
        if isCancelGuide then
            self:SetGuideTask()
        end
    end
end

function TaskManager:OnTaskFinished(taskId, stepId)
    local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId, stepId)
    if not taskConfig then
        return
    end
    --用于处理任务完成后的逻辑。如果当前在战斗中，则会播放任务完成后的对话
    if Fight.Instance and Fight.Instance.fightState == FightEnum.FightState.Fighting then
        local dialogId = taskConfig.ending_dialog
        self:PalyStory(dialogId)
    end
end

function TaskManager:PalyStory(dialogId)
    --local delayView, selectMap = self.taskConditionManager:GetStoryEndCondition(dialogId)
    Story.Instance:AddStoryCommand(dialogId)
end

--#region 任务指引
function TaskManager:SetGuideTask(taskId)
    if not taskId then
        self.guideTask = nil
        self.guideTaskParam = nil
    else
        -- 如果没有任务或者任务不在进行就不设置指引
        local task = mod.TaskCtrl:GetTask(taskId)
        if not task or not task.inProgress then
            return
        end

        -- 如果有指引 但是指引步骤和当前一样也不设置了
        if self.guideTask and self.guideTask.stepId == task.stepId and self.guideTask.taskId == task.taskId  then
            return
        end

        -- 隐藏任务的话也不要有指引
        local taskConfig = mod.TaskCtrl:GetTaskConfig(task.taskId, task.stepId)
        if taskConfig and taskConfig.is_hide_task then
            return
        end

        self.guideTask = { taskId = taskId, stepId = task.stepId, taskConfig = taskConfig }
    end

    self:SetGuideTaskView()
end

-- 实际处理任务的NPC占用
function TaskManager:SetNpcOccupyTaskInfo()
    local npcOccupyTask = mod.TaskCtrl:GetAllNpcOccupyTask()
    if not npcOccupyTask or not next(npcOccupyTask) then
        return
    end

    local npcManager = self.fight.entityManager.npcEntityManager
    for _, taskList in pairs(npcOccupyTask) do
        for taskId, v in pairs(taskList) do
            local task = mod.TaskCtrl:GetTask(taskId)
			if task then
				npcManager:BindTask(task.taskId, task.stepId)
			else
				LogError("找不到任务 "..taskId)
			end
        end
    end
end

function TaskManager:SetGuideTaskView()
    -- 先清除一下老的任务追踪显示
    self:DeleteGuideTaskView()
    if not self.guideTask or not self.guideTask.taskConfig then
        return
    end

    local taskConfig = self.guideTask.taskConfig
    local mapId = self.fight:GetFightMap()
    local haveNavPoint = next(taskConfig.task_position) or taskConfig.trace_eco_id ~= 0
    -- 如果不需要指引
    if not haveNavPoint then
        return
    end

    if taskConfig.map_id ~= mapId then
        
    else
        BehaviorFunctions.SetTaskGuideDisState(true)
        BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, true)
    end
    self:AddTaskGoalGuide(taskConfig)
end

-- 删除当前所有的任务追踪显示
function TaskManager:DeleteGuideTaskView()
    if self.curGuidePointer then
        self.fight.clientFight.fightGuidePointerManager:RemoveGuide(self.curGuidePointer)
        self.curGuidePointer = nil
        self.fight.entityManager:RemoveTaskGuideLight()
    end

    if self.curGuideMarks then
        self:RemoveMapMark(self.curGuideMarks)
        self.curGuideMarks = nil
    end

    -- self.curGuideEcoId = nil
    -- self.curRoadPathIsEco = false
    -- if self.curGuideRoadPath then
    --     BehaviorFunctions.UnloadRoadPath(self.curGuideRoadPath)
    --     self.curGuideRoadPath = nil
    -- end

    BehaviorFunctions.SetTaskGuideDisState(false)
end

function TaskManager:AddTaskGoalGuide(taskConfig)
    if taskConfig.task_position and next(taskConfig.task_position) then
        self:AddPositionGuide(taskConfig, nil, nil, nil, true)
    elseif taskConfig.trace_eco_id and taskConfig.trace_eco_id ~= 0 then
        self:AddEcoGuide(taskConfig, nil, nil, nil, true)
    end
end

-- 任务指引实体(只有在被修改的时候生效)
function TaskManager:GuideTaskEntity(taskId, instanceId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
    if not taskId and self.guideTask then
        taskId = self.guideTask.taskId
    end

    local task = mod.TaskCtrl:GetTask(taskId)
    if not task or not task.inProgress then
        return
    end

    local entity = self.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    -- 先清除一下老的任务追踪显示
    self:DeleteGuideTaskView()

    local taskConfig = mod.TaskCtrl:GetTaskConfig(task.taskId, task.stepId)
    local subTaskInfo = { radius = radius, taskConfig = taskConfig, entityInstanceId = instanceId, mapId = taskConfig.map_id, unloadDis = pathUnloadDis }
    self.guideTaskParam = { type = FightEnum.TaskGuideType.Entity, value = instanceId, taskId = taskId, taskConfig = taskConfig }

    -- 追踪实体的话会一直存在的
    -- isPathTrace = isPathTrace or (bindTaskPathTrace and taskConfig.path_trace)
    -- local mapId = self.fight:GetFightMap()
    -- if isPathTrace and taskConfig.map_id == mapId then
    --     pathUnloadDis = pathUnloadDis or 0
    --     self.curGuideRoadPath = BehaviorFunctions.DrawRoadPath3(instanceId, pathUnloadDis, FightEnum.NavDrawColor.Yellow)
    -- end
    self.curGuideMarks = self:AddTaskMark(taskId, subTaskInfo)
    -- 路径追踪才去做追踪 追踪交给标记去控制
    if isPathTrace or (bindTaskPathTrace and taskConfig.path_trace) then
        mod.WorldMapCtrl:ChangeMarkTraceState(self.curGuideMarks, true)
    else
        local setting = { hideOnSee = false, radius = radius }
        self.curGuidePointer = self.fight.clientFight.fightGuidePointerManager:AddGuideEntity(entity, setting, FightEnum.GuideType.Task, self.guideTask.taskId)
    end
end

function TaskManager:GuideTaskEco(taskId, ecoId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
    if not taskId and self.guideTask then
        taskId = self.guideTask.taskId
    end

    local task = mod.TaskCtrl:GetTask(taskId)
    if not task or not task.inProgress then
        return
    end

    self:DeleteGuideTaskView()

    local taskConfig = mod.TaskCtrl:GetTaskConfig(task.taskId, task.stepId)
    self:AddEcoGuide(taskConfig, ecoId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
end

function TaskManager:AddEcoGuide(taskConfig, ecoId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
    local mapId = self.fight:GetFightMap()
    local taskId = taskConfig.id
    -- 追踪的是什么生态ID
    radius = radius or taskConfig.radius
    ecoId = ecoId and ecoId or taskConfig.trace_eco_id
    local subTaskInfo = { radius = radius, taskConfig = taskConfig, traceEcoId = ecoId, mapId = taskConfig.map_id, unloadDis = pathUnloadDis }
    self.guideTaskParam = { type = FightEnum.TaskGuideType.EcoEntity, value = ecoId, taskId = taskId, taskConfig = taskConfig }

    -- 不在同一个地图不追踪
    if taskConfig.map_id ~= mapId then
        return 
    end

    --TODO临时处理之后注释掉
    --if taskConfig.map_id == mapId then
    --isPathTrace = isPathTrace or (bindTaskPathTrace and taskConfig.path_trace)
    --    if isPathTrace then
    --        pathUnloadDis = pathUnloadDis or 0
    --        self.curGuideEcoId = ecoId
    --        local ecoInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
    --        -- 如果当前生态存在，追踪他的当前位置，不存在追踪他的出生位置(如果有占用就追踪占用的位置)
    --        if ecoInstanceId then
    --            self.curRoadPathIsEco = true
    --            self.curGuideRoadPath = BehaviorFunctions.DrawRoadPath3(ecoInstanceId, pathUnloadDis, FightEnum.NavDrawColor.Yellow)
    --        else
    --            local bornPos = self.fight.entityManager.ecosystemCtrlManager:GetEcoBornPos(ecoId)
    --            bornPos = Vec3.New(bornPos.x, bornPos.y, bornPos.z)
    --            self.curGuideRoadPath = BehaviorFunctions.DrawRoadPath2(bornPos, pathUnloadDis, FightEnum.NavDrawColor.Yellow)
    --        end
    --    end
    --end
    self.curGuideMarks = self:AddTaskMark(taskId, subTaskInfo)
    if isPathTrace or (bindTaskPathTrace and taskConfig.path_trace) then
        mod.WorldMapCtrl:ChangeMarkTraceState(self.curGuideMarks, true)
    else
        local setting = { hideOnSee = false, radius = radius }
        self.curGuidePointer = self.fight.clientFight.fightGuidePointerManager:AddGuideEcoEntity(ecoId, setting, FightEnum.GuideType.Task, taskConfig.id)
    end
end

function TaskManager:GuideTaskPosition(taskId, position, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
    if not taskId and self.guideTask then
        taskId = self.guideTask.taskId
    end

    local task = mod.TaskCtrl:GetTask(taskId)
    if not task or not task.inProgress then
        return
    end

    self:DeleteGuideTaskView()

    local taskConfig = mod.TaskCtrl:GetTaskConfig(task.taskId, task.stepId)
    self:AddPositionGuide(taskConfig, position, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
end

function TaskManager:AddTaskMark(taskId, subTaskInfo)
    local data = {
        taskId = taskId,
        subTaskInfo = subTaskInfo,
    }
    self.markMap[taskId] = data
    if self:IsInTimeArea(taskId) then
        data.instanceId = mod.WorldMapCtrl:AddTaskMark(subTaskInfo)
    end
    return data.instanceId
end

function TaskManager:RemoveMapMark(mark)
    mod.WorldMapCtrl:RemoveMapMark(mark)
    TableUtils.ClearTable(self.markMap)
end

function TaskManager:EnterTaskTimeArea(inArea, taskId)
    local data = self.markMap[taskId]
    if not data then return end
    if inArea and not data.instanceId then
        data.instanceId = mod.WorldMapCtrl:AddTaskMark(data.subTaskInfo)
        self.curGuideMarks = data.instanceId
    elseif data.instanceId then
        mod.WorldMapCtrl:RemoveMapMark(data.instanceId)
        data.instanceId = nil
    end
end

function TaskManager:AddPositionGuide(taskConfig, position, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
    local mapId = self.fight:GetFightMap()
    local taskId = taskConfig.id
    -- 任务的追踪描述没有填默认找任务目标描述
    desc = desc or taskConfig.task_goal
    radius = radius or taskConfig.radius
    if not position and next(taskConfig.task_position) then
        local posCfg = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(taskConfig.position_id, taskConfig.task_position[2], taskConfig.task_position[1])
        if not posCfg or not next(posCfg) then
            return
        end

        position = Vec3.New(posCfg.x, posCfg.y, posCfg.z)
    end

    -- 地点的标记是需要添加position的
    local subTaskInfo = { radius = radius, taskConfig = taskConfig, mapId = taskConfig.map_id, position = position, unloadDis = pathUnloadDis }
    self.guideTaskParam = { type = FightEnum.TaskGuideType.Position, value = position, desc = desc }

    -- 不在同一个地图不追踪
    if taskConfig.map_id ~= mapId then
        return
    end
    --TODO临时处理之后注释掉
    --if taskConfig.map_id == mapId then
    --    -- 添加任务追踪光
    --    self.fight.entityManager:CreateTaskGuideLight(position)
    --    -- 任务是否需要画道路指引线?
    --    isPathTrace = isPathTrace or (bindTaskPathTrace and taskConfig.path_trace)
    --    if isPathTrace then
    --        pathUnloadDis = pathUnloadDis or 0
    --        self.curGuideRoadPath = BehaviorFunctions.DrawRoadPath2(position, pathUnloadDis, FightEnum.NavDrawColor.Yellow)
    --    end
    --end

    -- 地图也添加任务追踪
    self.curGuideMarks = self:AddTaskMark(taskId, subTaskInfo)
    if isPathTrace or (bindTaskPathTrace and taskConfig.path_trace) then
        mod.WorldMapCtrl:ChangeMarkTraceState(self.curGuideMarks, true)
    else
        -- 主界面和大世界内指引标记
        local extraSetting = { taskId = taskId, guideType = FightEnum.GuideType.Task, radius = radius }
        self.curGuidePointer = self.fight.clientFight.fightGuidePointerManager:AddGuidePosition(position, nil, extraSetting)
    end
end

function TaskManager:GetGuideTask()
    return self.guideTask
end

function TaskManager:GetGuideMarks()
    return self.curGuideMarks
end
--检测章节是否发生了变化
function TaskManager:CheckTypeChange(taskId)
    local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId)
    if not taskConfig then
        return
    end
    if taskConfig.is_hide_task then
        return false
    end
    local secType,type = mod.TaskCtrl:GetTaskType(taskId)
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

function TaskManager:IsInTimeArea(taskId)
    return self.taskConditionManager:IsInTimeArea(taskId)
end

--任务提前加载关卡
function TaskManager:PreAddLevel (taskId)
    local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId)
    if not taskConfig then
        return
    end
    if not taskConfig.pre_load_level then
        return
    end
    local preLoadLevel = taskConfig.pre_load_level
    if #preLoadLevel ==0 then
        return
    end
    if table.concat( self.preLoadLevel) == table.concat(preLoadLevel) then
        return
    end
    for k, v in pairs(preLoadLevel) do
        BehaviorFunctions.AddLevel(v)
    end
    self.preLoadLevel = preLoadLevel
end

function TaskManager:CheckIsPreLoadLevel(LevelId)
    for k, v in pairs(self.preLoadLevel) do
        if v == LevelId then
            return true
        end
    end
    return false
end

function TaskManager:__delete()
    self.taskTriggerManager:DeleteMe()
    self.taskConditionManager:DeleteMe()

    for taskId, steps in pairs(self.taskBehavior) do
        for stepId, v in pairs(steps) do
            v.behavior:DeleteMe()
            self.taskBehavior[taskId][stepId] = nil
        end
    end

    if self.curGuideMarks then
        self:RemoveMapMark(self.curGuideMarks)
        self.curGuideMarks = nil
    end

    if self.curGuidePointer and self.fight.clientFight.fightGuidePointerManager then
        self.fight.clientFight.fightGuidePointerManager:RemoveGuide(self.curGuidePointer)
        self.curGuidePointer = nil
    end

	-- if self.curGuideRoadPath then
	-- 	BehaviorFunctions.UnloadRoadPath(self.curGuideRoadPath)
	-- 	self.curGuideRoadPath = nil
	-- end

    self.guideTask = nil

    EventMgr.Instance:RemoveListener(EventName.RefreshNpcAcceptTask, self:ToFunc("RefreshNpcAcceptTask"))
    EventMgr.Instance:RemoveListener(EventName.AddTask, self:ToFunc("AddTask"))
    EventMgr.Instance:RemoveListener(EventName.GuideTaskChange, self:ToFunc("SetGuideTask"))
    -- EventMgr.Instance:RemoveListener(EventName.RemoveTaskProgressGuide, self:ToFunc("RemoveTaskProgressGuide"))
    EventMgr.Instance:RemoveListener(EventName.OccupyTaskChange, self:ToFunc("ChangeOccupyTask"))
    EventMgr.Instance:RemoveListener(EventName.TaskFinish, self:ToFunc("RemoveTask"))
    EventMgr.Instance:RemoveListener(EventName.TaskPreFinish, self:ToFunc("OnTaskFinished"))
    EventMgr.Instance:RemoveListener(EventName.TaskTypeChange, self:ToFunc("LoadTaskLogic"))
    EventMgr.Instance:RemoveListener(EventName.TaskBehaviorStateChange, self:ToFunc("SetBehaviorPauseState"))
    EventMgr.Instance:RemoveListener(EventName.EnterTaskTimeArea, self:ToFunc("EnterTaskTimeArea"))
end