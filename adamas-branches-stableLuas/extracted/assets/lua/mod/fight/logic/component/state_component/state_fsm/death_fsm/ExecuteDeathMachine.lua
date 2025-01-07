ExecuteDeathMachine = BaseClass("ExecuteDeathMachine",MachineBase)

function ExecuteDeathMachine:__init()

end

function ExecuteDeathMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
	self.deathFSM = deathFSM
end

function ExecuteDeathMachine:LateInit()

end

function ExecuteDeathMachine:OnEnter(delay)
	if self.entity.attrComponent then
		self.entity.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, 0)
	end

	--self.remainChangeTime = self.changeTime
	--if self.entity.animatorComponent then
		--self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Drowning)
	--end
	self.delay = delay or 0
end

function ExecuteDeathMachine:Update()
	self.delay = self.delay - 1
	if self.delay <= 0 then
		self.deathFSM:SwitchState(FightEnum.DeathState.Death)
	end
end

function ExecuteDeathMachine:OnLeave()
	self.remainChangeTime = nil
end

function ExecuteDeathMachine:OnCache()
	self.fight.objectPool:Cache(ExecuteDeathMachine,self)
end

function ExecuteDeathMachine:CanMove()
	return false
end

function ExecuteDeathMachine:CanJump()
	return false
end

function ExecuteDeathMachine:CanHit()
	return false
end

function ExecuteDeathMachine:CanCastSkill()
	return false
end

function ExecuteDeathMachine:__cache()

end

function ExecuteDeathMachine:__delete()

end