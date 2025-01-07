BeingHackedMachine = BaseClass("BeingHackedMachine", MachineBase)

function BeingHackedMachine:__init()

end

function BeingHackedMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function BeingHackedMachine:OnEnter()

end

function BeingHackedMachine:Update()

end

function BeingHackedMachine:OnLeave()

end

function BeingHackedMachine:OnCache()

end

function BeingHackedMachine:__cache()

end

function BeingHackedMachine:__delete()

end