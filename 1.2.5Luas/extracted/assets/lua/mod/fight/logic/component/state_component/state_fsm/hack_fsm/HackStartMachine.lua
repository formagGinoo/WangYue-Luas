HackStartMachine = BaseClass("HackStartMachine", MachineBase)

function HackStartMachine:__init()

end

function HackStartMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function HackStartMachine:OnEnter()

end

function HackStartMachine:Update()

end

function HackStartMachine:OnLeave()

end

function HackStartMachine:OnCache()

end

function HackStartMachine:__cache()

end

function HackStartMachine:__delete()

end