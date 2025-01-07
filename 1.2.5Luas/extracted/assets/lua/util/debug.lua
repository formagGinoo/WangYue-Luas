-- debug 调试类 -- 
--  作者：忠毅  --
-- 时间16-11-30 --

-- 拷贝table 不能直接用=来复制，否则会一起改变
function DeepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- 类调试 尽量不要用在一些定时回调类里面
-- debug_fun是自己的打印数组函数，没有就默认用print，但是可能参数会看不到
-- 例子：    
-- NoticeManager.New()
-- DebugClass("NoticeManager", xzy)
-- 这样就可以监听 NoticeManager 的回调情况
-- 
__debug_class__ = __debug_class__ or {}
function DebugClass(ClassName, debug_fun) 
    if not _G[ClassName] then return print(string.format("Class [%s] is not exist!", ClassName)) end
    if __debug_class__[ClassName] then return print(string.format("Class [%s] is in debug!", ClassName)) end 
    __debug_class__[ClassName] = __debug_class__[ClassName] or {}
    local ptm 
    local tmp = {}
    if _G[ClassName] and _G[ClassName]["Instance"] then 
        ptm = DeepCopy(_G[ClassName]["Instance"])
        _G[ClassName]["Instance"] = tmp
    else
        ptm = DeepCopy(_G[ClassName])
        _G[ClassName] = tmp
    end
    setmetatable(tmp, {__index = function(_table, index, value)
        local fun = ptm[index]
        if type(fun) == "function" then
            __debug_class__[ClassName][index] = (__debug_class__[ClassName][index] or 0) + 1
            if type(debug_fun) == "function" then
                return function(...) debug_fun(string.format("<color='#00ff00'>[类调用 %s:%s %s]</color> args:", ClassName, index, __debug_class__[ClassName][index]), ...) return fun(...) end 
            else
                return function(...) print(string.format("<color='#00ff00'>[类调用 %s:%s %s]</color> args:", ClassName, index, __debug_class__[ClassName][index], index), ...) return fun(...) end 
            end
        else
            return fun
        end
    end})
end