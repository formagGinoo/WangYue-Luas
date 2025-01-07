CommonAnimBehavior = BaseClass("CommonAnimBehavior", BehaviorBase)


local CommonEnumAnim = {
    StartBehaviorAnim = "StartBehaviorAnim",
	EndBehaviorAnim = "EndBehaviorAnim"
}

function CommonAnimBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonAnimBehavior:InitConfig()
  

end

function CommonAnimBehavior:InitAnimConfig(fight, entity, m_commonBehaviorsAnim)
    self.fight = fight
    self.entity = entity
    self.tempDir = Vec3.New()
    self.m_commonBehaviorsAnim = m_commonBehaviorsAnim
    
end

function CommonAnimBehavior:WorldInteractClick(uniqueId, instanceId)
	if self.m_commonBehaviorsAnim then --配置了通用行为动作才往下执行
	    if instanceId == self.entity.instanceId then
	        --进入操控状态
	        local driverInstanceId = BehaviorFunctions.GetCtrlEntity()
	        self:onDroneDrive(instanceId, driverInstanceId, true)
	    end
	end
end


--isClickInteract :是否是点击上车按钮的
function CommonAnimBehavior:onDroneDrive(targetInstanceId, driverInstanceId, isClickInteract)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    if self.curDriveId then
        return
    end
    self.curDriveId = driverInstanceId
    self.driver = BehaviorFunctions.GetEntity(self.curDriveId)

    --先走到固定的点位
    --获取固定点位
    if self.entity.clientTransformComponent and not self.leftDoor then
        local point = self.m_commonBehaviorsAnim.StartBehaviorAnim.m_checkName
        self.leftDoor = self.entity.clientTransformComponent:GetTransform(point)
    end
    --去掉玩家碰撞
    BehaviorFunctions.DoMagic(1, self.curDriveId, 1000055)
    BehaviorFunctions.SetPartEnableCollision(self.driver.instanceId, "Body", false)
    BehaviorFunctions.SetPartEnableHit(self.driver.instanceId, "Body", false)
    
    local callback = function()
        local eulerAngles = self.leftDoor.eulerAngles
        BehaviorFunctions.DoSetPosition(self.curDriveId, self.leftDoor.position.x, self.leftDoor.position.y, self.leftDoor.position.z)
        BehaviorFunctions.SetEntityEuler(self.curDriveId,eulerAngles.x,eulerAngles.y,eulerAngles.z)
        local params = {StartBehaviorAnim = self.m_commonBehaviorsAnim.StartBehaviorAnim, targetInstanceId = targetInstanceId}
        --人播放一个开车门的动作
        self.driver.stateComponent:SetState(FightEnum.EntityState.CommonAnim, params)
        --车播放一个被开门的动作
        if self.entity.animatorComponent then
            self.entity.animatorComponent:PlayAnimation(self.m_commonBehaviorsAnim.StartBehaviorAnim.m_animName)
        end
    end

    BehaviorFunctions.DoLookAtTargetByLerp(driverInstanceId, targetInstanceId, true,0, 180, -2)
    self.driver.stateComponent:SetState(FightEnum.EntityState.Move)
    --寻路过去
    self.driver.moveComponent:PreciseMoveTo(self.m_commonBehaviorsAnim.StartBehaviorAnim.m_preciseMoveFrame, self.leftDoor.position, callback)
end


function CommonAnimBehavior:OnStopCommonDrive(targetInstanceId)
    if not self.m_commonBehaviorsAnim or not self.m_commonBehaviorsAnim.EndBehaviorAnim then 
        return
    end
    if targetInstanceId ~= self.entity.instanceId then
        return
    end

    --获取固定点位
    if not self.getOffCarCheck then
        local point = self.m_commonBehaviorsAnim.EndBehaviorAnim.m_checkName
        self.getOffCarCheck = self.entity.clientTransformComponent:GetTransform(point)
    end
    if self.getOffCarCheck then
        local myPos = self.getOffCarCheck.position or self.rootTransform.position
        local eulerAngles = self.getOffCarCheck.eulerAngles
        BehaviorFunctions.DoSetPosition(self.curDriveId, myPos.x, myPos.y, myPos.z)
        BehaviorFunctions.SetEntityEuler(self.curDriveId,eulerAngles.x,eulerAngles.y,eulerAngles.z)
    end

    BehaviorFunctions.SetPartEnableHit(self.driver.instanceId, "Body", true)
    BehaviorFunctions.SetPartEnableCollision(self.driver.instanceId, "Body", true)

    if self.entity.collistionComponent then
        self.entity.collistionComponent:SetPresentationOnlyTrigger(false)
        self.entity.clientTransformComponent:SetLuaControlEntityMove(true)
    end
    
    --车播放一个被开门的动作
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(self.m_commonBehaviorsAnim.EndBehaviorAnim.m_animName)
    end
    --下车播动作
    self.driver.stateComponent:SetCommonAnimState(FightEnum.CommonAnimState.CommonAnimEnd, {EndBehaviorAnim = self.m_commonBehaviorsAnim.EndBehaviorAnim}, function()
        --玩家碰撞
        BehaviorFunctions.RemoveBuff(self.curDriveId, 1000055)
        self.curDriveId = nil
        self.driver = nil
    end)
end

