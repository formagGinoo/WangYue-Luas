FlyFallLoopMachine = BaseClass("FlyFallLoopMachine",MachineBase)

function FlyFallLoopMachine:__init()

end

function FlyFallLoopMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.transformComponent = self.entity.transformComponent
	self.loopTime = 0
end

function FlyFallLoopMachine:OnEnter()
	self.loopTime = 0
end

function FlyFallLoopMachine:Update()
	if self.entity.moveComponent.isFlyEntity then
		local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
		self.loopTime = self.loopTime + time
		if self.loopTime > self.entity.moveComponent.config.fallRecoverTime then
			self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFallRecover)
		end
	end
	if not self.entity.moveComponent.isAloft then
		self.hitFSM:OnLand()
	end
end

function FlyFallLoopMachine:OnLeave()

end

function FlyFallLoopMachine:CanMove()
	return false
end

function FlyFallLoopMachine:CanHit()
	return true
end

function FlyFallLoopMachine:CanCastSkill()
	return false
end

function FlyFallLoopMachine:CanChangeRole()
	return false
end

function FlyFallLoopMachine:OnCache()
	self.fight.objectPool:Cache(FlyFallLoopMachine,self)
end

function FlyFallLoopMachine:__cache()

end

function FlyFallLoopMachine:__delete()

end