ClimbRunRightEndMachine = BaseClass("ClimbRunRightEndMachine",MachineBase)

function ClimbRunRightEndMachine:__init()

end

function ClimbRunRightEndMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunRightEndMachine:OnEnter()
    self.entity.logicMove = false
    self.time = 18 * FightUtil.deltaTimeSecond      -- 动画帧数
    if self.entity.animatorComponent then
        self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunRightEnd)
        print("ClimbRunRightEndMachine")
    end
end

function ClimbRunRightEndMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(1, 0, 0)
    if self.time <= 0 then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
    end
end

function ClimbRunRightEndMachine:OnLeave()
    self.entity.logicMove = true
end

function ClimbRunRightEndMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunRightEndMachine,self)
end

function ClimbRunRightEndMachine:__cache()

end

function ClimbRunRightEndMachine:__delete()

end