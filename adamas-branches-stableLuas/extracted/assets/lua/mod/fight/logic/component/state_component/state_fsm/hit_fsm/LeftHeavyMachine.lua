LeftHeavyMachine = BaseClass("LeftHeavyMachine",MachineBase)

function LeftHeavyMachine:__init()

end

function LeftHeavyMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.LeftHeavyHit]
end

function LeftHeavyMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.LeftHeavyHit].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.LeftHeavyHit].ForceTime
	self.fusionChangeTime = self.hitTime[FightEnum.EntityHitState.LeftHeavyHit].FusionChangeTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function LeftHeavyMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	self.remainForceTime = self.remainForceTime - time
	self.fusionChangeTime = self.fusionChangeTime - time
	if self.remainChangeTime <= 0 then
		self.hitFSM:HitStateEnd()
	else
		if self.fusionChangeTime <= 0 then
			self.hitFSM:CheckBuff()
		end
	end
end

function LeftHeavyMachine:OnLeave()

end

function LeftHeavyMachine:CanMove()
	return self.remainForceTime <= 0
end

function LeftHeavyMachine:CanHit()
	return true
end

function LeftHeavyMachine:CanCastSkill()
	return self.remainForceTime <= 0
end

function LeftHeavyMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function LeftHeavyMachine:CanFall()
	if self.entity.tagComponent and (self.entity.tagComponent:IsPlayer() or self.entity.tagComponent:IsPartner()) then
		return false
	end

	return true
end

function LeftHeavyMachine:OnCache()
	self.fight.objectPool:Cache(LeftHeavyMachine,self)
end

function LeftHeavyMachine:__cache()

end

function LeftHeavyMachine:__delete()

end