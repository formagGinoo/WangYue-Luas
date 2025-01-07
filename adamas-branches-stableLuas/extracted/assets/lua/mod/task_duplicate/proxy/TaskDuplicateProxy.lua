TaskDuplicateProxy = BaseClass("TaskDuplicateProxy",Proxy)

function TaskDuplicateProxy:__init()

end

--**这里目前关卡副本也走这俩条协议
function TaskDuplicateProxy:__InitProxy()
    self:BindMsg("duplicate_task_enter")
    self:BindMsg("duplicate_task_finish")
end

--进入任务副本和关卡副本
function TaskDuplicateProxy:Send_duplicate_task_enter(systemDuplicateId, use_hero_id_list)
    --同步下角色的朝向给服务端
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local entityRotate = entity.transformComponent.rotation:ToEulerAngles()
    local struct_rorate = {
        pos_x = math.floor(entityRotate.x * 10000),
        pos_y = math.floor(entityRotate.y * 10000),
        pos_z = math.floor(entityRotate.z * 10000)
    }
    return {system_duplicate_id = systemDuplicateId, rotate = struct_rorate, use_hero_id_list = use_hero_id_list or {}}
end

--任务副本和关卡副本 完成
function TaskDuplicateProxy:Send_duplicate_task_finish(systemDuplicateId, isWin)
    return {system_duplicate_id = systemDuplicateId, kill_mon_list = {}, is_win = isWin}
end

function TaskDuplicateProxy:Recv_duplicate_task_finish(data)
    if Fight.Instance then
        Fight.Instance.duplicateManager:RecvFinishedDuplicate(data)
    end
end





