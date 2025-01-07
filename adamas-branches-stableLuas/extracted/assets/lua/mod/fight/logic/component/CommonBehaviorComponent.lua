---@class CommonBehaviorComponent
CommonBehaviorComponent = BaseClass("CommonBehaviorComponent",PoolBaseClass)

function CommonBehaviorComponent:__init()
	self.commonBehavior = {}
end

function CommonBehaviorComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.CommonBehavior)
end

function CommonBehaviorComponent:LateInit()
	for behaviorType, behaviorConfig in pairs(self.config.CommonBehaviors) do
		local name = behaviorConfig.ComponentBehaviorName
		local behavior = Fight.Instance.entityManager.entityBehaviorMgr:CreateBehavior(name, nil, self.entity.instanceId)
		local parm = {}
		for _, v in pairs(FightEnum.CommonBehaviorParamMap[name]) do
			table.insert(parm,behaviorConfig.NewCommonBehaviorParms[v])
		end
		behavior:InitConfig(self.fight, self.entity, table.unpack(parm))
		--todo 这里做个临时处理
		if self.config.m_commonBehaviorsAnim then
			behavior:InitAnimConfig(self.fight, self.entity, self.config.m_commonBehaviorsAnim)
		end
		self.commonBehavior[name] = behavior
	end
end

function CommonBehaviorComponent:BeforeUpdate()

end

function CommonBehaviorComponent:Update()
	for k, v in pairs(self.commonBehavior) do
		v:Update()
	end
end

function CommonBehaviorComponent:AfterUpdate()

end

function CommonBehaviorComponent:CallFunc(funName, ...)
	for k, behavior in pairs(self.commonBehavior) do
		if behavior and behavior[funName] then
			behavior[funName](behavior, ...)
			behavior:CallFunc(funName, ...)
		end
	end
end

function CommonBehaviorComponent:OnCache()
	for k, v in pairs(self.commonBehavior) do
		Fight.Instance.entityManager.entityBehaviorMgr:RemoveBehavior(v)
		if v.OnCache then
			v:OnCache()
		end
	end
	TableUtils.ClearTable(self.commonBehavior)
	self.fight.objectPool:Cache(CommonBehaviorComponent,self)
end

function CommonBehaviorComponent:__cache()

end

function CommonBehaviorComponent:__delete()

end

function CommonBehaviorComponent:IsHaveBehavior(behaviorName)
	if self.commonBehavior[behaviorName] then
		return true
	end
	return false
end

function CommonBehaviorComponent:GetBehaviorByName(behaviorName)
	return self.commonBehavior[behaviorName]
end

