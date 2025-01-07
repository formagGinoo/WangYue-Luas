-- CombatTimer 战斗定时器
-- 作者：忠毅
-- 时间：2018年1月30日整理
-- 历史背景：tween在处理一些并行和串行回调的时候，会显得非常无力，另外一些老项目是cocos实现的，很难移植。
-- 利用这个战斗定时器，可以做非战斗的东西，只是仙侠这边主要是移植cocos的战斗逻辑
-- 支持任意串行并行定时器搭配组合，配合tween来实现复杂的动画效果。并且只有一个定时器在执行。
-- PS：仙侠这边的luatimer有用update重写。其他项目如果有必要也可以实现一个，替换LuaTimner.Add
-- ====================================================================
CombatTimer = BaseClass("CombatTimer")

-- 单例
function CombatTimer:__init()
    if CombatTimer.Instance then
        LogError("不可以对单例[CombatTimer]对象重复实例化")
        return
    end
    self.all_timer = {}
    self.auto_id = 0
    CombatTimer.Instance = self
end

-- 添加战斗定时器
-- obj              回调的参数，或者对象，在定时器结束后返回
-- delay_ms         延迟，单位毫秒
-- callback_func    回调函数，最终回调为callback_func(obj)
-- timer_name       定时器名字（可选）如果已经存在，那就不会再次启用
-- 返回
-- timer_name       没有定义则返回的是自增id
function CombatTimer:Add(obj, delay_ms, callback_func, timer_name)
    if timer_name and self.all_timer[timer_name] then
        return
    end
    local time_id = LuaTimer.Add(delay_ms, function() self:__callback__(obj, timer_name, callback_func) end)
    timer_name = timer_name or self:__auto_id__()
    self.all_timer[timer_name] = time_id
    return timer_name
end

-- 删除定时器
function CombatTimer:Delete(timer_name)
    if self.all_timer[timer_name] then
        LuaTimer.Delete(self.all_timer[timer_name])
        self.all_timer[timer_name] = nil
    end
end

-- 删除所有定时器
function CombatTimer:DeleteAllTimer()
    for _, id in pairs(self.all_timer) do
        LuaTimer.Delete(id)
        print("删除定时器", id)
    end
    self.all_timer = {}
end

------  组合型定时器  ------
-- 串行组合定时器
function CombatTimer.Sequence(...)
    local new_obj = {data = {}, type=CombatTimer.Type.SEQUENCE}
    local time_add = 0
    for _, v in ipairs({...}) do
        new_obj = CombatTimer.__combo__(new_obj, v, time_add)
        time_add = CombatTimer.__calc_time__(v) + time_add
    end
    return CombatTimer.__recalc_time__(new_obj)
end


-- 并行组合定时器
function CombatTimer.Spawn(...)
    local new_obj = {data={}, type=CombatTimer.Type.SEQUENCE}
    for _, v in ipairs({...}) do
        new_obj = CombatTimer.__combo__(new_obj, v, 0)
    end
    return CombatTimer.__recalc_time__(new_obj)
end

-- 简单的回调
function CombatTimer.CallFunc(callback_func, delay_ms)
    delay_ms = delay_ms or 0
    return {data={delay_ms, callback_func, delay_ms}, type=CombatTimer.Type.ONE}
end

