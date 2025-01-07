IdleNoneMachine = BaseClass("IdleNoneMachine",MachineBase)

function IdleNoneMachine:__init()

end

function IdleNoneMachine:Init(fight,entity,idleFSM)
	self.fight = fight
	self.entity = entity
	self.idleFSM = idleFSM
end

function IdleNoneMachine:OnEnter()

end

function IdleNoneMachine:OnLeave()

end

function IdleNoneMachine:OnCache()
	self.fight.objectPool:Cache(IdleNoneMachine,self)
end

function IdleNoneMachine:__cache()

end

function IdleNoneMachine:__delete()

end