GOAPActionPathNode = BaseClass("GOAPActionPathNode", PoolBaseClass)
--[[

--]]
local _table = table
function GOAPActionPathNode:__init()
	self.fight = Fight.Instance
    self.action = 0
    self.cost = 0
	self.totalCost = 0
    self.parentNode = nil
    self.childNodes = {}
	self.targetNode = "Root"
end

-- 构建反向树
function GOAPActionPathNode:Init(planner, actionName, parentNode)
    self.planner = planner
    self.actionName = actionName
    self.parentNode = parentNode
    self.action = planner.goapActions:GetAction(self.actionName)
	if self.action then
		local effectAttr, effectAttrValue = self.action:GetEffect()
		self.virtualEffectAttr = effectAttr ~= "" and effectAttr or nil
		self.virtualEffectAttrValue = effectAttrValue or 0
	end
	self.cost = actionName ~= self.targetNode and planner.goapActions:GetCost(actionName, self.planner) or 0 

	if self.planner.curAction == actionName then
		local str = string.format("路径：%s", self.actionName)
		local totalCost = self.cost
		local parentNode = self.parentNode
		local nowNode = self
		local virtualAttr = {}
		while parentNode do
			str = string.format("%s->%s", str, parentNode.actionName)
			if parentNode.actionName ~= self.targetNode then
				totalCost = totalCost + parentNode.cost
				for k, attr in pairs(parentNode.action.preAttr) do
					local tempVirtualValue = 0
					if attr.attrName ~= "" then
						tempVirtualValue = parentNode.planner.dynamicAttrs[attr.attrName] or 0 + virtualAttr[attr.attrName] or 0
						local preAttrSuccess = GOAPConfig.RelationTrans(attr.ralation, tempVirtualValue, attr.attrValue)
						if not preAttrSuccess then
							LogError(string.format("GOAP路径由于%s==%s,%s%s没满足 %s走不通咯!", attr.attrName, tempVirtualValue, attr.ralation, attr.attrValue, str))
							return
						end
					end
				end
				if parentNode.virtualEffectAttr then
					virtualAttr[parentNode.virtualEffectAttr] = virtualAttr[parentNode.virtualEffectAttr] or 0 + parentNode.virtualEffectAttrValue 
				end
			end
			parentNode = parentNode.parentNode
			nowNode = nowNode.parentNode
		end
		LogError(str, totalCost)
		_table.insert(self.planner.pathFinding.plannerPaths, self)
		return
	end
    if self.actionName == self.targetNode then
        for i, action in ipairs(self.planner.pathFinding.actions) do
            if action.effectAttr == self.planner.goalChangeAttr and self:CheckNodeAttrPlusOrMinusState(action.effectAttrValue)then
				local childNode = self.fight.objectPool:Get(GOAPActionPathNode)
				self:AddChild(childNode)
				childNode:Init(self.planner, action.key, self)
			end
        end
    else
		local actions = self.planner.goapActions.typeActions[self.planner.goal]
		if not actions then return end
		actions[self.planner.curAction] = self.planner.goapActions.actions[self.planner.curAction]
		for name, action in pairs(actions) do
			if self:CheckNodeCanPush(action.key) then
				local childNode = self.fight.objectPool:Get(GOAPActionPathNode)
				self:AddChild(childNode)
				childNode:Init(self.planner, action.key, self)
			end
		end
    end
end


function GOAPActionPathNode:CheckNodeAttrPlusOrMinusState(value)
	if not self.planner then
		return false	
	end
	local state = value >= 0 and true or false
	return state == self.planner.goalPlusOrMinus
end

function GOAPActionPathNode:CheckNodeCanPush(actionName)
	if actionName == self.actionName then
		return false
	end
    if not self.parentNode then
        return true
    end
    local Node = self.parentNode
    while Node do
        if Node and Node.actionName == actionName then
            return false
        end
		Node = Node.parentNode
    end
	return true
end

function GOAPActionPathNode:GetTotalCost()
	local totalCost = self.cost or 0
	local Node = self.parentNode
	while Node do
		if self.actionName ~= self.targetNode then
			totalCost = totalCost + Node.cost
		end
		Node = Node.parentNode
	end
	return totalCost
end


function GOAPActionPathNode:AddChild(childNode)
    _table.insert(self.childNodes, childNode)
end

function GOAPActionPathNode:GetActionPath()
	local path = {}
	if self.action ~= self.targetNode then
		_table.insert(path, self.actionName)
	end
	local Node = self.parentNode
	while Node and Node.actionName ~= self.targetNode do
		_table.insert(path, Node.actionName)
		Node = Node.parentNode
	end
	return path
end

function GOAPActionPathNode:__cache()
    for k, v in pairs(self.childNodes) do
        Fight.Instance.objectPool:Cache(GOAPActionPathNode, v)
    end
    TableUtils.ClearTable(self.childNodes)
	self.action = nil
    self.parentNode = nil
	self.actionName = nil
    self.cost = 0
	self.totalCost = 0
	self.planner = nil
    self.actionName = nil
end

function GOAPActionPathNode:__delete()

end
