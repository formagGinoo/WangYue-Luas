ClimbRunLeftStartMachine = BaseClass("ClimbRunLeftStartMachine",MachineBase)

function ClimbRunLeftStartMachine:__init()

end

function ClimbRunLeftStartMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunLeftStartMachine:OnEnter()
    self.entity.logicMove = false
    self.time = 18 * FightUtil.deltaTimeSecond  -- 动画帧数
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunLeftStart)
    end
end

function ClimbRunLeftStartMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(-1, 0, 0)     -- 左方向
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunLeft)
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunLeftEnd)
        end
    end
end

function ClimbRunLeftStartMachine:OnLeave()
    self.entity.logicMove = true
end

function ClimbRunLeftStartMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunLeftStartMachine,self)
end

function ClimbRunLeftStartMachine:__cache()

end

function ClimbRunLeftStartMachine:__delete()

end