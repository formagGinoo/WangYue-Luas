GlideFSM = BaseClass("GlideFSM", FSM)

function GlideFSM:Init(fight, entity, glideMachine)
    self.fight = fight
    self.entity = entity
    self.glideMachine = glideMachine

    self:InitState()
end

function GlideFSM:InitState()
    local objectPool = self.fight.objectPool
    self:AddState(FightEnum.GlideState.GlideStart, objectPool:Get(GlideStartMachine))
    self:AddState(FightEnum.GlideState.GlideLoop, objectPool:Get(GlideLoopMachine))
    self:AddState(FightEnum.GlideState.GlideLand, objectPool:Get(GlideLandMachine))
    self:AddState(FightEnum.GlideState.GlideLandRoll, objectPool:Get(GlideLandRollMachine))

    for k, v in pairs(self.states) do
        v:Init(self.fight, self.entity, self)
    end
end

function GlideFSM:LateInit()
    for k, v in pairs(self.states) do
        if v.LateInit then
            v:LateInit()
        end
    end
end

function GlideFSM:StartGlide(gliderGo)
    self.moveComponent = self.entity.moveComponent
    self.yMoveComponent = self.moveComponent.yMoveComponent

    self.glideing = true
    self.gliderGo = gliderGo
    local bindNode = "ItemCase_r"
    if self.moveComponent.config.GlideBindNode and self.moveComponent.config.GlideBindNode ~= "" then
        bindNode = self.moveComponent.config.GlideBindNode
    end
    local bindTrans = self.entity.clientEntity.clientTransformComponent:GetTransform(bindNode)
    for i = 0, bindTrans.childCount - 1 do
        UnityUtils.SetActive(bindTrans:GetChild(i).gameObject, false)
    end

    UnityUtils.SetActive(self.gliderGo, true)
    UnityUtils.SetActive(bindTrans.gameObject, true)
    UnityUtils.SetLocalPosition(self.gliderGo.transform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(self.gliderGo.transform, 90, 0, 0)

    self:SwitchState(FightEnum.GlideState.GlideStart)
end

function GlideFSM:BindGliderGo(gliderGo)
    if not self.moveComponent then
        self.moveComponent = self.entity.moveComponent
        self.yMoveComponent = self.moveComponent.yMoveComponent
    end

    self.glideing = true
    self.gliderGo = gliderGo
    local bindNode = "ItemCase_r"
    if self.moveComponent.config.GlideBindNode and self.moveComponent.config.GlideBindNode ~= "" then
        bindNode = self.moveComponent.config.GlideBindNode
    end
    local bindTrans = self.entity.clientEntity.clientTransformComponent:GetTransform(bindNode)
    for i = 0, bindTrans.childCount - 1 do
        UnityUtils.SetActive(bindTrans:GetChild(i).gameObject, false)
    end

    UnityUtils.SetActive(self.gliderGo, true)
    UnityUtils.SetActive(bindTrans.gameObject, true)
    UnityUtils.SetLocalPosition(self.gliderGo.transform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(self.gliderGo.transform, 90, 0, 0)
end

function GlideFSM:Update()
    if not self.moveComponent.isAloft and self.glideing then
        self:OnLand()
    end

    self.statesMachine:Update()

    local moveEvent = Fight.Instance.operationManager:GetMoveEvent()
    if moveEvent then
        local handleRotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
        local entityRot = self.entity.transformComponent:GetRotation()
        local angle = handleRotate:ToEulerAngles().y - entityRot:ToEulerAngles().y

        angle = math.max(1, math.abs(angle))

        local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
        self.moveComponent:DoMoveByMoveEvent(moveEvent, self:GetSpeedZ(math.abs(angle)) * time)
        self.entity.rotateComponent:SetVector(moveEvent.x, moveEvent.y)
    end

    local costValue = 0
    if self.entity.attrComponent then
        costValue = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.GlideCost)
    end
    BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue, costValue)
    if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurStaminaValue) <= 0 then
        self:EndGlide()
    end
end

function GlideFSM:GetSpeedZ(angle)
    if not self.glideing then
        return 0
    end

    local speedZ = self.moveComponent.config.GlideMoveSpeed
    if angle > 0 and angle < 90 then
        local turnSpeed = self.moveComponent.config.GlideTurnSpeed
        speedZ = turnSpeed + ((self.moveComponent.config.GlideMoveSpeed - turnSpeed) / angle)
    elseif angle > 90 then
        speedZ = self.moveComponent.config.GlideTurnBackSpeed
    end

    return speedZ
end

function GlideFSM:OnLand()
    self.glideing = false
    self.gliderGo:SetActive(false)

    self.yMoveComponent:SetGlideState(false, true)
    if self.fight.operationManager:CheckMove() then
        self:SwitchState(FightEnum.GlideState.GlideLandRoll)
    else
        self:SwitchState(FightEnum.GlideState.GlideLand)
    end
end

function GlideFSM:EndGlide()
    self.glideing = false
    self.gliderGo:SetActive(false)
    self.yMoveComponent:SetGlideState(false, true)
    self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
end

function GlideFSM:CanMove()
    return false
end

function GlideFSM:CanJump()
    return false
end

function GlideFSM:CanCastSkill()
    return true
end

function GlideFSM:CanClimb()
    return true
end

function GlideFSM:CanPush()
    return false
end

function GlideFSM:CanChangeRole()
    return self:IsState(FightEnum.GlideState.GlideLoop)
end

function GlideFSM:Reset()
	self.yMoveComponent:SetGlideState(false, true)
    self.entity.clientEntity.clientTransformComponent:CacheGlider(self.gliderGo)
    local bindNode = "ItemCase_r"
    if self.moveComponent.config.GlideBindNode and self.moveComponent.config.GlideBindNode ~= "" then
        bindNode = self.moveComponent.config.GlideBindNode
    end
    local bindTrans = self.entity.clientEntity.clientTransformComponent:GetTransform(bindNode)
    for i = 0, bindTrans.childCount - 1 do
        UnityUtils.SetActive(bindTrans:GetChild(i).gameObject, true)
    end

    UnityUtils.SetActive(bindTrans.gameObject, false)
    self.yMoveComponent:SetGlideState(false)
    self.entity.clientEntity.clientTransformComponent:GetTransform(bindNode).gameObject:SetActive(false)
end

function GlideFSM:OnLeave()
    self:Reset()
end

function GlideFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(GlideFSM, self)
end