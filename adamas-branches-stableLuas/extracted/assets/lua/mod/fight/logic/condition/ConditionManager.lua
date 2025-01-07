---@class ConditionManager
ConditionManager = BaseClass("ConditionManager")
local LimitConditions = FightEnum.LimitConditions

local TargetByParam_1 = {
    [LimitConditions.CheckRoleCountByLevel] = true,
    [LimitConditions.CheckAllTalentLevel] = true,
    [LimitConditions.CheckLevel] = true,
    [LimitConditions.CheckPartnerCountByLevel] = true,
    [LimitConditions.CheckPerfectAssassinate] = true,
    [LimitConditions.CheckUsePartnerSkill] = true,
    [LimitConditions.CheckRoleCountByStage] = true,
    [LimitConditions.CheckWorldLevel] = true,
    [LimitConditions.CheckWeaponCountByLevel] = true,
    [LimitConditions.CheckWeaponCountByStage] = true,
    [LimitConditions.CheckTransportByCount] = true,
    [LimitConditions.CheckUseItem] = true,
    [LimitConditions.CheckGetItem] = true,
    [LimitConditions.CheckRoleUpgrade] = true,
    [LimitConditions.CheckWeaponUpgrade] = true,
    [LimitConditions.CheckKillEnemy] = true,
    [LimitConditions.CheckDodge] = true,
    [LimitConditions.CheckElementReadyState] = true,
    [LimitConditions.CheckMercenaryTask] = true,
    [LimitConditions.CheckPlayerIdentity] = true,
    [LimitConditions.CheckPlayerNowIdentity] = true,
    [LimitConditions.CheckNightMareFinishSystemDup] = true,
    [LimitConditions.CheckSystemTaskFinish] = true,
    [LimitConditions.UnLockPartnerSkill] = true
}
local TargetByParam_2 = {
    [LimitConditions.CheckItemNum] = true,
    [LimitConditions.CheckPartnerLevel] = true,
    [LimitConditions.CheckRoleLevel] = true,
    [LimitConditions.CheckWeaponLevel] = true,
    [LimitConditions.CheckHistroyUseItem] = true,
    [LimitConditions.CheckNightMareLevelPoint] = true,
    [LimitConditions.CheckNightMareLayerPoint] = true,
    [LimitConditions.CheckAssetPartnerCount] = true
}

local TargetByParam_3 = {
    [LimitConditions.CheckDecorationWorkAmount] = true,
}

local SearchFromStatistic = {
    [LimitConditions.CheckHistroyUseItem] = true
}

local _tinsert = table.insert

function ConditionManager:__init(fight)
    self.fight = fight

    self.listenerDict = {}
end

function ConditionManager:StartFight()
    self:BindConditions()
    self:BindListener()
end

