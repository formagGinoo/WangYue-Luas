ClimbFSM = BaseClass("ClimbFSM", FSM)

local ClimbState = FightEnum.EntityClimbState
local DeltaTime = FightUtil.deltaTimeSecond

function ClimbFSM:__init()

end

function ClimbFSM:Init(fight, entity)
	self.fight = fight
	self.entity = entity

	self.climbRun = false
	self.CheckJumpFrame = 0
	self.jumpVector = Vec3.New(0, 0, 0)

	self:InitStates()
end

function ClimbFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(ClimbState.None, objectPool:Get(ClimbNoneMachine))							-- 未在墙上
	self:AddState(ClimbState.StartClimb, objectPool:Get(StartClimbMachine))						-- 普通起跳上墙
	self:AddState(ClimbState.Idle, objectPool:Get(ClimbIdleMachine))							-- 墙上静止
	self:AddState(ClimbState.Climbing, objectPool:Get(ClimbingMachine))							-- 攀爬
	self:AddState(ClimbState.ClimbingRun, objectPool:Get(ClimbingRunMachine))					-- 攀跑
	self:AddState(ClimbState.ClimbStart2, objectPool:Get(ClimbStart2Machine))					-- 疾跑上墙
	self:AddState(ClimbState.ClimbRun, objectPool:Get(ClimbRunMachine))							-- 攀跑
	self:AddState(ClimbState.ClimbRunStart, objectPool:Get(ClimbRunStartMachine))				-- 起跑
	self:AddState(ClimbState.ClimbRunEnd, objectPool:Get(ClimbRunEndMachine))					-- 攀跑停
	self:AddState(ClimbState.ClimbJump, objectPool:Get(ClimbJumpMachine))						-- 攀跳
	self:AddState(ClimbState.ClimbingJump, objectPool:Get(ClimbingJumpMachine))					-- 向上攀跳
	self:AddState(ClimbState.ClimbJumpOver, objectPool:Get(ClimbJumpOverMachine))				-- 攀跳触顶
	self:AddState(ClimbState.ClimbRunOver, objectPool:Get(ClimbRunOverMachine))					-- 攀跑触顶
	self:AddState(ClimbState.StrideOver, objectPool:Get(StrideOverMachine))						-- 攀爬触顶
	self:AddState(ClimbState.ClimbLand, objectPool:Get(ClimbLandMachine))						-- 攀爬落地
	
	for k, v in pairs(self.states) do
		v:Init(self.fight, self.entity, self)
	end

	self:SwitchState(ClimbState.None)
end

function ClimbFSM:LateInit()
	for k, v in pairs(self.states) do
		if v.LateInit then
			v:LateInit()
		end
	end
end

-- 判断攀跳相关逻辑
function ClimbFSM:Update()
	if not self.statesMachine or self.curState == ClimbState.None then
		return
	end

	if self.fight.operationManager:CheckJump() then
		self.CheckJumpFrame = 6 * DeltaTime
		local moveVector = self.fight.operationManager:GetMoveEvent()
		if moveVector then
			self.jumpVector = moveVector
		end
	end

	if self.CheckJumpFrame > 0 then
		self.CheckJumpFrame = self.CheckJumpFrame - DeltaTime
	end
	
	if self:IsState(ClimbState.Idle) or self:IsState(ClimbState.Climbing) then
		-- 按键离开攀爬
		if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
			self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
			self.CheckJumpFrame = 0
			self.jumpVector:Set(0, 0, 0)
			return
		end
		
		-- 攀跳
		if self.CheckJumpFrame > 0 then
			if self.jumpVector.y < 0 then
				local val = math.abs(self.jumpVector.x) / math.abs(self.jumpVector.y)
				if math.abs(val) < 1.732 then	-- Y轴负方向正负60°区间内才可退出, tan60 ~= 1.732
					self.entity.rotateComponent:DoRotate(0, 180, 0)
					self.entity.clientTransformComponent:Async()
					self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, true)
					self.CheckJumpFrame = 0
					self.jumpVector:Set(0, 0, 0)
					return
				end
			else
				self:SwitchState(ClimbState.ClimbJump)	-- 多向攀跳
				self.CheckJumpFrame = 0
				self.jumpVector:Set(0, 0, 0)
			end
		end
	end

	self.statesMachine:Update()
end

