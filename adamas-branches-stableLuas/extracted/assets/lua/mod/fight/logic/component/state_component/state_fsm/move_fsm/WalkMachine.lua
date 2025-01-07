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

	-- 记录一下是不是在状态中 就不用绕一大圈去查了
	self.isWalk = false
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
end

function WalkMachine:LateInit()

end

function WalkMachine:OnEnter()
	-- 先查一下是不是有速度加成 有的话动画也要加速
	self:CalcSpeed()
	self.entity.logicMove = self.walkSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Walk)
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self.stepFrame = 0
	self.isWalk = true

	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(self.startSpeed * FightUtil.deltaTimeSecond * timeScale)
end

function WalkMachine:Update()
	self.walkSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkSpeed) or 0
	if self.walkSpeed == 0 then return end
	if ctx.IsDebug and self.entity.instanceId == BehaviorFunctions.GetCtrlEntity() then
		self.walkSpeed = self.walkSpeed * (tonumber(DebugClientInvoke.Cache.speedTimes  or 1))
	end
	local speed = self.walkSpeed
	if self.stepFrame < self.changeFrame then
		speed = self.startSpeed + (self.walkSpeed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		self.stepFrame = self.stepFrame + 1
	end

	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond * timeScale)
end

-- 在走的途中如果属性变化了也要加上对应的速度和动画速度
function WalkMachine:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not self.isWalk or self.entity.instanceId ~= entity.instanceId or attrType ~= EntityAttrsConfig.AttrType.WalkSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function WalkMachine:PlayerPropertyChange(attrType, resultValue, oldValue)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if not self.isWalk or self.entity.instanceId ~= ctrlId or attrType ~= FightEnum.PlayerAttr.WalkSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function WalkMachine:CalcSpeed()
	local eWalkSpeedPercent = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkSpeedPercent) or 0
	self.walkSpeedPercent = eWalkSpeedPercent + 1
	self.walkSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkSpeed) * self.walkSpeedPercent or 0
	self.entity.animatorComponent:SetAnimatorSpeed(self.walkSpeedPercent)
end

function WalkMachine:OnLeave()
	self.isWalk = false
	self.entity.logicMove = false
	if self.entity.animatorComponent then 
		self.entity.animatorComponent:SetAnimatorSpeed(1)
	end
end

function WalkMachine:OnCache()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
	self.fight.objectPool:Cache(WalkMachine,self)
end

function WalkMachine:__cache()

end

function WalkMachine:__delete()

end