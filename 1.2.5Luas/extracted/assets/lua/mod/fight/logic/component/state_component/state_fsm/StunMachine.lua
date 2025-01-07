StunMachine = BaseClass("StunMachine",MachineBase)

function StunMachine:__init()

end

function StunMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function StunMachine:OnEnter()
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Stun)
end

function StunMachine:OnLeave()

end

function StunMachine:CanMove()
	return false
end

function StunMachine:CanCastSkill()
	return false
end

function StunMachine:CanJump()
	return false
end

function StunMachine:OnCache()
	self.fight.objectPool:Cache(StunMachine,self)
end

function StunMachine:__cache()

end

function ImmobilizeMachine:__delete()

end