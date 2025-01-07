ResDuplicateProxy = BaseClass("ResDuplicateProxy",Proxy)

function ResDuplicateProxy:__init()

end

function ResDuplicateProxy:__InitProxy()
    self:BindMsg("duplicate_resource_enter")
    self:BindMsg("duplicate_resource_finish")
    
end

function ResDuplicateProxy:Send_duplicate_resource_enter(id, useHeroIdList)
    --同步下角色的朝向给服务端
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local entityRotate = entity.transformComponent.rotation:ToEulerAngles()
    local struct_rorate = {
        pos_x = math.floor(entityRotate.x * 10000),
        pos_y = math.floor(entityRotate.y * 10000),
        pos_z = math.floor(entityRotate.z * 10000)
    }
    return {system_duplicate_id = id, rotate = struct_rorate, use_hero_id_list = useHeroIdList or {}}
end

function ResDuplicateProxy:Send_duplicate_resource_finish(dupId, killMonList, isWin)
    return {system_duplicate_id = dupId, kill_mon_list = killMonList, is_win = isWin}
end

function ResDuplicateProxy:Recv_duplicate_resource_finish(data)
    --mod.ResDuplicateCtrl:RecvResDuplicateFinish(data)
    if Fight.Instance then
        Fight.Instance.duplicateManager:RecvFinishedDuplicate(data)
    end
end