function ConditionManager:BindConditions()
    self.conditions = {
        [LimitConditions.CheckLevel] = self:ToFunc("CheckLevel"),
        [LimitConditions.CheckRole] = self:ToFunc("CheckRole"),
        [LimitConditions.CheckItemNum] = self:ToFunc("CheckItemNum"),
        [LimitConditions.CheckSkillLevelByHeroNum] = self:ToFunc("CheckSkillLevelByHeroNum"),
        [LimitConditions.CheckTask] = self:ToFunc("CheckTask"),
        [LimitConditions.CheckWorldLevel] = self:ToFunc("CheckWorldLevel"),
        [LimitConditions.CheckAllTalentLevel] = self:ToFunc("CheckAllTalentLevel"),
        [LimitConditions.CheckRoleLevel] = self:ToFunc("CheckRoleLevel"),
        [LimitConditions.CheckRoleCountByLevel] = self:ToFunc("CheckRoleCountByLevel"),
        [LimitConditions.CheckRoleCountByStage] = self:ToFunc("CheckRoleCountByStage"),
        [LimitConditions.CheckWeaponLevel] = self:ToFunc("CheckWeaponLevel"),
        [LimitConditions.CheckWeaponCountByLevel] = self:ToFunc("CheckWeaponCountByLevel"),
        [LimitConditions.CheckWeaponCountByStage] = self:ToFunc("CheckWeaponCountByStage"),
        [LimitConditions.CheckPartnerLevel] = self:ToFunc("CheckPartnerLevel"),
        [LimitConditions.CheckPartnerCountByLevel] = self:ToFunc("CheckPartnerCountByLevel"),
        [LimitConditions.CheckTransport] = self:ToFunc("CheckTransport"),
        [LimitConditions.CheckTransportByCount] = self:ToFunc("CheckTransportByCount"),
        [LimitConditions.CheckPerfectAssassinate] = self:ToFunc("CheckPerfectAssassinate"),
        [LimitConditions.CheckPlayerIdentity] = self:ToFunc("CheckPlayerIdentity"),
        [LimitConditions.CheckPlayerNowIdentity] = self:ToFunc("CheckPlayerNowIdentity"),
        [LimitConditions.CheckNightMareLevelPoint] = self:ToFunc("CheckNightMareLevelPoint"),
        [LimitConditions.CheckNightMareLayerPoint] = self:ToFunc("CheckNightMareLayerPoint"),
        [LimitConditions.CheckNightMareFinishSystemDup] = self:ToFunc("CheckNightMareFinishSystemDup"),
        [LimitConditions.CheckPartnerPassiveSkillCount] = self:ToFunc("CheckPartnerPassiveSkillCount"),
        [LimitConditions.CheckTrafficTotalDistance] = self:ToFunc("CheckTrafficTotalDistance"),
        [LimitConditions.CheckVITTotalCost] = self:ToFunc("CheckVITTotalCost"),
        [LimitConditions.CheckDailyActivation] = self:ToFunc("CheckDailyActivation"),
        [LimitConditions.CheckRogueLikeEventNum] = self:ToFunc("CheckRogueLikeEventNum"),
        [LimitConditions.CheckPurchasePartnerBook] = self:ToFunc("CheckPurchasePartnerBook"),
        [LimitConditions.CheckFeedMailingTime] = self:ToFunc("CheckFeedMailingTime"),
        [LimitConditions.CheckSignInDays] = self:ToFunc("CheckSignInDays"),
        [LimitConditions.CheckSinceFinishLevelEvent] = self:ToFunc("CheckSinceFinishLevelEvent"),
        
        [LimitConditions.CheckAssetLevel] = self:ToFunc("CheckAssetLevel"),
        [LimitConditions.CheckHaveDecorationCount] = self:ToFunc("CheckHaveDecorationCount"),
        [LimitConditions.CheckSystemTaskFinish] = self:ToFunc("CheckSystemTaskFinish"),
    }
end

function ConditionManager:BindListener()
    EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("OnLevelUpdate"))
    EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("OnTaskFinish"))
    EventMgr.Instance:AddListener(EventName.GetRole, self:ToFunc("OnGetRole"))
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("OnItemUpdate"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinish, self:ToFunc("OnSystemTaskChange"))
    EventMgr.Instance:AddListener(EventName.SystemTaskChange, self:ToFunc("OnSystemTaskChange"))
end

function ConditionManager:GetConditionDesc(conditionId)
    local config = Config.DataCondition.data_condition[conditionId]
    if not config or not next(config) then
        return
    end

    return config.description
end

function ConditionManager:CheckCondition(type, params, targetValue)
    if self.conditions[type] then
        return self.conditions[type](params, targetValue)
    end

    return false
end

function ConditionManager:CheckFormula(type, args)
    if not args or not next(args) then
        return false
    end

    for i = 1, #args do
        if self:CheckConditionByConfig(args[i]) and type == 2 then
            return true
        elseif not self:CheckConditionByConfig(args[i]) then
            if type == 1 then
                return false
            end
        end
    end

    return type == 1
end

-- LogError("condition check = "..tostring(Fight.Instance.conditionManager:CheckConditionByConfig(1)))

