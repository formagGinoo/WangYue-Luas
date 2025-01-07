MonsterLandMachine = BaseClass("MonsterLandMachine", MachineBase)

function MonsterLandMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function MonsterLandMachine:OnEnter()
    -- self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
end

function MonsterLandMachine:Update()

end

function MonsterLandMachine:CanMove()
    return true
end

function MonsterLandMachine:CanCastSkill()
    return false
end

function MonsterLandMachine:CanLand()
    return false
end

function MonsterLandMachine:CanDoubleJump()
    return false
end

function MonsterLandMachine:CanProactiveDown()
    return false
end

function MonsterLandMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function MonsterLandMachine:OnCache()
    self.fight.objectPool:Cache(MonsterLandMachine, self)
end