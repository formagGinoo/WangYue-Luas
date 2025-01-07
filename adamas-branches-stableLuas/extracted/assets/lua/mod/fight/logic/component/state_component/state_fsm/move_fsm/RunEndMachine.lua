RunEndMachine = BaseClass("RunEndMachine",MachineBase)

function RunEndMachine:__init()

end

function RunEndMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function RunEndMachine:OnEnter()
	self.entity.logicMove = false
	self.changeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.RunEnd)
	self.remainChangeTime = self.changeTime
end

function RunEndMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function RunEndMachine:OnLeave()
	self.entity.logicMove = false
end

function RunEndMachine:OnCache()
	self.fight.objectPool:Cache(RunEndMachine,self)
end

function RunEndMachine:__cache()

end

function RunEndMachine:__delete()

end