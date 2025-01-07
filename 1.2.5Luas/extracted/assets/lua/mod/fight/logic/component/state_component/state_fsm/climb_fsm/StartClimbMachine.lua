StartClimbMachine = BaseClass("StartClimbMachine",MachineBase)

function StartClimbMachine:__init()

end

function StartClimbMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function StartClimbMachine:OnEnter()
	self.time = 30
	
	self.entity.logicMove = false
	self.entity.climbComponent:SetAdjustCheckOffset(self.entity.collistionComponent.height * 0.5)
	
	if self.entity.animatorComponent then
		self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.StartClimb)
	end
end

function StartClimbMachine:Update()
	self.time = self.time - FightUtil.deltaTimeSecond
	self.entity.climbComponent:SetForceCheckDirection(0, 1, 0)
	if self.time <= 0 then
		if self.fight.operationManager:CheckMove() then
			if self.climbFSM.climbingRun then
				self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbingRunStart)
			else
				self.climbFSM:SwitchState(FightEnum.EntityClimbState.Climbing)
			end
		else
			self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
		end
	end
end

function StartClimbMachine:OnLeave()
	self.entity.climbComponent:SetAdjustCheckOffset(nil)
end

function StartClimbMachine:OnCache()
	self.fight.objectPool:Cache(StartClimbMachine,self)
end

function StartClimbMachine:__cache()

end

function StartClimbMachine:__delete()

end