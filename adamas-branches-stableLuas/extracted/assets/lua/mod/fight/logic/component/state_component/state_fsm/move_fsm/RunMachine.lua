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

	-- 记录一下是不是在跑步状态 就不用绕一大圈去查了
	self.isRun = false
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
end

function RunMachine:LateInit()

end

function RunMachine:OnEnter()
	-- 先查一下是不是有速度加成 有的话动画也要加速
	self:CalcSpeed()
	self.entity.logicMove = self.runSpeed ~= 0
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Run)
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self.stepFrame = 0
	self.isRun = true

	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(self.startSpeed * FightUtil.deltaTimeSecond * timeScale)
end

function RunMachine:Update()
	self.runSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed) or 0
	if ctx.IsDebug and self.entity.instanceId == BehaviorFunctions.GetCtrlEntity() then
		self.runSpeed = self.runSpeed * (tonumber(DebugClientInvoke.Cache.speedTimes  or 1))
	end
	if self.runSpeed == 0 then return end
	local speed = self.runSpeed
	if self.stepFrame < self.changeFrame then
		speed = self.startSpeed + (self.runSpeed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		self.stepFrame = self.stepFrame + 1
	end

	local timeScale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond * timeScale)
end

-- 在走的途中如果属性变化了也要加上对应的速度和动画速度
function RunMachine:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not self.isRun or self.entity.instanceId ~= entity.instanceId or attrType ~= EntityAttrsConfig.AttrType.RunSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function RunMachine:PlayerPropertyChange(attrType, resultValue, oldValue)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if not self.isRun or self.entity.instanceId ~= ctrlId or attrType ~= FightEnum.PlayerAttr.RunSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function RunMachine:CalcSpeed()
	local eRunSpeedPercent = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeedPercent) or 0
	self.runSpeedPercent = eRunSpeedPercent + 1
	self.runSpeed = self.attrComponent and self.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed) * self.runSpeedPercent or 0
	self.entity.animatorComponent:SetAnimatorSpeed(self.runSpeedPercent)
end

function RunMachine:OnLeave()
	self.isRun = false
	self.entity.logicMove = false
	if self.entity.animatorComponent then 
		self.entity.animatorComponent:SetAnimatorSpeed(1)
	end
end

function RunMachine:OnCache()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
	self.fight.objectPool:Cache(RunMachine,self)
end

function RunMachine:__cache()

end

function RunMachine:__delete()

end