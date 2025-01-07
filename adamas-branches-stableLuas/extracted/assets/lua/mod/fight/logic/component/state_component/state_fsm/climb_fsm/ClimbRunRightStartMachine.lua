ClimbRunRightStartMachine = BaseClass("ClimbRunRightStartMachine",MachineBase)

function ClimbRunRightStartMachine:__init()

end

function ClimbRunRightStartMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunRightStartMachine:OnEnter()
    self.entity.logicMove = false
    self.time = 18 * FightUtil.deltaTimeSecond  -- 动画帧数
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunRightStart)
    end
end

function ClimbRunRightStartMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(1, 0, 0)     -- 左方向
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunRight)
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunRightEnd)
        end
    end
end

function ClimbRunRightStartMachine:OnLeave()
    self.entity.logicMove = true
end

function ClimbRunRightStartMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunRightStartMachine,self)
end

function ClimbRunRightStartMachine:__cache()

end

function ClimbRunRightStartMachine:__delete()

end