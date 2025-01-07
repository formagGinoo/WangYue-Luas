---@class LevelDependenciesNode
TaskDependenciesNode = BaseClass("TaskDependenciesNode",DependenciesNodeBase)

function TaskDependenciesNode:__init(nodeManager,totalAssetPool)
	self.nodeManager = nodeManager
	self.totalAssetPool = totalAssetPool
end

function TaskDependenciesNode:Init()

end

function TaskDependenciesNode:Analyse(key)
	self.name = "Task_"..key
	local resLoadHelp = FightResuorcesLoadHelp.New()
	
	local taskInfo = mod.TaskCtrl:GetTask(key)
	if not taskInfo then
		return
	end
	-- local taskConfig = taskInfo.taskConfig
	local taskConfig = mod.TaskCtrl:GetTaskConfig(taskInfo.taskId, taskInfo.stepId)
	if not taskConfig then
		return
	end

	if mod.TaskCtrl:CheckTaskTypeChange(key) then
		local secType,type = mod.TaskCtrl:GetTaskType(key)
		local typeConfig = mod.TaskCtrl:GetDataTaskType(secType,type)
		if typeConfig then
			local typeLogics = typeConfig.task_type_logic
			if not typeLogics then
				return
			end
			if #typeLogics>0 then
				for k, path in pairs(typeLogics) do
					local logicPrefab = "Prefabs/Scene/"..path
		            resLoadHelp:AddRes({path = logicPrefab, type = AssetType.Prefab})
				end
			end
		end
	end

	local behavior = taskConfig.behavior
	if not behavior or behavior == "" then
		self.resList = resLoadHelp.resList
		return
	end

	behavior = _G[behavior]
	
	if behavior.GetMagics then
		local magics = behavior.GetMagics()
		for i = 1, #magics do
			resLoadHelp:PreloadMagicAndBuffs(magics[i], nil, FightEnum.MagicConfigFormType.Level)
		end
	end

	if behavior.GetGenerates then
		local generates = behavior.GetGenerates()
		for i = 1, #generates do
			resLoadHelp:PreloadEntity(generates[i], false, true)
		end
	end

	self.resList = resLoadHelp.resList
end

function TaskDependenciesNode:OnCache()
	self.fight.objectPool:Cache(TaskDependenciesNode,self)
end

function TaskDependenciesNode:__delete()

end