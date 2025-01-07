---@class CustomFSMComponent
CustomFSMComponent = BaseClass("CustomFSMComponent",PoolBaseClass)

function CustomFSMComponent:__init()
end

function CustomFSMComponent:Init(fight,entity)
    self.fight = fight
    self.entity = entity
    self.config = entity:GetComponentConfig(FightEnum.ComponentType.CustomFSM)

    self.customFSM = self.fight.objectPool:Get(CustomFSM)
    local customParam = {}
    if self.config.StringValue and self.config.NumberValue then
        customParam = UtilsBase.copytab(self.config.StringValue)
        UtilsBase.covertab(customParam, self.config.NumberValue)
    end
    self.customFSM:Init(fight,entity, self.config.CustomFSMId, customParam)
end

function CustomFSMComponent:LateInit()
    self.customFSM:LateInit(true)
end

function CustomFSMComponent:OnCache()
    self.customFSM:OnCache()
    self.fight.objectPool:Cache(CustomFSMComponent,self)
end

function CustomFSMComponent:SwitchState(state,...)
    self.customFSM:SwitchState(state,...)
end

function CustomFSMComponent:Update()
    self.customFSM:Update()
end

function CustomFSMComponent:IsState(state)
    return self.customFSM:IsState(state)
end

function CustomFSMComponent:GetState()
    return self.customFSM:GetState()
end

function CustomFSMComponent:GetSubState()
    return self.customFSM:GetSubState()
end

function CustomFSMComponent:TryChangeState()
    return self.customFSM:TryChangeState()
end

function CustomFSMComponent:GetCurStateName()
    return self.customFSM:GetCurStateName()
end

function CustomFSMComponent:__cache()
    self.fight = nil
    self.entity = nil
end

function CustomFSMComponent:__delete()

end