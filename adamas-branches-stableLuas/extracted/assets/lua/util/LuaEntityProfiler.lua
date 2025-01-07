LuaEntityProfiler = {}

local os = os

function LuaEntityProfiler:StartRecord()
    self.entityRecord = self.entityRecord or {}
    self.functionRecord = self.functionRecord or {}
    self.startRecord = true
    self.curFrame = 0

    self.totalTime = 0
    self.tempClock = 0
end

function LuaEntityProfiler:StopRecord()
    self:PrintResult()

    self.curFrame = 0
    self.startRecord = false
end

function LuaEntityProfiler:UpdateRecord()
    if not self.startRecord then
        return
    end
    self.curFrame = self.curFrame + 1
end

--时间统计开始
function LuaEntityProfiler:StartTiming()
    if not self.startRecord then
        return
    end

    self.tempClock = os.clock()
end


--时间统计结束
function LuaEntityProfiler:EndTiming()
    if not self.startRecord or self.tempClock == 0 then
        return
    end

    self.totalTime = self.totalTime + (os.clock() - self.tempClock)
    self.tempClock = 0
end

--实体创建
function LuaEntityProfiler:OnEntityCreate(instanceId, entityId)
    if not self.startRecord then
        return
    end

    if not self.entityRecord[entityId] then
        self.entityRecord[entityId] = {
            entityId = entityId,
            instances = {},
            maxCount = 0,
            curCount = 0,
            totalCount = 0,
            createTimes = 0,
        }
    end

    self.entityRecord[entityId].createTimes = self.entityRecord[entityId].createTimes + 1
    self.entityRecord[entityId].curCount = self.entityRecord[entityId].curCount + 1
    self.entityRecord[entityId].totalCount = self.entityRecord[entityId].totalCount + 1
    self.entityRecord[entityId].maxCount = self.entityRecord[entityId].curCount > self.entityRecord[entityId].maxCount and
            self.entityRecord[entityId].curCount or self.entityRecord[entityId].maxCount

    self.entityRecord[entityId].instances[instanceId] = {
        time = 0,
        createFrame = self.curFrame,
        lifeFrame = -1,
        updateClock = 0,
    }
end

--实体销毁
function LuaEntityProfiler:OnEntityDestroy(instanceId, entityId)
    if not self.startRecord then
        return
    end
    if not self.entityRecord[entityId] or not self.entityRecord[entityId].instances[instanceId] then
        return
    end

    self.entityRecord[entityId].instances[instanceId].lifeFrame = self.curFrame - self.entityRecord[entityId].instances[instanceId].createFrame
    self.entityRecord[entityId].curCount = self.entityRecord[entityId].curCount - 1
end

--实体更新
function LuaEntityProfiler:OnEntityUpdateStart(instanceId, entityId)
    if not self.startRecord then
        return
    end
    if not self.entityRecord[entityId] or not self.entityRecord[entityId].instances[instanceId] then
        self:OnEntityCreate(instanceId, entityId)
    end
    self.entityRecord[entityId].instances[instanceId].updateClock = os.clock()
end

function LuaEntityProfiler:OnEntityUpdateEnd(instanceId, entityId)
    if not self.startRecord then
        return
    end
    if not self.entityRecord[entityId] or not self.entityRecord[entityId].instances[instanceId] then
        return
    end

    if self.entityRecord[entityId].instances[instanceId].updateClock > 0 then
        self.entityRecord[entityId].instances[instanceId].time = self.entityRecord[entityId].instances[instanceId].time + os.clock() - self.entityRecord[entityId].instances[instanceId].updateClock
        self.entityRecord[entityId].instances[instanceId].updateClock = 0
    end
end

