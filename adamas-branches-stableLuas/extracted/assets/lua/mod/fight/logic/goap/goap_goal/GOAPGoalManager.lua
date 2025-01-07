GOAPGoalManager = BaseClass("GOAPGoalManager", PoolBaseClass)

function GOAPGoalManager:__init()
	self.goals = {}
	self:InitGoals()
end

function GOAPGoalManager:InitGoals()
	for k, v in pairs(GOAPConfig.DataGoal) do
		local goalClassName = "Goal"..k
		local class = _G[goalClassName]
		if not class then
			LogError("找不到GOAP Goal "..k)
		end
		self.goals[k] = class.New()
		class:Init(v)
	end
end

function GOAPGoalManager:GetGoalTendency(goalKey,planner)
	return self.goals[goalKey]:GetGoalTendency(planner)
end

function GOAPGoalManager:__delete()

end
