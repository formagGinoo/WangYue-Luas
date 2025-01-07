JumpUpSprintMachine = BaseClass("JumpUpSprintMachine", MachineBase)

local JumpParam = Config.EntityCommonConfig.JumpParam

function JumpUpSprintMachine:__init()

end

function JumpUpSprintMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function JumpUpSprintMachine:LateInit()

end

function JumpUpSprintMachine:OnEnter()
	self.entity.logicMove = true
    local animationNames = Config.EntityCommonConfig.AnimatorNames

    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpUpSprint]
    local value = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.JumpCost)
    BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue, value)
    self.entity.animatorComponent:PlayAnimation(animationNames.JumpUpSprint)
end

function JumpUpSprintMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.duration <= 0 then
        if self.jumpFSM.yMoveComponent:GetSpeed() > 0 then
            -- 预留向上循环接口
        else
            self.jumpFSM:SwitchState(FightEnum.EntityJumpState.JumpDown)
        end
    end
end

function JumpUpSprintMachine:CanMove()
    return false
end

function JumpUpSprintMachine:CanCastSkill()
    return false
end

function JumpUpSprintMachine:CanLand()
    return true
end

function JumpUpSprintMachine:CanDoubleJump()
    return true
end

function JumpUpSprintMachine:CanProactiveDown()
    return self.passDuration >= JumpParam.ProactiveJumpDownTime
end

function JumpUpSprintMachine:CanChangeRole()
    return self.passDuration >= JumpParam.JumpUpChangeRoleTime
end

function JumpUpSprintMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
	self.entity.logicMove = false
end

function JumpUpSprintMachine:OnCache()
    self.fight.objectPool:Cache(JumpUpSprintMachine, self)
end