HackEndMachine = BaseClass("HackEndMachine", MachineBase)

function HackEndMachine:__init()

end

function HackEndMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function HackEndMachine:OnEnter()

end

function HackEndMachine:Update()

end

function HackEndMachine:OnLeave()

end

function HackEndMachine:OnCache()

end

function HackEndMachine:__cache()

end

function HackEndMachine:__delete()

end