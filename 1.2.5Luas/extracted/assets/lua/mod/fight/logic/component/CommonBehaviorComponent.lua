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
		--local behavior = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
		local name = behaviorConfig.ComponentBehaviorName
		if not _G[name] then
			LogError("创建行为树失败！"..name)
		end
		local behavior = _G[name].New()
		local parm = {}
		for _, v in pairs(Fight.CommonBehaviorParamMap[name]) do
			table.insert(parm,behaviorConfig.CommonBehaviorParms[v])
		end
		behavior:InitConfig(self.fight, self.entity, table.unpack(parm))
		table.insert(self.commonBehavior,behavior)
	end
end

function CommonBehaviorComponent:Update()
	for k, v in pairs(self.commonBehavior) do
		v:Update()
	end
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
	TableUtils.ClearTable(self.commonBehavior)
	self.fight.objectPool:Cache(CommonBehaviorComponent,self)
end

function CommonBehaviorComponent:__cache()

end

function CommonBehaviorComponent:__delete()

end


