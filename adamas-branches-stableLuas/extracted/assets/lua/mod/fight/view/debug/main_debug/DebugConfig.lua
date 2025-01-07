DebugConfig = DebugConfig or {}

DebugConfig.UseRenderFrame = false
DebugConfig.NpcAiLOD  = true
DebugConfig.ShowDamageLog = false
DebugConfig.StopMonsterLogic = false
DebugConfig.ShowSkillPointChangeByDamage = false
DebugConfig.ShowStoryLog = false
DebugConfig.ShowCheckEntityCollide = false
DebugConfig.SkipQueryEntry = true
DebugConfig.ShowLevelLogic = true
DebugConfig.MapToolOpen = false

DebugResList = {}


DebugConfig.Tag = {
	Plan = 1,
	Test = 2,
	Client = 3,
}

local DataPlan = Config.DataDebugPlan.Find
local DataTest = TestDebugConfig.Find
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
		if DebugPlanInvoke[func] then
			return DebugPlanInvoke[func]
		elseif DebugClientInvoke[func] then
			return DebugClientInvoke[func]
		elseif DebugTestInvoke[func] then
			return DebugTestInvoke[func]
		end
	elseif tag == DebugConfig.Tag.Test then
		if DebugTestInvoke[func] then
			return DebugTestInvoke[func]
		elseif DebugClientInvoke[func] then
			return DebugClientInvoke[func]
		elseif DebugPlanInvoke[func] then
			return DebugPlanInvoke[func]
		end
	elseif tag == DebugConfig.Tag.Client then
		if DebugClientInvoke[func] then
			return DebugClientInvoke[func]
		elseif DebugPlanInvoke[func] then
			return DebugPlanInvoke[func]
		elseif DebugTestInvoke[func] then
			return DebugTestInvoke[func]
		end
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

function DebugConfig.GetEntityAssets(fileId)
	DebugResStackDict = {}
	local help = FightResuorcesLoadHelpTools.New()
	DebugEntityFileName = tostring(fileId)
	FightResuorcesLoadHelpTools.PreloadEntityFile(fileId)
	DebugEntityFileResDict = {}
	DebugResStack = DebugResStackDict
end
