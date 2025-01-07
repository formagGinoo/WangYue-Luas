ClimbingRunMachine = BaseClass("ClimbingRunMachine",MachineBase)

function ClimbingRunMachine:__init()

end

function ClimbingRunMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbingRunMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbingRun)
	end
end

function ClimbingRunMachine:Update()
	local speed = 3
	self.entity.climbComponent:SetForceCheckDirection(0, 1, 0)
	self.entity.climbComponent:DoMoveUp(speed * FightUtil.deltaTimeSecond)
end

function ClimbingRunMachine:OnLeave()
end

function ClimbingRunMachine:CanChangeRole()
	return true
end

function ClimbingRunMachine:OnCache()
	self.fight.objectPool:Cache(ClimbingRunMachine,self)
end

function ClimbingRunMachine:__cache()

end

function ClimbingRunMachine:__delete()

end