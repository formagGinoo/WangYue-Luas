WorldProxy = BaseClass("WorldProxy",Proxy)

function WorldProxy:__init()

end

function WorldProxy:__InitProxy()
	self:BindMsg("ecosystem_state")
    self:BindMsg("ecosystem_hit")
    self:BindMsg("ecosystem_update")
    self:BindMsg("ecosystem_transport_point")
    self:BindMsg("map_sync_position")
    self:BindMsg("condition_state")
    self:BindMsg("ecosystem_entity_state")
    self:BindMsg("ecosystem_monster_level_bias")
end

function WorldProxy:__InitComplete()

end

function WorldProxy:Send_ecosystem_state(mapId)
    return {map_id = mapId}
end

function WorldProxy:Recv_ecosystem_state(data)
    -- LogTable("eco_list", data)
    Fight.Instance.entityManager.ecosystemEntityManager:InitEntityBornData(data)
    Fight.Instance.entityManager.ecosystemCtrlManager:OnRecvEcosystemState()
    mod.WorldMapTipCtrl:UpdateEcoBornState(data)
end

function WorldProxy:Recv_ecosystem_update(data)
    Fight.Instance.entityManager.ecosystemEntityManager:AddEntityBornData(data)
    mod.WorldMapTipCtrl:UpdateEcoBornState(data)
end

function WorldProxy:Send_ecosystem_hit(sInstanceId, sendPos)
    -- EventMgr.Instance:Fire(EventName.PauseTipQueue)
	return {id = sInstanceId, position = sendPos}
end

function WorldProxy:Recv_ecosystem_hit(data)
    EventMgr.Instance:Fire(EventName.EntityHitEnd, data)
    -- EventMgr.Instance:Fire(EventName.ResumeTipQueue)
end

function WorldProxy:Recv_ecosystem_transport_point(data)
    mod.WorldCtrl:SetTransportPoints(data)
    mod.WorldMapTipCtrl:UpdateEcoTransportPoints(data)
end

function WorldProxy:Send_map_sync_position(data)
    return { map_id = data.mapId, position = data.position, rotate = data.rotate }
end

function WorldProxy:ServerPos2Client(position)
    return {x = position.pos_x * 0.0001, y = position.pos_y * 0.0001, z = position.pos_z * 0.0001}
end

function WorldProxy:Send_condition_state(_id)
    return { id = _id }
end

function WorldProxy:Recv_condition_state(data)
    if not Fight.Instance then
        return
    end

    Fight.Instance.conditionManager:OnRecv_ConditionState(data)
end

function WorldProxy:Send_ecosystem_entity_state(mapId, stateList)
    -- LogTable("stateList - mapId = "..mapId, stateList)
    return { map_id = mapId, entity_state_list = stateList }
end

function WorldProxy:Recv_ecosystem_entity_state(data)
    -- LogTable("recv_ecosystem_entity_state", data)
    mod.WorldMapTipCtrl:UpdateEcoEntityInfo(data)
    if not Fight.Instance then
        return
    end

    Fight.Instance.entityManager.ecosystemEntityManager:UpdateSysEntityState(data)
end

function WorldProxy:Send_ecosystem_monster_level_bias(ecoId)
    return {id_list = {ecoId}}
end

function WorldProxy:Recv_ecosystem_monster_level_bias(data)
    if not Fight.Instance then
        return
    end

    Fight.Instance.entityManager.ecosystemEntityManager:UpdateEcoMonsterLevelBias(data)
end