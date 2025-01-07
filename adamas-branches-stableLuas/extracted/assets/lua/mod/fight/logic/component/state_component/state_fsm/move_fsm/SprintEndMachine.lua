SprintEndMachine = BaseClass("SprintEndMachine",MachineBase)

function SprintEndMachine:__init()

end

function SprintEndMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function SprintEndMachine:OnEnter()
	self.moveFSM:SetSprintState(false)
	
	self.entity.logicMove = false
	self.changeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.SprintEnd)
	self.remainChangeTime = self.changeTime
end

function SprintEndMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function SprintEndMachine:OnLeave()
	self.entity.logicMove = true
end

function SprintEndMachine:OnCache()
	self.fight.objectPool:Cache(SprintEndMachine,self)
end

function SprintEndMachine:__cache()

end

function SprintEndMachine:__delete()

end