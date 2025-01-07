LuaTimerManager = SingleClass("LuaTimerManager")

function LuaTimerManager:__init()
    self.uniqueId = 0
    self.removeTimerDict = {}
    self.nextFrameTimerList = List.New()
    self.timerList = List.New()
    self.timerDict = {}
    self.removeTimerList = {}
end

--@count 次数，无限次则填0
--@time 单位：秒
function LuaTimerManager:AddTimer(count,time,callback,timerId)
    local timer = self:GetTimer(timerId)
    if timer then return timer end
    timer = self:createTimer(count,time,callback,timerId)
    local iter = self.timerList:Push(timer)
    timer.iter = iter
    self.timerDict[timer.id] = timer
    return timer
end

function LuaTimerManager:AddTimerByNextFrame(count,time,callback,timerId)
    local timer = self:GetTimer(timerId)
    if timer then return timer end
    timer = self:createTimer(count,time,callback)
    timer.waitNextFrame = true
    local iter = self.nextFrameTimerList:Push(timer)
    timer.iter = iter
    self.timerDict[timer.id] = timer
    return timer
end

function LuaTimerManager:GetTimer(timerId)
    if not timerId then return nil end
    if not self.timerDict[timerId] then return nil end
    return self.timerDict[timerId]
end

function LuaTimerManager:createTimer(count,time,callback,timerId)
    local timerAction = TimerAction.New()
    timerAction:Init(count,time,callback)
    timerAction.id = timerId or self:GetUniqueId()
    return timerAction
end

function LuaTimerManager:RemoveTimer(timer)
    if not timer then return end
    if self:RemoveNextFrameTimer(timer) then return end
    if not self.timerDict[timer.id] then return end
    if timer.waitNextFrame then return end
    timer:SetCancel(true)
    self.removeTimerDict[timer.id] = true
end

function LuaTimerManager:RemoveNextFrameTimer(timer)
    if not self.timerDict[timer.id] then return false end
    if not timer.waitNextFrame then return false end
    self.nextFrameTimerList:Remove(timer.iter)
    self.timerDict[timer.id] = nil
    return true
end

function LuaTimerManager:RemoveTimerByGroup(group)
    for k,v in pairs(self.timerDict) do
        if v.group == group then self:RemoveTimer(v) end
    end
end

function LuaTimerManager:RemoveDiscardTimer()
    local len = self.timerList.length
    if len <= 0 then return end

    TableUtils.ClearTable(self.removeTimerList)
    for item in self.timerList:Items() do
        local isRemove = self:CheckoukRemove(item.value)
        if isRemove then 
            table.insert(self.removeTimerList,item) 
        end
    end

    for i,v in ipairs(self.removeTimerList) do self.timerList:Remove(v) end
end

function LuaTimerManager:CheckoukRemove(timer)
    if not self.removeTimerDict[timer.id] then return false end
    self.removeTimerDict[timer.id] = nil
    self.timerDict[timer.id] = nil
    return true
end

function LuaTimerManager:RemoveAllTimer()
    for k,v in pairs(self.timerDict) do self:RemoveTimer(v) end
end

function LuaTimerManager:Update()
    self:RemoveDiscardTimer()
    self:AddNextFrameTimer()
    for item in self.timerList:Items() do self:RunTimer(item.value) end
end

function LuaTimerManager:RunTimer(timer)
    if timer.cancel then return end
    local continue = timer:Run()
    if continue then return end
    self:RemoveTimer(timer)
end

function LuaTimerManager:AddNextFrameTimer()
    local removeList = {}
    local nowFrame = Time.frameCount
    for item in self.nextFrameTimerList:Items() do
        local isRemove = self:CanAddNextFrameTimer(item.value,nowFrame)
        if isRemove then table.insert(removeList,item) end
    end

    for i,v in ipairs(removeList) do self.nextFrameTimerList:Remove(v) end
end

function LuaTimerManager:CanAddNextFrameTimer(timer,nowFrame)
    if timer.createFrame == nowFrame then return false end
    timer:ResetNowTime()
    local iter = self.timerList:Push(timer)
    timer.waitNextFrame = false
    timer.iter = iter
    return true
end

function LuaTimerManager:GetUniqueId()
    self.uniqueId = self.uniqueId + 1
    return self.uniqueId
end
