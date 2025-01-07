PressDownMachine = BaseClass("PressDownMachine",MachineBase)

function PressDownMachine:__init()

end

function PressDownMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.PressDown]
end

function PressDownMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.PressDown].Time
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.PressDown].ForceTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function PressDownMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	self.remainForceTime = self.remainForceTime - time
	if self.remainChangeTime <= 0 then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.Lie)
	end
end

function PressDownMachine:CanMove()
	return false
end

function PressDownMachine:CanCastSkill()
	return false
end

function PressDownMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function PressDownMachine:CanFall()
	if self.entity.tagComponent and (self.entity.tagComponent:IsPlayer() or self.entity.tagComponent:IsPartner()) then
		return false
	end

	return true
end

function PressDownMachine:OnLeave()

end

function PressDownMachine:CanHit()
	return true
end

function PressDownMachine:OnCache()
	self.fight.objectPool:Cache(PressDownMachine,self)
end

function PressDownMachine:__cache()

end

function PressDownMachine:__delete()

end