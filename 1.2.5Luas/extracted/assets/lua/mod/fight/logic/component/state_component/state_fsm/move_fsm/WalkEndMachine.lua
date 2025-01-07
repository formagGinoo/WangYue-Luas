WalkEndMachine = BaseClass("WalkEndMachine",MachineBase)

function WalkEndMachine:__init()

end

function WalkEndMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
end

function WalkEndMachine:OnEnter()
	self.entity.logicMove = false
	self.changeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.WalkEnd)
	self.remainChangeTime = self.changeTime
end

function WalkEndMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function WalkEndMachine:OnLeave()
	self.entity.logicMove = false
end

function WalkEndMachine:OnCache()
	self.fight.objectPool:Cache(WalkEndMachine,self)
end

function WalkEndMachine:__cache()

end

function WalkEndMachine:__delete()

end