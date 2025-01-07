DayNightMgr = BaseClass("DayNightMgr")

local _deltaTime = FightUtil.deltaTimeSecond
local _ctrl = mod.DayNightCtrl

local _day2Second
local _day2Minute
local _Second2minute

local get_integer_and_remainder = function(x, y)
    local quotient = math.floor(x / y) -- 整数部分
    local remainder = x % y -- 余数部分
    return quotient, remainder
end

function DayNightMgr:__init()
    DayNightMgr.Instance = self
    self.pauseCount = 0
    self.time = 0
    self.totalTime = 0 --经过分钟所转换的时间戳
    self.timeData = {hour = 0, minute = 0, singleTime = 0}

    self.changeTime = 0 --更新间隔

    self.timeIndex = 0
    self.timeEventMap = {}
    self.addQueue = {}
    EventMgr.Instance:AddListener(EventName.LogicUpdate, self:ToFunc("Update"))
    _day2Second = SystemConfig.GetCommonValue("RealTimeToGameTime").int_val
    --_day2Second = 4320
    _day2Minute = 24 * 60
    _Second2minute = _day2Second / _day2Minute
end

function DayNightMgr:__delete()
    EventMgr.Instance:RemoveListener(EventName.LogicUpdate, self:ToFunc("Update"))
    DayNightMgr.Instance = nil
end

function DayNightMgr:StartFight()
    local totalMinte = get_integer_and_remainder(_day2Second, 60)
    local hour, minute = get_integer_and_remainder(totalMinte, 60)
    CustomUnityUtils.SetLoopTime(hour, minute)
    self.totalTime = _ctrl:GetTime()
    self:ApplyTime(true)
    self:AddBaseEvent()

    EventMgr.Instance:Fire(EventName.DayNightHourChanged)
end

function DayNightMgr:AddBaseEvent()
    local trunOn = SystemConfig.GetCommonValue("SceneLightTurnOnTime").int_val
    local trunOff = SystemConfig.GetCommonValue("SceneLightTurnOffTime").int_val
    local LightTrunOn = function()
        --MsgBoxManager.Instance:ShowTips(TI18N("开灯了"))
    end
    local LightTrunOff = function()
        --MsgBoxManager.Instance:ShowTips(TI18N("关灯了"))
    end
    self:AddTimeEvent(trunOn, trunOff, LightTrunOn, LightTrunOff)
end

function DayNightMgr:Update()
    if self:IsPause() then return end
    self.time = self.time + _deltaTime
    while self.time >= _Second2minute do
        self.time = self.time - _Second2minute
        self:AddMinute(1)
    end
end

local interval = 5
--DayNightMgr.Instance:AddMinute(60, true)
function DayNightMgr:AddMinute(minute,refreshView)
    local hour = self.timeData.hour
    self.totalTime = self.totalTime + minute
    self:ApplyTime(refreshView)
    if refreshView then self.time = 0 end

    local record = false
    self.changeTime =  self.changeTime + minute
    if self.changeTime > interval then
        self.changeTime = 0
        record = true
    end
    self:DayNightTimeChanged(record)
    if hour ~= self.timeData.hour then
        EventMgr.Instance:Fire(EventName.DayNightHourChanged, self.timeData.hour)
    end
end

function DayNightMgr:DayNightTimeChanged(record)
    mod.DayNightCtrl:SetTime(self.totalTime, record)
    local singleTime = self.timeData.singleTime
    EventMgr.Instance:Fire(EventName.DayNightTimeChanged, self.totalTime, singleTime, singleTime * _Second2minute)
    self:UpdateEvent()
end

local showLog = false
function DayNightMgr:ApplyTime(refreshView)
    local singleTime = math.fmod(self.totalTime, _day2Minute)
    local hour, minute = get_integer_and_remainder(singleTime, 60)
    if showLog then
        Logf("当前时间:hour = %s, minute = %s, singleTime = %s", hour, minute, singleTime)
    end
    self.timeData.hour = hour
    self.timeData.minute = minute
    self.timeData.singleTime = singleTime
    if refreshView then
        CustomUnityUtils.SetTime(hour, minute)
    end
end

function DayNightMgr:IsPause()
    return self.pauseCount > 0
end

function DayNightMgr:Pause()
    self.pauseCount = self.pauseCount + 1
    if  self.pauseCount == 1 then
        CustomUnityUtils.SetLoopTime(0, 0)
    end
end

function DayNightMgr:Resume()
    self.pauseCount = self.pauseCount - 1
    if  self.pauseCount == 0 then
        local totalMinte = get_integer_and_remainder(_day2Second, 60)
        local hour, minute = get_integer_and_remainder(totalMinte, 60)
        CustomUnityUtils.SetLoopTime(hour, minute)
    end
end

function DayNightMgr:UpdateEvent()
    for _, v in pairs(self.timeEventMap) do
        self:CheckEvent(v)
    end
end

function DayNightMgr:CheckEvent(event)
    local singleTime = self.timeData.singleTime
    local isEnter = false
        for _, vv in pairs(event.timeArea) do
            if singleTime >= vv.startTime and singleTime <= vv.endTime then
                isEnter = true
                break
            end
        end
        if isEnter and not event.isEnter then
            event.isEnter = true
            if event.enterFunc then event.enterFunc() end
        elseif not isEnter and event.isEnter then
            event.isEnter = false
            if event.exitFunc then event.exitFunc() end
        end
        if event.first then
            event.first = false
            if event.isEnter and event.enterFunc then event.enterFunc() end
            if not event.isEnter and event.exitFunc then event.exitFunc() end
        end
end

function DayNightMgr:AddTimeEvent(startTime, endTime, enterFunc, exitFunc)
    self.timeIndex = self.timeIndex + 1
    local timeArea = {}
    if startTime > endTime then
        table.insert(timeArea,  {startTime = startTime, endTime = 24 * 60 - 1})
        table.insert(timeArea,  {startTime = 0, endTime = endTime})
    else
        table.insert(timeArea,  {startTime = startTime, endTime = endTime})
    end
    local info = {
        timeArea = timeArea,
        enterFunc = enterFunc,
        exitFunc = exitFunc,
        index = self.timeIndex,
        isEnter = false,
        first = true
    }
    self.timeEventMap[self.timeIndex] = info
    self:CheckEvent(info)

    return self.timeIndex
end

function DayNightMgr:RemoveTimeEvent(timeIndex)
    if self.timeEventMap[self.timeIndex] then
        self.timeEventMap[self.timeIndex] = nil
    end
end

function DayNightMgr:GetTime()
    local singleTime = self.timeData.singleTime
    return self.totalTime, singleTime, singleTime * _Second2minute
end

function DayNightMgr:GetStandardTime()
    local data = self.timeData
    return data.hour, data.minute, data.singleTime
end