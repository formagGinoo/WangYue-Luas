BornMachine = BaseClass("BornMachine",MachineBase)

function BornMachine:__init()
end

function BornMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.State)
	self.changeTime = self.config.BornTime or 0
end

function BornMachine:OnEnter()
	self.fight.entityManager:CallBehaviorFun("Born", self.entity.instanceId, self.entity.entityId)
	self.remainChangeTime = self.changeTime
	if self.remainChangeTime == 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
		return
	end
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Born)
end

function BornMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end


function BornMachine:OnLeave()

end

function BornMachine:CanMove()
	return false
end

function BornMachine:CanCastSkill()
	return false
end

function BornMachine:OnCache()
	self.fight.objectPool:Cache(BornMachine,self)
end

function BornMachine:__cache()

end

function BornMachine:__delete()

end


