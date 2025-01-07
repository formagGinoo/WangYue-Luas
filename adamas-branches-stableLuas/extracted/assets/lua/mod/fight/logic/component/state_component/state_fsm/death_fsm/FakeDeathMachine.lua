FakeDeathMachine = BaseClass("FakeDeathMachine", MachineBase)

function FakeDeathMachine:__init()

end

function FakeDeathMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
	self.deathFSM = deathFSM
end

function FakeDeathMachine:OnEnter()
    self.fight.entityManager:CallBehaviorFun("FakeDeath", self.entity.instanceId)

	self.entity.transformComponent:Async()
	self.remainChangeTime = self.deathFSM.fakeDeathTime
end

function FakeDeathMachine:Update()
	self.remainChangeTime = self.remainChangeTime - (FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale())
	if self.remainChangeTime <= 0 then
		self.deathFSM:BeginDie()
	end
end

function FakeDeathMachine:OnLeave()

end

function FakeDeathMachine:CanHit()
	return false
end

function FakeDeathMachine:CanMove()
	return false
end

function FakeDeathMachine:CanCastSkill()
	return false
end

function FakeDeathMachine:CanJump()
	return false
end

function FakeDeathMachine:OnCache()
	self.fight.objectPool:Cache(FakeDeathMachine,self)
end

function FakeDeathMachine:__cache()

end

function FakeDeathMachine:__delete()

end