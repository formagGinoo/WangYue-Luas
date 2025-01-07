InjuredWalkEndMachine = BaseClass("InjuredWalkEndMachine",MachineBase)

function InjuredWalkEndMachine:__init()

end

function InjuredWalkEndMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function InjuredWalkEndMachine:OnEnter()
	self.moveFSM:SetSprintState(false)
	
	self.entity.logicMove = false
	self.changeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.InjuredWalkEnd)
	self.remainChangeTime = self.changeTime
end

function InjuredWalkEndMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.entity.defaultIdleType = FightEnum.EntityIdleType.InjuredIdle
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function InjuredWalkEndMachine:CanCastSkill()
	return false
end

function InjuredWalkEndMachine:CanJump()
	return false
end

function InjuredWalkEndMachine:CanClimb()
	return false
end

function InjuredWalkEndMachine:OnLeave()
	self.entity.logicMove = true
end

function InjuredWalkEndMachine:OnCache()
	self.fight.objectPool:Cache(InjuredWalkEndMachine,self)
end

function InjuredWalkEndMachine:__cache()

end

function InjuredWalkEndMachine:__delete()

end