RunStartEndMachine = BaseClass("RunStartEndMachine",MachineBase)

function RunStartEndMachine:__init()

end

function RunStartEndMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function RunStartEndMachine:OnEnter()
	self.entity.logicMove = false
	self.changeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.RunStartEnd)
	if self.changeTime == -FightUtil.deltaTimeSecond then
		self.changeTime = 0
	end
	self.remainChangeTime = self.changeTime
end

function RunStartEndMachine:Update()
	local rotation_vector = self.transformComponent.rotation_vector
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function RunStartEndMachine:OnLeave()
	self.entity.logicMove = false
end

function RunStartEndMachine:OnCache()
	self.fight.objectPool:Cache(RunStartEndMachine,self)
end

function RunStartEndMachine:__cache()

end

function RunStartEndMachine:__delete()

end