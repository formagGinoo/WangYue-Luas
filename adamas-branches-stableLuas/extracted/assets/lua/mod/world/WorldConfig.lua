local DataTransport = Config.DataMap.data_map_transport

WorldConfig = WorldConfig or {}

function WorldConfig.IsTransport(id)
    if DataTransport[id] then
        if DataTransport[id].type == 1 or DataTransport[id].type == 2 then
            return true
        end
    end
end