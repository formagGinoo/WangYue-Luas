SystemTaskConfig = SystemTaskConfig or {}

local DataSystemTask = Config.DataSystemTask
local DataCondition = Config.DataCondition.data_condition

function SystemTaskConfig.GetTaskByGroup(group)
    local temp = {}
    local tempOrder = {}
    for key, taskId in pairs(DataSystemTask.FindbyGroup[group]) do
        table.insert(temp, taskId)
        local curA = mod.SystemTaskCtrl:GetTaskProgress(taskId)
        local targetA = SystemTaskConfig.GetTaskTarget(taskId)
        curA = curA < targetA and curA or targetA
        local order = 100000
        if curA == -1 then
            order = order * 1
        elseif curA == targetA then
            order = order * 3
        else
            order = order * 2
        end
        tempOrder[taskId] = order
    end
    table.sort(temp, function (a, b)
        return (SystemTaskConfig.GetTask(a).order + tempOrder[a]) > (SystemTaskConfig.GetTask(b).order + tempOrder[b])
    end)
    return temp
end

function SystemTaskConfig.GetTaskMapByGroup(group)
    return DataSystemTask.FindbyGroup[group]
end

function SystemTaskConfig.GetTaskTarget(taskId)
    local config = SystemTaskConfig.GetTask(taskId)
    return ConditionManager.GetConditionTarget(config.condition)
end

function SystemTaskConfig.GetTask(id)
    return DataSystemTask.Find[id]
end

local LocalTaskCondition = 
{
    [FightEnum.LimitConditions.CheckLevel] = true,
    [FightEnum.LimitConditions.CheckRole] = true,
    [FightEnum.LimitConditions.CheckTask] = true,

    [FightEnum.LimitConditions.CheckWorldLevel] = true,
    [FightEnum.LimitConditions.CheckAllTalentLevel] = true,
    [FightEnum.LimitConditions.CheckRoleLevel] = true,
    [FightEnum.LimitConditions.CheckRoleCountByLevel] = true,
    [FightEnum.LimitConditions.CheckRoleCountByStage] = true,

    [FightEnum.LimitConditions.CheckItemNum] = true,
    [FightEnum.LimitConditions.CheckPartnerCountByLevel] = true,
    [FightEnum.LimitConditions.CheckPartnerLevel] = true,
    [FightEnum.LimitConditions.CheckWeaponCountByLevel] = true,
    [FightEnum.LimitConditions.CheckWeaponCountByStage] = true,
    [FightEnum.LimitConditions.CheckWeaponLevel] = true,

    [FightEnum.LimitConditions.CheckTransport] = true,
    [FightEnum.LimitConditions.CheckTransportByCount] = true,
}

function SystemTaskConfig.UseLocalProgress(id)
    local data = SystemTaskConfig.GetTask(id)
    local type = DataCondition[data.condition].type
    return LocalTaskCondition[type]
end

SystemTaskConfig.EventType =
{
    PerfectAssassinate = 1, -- 完美刺杀
	KillEnemy = 2, --击杀敌人
    Dodge = 3, -- 闪避或跳反
	EnterElementStateReady = 4, -- 击破弱点
	UsePartnerSkill = 5, --使用佩从技能
}