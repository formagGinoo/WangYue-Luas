LeftLightMachine = BaseClass("LeftLightMachine",MachineBase)

function LeftLightMachine:__init()

end

function LeftLightMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.LeftLightHit]
end

function LeftLightMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.LeftLightHit].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.LeftLightHit].ForceTime
	self.fusionChangeTime = self.hitTime[FightEnum.EntityHitState.LeftLightHit].FusionChangeTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function LeftLightMachine:Update()
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

function LeftLightMachine:OnLeave()

end

function LeftLightMachine:CanMove()
	return self.remainForceTime <= 0
end

function LeftLightMachine:CanHit()
	return true
end

function LeftLightMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function LeftLightMachine:CanCastSkill()
	return self.remainForceTime <= 0
end
function LeftLightMachine:OnCache()
	self.fight.objectPool:Cache(LeftLightMachine,self)
end

function LeftLightMachine:__cache()

end

function LeftLightMachine:__delete()

end