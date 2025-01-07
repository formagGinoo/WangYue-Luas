ClimbJumpLeftMachine = BaseClass("ClimbJumpLeftMachine",MachineBase)

function ClimbJumpLeftMachine:__init()

end

function ClimbJumpLeftMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbJumpLeftMachine:OnEnter()
    self.entity.logicMove = false

    self.time = 28 * FightUtil.deltaTimeSecond      -- 动画帧数
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbJumpLeft)
    end

end

function ClimbJumpLeftMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(-1, 0, 0)
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            local state = FightEnum.EntityClimbState.Climbing
            if self.climbFSM.climbRun then
                state = FightEnum.EntityClimbState.ClimbRunLeftStart     -- todo 后面要讨论不同情况下跳的方式
            end
            self.climbFSM:SwitchState(state)
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
        end
    end
end

function ClimbJumpLeftMachine:OnLeave()
end

function ClimbJumpLeftMachine:OnCache()
    self.fight.objectPool:Cache(ClimbJumpLeftMachine,self)
end

function ClimbJumpLeftMachine:__cache()

end

function ClimbJumpLeftMachine:__delete()

end