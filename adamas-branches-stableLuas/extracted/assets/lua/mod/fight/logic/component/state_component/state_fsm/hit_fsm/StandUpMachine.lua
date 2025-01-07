StandUpMachine = BaseClass("StandUpMachine",MachineBase)

function StandUpMachine:__init()

end

function StandUpMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.StandUp]
end

function StandUpMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.StandUp].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.StandUp].ForceTime
	self.ignoreHitTime = self.hitTime[FightEnum.EntityHitState.StandUp].IgnoreHitTime
	self.fusionChangeTime = self.hitTime[FightEnum.EntityHitState.StandUp].FusionChangeTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function StandUpMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	self.remainForceTime = self.remainForceTime - time
	self.ignoreHitTime = self.ignoreHitTime - time
	self.fusionChangeTime = self.fusionChangeTime - time
	if self.remainChangeTime <= 0 then
		self.hitFSM:HitStateEnd()
	else
		if self.fusionChangeTime <= 0 then
			self.hitFSM:CheckBuff()
		end
	end
end

function StandUpMachine:CanMove()
	return self.remainForceTime <= 0
end

function StandUpMachine:CanCastSkill()
	return self.remainForceTime <= 0
end

function StandUpMachine:OnLeave()

end

function StandUpMachine:CanHit()
	return self.ignoreHitTime < 0
end

function StandUpMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function StandUpMachine:CanFall()
	if self.entity.tagComponent and (self.entity.tagComponent:IsPlayer() or self.entity.tagComponent:IsPartner()) then
		return false
	end

	return true
end

function StandUpMachine:OnCache()
	self.fight.objectPool:Cache(StandUpMachine,self)
end

function StandUpMachine:__cache()

end

function StandUpMachine:__delete()

end