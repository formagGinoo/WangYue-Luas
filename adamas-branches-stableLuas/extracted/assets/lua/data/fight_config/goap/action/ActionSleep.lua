ActionSleep = BaseClass("ActionSleep",GOAPActionBase)

function ActionSleep:__init()
	
end

function ActionSleep:DoAction(planner)
	local entity = planner.entity
	local instanceId = planner.entity.instanceId
	local isIn = false
	if not isIn then
		isIn = true
		BehaviorFunctions.PlayAnimation(instanceId, "Dunxia_loop", FightEnum.AnimationLayer.PerformLayer)
	end
end

function ActionSleep:GetCost()
	return 2
end

function ActionSleep:GetPosition()
	return {x = 105.53, y = 6.8, z = 94.29589}
end

function ActionSleep:__delete()

end
