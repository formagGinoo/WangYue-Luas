HitDownMachine = BaseClass("HitDownMachine",MachineBase)

function HitDownMachine:__init()

end

function HitDownMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.HitDown]
end

function HitDownMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.HitDown].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.HitDown].ForceTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function HitDownMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	self.remainForceTime = self.remainForceTime - time
	if self.remainChangeTime <= 0 then
		if self.entity.moveComponent.isFlyEntity then
			self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFallLoop)
		else
			self.hitFSM:SwitchState(FightEnum.EntityHitState.Lie)
		end
	end
end

function HitDownMachine:CanMove()
	return false
end

function HitDownMachine:CanCastSkill()
	return false
end

function HitDownMachine:CanHit()
	return true
end

function HitDownMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function HitDownMachine:CanFall()
	if self.entity.tagComponent and (self.entity.tagComponent:IsPlayer() or self.entity.tagComponent:IsPartner()) then
		return false
	end

	return true
end

function HitDownMachine:OnLeave()

end

function HitDownMachine:OnCache()
	self.fight.objectPool:Cache(HitDownMachine,self)
end

function HitDownMachine:__cache()

end

function HitDownMachine:__delete()

end