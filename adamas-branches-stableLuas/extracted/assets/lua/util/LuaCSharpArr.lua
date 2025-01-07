local apiInit = nil
local apiCreateAccess = nil


apiCreateAccess = CS.LuaArrAccessAPI.CreateLuaShareAccess

LuaCSharpArr = 
{
    class = "LuaCSharpArr",
}
local fields = {}
local pin_func = lua_safe_pin_bind
setmetatable(LuaCSharpArr, LuaCSharpArr)
LuaCSharpArr.__index = function(t,k)
    local var = rawget(LuaCSharpArr, k)
    return var
end

function LuaCSharpArr.New(len)
    len = len or 10

    local v = {}
    for i = 1, len do
        v[i] = i
    end

    setmetatable(v, LuaCSharpArr)
    return v
end

local oldGCFunc = nil
local function newGCFunc(self)
    self:OnGC()
    oldGCFunc(self)
end

local function SetCSharpAccessGCFunc(pin)
    local mt = getmetatable(pin)
    if oldGCFunc == nil then
        oldGCFunc = mt.__gc
    end
    
    mt.__gc = newGCFunc
end

function LuaCSharpArr:GetCSharpAccess()
    if self.__pin == nil then
        self.__pin = apiCreateAccess()
        pin_func(self, self.__pin)
        SetCSharpAccessGCFunc(self.__pin)
    end

    -- body
    return self.__pin
end

function LuaCSharpArr:DestroyCSharpAccess()
    if self.__pin ~= nil then
        self.__pin:OnGC()
        self.__pin = nil
    end
end

function LuaCSharpArr:AutoDetectArch()
 
end


-- return LuaCSharpArr