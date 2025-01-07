GlideLoopMachine = BaseClass("GlideLoopMachine", MachineBase)

function GlideLoopMachine:Init(fight, entity, fsm)
    self.fight = fight
    self.entity = entity
    self.glideFSM = fsm

    -- 旋转角度
    self.rotateOffsetZ = 0
    self.rotateOffsetX = 0

    -- 固定数值
    self.maxAngle = 10
    self.angleSpeed = 0.25
    -- 记录一下转向前的角度
    self.lastAngle = 0
end

function GlideLoopMachine:OnEnter()
    self.animState = FightEnum.GlideLoopState.None
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GlideLoop)

    if not self.glideFSM.gliderGo then
        local gliderGo = self.entity.clientTransformComponent:BindGlider()
        self.glideFSM:BindGliderGo(gliderGo)
    end

    local gliderAnimator = self.glideFSM.gliderGo:GetComponentInChildren(Animator)
    gliderAnimator:Play(Config.EntityCommonConfig.AnimatorNames.GlideLoop)

    self.moveComponent = self.entity.moveComponent
    self.yMoveComponent = self.moveComponent.yMoveComponent
    local paramTable = {
        speedY = -self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.GlideSpeed),
        gravity = -10,
        accelerationY = 0,
        maxFallSpeed = -self.moveComponent.config.GlideDownSpeed,
    }
    self.yMoveComponent:SetConfig(paramTable, false)

    local entityRot = self.entity.transformComponent:GetRotation()
    self.lastAngle = entityRot:ToEulerAngles().y
end

function GlideLoopMachine:NormalizeEuler(value)
	if value < -180 then
		value = value + 360
	elseif value > 180 then
		value = value - 360
	end
	return value
end

function GlideLoopMachine:GetGlideLoopStateAnimation()
    if not self.animState then return end
    local animName = Config.EntityCommonConfig.AnimatorNames.GlideLoop
    if self.animState == FightEnum.GlideLoopState.Front then
        animName = Config.EntityCommonConfig.AnimatorNames.GlideLoopFront
    elseif self.animState == FightEnum.GlideLoopState.GlideLoopRight then
        animName = Config.EntityCommonConfig.AnimatorNames.GlideLoopRight
    elseif self.animState == FightEnum.GlideLoopState.GlideLoopLeft then
        animName = Config.EntityCommonConfig.AnimatorNames.GlideLoopLeft
    end

    return self.animState, animName
end

local CheckAngleVal = 0
local CheckTime = 0.5
function GlideLoopMachine:Update()
    -- 判断当前摇杆方向和镜头的朝向
    local moveEvent = Fight.Instance.operationManager:GetMoveEvent()
    if moveEvent then
        local handleRotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
        local entityRot = self.entity.transformComponent:GetRotation()
        local handleY = handleRotate:ToEulerAngles().y
        local entityY = entityRot:ToEulerAngles().y
        local angle = handleY - entityY
        angle = self:NormalizeEuler(angle)
        if not self.moveEventTime then
            self.moveEventTime = 0
            self.cacheAngle = self.cacheAngle or 0
            self.cacheAngle = self.cacheAngle + angle
        end

        self.moveEventTime = self.moveEventTime + FightUtil.deltaTimeSecond

        local actionOffset = self.lastAngle - entityY
        if self:CheckReverGlideState(angle) then
            if self.animState ~= FightEnum.GlideLoopState.Front then
                self.animState = FightEnum.GlideLoopState.Front
                self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GlideLoopFront)
            end

            -- if self.rotateOffsetZ ~= 0 then
            --     local isRight = self.rotateOffsetZ > 0 and -1 or 1
            --     self.rotateOffsetZ = self.rotateOffsetZ + (self.angleSpeed * isRight)
            -- end

            -- if self.rotateOffsetX < self.maxAngle then
            --     self.rotateOffsetX = self.rotateOffsetX + self.angleSpeed
            -- end
        elseif math.floor(angle) > 0 and math.abs(actionOffset) > CheckAngleVal then
            if self.animState ~= FightEnum.GlideLoopState.Right then
                self.animState = FightEnum.GlideLoopState.Right
                self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GlideLoopRight, nil, nil, nil, 0.5)
            end

            self.lastAngle = entityY
            -- if self.rotateOffsetZ > -self.maxAngle then
            --     self.rotateOffsetZ = self.rotateOffsetZ - self.angleSpeed
            -- end

            -- if self.rotateOffsetX ~= 0 then
            --     self.rotateOffsetX = self.rotateOffsetX - self.angleSpeed
            -- end
        elseif math.ceil(angle) < 0 and math.abs(actionOffset) > CheckAngleVal then
            if self.animState ~= FightEnum.GlideLoopState.Left then
                self.animState = FightEnum.GlideLoopState.Left
                self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GlideLoopLeft, nil, nil, nil, 0.5)
            end

            self.lastAngle = entityY
            -- if self.rotateOffsetZ < self.maxAngle then
            --     self.rotateOffsetZ = self.rotateOffsetZ + self.angleSpeed
            -- end

            -- if self.rotateOffsetX ~= 0 then
            --     self.rotateOffsetX = self.rotateOffsetX - self.angleSpeed
            -- end
        end
        
    else
        self.moveEventTime = nil
        self.cacheAngle = nil
        if self.animState ~= FightEnum.GlideLoopState.None then
            self.animState = FightEnum.GlideLoopState.None
            self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GlideLoop)
        end

        -- if self.rotateOffsetZ ~= 0 then
        --     local isRight = self.rotateOffsetZ > 0 and -1 or 1
        --     self.rotateOffsetZ = self.rotateOffsetZ + (self.angleSpeed * isRight)
        -- end

        -- if self.rotateOffsetX ~= 0 then
        --     self.rotateOffsetX = self.rotateOffsetX - self.angleSpeed
        -- end
    end
    -- self.entity.rotateComponent:DoModelXZRotate(self.rotateOffsetX, self.rotateOffsetZ)
end

function GlideLoopMachine:CheckReverGlideState(angle)
    if angle >= -15 and angle <= 15 then
        return true
    end
    return false
end

function GlideLoopMachine:CanMove()
    return false
end

function GlideLoopMachine:CanCastSkill()
    return true
end

function GlideLoopMachine:CanLand()
    return true
end

function GlideLoopMachine:CanDoubleJump()
    return false
end

function GlideLoopMachine:CanProactiveDown()
    return true
end

function GlideLoopMachine:OnLeave()
    self.rotateOffsetZ = 0
    self.rotateOffsetX = 0
end

function GlideLoopMachine:OnCache()
    self.fight.objectPool:Cache(GlideLoopMachine, self)
end