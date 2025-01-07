AimStartMachine = BaseClass("AimStartMachine",MachineBase)

function AimStartMachine:__init()

end

function AimStartMachine:Init(fight,entity,aimFSM)
	self.fight = fight
	self.entity = entity
	self.aimFSM = aimFSM
	self.transformComponent = self.entity.transformComponent
	-- self.changeFrame = 0
end

function AimStartMachine:LateInit()

end

function AimStartMachine:OnEnter()
	-- self.changeFrame = self.entity.animatorComponent.fusionFrame
	-- self.remainChangeTime = self.aimFSM.aimConfig.AimStartTime
    self:PlayAnimation()
end

function AimStartMachine:PlayAnimation()
	--local clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent
	--clientAnimatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.AimUp, 0.1, 0, self.aimFSM.aimLayer)

	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.AimUp, 0, self.aimFSM.aimLayer)
	self.entity.animatorComponent:Update()
	 -- self.entity.animatorComponent:Update()
end

function AimStartMachine:Update()
	-- self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	-- if self.remainChangeTime <= 0 then
	-- 	self.aimFSM:SwitchState(FightEnum.EntityAimState.AimIng)
	-- end
end

function AimStartMachine:OnLeave()

end

function AimStartMachine:OnCache()
	self.fight.objectPool:Cache(AimStartMachine,self)
end

function AimStartMachine:__cache()

end

function AimStartMachine:__delete()

end