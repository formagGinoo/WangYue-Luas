LieMachine = BaseClass("LieMachine",MachineBase)

function LieMachine:__init()

end

function LieMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.Lie]
end

function LieMachine:OnEnter()
	local changeTime = self.hitTime[FightEnum.EntityHitState.Lie].Time
	self.remainChangeTime = self.hitFSM:GetLieTime(changeTime)
	
	self.remainForceTime = self.hitTime[FightEnum.EntityHitState.Lie].ForceTime
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function LieMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	self.remainForceTime = self.remainForceTime - time
	if self.remainChangeTime <= 0 then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.StandUp)
	end
end

function LieMachine:CanMove()
	return false
end

function LieMachine:CanCastSkill()
	return false
end

function LieMachine:CanChangeRole()
	return self.remainForceTime <= 0
end

function LieMachine:CanFall()
	if self.entity.tagComponent and (self.entity.tagComponent:IsPlayer() or self.entity.tagComponent:IsPartner()) then
		return false
	end

	return true
end

function LieMachine:OnLeave()

end

function LieMachine:CanHit()
	return false
end

function LieMachine:OnCache()
	self.fight.objectPool:Cache(LieMachine,self)
end

function LieMachine:__cache()

end

function LieMachine:__delete()

end