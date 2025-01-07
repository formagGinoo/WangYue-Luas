SkillMachine = BaseClass("SkillMachine",MachineBase)

function SkillMachine:__init()

end

function SkillMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function SkillMachine:OnEnter()
	self.entity.logicMove = false
end

function SkillMachine:OnLeave()

end

function SkillMachine:OnSwitchEnd()
	if not self.entity.skillComponent then
		return
	end

	self.entity.skillComponent:onLevelSkillMachine()
end

function SkillMachine:CanMove()
	return self.entity.skillComponent:CanFinish() and not self.entity.moveComponent.isAloft
end

function SkillMachine:CanJump()
	return self.entity.skillComponent:CanFinish() and not self.entity.moveComponent.isAloft
end

function SkillMachine:CanCastSkill()
	return self.entity.skillComponent:CanCastOtherSkill() or self.entity.skillComponent:CanFinish()
end

function SkillMachine:CanChangeRole()
	return self.entity.skillComponent:CanChangeRole()
end

function SkillMachine:OnCache()
	self.fight.objectPool:Cache(SkillMachine,self)
end

function SkillMachine:__cache()

end

function SkillMachine:__delete()

end