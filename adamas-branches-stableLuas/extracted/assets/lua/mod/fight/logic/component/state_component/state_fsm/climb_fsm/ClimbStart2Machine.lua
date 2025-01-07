ClimbStart2Machine = BaseClass("ClimbStart2Machine",MachineBase)

function ClimbStart2Machine:__init()

end

function ClimbStart2Machine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbStart2Machine:LateInit()
    if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
        self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
    end
end

function ClimbStart2Machine:OnEnter()
    self.entity.logicMove = false    -- 使用动画逻辑位移
    self.time = 22 * FightUtil.deltaTimeSecond                -- 完整动画帧数

    local moveVector = self.fight.operationManager:GetMoveEvent()
    if moveVector then
        moveVector = moveVector.normalized
		self.moveVectorX = moveVector.x or 0
		self.moveVectorY = moveVector.y or 0
		self.entity.climbComponent:UpdateLastClimbRunVector(self.moveVectorX, self.moveVectorY)
    end
    
    if self.entity.animatorComponent then
        --print("ClimbStart2")
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbStart2)
    end
end

function ClimbStart2Machine:Update()
    --LogError("StartClimbMachine:Update()"..self.fight.fightFrame)
    self.time = self.time - FightUtil.deltaTimeSecond
    
    if self.time <= 0 then
        if self.fight.operationManager:CheckMove() then
            if self.climbFSM.climbRun then
                self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRun)
            else
                self.climbFSM:SwitchState(FightEnum.EntityClimbState.Climbing)
            end
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
        end
    end
end

function ClimbStart2Machine:OnLeave()
    self.entity.logicMove = true
    
    -- 根据人物体型修改KCC碰撞体半径和高度
    self.entity.climbComponent:SetClimbCapsuleRadiusAndHeight()
end

function ClimbStart2Machine:OnCache()
    self.fight.objectPool:Cache(ClimbStart2Machine,self)
end

function ClimbStart2Machine:__cache()

end

function ClimbStart2Machine:__delete()

end