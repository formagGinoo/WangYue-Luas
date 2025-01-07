SwimmingMachine = BaseClass("SwimmingMachine",MachineBase)

function SwimmingMachine:__init()

end

function SwimmingMachine:Init(fight, entity, swimFSM)
	self.fight = fight
	self.entity = entity
	self.swimFSM = swimFSM
	self.moveComponent = self.entity.moveComponent
	self.transformComponent = self.entity.transformComponent
end

function SwimmingMachine:LateInit()
end

function SwimmingMachine:OnEnter()
	self.effectInterval = Config.EntityCommonConfig.SwimParam.SwimEffectPlayInterval
	self.timeToPlay = self.effectInterval

	self.surfaceOfWater = self.moveComponent:GetSurfaceOfWater()
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Swimming)
end

function SwimmingMachine:Update()
	if ctx then
		self.timeToPlay = self.timeToPlay + FightUtil.deltaTimeSecond
		if self.timeToPlay >= self.effectInterval then
			self.timeToPlay = 0
			local pos = self.transformComponent.position
			local forward = pos + self.transformComponent.rotation * Vec3.forward
			BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.Swim, nil, pos.x, self.surfaceOfWater, pos.z, forward.x, self.surfaceOfWater - 0.1, forward.z)
		end
	end
end

function SwimmingMachine:CanChangeRole()
	return true
end

function SwimmingMachine:OnLeave()
end

function SwimmingMachine:OnCache()
	self.fight.objectPool:Cache(SwimmingMachine, self)
end

function SwimmingMachine:__cache()

end

function SwimmingMachine:__delete()

end