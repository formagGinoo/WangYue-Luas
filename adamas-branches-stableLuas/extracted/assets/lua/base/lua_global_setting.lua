local parentG = {}
--if not ctx.Editor then
    -- 数据表跟其它的不一样
    Config = Config or {}
    local dataG = {}
    local __Dataoaded = {}
    setmetatable(Config, dataG)
    dataG.__index = function(t, k)
        local requireName = ClzMapping[k]
		local loaded = __Dataoaded[requireName]
        if requireName and not loaded then
            __Dataoaded[requireName] = true
            if require (ClzMapping[k]) then
                return Config[k]
            else
                return false
            end
        end
    end
    
    local __ModuleLoaded = {}
    setmetatable(_G, parentG)
    parentG.__index = function(t, k)
        local requireName = ClzMapping[k]
		local loaded = __ModuleLoaded[requireName]
        if requireName and not loaded then
            __ModuleLoaded[requireName] = true
            if require (ClzMapping[k]) then
                return _G[k]
            else
                return false
            end
        else
            --return GetCSharp(k)
        end
    end
--end

if ctx.IsDebug then
    -- local __g = _G
    -- local msg = "VARIABLE : '%s' SET TO GLOBAL VARIABLE \n%s"
    -- parentG.__newindex = function(_, name, value)
    --     rawset(__g, name, value)
    --     if ClzMapping[name] ~= nil then
    --         return
    --     end
    --     local trace = debug.traceback()
    --     if name ~= "connection_recv_data" and string.sub(name, 1, 3) ~= "___" then
    --         LogError(string.format(msg, name, trace), 0)
    --     end
    -- end
end
