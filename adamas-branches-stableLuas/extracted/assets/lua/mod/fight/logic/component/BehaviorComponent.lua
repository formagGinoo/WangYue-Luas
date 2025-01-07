---@class BehaviorComponent
BehaviorComponent = BaseClass("BehaviorComponent",PoolBaseClass)
local _tinsert = table.insert
local _tremove = table.remove
local DebugConfig = DebugConfig
local EntityNpcTag = FightEnum.EntityNpcTag
local TableUtils = TableUtils

function BehaviorComponent:__init()
	self.values = {}
	self.behaviors = {}
	self.removeQueue = {}
	self.behaviorInstances = {}
	self.addQueue = FixedQueue.New()
end

function BehaviorComponent:Init(fight, entity)
	self.fight = fight
	self.entity = entity
	
	self.maxBehaviorNum = 100
	
	self.behaviorInstancesId = 0

	local behaviorConfigs = entity:GetComponentConfig(FightEnum.ComponentType.Behavior)
	if behaviorConfigs.Behaviors then
		for k, v in pairs(behaviorConfigs.Behaviors) do
			self:AddBehavior(v)
		end
	end
end

function BehaviorComponent:LateInit()
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior and behavior.LateInit then
			behavior:LateInit()
		end
	end

	while self.addQueue:GetTop() do
		local behaviorInstancesId = self.addQueue:Pop()
		local behavior = self.behaviors[behaviorInstancesId]
		if behavior then
			_tinsert(self.behaviorInstances, behaviorInstancesId)
			if behavior.LateInit then
				behavior:LateInit()
			end
		end
	end
end

function BehaviorComponent:AddBehavior(behaviorName, Prefix, params, parentBehavior)
	if #self.behaviorInstances >= self.maxBehaviorNum then
		LogError("行为树总数超过上限")
		return
	end

	Prefix = Prefix or "Behavior"
	local class = Prefix..behaviorName
	local behavior = Fight.Instance.entityManager:CreateBehavior(class, parentBehavior, self.entity.instanceId, self.entity.sInstanceId, params)
	if behavior then
		self.behaviorInstancesId = self.behaviorInstancesId + 1
		behavior.behaviorInstancesId = self.behaviorInstancesId

		self.behaviors[behavior.behaviorInstancesId] = behavior
		self.addQueue:Push(self.behaviorInstancesId)
	end

	return behavior
end

function BehaviorComponent:BeforeUpdate()
	if not self:NeedUpdate() then
		return
	end
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			behavior:BeforeUpdate()
		end
	end
end

function BehaviorComponent:Update()
	if not self:NeedUpdate() then
		return
	end
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			behavior:Update()
		else
			_tinsert(self.removeQueue, i)
		end
	end

	while self.addQueue:GetTop() do
		local behaviorInstancesId = self.addQueue:Pop()
		local behavior = self.behaviors[behaviorInstancesId]
		if behavior then
			_tinsert(self.behaviorInstances, behaviorInstancesId)
			if behavior.LateInit then
				behavior:LateInit()
			end

			behavior:Update()
		end
	end
	if next(self.removeQueue) then
		for i = #self.removeQueue, 1, -1 do
			_tremove(self.behaviorInstances, self.removeQueue[i])
		end

		TableUtils.ClearTable(self.removeQueue)
	end
end

function BehaviorComponent:AfterUpdate()
	if not self:NeedUpdate() then
		return
	end
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			behavior:AfterUpdate()
		end
	end
end

function BehaviorComponent:CallFunc(funName, ...)
	local addQueueLength = self.addQueue:Length()
	if addQueueLength > 0 then
		for i = 1 , addQueueLength do
			local behaviorInstancesId = self.addQueue:GetIndex(i)
			local behavior = self.behaviors[behaviorInstancesId]
			if behavior then
				if behavior[funName] then
					behavior[funName](behavior, ...)
				end
				behavior:CallFunc(funName, ...)
			end
		end
	end

	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			if behavior[funName] then
				behavior[funName](behavior, ...)
			end
			behavior:CallFunc(funName, ...)
		end
	end
end

function BehaviorComponent:OnCache()
	self.fight.objectPool:Cache(BehaviorComponent,self)
end

function BehaviorComponent:__cache()
	self:RemoveBehaviors()
	self.fight = nil
	self.entity = nil
	TableUtils.ClearTable(self.values)
	TableUtils.ClearTable(self.behaviorInstances)
	TableUtils.ClearTable(self.behaviors)
	TableUtils.ClearTable(self.removeQueue)
	self.addQueue:Refresh()
	self.behaviorInstancesId = 0
end

function BehaviorComponent:__delete()
	self:RemoveBehaviors()
end

function BehaviorComponent:RemoveBehavior(instanceId)
	if not self.behaviors[instanceId] then
		--LogError("对应behavior为空 id = "..instanceId)
		return
	end
	self.behaviors[instanceId]:Remove()
	self.behaviors[instanceId]:DeleteMe()
	self.behaviors[instanceId] = nil
end

function BehaviorComponent:RemoveBehaviors()
	if self.behaviorInstances then
		for i = #self.behaviorInstances, 1, -1 do
			self:RemoveBehavior(self.behaviorInstances[i])
		end
	end
end

function BehaviorComponent:GetBehavior(instanceId)
	if not self.behaviors[instanceId] then
		LogError("对应behavior为空 id = "..instanceId)
		return
	end
	return self.behaviors[instanceId]
end

function BehaviorComponent:NeedUpdate()
	if DebugConfig.StopMonsterLogic then
		if self.entity.tagComponent then
			local tag = self.entity.tagComponent.npcTag
			if tag == EntityNpcTag.Monster
			or tag == EntityNpcTag.Elite
			or tag == EntityNpcTag.Boss then
				return false
			end
		end
	end

	return true
end