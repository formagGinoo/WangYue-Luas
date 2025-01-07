FightIdleMachine = BaseClass("FightIdleMachine",MachineBase)

function FightIdleMachine:__init()

end

function FightIdleMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function FightIdleMachine:OnEnter()
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.FightIdle)
end

function FightIdleMachine:OnLeave()

end

function FightIdleMachine:CanMove()
	return true
end

function FightIdleMachine:CanCastSkill()
	return true
end

function FightIdleMachine:OnCache()
	self.fight.objectPool:Cache(FightIdleMachine,self)
end

function FightIdleMachine:__cache()

end

function FightIdleMachine:__delete()

end