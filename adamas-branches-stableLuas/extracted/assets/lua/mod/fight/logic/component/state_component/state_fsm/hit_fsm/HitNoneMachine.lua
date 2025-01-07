HitNoneMachine = BaseClass("HitNoneMachine",MachineBase)

function HitNoneMachine:__init()

end

function HitNoneMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
end

function HitNoneMachine:OnEnter()

end

function HitNoneMachine:OnLeave()

end

function HitNoneMachine:CanMove()
	return false
end

function HitNoneMachine:CanHit()
	return true
end

function HitNoneMachine:CanCastSkill()
	return false
end

function HitNoneMachine:CanChangeRole()
	return false
end

function HitNoneMachine:OnCache()
	self.fight.objectPool:Cache(HitNoneMachine,self)
end

function HitNoneMachine:__cache()

end

function HitNoneMachine:__delete()

end