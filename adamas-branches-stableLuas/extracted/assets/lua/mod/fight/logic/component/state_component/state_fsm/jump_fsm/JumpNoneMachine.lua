JumpNoneMachine = BaseClass("JumpNoneMachine", MachineBase)

function JumpNoneMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM
end

function JumpNoneMachine:OnEnter()

end

function JumpNoneMachine:Update()

end

function JumpNoneMachine:OnLeave()

end

function JumpNoneMachine:CanMove()
    return false
end

function JumpNoneMachine:CanCastSkill()
    return false
end

function JumpNoneMachine:CanLand()
    return false
end

function JumpNoneMachine:CanDoubleJump()
    return false
end

function JumpNoneMachine:OnCache()
    self.fight.objectPool:Cache(JumpNoneMachine, self)
end