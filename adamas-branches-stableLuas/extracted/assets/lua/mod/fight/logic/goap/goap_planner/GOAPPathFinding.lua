GOAPPathFinding = BaseClass("GOAPPathFinding", PoolBaseClass)

function GOAPPathFinding:__init()
	self.fight = Fight.Instance
	self.plannerPaths = {}
	self.defaultNode = "Root"
	self.actions = {}
end

function GOAPPathFinding:PathFinding(planner)
	for _, action in pairs(planner.goapActions.actions) do
		table.insert(self.actions, action)
	end
	self.actionPathNode = self.fight.objectPool:Get(GOAPActionPathNode)
	self.actionPathNode:Init(planner, self.defaultNode, nil)
end

function GOAPPathFinding:__cache()
	self.fight.objectPool:Cache(GOAPActionPathNode, self.actionPathNode)
	TableUtils.ClearTable(self.plannerPaths)
	TableUtils.ClearTable(self.actions)
end

function GOAPPathFinding:__delete()

end
