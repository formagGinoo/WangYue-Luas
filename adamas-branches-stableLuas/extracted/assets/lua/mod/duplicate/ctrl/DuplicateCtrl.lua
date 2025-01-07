DuplicateCtrl = BaseClass("DuplicateCtrl",Controller)

local _tinsert = table.insert

--** 关于id的情况 系统副本id和关联的副本id肯定是存在的，然后通过类型去判断属于哪种副本
function DuplicateCtrl:__init()
    self.systemDuplicateId = nil --系统副本id
    self.duplicateId = nil --副本id
    self.fightEventIdList = {} -- 战斗事件列表
    self.duplicateStateList = {}--副本通用信息表
    self.progressList = {} --副本进度
    self.duplicatePos = nil --复活点
    -- self.duplicateRemainTime = nil --副本剩余时间
    self.systemDuplicateCfg = nil --系统副本配置
    self.fightResult = FightEnum.FightResult.None --副本内的结果
end

--进入副本同步
function DuplicateCtrl:EnterDuplicateData(data)
    self.systemDuplicateId = data.system_duplicate_id

    --读取系统副本表，判断是哪个类型，判断是哪个副本
    self.systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)
    self.duplicateId = self.systemDuplicateCfg.duplicate_id

    self:UpdateDataByDupType(data)
end

function DuplicateCtrl:UpdateDataByDupType(data)
    if self.systemDuplicateCfg.type == FightEnum.SystemDuplicateType.Res then
        mod.ResDuplicateCtrl:RecvEnterResDuplicate(data)
        self.fightEventIdList = DuplicateConfig.GetResFightEventList(self.systemDuplicateId)
    elseif self.systemDuplicateCfg.type == FightEnum.SystemDuplicateType.Task then
        self.fightEventIdList = DuplicateConfig.GetTaskFightEventList(self.systemDuplicateId)
    elseif self.systemDuplicateCfg.type == FightEnum.SystemDuplicateType.NightMare then
        mod.NightMareDuplicateCtrl:UpdateNightMareDuplicateData(data)
    end
    --设置一下编队类型
    mod.FormationCtrl:SetTeamType(self.systemDuplicateCfg.team_type)
    --根据副本类型去判断是大世界编队还是副本编队 
    if DuplicateConfig.dupFormation[self.systemDuplicateCfg.team_type] then
        mod.FormationCtrl:SetDupFormation(data.use_hero_id_list)
    end
    self:SetDuplicateProgress(data.progress_list)
    self:SetDuplicatePosBySever(data.pos, data.rotate)
    -- self:InitDuplicateRemainTime()

    -- 如果有系统副本ID就开始计时
    if self.systemDuplicateId and self.systemDuplicateId ~= 0 and Fight.Instance then
        Fight.Instance.duplicateManager:AddTimerByDuplicateID(self.systemDuplicateId)
    end
end

--退出副本同步
function DuplicateCtrl:ResetDuplicateData(data)
    self.duplicateId = nil
    self.systemDuplicateId = nil
    self.fightEventIdList = {} -- 战斗事件列表
    self.progressList = {} --副本进度
    self.duplicatePos = nil --复活点
    -- self.duplicateRemainTime = nil --副本剩余时间
    self.systemDuplicateCfg = nil
    self.fightResult = FightEnum.FightResult.None
    --资源副本，清空资源副本信息
    mod.ResDuplicateCtrl:RecvQuitResDuplicate(data)
    --梦魇副本，清空数据
    mod.NightMareDuplicateCtrl:ClearNightMareDuplicateData(data)
    self:SetPlayerRotate(data) --设置人物旋转
end

--通用副本信息汇总
function DuplicateCtrl:UpdateDuplicateStateList(data)
    for i, v in pairs(data.duplicate_list) do
        local id = v.system_duplicate_id
        if not self.duplicateStateList[id] then
            self.duplicateStateList[id] = {}
        end
        self.duplicateStateList[id] = v
    end
end

--获取副本的信息
function DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId)
    return self.duplicateStateList[systemDuplicateId]
end

--副本结果(做保底用)
function DuplicateCtrl:SetDupResult(result)
    self.fightResult = result and FightEnum.FightResult.Win or FightEnum.FightResult.Lose
end

function DuplicateCtrl:GetDupResult()
    return self.fightResult
end

--副本进度同步
function DuplicateCtrl:SetDuplicateProgress(data)
    for i, v in pairs(data) do
        self:SetDuplicateProgressBykey(v.key, v.value)
    end
end

--除了可以同步进度还可以同步血量信息等
function DuplicateCtrl:SetDuplicateProgressBykey(key, value)
    self.progressList[key] = value
end

