MoveNoneMachine = BaseClass("MoveNoneMachine",MachineBase)

function MoveNoneMachine:__init()

end

function MoveNoneMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
end

function MoveNoneMachine:OnEnter()

end

function MoveNoneMachine:OnLeave()

end

function MoveNoneMachine:OnCache()
	self.fight.objectPool:Cache(MoveNoneMachine,self)
end

function MoveNoneMachine:__cache()

end

function MoveNoneMachine:__delete()

end