-------------------------------------------------------------------
local path = "Temp_LuaEntityProfiler\\"
function LuaEntityProfiler:PrintResult()
    --TODO 排序参数

    local tempTable = {}
    for k, record in pairs(self.entityRecord) do
        --entity总耗时
        record.totalTime = 0
        --entity总存在帧数
        record.totalFrame = 0
        --实体存在最长帧数
        record.maxLifeFrame = 0

        for _, v in pairs(record.instances) do
            record.totalTime = record.totalTime + v.time * 1000
            local lifeFrame = v.lifeFrame >= 0 and v.lifeFrame or self.curFrame - v.createFrame
            record.maxLifeFrame = lifeFrame > record.maxLifeFrame and lifeFrame or record.maxLifeFrame
            record.totalFrame = record.totalFrame + lifeFrame

        end
        --entity平均耗时
        record.averageTime = record.totalTime / record.totalFrame
        --entity耗时占总耗时的百分比
        record.percent = record.totalTime / (self.totalTime * 1000)
        table.insert(tempTable, record)
    end

    ---排序
        table.sort(tempTable, function(a, b)
            return a.percent > b.percent
        end)
    ---输出

    local date = os.date("*t")
    local fileName = date.year.. "-" .. date.month.. "-".. date.day.. "-".. date.hour.. "-".. date.min.. "-".. date.sec.. ".lua"
    local file, err = io.open(path .. fileName, "w")

    local columnWidths = {6, 15, 12, 14, 10, 16, 13, 11, 14} -- 每列的宽度
    local columnHeaders = {"index", "entityId", "maxCount", "totalCount", "percent", "averageTime", "totalTime", "totalFrame", "maxLifeFrame"}
    --local columnHeaderNotes = {"index", "entityId", "同屏最大数量", "统计周期总数量", "耗时占比", "平均耗时(ms)", "总耗时(ms)", "总帧数", "最长存在帧数"}

    -- 写入表头
    for i, header in ipairs(columnHeaders) do
        file:write(string.format("%-"..columnWidths[i].."s", header))
    end
    file:write("\n")
    -- 写入表头注释
    --for i, header in ipairs(columnHeaderNotes) do
    --    file:write(string.format("%-"..columnWidths[i].."s", header))
    --end
    file:write("index entityId       同屏最大数量 统计周期总数量  耗时占比  平均耗时(ms)     总耗时(ms)    总帧数    最长存在帧数".."\n")
    file:write("\n")

    -- 写入数据
    for index, record in pairs(tempTable) do
        local data = {
            index,
            record.entityId,
            record.maxCount,
            record.totalCount,
            string.format("%.4f%%", record.percent * 100),
            string.format("%.4f",record.averageTime),
            string.format("%.2f",record.totalTime),
            record.totalFrame,
            record.maxLifeFrame,
        }
        for i, column in ipairs(data) do
            file:write(string.format("%-"..columnWidths[i].."s", column))
        end
        file:write("\n")
    end

    --file:write("index   entityId      maxCount      totalCount      percent      averageTime      totalTime      totalFrame      maxLifeFrame".."\n")
    --file:write("index   entityId      同屏最大数量     统计周期总数量    耗时占比       平均耗时(ms)      总耗时(ms)       总帧数          最长存在帧数".."\n")
    --for index, record in pairs(tempTable) do
    --    local str = string.format("%-6s %-9s %-12s %-15s %-13s %-11s %-14s",
    --            )
    --    file:write(str .. "\n")
    --end

    file:close()
end

-----------------------------------------------------------------------------------------------------
--收集特定函数执行，监控函数每帧执行次数，计算总次数和平均数，总耗时和平均耗时
function LuaEntityProfiler:OnFunctionBegin(funcName)
    if not self.startRecord then
        return
    end

    if not self.functionRecord[funcName] then
        self.entityRecord[funcName] = {
            funcName = funcName,
            frameMaxCount = 0,
            curFrameMaxCount = 0,
            totalCount = 0,
            costTime = 0,
        }
    end

    self.functionRecord[funcName].updateClock = os.clock()
end

function LuaEntityProfiler:OnFunctionEnd(funcName)
    if not self.startRecord then
        return
    end
    if not self.functionRecord[funcName]  then
        return
    end

    if self.functionRecord[funcName].updateClock > 0 then
        self.functionRecord[funcName].costTime = self.functionRecord[funcName].costTime + os.clock() - self.functionRecord[funcName].updateClock
        self.functionRecord[funcName].updateClock.curFrameMaxCount = self.functionRecord[funcName].updateClock.curFrameMaxCount + 1
        self.functionRecord[funcName].updateClock.totalCount = self.functionRecord[funcName].updateClock.totalCount + 1
        self.functionRecord[funcName].updateClock = 0
    end
end

function LuaEntityProfiler:OnLogicFrameEnd()
    for k, v in pairs(self.functionRecord) do
        v.frameMaxCount = v.frameMaxCount > v.curFrameMaxCount and v.frameMaxCount or v.curFrameMaxCount
        v.curFrameMaxCount = 0
    end
end

function LuaEntityProfiler:PrintFuncResult()

    local tempTable = {}
    for k, record in pairs(self.functionRecord) do
        --平均耗时
        record.costTime = record.costTime * 1000
        record.averageTime = record.costTime / record.totalCount
        --entity耗时占总耗时的百分比
        record.percent = record.costTime / (self.totalTime * 1000)
        table.insert(tempTable, record)
    end

    ---排序
    table.sort(tempTable, function(a, b)
        return a.percent > b.percent
    end)
    ---输出

end