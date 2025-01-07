StunMachine = BaseClass("StunMachine",MachineBase)

function StunMachine:__init()

end

function StunMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function StunMachine:LateInit()
	self.clientIkComponent = self.entity.clientEntity.clientIkComponent
end

function StunMachine:OnEnter()
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Stun)

	if self.entity.moveComponent then
		local checkGround = self.fight.physicsTerrain:CheckGround(self.entity.transformComponent:GetPosition(), self.entity, true)
		if checkGround then
			local JumpParam = Config.EntityCommonConfig.JumpParam
			local paramsTable = {
				speedY = -2,
				gravity = JumpParam.Gravity,
				accelerationY = JumpParam.JumpSpeedAcceleration,
				maxFallSpeed = JumpParam.MaxFallSpeed,
			}
			self.entity.moveComponent.yMoveComponent:SetConfig(paramsTable, true)
			self.entity.moveComponent.yMoveComponent:SetPlaneSpeed(0)
		end
	end

	if self.clientIkComponent then
		self.clientIkComponent:SetStateLookEnable(false)
	end
end

function StunMachine:OnLeave()
	if self.clientIkComponent then
		self.clientIkComponent:SetStateLookEnable(true, FightEnum.EntityState.Stun)
	end
end

function StunMachine:CanMove()
	return false
end

function StunMachine:CanCastSkill()
	return false
end

function StunMachine:CanJump()
	return false
end

function StunMachine:OnCache()
	self.fight.objectPool:Cache(StunMachine,self)
end

function StunMachine:__cache()

end

function ImmobilizeMachine:__delete()

end