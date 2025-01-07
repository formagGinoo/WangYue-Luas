ClimbRunEndMachine = BaseClass("ClimbRunEndMachine",MachineBase)

local ClimbState = FightEnum.EntityClimbState

function ClimbRunEndMachine:__init()

end

function ClimbRunEndMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunEndMachine:LateInit()
    if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
        self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
    end

    self.climbComponent = self.entity.climbComponent
end

function ClimbRunEndMachine:OnEnter()
    self.entity.logicMove = false
    self.entity.clientTransformComponent:SetUseRenderAniMove(true)

    local moveVector = self.entity.climbComponent:GetLastClimbRunVector()
    if not moveVector then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
        return 
    end

    if self.animator then
        self.animator:SetFloat("moveVectorX", moveVector.x)
        self.animator:SetFloat("moveVectorY", moveVector.y)
    end
    
    self.time = 30 * FightUtil.deltaTimeSecond                      -- 动画总帧数
    self.climbableTime = 22 * FightUtil.deltaTimeSecond             -- 可攀爬帧数
    self.jumpRunSwitchableTime = 17 * FightUtil.deltaTimeSecond     -- 可切换至攀跳、攀跑帧数
    self.reverseTime = 6 * FightUtil.deltaTimeSecond                -- 可切换反方向打断参数
    
    self.startFrame = 0                                             -- 帧计数用
    self.isFirst = true
    self.checkJumpFrame = 0                                         -- 缓存按键输入，暂定4帧
    
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunEnd)
        --print("ClimbRunEnd", moveVector.x, moveVector.y)
    end
end

function ClimbRunEndMachine:Update()
    --LogError("ClimbRunEndMachine:Update()"..self.fight.fightFrame)
    if self.isFirst then
        self.startFrame = self.fight.fightFrame
        self.isFirst = false
    end

    if self.fight.operationManager:CheckJump() then
        self.checkJumpFrame = 6 * FightUtil.deltaTimeSecond
    end
    
    -- 离开攀爬按键
    if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
        return
    end
    
    self.time = self.time - FightUtil.deltaTimeSecond
    self.jumpRunSwitchableTime = self.jumpRunSwitchableTime - FightUtil.deltaTimeSecond
    self.climbableTime = self.climbableTime - FightUtil.deltaTimeSecond
    self.reverseTime = self.reverseTime - FightUtil.deltaTimeSecond
    if self.checkJumpFrame > 0 then
        self.checkJumpFrame = self.checkJumpFrame - FightUtil.deltaTimeSecond
    end

    local moveVector = self.fight.operationManager:GetMoveEvent()
    local lastRunVector = self.entity.climbComponent:GetLastClimbRunVector()
    
    -- 反方向攀跑可打断参数，需要将当前输入帧与上一帧进行比较
    if self.reverseTime <= 0 then
        if moveVector and self.climbFSM.climbRun then
            if moveVector.x == 0 and moveVector.y < 0 then
                --self.climbFSM:SwitchState(ClimbState.Idle)
                --return
            elseif moveVector.x > 0 and lastRunVector.x < 0 or moveVector.x < 0 and lastRunVector.x > 0 then
                --LogError("反向攀跑可打断，当前经历帧数为：" .. self.fight.fightFrame - self.startFrame)
                self.climbFSM:SwitchState(ClimbState.ClimbRunStart)
                return
            end
        end
    end
    
    -- 攀跳，攀跑可打断参数
    if self.jumpRunSwitchableTime <= 0 then
        -- 攀跳检测
        if self.checkJumpFrame > 0 then
            if moveVector then
                if moveVector.y < 0 then
                    local val = math.abs(moveVector.x) / math.abs(moveVector.y)
                    if math.abs(val) < 1.732 then			-- Y轴负方向正负60°区间内才可退出, tan60
                        self.entity.rotateComponent:DoRotate(0, 180, 0)
                        self.entity.clientTransformComponent:Async()
                        self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, true)
                        return
                    end
                else
                    --LogError("攀跳可打断，当前经历帧数为：" .. self.fight.fightFrame - self.startFrame)
                    self.climbFSM:SwitchState(ClimbState.ClimbJump)	-- 多向攀跳
                    return
                end
            else
                self.climbFSM:SwitchState(ClimbState.ClimbingJump)	-- 没有输入默认向上攀跳
                return
            end
        end
        
        -- 攀跑检测
        if moveVector and self.climbFSM.climbRun then
			if not (moveVector.x == 0 and moveVector.y < 0) then
				--LogError("攀跑起步可打断，当前经历帧数为：" .. self.fight.fightFrame - self.startFrame)
				self.climbFSM:SwitchState(ClimbState.ClimbRunStart)
				return
			end
        end
    end

    -- 攀爬可打断参数
    if self.climbableTime <= 0 then
        if moveVector and not self.climbFSM.climbRun then
            --LogError("攀爬可打断，当前经历帧数为：" .. self.fight.fightFrame - self.startFrame)
            self.climbFSM:SwitchState(ClimbState.Climbing)
            return
        end
    end
    
    -- 自然播放结束
    if self.time <= 0 then
        --LogError("攀跑停播放结束，当前经历帧数为：" .. self.fight.fightFrame - self.startFrame)
        self.climbFSM:SwitchState(ClimbState.Idle)
    end
end

function ClimbRunEndMachine:OnLeave()
    self.entity.logicMove = true
    
    self.entity.clientTransformComponent:SetUseRenderAniMove(false)
end

function ClimbRunEndMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunEndMachine, self)
end

function ClimbRunEndMachine:__cache()

end

function ClimbRunEndMachine:__delete()

end