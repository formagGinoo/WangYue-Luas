
TaskConfig = TaskConfig or {}

local DataTask = Config.DataTask
local DataTaskStage = Config.DataTask.data_task_stage

local taskMainType = nil

TaskConfig.TaskType = {
    Main = 1,
    Branch = 2,
	Delegate = 3,
	World = 4
}

TaskConfig.BehaviorFun =
{
	["Death"] = 0,
	["WorldInteractClick"] = 0,
	["EnterTrigger"] = 0,
	["ExitTrigger"] = 0,
	["EntityHitEnd"] = 0,
	["CastSkill"] = 0,
	["Dodge"] = 0,
	["AddEntitySign"] = 0,
	["RemoveEntitySign"] = 0,
	["AddSkillSign"] = 0,
	["StoryEndEvent"] = 0,
	["StoryStartEvent"] = 0,
	["StorySelectEvent"] = 0,
	["StoryPassEvent"] = 0,
	["OnGuideImageTips"] = 0,
	["ClearSkill"] = 0,
	["PathFindingEnd"] = 0,
	["BackGroundEnd"] = 0,
	["CatchPartnerEnd"] = 0,
}

function TaskConfig.GetAllTaskMainType()
	if taskMainType then
		return taskMainType
	end

	taskMainType = {}
	for k, v in pairs(DataTask.data_task_type) do
		if taskMainType[v.type] then
			goto continue
		end

		taskMainType[v.type] = v.type_name

		::continue::
	end

	return taskMainType
end

function TaskConfig.GetTaskTypeInfo(taskType, taskChildType)
	if taskChildType == 0 then
		return
	end

	local index = taskType.."_"..taskChildType
	return DataTask.data_task_type[index]
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