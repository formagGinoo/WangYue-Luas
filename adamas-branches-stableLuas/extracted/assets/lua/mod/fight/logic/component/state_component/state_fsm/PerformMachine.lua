PerformMachine = BaseClass("PerformMachine",MachineBase)

function PerformMachine:__init()

end

function PerformMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function PerformMachine:OnEnter()
	--进入表演同步下位置
	--InputManager:SetCameraMouseInput(false) TODO 会卡住游戏，先去掉
	--self.entity.logicMove = true
	local transformComponent = self.entity.transformComponent
	if transformComponent then
		local position = transformComponent.position
		transformComponent:SetPosition(position.x, position.y, position.z,true)
		
		self.entity.clientTransformComponent:ClearMoveX()
	end
end

function PerformMachine:OnLeave()
	--self.entity.logicMove = false
	self.entity.stateComponent:SetPerformMoveState(false)
end

function PerformMachine:CanMove()
	return false
end

function PerformMachine:CanJump()
	return false
end

function PerformMachine:CanCastSkill()
	return false
end

function PerformMachine:OnCache()
	self.fight.objectPool:Cache(PerformMachine,self)
end

function PerformMachine:__cache()

end

function PerformMachine:__delete()

end