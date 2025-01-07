GlideFSM = BaseClass("GlideFSM", FSM)

local glideMaxSpeed = 0.15
local checkRotateMaxEuler = 40
local checkRotateMinEuler = -40
local accSpeedAllTime = 0.2

local interpolationFactor = 0.05
local interpolationSpeed = 0.5 -- 调整插值速度
local addEulerVal

function GlideFSM:Init(fight, entity, glideMachine)
    self.fight = fight
    self.entity = entity
    self.glideMachine = glideMachine

    self:InitState()

    EventMgr.Instance:AddListener(EventName.OnEntityLand, self:ToFunc("OnLand"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("ResetRotateMoveSpeed"))
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

function GlideFSM:GetGlideState(state)
    return self.states[state]
end

function GlideFSM:StartGlide(gliderGo)
    self.isOn = true
    self.moveComponent = self.entity.moveComponent
    self.yMoveComponent = self.moveComponent.yMoveComponent

    self.glideing = true
    self.gliderGo = gliderGo
    local bindNode = "ItemCase_r"
    if self.moveComponent.config.GlideBindNode and self.moveComponent.config.GlideBindNode ~= "" then
        bindNode = self.moveComponent.config.GlideBindNode
    end
    local bindTrans = self.entity.clientTransformComponent:GetTransform(bindNode)
    for i = 0, bindTrans.childCount - 1 do
        UnityUtils.SetActive(bindTrans:GetChild(i).gameObject, false)
    end

    UnityUtils.SetActive(self.gliderGo, true)
    local canShowGlideObj = self.moveComponent.config.canShowGlideObj
    if not canShowGlideObj and canShowGlideObj ~= false then
        canShowGlideObj = true
    end
    UnityUtils.SetActive(bindTrans.gameObject, canShowGlideObj)
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
    local bindTrans = self.entity.clientTransformComponent:GetTransform(bindNode)
    for i = 0, bindTrans.childCount - 1 do
        UnityUtils.SetActive(bindTrans:GetChild(i).gameObject, false)
    end

    UnityUtils.SetActive(self.gliderGo, true)
    UnityUtils.SetActive(bindTrans.gameObject, true)
    UnityUtils.SetLocalPosition(self.gliderGo.transform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(self.gliderGo.transform, 90, 0, 0)
end

function GlideFSM:UpdateGlideStateInfo(isDec)
    -- self.speedTime = 0
    self.rotateDecTime = isDec and glideMaxSpeed or nil
    self.rotateAddTime = isDec and self.rotateAddTime or 0
    -- self.startRotateY = isDec and nil or self.startRotateY
    self.isDec = isDec
    self.isEnd = false
end

function GlideFSM:Update()
    self.statesMachine:Update()
    local moveEvent = Fight.Instance.operationManager:GetMoveEvent()
    if moveEvent then
        if self.isDec then
            self.speedTime = 0
            self:UpdateGlideStateInfo(false)
            self.triggerEventTime = Time.fixedTime
            if self.curSpeed and self.curSpeed ~= 0 then
                self.speedTime =  (self.curSpeed / glideMaxSpeed) * accSpeedAllTime
            end
        end

        self.cacheMoveEvent = self.cacheMoveEvent or {}
        self.cacheMoveEvent.x = moveEvent.x
        self.cacheMoveEvent.y = moveEvent.y
        self:UpdateEntityGlide(moveEvent, false)
    else
        self.isFixedEuler = false
        self.targetEuler = nil
        self.startEuler = nil
        
        if self.cacheMoveEvent then
            if not self.isDec then
                local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
                self.speedTime = time
                self:UpdateGlideStateInfo(true)
            end
            self:UpdateEntityGlide(self.cacheMoveEvent, true)
        end
    end

    local costValue = 0
    if self.entity.attrComponent then
        costValue = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.GlideCost)
    end

    if not BehaviorFunctions.HasEntitySign(1,10000012) then
        BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue, costValue)
    end

    if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurStaminaValue) <= 0 then
        self:EndGlide()
    end
end


function GlideFSM:UpdateEntityGlide(moveEvent, isDec)
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    
    self.curSpeed = self.curSpeed or 0
    local fixSpeed
    local speed
    if not isDec then
        fixSpeed = self:GetRotateToMoveSpeed(moveEvent, time)
    end

    if not fixSpeed then
        speed = self:GetSpeedZ(not isDec)
    end

    speed = fixSpeed or speed
    if speed <= 0 and isDec then
        self.cacheMoveEvent = nil
        return
    end

    if fixSpeed then
        self.moveComponent:DoMoveByMoveEvent(moveEvent, speed)
    else
        self.moveComponent:DoMoveForward(speed)
    end
end

local addVal = 0.03
function GlideFSM:GetSpeedZ(isAcc, addTime)
    local targetSpeed = isAcc and glideMaxSpeed or 0
    local time = isAcc and accSpeedAllTime or 0.5
    self.speedTime = self.speedTime or 0
    if self.speedTime >= time then
        self.speedTime = time
        return targetSpeed, targetSpeed
    end
    local startSpeed = isAcc and 0 or self.curSpeed
    local t = self.speedTime / time
    local curSpeed = (1 - t) * startSpeed + t * targetSpeed
    self.speedTime = self.speedTime + addVal
    self.curSpeed = curSpeed
    return curSpeed, targetSpeed
