ActivityConfig = ActivityConfig or {}

local DataSignInMain = Config.DataSignInMain.Find
local DataSignInReward = Config.DataSignInReward.Find
local DataNoviceTaskMain = Config.DataNoviceTaskMain.Find
local DataNoviceTaskSumReward = Config.DataNoviceTaskSumReward.Find
local DataReward = Config.DataReward.Find
local DataSystemTask = Config.DataSystemTask.Find
local DataReward = Config.DataReward.Find
ActivityConfig.TaskGearMap = {}
ActivityConfig.TaskGearMapArray = {}

function ActivityConfig.GetTaskConfig(taskId)
	local config = DataSystemTask[taskId]
	if not config then
		return 
	end
	
	return config
end

function ActivityConfig.GetActivityReward(lev)
    if DataActivity[lev].completion_reward == 0 then
        return
    end
    return ItemConfig.GetReward(DataActivity[lev].completion_reward)
end

-- 获得经过排序后的task组列表
function ActivityConfig.GetActivityTask(id)
    if not DataNoviceTaskMain[id].system_task_group then
        return
    end
    local taskGroupList = {}
    for i, v in ipairs(DataNoviceTaskMain[id].system_task_group) do
        table.insert(taskGroupList,SystemTaskConfig.GetTaskByGroup(v))
    end
    return taskGroupList
end

-- 获得原生task组列表
function ActivityConfig.GetActivityTaskMap(id)
    if not DataNoviceTaskMain[id].system_task_group then
        return {}
    end
    local taskGroupMapList = {}
    for i, v in ipairs(DataNoviceTaskMain[id].system_task_group) do
        table.insert(taskGroupList,SystemTaskConfig.GetTaskMapByGroup(v))
    end
    return taskGroupMapList
end


function ActivityConfig.GetChangeDesc(index, lev, isDegrade)
    if index == 1 then
        return string.format(TI18N("确认后，世界等级调整到<color=#ffb865>Lv.%s</color>"), lev)
    elseif index == 2 then
        if isDegrade then
            return TI18N("世界上的敌人等级<color=#ffb865>降低</color>")
        else
            return TI18N("世界上的敌人等级<color=#ffb865>提升</color>")
        end
    elseif index == 3 then
        if isDegrade then
            return TI18N("世界上的敌人掉落等级<color=#ffb865>降低</color>")
        else
            return TI18N("世界上的敌人掉落等级<color=#ffb865>提升</color>")
        end
    end
end



function ActivityConfig.GetRewardList(rewardId)
	local reward = DataReward[rewardId]
	if not reward then
		return
	end
	return reward.reward_list
end

function ActivityConfig.GetDataSignInMain(id)
    return DataSignInMain[id]
end

function ActivityConfig.GetDataSignInReward(id)
    local rewardsDay = {}
    for k, v in pairs(DataSignInReward) do
        if v.id == id then
            table.insert(rewardsDay,v)
        end
    end
    return rewardsDay
end

function ActivityConfig:GetTaskGear(id)
    if not self.TaskGearMap[id] then
        local TaskGear = {}
        for k, v in pairs(DataNoviceTaskSumReward) do
            if v.task_id == id then
                TaskGear[v.num] = v
            end
        end
        self.TaskGearMap[id] = TaskGear
    end
    return self.TaskGearMap[id]
end

function ActivityConfig:GetTaskGearArray(id)
    if not self.TaskGearMapArray[id] then
        local TaskGear = {}
        for k, v in pairs(DataNoviceTaskSumReward) do
            if v.task_id == id then
                table.insert(TaskGear,v)
            end
			
        end
		table.sort(TaskGear,function (a, b)
				return a.num < b.num
			end)
        self.TaskGearMapArray[id] = TaskGear
    end
    return self.TaskGearMapArray[id]
end

function ActivityConfig.GetDataNoviceTaskMain(id)
    return DataNoviceTaskMain[id]
end

