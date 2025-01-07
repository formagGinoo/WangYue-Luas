GOAPPlanner = BaseClass("GOAPPlanner",PoolBaseClass)
--[[
计划者，寻找目标和计算达到目标的最优路径选择
--]]
local _table = table
function GOAPPlanner:__init()
	self.dynamicAttrs = {}
	self.staticAttrs = {}
	self.actions = {}
	self.goals = {}
	self.plannerPaths = {}
	self.target = 0
	self.queue = FixedQueue.New()
	self.actionPathNode = nil
	self.defaultAction = "Idle"
	self.curAction = self.defaultAction
	self.updateGoalFrame = Application.targetFrameRate * 5
end

function GOAPPlanner:Init(entity,goapManager)
	self.config = Config["Planner"..entity.entityId]
	if not self.config then
		LogError("找不到配置Planner配置！"..entity.entityId)
		return
	end
	self.goapManager = goapManager
	self.fight = goapManager.fight
	self.goapActions = self.goapManager.actions
	self.goalManager = self.goapManager.goalManager
	self.globalAttrs = self.goapManager.globalAttrs
	self.entity = entity
	self.agent = self.goapManager.agentManager:AddAgent(self)
	self:InitAttr()
	self:InitAction()
	self:InitGoal()
	self:PlanningGoal()
end

function GOAPPlanner:InitAttr()
	if not self.config.PlannerAttrs then
		LogError("GOAP G了"..self.entity.instanceId.." ".. self.entity.entityId.."编辑器中没有配任何一个动态属性，回去看看吧")
		return
	end
	for k, v in pairs(self.config.PlannerAttrs) do
		self.staticAttrs[k] = v.Value
	end
	self.dynamicAttrs = GOAPConfig.GetGoapDynamicAattrRamdom()
end

function GOAPPlanner:InitAction()
	if not self.config.PlannerGoals then
		LogError("GOAP G了"..self.entity.instanceId.." ".. self.entity.entityId.."编辑器中没有配任何一个行为，回去看看吧")
		return
	end
	for k, v in pairs(self.config.PlannerActions) do
		self.actions[k] = v.Key
	end
end

function GOAPPlanner:InitGoal()
	if not self.config.PlannerGoals then
		LogError("GOAP G了"..self.entity.instanceId.." ".. self.entity.entityId.."编辑器中没有配任何一个目标，回去看看吧")
		return
	end
	for k, v in pairs(self.config.PlannerGoals) do
		self.goals[k] = v.Key
	end
end

function GOAPPlanner:Update()
	self.remainUpdateGoalFrame = self.remainUpdateGoalFrame - 1
	if self.remainUpdateGoalFrame == 0 then
		self:PlanningGoal()
	end
end

--规划目标
function GOAPPlanner:PlanningGoal()
	self.remainUpdateGoalFrame = self.updateGoalFrame
	local maxTendency = 0
	local goal = 0
	for k, v in pairs(self.goals) do
		local tendency = self.goalManager:GetGoalTendency(k,self) or 0
		LogError("GOAP倾向值: "..self.entity.instanceId.." ".. self.entity.entityId.." " .. k ..":" .. tendency)
		if tendency > maxTendency then
			maxTendency = tendency
			goal = k
		end
	end
	if goal == 0 then
		LogError("GOAP G了 "..self.entity.instanceId.." ".. self.entity.entityId.."所有的目标的倾向都是0，找不到目标了")
		return
	end
	LogError("curState "..self.curAction..",Goal = "..goal)
	for k, v in pairs(GOAPConfig.DataGoapDynamicAttr) do
		print("curattr:" ..k.. self.dynamicAttrs[k])
	end
	self:SetGoal(goal)
end

function GOAPPlanner:SetGoal(goal)
	if goal == self.goal then
		LogError("GOAP".. self.entity.instanceId.." ".. self.entity.entityId .."当前目标和目标目标相同")
	end
	self.goal = goal
	self.goalChangeAttr = self.goalManager.goals[self.goal].changeAttr
	self.goalPlusOrMinus = self.goalManager.goals[self.goal].goalPlusOrMinus
	self:ClearPathNode()
	self.pathFinding = self.pathFinding or self.fight.objectPool:Get(GOAPPathFinding)
	self.pathFinding:PathFinding(self)
	self.plannerPaths = self.pathFinding.plannerPaths
	self:OptimizationPath()
end

