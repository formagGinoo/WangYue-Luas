ClimbingJumpMachine = BaseClass("ClimbingJumpMachine",MachineBase)

function ClimbingJumpMachine:__init()

end

function ClimbingJumpMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbingJumpMachine:OnEnter()
	self.entity.logicMove = false
	
	self.time = 22 * FightUtil.deltaTimeSecond
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbingJump)
	end
	
end

function ClimbingJumpMachine:Update()
	self.time = self.time - FightUtil.deltaTimeSecond
	self.entity.climbComponent:SetForceCheckDirection(0, 1, 0)
	if self.time <= 0 then
		if self.fight.operationManager:CheckMove() then
			local state = FightEnum.EntityClimbState.Climbing
			if self.climbFSM.climbingRun then
				state = FightEnum.EntityClimbState.ClimbingRunStart
			end
			self.climbFSM:SwitchState(state)
		else
			self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
		end
	end
end

function ClimbingJumpMachine:OnLeave()
end

function ClimbingJumpMachine:OnCache()
	self.fight.objectPool:Cache(ClimbingJumpMachine,self)
end

function ClimbingJumpMachine:__cache()

end

function ClimbingJumpMachine:__delete()

end