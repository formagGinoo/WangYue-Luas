JumpFSM = BaseClass("JumpFSM", FSM)
local JumpState = FightEnum.EntityJumpState
local JumpParam = Config.EntityCommonConfig.JumpParam

function JumpFSM:__init()

end

function JumpFSM:Init(fight, entity)
    self.fight = fight
    self.entity = entity

    self.speedZ = 0
    self.isStandJump = false

    -- 记录是否在跳跃状态
    self.jumping = false

    -- 判断是玩家进入跳跃还是怪物
    self.isPlayer = false
    self.notPlayer = false

    self:InitStates()
end

function JumpFSM:InitStates()
    local objectPool = self.fight.objectPool
    self:AddState(JumpState.None, objectPool:Get(JumpNoneMachine))
    self:AddState(JumpState.JumpUp, objectPool:Get(JumpUpMachine))
    self:AddState(JumpState.JumpLand, objectPool:Get(JumpLandMachine))
    self:AddState(JumpState.JumpLandHard, objectPool:Get(JumpLandHardMachine))
    self:AddState(JumpState.JumpUpRun, objectPool:Get(JumpUpRunMachine))
    self:AddState(JumpState.JumpUpSprint, objectPool:Get(JumpUpSprintMachine))
    self:AddState(JumpState.JumpDown, objectPool:Get(JumpDownMachine))
    self:AddState(JumpState.JumpUpDouble, objectPool:Get(JumpUpDoubleMachine))
    self:AddState(JumpState.RunStartLand, objectPool:Get(RunStartLandMachine))
    self:AddState(JumpState.ProactiveDown, objectPool:Get(ProactiveDownMachine))
    self:AddState(JumpState.ProactiveLand, objectPool:Get(ProactiveLandMachine))
    self:AddState(JumpState.SprintStartLand, objectPool:Get(SprintStartLandMachine))
    self:AddState(JumpState.MonsterLand, objectPool:Get(MonsterLandMachine))
    self:AddState(JumpState.JumpLandRoll, objectPool:Get(JumpLandRollMachine))
    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end

    self:SwitchState(JumpState.None)
end

function JumpFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

---comment
---@param isSkill boolean 是不是在使用技能 落地不应用水平速度
---@param forceJump boolean 策划调用的跳跃都是起跳
function JumpFSM:StartJump(isSkill, forceJump, forceDown)
    self:CheckIsPlayer()
	self.jumping = true
    self.moveComponent = self.entity.moveComponent
    self.yMoveComponent = self.moveComponent.yMoveComponent
    self.stateComponent = self.entity.stateComponent
    self.moveComponent:SetAloft(true)

    self.speedZ = 0
    local speedY = 0

    if self.isPlayer then
        local isMoving = self.fight.operationManager:CheckMove() and not isSkill
        local moveMode = self.stateComponent:GetMoveMode()
        local isSprint = self.stateComponent:IsSprint()

        if isMoving then
            self.speedZ = isSprint and JumpParam.JumpSprintPlaneSpped or (moveMode == FightEnum.EntityMoveMode.Run and JumpParam.JumpRunPlaneSpeed or JumpParam.JumpPlaneSpeed)
        end

        if (not self.fight.operationManager:CheckJump() and not forceJump) or forceDown then
            speedY = self.yMoveComponent.speed == 0 and -2 or self.yMoveComponent.speed
            self:SwitchState(JumpState.JumpDown)
        elseif isSprint then
            speedY = JumpParam.JumpUpSprintSpeed
            self:SwitchState(JumpState.JumpUpSprint)
        elseif moveMode == FightEnum.EntityMoveMode.Run and isMoving then
            speedY = JumpParam.JumpUpRunSpeed
            self:SwitchState(JumpState.JumpUpRun)
        else
            speedY = JumpParam.JumpUpSpeed
            self.isStandJump = not isMoving
            self:SwitchState(JumpState.JumpUp)
        end
    end

    -- TODO 不知道以后怪物会不会跳
    if self.notPlayer then
        speedY = -2
        self:SwitchState(JumpState.JumpDown)
    end

    local paramsTable = {
        speedY = speedY,
        gravity = JumpParam.Gravity,
        accelerationY = JumpParam.JumpSpeedAcceleration,
        maxFallSpeed = JumpParam.MaxFallSpeed,
    }
    self.yMoveComponent:SetConfig(paramsTable, true)
end

function JumpFSM:CheckIsPlayer()
    if self.isPlayer or self.notPlayer then
        return
    end

    local player = self.fight.playerManager:GetPlayer()
    for i = 1, #player.entityInfos do
        if self.entity.instanceId == player.entityInfos[i].InstanceId then
            self.isPlayer = true
            break
        end

        if i == #player.entityInfos then
            self.notPlayer = true
        end
    end
end

