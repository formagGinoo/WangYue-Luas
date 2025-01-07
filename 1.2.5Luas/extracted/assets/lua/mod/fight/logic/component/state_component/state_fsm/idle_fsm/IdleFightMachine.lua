IdleFightMachine = BaseClass("IdleFightMachine",MachineBase)

function IdleFightMachine:__init()

end

function IdleFightMachine:Init(fight,entity,idleFSM)
	self.fight = fight
	self.entity = entity
	self.idleFSM = idleFSM
end

function IdleFightMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.FightIdle)
	end	
end

function IdleFightMachine:OnLeave()

end

function IdleFightMachine:OnCache()
	self.fight.objectPool:Cache(IdleFightMachine,self)
end

function IdleFightMachine:__cache()

end

function IdleFightMachine:__delete()

end