-- 在Idle状态时，每帧根据当前输入判断下一帧攀爬状态
function ClimbFSM:StartClimb()
	if not (self:IsState(ClimbState.None) or self:IsState(ClimbState.Idle)) or self:IsState(ClimbState.StrideOver) then
		return 
	end
	
	-- 检测墙体高度是否能直接攀越，后续看是否根据不同状态和高度播放不同跨越动画
	local animationYOffset = self.entity.climbComponent.config.ClimbStrideOverOffset
	local canClimbLedge, correctOffset = self.entity.climbComponent:TryClimbToLedge(animationYOffset)
	if self:IsState(ClimbState.None) and canClimbLedge then
		self.entity.moveComponent:SetPositionOffset(correctOffset.x,correctOffset.y,correctOffset.z)
		self:SwitchState(ClimbState.StrideOver)
		return
	end
	
	if self:IsState(ClimbState.Idle) then
		if self.climbRun then
			local moveVector = self.fight.operationManager:GetMoveEvent()
			if not moveVector then
				return
			end

			if moveVector.x == 0 and moveVector.y == -1 then	-- 输入Y轴为-1时需要特判，人物不移动
				return
			end
			
			self:SwitchState(ClimbState.ClimbRunStart)
		else
			self:SwitchState(ClimbState.Climbing)
		end
	else
		if self.entity.stateComponent:IsSprint() then	-- 在冲刺中
			self:SwitchState(ClimbState.ClimbStart2)
		else
			self:SwitchState(ClimbState.StartClimb)
		end							
	end
end

-- 每帧判断状态机是否可切换至 -> 当前动作结束状态
function ClimbFSM:StopClimb()
	if self:IsState(ClimbState.Idle) or
		self:IsState(ClimbState.StartClimb) or
		self:IsState(ClimbState.ClimbRunStart) or
		self:IsState(ClimbState.ClimbRunEnd) or
		self:IsState(ClimbState.ClimbJump) or
		self:IsState(ClimbState.ClimbingJump) or
		self:IsState(ClimbState.ClimbStart2) or
		self:IsState(ClimbState.ClimbJumpOver) or
		self:IsState(ClimbState.ClimbRunOver) or
		self:IsState(ClimbState.StrideOver) or
		self:IsState(ClimbState.ClimbLand) then
		return
	end
	
	if self:IsState(ClimbState.ClimbRun) then
		self:SwitchState(ClimbState.ClimbRunEnd)
	else 
		self:SwitchState(ClimbState.Idle)
	end
	
	self.climbRun = false
end

-- 进入状态时希望动画完整播放完，不会进入PhysicClimbing判断
function ClimbFSM:ShouldForbidPhysicClimbing()
	if self:IsState(ClimbState.ClimbJumpOver) or
			self:IsState(ClimbState.ClimbRunOver) or
			self:IsState(ClimbState.StrideOver)--[[ or
			self:IsState(ClimbState.StartClimb)]]
	then
		
		return true
	end
	
	return false
end

function ClimbFSM:ForceLeaveClimb()
	self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
end

-- 设置攀跑状态
function ClimbFSM:SetClimbingRun(state)
	if self.climbRun == state then return end

	self.climbRun = state

	local moveVector = self.fight.operationManager:GetMoveEvent()
    if not moveVector then
        return
    end
	
	if (self:IsState(ClimbState.Idle) or self:IsState(ClimbState.Climbing)) and self.climbRun then
		-- 长按S和攀跑按钮时切换为静止
		if moveVector.x == 0 and moveVector.y == -1 then
			self:SwitchState(ClimbState.Idle)
			return
		else
			self:SwitchState(ClimbState.ClimbRunStart)
		end
	elseif (self:IsState(ClimbState.ClimbRun) or self:IsState(ClimbState.ClimbRunStart)) and not self.climbRun then
		self:SwitchState(ClimbState.ClimbRunEnd)
	end
end
	
function ClimbFSM:SetClimbState(state)
	self:SwitchState(state)
end

function ClimbFSM:CanMove()
	return not self:IsState(ClimbState.StartClimb)
end

function ClimbFSM:CanChangeRole()
	if self.statesMachine.CanChangeRole then
		return self.statesMachine:CanChangeRole()
	end

	return false
end

function ClimbFSM:Reset()
	self:SwitchState(ClimbState.None)
	self.entity.logicMove = false

	if self.entity.climbComponent then
		-- 恢复设置KCC胶囊体半径和高度
		self.entity.climbComponent:ResetClimbCapsuleRadiusAndHeight()

		if not self.entity.climbComponent.climbToStrideOver then
			local euler = self.entity.transformComponent:GetRotation():ToEulerAngles()
			local rotation = Quat.Euler(0, euler.y, 0)
			self.entity.transformComponent:SetRotation(rotation)
		end
	end
end

function ClimbFSM:OnLeave()
	self:Reset()
end

function ClimbFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(ClimbFSM, self)
end

function ClimbFSM:__delete()

end