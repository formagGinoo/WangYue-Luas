FSMBehaviorBase = BaseClass("FSMBehaviorBase",BehaviorBase)

function FSMBehaviorBase:__init()
    self.customParam = {}
end

function FSMBehaviorBase:SetParentBehavior(ParentBehavior)
    if ParentBehavior.MainBehavior then
        self.MainBehavior = ParentBehavior.MainBehavior
    else
        self.MainBehavior = ParentBehavior
    end
    self.ParentBehavior = ParentBehavior
end