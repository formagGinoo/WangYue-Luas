SprintStartLandMachine = BaseClass("SprintStartLandMachine", MachineBase)

function SprintStartLandMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function SprintStartLandMachine:OnEnter()
    local animationNames = Config.EntityCommonConfig.AnimatorNames
    
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.SprintStartLand]
    self.entity.animatorComponent:PlayAnimation(animationNames.SprintStartLand)

    self.checkHardLandHurt = false
end

function SprintStartLandMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.passDuration > 0.02 and not self.checkHardLandHurt then
        self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
        self.checkHardLandHurt = true
        if self.entity.stateComponent:IsState(FightEnum.EntityState.Death) then
            return
        end
    end

    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
        self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StartMove()
        self.entity.stateComponent:SetSprintState(true)
    end

    if not self.fight.operationManager:CheckMove() then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
        self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StopMove()
        return
    elseif self.fight.operationManager:CheckJump() and self.passDuration >= Config.EntityCommonConfig.JumpParam.RunStartLandBreakTime then
        self.jumpFSM:Reset()
        self.jumpFSM:StartJump()
        return
    end

    local moveEvent = self.fight.operationManager:GetMoveEvent()
    if moveEvent then
        self.entity.rotateComponent:SetVector(moveEvent.x,moveEvent.y)
    end
end

function SprintStartLandMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0

    if not self.checkHardLandHurt then
        self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
        self.checkHardLandHurt = true
    end
end

function SprintStartLandMachine:CanLand()
    return false
end

function SprintStartLandMachine:CanMove()
    return false
end

function SprintStartLandMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.RunStartLandBreakTime
end

function SprintStartLandMachine:CanDoubleJump()
    return false
end

function SprintStartLandMachine:OnCache()
    self.fight.objectPool:Cache(SprintStartLandMachine, self)
end