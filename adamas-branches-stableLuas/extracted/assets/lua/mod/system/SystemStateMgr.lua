SystemStateMgr = SingleClass("SystemStateMgr")
local StateWeight = SystemStateConfig.StateWeight 
local TransitionType = SystemStateConfig.TransitionType 
local StateType = SystemStateConfig.StateType
local TipQueueState = SystemStateConfig.TipQueueState
local DebugStateName = SystemStateConfig.DebugStateName

function SystemStateMgr:__init()
    self.stateStack = {} --表示激活中的状态
    self.stateQueue = {} --表示排队中的状态
    self.topState = nil --主状态，决定公共模块表现
    self.lastEntityState = nil
    self.lastCamState = nil
    self.stateMap = {}
    self.timeIndex = 0

    self.curTipQueueState = TipQueueState.Play
end

function SystemStateMgr:BindEvent()
    EventMgr.Instance:AddListener(EventName.ExitFight, self:ToFunc("Clear"))
end

function SystemStateMgr:GetTimeIndex()
    self.timeIndex = self.timeIndex + 1
    return self.timeIndex
end

--- func desc 逻辑层需要进入就调用
---@param state any
---@SystemStateMgr.Instance:AddState(SystemStateConfig.StateType)
function SystemStateMgr:AddState(state, ...)
    if self:StateActive(state) then
        return self:EnterState(state, {...})
    end
    local stateData = {
        state = state, 
        params = {...},
        timeIndex = self:GetTimeIndex()
    }
    table.insert(self.stateQueue, stateData)
    table.sort(self.stateQueue, function (a, b)
        if StateWeight[a.state] == StateWeight[b.state] then
            return a.timeIndex < b.timeIndex
        end
        return StateWeight[a.state] > StateWeight[b.state]
    end)
    self:StateChanged()
    self:UpdateStateView()
    --self:LogStackTable("状态添加完成："..DebugStateName[state])
end
--- func desc 表现层退出完成后再调用
---@param state any
---@SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType)
function SystemStateMgr:RemoveState(state)
    self.stateMap[state].activeCount = false
    for i, v in ipairs(self.stateStack) do
        if v.state == state then
            table.remove(self.stateStack, i)
        end
    end
    if state == self.topState then
        self.topState = nil
    end
    self:StateChanged()
    self:UpdateStateView()
    --self:LogStackTable("状态移除完成："..DebugStateName[state])
end

function SystemStateMgr:IsTopState(state)
    return state == self.topState
end

function SystemStateMgr:GetTargetState()
    if next(self.stateQueue) then
        return self.stateQueue[1].state, false  
    end
end

function SystemStateMgr:EnterStateView(state)
   --专属UI、 战斗UI、 输入、实体状态
    local stateInfo = self.stateMap[state]
    if stateInfo.binaryStr then
        BehaviorFunctions.SetFightPanelVisible(stateInfo.binaryStr)
    end
    if stateInfo.panelMap then
        for k, v in pairs(stateInfo.panelMap) do
            v:ActiveSystemState(true, state)
        end
    end

    if stateInfo.entityState then
        local instanceId = BehaviorFunctions.GetCtrlEntity()
        if not self.lastEntityState then
            local entity = BehaviorFunctions.GetEntity(instanceId)
            local lastState = entity.stateComponent:GetState()
            if lastState ~= FightEnum.EntityState.Glide then
                lastState = FightEnum.EntityState.Idle
            end
            self.lastEntityState = lastState
        end
        BehaviorFunctions.DoSetEntityState(instanceId, stateInfo.entityState)
    end

    if stateInfo.camState then
        if not self.lastCamState then
            self.lastCamState = CameraManager.Instance:GetCameraState()
        end
        CameraManager.Instance:SetCameraState(stateInfo.camState)
    end
end

function SystemStateMgr:ExitStateView(state)
    local stateInfo = self.stateMap[state]
    if not stateInfo then return end
    if stateInfo.panelMap then
        for k, v in pairs(stateInfo.panelMap) do
            v:ActiveSystemState(false, state)
        end
    end
end

function SystemStateMgr:EnterState(state, params)
    if not state then
        local stateData = table.remove(self.stateQueue, 1)
        if stateData then
            table.insert(self.stateStack, stateData)
            state = stateData.state
            params = stateData.params
        else
            return
        end
    end
    self.stateMap[state] = self.stateMap[state] or {}
    self.stateMap[state].activeCount = true
    --调用方法进入目标状态
    SystemStateMgr.Log("进入状态", DebugStateName[state])

    EventMgr.Instance:Fire(EventName.EnterSystemState, state, table.unpack(params))
    if SystemStateConfig.EnterFuncs[state] then
        SystemStateConfig.EnterFuncs[state](table.unpack(params))
    end
end

function SystemStateMgr:ExitState(state)
    --提前结束目标状态
    EventMgr.Instance:Fire(EventName.ExitSystemState, state)
    if SystemStateConfig.ExitFuncs[state] then
        SystemStateConfig.ExitFuncs[state]()
    end
end

