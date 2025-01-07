ClimbingRunStartMachine = BaseClass("ClimbingRunStartMachine",MachineBase)

function ClimbingRunStartMachine:__init()

end

function ClimbingRunStartMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbingRunStartMachine:OnEnter()
	self.entity.logicMove = false
	self.time = 11 * FightUtil.deltaTimeSecond
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbingRunStart)
	end
end

function ClimbingRunStartMachine:Update()
	self.time = self.time - FightUtil.deltaTimeSecond
	self.entity.climbComponent:SetForceCheckDirection(0, 1, 0)
	if self.time <= 0 then
		if self.fight.operationManager:CheckMove() then
			self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbingRun)
		else
			self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbingRunEnd)
		end
	end
end

function ClimbingRunStartMachine:OnLeave()
	self.entity.logicMove = true
end

function ClimbingRunStartMachine:OnCache()
	self.fight.objectPool:Cache(ClimbingRunStartMachine,self)
end

function ClimbingRunStartMachine:__cache()

end

function ClimbingRunStartMachine:__delete()

end