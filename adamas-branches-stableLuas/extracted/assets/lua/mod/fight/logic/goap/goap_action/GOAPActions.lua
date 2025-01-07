GOAPActions = BaseClass("GOAPActions",PoolBaseClass)

function GOAPActions:__init(fight,goapManager)
	self.fight = fight
	self.goapManager = goapManager
	self.actions = {}

	for k, v in pairs(GOAPConfig.DataGoapAction) do
		local className = "Action"..k
		local class = _G[className]
		if not class then
			LogError("找不到GOAP Action "..k)
		else
			local action = class.New()
			self.actions[k] = action
			action:Init(v)
		end
	end
	-- 分类型的目标类型的action列表
	self.typeActions = GOAPConfig.GetGoapGoalEffectAction(self.actions)
end

function GOAPActions:GetActionPosition(actionName,planner)
	return self.actions[actionName]:GetPosition(planner)
end

function GOAPActions:GetAction(actionName)
	return self.actions[actionName]
end

function GOAPActions:StartDoAction(actionName,planner)
	self.actions[actionName]:StartDoAction(planner)
end

function GOAPActions:DoAction(actionName,planner)
	self.actions[actionName]:DoAction(planner)
end

function GOAPActions:GetTargetTendency(actionName,planner)
	return self.actions[actionName]:GetTargetTendency(planner)
end

function GOAPActions:GetCost(actionName,planner)
	return self.actions[actionName]:GetCost(planner)
end

function GOAPActions:FinishAction(actionName, planner)
	self.actions[actionName]:FinishAction(planner)
end

function GOAPActions:GetFrontActions(actionName,planner)
	return self.actions[actionName]:GetFrontActions(planner)
end
function GOAPActions:CheckPrecondition(actionName,planner)
	return self.actions[actionName]:CheckPrecondition(planner)
end

function GOAPActions:__delete()

end
