RightHeavyMachine = BaseClass("RightHeavyMachine",MachineBase)

function RightHeavyMachine:__init()

end

function RightHeavyMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.RightHeavyHit]
end

function RightHeavyMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.RightHeavyHit].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.RightHeavyHit].ForceTime
	self.fusionChangeTime = self.hitTime[FightEnum.EntityHitState.RightHeavyHit].FusionChangeTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function RightHeavyMachine:Update()
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

function RightHeavyMachine:OnLeave()

end
function RightHeavyMachine:CanMove()
	return self.remainForceTime <= 0
end

function RightHeavyMachine:CanHit()
	return true
end

function RightHeavyMachine:CanCastSkill()
	return self.remainForceTime <= 0
end

function RightHeavyMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function RightHeavyMachine:OnCache()
	self.fight.objectPool:Cache(RightHeavyMachine,self)
end

function RightHeavyMachine:__cache()

end

function RightHeavyMachine:__delete()

end