FlyFallMachine = BaseClass("FlyFallMachine",MachineBase)

function FlyFallMachine:__init()

end

function FlyFallMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.HitFlyFall]
end

function FlyFallMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.HitFlyFall].Time
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function FlyFallMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	if not self.entity.moveComponent.isAloft then
		self.hitFSM:OnLand()
		return
	end
	if self.remainChangeTime <= 0 then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFallLoop)
	end
end

function FlyFallMachine:OnLeave()

end

function FlyFallMachine:CanMove()
	return false
end

function FlyFallMachine:CanHit()
	return true
end

function FlyFallMachine:CanCastSkill()
	return false
end

function FlyFallMachine:CanChangeRole()
	return false
end

function FlyFallMachine:OnCache()
	self.fight.objectPool:Cache(FlyFallMachine,self)
end

function FlyFallMachine:__cache()

end

function FlyFallMachine:__delete()

end