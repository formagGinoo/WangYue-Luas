---@class ConditionManager
ConditionManager = BaseClass("ConditionManager")
local LimitConditions = FightEnum.LimitConditions

local TargetByParam_1 = 
{
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
}
local TargetByParam_2 = 
{
    [LimitConditions.CheckItemNum] = true,
    [LimitConditions.CheckPartnerLevel] = true,
    [LimitConditions.CheckRoleLevel] = true,
    [LimitConditions.CheckWeaponLevel] = true,
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
    }
end

function ConditionManager:BindListener()
	EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("OnLevelUpdate"))
	EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("OnTaskFinish"))
	EventMgr.Instance:AddListener(EventName.GetRole, self:ToFunc("OnGetRole"))
	EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("OnItemUpdate"))
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

function ConditionManager:CheckConditionByConfig(conditionId)
    local config = Config.DataCondition.data_condition[conditionId]
    if not config or not next(config) then
        --策划要求改成没配置时系统默认开启
        return true
    end

    if not config.type or config.type == 0 then
        return self:CheckFormula(config.logical_type, config.logical_args)
    elseif self.conditions[config.type] then
        local targetValue = self.GetConditionTarget(conditionId)
        return self:CheckCondition(config.type, {config.arg1, config.arg2, config.arg3, config.arg4}, targetValue)
    else
        self:QueryServer(conditionId)
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
    return mod.TaskCtrl:CheckTaskIsFinish(tonumber(params[1])) == true
end

function ConditionManager:CheckWorldLevel(params)
    local _, maxLev = mod.WorldLevelCtrl:GetWorldLevel()
    return maxLev >= tonumber(params[1]), maxLev
end

function ConditionManager:CheckAllTalentLevel(params)
    local count = mod.TalentCtrl:GetAllTalentLev()
    return  count >= tonumber(params[1]), count
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
    else
        return 1
    end
end

function ConditionManager:QueryServer(conditionId)
    mod.WorldFacade:SendMsg("condition_state", conditionId)
end

function ConditionManager:OnRecv_ConditionState(data)
    EventMgr.Instance:Fire(EventName.ConditionCheck, data)
    LogError("condition QueryServer = "..tostring(data.state))
    return data.state
end

function ConditionManager:AddListener(conditionId, func)
	local config = Config.DataCondition.data_condition[conditionId]
	if not config or not next(config) then
		LogError("错误的条件id"..conditionId)
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