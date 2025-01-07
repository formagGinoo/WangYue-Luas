RedPointNode = BaseClass("RedPointNode")

function RedPointNode:__init()
    self.parent = nil
    self.redCount = 0
    self.bindCount = 0
    self.isRed = false
    self.isSystemOpen = true
    self.eventActive = false
    self.childMap = {}
end

function RedPointNode:__delete()
    EventMgr.Instance:RemoveListener(EventName.RefreshRedPoint, self:ToFunc("RefreshRedPointByKey"))
    for key, eventName in pairs(self.nodeData.eventList) do
        EventMgr.Instance:RemoveListener(eventName, self:ToFunc("RefreshRedPoint"))
    end
end

function RedPointNode:RemoveEvent()
    if self.eventActive == false then return end
    for key, eventName in pairs(self.nodeData.eventList) do
        EventMgr.Instance:RemoveListener(eventName, self:ToFunc("RefreshRedPoint"))
    end
    self.eventActive = false
end

function RedPointNode:BindEvent()
    if self.eventActive == true then return end
    for key, eventName in pairs(self.nodeData.eventList) do
        EventMgr.Instance:AddListener(eventName, self:ToFunc("RefreshRedPoint"))
    end
    self.eventActive = true
end

function RedPointNode:AddBind()
    if self.bindCount == 0 then 
        self:BindEvent()
        for k, v in pairs(self.childMap) do
            v:AddBind()
        end
    end
    self.bindCount = self.bindCount + 1
    self:RefreshRedPoint()
end

function RedPointNode:RemoveBind()
    if self.bindCount > 0 then
        self.bindCount = self.bindCount - 1
        if self.bindCount == 0 then
            self:RemoveEvent()
            for k, v in pairs(self.childMap) do
                v:RemoveBind()
            end
        end
    end
end

function RedPointNode:RefreshRedPointByKey(key)
    if key == self.key then
        self:RefreshRedPoint()
    end
end

function RedPointNode:RefreshRedPoint()
    if RedPointMgr.Instance:IsDelayRefresh() then
        RedPointMgr.Instance:AddDelayNode(self)
        return
    end
    for key, value in pairs(self.childMap) do
        value:RefreshRedPoint()
    end

    local oldState = self:GetState()

    if self.nodeData.checkSystemOpenFunc then
        self.isSystemOpen = self.nodeData.checkSystemOpenFunc()
    end

    if self.nodeData.checkFunc then
        self.isRed = self.nodeData.checkFunc()
    end

    local newState = self:GetState()
    --LogError("RefreshRedPoint", self.key)
    self:StateChanged(oldState, newState)
end

function RedPointNode:AddRedCount(value)
    if self.isSystemOpen == false then
        self.isSystemOpen = self.nodeData.checkSystemOpenFunc()
    end
    local oldState = self:GetState()
    self.redCount = self.redCount + value
    local newState = self:GetState()
    self:StateChanged(oldState, newState)
end

function RedPointNode:StateChanged(oldState, newState)
    if oldState ~= newState then
        RedPointMgr.Instance:RedPointStateChange(self.key, newState)
        if self.parent then
            if newState then
                self.parent:AddRedCount(1)
            else
                self.parent:AddRedCount(-1)
            end
        end
    end
end

function RedPointNode:GetState()
    if not self.isSystemOpen then
        return self.isSystemOpen
    end
    return self.isRed or self.redCount > 0
end

function RedPointNode:SetState(state)
    state = state or false
    local oldState = self:GetState()
    self.isRed = state
    local newState = self:GetState()
    self:StateChanged(oldState, newState)
end

function RedPointNode:CreateNode(key, parent, nodeData)
    self.key = key
    self.nodeData = nodeData or RedPointConfig.GetNodeData(key)
    self.parent = parent
    if parent then
        self.parent.childMap[key] = self
    end
    RedPointMgr.Instance:AddRedInfo(self.key, self)
    EventMgr.Instance:AddListener(EventName.RefreshRedPoint, self:ToFunc("RefreshRedPointByKey"))
	--self:BindEvent()

    for _, childKey in pairs( self.nodeData.childs) do
        self:AddChild(childKey)
    end
end

function RedPointNode:GetChild(key)
    if not self.childMap[key] then
        LogError("子红点不存在", key)
    else
        return self.childMap[key]
    end
end

function RedPointNode:AddChild(key, state, nodeData)
    if self.childMap[key] then
        LogError("添加重复结点", key)
    end
    local point = RedPointNode.New()
    point:CreateNode(key, self, nodeData)
    --self.childMap[key] = point
    point:SetState(state)
end

function RedPointNode:RemoveAllChild()
    for k, v in pairs(self.childMap) do
        if  v then
            v:RemoveSelf()
        end
        v = nil
    end
end
function RedPointNode:RemoveChild(key)
    if self.childMap[key] then
        self.childMap[key]:RemoveSelf()
    end
    self.childMap[key] = nil
end

function RedPointNode:RemoveSelf(removeParent)
    for key, value in pairs(self.childMap) do
        value:RemoveSelf()
    end
    TableUtils.ClearTable(self.childMap)
    local oldState = self:GetState()
    if oldState then
        RedPointMgr.Instance:RedPointStateChange(self.key, false)
    end
    if self.parent then
        self.parent.childMap[self.key] = nil
        if oldState then
            self.parent:AddRedCount(-1)
        end
    end
    self:RemoveEvent()
    self:DeleteMe()
end
