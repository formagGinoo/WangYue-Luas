ClimbRunOverMachine = BaseClass("ClimbRunOverMachine",MachineBase)

local Vec3 = Vec3
local Quat = Quat

local AnimFrame = 19            -- 动画帧数
local SwitchableFrame = 18      -- 可打断帧数

function ClimbRunOverMachine:__init()

end

function ClimbRunOverMachine:Init(fight,entity)
    self.fight = fight
    self.entity = entity

    self.tempVec = Vec3.New(0, 0, 0)
    self.rotateSpeed = 20 * FightUtil.deltaTimeSecond
end

function ClimbRunOverMachine:OnEnter()
    self.entity.clientTransformComponent:SetUseRenderAniMove(true)
    self.entity.logicMove = true
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunOver)
    --print("ClimbRunOver")
    
    self.remainChangeTime = AnimFrame * FightUtil.deltaTimeSecond      -- 动画帧数
    self.switchableFrame = SwitchableFrame * FightUtil.deltaTimeSecond
end

function ClimbRunOverMachine:Update()
    --LogError("ClimbRunOverMachine time update: "..self.fight.fightFrame)
    self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
    self.switchableFrame = self.switchableFrame - FightUtil.deltaTimeSecond

    if self.remainChangeTime <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end

    if self.switchableFrame <= 0 then
        local moveVector = self.fight.operationManager:GetMoveEvent()
        if moveVector then
            self.entity.stateComponent:ChangeRole_SetSubState(FightEnum.EntityState.Move, FightEnum.EntityMoveSubState.Sprint)        -- 切换至移动
        end
        return
    end
end

function ClimbRunOverMachine:OnLeave()
    --LogError("ClimbRunOverMachine time OnLeave: "..self.fight.fightFrame)
    self.entity.logicMove = false
    local euler = self.entity.transformComponent:GetRotation():ToEulerAngles()
    local rotation = Quat.Euler(0, euler.y, 0)
    self.entity.transformComponent:SetRotation(rotation)

    self.entity.clientTransformComponent:SetUseRenderAniMove(false)
end

function ClimbRunOverMachine:CanMove()     
    return self.switchableFrame <= 0        -- 多少帧后可以切换至Move状态
end

function ClimbRunOverMachine:CanJump()
    return false
end

function ClimbRunOverMachine:CanClimb()
    return false
end

function ClimbRunOverMachine:CanCastSkill()
    return false
end

function ClimbRunOverMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunOverMachine, self)
end

function ClimbRunOverMachine:__cache()

end

function ClimbRunOverMachine:__delete()

end