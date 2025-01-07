TerrainDeathMachine = BaseClass("TerrainDeathMachine",MachineBase)

function TerrainDeathMachine:__init()

end

function TerrainDeathMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
	self.deathFSM = deathFSM
    self.changeTime = entity:GetComponentConfig(FightEnum.ComponentType.State).DyingTime
end

function TerrainDeathMachine:LateInit()

end

function TerrainDeathMachine:OnEnter()
	if self.entity.attrComponent then
		self.entity.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, 0)
	end

	self.remainChangeTime = self.changeTime
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Drowning)
	end
end

function TerrainDeathMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTime / 10000 * self.entity.timeComponent:GetTimeScale()
	if self.remainChangeTime <= 0 then
		self.deathFSM:SwitchState(FightEnum.DeathState.Death)
	end
end

function TerrainDeathMachine:OnLeave()
	self.remainChangeTime = nil
end

function TerrainDeathMachine:OnCache()
	self.fight.objectPool:Cache(TerrainDeathMachine,self)
end

function TerrainDeathMachine:CanMove()
	return false
end

function TerrainDeathMachine:CanJump()
	return false
end

function TerrainDeathMachine:CanHit()
	return false
end

function TerrainDeathMachine:CanCastSkill()
	return false
end

function TerrainDeathMachine:__cache()

end

function TerrainDeathMachine:__delete()

end