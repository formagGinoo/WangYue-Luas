
-- 0.1s一帧
local SECOND_PER_FRAME = 0.1 
local FRAME_RATE = 1 / SECOND_PER_FRAME 

-- 20s之内的timer
local WHEEL_SIZE_1 = 200 
-- 20分钟
local WHEEL_SIZE_2 = 60 
-- 20小时
local WHEEL_SIZE_3 = 60 
-- 50天
local WHEEL_SIZE_4 = 60

local WHEEL_SIZE_MUL12 = WHEEL_SIZE_1*WHEEL_SIZE_2
local WHEEL_SIZE_MUL123 = WHEEL_SIZE_1*WHEEL_SIZE_2*WHEEL_SIZE_3
local WHEEL_SIZE_MUL1234 = WHEEL_SIZE_1*WHEEL_SIZE_2*WHEEL_SIZE_3*WHEEL_SIZE_4

local TIMER_COUNTER = 1

local INNER_BARRIER = false 

local floor = math.floor

local function _CreateWheel(scale)
    local wheel = {} 
    for i=1,scale do
        wheel[i-1] = {}
    end
    wheel.index = 0 
    wheel.bound = scale

    return wheel
end

Timer = BaseClass("Timer")
function Timer:__init()
    if Timer.Instance then
        Log.Error("单例对象重复实例化")
    end

    Timer.Instance = self

    self:Clear()
end

function Timer:Clear()
    self.elapseTime = 0
    -- 帧数
    self.currentFrameIdx = 0 

    self.wheels = {
        _CreateWheel(WHEEL_SIZE_1), 
        _CreateWheel(WHEEL_SIZE_2), 
        _CreateWheel(WHEEL_SIZE_3), 
        _CreateWheel(WHEEL_SIZE_4)
    }

    self.timerIdMap = {}
end


function Timer:InternalAddTimer(timer)
    local expires = timer.expires
    local idx = expires - self.currentFrameIdx
    local slot
    if idx <= 0 then
        -- 在下一次update 调用
        local wheelIdx = self.wheels[1].index 
        if INNER_BARRIER then 
            wheelIdx = (wheelIdx + 1) % WHEEL_SIZE_1
        end
        slot = self.wheels[1][wheelIdx]

    elseif idx < WHEEL_SIZE_1 then   
        slot = self.wheels[1][ expires % WHEEL_SIZE_1 ]
    elseif idx < WHEEL_SIZE_MUL12 then
        slot = self.wheels[2][ (floor(expires/WHEEL_SIZE_1)-1) % WHEEL_SIZE_2 ]
    elseif idx < WHEEL_SIZE_MUL123 then
        slot = self.wheels[3][ (floor(expires/WHEEL_SIZE_MUL12)-1) % WHEEL_SIZE_3 ]
    elseif idx < WHEEL_SIZE_MUL1234 then 
        slot = self.wheels[4][ (floor(expires/WHEEL_SIZE_MUL123)-1) % WHEEL_SIZE_4 ]
    else
        Log.Debug("too long timer", timer)
        return
    end

    if not slot then 
        Log.Error("InternalAddTimer", idx, timer, self.currentFrameIdx, self.wheels, debug.traceback())
        return
    end

    slot[timer.id] = timer
    self.timerIdMap[timer.id] = slot
end

-- 注释，
-- callback
-- 参数
-- expires 秒， 精确到0.1
function Timer:AddTimer(expires, cb, arg1, arg2, cycle)
    TIMER_COUNTER = TIMER_COUNTER + 1

    cycle = cycle or 0

    local timer = {
        id = TIMER_COUNTER,
        expires = math.floor((expires + self.elapseTime) * FRAME_RATE) + self.currentFrameIdx,
        arg1 = arg1,
        arg2 = arg2,
        callback = cb,
        cycle = cycle * FRAME_RATE,
    }

    self:InternalAddTimer(timer)

    return TIMER_COUNTER
end

function Timer:RemoveTimer(timerId)
    assert(timerId, "nil timerId found")

    local slot = self.timerIdMap[timerId]  
    if slot then
        slot[timerId] = nil
        self.timerIdMap[timerId] = nil
    end
end

function Timer.Add(...)
    Timer.Instance:AddTimer(...)
end

function Timer.Remove(...)
    Timer.Instance:Remove(...)
end

function Timer:CastWheelTimers(wheel)
    local slot = wheel[wheel.index]
    
    for _, timer in pairs(slot) do
        self:InternalAddTimer(timer)
    end

    wheel[wheel.index] = {}
    wheel.index = wheel.index + 1
end

function Timer:FixedUpdate()
    self.elapseTime = self.elapseTime + Time.unscaledDeltaTime

    while self.elapseTime > SECOND_PER_FRAME do 
        -- 0.1s一帧
        self.elapseTime = self.elapseTime - SECOND_PER_FRAME 

        local wheel = self.wheels[1]
        local wheelIdx = 1 
        while wheel.index >= wheel.bound do 
            wheel.index = 0 
            wheelIdx = wheelIdx + 1
            wheel = self.wheels[wheelIdx] 
            self:CastWheelTimers(wheel) 
        end
        wheel = self.wheels[1]

        local slot = wheel[wheel.index] 
        for idx, timer in pairs(slot) do

            INNER_BARRIER = true
            local result = timer.callback(timer.arg1, timer.arg2, timer.id)
            INNER_BARRIER = false

            self:RemoveTimer(idx)

            if timer.cycle > 0 and result then
                timer.expires = timer.expires + timer.cycle 
                self:InternalAddTimer(timer)
            end
        end

        self.currentFrameIdx = self.currentFrameIdx + 1
        wheel.index = wheel.index + 1
    end
end

