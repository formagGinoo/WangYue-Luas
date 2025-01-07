TimerAction = BaseClass("TimerAction")
TimerAction.poolKey = "timer_action"
local Time = Time

function TimerAction:__init()
    self.id = nil
    self.iter = nil
    self.leftTime = 0.0
    self.count = nil
    self.time = nil
    self.callback = nil
    self.args = nil
    self.loop = nil
    self.clearOffset = true
    self.curTime = nil
    self.createFrame = 0
    self.runCount = 0
    self.cancel = false
    self.runError = false
    self.waitNextFrame = false
end

function TimerAction:Init(count,time,callback)
    self.count = count or 0
    self.time = time or 0
    self.callback = callback
    self.loop = self.count <= 0
    -- self.debug = debug.traceback()
    self.createFrame = Time.frameCount
    self.cancel = false
    self.isScale = false or DebugConfig.UseRenderFrame
end

function TimerAction:SetArgs(args)
    self.args = args
end

function TimerAction:SetDelay(delayTime)
    self.leftTime = -1 * delayTime
end

function TimerAction:SetClearOffset(clearOffset)
    self.clearOffset = clearOffset
end

function TimerAction:SetGroup(group)
    self.group = group
end

function TimerAction:SetScale(flag)
    self.isScale = flag
end

function TimerAction:ResetNowTime()
    self.nowTime = Time.realtimeSinceStartup
end

function TimerAction:Run()
    if not self.callback or self.runError or self.cancel then return false end
    local deltaTime = self:unDeltaScale()
    if not self:isExecute(deltaTime) then return true end
    if not self.loop then self.count = self.count - 1 end
    local isFinish = not self.loop and self.count <= 0
    self.runCount = self.runCount + 1
    self.runError = true
    self.callback(self.args,isFinish,self.runCount,self.id)
    self.runError = false
    return not isFinish
end

function TimerAction:unDeltaScale()
    if self.isScale then 
        return Time.deltaTime
    else
        return Time.unscaledDeltaTime
    end
end

function TimerAction:isExecute(delta)
    self.leftTime = self.leftTime + delta
    if self.leftTime < self.time then return false end
    self.leftTime = self.clearOffset and 0 or self.leftTime - self.time
    return true
end

function TimerAction:RunCallback()
    if not self.callback or self.runError or self.cancel then return end
    self.callback(self.args)
end

function TimerAction:SetCancel(flag)
    self.cancel = flag
end

function TimerAction:OnReset()
    self.id = nil
    self.iter = nil
    self.leftTime = 0.0
    self.count = nil
    self.time = nil
    self.callback = nil
    self.args = nil
    self.loop = nil
    self.clearOffset = true
    self.curTime = nil
    self.runCount = 0
    self.cancel = false
    self.runError = false
    self.waitNextFrame = false
end