function ConditionManager:CheckConditionByConfig(conditionId,notQueryServer)
    local config = Config.DataCondition.data_condition[conditionId]
    if not config or not next(config) then
        --策划要求改成没配置时系统默认开启
        return true
    end

    if not config.type or config.type == 0 then
        return self:CheckFormula(config.logical_type, config.logical_args)
    elseif self.conditions[config.type] then
        local targetValue = self.GetConditionTarget(conditionId)
        return self:CheckCondition(config.type, { config.arg1, config.arg2, config.arg3, config.arg4 }, targetValue)
    else
        if not notQueryServer then
            self:QueryServer(conditionId)
        end
    end
end

function ConditionManager:CheckLevel(params)
    local adventureInfo = mod.WorldLevelCtrl:GetAdventureInfo()
    if not adventureInfo or not next(adventureInfo) then
        return false
    end

    return adventureInfo.lev >= tonumber(params[1]), adventureInfo.lev
end

function ConditionManager:CheckRole(params)
    local roleInfo = mod.RoleCtrl:GetRoleData(tonumber(params[1]))
    if roleInfo and next(roleInfo) then
        return true
    end

    return false
end

function ConditionManager:CheckItemNum(params)
    local itemNum = mod.BagCtrl:GetItemCountById(tonumber(params[1]))
    return itemNum >= tonumber(params[2]), itemNum
end

function ConditionManager:CheckTask(params)
    local taskId = tonumber(params[1])
    if mod.TaskCtrl:CheckTaskIsFinish(taskId) then
        return true
    end

    if not params[2] or params[2] == "" then
        return false
    end

    local stepId = tonumber(params[2])
    local task = mod.TaskCtrl:GetTask(taskId)
    return task and (task.stepId > stepId or (task.stepId == stepId and task.isFinish))
end

function ConditionManager:CheckWorldLevel(params)
    local _, maxLev = mod.WorldLevelCtrl:GetWorldLevel()
    return maxLev >= tonumber(params[1]), maxLev
end

function ConditionManager:CheckAllTalentLevel(params)
    local count = mod.TalentCtrl:GetAllTalentLev()
    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckRoleLevel(params)
    local roleData = mod.RoleCtrl:GetRoleData(tonumber(params[1]))
    if roleData then
        return tonumber(params[2]) >= roleData.lev
    else
        return false, 0
    end
end

function ConditionManager:CheckRoleCountByLevel(params)
    local roleList = mod.RoleCtrl:GetRoleList()
    local count = 0
    for key, value in pairs(roleList) do
        if value.lev >= tonumber(params[2]) then
            count = count + 1
        end
    end

    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckRoleCountByStage(params)
    local roleList = mod.RoleCtrl:GetRoleList()
    local count = 0
    for key, value in pairs(roleList) do
        if value.stage >= tonumber(params[2]) then
            count = count + 1
        end
    end

    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckWeaponLevel(params)
    local data = mod.BagCtrl:GetItemsById(tonumber(params[1]))
    local maxLev = 0

    for key, value in pairs(data) do
        if value.lev > maxLev then
            maxLev = value.lev
        end
    end

    return maxLev >= tonumber(params[2]), maxLev
end

-- 查询是否有X个英雄将技能提升至Y级
function ConditionManager:CheckSkillLevelByHeroNum(params)
    local heroList = mod.RoleCtrl:GetRoleList()
    local numLimit = tonumber(params[1])
    local levelLimit = tonumber(params[2])
    local typeLimit = tonumber(params[3])

    if numLimit > TableUtils.GetTabelLen(heroList) then
        return false
    end

    local eligibleSkillList = mod.RoleCtrl:GetAllEligibleSkills(levelLimit, typeLimit)

    return #eligibleSkillList >= numLimit, #eligibleSkillList
end

