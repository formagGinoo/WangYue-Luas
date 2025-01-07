HackingMachine = BaseClass("HackingMachine", MachineBase)

function HackingMachine:__init()

end

function HackingMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function HackingMachine:OnEnter()

end

function HackingMachine:Update()

end

function HackingMachine:OnLeave()

end

function HackingMachine:OnCache()

end

function HackingMachine:__cache()

end

function HackingMachine:__delete()

end