TimeUtils = BaseClass("TimeUtils")

--登录时初始化，所以登录后才能使用!!!
TimeUtils.serverTime = nil
TimeUtils.timezone = 8
TimeUtils.timeOffset = 0

local minuteSeconds = 60
local hourSeconds = 3600
local daySeconds = 86400

--获取当前时间戳/根据服务器时区
function TimeUtils.GetCurTimestamp()
    return math.floor(TimeUtils.serverTime + TimeUtils.timeOffset)
end

local function GetTimezoneOffset()
    local now = os.time()
    local utcNow = os.time(os.date("!*t", now))

    local timezoneOffsetInSeconds = os.difftime(now, utcNow)
    local timezoneOffsetInHour = timezoneOffsetInSeconds / 3600

    return TimeUtils.timezone - timezoneOffsetInHour
end

--基于服务器所在时区，获取最近的周一n(四)点的时间戳
function TimeUtils.getNextMondayAtHour(hour)
    hour = hour or 4
    -- 获取输入时间戳对应的日期表
    local inputDate = os.date("*t")

    local offset = GetTimezoneOffset()
    inputDate.hour = inputDate.hour + offset
    local nextMonday
    -- 如果当前时间是周一并且时间小于 4 点，则返回当天的 4 点
    if inputDate.wday == 2 and inputDate.hour < hour then
        nextMonday = os.time({
            year = inputDate.year,
            month = inputDate.month,
            day = inputDate.day,
            hour = hour + offset,
            min = 0,
            sec = 0
        })
    else
        -- 否则，计算距离下一个周一还有几天
        local daysToNextMonday = (8 - inputDate.wday) % 7 + 1
        -- 将输入时间调整到下一个周一，并设置小时数为 hour
        nextMonday = os.time({
            year = inputDate.year,
            month = inputDate.month,
            day = inputDate.day + daysToNextMonday,
            hour = hour + offset,
            min = 0,
            sec = 0
        })
    end

    return nextMonday
end

--基于服务器所在时区，获取最近的周x,y(四)点的时间戳
function TimeUtils.getNextWeekAtDayAndHour(day,hour)
    day = (day + 1) or 4
    hour = hour or 4
    if day == 8 then day = 1 end
    -- 获取输入时间戳对应的日期表
    local inputDate = os.date("*t")

    local offset = GetTimezoneOffset()
    inputDate.hour = inputDate.hour + offset
    local nextWday
    -- 如果当前时间是周一并且时间小于 4 点，则返回当天的 4 点
    if inputDate.wday == day and inputDate.hour < hour then
        nextWday = os.time({
            year = inputDate.year,
            month = inputDate.month,
            day = inputDate.day,
            hour = hour + offset,
            min = 0,
            sec = 0
        })
    else
        -- 否则，计算距离下一个周y还有几天
        local daysToNextWday = ((8 - inputDate.wday)+ (day - 1))%7
        -- 将输入时间调整到下一个周一，并设置小时数为 hour
        nextWday = os.time({
            year = inputDate.year,
            month = inputDate.month,
            day = inputDate.day + daysToNextWday,
            hour = hour + offset,
            min = 0,
            sec = 0
        })
    end
    return nextWday
end

--基于服务器所在时区，获取最近的下一个每月15号四点的时间戳
function TimeUtils.getTimestampForNextMonthDayHour(day, hour)
    day = day or 15
    hour = hour or 4
    -- 获取当前本地时间表
    local currentDate = os.date("*t")
    local offset = GetTimezoneOffset()
    currentDate.hour = currentDate.hour + offset
    -- 检查今天是否为所需的天数，并且当前时间小于 5 点
    if currentDate.day == day and currentDate.hour < hour then
        currentDate.hour = hour + offset
        currentDate.min = 0
        currentDate.sec = 0
    else
        -- 计算当前月份有多少天
        local function getDaysInMonth(month, year)
            local daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
            local days = daysInMonth[month]

            -- 闰年处理
            if month == 2 and (year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)) then
                days = 29
            end

            return days
        end

        local daysInCurrentMonth = getDaysInMonth(currentDate.month, currentDate.year)

        -- 如果所需的天数在当前月内，设置新的日期，否则进入下个月
        if currentDate.day < day and day <= daysInCurrentMonth then
            currentDate.day = day
        else
            currentDate.month = currentDate.month + 1

            -- 如果月份大于 12，设置新年份并将月份重置为 1
            if currentDate.month > 12 then
                currentDate.year = currentDate.year + 1
                currentDate.month = 1
            end

            -- 设置所需的天数
            currentDate.day = day
        end

        currentDate.hour = hour + offset
        currentDate.min = 0
        currentDate.sec = 0
    end

    -- 将调整后的日期转换为时间戳并返回
    return os.time(currentDate)
end

--基于服务器所在时区，获取最近的下一个n(五)点的时间戳
function TimeUtils.getNextClosestHour(hour)
    hour = hour or 4
    local offset = GetTimezoneOffset()
    -- 获取当前本地时间表
    local currentDate = os.date("*t")
    currentDate.hour = currentDate.hour + offset

    -- 检查当前时间是否小于 4 点，如果是，则设置为当天的 4 点，否则设置为明天的 4 点
    if currentDate.hour < hour then
        currentDate.hour = hour + offset
    else
        currentDate.day = currentDate.day + 1
        currentDate.hour = hour + offset
    end

    -- 将分钟和秒钟重置为零
    currentDate.min = 0
    currentDate.sec = 0

    -- 将调整后的日期转换为时间戳并返回
    return os.time(currentDate)
end

--将给定的秒数转换为天数、小时数和分钟数
function TimeUtils.convertSecondsToDHMs(seconds)
    -- 计算天数、小时数和分钟数
    local result = {}
    result.days = math.floor(seconds / (daySeconds))
    result.hours = math.floor((seconds % (daySeconds)) / (hourSeconds))
    result.minutes = math.floor((seconds % (hourSeconds)) / minuteSeconds)

    return result
end

--根据服务器时区解析配置时间到时间戳，需求定下，配置格式定好再做
function TimeUtils.SecondsToDaysHoursMinutes(param)

end

function TimeUtils.GetRefreshTimeByRefreshId(refreshId)
    local refreshInfo = Config.DataRefresh.Find[refreshId]
    local time
    if refreshInfo.refresh_type == 1 then
        time = TimeUtils.getNextClosestHour() - TimeUtils.GetCurTimestamp()
    elseif refreshInfo.refresh_type == 2 then
        time = TimeUtils.getNextWeekAtDayAndHour(refreshInfo.refresh_param) - TimeUtils.GetCurTimestamp()
    elseif refreshInfo.refresh_type == 3 then
        time = TimeUtils.getTimestampForNextMonthDayHour(refreshInfo.refresh_param) - TimeUtils.GetCurTimestamp()
    end
    return TimeUtils.convertSecondsToDHMs(time)
end




