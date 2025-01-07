NightMareDuplicateProxy = BaseClass("NightMareDuplicateProxy",Proxy)

function NightMareDuplicateProxy:__init()

end

function NightMareDuplicateProxy:__InitProxy()
    self:BindMsg("duplicate_nightmare_enter")
    self:BindMsg("duplicate_nightmare_finish")
    self:BindMsg("duplicate_nightmare_reset")
    self:BindMsg("duplicate_nightmare_get_score_award")
    self:BindMsg("duplicate_nightmare_layer_score_list")
    self:BindMsg("duplicate_nightmare_best_list")
    self:BindMsg("duplicate_nightmare_final_info")
    self:BindMsg("duplicate_nightmare_rank")
end

--梦魇副本进入
function NightMareDuplicateProxy:Send_duplicate_nightmare_enter(systemDuplicateId, useHeroIdList, useBuffList)
    --同步下角色的朝向给服务端
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local entityRotate = entity.transformComponent.rotation:ToEulerAngles()
    local struct_rorate = {
        pos_x = math.floor(entityRotate.x * 10000),
        pos_y = math.floor(entityRotate.y * 10000),
        pos_z = math.floor(entityRotate.z * 10000)
    }
    return {system_duplicate_id = systemDuplicateId, rotate = struct_rorate, use_hero_id_list = useHeroIdList, use_buff_list = useBuffList}
end

--梦魇副本完成
function NightMareDuplicateProxy:Send_duplicate_nightmare_finish(systemDuplicateId, killMonList, isWin, duplicateUseTime, hpPercent, useHeroIdList, useBuffList)
    return {system_duplicate_id = systemDuplicateId, kill_mon_list = {}, is_win = isWin, duplicate_use_time = duplicateUseTime,
            hp_percent = hpPercent, use_hero_id_list = useHeroIdList, use_buff_list = useBuffList}
end

function NightMareDuplicateProxy:Recv_duplicate_nightmare_finish(data)
    local result = mod.DuplicateCtrl:GetDupResult()
    if result == FightEnum.FightResult.Win then
        WindowManager.Instance:OpenWindow(NightMareSuccessWindow, {systemDuplicateId = data.system_duplicate_id})
    else
        WindowManager.Instance:OpenWindow(NightMareFailWindow, {systemDuplicateId = data.system_duplicate_id})
    end
end

--梦魇副本回溯
function NightMareDuplicateProxy:Send_duplicate_nightmare_reset(keyType, systemDuplicateId)
    return {key_type = keyType, system_duplicate_id = systemDuplicateId}
end

function NightMareDuplicateProxy:Recv_duplicate_nightmare_reset(data)
    
end

--梦魇副本领取积分奖励
function NightMareDuplicateProxy:Send_duplicate_nightmare_get_score_award(layScoreList)
    return {lay_score_list = layScoreList}
end

function NightMareDuplicateProxy:Recv_duplicate_nightmare_get_score_award(data)

end

--梦魇层级对应最高积分返回
function NightMareDuplicateProxy:Recv_duplicate_nightmare_layer_score_list(data)
    mod.NightMareDuplicateCtrl:SetNightMareLayerScoreList(data)
end

--梦魇副本历史最佳记录返回
function NightMareDuplicateProxy:Recv_duplicate_nightmare_best_list(data)
    mod.NightMareDuplicateCtrl:SetNightMareBestList(data)
end

--梦魇副本终战记录返回
function NightMareDuplicateProxy:Recv_duplicate_nightmare_final_info(data)
    mod.NightMareDuplicateCtrl:SetNightMareFinalInfo(data)
end

--梦魇副本排行榜
function NightMareDuplicateProxy:Send_duplicate_nightmare_rank(rankType)
    return {rank_type = rankType}
end

--梦魇副本排行榜返回
function NightMareDuplicateProxy:Recv_duplicate_nightmare_rank(data)
    mod.NightMareDuplicateCtrl:SetNightMareRankInfo(data)
    EventMgr.Instance:Fire(EventName.NightMareFreshRank)
end

