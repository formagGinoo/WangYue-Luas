DuplicateProxy = BaseClass("DuplicateProxy",Proxy)

function DuplicateProxy:__init()

end

--注意 ：**这里只负责副本通用的协议（每个副本发送自己本身的进入和退出协议，回通用的进入和退出回包）
function DuplicateProxy:__InitProxy()
    --通用副本协议
    self:BindMsg("duplicate_enter_base")
    self:BindMsg("duplicate_quit_base")
    self:BindMsg("duplicate_reset_base")
    self:BindMsg("duplicate_again_base")
    --新增结算协议
    
    self:BindMsg("duplicate_progress_base")
    self:BindMsg("duplicate_relive_pos_base")
    self:BindMsg("duplicate_state_list")
end

--进入副本 system_duplicate_id不能为空
function DuplicateProxy:Recv_duplicate_enter_base(data)
    local duplicateId = Config.DataSystemDuplicateMain.Find[data.system_duplicate_id].duplicate_id
    local dupCfg = Config.DataDuplicate.data_duplicate[duplicateId]
    mod.WorldMapCtrl:SetDuplicateInfo(duplicateId, dupCfg.level_id)
    --更新数据到DuplicateCtrl
    mod.DuplicateCtrl:EnterDuplicateData(data)
    if dupCfg.is_switch_map then
        -- local bornPos = BehaviorFunctions.GetTerrainPositionP(dupCfg.position, dupCfg.level_id)
        local bornPos = mod.WorldMapCtrl:GetMapPositionConfig(dupCfg.level_id, dupCfg.position)
        local pos = Vec3.New()
        local rot = Quat.New(0, 0, 0, 0)
        if bornPos then
            pos.x = bornPos.x or 0
            pos.y = bornPos.y or 0
            pos.z = bornPos.z or 0
            rot.x = bornPos.rotX or 0
            rot.y = bornPos.rotY or 0
            rot.z = bornPos.rotZ or 0
            rot.w = bornPos.rotW or 0
        end

        local isInGame = mod.LoginCtrl:IsInGame()
        if isInGame then
            mod.WorldMapCtrl:EnterMap(dupCfg.map_id, pos, rot:ToEulerAngles())
        else
            mod.WorldMapCtrl:SetLoginMapAndPos(dupCfg.map_id, pos, rot:ToEulerAngles())
        end
        -- mod.WorldMapCtrl:EnterMap(dupCfg.map_id, pos, rot:ToEulerAngles())
    else
        --非切地图场景
        if Fight.Instance then
            local duplicateId_, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
            if dupLevelId then
                Fight.Instance.levelManager:CreateLevel(dupLevelId)
            end
            Fight.Instance.duplicateManager:StartFight()
        end
    end

    -- 预留接口，设置fightevent（自选fightevent）
    -- if data.fight_event then
    --     mod.DuplicateCtrl:SetFightEvent(data.fight_event)
    -- end

    EventMgr.Instance:Fire(EventName.EnterDuplicate)
end

--退出副本
function DuplicateProxy:Send_duplicate_quit_base()
    return {}
end


function DuplicateProxy:Recv_duplicate_quit_base(data)
    EventMgr.Instance:Fire(EventName.QuitDuplicate)
    --重置编队类型
    mod.FormationCtrl:ResetTeamType()
    --重置编队状态
    mod.FormationCtrl:ResetFormation()
    --清空数据
    mod.DuplicateCtrl:ResetDuplicateData(data)
    mod.WorldMapCtrl:LeaveDuplicate(data)  --离开副本地图
end

--重置副本
function DuplicateProxy:Send_duplicate_reset_base()
	return {}
end

--function DuplicateProxy:Recv_duplicate_reset()
--    
--end

--再次挑战
function DuplicateProxy:Send_duplicate_again_base()
	return {}
end

function DuplicateProxy:Recv_duplicate_again_base(data)
    --清空数据
    mod.DuplicateCtrl:ClearProgressList()
    mod.DuplicateCtrl:ClearDuplicatePos()
    mod.DuplicateCtrl.fightResult = FightEnum.FightResult.None
    if Fight.Instance then
        Fight.Instance.duplicateManager:RecvAgainDuplicateLevel()
    end
    EventMgr.Instance:Fire(EventName.ResetDuplicate)
end

--副本进度
function DuplicateProxy:Send_duplicate_progress_base(data)
    return {progress_list = data.progress_list}
end

--function DuplicateProxy:Recv_duplicate_progress()
--    
--end

--复活点
function DuplicateProxy:Send_duplicate_relive_pos_base(data)
    return {pos = data.pos, rotate = data.rotate}
end

--function DuplicateProxy:Recv_duplicate_relive_pos()
--    
--end

--所有副本的信息(全量/增量)
function DuplicateProxy:Recv_duplicate_state_list(data)
    mod.DuplicateCtrl:UpdateDuplicateStateList(data)
end



