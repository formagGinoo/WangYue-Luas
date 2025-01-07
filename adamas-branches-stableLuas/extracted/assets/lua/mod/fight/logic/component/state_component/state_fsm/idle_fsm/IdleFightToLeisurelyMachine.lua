IdleFightToLeisurelyMachine = BaseClass("IdleFightToLeisurelyMachine",MachineBase)

function IdleFightToLeisurelyMachine:__init()

end

function IdleFightToLeisurelyMachine:Init(fight,entity,idleFSM)
	self.fight = fight
	self.entity = entity
	self.idleFSM = idleFSM
	self.changeTime = entity:GetComponentConfig(FightEnum.ComponentType.State).FightToLeisurely
	self.timeComponent = self.entity.timeComponent
end

function IdleFightToLeisurelyMachine:OnEnter()
	self.remainChangeTime = self.changeTime
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.FightToLeisurely)
end

function IdleFightToLeisurelyMachine:Update()
	local timeScale = self.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond * timeScale
	if self.remainChangeTime <= 0 then
		self.idleFSM:SwitchState(FightEnum.EntityIdleType.LeisurelyIdle)
	end
end

function IdleFightToLeisurelyMachine:OnLeave()

end

function IdleFightToLeisurelyMachine:OnCache()
	self.fight.objectPool:Cache(IdleFightToLeisurelyMachine,self)
end

function IdleFightToLeisurelyMachine:__cache()

end

function IdleFightToLeisurelyMachine:__delete()

end