SystemView = BaseClass("SystemView")

function SystemView:__init()
    self.systemState = nil
    self.systemStateMap = {}
    self.enterFuncs = {}
    self.exitFuncs = {}
end

function SystemView:__delete()
    
end

function SystemView:AddSystemState(state)
    self.systemStateMap[state] = state
    if not self.systemState then
        self:ChangeSystemState(state)
    end
end

function SystemView:ChangeSystemState(state)
    self.systemState = state
end

function SystemView:AddEnterFunc(callBack, state)
    state = state or self.systemState
end

function SystemView:AddExitFunc(callBack, state)
    state = state or self.systemState
end

function SystemView:__Show()
    for k, v in pairs(self.systemStateMap) do
        --Log(self.__className, v or "")
        SystemStateMgr.Instance:AddStateView(v, self)
    end
end

function SystemView:__Hide()
    for k, v in pairs(self.systemStateMap) do
        SystemStateMgr.Instance:RemoveStateView(v, self)
    end
end

function SystemView:__ShowComplete()
    self:TryShowSystemView()
end

function SystemView:ActiveSystemState(active, state)
    state = state or self.systemState
    if state == nil then
        return
    end
    if self.active then
        self:SetViewActive(active, state)
        if active and self.enterFuncs[state] then
            for i, v in ipairs(self.enterFuncs[state]) do
                v()
            end
        end
        if not active and self.exitFuncs[state] then
            for i, v in ipairs(self.exitFuncs[state]) do
                v()
            end
        end
    end
end

--可以在子类中重写
function SystemView:SetViewActive(active, state)
    self.gameObject:SetActive(active)
end

function SystemView:TryShowSystemView(state)
    state = state or self.systemState
    if state == nil then return end
    local active = SystemStateMgr.Instance:IsTopState(state)
    self:SetViewActive(active, state)
    if active and self.enterFuncs[state] then
        for i, v in ipairs(self.enterFuncs[state]) do
            v()
        end 
    end
end
