WalkBackMachine = BaseClass("WalkBackMachine",MachineBase)

function WalkBackMachine:__init()

end

function WalkBackMachine:Init(fight,entity,moveFSM)
	self.fight = fight
	self.entity = entity
	self.moveFSM = moveFSM
	self.moveComponent = self.entity.moveComponent
	self.attrComponent = self.entity.attrComponent

	self.walkBackSpeed = 0
end

function WalkBackMachine:LateInit()

end

function WalkBackMachine:OnEnter()
	self.walkBackSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkBackSpeed) or 0
	self.entity.logicMove = self.walkBackSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.WalkBack)
end

function WalkBackMachine:Update()
	self.walkBackSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkBackSpeed) or 0
	self.moveComponent:DoMoveBack(self.walkBackSpeed * FightUtil.deltaTimeSecond)
end

function WalkBackMachine:OnLeave()
	self.entity.logicMove = false
end

function WalkBackMachine:OnCache()
	self.fight.objectPool:Cache(WalkBackMachine,self)
end

function WalkBackMachine:__cache()

end

function WalkBackMachine:__delete()

end