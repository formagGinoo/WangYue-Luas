HitMachine = BaseClass("HitMachine",MachineBase)

function HitMachine:__init()

end

function HitMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.hitFSM = self.fight.objectPool:Get(HitFSM)
	self.hitFSM:Init(fight,entity)
end

function HitMachine:OnEnter(attackConfig,...)
	self.hitFSM:OnEnter(attackConfig,...)
end

function HitMachine:Update()
	self.hitFSM:Update()
end

function HitMachine:OnLeave()
	self.entity.transformComponent.hitFlyHeight = 0
	self.entity.transformComponent.lastHitFlyHeight = 0
	self.hitFSM:Reset()
end

function HitMachine:CanMove()
	return self.hitFSM:CanMove()
end

function HitMachine:CanCastSkill()
	return self.hitFSM:CanCastSkill()
end

function HitMachine:CanStun()
	return false
end

function HitMachine:CanJump()
	return false
end

function HitMachine:CanChangeRole()
	return self.hitFSM:CanChangeRole()
end

function HitMachine:OnCache()
	if self.hitFSM then
		self.hitFSM:OnCache()
		self.hitFSM = nil
	end
	self.fight.objectPool:Cache(HitMachine,self)
end

function HitMachine:__cache()

end

function HitMachine:__delete()
	if self.hitFSM then
		self.hitFSM:DeleteMe()
		self.hitFSM = nil
	end
end