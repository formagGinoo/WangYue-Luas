ClimbRunStartMachine = BaseClass("ClimbRunStartMachine",MachineBase)

local ClimbState = FightEnum.EntityClimbState

function ClimbRunStartMachine:__init()

end

function ClimbRunStartMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunStartMachine:LateInit()
    if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
        self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
    end

    self.climbComponent = self.entity.climbComponent
end

function ClimbRunStartMachine:OnEnter()
    --LogError("ClimbRunStart OnEnter: "..self.fight.fightFrame)
    self.entity.logicMove = false
    self.entity.clientTransformComponent:SetUseRenderAniMove(true)
    
    self.time = 15 * FightUtil.deltaTimeSecond    -- 动画帧数
	self.CheckJumpFrame = 0						  -- 跳跃按键缓存

    local moveVector = self.fight.operationManager:GetMoveEvent()
    if not moveVector then
        self.climbFSM:SwitchState(ClimbState.ClimbRunEnd)
        return 
    end
    
    moveVector = moveVector.normalized
    self.moveVectorX = moveVector.x or 0
    self.moveVectorY = moveVector.y or 0
    
    if self.moveVectorY < 0 then                                -- 手柄操作Y轴输入为负时，当作输入为0
        self.moveVectorY = 0
        if moveVector.x == 0 then
            self.moveVectorX = 0                                        
        else
            self.moveVectorX = self.moveVectorX > 0 and 1 or -1         -- 要强制设为-1或者1，不然动作融合会向上
        end
    end

    if self.moveVectorX == 0 and self.moveVectorY == 0 then     -- 只按下S和攀跑按键时，切换跑停逻辑
        self.climbFSM:SwitchState(ClimbState.ClimbRunEnd)
        return
    end

    if self.animator then                                       -- 设置攀跑起步融合方向
        self.animator:SetFloat("moveVectorX", self.moveVectorX)
        self.animator:SetFloat("moveVectorY", self.moveVectorY)
    end

    self.climbComponent:UpdateLastClimbRunVector(self.moveVectorX, self.moveVectorY)
    
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunStart)
        --print("ClimbRunStart", self.moveVectorX, self.moveVectorY)
    end
end

function ClimbRunStartMachine:Update()
    --LogError("ClimbRunStart Update: "..self.fight.fightFrame)
    -- 离开攀爬按键
    if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
        return
    end
	
	if self.fight.operationManager:CheckJump() then
		self.CheckJumpFrame = 6 * FightUtil.deltaTimeSecond
	end
	
	if self.CheckJumpFrame > 0 then
		self.CheckJumpFrame = self.CheckJumpFrame - FightUtil.deltaTimeSecond
	end
    
	local moveVector = self.fight.operationManager:GetMoveEvent()
	
	if self.CheckJumpFrame > 0 then
		if moveVector then
			moveVector = moveVector.normalized
			if moveVector.y < 0 then
				local val = math.abs(moveVector.x) / math.abs(moveVector.y)
				if math.abs(val) < 1.732 then			-- Y轴负方向正负60区间内才可退出, tan60
					self.entity.rotateComponent:DoRotate(0, 180, 0)
					self.entity.clientTransformComponent:Async()
					self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, true)
					return
				end
			else
				self.climbFSM:SwitchState(ClimbState.ClimbJump)	-- 多向攀跳
				return
			end
		else
			self.climbFSM:SwitchState(ClimbState.ClimbingJump)	-- 没有输入默认向上攀跳
			return
		end
	end
	
    --self.entity.climbComponent:SetForceCheckDirection(self.moveVectorX, self.moveVectorY, 0)
    if not moveVector then
        self.climbFSM:SwitchState(ClimbState.ClimbRunEnd)
        return
    end

    moveVector = moveVector.normalized
    self.moveVectorX = moveVector.x or 0
    self.moveVectorY = moveVector.y or 0

    if self.moveVectorY < 0 then                                        -- 手柄操作Y轴输入为负时，当作输入为0
        self.moveVectorY = 0
        if moveVector.x == 0 then
            self.moveVectorX = 0                                        
        else
            self.moveVectorX = self.moveVectorX > 0 and 1 or -1         -- 要强制设为-1或者1，不然动作融合会向上
        end
    end

    if self.moveVectorX == 0 and self.moveVectorY == 0 then             -- 只按下S和攀跑按键时，切换跑停逻辑
        self.climbFSM:SwitchState(ClimbState.ClimbRunEnd)
        return
    end

    -- 如果X轴输入变换了象限，切换至跑停
    local lastMoveVector = self.climbComponent:GetLastClimbRunVector()
    if lastMoveVector.x < 0 and self.moveVectorX > 0 or lastMoveVector.x > 0 and self.moveVectorX < 0 then
        self.climbFSM:SwitchState(ClimbState.ClimbRunEnd)
        return
    end

    self.climbComponent:UpdateLastClimbRunVector(self.moveVectorX, self.moveVectorY)
    
    self.time = self.time - FightUtil.deltaTimeSecond
    
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            self.climbFSM:SwitchState(ClimbState.ClimbRun)
        else
            self.climbFSM:SwitchState(ClimbState.ClimbRunEnd)
        end
    end
end

function ClimbRunStartMachine:Move()
    
end

function ClimbRunStartMachine:OnLeave()
    self.entity.logicMove = true

    self.entity.clientTransformComponent:SetUseRenderAniMove(false)
end

function ClimbRunStartMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunStartMachine, self)
end

function ClimbRunStartMachine:__cache()

end

function ClimbRunStartMachine:__delete()

end