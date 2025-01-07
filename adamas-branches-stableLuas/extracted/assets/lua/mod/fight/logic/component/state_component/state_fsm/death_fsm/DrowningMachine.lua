DrowningMachine = BaseClass("DrowningMachine",MachineBase)

function DrowningMachine:__init()

end

function DrowningMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
	self.deathFSM = deathFSM
end

function DrowningMachine:LateInit()
	if self.entity.moveComponent then
		self.surfaceOfWater = self.entity.moveComponent:GetSurfaceOfWater()
	end
end

function DrowningMachine:OnEnter()
	if self.entity.attrComponent then
		self.entity.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, 0)
	end

	local config = self.entity.deathComponent:GetJudgeCondition(FightEnum.DeathCondition.Drown)
	self.changeTime = config.deathTime

	if self.changeTime == -FightUtil.deltaTimeSecond or self.changeTime == -1 then
		self.changeTime = 0
	end
	self.remainChangeTime = self.changeTime

	if self.surfaceOfWater then
		local pos = self.entity.transformComponent:GetPosition()
		BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.Drowning, self.entity.instanceId, pos.x, self.surfaceOfWater - 0.1, pos.z)
	end

	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Drowning)
end

function DrowningMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.deathFSM:SwitchState(FightEnum.DeathState.Death)
	end
end

function DrowningMachine:OnLeave()
	self.changeTime = nil
	self.remainChangeTime = nil
end

function DrowningMachine:OnCache()
	self.fight.objectPool:Cache(DrowningMachine,self)
end

function DrowningMachine:CanMove()
	return false
end

function DrowningMachine:CanJump()
	return false
end

function DrowningMachine:CanHit()
	return false
end

function DrowningMachine:CanCastSkill()
	return false
end

function DrowningMachine:__cache()

end

function DrowningMachine:__delete()

end