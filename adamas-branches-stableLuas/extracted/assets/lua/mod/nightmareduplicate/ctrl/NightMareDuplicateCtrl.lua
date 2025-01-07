NightMareDuplicateCtrl = BaseClass("NightMareDuplicateCtrl",Controller)
--梦魇副本的ctrl
local _tinsert = table.insert

function NightMareDuplicateCtrl:__init()
    self.nightmareFinalInfo = {} --梦魇副本终战记录
    self.nightSysDupPoint = {}--梦魇副本对应的最高积分
    self.nightMareLayerScoreList = {} --梦魇层级对应最高积分
    self.nightMareBestList = {} --梦魇副本历史最佳记录返回
    self.nightMareRankInfo = {} --梦魇副本排行榜数据
    
    self.useHeroIdList = {}--角色列表
    self.useBuffList = {} --buff列表
    self.lastDupStateList = {}--上次副本的stateList
    self.lastDupUseBuffList = {}--上次副本使用的buff列表(失败时存入，成功时删除)
    self.duplicateUseTime = nil --副本耗时
    self.hpPercent = nil --剩余血量
end

--进入梦魇副本同步
function NightMareDuplicateCtrl:UpdateNightMareDuplicateData(data)
    --这里同步下角色列表和buff列表
    self.useHeroIdList = data.use_hero_id_list
    self.useBuffList = data.use_buff_list
    
    local fightEventIdList = {}
    --把环境buff和词缀buff添加到fightEvent
    local nightDupCfg = NightMareConfig.GetDataNightmareDuplicate(mod.DuplicateCtrl:GetSystemDuplicateId())
    for i, evBuffId in pairs(nightDupCfg.environment_buff_id) do
        if evBuffId ~= 0 then
            local systemBuff = NightMareConfig.GetDataSystemBuff(evBuffId)
            table.insert(fightEventIdList, systemBuff.fight_event_id)
        end
    end
    for k, v in pairs(data.use_buff_list) do
		local fight_base_id = v.key 
		local index = v.value 
		
        local nightBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
        local fight_buff = nightBuffCfg.fight_buff[index]
        local buffId = fight_buff[1]
        local systemBuff = NightMareConfig.GetDataSystemBuff(buffId)
        table.insert(fightEventIdList, systemBuff.fight_event_id)
    end
    
    mod.DuplicateCtrl:SetFightEvent(fightEventIdList)
end

--退出梦魇副本同步
function NightMareDuplicateCtrl:ClearNightMareDuplicateData()
    self.useHeroIdList = {}
    self.useBuffList = {}
    self.duplicateUseTime = nil
    self.hpPercent = nil
end

--获取血量
function NightMareDuplicateCtrl:GetNightMareHpPercent()
    return self.hpPercent
end

--副本耗时
function NightMareDuplicateCtrl:GetNightMareDuplicateUseTime()
    return self.duplicateUseTime
end

--更新主界面梦魇层级对应最高积分
function NightMareDuplicateCtrl:SetNightMareLayerScoreList(data)
    for i, v in pairs(data.layer_score_list) do
        self.nightMareLayerScoreList[v.key] = v.value
    end
end

--获取主界面梦魇层级对应当前最高积分
function NightMareDuplicateCtrl:GetNightMareLayerScoreList(layer)
    return self.nightMareLayerScoreList[layer]
end

--获取当前通关到了第几层第几关
function NightMareDuplicateCtrl:GetNightMareNowLayerAndProgress()
    local layer = next(self.nightMareLayerScoreList) and #self.nightMareLayerScoreList or 1
    --获取该层的进度
    local nowProgress, maxProgress = self:GetNowLayerProgress(layer)
    if nowProgress == maxProgress then
        local layerDupList = NightMareConfig.GetDataNightmareDuplicateFindbyLayer(layer + 1)
        if layerDupList then
            return layer + 1, 1
        end
    end
    return layer, nowProgress
end

--获取上次的数据 
function NightMareDuplicateCtrl:GetLastDupStateList()
    return self.lastDupStateList
end

--设置上次选择的buff列表
function NightMareDuplicateCtrl:SetLastDupUseBuffList(systemDuplicateId)
    self.lastDupUseBuffList[systemDuplicateId] = self.useBuffList
end

--清除上次选择的buff列表
function NightMareDuplicateCtrl:ClearLastDupUseBuffList(systemDuplicateId)
    self.lastDupUseBuffList[systemDuplicateId] = nil
end

--获取上次选择的buff列表
function NightMareDuplicateCtrl:GetLastDupUseBuffList(systemDuplicateId)
    return self.lastDupUseBuffList[systemDuplicateId]
end

--更新主界面梦魇历史最佳记录
function NightMareDuplicateCtrl:SetNightMareBestList(data)
    --if v.duplicate_best_key_type == 1 then
    --    --副本id 
    --
    --elseif v.duplicate_best_key_type == 2 then
    --    --组id
    --
    --end
    
    --for i, v in pairs(data.duplicate_best_list) do
    --    self.nightMareBestList[v.duplicate_best_info_list.system_duplicate_id] = v
    --end
