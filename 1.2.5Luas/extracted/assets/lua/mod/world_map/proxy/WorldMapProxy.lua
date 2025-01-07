WorldMapProxy = BaseClass("WorldMapProxy", Proxy)

function WorldMapProxy:__InitProxy()
    self:BindMsg("map_to_transport_point")
    self:BindMsg("map_mark")
    self:BindMsg("map_mark_remove")
    self:BindMsg("map_system_jump")
    self:BindMsg("map_enter")
    self:BindMsg("map_info")
    self:BindMsg("duplicate_enter")
    self:BindMsg("duplicate_quit")
    self:BindMsg("duplicate_finish")
    self:BindMsg("duplicate_state")
end

function WorldMapProxy:ServerPos2Client(position)
    return {x = position.pos_x * 0.0001, y = position.pos_y * 0.0001, z = position.pos_z * 0.0001}
end

function WorldMapProxy:Recv_map_info(data)
    local pos = self:ServerPos2Client(data.position)
    mod.WorldMapCtrl:SetLoginMapAndPos(data.map_id, pos)
end

function WorldMapProxy:Send_map_enter(mapId, x, y, z)
    local position = { pos_x = math.floor(x * 10000), pos_y = math.floor(y * 10000), pos_z = math.floor(z * 10000)}
    return { map_id = mapId, position = position }
end

function WorldMapProxy:Recv_map_enter(data)
    local pos = self:ServerPos2Client(data.position)
    local isInGame = mod.LoginCtrl:IsInGame()
    if isInGame then
        mod.WorldMapCtrl:EnterMap(data.map_id, pos)
    else
        mod.WorldMapCtrl:SetLoginMapAndPos(data.map_id, pos)
    end
end

function WorldMapProxy:Send_duplicate_enter(duplicateId)
    return {duplicate_id = duplicateId}
end

function WorldMapProxy:Recv_duplicate_enter(data)
    local duplicateId = data.duplicate_id
    local dupCfg = Config.DataDuplicate.data_duplicate[duplicateId]
    mod.WorldMapCtrl:SetDuplicateInfo(duplicateId, dupCfg.level_id)
    if dupCfg.is_switch_map then
		mod.WorldMapCtrl:EnterMap(dupCfg.map_id, Vector3.zero)
		return
	end

    EventMgr.Instance:Fire(EventName.CreateDuplicate, duplicateId)
end

function WorldMapProxy:Send_map_to_transport_point(entityEcoId, position)
    return { entity_born_id = entityEcoId, position = position }
end

function WorldMapProxy:Recv_map_to_transport_point(data)
    local position = { x = data.position.pos_x / 10000, y = data.position.pos_y / 10000, z = data.position.pos_z / 10000 }
    mod.WorldMapCtrl:EnterMap(data.map_id, position)
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

function WorldMapProxy:Send_duplicate_quit(duplicateId)
    return {duplicate_id = duplicateId}
end

function WorldMapProxy:Recv_duplicate_quit(data)
    mod.WorldMapCtrl:LeaveDuplicate()
end

function WorldMapProxy:Send_duplicate_finish(duplicateId)
    return {duplicate_id = duplicateId, kill_mon_list = {}}
end

function WorldMapProxy:Recv_duplicate_finish(data)

end

function WorldMapProxy:Send_condition_state(id)
    return { id = id }
end

function WorldMapProxy:Recv_duplicate_state(data)

end