DailyActivityConfig = DailyActivityConfig or {}

local DataDailyActivity = Config.DataDailyActivity.Find
local DataSystemTask = Config.DataSystemTask.Find
local DataReward = Config.DataReward.Find

function DailyActivityConfig.GetDailyActivityConfig(controlId)
	local config = {}
	for _, v in pairs(DataDailyActivity) do
		if v.control_id == controlId then
			table.insert(config, v)
		end
	end
	
	if not next(config) then
		return 
	end
	
	table.sort(config, function(a, b) return a.activation < b.activation end)
	return config
end

local DefaultTeachId = 40004
function DailyActivityConfig.GetDailyActivityTeachId(controlId)
	for _, v in pairs(DataDailyActivity) do
		if v.control_id == controlId then
			return v.teach_id or DefaultTeachId
		end
	end
	
	return DefaultTeachId
end

--1:未完成 2:完成未领取 3:已领取 4:不存在结果，可能客户端本地数据被修改
function DailyActivityConfig.GetRewardReciveType(config, progress, canGetList, hasGetList)
	local finish = progress >= config.activation
	if not finish then
		return 1
	end
	
	if TableUtils.ContainValue(canGetList, config.activation) then
		return 2
	end
	
	if TableUtils.ContainValue(hasGetList, config.activation) then
		return 3
	end
	
	LogError("活跃度领取状态异常:"..config.activation)
	return 4
end

function DailyActivityConfig.GetMaxActivation(controlId)
	local config = DailyActivityConfig.GetDailyActivityConfig(controlId)
	if not config then
		return 9999
	end
	
	return config[#config].activation
end

function DailyActivityConfig.GetRewardList(rewardId)
	local reward = DataReward[rewardId]
	if not reward then
		return
	end
	
	return reward.reward_list
end

function DailyActivityConfig.GetTaskConfig(taskId)
	local config = DataSystemTask[taskId]
	if not config then
		return 
	end
	
	return config
end

function DailyActivityConfig.GetTaskActivation(rewardId)
	local rewardList = DailyActivityConfig.GetRewardList(rewardId)
	if not rewardList or not next(rewardList) then
		return 0
	end
	
	--每日活跃的任务奖励必然是活跃度，不然就是配置错误
	return rewardList[1][2]
end

function DailyActivityConfig.GetTaskProgress(taskId)
	local progress = mod.SystemTaskCtrl:GetTaskProgress(taskId)
	local maxProgress = SystemTaskConfig.GetTaskTarget(taskId)
	
	return progress, maxProgress
end

--[[
未领取>未完成>已领取
优先级越高，任务越靠前
若优先级相同则按系统任务表的显示优先级排序
当活跃度达到最大值，任务排序不会再发生变化。
]]
function DailyActivityConfig.SortTaskList(taskList)
	local unfinish = {}
	local finish = {}
	local receive = {}
	
	local fullActivation = mod.DailyActivityCtrl:IsFullActivation()

	--分类
	for _, v in pairs(taskList) do
		local progress = mod.SystemTaskCtrl:GetTaskProgress(v.task_id)
		-- -1的情况是完成已领取
		if progress == -1 then
			table.insert(receive, v)
		--满活跃当全部已完成未领取
		elseif fullActivation then
			table.insert(finish, v)
		else
			local maxProgress = SystemTaskConfig.GetTaskTarget(v.task_id)
			if progress >= maxProgress then
				table.insert(finish, v)
			else
				table.insert(unfinish, v)
			end
		end
	end

	--按优先级排序
	local sortFunc = function(a, b)
		local taskA = DailyActivityConfig.GetTaskConfig(a.task_id)
		local taskB = DailyActivityConfig.GetTaskConfig(b.task_id)
		return taskA.order > taskB.order
	end

	table.sort(unfinish, sortFunc)
	table.sort(finish, sortFunc)
	table.sort(receive, sortFunc)

	TableUtils.ClearTable(taskList)

	for _, v in pairs(finish) do
		table.insert(taskList, v)
	end

	for _, v in pairs(unfinish) do
		table.insert(taskList, v)
	end

	for _, v in pairs(receive) do
		table.insert(taskList, v)
	end
end