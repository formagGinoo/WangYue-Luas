DeathNoneMachine = BaseClass("DeathNoneMachine", MachineBase)

function DeathNoneMachine:__init()

end

function DeathNoneMachine:Init(fight, entity)
    self.fight = fight
end

function DeathNoneMachine:Update()

end

function DeathNoneMachine:CanMove()
	return false
end

function DeathNoneMachine:CanJump()
	return false
end

function DeathNoneMachine:CanHit()
	return false
end

function DeathNoneMachine:CanCastSkill()
	return false
end

function DeathNoneMachine:OnCache()
    self.fight.objectPool:Cache(DeathNoneMachine, self)
end

function DeathNoneMachine:__cache()

end

function DeathNoneMachine:__delete()

end