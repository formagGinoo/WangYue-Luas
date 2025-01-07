---@class AimComponent
AimComponent = BaseClass("AimComponent",PoolBaseClass)

function AimComponent:__init()
end

function AimComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function AimComponent:OnCache()
	self.fight.objectPool:Cache(AimComponent,self)
end

function AimComponent:__cache()
	self.fight = nil
	self.entity = nil
	self.config = nil
end

function AimComponent:__delete()

end