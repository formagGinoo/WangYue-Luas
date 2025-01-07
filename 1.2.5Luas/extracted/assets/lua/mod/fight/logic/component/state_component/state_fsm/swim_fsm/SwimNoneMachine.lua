SwimNoneMachine = BaseClass("SwimNoneMachine",MachineBase)

function SwimNoneMachine:__init()

end

function SwimNoneMachine:Init(fight,entity,swimFSM)
	self.fight = fight
	self.entity = entity
	self.swimFSM = swimFSM
end

function SwimNoneMachine:OnEnter()
end

function SwimNoneMachine:Update()

end

function SwimNoneMachine:CanChangeRole()
	return false
end

function SwimNoneMachine:OnLeave()

end

function SwimNoneMachine:OnCache()
	self.fight.objectPool:Cache(SwimNoneMachine,self)
end

function SwimNoneMachine:__cache()

end

function SwimNoneMachine:__delete()

end