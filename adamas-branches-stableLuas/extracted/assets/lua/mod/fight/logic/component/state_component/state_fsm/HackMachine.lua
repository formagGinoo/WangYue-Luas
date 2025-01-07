HackMachine = BaseClass("HackMachine", MachineBase)

function HackMachine:__init()

end

function HackMachine:Init(fight, entity)
	self.fight = fight
	self.entity = entity

	self.hackFSM = self.fight.objectPool:Get(HackFSM)
	self.hackFSM:Init(fight,entity)
    self.hackFSM.parentFSM = self.parentFSM
    self.hackFSM.stateId = self.stateId
end

function HackMachine:LateInit()
    self.hackFSM:LateInit()
end

function HackMachine:OnEnter()
	self.hackFSM:OnEnter()
end

function HackMachine:OnLeave()
    self.hackFSM:OnLeave()
end

function HackMachine:Update()
    self.hackFSM:Update()
end

function HackMachine:CanMove()
    return self.hackFSM:CanMove()
end

function HackMachine:CanJump()
    return false
end

function HackMachine:CanFall()
    return false
end

function HackMachine:GetSubState()
	return self.hackFSM:GetState()
end

function HackMachine:CanCastSkill()
    return false
end

function HackMachine:OnCache()
    if self.hackFSM then
		self.hackFSM:OnCache()
		self.hackFSM = nil
	end
	self.fight.objectPool:Cache(HackMachine, self)
end

function HackMachine:__delete()
    if self.hackFSM then
        self.hackFSM:DeleteMe()
        self.hackFSM = nil
    end
end