--获取副本进度
function DuplicateCtrl:GetDuplicateProgress()
    return self.progressList
end

--获取副本进度(ipairs形式)
function DuplicateCtrl:GetDuplicateProgressByIpairs()
    local data = {}
    for key, value in pairs(self.progressList) do
        table.insert(data, {key = key, value = value})
    end
    return data
end

 --设置当前副本战斗事件列表
 function DuplicateCtrl:SetFightEvent(fightEvent)
     self.fightEventIdList = fightEvent
 end

-- 获取当前副本战斗事件列表
function DuplicateCtrl:GetFightEventIdList()
    return self.fightEventIdList
end

--清空目前副本的进度
function DuplicateCtrl:ClearProgressList()
    self.progressList = {}
end

--清空目前副本的复活点
function DuplicateCtrl:ClearDuplicatePos()
    self.duplicatePos = { x = 0, y = 0, z = 0 }
end

--副本复活点
function DuplicateCtrl:SetDuplicatePos(data)
    self.duplicatePos = data
end

--副本复活点
function DuplicateCtrl:SetDuplicatePosBySever(severPos, severRotate)
    local pos = {}
    if severPos then
         pos.x = severPos.pos_x * 0.0001
         pos.y = severPos.pos_y * 0.0001
         pos.z = severPos.pos_z * 0.0001
    end
    if severRotate then
        local rotation = Quat.Euler(severRotate.pos_x * 0.0001, severRotate.pos_y * 0.0001, severRotate.pos_z * 0.0001)
        pos.rotX = rotation.x
        pos.rotY = rotation.y
        pos.rotZ = rotation.z
        pos.rotW = rotation.w
    end
    self.duplicatePos = pos
end

function DuplicateCtrl:GetDuplicatePos()
    return self.duplicatePos
end

function DuplicateCtrl:GetDefultDuplicatePos()
    local duplicateId, levelId = mod.WorldMapCtrl:GetDuplicateInfo()
    local duplicateConfig = DuplicateConfig.GetDuplicateConfigById(duplicateId)
    if next(duplicateConfig.revive_pos) then
        --默认复活点
        return mod.WorldMapCtrl:GetMapPositionConfig(levelId, duplicateConfig.revive_pos[2], duplicateConfig.revive_pos[1])
    else
        local pos = {}
        if Fight.Instance then
            pos = Fight.Instance.duplicateManager:GetCtrlEntityPos()
        end
        --原地复活
        return pos
    end
end

--获取当前的副本id
function DuplicateCtrl:GetDuplicateId()
    return self.duplicateId
end

--获取当前的系统副本id
function DuplicateCtrl:GetSystemDuplicateId()
    return self.systemDuplicateId
end

--副本剩余时间初始化
-- function DuplicateCtrl:InitDuplicateRemainTime()
--     if not self.systemDuplicateCfg then
--         return
--     end
--     --等于0 也不设置
--     if self.systemDuplicateCfg.time == 0 then
--         return
--     end

--     self.duplicateRemainTime = self.systemDuplicateCfg.time
-- end

--设置副本剩余时间
-- function DuplicateCtrl:SetDuplicateRemainTime(remainTime)
--     self.duplicateRemainTime = remainTime
-- end

--获取副本剩余时间
-- function DuplicateCtrl:GetDuplicateRemainTime()
--     return self.duplicateRemainTime
-- end

function DuplicateCtrl:SetPlayerRotate(data)
    local rot = data.rotate
	if rot then 
        --判断是否是切地图
        local rotation = Quat.Euler(rot.pos_x * 0.0001, rot.pos_y * 0.0001, rot.pos_z * 0.0001)
        mod.WorldMapCtrl:CacheTpRotation(rotation.x, rotation.y, rotation.z ,rotation.w)
	end
end

-- function DuplicateCtrl:IsCanGetDuplicateTime()
--     if (not self.systemDuplicateCfg) or (self.systemDuplicateCfg.time == 0) then
--         LogError("无法获取该副本倒计时")
--         return false 
--     end
    
--    return true 
-- end

--检测是否在副本内，并且是某种副本类型
function DuplicateCtrl:CheckIsDupAndType(type)
    local isDup = self.systemDuplicateId ~= nil
    if type then
        return isDup and self.systemDuplicateCfg.type == type
    end
    return isDup
end

-- 检查当前体力能否进入副本
function DuplicateCtrl:IsCanEnterDupByCost(systemDuplicateId, cost)
    local systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    if not systemDuplicateCfg then return end 
    
    local costVit = cost and cost or systemDuplicateCfg.cost
    local currVit = mod.BagCtrl:GetItemCountById(ItemConfig.StrengthId)

    if currVit < costVit then
        MsgBoxManager.Instance:ShowTips(TI18N("体力不足"))
        PanelManager.Instance:OpenPanel(StrengthExchangePanel)
        return false
    end

    return true
