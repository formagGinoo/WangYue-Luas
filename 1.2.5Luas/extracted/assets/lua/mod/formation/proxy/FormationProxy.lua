---@class FormationProxy : Proxy
FormationProxy = BaseClass("FormationProxy",Proxy)

function FormationProxy:__init()

end

function FormationProxy:__InitProxy()
    self:BindMsg("formation_list")
    self:BindMsg("formation_update")
    self:BindMsg("formation_name")
    self:BindMsg("formation_use")
end

function FormationProxy:__InitComplete()

end

function FormationProxy:Send_formation_list()

end

function FormationProxy:Recv_formation_list(data)
    mod.FormationCtrl:UpdateAllFormation(data)
end

function FormationProxy:Send_formation_update(data)
    return { id = data.id, hero_id_list = data.hero_id_list }
end

function FormationProxy:Recv_formation_update(data)
    mod.FormationCtrl:UpdateFormation(data.id, data.hero_id_list)
end

function FormationProxy:Send_formation_name(id, name)
    return { id = id, name = name }
end

function FormationProxy:Recv_formation_name(data)
    mod.FormationCtrl:UpdateFormationName(data.id, data.name)
end

function FormationProxy:Send_formation_use(id)
    return { id = id }
end

function FormationProxy:Recv_formation_use(data)
    --mod.FormationCtrl:UpdateCurFormation(data.id)
end