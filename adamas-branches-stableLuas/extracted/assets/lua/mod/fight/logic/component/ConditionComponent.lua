---@class ConditionComponent
ConditionComponent = BaseClass("ConditionComponent",PoolBaseClass)

function ConditionComponent:__init()
end

function ConditionComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Condition)
	
end

function ConditionComponent:LateInit()
	self:InitCondition()
end

function ConditionComponent:InitCondition()
	local paramList = self.config.ConditionParamsList or {}
	for k, v in pairs(paramList) do
		v.EventId = self.entity.entityId * 100 + k
	end
	
	if self.fight.fightConditionManager then
		self.fight.fightConditionManager:AddListenerList(self.entity.instanceId, paramList)
	end
end

function ConditionComponent:OnCache()
	self.fight.objectPool:Cache(ConditionComponent,self)
end