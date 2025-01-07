FastSwimmingMachine = BaseClass("FastSwimmingMachine",MachineBase)

function FastSwimmingMachine:__init()

end

function FastSwimmingMachine:Init(fight, entity, swimFSM)
	self.fight = fight
	self.entity = entity
	self.swimFSM = swimFSM
	self.moveComponent = self.entity.moveComponent
	self.transformComponent = self.entity.transformComponent
end

function FastSwimmingMachine:LateInit()
end

function FastSwimmingMachine:OnEnter()
	self.surfaceOfWater = self.moveComponent:GetSurfaceOfWater()
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.FastSwimming)

	self.effectInterval = Config.EntityCommonConfig.SwimParam.SwimFastPatEffectPlayInterval
	self.timeToPlay = self.effectInterval
end

function FastSwimmingMachine:Update()
	if ctx then
		self.timeToPlay = self.timeToPlay + FightUtil.deltaTimeSecond
		if self.timeToPlay >= self.effectInterval then
			self.timeToPlay = 0
			local pos = self.entity.transformComponent.position + self.entity.transformComponent.rotation * (Vec3.forward * 1.1)
			local forward = pos + self.transformComponent.rotation * Vec3.forward

			BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.SwimFast, nil, pos.x, self.surfaceOfWater, pos.z, forward.x, self.surfaceOfWater - 0.1, forward.z)
			BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.SwimFastPat, nil, pos.x, self.surfaceOfWater, pos.z, forward.x, self.surfaceOfWater - 0.1, forward.z)
		end
	end
end

function FastSwimmingMachine:CanChangeRole()
	return true
end

function FastSwimmingMachine:OnLeave()

end

function FastSwimmingMachine:OnCache()
	self.fight.objectPool:Cache(FastSwimmingMachine, self)
end

function FastSwimmingMachine:__cache()

end

function FastSwimmingMachine:__delete()

end