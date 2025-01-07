---@class CampComponent
CampComponent = BaseClass("CampComponent",PoolBaseClass)

function CampComponent:__init()
end

function CampComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Camp)
	self.camp = self.config.Camp
end

function CampComponent:SetCamp(camp)
	self.camp = camp
end

function CampComponent:OnCache()
	self.fight.objectPool:Cache(CampComponent,self)
end

function CampComponent:__cache()
end

function CampComponent:__delete()
end