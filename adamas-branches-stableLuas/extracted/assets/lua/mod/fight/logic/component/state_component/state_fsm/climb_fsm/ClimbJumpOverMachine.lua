ClimbJumpOverMachine = BaseClass("ClimbJumpOverMachine",MachineBase)

local Vec3 = Vec3
local Quat = Quat

local AnimFrame = 54            -- 动画帧数
local SwitchableFrame = 18      -- 可打断帧数

function ClimbJumpOverMachine:__init()

end

function ClimbJumpOverMachine:Init(fight,entity)
    self.fight = fight
    self.entity = entity
    self.tempVec = Vec3.New(0, 0, 0)
end

function ClimbJumpOverMachine:OnEnter()
    self.entity.clientTransformComponent:SetUseRenderAniMove(true)
    self.entity.logicMove = true
    self.startFrame = self.fight.fightFrame
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbJumpOver)
    self.remainChangeTime = AnimFrame * FightUtil.deltaTimeSecond
    self.switchableFrame = SwitchableFrame * FightUtil.deltaTimeSecond
    
    --print("ClimbJumpOver")
end

function ClimbJumpOverMachine:Update()
    self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
    self.switchableFrame = self.switchableFrame - FightUtil.deltaTimeSecond
    
    if self.remainChangeTime <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end

    if self.switchableFrame <= 0 then
        local moveVector = self.fight.operationManager:GetMoveEvent()
        if moveVector then
            self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
        end
    end
end

function ClimbJumpOverMachine:OnLeave()
    --LogError("ClimbRunOverMachine total frame: " .. self.fight.fightFrame - self.startFrame)
    self.entity.logicMove = false

    local euler = self.entity.transformComponent:GetRotation():ToEulerAngles()
    local rotation = Quat.Euler(0, euler.y, 0)
    self.entity.transformComponent:SetRotation(rotation)
    self.entity.clientTransformComponent:SetUseRenderAniMove(false)
end

function ClimbJumpOverMachine:CanMove()

end

function ClimbJumpOverMachine:CanJump()
    return false
end

function ClimbJumpOverMachine:CanClimb()
    return false
end

function ClimbJumpOverMachine:CanCastSkill()
    return false
end

function ClimbJumpOverMachine:OnCache()
    self.fight.objectPool:Cache(ClimbJumpOverMachine, self)
end

function ClimbJumpOverMachine:__cache()

end

function ClimbJumpOverMachine:__delete()

end