-- 检查任意X只月灵拥有Y个打书被动
function ConditionManager:CheckPartnerPassiveSkillCount(params)
    local partnerCountLimit = tonumber(params[1])
    local partnerPassiveCountLimit = tonumber(params[2])

    if partnerCountLimit == nil or partnerPassiveCountLimit == nil then
        LogError("月灵打书被动条件检测缺少参数")
        return false
    end

    local partnersData = {};
    for _, value in pairs(mod.BagCtrl:GetPartnersData()) do
        table.insert(partnersData, value)
    end

    if #partnersData == 0 then
        return false
    end

    if partnersData then
        table.sort(partnersData, function(a, b)
            return #a.passive_skill_list > #b.passive_skill_list
        end)

        for i = 1, #partnersData do
            if (partnerCountLimit > 0) then
                partnerCountLimit = partnerCountLimit - 1
                partnerPassiveCountLimit = partnerPassiveCountLimit - #partnersData[i].passive_skill_list
                goto continue
            end

            break

            :: continue ::
        end

        return partnerPassiveCountLimit <= 0
    end
end

-- 检查历史总驾驶距离达到X米/公里
function ConditionManager:CheckTrafficTotalDistance(params)
    local distanceLimit = tonumber(params[1])
    local isKM = tonumber(params[2]) or 1        -- 1是米，2是公里

    if not distanceLimit then
        LogError("行驶总路程条件检测缺少参数")
        return false
    end
    
    local totalDistance = mod.RoleCtrl:GetTrafficTotalDistance() or 0
    if isKM == 2 then
        distanceLimit = distanceLimit * 1000
    end
    
    return totalDistance >= distanceLimit
end

-- 距离上次随机事件完成
function ConditionManager:CheckSinceFinishLevelEvent(params)
    local targetLevel = tonumber(params[1])

    local targetFinish = mod.LevelEventCtrl:CheckLevelEventFinish(targetLevel)

    if targetFinish then
        local sinceTime = TimeUtils.GetCurTimestamp() - targetFinish
        return sinceTime > tonumber(params[2]),sinceTime
    else
        return false
    end
end

-- 历史登陆天数是否达到x天
function ConditionManager:CheckSignInDays(params)
    local dayLimit = tonumber(params[1])
    local dayCount = mod.RoleCtrl:GetLoginCount() or 0

    if not dayLimit then
        LogError("历史登陆天数条件检测缺少参数")
        return false
    end

    return dayCount >= dayLimit, dayCount
end
-- 累计脉灵投喂X次
function ConditionManager:CheckFeedMailingTime(params) 
    local numLimit = tonumber(params[1])

    if not numLimit then
        LogError("累计脉灵投喂条件检测缺少参数")
        return false
    end
    
    local totalFeedTime = mod.MailingCtrl:GetFeedMailingTotalTime() or 0
    
    return totalFeedTime >= numLimit, totalFeedTime
end

-- 累计消耗X体力
function ConditionManager:CheckVITTotalCost(params)
    local vitLimit = tonumber(params[1])

    if not vitLimit then
        LogError("累计消耗体力条件检测缺少参数")
        return false
    end
    
    local totalVitCost = mod.RoleCtrl:GetItemExpendCount(5) or 0   -- 5是塑土
    
    return totalVitCost >= vitLimit, totalVitCost
end

-- 当日累计活跃达到X
function ConditionManager:CheckDailyActivation(params)
    local activationLimit = tonumber(params[1])

    if not activationLimit then
        LogError("当日累计活跃条件检测缺少参数")
    end
    
    local activation = mod.DailyActivityCtrl:GetInfo().value or 0
    
    return activation >= activationLimit, activation
end

-- 完成X个肉鸽事件
function ConditionManager:CheckRogueLikeEventNum(params)
    local numLimit = tonumber(params[1])

    if not numLimit then
        LogError("当日累计活跃条件检测缺少参数")
    end
    
    local num = mod.RoguelikeCtrl:GetFinishedEventNum() or 0
    
    return num >= numLimit, num
end

