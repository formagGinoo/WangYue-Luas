IdleLeisurelyMachine = BaseClass("IdleLeisurelyMachine",MachineBase)

function IdleLeisurelyMachine:__init()

end

function IdleLeisurelyMachine:Init(fight,entity,idleFSM)
	self.fight = fight
	self.entity = entity
	self.idleFSM = idleFSM
end

function IdleLeisurelyMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Idle)
	end
end

function IdleLeisurelyMachine:OnLeave()

end

function IdleLeisurelyMachine:OnCache()
	self.fight.objectPool:Cache(IdleLeisurelyMachine,self)
end

function IdleLeisurelyMachine:__cache()

end

function IdleLeisurelyMachine:__delete()

end