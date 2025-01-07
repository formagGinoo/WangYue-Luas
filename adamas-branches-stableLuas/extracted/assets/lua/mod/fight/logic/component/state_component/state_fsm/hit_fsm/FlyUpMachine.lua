FlyUpMachine = BaseClass("FlyUpMachine",MachineBase)

function FlyUpMachine:__init()

end

function FlyUpMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.HitFlyUp]
end

function FlyUpMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.HitFlyUp].Time
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function FlyUpMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	if self.entity.moveComponent and not self.entity.moveComponent.isAloft then
		self.hitFSM:OnLand()
		return
	end

	if self.remainChangeTime <= 0 or self.hitFSM.yMoveComponent:GetSpeed() < 0 then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyUpLoop)
	end
end

function FlyUpMachine:OnLeave()

end

function FlyUpMachine:CanMove()
	return false
end

function FlyUpMachine:CanCastSkill()
	return false
end

function FlyUpMachine:CanHit()
	return true
end

function FlyUpMachine:CanChangeRole()
	return false
end

function FlyUpMachine:OnCache()
	self.fight.objectPool:Cache(FlyUpMachine,self)
end

function FlyUpMachine:__cache()

end

function FlyUpMachine:__delete()

end