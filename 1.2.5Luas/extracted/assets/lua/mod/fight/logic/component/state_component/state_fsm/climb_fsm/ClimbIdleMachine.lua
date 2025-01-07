ClimbIdleMachine = BaseClass("ClimbIdleMachine",MachineBase)

function ClimbIdleMachine:__init()

end

function ClimbIdleMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbIdleMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbIdle)
	end
end

function ClimbIdleMachine:Update()
end

function ClimbIdleMachine:OnLeave()
end

function ClimbIdleMachine:CanChangeRole()
	return true
end

function ClimbIdleMachine:OnCache()
	self.fight.objectPool:Cache(ClimbIdleMachine,self)
end

function ClimbIdleMachine:__cache()

end

function ClimbIdleMachine:__delete()

end