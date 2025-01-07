PathfindingMachine = BaseClass("PathfindingMachine",MachineBase)

function PathfindingMachine:__init()

end

function PathfindingMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function PathfindingMachine:OnEnter()

end

function PathfindingMachine:OnLeave()

end

function PathfindingMachine:CanMove()
	return true
end

function PathfindingMachine:CanCastSkill()
	return true
end

function PathfindingMachine:OnCache()
	self.fight.objectPool:Cache(PathfindingMachine,self)
end

function PathfindingMachine:__cache()

end

function PathfindingMachine:__delete()

end