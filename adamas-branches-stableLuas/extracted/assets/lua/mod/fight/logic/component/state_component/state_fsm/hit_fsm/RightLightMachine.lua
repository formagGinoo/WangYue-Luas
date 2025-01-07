RightLightMachine = BaseClass("RightLightMachine",MachineBase)

function RightLightMachine:__init()

end

function RightLightMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.RightLightHit]
end

function RightLightMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.RightLightHit].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.RightLightHit].ForceTime
	self.fusionChangeTime = self.hitTime[FightEnum.EntityHitState.RightLightHit].FusionChangeTime
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(self.hitName)
	end
end

function RightLightMachine:Update()
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

function RightLightMachine:OnLeave()

end

function RightLightMachine:CanMove()
	return self.remainForceTime <= 0
end

function RightLightMachine:CanHit()
	return true
end

function RightLightMachine:CanCastSkill()
	return self.remainForceTime <= 0
end

function RightLightMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function RightLightMachine:CanFall()
	if self.entity.tagComponent and (self.entity.tagComponent:IsPlayer() or self.entity.tagComponent:IsPartner()) then
		return false
	end

	return true
end

function RightLightMachine:OnCache()
	self.fight.objectPool:Cache(RightLightMachine,self)
end

function RightLightMachine:__cache()

end

function RightLightMachine:__delete()

end