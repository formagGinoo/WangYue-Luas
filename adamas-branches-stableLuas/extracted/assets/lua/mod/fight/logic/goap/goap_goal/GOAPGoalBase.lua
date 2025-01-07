GOAPGoalBase = BaseClass("GOAPGoalBase", PoolBaseClass)

function GOAPGoalBase:__init()

end
function GOAPGoalBase:Init(config)
	self.changeAttr = config.change_attr
	self.goalPlusOrMinus = config.plus_or_minus
	self.effectAction = {}
	for i, v in ipairs(config.effect_action) do
		if v ~= "" then
			table.insert(self.effectAction, v)
		end
	end
end

--获取目标倾向
function GOAPGoalBase:GetGoalTendency(planner)
	return 0
end

function GOAPGoalBase:__delete()

end
