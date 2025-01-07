WalkMachine = BaseClass("WalkMachine",MachineBase)

function WalkMachine:__init()

end

function WalkMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent
	self.transformComponent = self.entity.transformComponent

	self.walkSpeed = 0
	self.changeFrame = 0
end

function WalkMachine:LateInit()

end

function WalkMachine:OnEnter()
	self.walkSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkSpeed) or 0
	self.entity.logicMove = self.walkSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Walk)
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self.stepFrame = 0
end

function WalkMachine:Update()
	self.walkSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkSpeed) or 0
	if self.walkSpeed == 0 then return end
	local speed = self.walkSpeed
	if self.stepFrame < self.changeFrame then
		speed = self.startSpeed + (self.walkSpeed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		self.stepFrame = self.stepFrame + 1
	end
	self.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond)
end

function WalkMachine:OnLeave()
	self.entity.logicMove = false
end

function WalkMachine:OnCache()
	self.fight.objectPool:Cache(WalkMachine,self)
end

function WalkMachine:__cache()

end

function WalkMachine:__delete()

end