end

--获取副本等级、怪物等级、指定怪物等级信息
function DuplicateCtrl:GetMonsterLevelByDup(masterId, npcTag)
    if not self.systemDuplicateId then
        return
    end
    local monsterCfg = Config.DataMonster.Find[masterId]
    if not monsterCfg then
        return
    end
    
    local level --怪物最终等级 
    local tag  --怪物类型
    local systemDupCfg = self.systemDuplicateCfg
    --判断该怪物在怪物表的类型，如果类型未配置，则取实体身上的npcTag
    if monsterCfg.type_id ~= 0 then
        tag = monsterCfg.type_id
    else
        tag = npcTag
    end
    --副本等级 
    if systemDupCfg.duplicate_level ~= 0 then
        level = systemDupCfg.duplicate_level
    end
    --怪物等级 
    if tag == FightEnum.MonsterTypeId.Monster and systemDupCfg.monster_level ~= 0 then
        level = systemDupCfg.monster_level --小怪等级
    elseif tag == FightEnum.MonsterTypeId.Elite and systemDupCfg.elite_level ~= 0 then
        level = systemDupCfg.elite_level --精英等级
    elseif tag == FightEnum.MonsterTypeId.Boss and systemDupCfg.boss_level ~= 0 then
        level = systemDupCfg.boss_level --boss等级
    end
    --指定怪物等级tb
    for i, v in pairs(systemDupCfg.order_monster_level) do
        local monster_Id = v[1]
        if monster_Id == masterId then
            level = v[2]
        end
    end

    return level
end

-- 检查当前副本是否有人员限制
function DuplicateCtrl:IsCanEnterDupByTeamRequestId(systemDuplicateId)
    local systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    if not systemDuplicateCfg then return end

    if systemDuplicateCfg.team_request_id then
        for i, v in ipairs(systemDuplicateCfg.team_request_id) do
            if v ~= 0 then --不为空，表示有队伍限制
                return true 
            end
        end
    end

    return false
end

---------------------------------协议交互部分
--进入
function DuplicateCtrl:EnterDuplicateMessage(systemDuplicateId, params)
    local systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    local type = systemDuplicateCfg.type
    
    if type == FightEnum.SystemDuplicateType.Res then --资源副本 
        mod.ResDuplicateFacade:SendMsg("duplicate_resource_enter", systemDuplicateId, params.useHeroIdList)
    elseif type == FightEnum.SystemDuplicateType.NightMare then	-- 梦魇类型
        mod.NightMareDuplicateFacade:SendMsg("duplicate_nightmare_enter", systemDuplicateId, params.useHeroIdList, params.useBuffList)
    elseif type == FightEnum.SystemDuplicateType.CitySimulation then --城市经营
        mod.CitySimulationFacade:SendMsg("city_operate_entrust_enter", params.shopID, params.currSelectEntrustmentId, params.useHeroIdList)
    else --任务副本和非系统副本
        mod.TaskDuplicateFacade:SendMsg("duplicate_task_enter", systemDuplicateId, params.useHeroIdList)
    end
end

--退出副本
function DuplicateCtrl:QuitDuplicate()
    --如果不在副本内则退出副本
    if not self.duplicateId then
        return
    end
    --如果是梦魇副本，退出后，需要打开梦魇主界面todo
    mod.DuplicateFacade:SendMsg("duplicate_quit_base")
end

--再次挑战副本
function DuplicateCtrl:AgainDuplicate()
    --如果不在副本内则不响应
    if not self.duplicateId then
        return
    end
    mod.DuplicateFacade:SendMsg("duplicate_again_base")
end

--完成
function DuplicateCtrl:SendDuplicateFinishedMessage(result)
    local systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)
    if not systemDuplicateCfg then return end 
    local type = systemDuplicateCfg.type
    
    if type == FightEnum.SystemDuplicateType.Res then --资源副本
        mod.ResDuplicateFacade:SendMsg("duplicate_resource_finish", self.systemDuplicateId, {}, true)
    elseif type == FightEnum.SystemDuplicateType.NightMare then	-- 梦魇类型
        mod.NightMareDuplicateCtrl:FinishNightMareDup(self.systemDuplicateId, nil, result)
    elseif type == FightEnum.SystemDuplicateType.CitySimulation then --城市经营
        mod.CitySimulationFacade:SendMsg("city_operate_entrust_finish", self.systemDuplicateId, result)
    else --任务副本和非系统副本
        mod.TaskDuplicateFacade:SendMsg("duplicate_task_finish", self.systemDuplicateId, result)
    end
end
