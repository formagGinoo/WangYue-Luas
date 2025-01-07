DebugConfig = DebugConfig or {}

DebugConfig.Tag = {
	Plan = 1,
	Test = 2,
	Client = 3,
}

local DataPlan = Config.DataDebugPlan.Find
local DataTest = Config.DataDebugTest.Find
local DataClient = Config.DataDebugClient.Find

function DebugConfig.GetDataConfigByTag(tag)
	if tag == DebugConfig.Tag.Plan then
		return DataPlan
	elseif tag == DebugConfig.Tag.Test then
		return DataTest
	elseif tag == DebugConfig.Tag.Client then
		return DataClient
	end
end

function DebugConfig.GetDataConfig(tag, id)
	local config = DebugConfig.GetDataConfigByTag(tag)
	if not config then
		return 
	end
	
	return config[id]
end

function DebugConfig.GetInvokeClass(tag, func)
	if tag == DebugConfig.Tag.Plan then
		return DebugPlanInvoke[func]
	elseif tag == DebugConfig.Tag.Test then
		return DebugTestInvoke[func]
	elseif tag == DebugConfig.Tag.Client then
		return DebugClientInvoke[func]
	end
end

function DebugConfig.CallFunc(tag, func, param1, param2, param3)
	local callFunc = DebugConfig.GetInvokeClass(tag, func)
	if callFunc then
		return callFunc(param1, param2, param3)
	else
		LogError("未找到方法:"..func)
	end
end