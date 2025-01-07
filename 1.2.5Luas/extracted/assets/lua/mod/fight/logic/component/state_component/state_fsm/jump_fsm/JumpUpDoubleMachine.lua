JumpUpDoubleMachine = BaseClass("JumpUpDoubleMachine", MachineBase)

local JumpParam = Config.EntityCommonConfig.JumpParam

function JumpUpDoubleMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.haveMoveDirection = false
    self.moveEvent = nil
    self.duration = 0
    self.passDuration = 0
end

function JumpUpDoubleMachine:OnEnter()
    self.haveMoveDirection = self.fight.operationManager:CheckMove()
    if self.haveMoveDirection then
        local moveEvent = self.fight.operationManager:GetMoveEvent()
        local rotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
        self.entity.rotateComponent:SetRotation(rotate)
    end

    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpUpDouble]
    BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue, -75)
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpUpDouble)
	
	local pos = self.entity.transformComponent.position
	BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.DoubleJump, nil, pos.x, pos.y, pos.z)
end

function JumpUpDoubleMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if not self.haveMoveDirection and self.fight.operationManager:CheckMove() then
        local moveEvent = self.fight.operationManager:GetMoveEvent()
        local rotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
        self.entity.rotateComponent:SetRotation(rotate)
        self.haveMoveDirection = true
    end

    if self.duration <= 0 then
		local speed = self.jumpFSM.yMoveComponent:GetSpeed() or 0
        if speed > 0 then
            -- 预留向上循环接口
        else
            self.jumpFSM:SwitchState(FightEnum.EntityJumpState.JumpDown)
        end
    end
end

function JumpUpDoubleMachine:CanMove()
    return false
end

function JumpUpDoubleMachine:CanCastSkill()
    return false
end

function JumpUpDoubleMachine:CanLand()
    return true
end

function JumpUpDoubleMachine:CanDoubleJump()
    return false
end

function JumpUpDoubleMachine:CanProactiveDown()
    return self.passDuration >= JumpParam.ProactiveJumpDownTime
end

function JumpUpDoubleMachine:CanChangeRole()
    return self.passDuration >= JumpParam.JumpUpChangeRoleTime
end

function JumpUpDoubleMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
    self.moveEvent = nil
end

function JumpUpDoubleMachine:OnCache()
    self.fight.objectPool:Cache(JumpUpDoubleMachine, self)
end