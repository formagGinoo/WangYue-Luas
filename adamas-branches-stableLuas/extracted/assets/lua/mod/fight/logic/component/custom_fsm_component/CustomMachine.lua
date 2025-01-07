CustomMachine = BaseClass("CustomMachine", PoolBaseClass)

function CustomMachine:__init()

end

function CustomMachine:Init(fight, entity, config, parent)
    self.fight = fight
    self.entity = entity
    self.config = config
    self.type = self.config.Type
    self.parent = parent

    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM = self.fight.objectPool:Get(CustomFSM)
        self.subFSM:Init(fight, entity, self.config.SubFSMId)
    elseif self.type == FightEnum.CommonFSMType.State then

    end
end

function CustomMachine:LateInit()
end

function CustomMachine:OnEnter(...)
    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM:OnEnter(self.parent.behaviorInstancesId, ...)
    elseif self.type == FightEnum.CommonFSMType.State then
        if not self.behaviorInstancesId then
            local parentBehavior = self.parent.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.parent.behaviorInstancesId)
            local behavior = self.entity.behaviorComponent:AddBehavior(self.config.BehaviorId, "FSMBehavior", nil, parentBehavior)
            behavior.customParam = self.parent.customParam
            self.behaviorInstancesId = behavior.behaviorInstancesId
        end
    end

    self:AddBlackBoardDataListener()
end

function CustomMachine:Update()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM:Update()
    end
end

function CustomMachine:OnLeave()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM:OnLeave()
    elseif self.type == FightEnum.CommonFSMType.State then
        local behavior = self.entity.behaviorComponent:GetBehavior(self.behaviorInstancesId)
        if behavior.OnLeaveState then
            behavior:OnLeaveState()
        end
        self.entity.behaviorComponent:RemoveBehavior(self.behaviorInstancesId)
        self.behaviorInstancesId = nil
    end
    self:RemoveBlackBoardDataListener()
end

--检测当前状态跳转列表里哪些状态是可到达的
function CustomMachine:checkJumpTargetList()
    for _, v in pairs(self.config.JumpTargetLists) do
        local parentBehavior = self.parent.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.parent.behaviorInstancesId)
        local curBehavior
        if self.type == FightEnum.CommonFSMType.SubFSM then
            curBehavior = self.subFSM.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.subFSM.behaviorInstancesId)
        elseif self.type == FightEnum.CommonFSMType.State then
            curBehavior = self.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.behaviorInstancesId)
        end

        if v.useBehaviorFun and curBehavior[v.checkFunName](self.entity.instanceId, parentBehavior, curBehavior, curBehavior.MainBehavior) then
            self.parent:SwitchState(v.TargetMachineId)
            return true
        elseif not CustomFsmChangeStateFunctions[v.checkFunName] then
            if ctx.Editor then
                if not v.checkFunName then
                    LogError("从状态【" .. self.config.Name .. "】到【" .. v.Name .. "】的跳转条件函数为nil")
                else
                    LogError("从状态【" .. self.config.Name .. "】到【" .. v.Name .. "】的跳转条件函数【" .. (v.checkFunName) .. "】 不存在")
                end
            end
        elseif CustomFsmChangeStateFunctions[v.checkFunName](self.entity.instanceId, parentBehavior, curBehavior, curBehavior.MainBehavior) then
            self.parent:SwitchState(v.TargetMachineId)
            return true
        end
    end
    if self.type == FightEnum.CommonFSMType.SubFSM then
        return self.subFSM:TryChangeState()
    end
    return false
end

--注册对黑板数据的监听
function CustomMachine:AddBlackBoardDataListener()
    for _, jumpTarget in pairs(self.config.JumpTargetLists) do
        for _, key in pairs(jumpTarget.DataListenerList) do
            CustomDataBlackBoard.Instance:AddListener(CustomFsmDataBlackBoardEnum[key], self:ToFunc("checkJumpTargetList"))
        end
    end
end

--取消对黑板数据的监听
function CustomMachine:RemoveBlackBoardDataListener()
    for _, jumpTarget in pairs(self.config.JumpTargetLists) do
        for _, key in pairs(jumpTarget.DataListenerList) do
            CustomDataBlackBoard.Instance:RemoveListener(CustomFsmDataBlackBoardEnum[key], self:ToFunc("checkJumpTargetList"))
        end
    end
end

function CustomMachine:GetSubState()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        return self.subFSM:GetState()
    end
end

function CustomMachine:GetCurStateName()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        return self.subFSM:GetCurStateName()
    else
        return self.config.Name .. "[" .. self.config.BehaviorId .. "]"
    end
end

function CustomMachine:OnCache()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM:OnCache()
        self.subFSM = nil
    elseif self.type == FightEnum.CommonFSMType.State then
        if self.entity.behaviorComponent then
            self.entity.behaviorComponent:RemoveBehavior(self.behaviorInstancesId)
        end
    end
    self:RemoveBlackBoardDataListener()
    self.fight.objectPool:Cache(CustomMachine, self)
end

function CustomMachine:OnSwitchEnd()

end

function CustomMachine:__cache()
    self.fight = nil
    self.entity = nil
    self.config = nil
    self.type = nil
    self.parent = nil
    self.behaviorInstancesId = nil
end

function CustomMachine:__delete()
    if self.type == FightEnum.CommonFSMType.SubFSM and self.subFSM then
        self.subFSM:DeleteMe()
        self.subFSM = nil
    end
end