end

function NightMareDuplicateCtrl:GetNightMareBestList(system_duplicate_id)
    return self.nightMareBestList[system_duplicate_id]
end

--排行榜数据 
function NightMareDuplicateCtrl:SetNightMareRankInfo(data)
    self.nightMareRankInfo[data.rank_type] = data
end

--排行榜数据 
function NightMareDuplicateCtrl:GetNightMareRankInfo(rank_type)
    return self.nightMareRankInfo[rank_type]
end

--该副本组已经有哪些角色通关过副本
function NightMareDuplicateCtrl:GetNightMareDupGroupRoleList(systemDuplicateId)
    local collectedList = {}
    local nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId)
    local groupList = NightMareConfig.GetDataNightmareDuplicateFindbyDuplicateGroup(nightMareDupCfg.duplicate_group)
    if groupList then
        for i, sysDupId in ipairs(groupList) do
            --获取别的组是否用到目前的角色
            if sysDupId == systemDuplicateId then
                goto continue
            end

            local dupStateInfo = mod.DuplicateCtrl:GetDuplicateStateBySysId(sysDupId)
            if (not dupStateInfo) or (dupStateInfo.current_score == 0) then
                goto continue
            end

            for _, roleId in ipairs(dupStateInfo.use_hero_id_list) do
				collectedList[roleId] = sysDupId
            end

            ::continue::
        end
    end

    return collectedList
end

--该副本位于副本组的第几个
function NightMareDuplicateCtrl:GetNightMareDupGroupOrder(systemDuplicateId)
    local nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId)
    local nightMareGroupList = NightMareConfig.GetDataNightmareDuplicateFindbyDuplicateGroup(nightMareDupCfg.duplicate_group)
    for i, sysDupId in ipairs(nightMareGroupList) do
        if sysDupId == systemDuplicateId then
            return i
        end
    end
    
    return 1
end

--获取该副本的必选buff列表
function NightMareDuplicateCtrl:GetBasicUseBuffList(systemDuplicateId)
    local basicBuffList = {}
    local nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId)
    --获取词缀组
    local fightListById = NightMareConfig.GetDataNightmareTagFindById(nightMareDupCfg.final_fight_id)
    for _, id in pairs(fightListById) do
        local fightCfg = NightMareConfig.GetDataNightmareTag(id)
        --是否解锁
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(fightCfg.condition)
        if fightCfg.basic_base_buff ~= 0 and isPass then
            basicBuffList[fightCfg.fight_base_id] = fightCfg.basic_base_buff
        end
    end
    
    return basicBuffList
end

--根据玩家等级判断在哪个区
function NightMareDuplicateCtrl:GetPlayerInPart(level)
    local partList = NightMareConfig.GetDataNightmarePart()
    for i, v in pairs(partList) do
        if level >= v.level_limit[1] and level <= v.level_limit[2] then
            return v
        end
    end
end

--获取目前使用的buff的预计最大积分和混沌积分
function NightMareDuplicateCtrl:GetMaxTypePoint()
    local totalPoint = 0 --预计总积分
    local maxTypePoint = 0 --混沌积分
    local nightDupCfg = NightMareConfig.GetDataNightmareDuplicate(mod.DuplicateCtrl:GetSystemDuplicateId())
    for _, v in ipairs(self.useBuffList) do
        local fight_base_id = v.key
        local index = v.value

        local key = UtilsBase.GetDoubleKeys(nightDupCfg.final_fight_id, fight_base_id)
        local tagCfg = NightMareConfig.GetDataNightmareTag(key)
        local nightBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
        local fight_buff = nightBuffCfg.fight_buff[index]
        local pointConfig = NightMareConfig.GetDataNightmarePointRule(fight_buff[2])
        
        if tagCfg.fight_base_type == 3 and pointConfig then
            maxTypePoint = maxTypePoint + pointConfig.point
        end

        if pointConfig then
            totalPoint = totalPoint + pointConfig.point
        end
    end
    
    return totalPoint, maxTypePoint
end

--获取层级最大的积分
function NightMareDuplicateCtrl:GetNightMareLayerMaxScore(layer)
    local maxPoint = 0
    --获取该层所有的副本
    local layerDupList = NightMareConfig.GetDataNightmareDuplicateFindbyLayer(layer)
    for i, systemDuplicateId in pairs(layerDupList) do
        local point = self:GetDupMaxPoint(systemDuplicateId)
        maxPoint = maxPoint + point
    end
    return maxPoint
end