function SystemStateMgr:StateChanged()
    local target, active = self:GetTargetState()
    if not target then return end
    if active then
        goto continue
    end

    if not next(self.stateStack) then
        self:EnterState()
        goto continue
    end

    for i, v in ipairs(self.stateStack) do
        local curState = v.state
        if SystemStateConfig.GetStateTransition(curState, target) == TransitionType.LineUp then
            return
        end
    end

    for i, v in ipairs(self.stateStack) do
        local curState = v.state
        if SystemStateConfig.GetStateTransition(curState, target) == TransitionType.Break then
            self:ExitState(curState)
        end
    end
    self:EnterState()

    ::continue::
    table.sort(self.stateStack, function(a, b)
        if StateWeight[a.state] == StateWeight[b.state] then
            return a.timeIndex < b.timeIndex
        end
        return StateWeight[a.state] > StateWeight[b.state]
    end)
    self:StateChanged()
end

function SystemStateMgr:UpdateStateView()
    local state = self.stateStack[1] and self.stateStack[1].state
    if self.topState ~= state and state then
        self:ExitStateView(self.topState)
        self:EnterStateView(state)
    end
    self.topState = state
    if not self.topState then
        BehaviorFunctions.SetFightPanelVisible("-1")
        if self.lastEntityState then
            BehaviorFunctions.DoSetEntityState(BehaviorFunctions.GetCtrlEntity(), self.lastEntityState)
            self.lastEntityState = nil
        end
        if self.lastCamState then
            CameraManager.Instance:SetCameraState(self.lastCamState)
            self.lastCamState = nil
        end
    end
    --self.curTipQueueState
    local tipState = TipQueueState.Play
    for i, v in ipairs(self.stateStack) do
        local temp = SystemStateConfig.GetTipQueueState(v.state)
        tipState = temp > tipState and temp or tipState
    end
    if self.curTipQueueState ~= tipState then
        self.curTipQueueState = tipState
        if Fight.Instance then
            Fight.Instance.tipQueueManger:TryShow()
        end
    end
end


function SystemStateMgr:OpenSystem()
    if Fight.Instance then
        Fight.Instance.tipQueueManger:PauseFightTip()
    end
    BehaviorFunctions.StoryPauseDialog()
end

function SystemStateMgr:CloseSystem()
    if Fight.Instance then
        Fight.Instance.tipQueueManger:ResumeFightTip()
    end
    BehaviorFunctions.StoryResumeDialog()
end
---SystemStateMgr.Instance:SetFightVisible(state, binaryStr)
function SystemStateMgr:SetFightVisible(state, binaryStr)
    self.stateMap[state] = self.stateMap[state] or {}
    self.stateMap[state].binaryStr = binaryStr
    if self:IsTopState(state) then
        BehaviorFunctions.SetFightPanelVisible(binaryStr)
    end
end
--SystemStateMgr.Instance:ChangeEntityState(StateType.Story,FightEnum.EntityState.Perform)
function SystemStateMgr:ChangeEntityState(state, entityState)
    self.stateMap[state] = self.stateMap[state] or {}
    self.stateMap[state].entityState = entityState
    if self:IsTopState(state) then
        local instanceId = BehaviorFunctions.GetCtrlEntity()
        if not self.lastEntityState then
            local entity = BehaviorFunctions.GetEntity(instanceId)
            local lastState = entity.stateComponent:GetState()
            if lastState ~= FightEnum.EntityState.Glide then
                lastState = FightEnum.EntityState.Idle
            end
            self.lastEntityState = lastState
            BehaviorFunctions.DoSetEntityState(instanceId, entityState)
        end
    end
end

function SystemStateMgr:SetCameraState(state, camState)
    self.stateMap[state] = self.stateMap[state] or {}
    self.stateMap[state].camState = camState
    if self:IsTopState(state) then
        if not self.lastCamState then
            self.lastCamState = CameraManager.Instance:GetCameraState()
            CameraManager.Instance:SetCameraState(camState)
        end
    end
end

function SystemStateMgr:AddStateView(state, panel)
    self.stateMap[state] = self.stateMap[state] or {}
    self.stateMap[state].panelMap = self.stateMap[state].panelMap or {}
    local panelMap = self.stateMap[state].panelMap
    panelMap[panel.__className] = panel
end

function SystemStateMgr:RemoveStateView(state, panel)
    local panelMap = self.stateMap[state].panelMap
    panelMap[panel.__className] = nil
end

function SystemStateMgr:CanShowFightTip()
    return self.curTipQueueState < TipQueueState.PausePart
end

function SystemStateMgr:CanShowSystemTip()
    return self.curTipQueueState < TipQueueState.Pause
end

function SystemStateMgr:StateActive(state)
    if self.stateMap[state] and self.stateMap[state].activeCount then
        return true
    end
end

function SystemStateMgr:Clear()
    TableUtils.ClearTable(self.stateStack)
    TableUtils.ClearTable(self.stateQueue)
    TableUtils.ClearTable(self.stateMap)
    self.topState = nil --主状态，决定公共模块表现
    self.lastEntityState = nil
    self.lastCamState = nil
    self.curTipQueueState = TipQueueState.Play
end

function SystemStateMgr:LogStackTable(name)
    local res = {
        ["激活中的状态"] = {},
        ["排队中的状态"] = {},
    }

    for i, v in ipairs(self.stateStack) do
        table.insert(res["激活中的状态"], DebugStateName[v.state])
    end

    for i, v in ipairs(self.stateQueue) do
        table.insert(res["排队中的状态"], DebugStateName[v.state])
    end
    LogTable(name, res)
    --SystemStateMgr.Log("当前输入模式", InputManager.Instance:GetNowActionMapName())
end

function SystemStateMgr.Log(...)
    --Log("系统状态", ...)
end
