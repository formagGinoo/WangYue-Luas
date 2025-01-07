ClimbNoneMachine = BaseClass("ClimbNoneMachine",MachineBase)

function ClimbNoneMachine:__init()

end

function ClimbNoneMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbNoneMachine:OnEnter()

end

function ClimbNoneMachine:OnLeave()

end

function ClimbNoneMachine:OnCache()
	self.fight.objectPool:Cache(ClimbNoneMachine,self)
end

function ClimbNoneMachine:__cache()

end

function ClimbNoneMachine:__delete()

end