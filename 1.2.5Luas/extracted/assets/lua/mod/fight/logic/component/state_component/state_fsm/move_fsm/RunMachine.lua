RunMachine = BaseClass("RunMachine",MachineBase)

function RunMachine:__init()
end

function RunMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.transformComponent = self.entity.transformComponent
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent

	self.runSpeed = 0
	self.changeFrame = 0
end

function RunMachine:LateInit()

end

function RunMachine:OnEnter()
	self.runSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed) or 0
	self.entity.logicMove = self.runSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Run)
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self.stepFrame = 0
end

function RunMachine:Update()
	self.runSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed) or 0
	if self.runSpeed == 0 then return end
	local speed = self.runSpeed
	if self.stepFrame < self.changeFrame then
		speed = self.startSpeed + (self.runSpeed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		self.stepFrame = self.stepFrame + 1
	end
	self.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond)
end

function RunMachine:OnLeave()
	self.entity.logicMove = false
end

function RunMachine:OnCache()
	self.fight.objectPool:Cache(RunMachine,self)
end

function RunMachine:__cache()

end

function RunMachine:__delete()

end