JumpMachine = BaseClass("JumpMachine", MachineBase)

function JumpMachine:__init()

end

function JumpMachine:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = self.fight.objectPool:Get(JumpFSM)
    self.jumpFSM:Init(fight, entity)
    self.jumpFSM.parentFSM = self.parentFSM
    self.jumpFSM.stateId = self.stateId
end

function JumpMachine:LateInit()
    self.jumpFSM:LateInit()
end

function JumpMachine:OnEnter(isSkill, forceJump, forceDown, fromGlider)
    self.jumpFSM:StartJump(isSkill, forceJump, forceDown, fromGlider)
end

function JumpMachine:OnLeave()
    self.jumpFSM:Reset()
end

function JumpMachine:Update()
    self.jumpFSM:Update()
end

function JumpMachine:CanMove()
    return self.jumpFSM:CanMove()
end

function JumpMachine:CanJump()
    return self.jumpFSM:CanJump()
end

function JumpMachine:GetSubState()
	return self.jumpFSM:GetState()
end

function JumpMachine:CanCastSkill()
    return self.jumpFSM:CanCastSkill()
end

function JumpMachine:CanClimb()
	return self.jumpFSM:CanClimb()
end

function JumpMachine:CanPush()
	return self.jumpFSM:CanPush()
end

function JumpMachine:CanChangeRole()
    return self.jumpFSM:CanChangeRole()
end

function JumpMachine:OnCache()
    if self.jumpFSM then
		self.jumpFSM:OnCache()
		self.jumpFSM = nil
	end
	self.fight.objectPool:Cache(JumpMachine, self)
end

function JumpMachine:__delete()
    if self.jumpFSM then
        self.jumpFSM:DeleteMe()
        self.jumpFSM = nil
    end
end