RunStartMachine = BaseClass("RunStartMachine",MachineBase)

function RunStartMachine:__init()

end

function RunStartMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.changeTime = entity:GetComponentConfig(FightEnum.ComponentType.State).RunStartTime
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function RunStartMachine:OnEnter()
	self.remainChangeTime = self.changeTime
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.RunStart)
end

function RunStartMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.moveFSM:SwitchState(FightEnum.EntityMoveSubState.Run)
	end
end

function RunStartMachine:OnLeave()

end

function RunStartMachine:OnCache()
	self.fight.objectPool:Cache(RunStartMachine,self)
end

function RunStartMachine:__cache()

end

function RunStartMachine:__delete()

end