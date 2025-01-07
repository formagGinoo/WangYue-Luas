ImmobilizeMachine = BaseClass("ImmobilizeMachine",MachineBase)

function ImmobilizeMachine:__init()

end

function ImmobilizeMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function ImmobilizeMachine:OnEnter()

end

function ImmobilizeMachine:OnLeave()

end

function ImmobilizeMachine:CanMove()
	return false
end

function ImmobilizeMachine:CanCastSkill()
	return false
end

function ImmobilizeMachine:OnCache()
	self.fight.objectPool:Cache(ImmobilizeMachine,self)
end

function ImmobilizeMachine:__cache()

end

function ImmobilizeMachine:__delete()

end