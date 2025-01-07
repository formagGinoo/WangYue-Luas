ClimbingRunEndMachine = BaseClass("ClimbingRunEndMachine",MachineBase)

function ClimbingRunEndMachine:__init()

end

function ClimbingRunEndMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbingRunEndMachine:OnEnter()
	self.entity.logicMove = false
	self.time = 16 * FightUtil.deltaTimeSecond
	if self.entity.animatorComponent then
		self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbingRunEnd)
	end
end

function ClimbingRunEndMachine:Update()
	self.time = self.time - FightUtil.deltaTimeSecond
	self.entity.climbComponent:SetForceCheckDirection(0, 1, 0)
	if self.time <= 0 then
		self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
	end
end

function ClimbingRunEndMachine:OnLeave()
	self.entity.logicMove = true
end

function ClimbingRunEndMachine:OnCache()
	self.fight.objectPool:Cache(ClimbingRunEndMachine,self)
end

function ClimbingRunEndMachine:__cache()

end

function ClimbingRunEndMachine:__delete()

end