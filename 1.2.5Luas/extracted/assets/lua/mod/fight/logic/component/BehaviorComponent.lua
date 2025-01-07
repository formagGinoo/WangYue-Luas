---@class BehaviorComponent
BehaviorComponent = BaseClass("BehaviorComponent",PoolBaseClass)
local _tinsert = table.insert
local _tremove = table.remove

function BehaviorComponent:__init()
	self.values = {}
	self.behaviors = {}
	self.removeQueue = {}
	self.behaviorInstances = {}
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
end

function BehaviorComponent:AddBehavior(behaviorName, Prefix)
	if #self.behaviorInstances >= self.maxBehaviorNum then
		LogError("行为树总数超过上限")
		return
	end

	Prefix = Prefix or "Behavior"
	local class = Prefix..behaviorName
	if not _G[class] then
		LogError(" AddBehavior error "..class)
		return
	end
	local behavior = _G[class].New()
	if behavior then
		self.behaviorInstancesId = self.behaviorInstancesId + 1
		behavior:SetInstanceId(self.entity.instanceId, self.entity.sInstanceId)
		behavior:Init()
		behavior.behaviorInstancesId = self.behaviorInstancesId
		
		self.behaviors[behavior.behaviorInstancesId] = behavior
		_tinsert(self.behaviorInstances, self.behaviorInstancesId)
	end

	return behavior
end

function BehaviorComponent:BeforeUpdate()
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			behavior:BeforeUpdate()
		else
			_tinsert(self.removeQueue, i)
		end
	end

	if next(self.removeQueue) then
		for i = #self.removeQueue, 1, -1 do
			_tremove(self.behaviorInstances, self.removeQueue[i])
		end

		for i = #self.removeQueue, 1, -1 do
			_tremove(self.removeQueue)
		end
	end
end

function BehaviorComponent:Update()
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			behavior:Update()
		end
	end
end

function BehaviorComponent:AfterUpdate()
	for i = 1, #self.behaviorInstances do
		local behavior = self.behaviors[self.behaviorInstances[i]]
		if behavior then
			behavior:AfterUpdate()
		end
	end
end

function BehaviorComponent:CallFunc(funName, ...)
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
	self.behaviorInstancesId = 0
end

function BehaviorComponent:__delete()
	self:RemoveBehaviors()
end

function BehaviorComponent:RemoveBehavior(instanceId)
	if not self.behaviors[instanceId] then
		LogError("对应behavior为空 id = "..instanceId)
		return
	end
	self.behaviors[instanceId]:Remove()
	self.behaviors[instanceId]:DeleteMe()
	self.behaviors[instanceId] = nil
	for k, v in pairs(self.behaviorInstances) do
		if instanceId == v then
			_tremove(self.behaviorInstances, k)
			break
		end
	end
end

function BehaviorComponent:RemoveBehaviors()
	--不调用 RemoveBehavior()是为了减少for循环次数
	if self.behaviorInstances then
		for i = #self.behaviorInstances, 1, -1 do
			local instanceId = self.behaviorInstances[i]
			if self.behaviors[instanceId] then
				self.behaviors[instanceId]:Remove()
				self.behaviors[instanceId]:DeleteMe()
				self.behaviors[instanceId] = nil
			end
			_tremove(self.behaviorInstances, i)
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