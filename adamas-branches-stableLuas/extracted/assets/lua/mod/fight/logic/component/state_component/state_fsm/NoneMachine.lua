NoneMachine = BaseClass("NoneMachine",MachineBase)

function NoneMachine:__init()
end

function NoneMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function NoneMachine:OnEnter()

end

function NoneMachine:OnLeave()

end

function NoneMachine:CanMove()
	return true
end

function NoneMachine:CanCastSkill()
	return true
end

function NoneMachine:OnCache()
	self.fight.objectPool:Cache(NoneMachine,self)
end

function NoneMachine:__cache()

end

function NoneMachine:__delete()

end