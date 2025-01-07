IdleInjuredMachine = BaseClass("IdleInjuredMachine",MachineBase)

function IdleInjuredMachine:__init()

end

function IdleInjuredMachine:Init(fight,entity,idleFSM)
	self.fight = fight
	self.entity = entity
	self.idleFSM = idleFSM
end

function IdleInjuredMachine:OnEnter()
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.InjuredIdle)
end

function IdleInjuredMachine:CanCastSkill()
	return true
end

function IdleInjuredMachine:CanJump()
	return false
end

function IdleInjuredMachine:CanClimb()
	return false
end

function IdleInjuredMachine:OnLeave()

end

function IdleInjuredMachine:OnCache()
	self.fight.objectPool:Cache(IdleInjuredMachine,self)
end

function IdleInjuredMachine:__cache()

end

function IdleInjuredMachine:__delete()

end