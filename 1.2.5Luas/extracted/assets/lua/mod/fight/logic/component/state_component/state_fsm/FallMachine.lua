FallMachine = BaseClass("FallMachine",MachineBase)

function FallMachine:__init()

end

function FallMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function FallMachine:OnEnter()

end

function FallMachine:OnLeave()

end

function FallMachine:CanMove()
	return false
end

function FallMachine:CanCastSkill()
	return false
end

function FallMachine:OnCache()
	self.fight.objectPool:Cache(FallMachine,self)
end

function FallMachine:__cache()

end

function FallMachine:__delete()

end