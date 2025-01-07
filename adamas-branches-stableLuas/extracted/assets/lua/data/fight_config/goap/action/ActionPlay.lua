ActionPlay = BaseClass("ActionPlay",GOAPActionBase)

function ActionPlay:__init()
	
end

function ActionPlay:DoAction(planner)
	local entity = planner.entity
	local instanceId = planner.entity.instanceId
	local isIn = false
	if not isIn then
		isIn = true
		BehaviorFunctions.PlayAnimation(instanceId, "Chayao_loop", FightEnum.AnimationLayer.PerformLayer)
	end
end

function ActionPlay:GetCost()
	return 3
end

function ActionPlay:GetPosition()
	return {x = 115.53, y = 6.8, z = 94.29589}
end

function ActionPlay:__delete()

end