--构造临接表
function GOAPPlanner:CreateGraph(changeAttr, graph, start)
	graph = graph or {}
	for name, action in pairs(self.goapActions.actions) do
		if self.actions[name]
		and self.actions[start]
		and action.effectAttr == changeAttr 
		and name ~= start 
		and self.goapActions:GetAction(start).effectAttr == changeAttr then
			local visited = false
			for i, value in ipairs(graph[start]) do
				if value == name then
					visited = true
				end
			end
			if not visited and GOAPConfig.RelationTrans(action.relation, self.dynamicAttrs[action.preAttr], action.preAttrValue) then
				table.insert(graph[start], name)
				self:CreateGraph(action.preAttr, graph, name)
			end
		end
	end
end

--获得所有路径
function GOAPPlanner:GetAllPath(graph, start, path, visited, totalCost, costs, actions)
	graph = graph or {}
	path = path or {}
    visited = visited or {}
    totalCost = totalCost or 0
	costs = costs or {}
	actions = actions or {}

	table.insert(path, start)
	table.insert(actions, self.goapActions:GetAction(start))
    if graph[start] and #graph[start] > 0 then
		-- 递归地寻找从相邻节点到终止节点的路径
		visited[start] = true
		for _, node in ipairs(graph[start]) do
			local cost = self.goapActions:GetCost(node,self)
			if not visited[node] then
				table.insert(costs, cost)
				self:GetAllPath(graph, node, path, visited, totalCost + cost, costs, actions)
			end
		end
    end
	if #path > 1 and path[1] ~= start then
		table.insert(self.plannerPaths, {
			path = TableUtils.CopyTable(path), 
			totalCost = totalCost, 
			costs = TableUtils.CopyTable(costs),
			actions = TableUtils.CopyTable(actions)
		})
	end
	-- LogError("路径: ", table.concat(path, " -> "), "消耗: ", totalCost)
	table.remove(path)
	table.remove(actions)
	table.remove(costs)
    visited[start] = nil
end

function GOAPPlanner:PlanningPath()
	self.actionPathNode = self.fight.objectPool:Get(GOAPActionPathNode)

	self.actionPathNode:Init(self, "Root", nil)
	-- self:PlanningPathNode(self.actionPathNode)
end
  
function GOAPPlanner:PlanningPathNode1(actionPathNode)
	local action = actionPathNode.action
	local actions = self.goapActions:GetFrontActions(action,self)
	for k, node in pairs(actions) do
		local cost = self.goapActions:GetCost(node,self)
		local actionPathNodeTemp = self.fight.objectPool:Get(GOAPActionPathNode)
		actionPathNodeTemp:Init(node,cost,actionPathNode)
		actionPathNode:AddChildNode(actionPathNodeTemp)
		if actionPathNodeTemp.action == self.curAction then
			self:AddPath(actionPathNodeTemp)
			return
		end
		if self.goapActions:CheckPrecondition(node,self) then
			self:PlanningPathNode(actionPathNodeTemp)
		end
	end
end

function GOAPPlanner:CheckCanPush(action,actionPathNode)
	if self.actions[action] then
		
	else
		return false
	end
	local Node = actionPathNode
	while Node do
		Node = Node.parentNode
		if Node and Node.action == action then
			return false
		end
	end
	return  
end

--穷举所有路径
function GOAPPlanner:AddPath(Node)
	local path = {}
	local actionPathNode = Node
	local cost = actionPathNode.cost
	path.totalCost = 0
	path.actions = {}
	path.costs = {}
	while actionPathNode do
		cost = actionPathNode.cost
		path.totalCost = path.totalCost + cost
		_table.insert(path.actions,actionPathNode.action)
		_table.insert(path.costs,cost)
		actionPathNode = actionPathNode.parentNode
	end
	_table.insert(self.plannerPaths,path)
end

function GOAPPlanner:OptimizationPath()
	-- Log("OptimizationPath")
	local minCost = math.maxinteger
	local optimalPathNode = nil
	for k, v in pairs(self.plannerPaths) do
		local totalCost = v:GetTotalCost()
		if totalCost < minCost then
			minCost = totalCost
			optimalPathNode = v
		end
	end
	if not optimalPathNode then
		LogError("GOAP G了 "..self.entity.instanceId.." ".. self.entity.entityId.."没有最优路径")
		return
	end
	if #optimalPathNode:GetActionPath() == 1 then
		return
	end
	self.agent:SetActions(optimalPathNode:GetActionPath(), optimalPathNode)
end

function GOAPPlanner:PrintPath(path)
	if not path then
		return
	end
	local info = "路径总消耗："..path.totalCost.." "
	for i, v in ipairs(path.path) do
		if path.costs[i] then
			info = info .."("..path.costs[i]..") -> "
		end
	end
	Log(info)
end

function GOAPPlanner:ClearPathNode()
	if not self.pathFinding then
		return
	end
	self.fight.objectPool:Cache(GOAPPathFinding, self.pathFinding)
	TableUtils.ClearTable(self.plannerPaths)
end

function GOAPPlanner:__delete()

end