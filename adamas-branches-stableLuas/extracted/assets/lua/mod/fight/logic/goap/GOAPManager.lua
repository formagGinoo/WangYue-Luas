GOAPManager = BaseClass("GOAPManager",PoolBaseClass)
--[[
GOAP - 目标导向型AI
本质提炼：
1，穷举能达到目录的路径，找最优解
2，自身或者世界状态的改变会影响目标和行为路径
3，每个节点的计划或者执行都需要满足所有的前置条件
4，每个行为都会影响自身或者世界，自身的属性有些是长期的
5，把所以条件都转化成数值
--]]


function GOAPManager:__init(fight)
	self.fight = fight
	self.plannerManager = GOAPPlannerManager.New(self.fight,self)
	self.agentManager = GOAPAgentManager.New(self.fight,self)
	self.globalAttrs = GOAPGlobalAttrs.New(self.fight,self)
	self.goalManager = GOAPGoalManager.New(self.fight,self)
	self.actions = GOAPActions.New(self.fight,self)
end
 
function GOAPManager:Update()
	self.agentManager:Update()
	self.plannerManager:Update()
end

function GOAPManager:AddPlanner(entity)
	self.plannerManager:AddPlanner(entity)
end

function GOAPManager:GetPlanner(entity)
	return self.plannerManager:GetPlanner(entity)
end

function GOAPManager:RemovePlanner(entity)
	self.plannerManager:RemovePlanner(entity)
end

function GOAPManager:__delete()

end
