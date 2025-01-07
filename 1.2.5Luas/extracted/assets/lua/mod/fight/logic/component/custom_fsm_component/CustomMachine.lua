CustomMachine = BaseClass("CustomMachine",PoolBaseClass)

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
        self.subFSM:Init(fight,entity, self.config.SubFSMId)
    elseif self.type == FightEnum.CommonFSMType.State then

    end
end

function CustomMachine:LateInit()
    if self.subFSM and self.subFSM.LateInit then
        self.subFSM:LateInit()
    end
end

function CustomMachine:OnEnter(...)
    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM:OnEnter(...)
    elseif self.type == FightEnum.CommonFSMType.State then
        if not self.behaviorInstancesId then
            local behavior = self.entity.behaviorComponent:AddBehavior(self.config.BehaviorId, "FSMBehavior")
            local parentBehavior = self.parent.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.parent.behaviorInstancesId)
            if parentBehavior then
                behavior:SetParentBehavior(parentBehavior)
            end
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
        self.entity.behaviorComponent:RemoveBehavior(self.behaviorInstancesId)
        self.behaviorInstancesId = nil
    end
    self:RemoveBlackBoardDataListener()
end

--检测当前状态跳转列表里哪些状态是可到达的
function CustomMachine:checkJumpTargetList()
    for _, v in pairs(self.config.JumpTargetLists) do
        local mainBehavior = self.parent.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.parent.behaviorInstancesId)
        local subBehavior
        if self.type == FightEnum.CommonFSMType.SubFSM then
            subBehavior = self.subFSM.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.subFSM.behaviorInstancesId)
        elseif self.type == FightEnum.CommonFSMType.State then
            subBehavior = self.behaviorInstancesId and self.entity.behaviorComponent:GetBehavior(self.behaviorInstancesId)
        end
        if CustomFsmChangeStateFunctions[v.checkFunName](self.entity.instanceId, mainBehavior, subBehavior) then
            self.entity.customFSMComponent:SwitchState(v.TargetMachineId)
            return
        end
    end
end

--注册对黑板数据的监听
function CustomMachine:AddBlackBoardDataListener()
    for _, jumpTarget in pairs(self.config.JumpTargetLists) do
        for _, key in pairs(jumpTarget.DataListenerList) do
            CustomDataBlackBoard.Instance:AddListener(CustomFsmDataBlackBoardEnum[key], self:ToFunc("checkJumpTargetList"))
        end
    end
end

--注册对黑板数据的监听
function CustomMachine:RemoveBlackBoardDataListener()
    for _, jumpTarget in pairs(self.config.JumpTargetLists) do
        for _, key in pairs(jumpTarget.DataListenerList) do
            CustomDataBlackBoard.Instance:RemoveListener(CustomFsmDataBlackBoardEnum[key], self:ToFunc("checkJumpTargetList"))
        end
    end
end

function CustomMachine:GetSubState()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        return self.subFSM:GetSubState()
    elseif self.type == FightEnum.CommonFSMType.State then
        return self.config.MachineId
    end
end

function CustomMachine:OnCache()
    if self.type == FightEnum.CommonFSMType.SubFSM then
        self.subFSM:OnCache()
        self.subFSM = nil
    elseif self.type == FightEnum.CommonFSMType.State then
        self.entity.behaviorComponent:RemoveBehavior(self.behaviorInstancesId)
    end
    self.fight.objectPool:Cache(CustomMachine,self)
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