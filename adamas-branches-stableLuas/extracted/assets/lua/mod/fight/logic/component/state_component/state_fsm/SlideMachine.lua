SlideMachine = BaseClass("SlideMachine",MachineBase)

function SlideMachine:__init()

end

function SlideMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function SlideMachine:OnEnter()
	print("EnterSLide")
end

function SlideMachine:OnLeave()
end

function SlideMachine:CanMove()
	return false
end

function SlideMachine:CanJump()
	return true
end

function SlideMachine:CanCastSkill()
	return false
end

function SlideMachine:OnCache()
	self.fight.objectPool:Cache(SlideMachine,self)
end

function SlideMachine:__cache()

end

function SlideMachine:__delete()

end