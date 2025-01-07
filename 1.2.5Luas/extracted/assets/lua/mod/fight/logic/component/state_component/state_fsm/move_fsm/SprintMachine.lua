SprintMachine = BaseClass("SprintMachine",MachineBase)

function SprintMachine:__init()

end

function SprintMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent

	self.sprintSpeed = 0
	self.changeFrame = 0
end

function SprintMachine:LateInit()

end

function SprintMachine:OnEnter()
	self.sprintSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.SprintSpeed) or 0
	self.entity.logicMove = self.sprintSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Sprint)
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self.stepFrame = 0
end

function SprintMachine:Update()
	--self.sprintSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.SprintSpeed) or 0
	--if self.sprintSpeed == 0 then return end
	--local speed = self.sprintSpeed
	--if self.stepFrame < self.changeFrame then
		--speed = self.startSpeed + (self.sprintSpeed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		--self.stepFrame = self.stepFrame + 1
	--end
	self.moveComponent:DoMoveForward(self.sprintSpeed * FightUtil.deltaTimeSecond)
end

function SprintMachine:OnLeave()
	self.entity.logicMove = false
end

function SprintMachine:OnCache()
	self.fight.objectPool:Cache(SprintMachine,self)
end

function SprintMachine:__cache()

end

function SprintMachine:__delete()

end