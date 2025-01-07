CustomFSM = BaseClass("CustomFSM", PoolBaseClass)

function CustomFSM:__init()
    self.states = {}
end

function CustomFSM:Init(fight, entity, configId, customParam)
    self.fight = fight
    self.entity = entity
    self.configId = configId
    self.initState = nil
    self.config = Config["CustomFsm" .. self.configId]
    self.customParam = customParam
    if not self.config then
        LogError("CustomFSM " .. configId .. " 不存在！")
    end

    self:InitStates()
end

function CustomFSM:InitStates()
    local objectPool = self.fight.objectPool
    for _, v in pairs(self.config.SubFSMDatas) do
        local machine = objectPool:Get(CustomMachine)
        self:AddState(v.MachineId, machine)
        if v.IsInitState then
            self.initState = v.MachineId
        end
    end

    for _, v in pairs(self.config.SubFSMDatas) do
        self.states[v.MachineId]:Init(self.fight, self.entity, v, self)
    end
end

function CustomFSM:LateInit(isRoot)
    if isRoot then
        self:OnEnter()
    end
end

function CustomFSM:AddState(state, stateMachine)
    self.states[state] = stateMachine
end

function CustomFSM:OnEnter(parentBehaviorInstancesId)
    if not self.behaviorInstancesId then
        local parentBehavior = parentBehaviorInstancesId and self.entity.behaviorComponent:GetBehavior(parentBehaviorInstancesId)
        local behavior = self.entity.behaviorComponent:AddBehavior(self.config.BehaviorId, "FSMBehavior", nil, parentBehavior)
        behavior.customParam = self.customParam
        self.behaviorInstancesId = behavior.behaviorInstancesId
    end
    self:SwitchState(self.initState)
    self.states[self.curState]:OnEnter()
end

function CustomFSM:OnLeave()
    local behavior = self.entity.behaviorComponent:GetBehavior(self.behaviorInstancesId)
    if behavior.OnLeaveState then
        behavior:OnLeaveState()
    end
    self.entity.behaviorComponent:RemoveBehavior(self.behaviorInstancesId)
    self.behaviorInstancesId = nil

    self.states[self.curState]:OnLeave()
    self.curState = nil
end

function CustomFSM:SwitchState(state, ...)
    local lastState = self.states[self.curState]
    if lastState and state ~= self.curState then
        lastState:OnLeave()
    end

    self.curState = state
    self.statesMachine = self.states[self.curState]
    self.statesMachine:OnEnter(...)
end

function CustomFSM:Update()
    if not self.statesMachine then
        return
    end
    self.statesMachine:Update()
end

function CustomFSM:IsState(state)
    return self.curState == state
end

function CustomFSM:TryChangeState()
    return self.states[self.curState]:checkJumpTargetList()
end

function CustomFSM:GetState()
    return self.curState
end

function CustomFSM:GetCurStateName()
    return self.states[self.curState]:GetCurStateName()
end

function CustomFSM:GetSubState()
    if self.states[self.curState].type == FightEnum.CommonFSMType.SubFSM then
        return self.states[self.curState]:GetSubState()
    end
end

function CustomFSM:CacheStates()
    for k, v in pairs(self.states) do
        v:OnCache()
    end
    self.states = {}
end

--注册对事件的回调
function CustomFSM:RegisterEventListener(eventName, callback)
    EventMgr.Instance:AddListener(eventName, function()
        callback()
        self.states[self.curState]:checkJumpTargetList()
    end)
end

--注册对黑板数据的监听
function CustomFSM:RegisterBlackBoardListener(dataName, callback)
    callback()
    self.states[self.curState]:checkJumpTargetList()
end

function CustomFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(CustomFSM, self)
end

function CustomFSM:__cache()
    self.states = {}
    self.fight = nil
    self.entity = nil
    self.config = nil
    self.initState = nil
    self.behaviorInstancesId = nil
    self.curState = nil
end

function CustomFSM:__delete()
    for k, v in pairs(self.states) do
        v:DeleteMe()
    end
    self.states = nil
end