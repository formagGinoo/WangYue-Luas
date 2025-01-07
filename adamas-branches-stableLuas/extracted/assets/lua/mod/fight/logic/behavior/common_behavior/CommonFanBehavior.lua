CommonFanBehavior = BaseClass("CommonFanBehavior", BehaviorBase)

local BF = BehaviorFunctions
local consoleId = 2080103
function CommonFanBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonFanBehavior:InitConfig(fight, entity, force, windForce, attenuationDistance)
    self.fight = fight
    self.entity = entity
    self.isActive = false
    self.windForce = windForce
    self.attenuationDistance = attenuationDistance
    local windDirection = self.entity.clientTransformComponent:GetTransform("WindDirection")
    self.windDirection = Vec3.CreateByUnityVec3(windDirection.forward)
    self.force = self.windDirection * -force
end

function CommonFanBehavior:Update()
    if self.entity.triggerComponent and self.entity.jointComponent and self.entity.jointComponent.jointCtrl then
        local consoleInstanceId = self.entity.jointComponent.jointCtrl:CheckEntityByEntityId(consoleId)
        --TODO 先出效果，下版本推进交互组件改版
        if consoleInstanceId then
            self.entity.triggerComponent.enabled = false
            self.entity:RemoveInteractItem(self.entity.triggerComponent.defaultInteractId)
            self.entity.triggerComponent:InvokeEvent(false, Fight.Instance.playerManager:GetPlayer())
        else
            self.entity.triggerComponent.enabled = true
        end
    end

    if self.isActive then
        self.entity.clientTransformComponent:ResetConstantForce()
        --上方向 * 世界朝向 = 力的方向
        --没有父/子实体时，自身不受力
        if #self.entity.jointComponent.childIdList ~= 0 or #self.entity.jointComponent.parentIdList ~= 0 then
            self.entity.clientTransformComponent:AddConstantForce(0, 0, 0, self.force.x, self.force.y, self.force.z)
        end
    end
end

function CommonFanBehavior:OnActiveJointEntity(instanceId, isActive)
    if instanceId == self.entity.instanceId then
        self.isActive = isActive
        if self.isActive then
            self:OnFanActive()
        else
            self:OnFanUnActive()
        end
    end
end

function CommonFanBehavior:OnFanActive()
    --风扇激活，播对应动作和特效
end

function CommonFanBehavior:OnFanUnActive()
    --风扇关闭，移除对应动作和特效
    self.entity.clientTransformComponent:ResetConstantForce()
end