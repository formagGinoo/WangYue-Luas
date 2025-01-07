WalkStartMachine = BaseClass("WalkStartMachine",MachineBase)

function WalkStartMachine:__init()

end

function WalkStartMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function WalkStartMachine:OnEnter()
	self.changeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.WalkStart)
	if self.changeTime == -FightUtil.deltaTimeSecond then
		self.changeTime = 0
	end
	self.remainChangeTime = self.changeTime
end

function WalkStartMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.moveFSM:SwitchState(FightEnum.EntityMoveSubState.Walk)
	end
end

function WalkStartMachine:OnLeave()

end

function WalkStartMachine:OnCache()
	self.fight.objectPool:Cache(WalkStartMachine,self)
end

function WalkStartMachine:__cache()

end

function WalkStartMachine:__delete()

end