end

function GlideFSM:NormalizeEuler(value)
	if value < -180 then
		value = value + 360
	elseif value > 180 then
		value = value - 360
	end
	return value
end

function GlideFSM:UpdateRotate(moveEvent)
    local eulerVal = 6
    local glideLoop = self:GetGlideState(FightEnum.GlideState.GlideLoop)
    local state, animName = glideLoop:GetGlideLoopStateAnimation()
    if state and (not self.glideAnimState or self.glideAnimState ~= state) then
        local nName, data = self.entity.animatorComponent:GetAnimFusionData(animName)
        if data then
            local time = data.fusionFrame * FightUtil.deltaTimeSecond
            self.switchAnimTime = time
            self.glideAnimState = state
        end
    end

    if self.switchAnimTime and self.switchAnimTime > 0 then
        self.switchAnimTime = self.switchAnimTime - FightUtil.deltaTimeSecond
        eulerVal = 4
    end


    local handleRotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
    local handleEuler = handleRotate:ToEulerAngles()
    local handleNormalY = self:NormalizeEuler(math.ceil(handleEuler.y))

    local entityRot = self.entity.transformComponent:GetRotation()
    local entityEuler = entityRot:ToEulerAngles()
    local entityNormalY = self:NormalizeEuler(math.ceil(entityEuler.y))
    local decVal = math.abs(handleNormalY - entityNormalY)

    if decVal <= 6 then
        entityNormalY = handleNormalY
    else
        local val = self:NormalizeEuler(handleNormalY - entityNormalY)
        local newVal = val > 0 and eulerVal or 0 - eulerVal
        entityNormalY = entityNormalY + newVal
    end
    local toRot = Quat.Euler(entityEuler.x + handleEuler.x, entityNormalY, entityEuler.z + handleEuler.z)
	self.entity.transformComponent:SetRotation(toRot)
end

function GlideFSM:ResetRotateMoveSpeed(key, value)
    if key ~= FightEnum.KeyEvent.Move then return end
    if not self.targetEuler then return end
    self.targetEuler = nil
end

function GlideFSM:GetRotateToMoveSpeed(moveEvent, time)
    local handleRotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
    local fixedSpeed
    local entityRot = self.entity.transformComponent:GetRotation()
    self:UpdateRotate(moveEvent)

    local euler = Quat.Angle(entityRot, handleRotate)
    self.targetEuler = self.targetEuler or euler

    if euler <= 1 then
        if self.isFixed then
            self.curSpeed = glideMaxSpeed
            self.speedTime = accSpeedAllTime
            self.isFixed = false
        end
        return
    end

    local precent = 1 - (euler / 180)
    precent = math.max(precent, 0)
    fixedSpeed = glideMaxSpeed * precent
    fixedSpeed = math.max(fixedSpeed, 0.04)
    self.curSpeed = fixedSpeed
    self.isFixed = true
    return fixedSpeed
end

function GlideFSM:OnLand(instanceId)
    if self.entity.instanceId ~= instanceId or not self.glideing  or not self.isOn then
        return
    end

    self.yMoveComponent:ClearConfig()
    self.glideing = false
    self.gliderGo:SetActive(false)
    self.yMoveComponent:SetGlideState(false, true)
    if not self.entity.stateComponent or not self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
        if self.fight.operationManager:CheckMove() then
            self:SwitchState(FightEnum.GlideState.GlideLandRoll)
        else
            self:SwitchState(FightEnum.GlideState.GlideLand)
        end
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

function GlideFSM:CanGlide()
    return true
end

function GlideFSM:CanChangeRole()
    return self:IsState(FightEnum.GlideState.GlideLoop)
end

function GlideFSM:Reset()
    self.isOn = false

    self.yMoveComponent:ClearConfig()
	self.yMoveComponent:SetGlideState(false, true)
    self.glideing = false
    self.entity.clientTransformComponent:CacheGlider(self.gliderGo)
    local bindNode = "ItemCase_r"
    if self.moveComponent.config.GlideBindNode and self.moveComponent.config.GlideBindNode ~= "" then
        bindNode = self.moveComponent.config.GlideBindNode
    end
    local bindTrans = self.entity.clientTransformComponent:GetTransform(bindNode)
    for i = 0, bindTrans.childCount - 1 do
        UnityUtils.SetActive(bindTrans:GetChild(i).gameObject, true)
    end

    UnityUtils.SetActive(bindTrans.gameObject, false)
    self.entity.clientTransformComponent:GetTransform(bindNode).gameObject:SetActive(false)
end

function GlideFSM:OnLeave()
    self:Reset()
end

function GlideFSM:OnCache()
    self:CacheStates()
    self.fight.objectPool:Cache(GlideFSM, self)

    EventMgr.Instance:RemoveListener(EventName.OnEntityLand, self:ToFunc("OnLand"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("ResetRotateMoveSpeed"))
end

function GlideFSM:__delete()
    EventMgr.Instance:RemoveListener(EventName.OnEntityLand, self:ToFunc("OnLand"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("ResetRotateMoveSpeed"))
end