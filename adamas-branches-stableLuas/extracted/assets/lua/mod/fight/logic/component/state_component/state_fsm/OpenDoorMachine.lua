OpenDoorMachine = BaseClass("OpenDoorMachine", MachineBase)

function OpenDoorMachine:__init()

end

function OpenDoorMachine:Init(fight, entity)
    self.fight = fight
    self.entity = entity

    self.openDoorFSM = self.fight.objectPool:Get(OpenDoorFSM)
    self.openDoorFSM:Init(fight,entity)
end

function OpenDoorMachine:LateInit()
    self.openDoorFSM:LateInit()
end

function OpenDoorMachine:OnEnter(type, callback ,bip)
    self.openDoorFSM:OnEnter(type, callback,bip)
end

function OpenDoorMachine:OnLeave()
    self.openDoorFSM:OnLeave()
end

function OpenDoorMachine:Update()
    self.openDoorFSM:Update()
end

function OpenDoorMachine:CanMove()
    return self.openDoorFSM:CanMove()
end

function OpenDoorMachine:CanFall()
    return false
end

function OpenDoorMachine:CanJump()
    return false
end

function OpenDoorMachine:CanCastSkill()
    return false
end

function OpenDoorMachine:OnCache()
    if self.openDoorFSM then
        self.openDoorFSM:OnCache()
        self.openDoorFSM = nil
    end
    self.fight.objectPool:Cache(OpenDoorMachine, self)
end

function OpenDoorMachine:__delete()
    if self.openDoorFSM then
        self.openDoorFSM:DeleteMe()
        self.openDoorFSM = nil
    end
end