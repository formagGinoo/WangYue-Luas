SwimIdleMachine = BaseClass("SwimIdleMachine",MachineBase)

function SwimIdleMachine:__init()

end

function SwimIdleMachine:Init(fight, entity, swimFSM)
	self.fight = fight
	self.entity = entity
	self.swimFSM = swimFSM
	self.moveComponent = self.entity.moveComponent
	self.transformComponent = self.entity.transformComponent
end

function SwimIdleMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.SwimIdle)
	end

	self.surfaceOfWater = self.moveComponent:GetSurfaceOfWater()

	self.effectInterval = Config.EntityCommonConfig.SwimParam.SwimStandEffectPlayInterval
	self.timeToPlay = self.effectInterval
end

function SwimIdleMachine:Update()
	if ctx then
		self.speed = self.swimFSM:GetSwimmingSpeed()
		self.timeToPlay = self.timeToPlay + FightUtil.deltaTimeSecond
		if self.timeToPlay >= self.effectInterval and self.speed <= 0 then
			self.timeToPlay = 0
			local pos = self.entity.transformComponent.position
			BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.SwimIdle, nil, pos.x, self.surfaceOfWater, pos.z)
		end
	end
end

function SwimIdleMachine:CanChangeRole()
	return true
end

function SwimIdleMachine:OnLeave()

end

function SwimIdleMachine:OnCache()
	self.fight.objectPool:Cache(SwimIdleMachine, self)
end

function SwimIdleMachine:__cache()

end

function SwimIdleMachine:__delete()

end