
TaskConfig = TaskConfig or {}

local DataTask = Config.DataTask
local DataTaskType = Config.DataTaskType
local DataTaskReward = Config.DataTaskReward
local DataTaskStage = Config.DataTask.data_task_stage

local taskMainType = nil
local taskCount = nil
local taskChapterInfo = nil

function TaskConfig.GetAllTaskMainType()
	if taskMainType then
		return taskMainType
	end

	taskMainType = {}
	for k, v in pairs(DataTaskType.Find) do
		if taskMainType[v.type] then
			goto continue
		end

		taskMainType[v.type] = v.type_name

		::continue::
	end

	return taskMainType
end

function TaskConfig.GetTaskChapterInfo(taskType, taskChildType)
	if not taskChapterInfo then
		taskChapterInfo = {}
	end
	
	if not taskChapterInfo[taskType] then
		taskChapterInfo[taskType] = {}
	end

	if taskChapterInfo[taskType][taskChildType] then
		return taskChapterInfo[taskType][taskChildType]
	end

	for i, v in pairs(DataTaskReward.Find) do
		if v.type == taskType and v.sec_type == taskChildType then
			taskChapterInfo[taskType][taskChildType] = v

			return taskChapterInfo[taskType][taskChildType]
		end
	end

	return
end

--根据任务id获取章节奖励信息
function TaskConfig.GetTaskChapterInfoByTaskId(taskId)
	
	local mType, sType = mod.TaskCtrl:GetTaskType(taskId)
	if not mType or not sType then
		return
	end
    local chapterInfo = TaskConfig.GetTaskChapterInfo(mType, sType)

	return chapterInfo
end

--根据任务id获取任务信息
function TaskConfig.GetTaskCfgByTaskId(taskId, stepId)
	local key = UtilsBase.GetStringKeys(taskId, stepId)
	return DataTask.data_task[key]
end

function TaskConfig.GetTaskPointProgress(taskRewardInfo)
	local num = 0
	local startTask = taskRewardInfo.chapter_start
	local endTask = taskRewardInfo.chapter_end
	for i, v in ipairs(taskRewardInfo.task_reward) do
		local isFinished = mod.TaskCtrl:CheckTaskIsFinish(v[1])
		if isFinished then
			num = num + 1
			startTask = v[1]
		else
			endTask = v[1]
			break
		end
	end
	
	return num, startTask, endTask
end

function TaskConfig.CheckTaskIsReceived(taskId)
	return mod.TaskCtrl:CheckTaskIsReceived(taskId)
end

function TaskConfig.GetTaskTypeInfo(taskType, taskChildType)
	if taskChildType == 0 then
		return
	end
	for k, v in pairs(DataTaskType.Find) do
		if taskType == v.type and taskChildType == v.sec_type then
			return DataTaskType.Find[k]
		end
	end
end

function TaskConfig.GetChildTypeInfo(taskType, taskChildType)
	local taskTypeInfo = TaskConfig.GetTaskTypeInfo(taskType, taskChildType)
	return taskTypeInfo
end

function TaskConfig.GetChildTypeName(taskType, taskChildType)
	local taskTypeInfo = TaskConfig.GetTaskTypeInfo(taskType, taskChildType)
	return taskTypeInfo and taskTypeInfo.sec_type_name or ""
end

function TaskConfig.GetChildTypeSubhead(taskType, taskChildType)
	local taskTypeInfo = TaskConfig.GetTaskTypeInfo(taskType, taskChildType)
	return taskTypeInfo and taskTypeInfo.sec_type_subhead or ""
end

function TaskConfig.GetChildTypeCount(taskType, taskChildType)
	local taskTypeInfo = TaskConfig.GetTaskTypeInfo(taskType, taskChildType)
	return taskTypeInfo and taskTypeInfo.sec_type_count or 0
end

local secTypeRewardList = {}
function TaskConfig.GetSecTypeRewardList(secType)
	if secTypeRewardList[secType] then
		return secTypeRewardList[secType]
	end

	local list = {}
	for k, v in ipairs(DataTaskStage) do
		if v.sec_type == secType then
			table.insert(list, v)
		end
	end

	secTypeRewardList[secType] = list

	return list
end

--返回任务的可进行时段
local _ActionableTimeCache = {}
function TaskConfig.GetTaskActionableTimeArea(taskId, stepId)
	if _ActionableTimeCache[taskId] and _ActionableTimeCache[taskId][stepId] then
		return _ActionableTimeCache[taskId][stepId]
	end
	local config = TaskConfig.GetTaskCfgByTaskId(taskId, stepId)
	local timeArea = {}
	if config and config.task_time and next(config.task_time) then
		for k, v in pairs(config.task_time) do
			local key = "DayNightTime_" .. v
            local cv = SystemConfig.GetCommonValue(key)
            local startTime = cv.int_val
            local endTime = cv.int_val2
            if startTime > endTime then
                table.insert(timeArea,  {startTime = startTime, endTime = 24 * 60 - 1})
                table.insert(timeArea,  {startTime = 0, endTime = endTime})
            else
                table.insert(timeArea,  {startTime = startTime, endTime = endTime})
            end
		end
		_ActionableTimeCache[taskId] = _ActionableTimeCache[taskId] or {}
		_ActionableTimeCache[taskId][stepId] = timeArea
		--LogTable("task_timeArea"..taskId, timeArea)
	end
	return timeArea
end