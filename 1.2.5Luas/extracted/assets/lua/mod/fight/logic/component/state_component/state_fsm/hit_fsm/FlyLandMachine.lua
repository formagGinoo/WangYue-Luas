FlyLandMachine = BaseClass("FlyLandMachine",MachineBase)

function FlyLandMachine:__init()

end
function FlyLandMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.HitFlyLand]
end

function FlyLandMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.HitFlyLand].Time
	self.entity.animatorComponent:PlayAnimation(self.hitName)
end

function FlyLandMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	if self.remainChangeTime <= 0 then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.Lie)
	end
end

function FlyLandMachine:OnLeave()

end

function FlyLandMachine:CanMove()
	return false
end

function FlyLandMachine:CanHit()
	return false
end

function FlyLandMachine:CanCastSkill()
	return false
end

function FlyLandMachine:CanChangeRole()
	return false
end

function FlyLandMachine:OnCache()
	self.fight.objectPool:Cache(FlyLandMachine,self)
end

function FlyLandMachine:__cache()

end

function FlyLandMachine:__delete()

end