-- 检查从商店类型为X购买Y本品质为Z的月灵技能书
function ConditionManager:CheckPurchasePartnerBook(params)
    local numLimit = tonumber(params[1])
    local qualityLimit = tonumber(params[2])
    local shopTypeLimit = tonumber(params[3])
    
    local goodsData = mod.PurchaseCtrl:GetHistoryPurchaseData(shopTypeLimit)
    if goodsData then
        for i = 1, #goodsData do
            if goodsData[i].quality == qualityLimit and goodsData[i].itemType == 1057 then  -- 1057是月灵技能书
                numLimit = numLimit - goodsData[i].num
            end
        end
        
        return numLimit <= 0
    else
        return false
    end
end

function ConditionManager:CheckWeaponCountByLevel(params)
    local data = mod.BagCtrl:GetBagByType(BagEnum.BagType.Weapon)
    local count = 0
    for key, value in pairs(data) do
        for _, v in pairs(value) do
            if v.lev >= tonumber(params[2]) then
                count = count + 1
            end
        end
    end
    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckWeaponCountByStage(params)
    local data = mod.BagCtrl:GetBagByType(BagEnum.BagType.Weapon)
    local count = 0
    for key, value in pairs(data) do
        for _, v in pairs(value) do
            if v.stage >= tonumber(params[2]) then
                count = count + 1
            end
        end
    end
    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckPartnerLevel(params)
    local data = mod.BagCtrl:GetItemsById(tonumber(params[1]))
    local maxLev = 0

    for key, value in pairs(data) do
        if value.lev > maxLev then
            maxLev = value.lev
        end
    end

    return maxLev >= tonumber(params[2]), maxLev
end

function ConditionManager:CheckPartnerCountByLevel(params)
    local data = mod.BagCtrl:GetBagByType(BagEnum.BagType.Partner) or {}
    local count = 0
    for key, value in pairs(data) do
        if value.lev >= tonumber(params[2]) then
            count = count + 1
        end
    end
    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckTransport(params)
    return mod.WorldCtrl:CheckIsTransportPointActive(tonumber(params[1]))
end

function ConditionManager:CheckTransportByCount(params)
    local points = mod.WorldCtrl:GetTransportPoint()
    local count = 0
    for key, value in pairs(points) do
        if WorldConfig.IsTransport(key) then
            count = count + 1
        end
    end
    return count >= tonumber(params[1]), count
end

function ConditionManager:CheckPlayerIdentity(params)
    local identityLvMap = mod.IdentityCtrl:GetPlayerIdentity()
    local id = tonumber(params[1])
    local lv = tonumber(params[2])
    if not identityLvMap[id] or identityLvMap[id] < lv then
        return false
    end
    return true
end

function ConditionManager:CheckPlayerNowIdentity(params)
    local identity = mod.IdentityCtrl:GetNowIdentity()
    local id = tonumber(params[1])
    local lv = tonumber(params[2])
    if identity.id == id and identity.lv >= lv then
        return true
    end
    return false
end

function ConditionManager:CheckNightMareLevelPoint(params)
    local id = tonumber(params[1]) --systemDuplicateId
    local point = tonumber(params[2]) --积分数值
    local stateList = mod.DuplicateCtrl:GetDuplicateStateBySysId(id)
    if stateList and stateList.system_duplicate_id == id and stateList.best_score >= point then
        return true
    end
    return false
end

function ConditionManager:CheckNightMareLayerPoint(params)
    local id = tonumber(params[1]) --layer
    local point = tonumber(params[2]) --积分数值
    local layerScore = mod.NightMareDuplicateCtrl:GetNightMareLayerScoreList(id)
    if layerScore and layerScore >= point then
        return true
    end
    return false
end

function ConditionManager:CheckNightMareFinishSystemDup(params)
    local id = tonumber(params[1]) --systemDuplicateId
    local stateList = mod.DuplicateCtrl:GetDuplicateStateBySysId(id)
    if stateList and stateList.best_score > 0 then
        return true
    end
    return false
