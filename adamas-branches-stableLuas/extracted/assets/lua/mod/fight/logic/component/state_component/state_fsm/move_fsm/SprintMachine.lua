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

	-- 记录一下是不是在跑步状态 就不用绕一大圈去查了
	self.isSprint = false
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
end

function SprintMachine:LateInit()

end

function SprintMachine:OnEnter()
	-- 先查一下是不是有速度加成 有的话动画也要加速
	self:CalcSpeed()
	self.entity.logicMove = self.sprintSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Sprint)
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self.stepFrame = 0
	self.isSprint = true

	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(self.startSpeed * FightUtil.deltaTimeSecond * timeScale)
end

function SprintMachine:Update()
	self.sprintSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.SprintSpeed) or 0
	if self.sprintSpeed == 0 then return end
	local speed = self.sprintSpeed
	if self.stepFrame < self.changeFrame then
		speed = self.startSpeed + (self.sprintSpeed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		self.stepFrame = self.stepFrame + 1
	end
	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond * timeScale)
end

-- 在走的途中如果属性变化了也要加上对应的速度和动画速度
function SprintMachine:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not self.isSprint or self.entity.instanceId ~= entity.instanceId or attrType ~= EntityAttrsConfig.AttrType.SprintSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function SprintMachine:PlayerPropertyChange(attrType, resultValue, oldValue)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if not self.isSprint or self.entity.instanceId ~= ctrlId or attrType ~= FightEnum.PlayerAttr.SprintSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function SprintMachine:CalcSpeed()
	local player = Fight.Instance.playerManager:GetPlayer()
	local ctrlId = player:GetCtrlEntity()
	local eSprintSpeedPercent = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.SprintSpeedPercent) or 0
	self.sprintSpeedPercent = eSprintSpeedPercent + 1
	if ctx.IsDebug and self.entity.instanceId == ctrlId then
		local debugTimes = tonumber(DebugClientInvoke.Cache.speedTimes or 1)
		self.sprintSpeedPercent = self.sprintSpeedPercent * debugTimes
	end

	self.sprintSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.SprintSpeed) * self.sprintSpeedPercent or 0
	self.entity.animatorComponent:SetAnimatorSpeed(self.sprintSpeedPercent)
end

function SprintMachine:OnLeave()
	self.isSprint = false
	self.entity.logicMove = false
	self.entity.animatorComponent:SetAnimatorSpeed(1)
end

function SprintMachine:OnCache()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
	self.fight.objectPool:Cache(SprintMachine,self)
end

function SprintMachine:__cache()

end

function SprintMachine:__delete()

end