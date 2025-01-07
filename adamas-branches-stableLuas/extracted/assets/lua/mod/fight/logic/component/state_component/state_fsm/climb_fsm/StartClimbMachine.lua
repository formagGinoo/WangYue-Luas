StartClimbMachine = BaseClass("StartClimbMachine",MachineBase)

local ClimbState = FightEnum.EntityClimbState
local DeltaTime = FightUtil.deltaTimeSecond

function StartClimbMachine:__init()

end

function StartClimbMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
end

function StartClimbMachine:LateInit()
	if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
		self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
	end

	self.climbComponent = self.entity.climbComponent
end

function StartClimbMachine:OnEnter()
	--self.entity.logicMove = false
	--self.entity.clientTransformComponent:SetUseRenderAniMove(true)
	
	self.animTime = 24
	self.switchableTime = 12
	self.timer = 0

	local moveVector = self.fight.operationManager:GetMoveEvent()
	if not moveVector then
		self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
		return
	end
	
	if self.entity.animatorComponent then
		-- LogError("ClimbJumpStart")
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.StartClimb)
	end
end

function StartClimbMachine:Update()
	--LogError("StartClimbMachine:Update()" .. self.fight.fightFrame)
	-- 离开攀爬按键
	if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
		self.entity.climbComponent:UpdateRot(self.heightCheck)
		self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
		return
	end
	
	-- 线性插值调整旋转
	--self.entity.transformComponent:SetRotation(Quat.Lerp(self.currRotation, self.targetRotation, self.timer / self.switchableTime))

	if self.timer * DeltaTime >= self.animTime * DeltaTime then
		local moveVector = self.fight.operationManager:GetMoveEvent()
		if moveVector then
			if self.climbFSM.climbRun then
				if moveVector.x == 0 and moveVector.y < 0 then
					self.climbFSM:SwitchState(ClimbState.Idle)
				else
					self.climbFSM:SwitchState(ClimbState.ClimbRunStart)
				end
			else
				self.climbFSM:SwitchState(ClimbState.Climbing)
			end
		else
			self.climbFSM:SwitchState(ClimbState.Idle)
		end
	end

	if self.timer * DeltaTime >= self.switchableTime * DeltaTime then
		local moveVector = self.fight.operationManager:GetMoveEvent()
		if moveVector then
			if self.climbFSM.climbRun then
				if moveVector.x == 0 and moveVector.y < 0 then
					self.climbFSM:SwitchState(ClimbState.Idle)
				else
					self.climbFSM:SwitchState(ClimbState.ClimbRunStart)
				end
			else
				self.climbFSM:SwitchState(ClimbState.Climbing)
			end
		end
	end

	-- todo 版本前临时处理，因为开始上墙动作root点在腰部，导致会先出现向下的位移，后面修复后删掉这里逻辑
	if self.timer == 6 then
		self.entity.clientTransformComponent:SetUseRenderAniMove(true)
	end

	self.timer = self.timer + 1
end

function StartClimbMachine:OnLeave()
	self.entity.clientTransformComponent:SetUseRenderAniMove(false)

	-- 根据人物体型修改KCC碰撞体半径和高度
	self.entity.climbComponent:SetClimbCapsuleRadiusAndHeight()
end

function StartClimbMachine:OnCache()
	self.fight.objectPool:Cache(StartClimbMachine,self)
end

function StartClimbMachine:__cache()

end

function StartClimbMachine:__delete()

end