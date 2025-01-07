ActionWork = BaseClass("ActionWork",GOAPActionBase)

function ActionWork:__init()
	
end

function ActionWork:DoAction(planner)
	local entity = planner.entity
	local instanceId = planner.entity.instanceId
	local isIn = false
	if not isIn then
		isIn = true
		BehaviorFunctions.PlayAnimation(instanceId, "Tanshou_loop", FightEnum.AnimationLayer.PerformLayer)
	end
end

function ActionWork:GetCost()
	return 1
end

function ActionWork:GetPosition(planner)
	return {x = 100.53, y = 6.8, z = 94.29589}
end

function ActionWork:__delete()

end
