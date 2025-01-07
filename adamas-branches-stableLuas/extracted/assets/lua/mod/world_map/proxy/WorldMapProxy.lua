WorldMapProxy = BaseClass("WorldMapProxy", Proxy)

function WorldMapProxy:__InitProxy()
    self:BindMsg("map_to_transport_point")
    self:BindMsg("map_mark")
    self:BindMsg("map_mark_remove")
    self:BindMsg("map_system_jump")
    self:BindMsg("map_enter")
    self:BindMsg("map_info")
end

function WorldMapProxy:ServerPos2Client(position)
    return {x = position.pos_x * 0.0001, y = position.pos_y * 0.0001, z = position.pos_z * 0.0001}
end

function WorldMapProxy:Recv_map_info(data)
    local pos = self:ServerPos2Client(data.position)
    local rot = self:ServerPos2Client(data.rotate)
    mod.WorldMapCtrl:SetLoginMapAndPos(data.map_id, pos, rot)
end

function WorldMapProxy:Send_map_enter(mapId, x, y, z, rx, ry, rz)
    rx = rx or 0
    ry = ry or 0
    rz = rz or 0
    local position = { pos_x = math.floor(x * 10000), pos_y = math.floor(y * 10000), pos_z = math.floor(z * 10000)}
    local rotate = { pos_x = math.floor(rx * 10000), pos_y = math.floor(ry * 10000), pos_z = math.floor(rz * 10000)}
    return { map_id = mapId, position = position, rotate = rotate }
end

function WorldMapProxy:Recv_map_enter(data)
    local pos = self:ServerPos2Client(data.position)
    local rot = self:ServerPos2Client(data.rotate)
    local isInGame = mod.LoginCtrl:IsInGame()
    if isInGame then
        mod.WorldMapCtrl:EnterMap(data.map_id, pos, rot)
    else
        mod.WorldMapCtrl:SetLoginMapAndPos(data.map_id, pos, rot)
    end
end

function WorldMapProxy:Send_map_to_transport_point(entityEcoId, position, rotate)
    return { entity_born_id = entityEcoId, position = position, rotate = rotate }
end

function WorldMapProxy:Recv_map_to_transport_point(data)
    local position = self:ServerPos2Client(data.position)
    local rot = self:ServerPos2Client(data.rotate)
    mod.WorldMapCtrl:EnterMap(data.map_id, position, rot)
end

function WorldMapProxy:Send_map_mark(mark)
    return { map_mark = mark }
end

function WorldMapProxy:Recv_map_mark(data)
    mod.WorldMapCtrl:UpdateCustomMark(data.map_mark)
end

function WorldMapProxy:Send_map_mark_remove(markId)
    return { mark_id = markId }
end

function WorldMapProxy:Recv_map_mark_remove(data)
    mod.WorldMapCtrl:RemoveCustomMark(data.mark_id)
end

function WorldMapProxy:Send_map_system_jump(ids)
    return { show_list = ids }
end

function WorldMapProxy:Recv_map_system_jump(data)
    mod.WorldMapCtrl:UpdateMapMarkDefaultShow(data)
end

function WorldMapProxy:Send_condition_state(id)
    return { id = id }
end
