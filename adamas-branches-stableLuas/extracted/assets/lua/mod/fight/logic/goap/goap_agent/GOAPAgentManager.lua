GOAPAgentManager = BaseClass("GOAPAgentManager",PoolBaseClass)

function GOAPAgentManager:__init(fight,goapManager)
	self.fight = fight
	self.goapManager = goapManager
	self.agents = {}
end

function GOAPAgentManager:Update()
	for k, v in pairs(self.agents) do
		v:Update()
	end
end

function GOAPAgentManager:AddAgent(planner)
	local agent = self.fight.objectPool:Get(GOAPAgent)
	self.agents[planner.entity.instanceId] = agent
	agent:Init(planner,self.goapManager.actions)
	return agent
end

function GOAPAgentManager:RemoveAgent(planner)
	local agent = self.planers[planner.entity.instanceId]
	self.fight.objectPool:Cache(GOAPAgent,agent)
	self.agents[planner.entity.instanceId] = nil
end

function GOAPAgentManager:__delete()

end