-- 执行定时器组合
function CombatTimer.RunTimer(timer_obj)
    local lastobj = timer_obj.data[#timer_obj.data]
    timer_obj = CombatTimer.__recalc_time__(timer_obj)
    -- xzy(timer_obj)
    local auto_id = CombatTimer.Instance:__auto_id__()
    CombatTimer.Instance:__run_one_timer__(timer_obj, nil, auto_id)
    return auto_id, lastobj and lastobj.data and lastobj.data[3]
end

------  组合型定时器  ------



-- 自增id
function CombatTimer:__auto_id__()
    self.auto_id = self.auto_id + 1
    return self.auto_id
end

-- 合并定时器
function CombatTimer.__combo__(timer_obj, one, time_add)
    if one.type == CombatTimer.Type.ONE then
        one.data[3] = one.data[3] + time_add
        table.insert(timer_obj.data, one)
    elseif one.type == CombatTimer.Type.SEQUENCE then
        for _, v in ipairs(one.data) do
            timer_obj = CombatTimer.__combo__(timer_obj, v, time_add)
        end
    end
    return timer_obj
end

-- 重算定时器时间
function CombatTimer.__recalc_time__(timer_obj)
    if timer_obj.type == CombatTimer.Type.ONE then return timer_obj end
    table.sort(timer_obj.data, function(a, b)
        return a.data[3] < b.data[3]
    end)
    local time_cut = 0
    for _, v in ipairs(timer_obj.data) do
        v.data[1] = v.data[3] - time_cut
        time_cut = v.data[3]
    end
    return timer_obj
end

-- 内部回调函数
function CombatTimer:__callback__(obj, timer_name, callback_func)
    if type(callback_func) == "function" then
        callback_func(obj)
    end
end

-- 执行一个定时器
function CombatTimer:__run_one_timer__(timer_obj, args, time_id)
    if timer_obj then
        local obj_type = timer_obj.type
        if obj_type == CombatTimer.Type.ONE then
            self:__run_one__(timer_obj.data, args, time_id)
        elseif obj_type == CombatTimer.Type.SEQUENCE then
            self:__run_one_sequence__(timer_obj, time_id)
        else
            LogError(string.format("不存在ObjTimer定时器类型[%s]", obj_type))
        end
    end
end

-- 新增一个单元
function CombatTimer:__add__(obj, delay_ms, callback_func, timer_name)
    if timer_name and self.all_timer[timer_name] then
        -- print("定时器已经纯在")
        return
    end
    local timer_id = LuaTimer.Add(delay_ms, function() self:__callback_mix__(obj, timer_name, callback_func) end)
    timer_name = timer_name or self:__auto_id__()
    self.all_timer[timer_name] = timer_id
    return timer_name
end

-- 执行单个定时器
function CombatTimer:__run_one__(one, args, time_id)
    if one.type then
        self:__run_one_timer__(one, args, time_id)
    else
        -- print("单个定时器开始, 时间:", one[1])
        if one[1] == 0 then
            -- print("0定时器直接执行回调", time_id)
            self:__callback_mix__(args, time_id, one[2])
        else
            -- print(time_id, time_id)
            self:__add__(args, one[1], one[2], time_id)
        end
    end
end

-- 重算定时器在串行定时器里面的相对时间
function CombatTimer.__calc_time__(obj)
    if obj.type == CombatTimer.Type.ONE then
        return obj.data[1]
    elseif obj.type == CombatTimer.Type.SEQUENCE then
        local time = 0
        for _, v in ipairs(obj.data) do
            time = time + CombatTimer.__calc_time__(v)
        end
        return time
    end
end

-- 执行一个顺序组合定时器
function CombatTimer:__run_one_sequence__(timer_obj, time_id)
    local tmp = table.remove(timer_obj.data, 1)
    if #timer_obj.data == 0 then timer_obj = nil end    -- 没对象的时候清空
    if tmp then
        self:__run_one__(tmp, timer_obj, time_id)
    end
end

-- 组合型定时器回调
function CombatTimer:__callback_mix__(args, timer_name, callback_func)
    -- print("单个定时器结束", timer_name)
    callback_func()
    if self.all_timer[timer_name] then
        self.all_timer[timer_name] = nil
    else
        -- print("定时器已经被取消")
    end
    if args and args.type then
        self:__run_one_timer__(args, nil, timer_name)
    end
end

CombatTimer.Type = {
    SEQUENCE = 1,
    ONE = 2,
}

-- 测试函数
function test()
    CombatTimer.New()
    -- 定时回调
    local t = CombatTimer.CallFunc(function(args) print("1秒后回调", args) end, 1000)
    -- 并行定时器
    t = CombatTimer.Spawn(CombatTimer.CallFunc(function(args) print("3秒后回调", args) end, 3000), t)
    -- 串行定时器
    t = CombatTimer.Sequence(t, CombatTimer.CallFunc(function(args) print("2.5秒后回调", args) end, 2500))
    -- 并行定时器
    t = CombatTimer.Spawn(t, CombatTimer.CallFunc(function(args) print("1.1秒后回调", args) end, 1100))
    -- 串行定时器
    t = CombatTimer.Sequence(t, CombatTimer.CallFunc(function(args) print("3.1秒后回调", args) end, 3100))
    local id = CombatTimer.RunTimer(t)
    -- 删除已经存在的定时器
    -- -- local t2 = CombatTimer.CallFunc(301, function(args) print("删除定时器", args)
    --     CombatTimer.Instance:Delete(id)
    -- end)
    -- CombatTimer.RunTimer(t2)

    local move_start_fun = CombatTimer.CallFunc(function(args)
        print("开始移动，反转, 时间:", 3)
        -- fighter:reverse(-1)
    end, 3000)

    local move_end_fun = CombatTimer.CallFunc(function(args)
        print("结束回调，结束，反转恢复", args)
        -- fighter:MoveTo(target_pos)
    end, 2000)

    local id = CombatTimer.RunTimer(CombatTimer.Sequence(move_start_fun, move_end_fun))
end
-- 测试方式，调用test()函数即可
-- test()
