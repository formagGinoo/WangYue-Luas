AimMachine = BaseClass("AimMachine",MachineBase)

function AimMachine:__init()

end

function AimMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity

	self.aimFSM = self.fight.objectPool:Get(AimFSM)
	self.aimFSM:Init(fight,entity)
end

function AimMachine:LateInit()
    self.aimFSM:LateInit()
end

function AimMachine:OnEnter()
	self.aimFSM:OnEnter()
end

function AimMachine:OnLeave()
    self.aimFSM:OnLeave()
end

function AimMachine:Update()
    self.aimFSM:Update()
end

function AimMachine:StartMove()
	self.aimFSM:StartMove()
end

function AimMachine:StopMove()
	self.aimFSM:StopMove()
end

function AimMachine:CanMove()
    return self.aimFSM:CanMove()
end

function AimMachine:CanJump()
    return false
end

function AimMachine:CanCastSkill()
    return true
end

function AimMachine:OnCache()
    if self.aimFSM then
		self.aimFSM:OnCache()
		self.aimFSM = nil
	end
	self.fight.objectPool:Cache(AimMachine, self)
end

function AimMachine:__delete()
    if self.aimFSM then
        self.aimFSM:DeleteMe()
        self.aimFSM = nil
    end
end