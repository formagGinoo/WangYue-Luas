FlyUpLoopMachine = BaseClass("FlyUpLoopMachine",MachineBase)

function FlyUpLoopMachine:__init()

end

function FlyUpLoopMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
end

function FlyUpLoopMachine:Update()
	if not self.entity.moveComponent.isAloft then
		self.hitFSM:OnLand()
		return
	end

	local speed = self.hitFSM.yMoveComponent:GetSpeed()
	if speed and speed <= 0 then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFall)
	end
end

function FlyUpLoopMachine:OnEnter()

end


function FlyUpLoopMachine:OnLeave()

end

function FlyUpLoopMachine:CanMove()
	return false
end

function FlyUpLoopMachine:CanHit()
	return true
end

function FlyUpLoopMachine:CanCastSkill()
	return false
end

function FlyUpLoopMachine:CanChangeRole()
	return false
end

function FlyUpLoopMachine:OnCache()
	self.fight.objectPool:Cache(FlyUpLoopMachine,self)
end

function FlyUpLoopMachine:__cache()

end

function FlyUpLoopMachine:__delete()

end