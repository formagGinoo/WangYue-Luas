DieMachine = BaseClass("DieMachine",MachineBase)

function DieMachine:__init()

end

function DieMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
	self.deathFSM = deathFSM
	self.changeTime = entity:GetComponentConfig(FightEnum.ComponentType.State).DyingTime
end

function DieMachine:OnEnter()
	self.entity.transformComponent:Async()
	
	self.remainChangeTime = self.changeTime
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Dying)
	end
end

function DieMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTime / 10000 * self.entity.timeComponent:GetTimeScale()
	if self.remainChangeTime <= 0 then
		local nextState = self.deathFSM.fakeDeath and FightEnum.DeathState.FakeDeath or FightEnum.DeathState.Death
		self.deathFSM:SwitchState(nextState)
	end
end

function DieMachine:OnLeave()

end

function DieMachine:CanHit()
	return false
end

function DieMachine:CanMove()
	return false
end

function DieMachine:CanCastSkill()
	return false
end

function DieMachine:CanJump()
	return false
end

function DieMachine:OnCache()
	self.fight.objectPool:Cache(DieMachine,self)
end

function DieMachine:__cache()

end

function DieMachine:__delete()

end