end

function ConditionManager:CheckAssetLevel(params)
    local lv = mod.AssetPurchaseCtrl:GetAssetLevel(tonumber(params[1]))
    if lv and lv >= tonumber(params[2])then
        return true
    end
    return false
end

function ConditionManager:CheckHaveDecorationCount(params)
    local count = mod.AssetPurchaseCtrl:GetDecorationTotalCount(params[1])
    if count and count >= tonumber(params[2]) then
        return true
    end
    return false
end

function ConditionManager:CheckSystemTaskFinish(params)
    local taskId = tonumber(params[1])
    local isFinish = mod.SystemTaskCtrl:CheckTaskFinished(taskId)
    if not isFinish then
        local curValue = mod.SystemTaskCtrl:GetTaskProgress(taskId)
        local targetValue = ConditionManager.GetConditionTarget(AssetTaskConfig.GetAssetTaskInfoById(taskId).condition)
        return curValue >= targetValue
    end
    return isFinish
end

-- LogError("condition check = "..tostring(Fight.Instance.conditionManager:CheckSystemOpen(1)))

function ConditionManager:CheckSystemOpen(systemId)
    local config = Config.DataSystemOpen.data_system_open[systemId]
    if not config or not next(config) then
        return false
    end

    local isPass = self:CheckConditionByConfig(config.condition)
    local desc = not isPass and self:GetConditionDesc(config.condition) or ""

    return isPass, desc
end

function ConditionManager.GetConditionTarget(conditionId)
    local config = Config.DataCondition.data_condition[conditionId]
    if TargetByParam_1[config.type] then
        return tonumber(config.arg1)
    elseif TargetByParam_2[config.type] then
        return tonumber(config.arg2)
    elseif TargetByParam_3[config.type] then
        return tonumber(config.arg3)
    else
        return 1
    end
end

function ConditionManager.GetConditionSearchFromStatistic(conditionId)
    local config = Config.DataCondition.data_condition[conditionId]
    return SearchFromStatistic[config.type]
end

function ConditionManager:QueryServer(conditionId)
    -- mod.WorldFacade:SendMsg("condition_state", conditionId)
end

function ConditionManager:OnRecv_ConditionState(data)
    EventMgr.Instance:Fire(EventName.ConditionCheck, data)
    -- LogError("condition QueryServer = "..tostring(data.state))
    return data.state
end

function ConditionManager:AddListener(conditionId, func)
    local config = Config.DataCondition.data_condition[conditionId]
    if not config or not next(config) then
        LogError("错误的条件id" .. conditionId)
        return
    end

    if not self.listenerDict[config.type] then
        self.listenerDict[config.type] = {}
    end
    local dict = self.listenerDict[config.type]
    dict[conditionId] = dict[conditionId] or {}

    _tinsert(dict[conditionId], func)
end

function ConditionManager:OnEventInvoke(type)
    local data = self.listenerDict[type]
    if not data or not next(data) then
        return
    end

    local removeList = {}
    for id, funcMap in pairs(data) do
        if self:CheckConditionByConfig(id) then
            for _, func in ipairs(funcMap) do
                func(id)
            end
            table.insert(removeList, id)
        end
    end

    for i = 1, #removeList do
        data[removeList[i]] = nil
    end
end

--消息
function ConditionManager:OnLevelUpdate(addExp, level)
    if not level then
        return
    end

    self:OnEventInvoke(LimitConditions.CheckLevel)
end

function ConditionManager:OnGetRole(roleId)
    self:OnEventInvoke(LimitConditions.CheckRole)
end

function ConditionManager:OnTaskFinish(taskId)
    self:OnEventInvoke(LimitConditions.CheckTask)
end

function ConditionManager:OnItemUpdate()
    self:OnEventInvoke(LimitConditions.CheckItemNum)
end

function ConditionManager:OnSystemTaskChange()
    self:OnEventInvoke(LimitConditions.CheckSystemTaskFinish)
end