function JumpFSM:Update()
    if not self.statesMachine or self.curState == JumpState.None then
        return
    end

    self:CheckIsPlayer()
    self.statesMachine:Update()

    if not self.moveComponent.isAloft and self.jumping then
        self:OnLand()
    end

    if self.isPlayer then
        local speedY = 0
        local speedYChange = false
        if self.yMoveComponent.isHitHead then
            speedY = 0
            speedYChange = true
            self:SwitchState(JumpState.JumpDown)
        -- elseif self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.Attack) and self:CanProactiveDown() then
            -- speedY = JumpParam.ProactiveDownSpeed
            -- speedYChange = true
            -- self:SwitchState(JumpState.ProactiveDown)
        elseif self.yMoveComponent:CheckDoDoubleJump() then
            speedY = JumpParam.JumpUpDoubleSpeed
            speedYChange = true

            self.speedZ = self:GetDoubleJumpSpeedZ()
            self:SwitchState(JumpState.JumpUpDouble)
            self.yMoveComponent.doDoubleJump = false
            self.yMoveComponent:SetDoubleJumpState(true)
        end

        if speedYChange then
            local paramsTable = {speedY = speedY}
            self.yMoveComponent:SetConfig(paramsTable, true)
        end
    end

    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.moveComponent:DoMoveForward(self.speedZ * time)
end

function JumpFSM:GetDoubleJumpSpeedZ()
    if not self.fight.operationManager:CheckMove() then
        return 0
    end

    local moveMode = self.entity.stateComponent:GetMoveMode()
    local isSprint = self.entity.stateComponent:IsSprint()
    if isSprint then
        return JumpParam.DoubleJumpSprintPlaneSpeed
    elseif moveMode == FightEnum.EntityMoveMode.Walk then
        return self.isStandJump and JumpParam.StandDoubleJumpPlaneSpeed or JumpParam.DoubleJumpPlaneSpeed
    elseif moveMode == FightEnum.EntityMoveMode.Run then
        return JumpParam.DoubleJumpRunPlaneSpeed
    end

    return self.speedZ
end

function JumpFSM:CanProactiveDown()
    local position = self.entity.transformComponent.position
    local height = self.fight.physicsTerrain:CheckTerrainHeight(position)
    if math.floor(JumpParam.ProactiveJumpDownHeight * 10000) - math.floor(height * 10000) > 500 then
        return false
    end

    return self.statesMachine:CanProactiveDown()
end

function JumpFSM:OnLand()
	local pos = self.entity.transformComponent.position
	BehaviorFunctions.CreateEntity(Config.EntityCommonConfig.LogicPlayEffect.JumpLand, nil, pos.x, pos.y, pos.z)
	
    if self.notPlayer then
        self:SwitchState(JumpState.MonsterLand)
    end

    if self.isPlayer then
        local moveMode = self.entity.stateComponent:GetMoveMode()
        local isSprint = self.entity.stateComponent:IsSprint()
        if self.curState == JumpState.ProactiveDown then
            self:SwitchState(JumpState.ProactiveLand)
		elseif moveMode == FightEnum.EntityMoveMode.InjuredWalk then
			self:SwitchState(JumpState.JumpLand)
        elseif self.fight.operationManager:CheckMove() and (not self.entity.handleMoveInputComponent or self.entity.handleMoveInputComponent.enabled) and (moveMode ~= FightEnum.EntityMoveMode.Walk or isSprint) and self.speedZ ~= 0 then
			if self.yMoveComponent:GetEndSpeed() <= Config.EntityCommonConfig.JumpParam.LandRollSpeed then
				self:SwitchState(JumpState.JumpLandRoll)
            elseif isSprint then
                self:SwitchState(JumpState.SprintStartLand)
            else
                self:SwitchState(JumpState.RunStartLand)
            end
        elseif self.yMoveComponent:GetEndSpeed() <= Config.EntityCommonConfig.JumpParam.LandHardSpeed then
            self:SwitchState(JumpState.JumpLandHard)
        else
            self:SwitchState(JumpState.JumpLand)
        end
    end

    self.speedZ = 0
	self.jumping = false
end

function JumpFSM:CanJump()
    if self.curState ~= JumpState.None or self.moveComponent.isAloft then
        return false
    end

    local position = self.entity.transformComponent.position
    local overHeadBlock = UnityUtils.GetDistanceOfOverHead(position.x, position.y + self.entity.collistionComponent.config.Height, position.z)
    if overHeadBlock ~= 0 and math.floor(0.5 * 10000) - math.floor(overHeadBlock * 10000) > 500 then
        return false
    end

    return true
end

function JumpFSM:CanMove()
    return self.statesMachine:CanMove()
end

function JumpFSM:CanCastSkill()
    return true
end

function JumpFSM:CanClimb()
	return true
end

function JumpFSM:CanPush()
	return self.speedZ ~= 0
end

function JumpFSM:CanChangeRole()
    if self:IsState(FightEnum.EntityJumpState.JumpDown) then
        return true
    elseif self.statesMachine.CanChangeRole then
        return self.statesMachine:CanChangeRole()
    end

    return false
end

function JumpFSM:Reset()
    self.isStandJump = false
    self:SwitchState(JumpState.None)
end

function JumpFSM:OnLeave()
    self:Reset()
end

function JumpFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(JumpFSM, self)
end

function JumpFSM:__delete()

end