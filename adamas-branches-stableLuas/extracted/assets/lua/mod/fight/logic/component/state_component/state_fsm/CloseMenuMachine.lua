CloseMenuMachine = BaseClass("CloseMenuMachine",MachineBase)

function CloseMenuMachine:__init()
end

function CloseMenuMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function CloseMenuMachine:OnEnter()
	self.remainChangeTime = 0.9
	if self.remainChangeTime == 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
		return
	end
	self.entity.animatorComponent:PlayAnimation("Stand1")
end

function CloseMenuMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	if self.remainChangeTime <= 0 then
		self.entity.defaultIdleType = FightEnum.EntityIdleType.LeisurelyIdle
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function CloseMenuMachine:OnLeave()

end

function CloseMenuMachine:CanMove()
	return true
end

function CloseMenuMachine:CanCastSkill()
	return true
end

function CloseMenuMachine:OnCache()
	self.fight.objectPool:Cache(CloseMenuMachine,self)
end

function CloseMenuMachine:__cache()

end

function CloseMenuMachine:__delete()

end


