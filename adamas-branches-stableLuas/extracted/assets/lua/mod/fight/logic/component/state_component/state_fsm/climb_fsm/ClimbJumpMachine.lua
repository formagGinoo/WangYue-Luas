ClimbJumpMachine = BaseClass("ClimbJumpMachine",MachineBase)

function ClimbJumpMachine:__init()

end

function ClimbJumpMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbJumpMachine:LateInit()
    if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
        self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
    end

    self.climbComponent = self.entity.climbComponent
end

function ClimbJumpMachine:OnEnter()
    self.entity.logicMove = false
    self.entity.clientTransformComponent:SetUseRenderAniMove(true)      -- 使用动画位移

    local moveVector = self.fight.operationManager:GetMoveEvent()
    if not moveVector then
        moveVector = Vec3.New(0, 0, 0)
    end
    
    if math.abs(moveVector.x) < 1e-8 and math.abs(moveVector.y) < 1e-8 then
        moveVector.x = 0
        moveVector.y = 1
    end
    
    self.moveVectorX = moveVector.x or 0
    self.moveVectorY = moveVector.y or 0

    if self.animator then
        self.animator:SetFloat("moveVectorX", self.moveVectorX)
        self.animator:SetFloat("moveVectorY", self.moveVectorY)
    end

    self.time = 55 * FightUtil.deltaTimeSecond      -- 动画帧数
    self.switchableTime = 30 * FightUtil.deltaTimeSecond
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbJump)
        --print("ClimbJump")
    end
end

function ClimbJumpMachine:Update()
    --LogError("ClimbJump time update: "..self.fight.fightFrame)
    self.time = self.time - FightUtil.deltaTimeSecond
    self.switchableTime = self.switchableTime - FightUtil.deltaTimeSecond
    
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            local state = FightEnum.EntityClimbState.Climbing
            if self.climbFSM.climbRun then
                state = FightEnum.EntityClimbState.ClimbRunStart
            end
            self.climbFSM:SwitchState(state)
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
        end
    end

    -- 打断帧
    if self.switchableTime <= 0 then
        -- 离开攀爬按键
        if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
            self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
            return
        end
        
        if self.fight.operationManager:CheckMove() or self.fight.operationManager:CheckJump() then
            local state = FightEnum.EntityClimbState.Climbing
            if self.climbFSM.climbRun then
                state = FightEnum.EntityClimbState.ClimbRunStart
            end
            self.climbFSM:SwitchState(state)
        end
    end
end

function ClimbJumpMachine:OnLeave()
    self.entity.logicMove = true
    self.entity.clientTransformComponent:SetUseRenderAniMove(false)
end

function ClimbJumpMachine:OnCache()
    self.fight.objectPool:Cache(ClimbJumpMachine,self)
end

function ClimbJumpMachine:__cache()

end

function ClimbJumpMachine:__delete()

end