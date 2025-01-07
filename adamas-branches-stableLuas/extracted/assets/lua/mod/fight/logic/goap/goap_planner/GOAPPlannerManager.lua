GOAPPlannerManager = BaseClass("GOAPPlannerManager",PoolBaseClass)

function GOAPPlannerManager:__init(fight,goapManager)
	self.fight = fight
	self.goapManager = goapManager
	self.planners = {}
end

function GOAPPlannerManager:Update()
	for k, v in pairs(self.planners) do
		v:Update()
	end
end

function GOAPPlannerManager:AddPlanner(entity)
	local planner = self.fight.objectPool:Get(GOAPPlanner)
	self.planners[entity.instanceId] = planner
	planner:Init(entity,self.goapManager)
end

function GOAPPlannerManager:GetPlanner(instanceId)
	return self.planners[instanceId]
end

function GOAPPlannerManager:RemovePlanner(entity)
	local planner = self.planners[entity.instanceId]
	self.fight.objectPool:Cache(GOAPPlanner,planner)
	self.planners[entity.instanceId] = nil
end

function GOAPPlannerManager:__delete()

end
