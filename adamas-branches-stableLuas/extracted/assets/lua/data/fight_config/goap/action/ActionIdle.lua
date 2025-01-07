ActionIdle = BaseClass("ActionIdle",GOAPActionBase)

function ActionIdle:__init()
	
end

function ActionIdle:DoAction(planner)
	local entity = planner.entity
	local instanceId = planner.entity.instanceId
	local isIn = false
	if not isIn then
		isIn = true
		BehaviorFunctions.PlayAnimation(instanceId, "Beishou_loop", FightEnum.AnimationLayer.PerformLayer)
	end
end

function ActionIdle:GetCost()
	return 999
end

function ActionIdle:GetPosition()
	return {x = 110.53, y = 6.8, z = 94.29589}
end

function ActionIdle:__delete()

end
