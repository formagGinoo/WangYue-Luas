StrideOverMachine = BaseClass("StrideOverMachine",MachineBase)

local Vec3 = Vec3
local Quat = Quat
local animFrame = 59			-- 动画帧数
local SwitchableFrame = 20      -- 可打断帧数

function StrideOverMachine:__init()

end

function StrideOverMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function StrideOverMachine:OnEnter()
	--LogError("Enter StrideOverMachine")
	--self.entity.logicMove = true
	self.entity.clientTransformComponent:SetUseRenderAniMove(true)
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.StrideOver)
	
	self.remainChangeTime = animFrame * FightUtil.deltaTimeSecond
	self.switchableFrame = SwitchableFrame * FightUtil.deltaTimeSecond
end

function StrideOverMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	self.switchableFrame = self.switchableFrame - FightUtil.deltaTimeSecond

	if self.remainChangeTime < 55 * FightUtil.deltaTimeSecond then
		-- 根据人物体型修改KCC碰撞体半径和高度
		self.entity.climbComponent:SetClimbCapsuleRadiusAndHeight()
	end
	
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end

	if self.switchableFrame <= 0 then
		local moveVector = self.fight.operationManager:GetMoveEvent()
		if moveVector then
			self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
		end
	end
end

function StrideOverMachine:OnLeave()
	--self.entity.logicMove = false
	local euler = self.entity.transformComponent:GetRotation():ToEulerAngles()
	local rotation = Quat.Euler(0, euler.y, 0)
	self.entity.transformComponent:SetRotation(rotation)
	self.entity.clientTransformComponent:SetUseRenderAniMove(false)
end

function StrideOverMachine:CanMove()

end

function StrideOverMachine:CanJump()
	return false
end

function StrideOverMachine:CanClimb()
	return false
end

function StrideOverMachine:CanCastSkill()
	return false
end

function StrideOverMachine:OnCache()
	self.fight.objectPool:Cache(StrideOverMachine,self)
end

function StrideOverMachine:__cache()

end

function StrideOverMachine:__delete()

end