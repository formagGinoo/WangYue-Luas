FSMBehaviorBase = BaseClass("FSMBehaviorBase",BehaviorBase)

function FSMBehaviorBase:__init()
end

function FSMBehaviorBase:SetParentBehavior(ParentBehavior)
    if ParentBehavior.MainBehavior then
        self.MainBehavior = ParentBehavior.ParentBehavior
    else
        self.MainBehavior = ParentBehavior
    end
    self.ParentBehavior = ParentBehavior
end