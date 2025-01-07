WalkLeftMachine = BaseClass("WalkLeftMachine",MachineBase)

function WalkLeftMachine:__init()

end

function WalkLeftMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent

	self.walkLeftSpeed = 0
end

function WalkLeftMachine:LateInit()

end

function WalkLeftMachine:OnEnter()
	self.walkLeftSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkLeftSpeed) or 0
	self.entity.logicMove = self.walkLeftSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.WalkLeft)
end

function WalkLeftMachine:Update()
	self.walkLeftSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkLeftSpeed) or 0
	if self.walkLeftSpeed == 0 then return end
	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveLeft(self.walkLeftSpeed * FightUtil.deltaTimeSecond * timeScale)
end

function WalkLeftMachine:OnLeave()
	self.entity.logicMove = false
end

function WalkLeftMachine:OnCache()
	self.fight.objectPool:Cache(WalkLeftMachine,self)
end

function WalkLeftMachine:__cache()

end

function WalkLeftMachine:__delete()

end