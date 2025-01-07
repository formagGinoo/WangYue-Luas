WalkRightMachine = BaseClass("WalkRightMachine",MachineBase)

function WalkRightMachine:__init()

end

function WalkRightMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent

	self.walkRightSpeed = 0
end

function WalkRightMachine:LateInit()

end

function WalkRightMachine:OnEnter()
	self.walkRightSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkRightSpeed) or 0
	self.entity.logicMove = self.walkRightSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.WalkRight)
end

function WalkRightMachine:Update()
	self.walkRightSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkRightSpeed) or 0
	if self.walkRightSpeed == 0 then return end
	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveRight(self.walkRightSpeed * FightUtil.deltaTimeSecond * timeScale)
end

function WalkRightMachine:OnLeave()
	self.entity.logicMove = false
end

function WalkRightMachine:OnCache()
	self.fight.objectPool:Cache(WalkRightMachine,self)
end

function WalkRightMachine:__cache()

end

function WalkRightMachine:__delete()

end