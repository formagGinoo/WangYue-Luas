JumpLandRollMachine = BaseClass("JumpLandRollMachine", MachineBase)

function JumpLandRollMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function JumpLandRollMachine:OnEnter()
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpLandRoll]
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpLandRoll)
    --self.entity.stateComponent:SetSprintState(false)
	
	local moveVector = self.fight.operationManager:GetMoveEvent()
	local rotate = Quat.LookRotationA(moveVector.x,0,moveVector.y)
	self.entity.rotateComponent:SetRotation(rotate)
	
	self.checkHardLandHurt = false
end

function JumpLandRollMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

	-- if self.passDuration > 0.02 and not self.checkHardLandHurt then
	-- 	self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
	-- 	self.checkHardLandHurt = true
	-- 	if self.entity.stateComponent:IsState(FightEnum.EntityState.Death) then
	-- 		return
	-- 	end
	-- end

    if self.passDuration >= Config.EntityCommonConfig.JumpParam.LandRollBreakTime then
        if self.fight.operationManager:CheckMove() then
            self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
            self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StartMove()
            return
        elseif self.fight.operationManager:CheckJump() then
            self.jumpFSM:Reset()
            self.jumpFSM:StartJump()
            return
        end
    end

    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function JumpLandRollMachine:OnLeave()
	self.duration = 0
	self.passDuration = 0

	-- if not self.checkHardLandHurt then
	-- 	self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
	-- 	self.checkHardLandHurt = true
	-- end
end

function JumpLandRollMachine:CanMove()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.LandRollBreakTime
end

function JumpLandRollMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.LandRollBreakTime
end

function JumpLandRollMachine:CanLand()
    return false
end

function JumpLandRollMachine:CanDoubleJump()
    return false
end

function JumpLandRollMachine:CanProactiveDown()
    return false
end

function JumpLandRollMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function JumpLandRollMachine:OnCache()
    self.fight.objectPool:Cache(JumpLandRollMachine, self)
end