ClimbJumpRightMachine = BaseClass("ClimbJumpRightMachine",MachineBase)

function ClimbJumpRightMachine:__init()

end

function ClimbJumpRightMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbJumpRightMachine:OnEnter()
    self.entity.logicMove = false

    self.time = 28 * FightUtil.deltaTimeSecond      -- 动画帧数
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbJumpRight)
    end

end

function ClimbJumpRightMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(1, 0, 0)
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            local state = FightEnum.EntityClimbState.Climbing
            if self.climbFSM.climbRun then
                state = FightEnum.EntityClimbState.ClimbRunRightStart
            end
            self.climbFSM:SwitchState(state)
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
        end
    end
end

function ClimbJumpRightMachine:OnLeave()
end

function ClimbJumpRightMachine:OnCache()
    self.fight.objectPool:Cache(ClimbJumpRightMachine,self)
end

function ClimbJumpRightMachine:__cache()

end

function ClimbJumpRightMachine:__delete()

end