ClimbIdleMachine = BaseClass("ClimbIdleMachine",MachineBase)

function ClimbIdleMachine:__init()

end

function ClimbIdleMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function ClimbIdleMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbIdle)
		--print("ClimbIdle")
	end
	local kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
	if kCCCharacterProxy then
		kCCCharacterProxy:SetClimb(true)
	end
end

function ClimbIdleMachine:Update()
end

function ClimbIdleMachine:OnLeave()
	if self.animator then
		self.animator:SetFloat("moveVectorX", 0)
		self.animator:SetFloat("moveVectorY", 0)
	end
	local kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
	if kCCCharacterProxy then
		kCCCharacterProxy:SetClimb(false)
	end
end

function ClimbIdleMachine:CanChangeRole()
	return true
end

function ClimbIdleMachine:OnCache()
	self.fight.objectPool:Cache(ClimbIdleMachine,self)
end

function ClimbIdleMachine:__cache()

end

function ClimbIdleMachine:__delete()

end