--获取该副本的最大积分
function NightMareDuplicateCtrl:GetDupMaxPoint(systemDuplicateId)
    local nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId)
    local maxPoint = self.nightSysDupPoint[nightMareDupCfg.final_fight_id]
    
    if not maxPoint then
        maxPoint = 0
        --获取词缀组
        local fightListById = NightMareConfig.GetDataNightmareTagFindById(nightMareDupCfg.final_fight_id)
        for _, id in ipairs(fightListById) do
            local fightCfg = NightMareConfig.GetDataNightmareTag(id)
            local nightBuffCfg = NightMareConfig.GetDataNightmareBuff(fightCfg.fight_base_id)
            local fightBuff = nightBuffCfg.fight_buff[#nightBuffCfg.fight_buff]
            
            local pointConfig = NightMareConfig.GetDataNightmarePointRule(fightBuff[2])
            if pointConfig then
                maxPoint = maxPoint + pointConfig.point
            end
        end
        self.nightSysDupPoint[nightMareDupCfg.final_fight_id] = maxPoint
    end


    return maxPoint
end

--获取该层的进度
function NightMareDuplicateCtrl:GetNowLayerProgress(layer)
    --获取该层所有的副本
    local layerDupList = NightMareConfig.GetDataNightmareDuplicateFindbyLayer(layer)
    
    local nowProgress = 0
    local maxProgress = #layerDupList
    for i, systemDuplicateId in pairs(layerDupList) do
        local dupStateList = mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId)
        if dupStateList and dupStateList.best_score > 0 then
            nowProgress = nowProgress + 1
        end
    end
    
    return nowProgress, maxProgress
end

--更新主界面梦魇终战记录信息
function NightMareDuplicateCtrl:SetNightMareFinalInfo(data)
    self.nightmareFinalInfo = data.nightmare_final_info
end

function NightMareDuplicateCtrl:GetNightMareFinalInfo()
    return self.nightmareFinalInfo
end

--使用的buff列表
function NightMareDuplicateCtrl:GetNightMareUseBuffList()
    return self.useBuffList
end

--使用的角色列表
function NightMareDuplicateCtrl:GetNightMareUseHeroList()
    return self.useHeroIdList
end

--进梦魇副本之前check副本组
function NightMareDuplicateCtrl:CheckDupGroup(nowSysDupId, duplicate_group, useHeroIdList)
    local groupList = NightMareConfig.GetDataNightmareDuplicateFindbyDuplicateGroup(duplicate_group)
    if groupList then
        for i, systemDuplicateId in ipairs(groupList) do
            --获取别的组是否用到目前的角色
            if systemDuplicateId == nowSysDupId then
                goto continue
            end
            
            local dupStateInfo = mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId)
            if not dupStateInfo then
                goto continue
            end
            
            for _, roleId in ipairs(dupStateInfo.use_hero_id_list) do
                if useHeroIdList[roleId] then
                    return roleId, systemDuplicateId
                end
            end
            
            ::continue::
        end
    end
    
    return false
end

function NightMareDuplicateCtrl:SetFinishNightMareDupData(systemDuplicateId, killMonList, isWin)
    --完成之前保存上一次的数据
    self.lastDupStateList = UtilsBase.copytab(mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId))
    if not isWin then
        self:SetLastDupUseBuffList(systemDuplicateId)
    else
        self:ClearLastDupUseBuffList(systemDuplicateId)
    end

    local timerId = Fight.Instance.duplicateManager:GetDuplicateUseTimerId()
    self.duplicateUseTime = Fight.Instance.duplicateManager:ReturnTimerTime(timerId)

    --计算编队整体血量(之后这段逻辑会写在duplicateManager)
    local nowLife = 0
    local maxLife = 0
    local player = Fight.Instance.playerManager:GetPlayer()
    --获取整个编队
    local entityList = player:GetEntityMap()
    for _, v in pairs(entityList) do
        local entity = BehaviorFunctions.GetEntity(v.InstanceId)
        local nowValue, maxValue = entity.attrComponent:GetValueAndMaxValue(EntityAttrsConfig.AttrType.Life)
        nowLife = nowLife + nowValue
        maxLife = maxLife + maxValue
    end
    self.hpPercent = nowLife / maxLife
end

-----------------协议交互
---进入梦魇副本
function NightMareDuplicateCtrl:EnterNightMareDup(systemDuplicateId, useHeroIdList, useBuffList)
    mod.NightMareDuplicateFacade:SendMsg("duplicate_nightmare_enter", systemDuplicateId, useHeroIdList, useBuffList)
end

---完成梦魇副本
function NightMareDuplicateCtrl:FinishNightMareDup(systemDuplicateId, killMonList, isWin)
    self:SetFinishNightMareDupData(systemDuplicateId, killMonList, isWin)
    mod.NightMareDuplicateFacade:SendMsg("duplicate_nightmare_finish", systemDuplicateId, killMonList, isWin, math.floor(self.duplicateUseTime), math.floor(self.hpPercent * 10000), self.useHeroIdList, self.useBuffList)
end

---请求梦魇排名数据
function NightMareDuplicateCtrl:GetDuplicateNightmareRank(rank_type)
    mod.NightMareDuplicateFacade:SendMsg("duplicate_nightmare_rank", rank_type)
end



