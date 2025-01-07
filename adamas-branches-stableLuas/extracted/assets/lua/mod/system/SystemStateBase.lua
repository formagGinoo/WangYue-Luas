SystemStateBase = BaseClass("SystemStateBase")

function SystemStateBase:__init()
    self.stateActive = false
    self.viewActive = false
end

function SystemStateBase:__delete()
    self.stateActive = false
    self.viewActive = false
    self.systemState = nil
end

function SystemStateBase:SetSystemState(state)
    self.systemState = state
end

function SystemStateBase:GetSystemState()
    return self.systemState
end

function SystemStateBase:EnterSystemState(...)
    
end

function SystemStateBase:ExitSystemState(...)

end

function SystemStateBase:__EnterSystemState(...)
    self.stateActive = true
end

function SystemStateBase:__ExitSystemState(...)
    self.stateActive = false 

end

function SystemStateBase:__EnterSystemView(...)
    self.viewActive = true
end

function SystemStateBase:__ExitSystemView(...) 
    self.viewActive = false
end

function SystemStateBase:__Pause(...) end

function SystemStateBase:__Resume(...) end