--[[
-- 这个值如果大少要预加载的数量，即没有进度条
_LuaPreloadSpan = 200
_LuaPreload = _LuaPreload or {}

-- 数据表这里添加
-- table.insert(_LuaPreload, "data/data_item")

-- 其它需要预加载的文件
if ClzMapping ~= nil then
    for key, path in pairs(ClzMapping) do
        if string.find(key, "Manager") then
            table.insert(_LuaPreload, path)
        end
    end
end

-- 最最后
table.insert(_LuaPreload, "base/lua_global_setting")
--]]