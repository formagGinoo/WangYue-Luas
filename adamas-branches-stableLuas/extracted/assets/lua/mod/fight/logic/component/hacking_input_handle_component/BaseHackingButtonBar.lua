BaseHackingButtonBar = BaseClass("BaseHackingButtonBar", PoolBaseClass)

function BaseHackingButtonBar:__Init()
end

function BaseHackingButtonBar:Init(fight, entity, config, title)
    
end

function BaseHackingButtonBar:GetButtonConfig()
    
end

function BaseHackingButtonBar:CallBehavior()
    
end

function BaseHackingButtonBar:GetCostRam()
    return 0
end

function BaseHackingButtonBar:GetCostElectricity()
    return 0
end

function BaseHackingButtonBar:SetActiveState(flag)
    
end

function BaseHackingButtonBar:SetEnable(able)
    self.enable = able
end

function BaseHackingButtonBar:GetEnable()
    return self.enable
end

function BaseHackingButtonBar:OnCache()
    LogError("请在BaseInputHandle的子类中重写OnCache方法")
    self.fight.objectPool:Cache(BaseHackingButtonBar, self)
end

function BaseHackingButtonBar:__cache()

end

function BaseHackingButtonBar:__delete()

end