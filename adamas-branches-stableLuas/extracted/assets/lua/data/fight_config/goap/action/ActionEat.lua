ActionEat = BaseClass("ActionEat",GOAPActionBase)

function ActionEat:__init()
	
end

function ActionEat:DoAction(planner)
	local entity = planner.entity
	local instanceId = planner.entity.instanceId
	local isIn = false
	if not isIn then
		isIn = true
		BehaviorFunctions.PlayAnimation(instanceId, "PhoneStand_loop", FightEnum.AnimationLayer.PerformLayer)
	end
end

function ActionEat:GetCost()
	return 2.5
end

function ActionEat:__delete()

end
