ClimbingRunMachine = BaseClass("ClimbingRunMachine",MachineBase)

function ClimbingRunMachine:__init()

end

function ClimbingRunMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM

	self.isClimbRun = false
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
end

function ClimbingRunMachine:OnEnter()
	self.isClimbRun = true
	self:CalcSpeed()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbingRun)
	end
end

function ClimbingRunMachine:Update()
	self.entity.climbComponent:SetForceCheckDirection(0, 1, 0)
	self.entity.climbComponent:DoMoveUp(self.climbRunSpeed * FightUtil.deltaTimeSecond)
end

function ClimbingRunMachine:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not self.isClimbRun or self.entity.instanceId ~= entity.instanceId or attrType ~= EntityAttrsConfig.AttrType.ClimbRunSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function ClimbingRunMachine:PlayerPropertyChange(attrType, resultValue, oldValue)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if not self.isClimbRun or self.entity.instanceId ~= ctrlId or attrType ~= FightEnum.PlayerAttr.ClimbRunSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function ClimbingRunMachine:CalcSpeed()
	local player = Fight.Instance.playerManager:GetPlayer()
	local eClimbRunSpeedPercent = self.entity.attrComponent and self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.ClimbRunSpeedPercent) or 0
	self.climbRunSpeedPercent = eClimbRunSpeedPercent + 1
	self.climbRunSpeed = player.fightPlayer:GetBaseAttrValue(FightEnum.PlayerAttr.ClimbRunSpeed) * self.climbRunSpeedPercent
	self.entity.animatorComponent:SetAnimatorSpeed(self.climbRunSpeedPercent)
end

function ClimbingRunMachine:OnLeave()
	self.isClimbRun = false
	self.entity.animatorComponent:SetAnimatorSpeed(1)
end

function ClimbingRunMachine:CanChangeRole()
	return true
end

function ClimbingRunMachine:OnCache()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
	self.fight.objectPool:Cache(ClimbingRunMachine,self)
end

function ClimbingRunMachine:__cache()

end

function ClimbingRunMachine:__delete()

end