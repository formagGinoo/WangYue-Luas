DrivingMachine = BaseClass("DrivingMachine", MachineBase)

function DrivingMachine:__init()

end

function DrivingMachine:Init(fight, entity, openDoorFSM)
    self.fight = fight
    self.entity = entity
    self.openDoorFSM = openDoorFSM
end

function DrivingMachine:OnEnter()
    
end

function DrivingMachine:Update()
	
end

function DrivingMachine:OnLeave()

end

function DrivingMachine:OnCache()
    self.fight.objectPool:Cache(DrivingMachine,self)
end

function DrivingMachine:__cache()

end

function DrivingMachine:__delete()

end