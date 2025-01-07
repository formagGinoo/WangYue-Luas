InjuredWalkMachine = BaseClass("InjuredWalkMachine",MachineBase)

function InjuredWalkMachine:__init()

end

function InjuredWalkMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent

	self.injuredWalkSpeed = 0
	self.changeFrame = 0
end

function InjuredWalkMachine:LateInit()

end

function InjuredWalkMachine:OnEnter()
	--self.injuredWalkSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.InjuredWalkSpeed) or 1.5
	self.injuredWalkSpeed = 1.5
	self.entity.logicMove = self.injuredWalkSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.InjuredWalk)
	--self.changeFrame = self.entity.animatorComponent.fusionFrame
end

function InjuredWalkMachine:Update()
	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(self.injuredWalkSpeed * FightUtil.deltaTimeSecond * timeScale)
end

function InjuredWalkMachine:CanCastSkill()
	return true
end

function InjuredWalkMachine:CanJump()
	return false
end

function InjuredWalkMachine:CanClimb()
	return false
end

function InjuredWalkMachine:OnLeave()
	self.entity.logicMove = false
end

function InjuredWalkMachine:OnCache()
	self.fight.objectPool:Cache(InjuredWalkMachine,self)
end

function InjuredWalkMachine:__cache()

end

function InjuredWalkMachine:__delete()

end