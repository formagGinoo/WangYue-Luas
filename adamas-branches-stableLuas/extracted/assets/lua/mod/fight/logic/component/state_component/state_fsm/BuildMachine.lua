BuildMachine = BaseClass("BuildMachine", MachineBase)

function BuildMachine:__init()

end

function BuildMachine:Init(fight, entity)
	self.fight = fight
	self.entity = entity

	self.buildFSM = self.fight.objectPool:Get(BuildFSM)
	self.buildFSM:Init(fight,entity)
    self.buildFSM.parentFSM = self.parentFSM
    self.buildFSM.stateId = self.stateId
end

function BuildMachine:LateInit()
    self.buildFSM:LateInit()
end

function BuildMachine:OnEnter()
	self.buildFSM:OnEnter()
end

function BuildMachine:OnLeave()
    self.buildFSM:OnLeave()
end

function BuildMachine:Update()
    self.buildFSM:Update()
end

function BuildMachine:CanMove()
    return self.buildFSM:CanMove()
end

function BuildMachine:StartMove()
    return self.buildFSM:StartMove()
end

function BuildMachine:StopMove()
    return self.buildFSM:StopMove()
end

function BuildMachine:CanJump()
    return true
end

function BuildMachine:CanFall()
    return true
end

function BuildMachine:GetSubState()
	return self.buildFSM:GetState()
end

function BuildMachine:CanCastSkill()
    return false
end

function BuildMachine:OnCache()
    if self.buildFSM then
		self.buildFSM:OnCache()
		self.buildFSM = nil
	end
	self.fight.objectPool:Cache(BuildMachine, self)
end

function BuildMachine:__delete()
    if self.buildFSM then
        self.buildFSM:DeleteMe()
        self.buildFSM = nil
    end
end