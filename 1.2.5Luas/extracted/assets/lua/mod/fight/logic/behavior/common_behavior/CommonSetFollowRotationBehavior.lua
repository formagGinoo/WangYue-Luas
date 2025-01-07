CommonSetFollowRotationBehavior = BaseClass("CommonSetFollowRotationBehavior", BehaviorBase)

---@param fight Fight
---@param entity Entity
function CommonSetFollowRotationBehavior:InitConfig(fight, entity)
    self.fight = fight
    self.entity = entity
    self.curSetFollowEntity = {}
end

function CommonSetFollowRotationBehavior:EnterTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    local entity = Fight.Instance.entityManager:GetEntity(playerId)
    if entity and entity.rotateComponent then
        entity.rotateComponent:SetFollowTarget(self.entity.instanceId)
        table.insert(self.curSetFollowEntity, playerId)
    end
end

function CommonSetFollowRotationBehavior:ExitTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    local entity = Fight.Instance.entityManager:GetEntity(playerId)
    if entity and entity.rotateComponent then
        entity.rotateComponent:RemoveFollowTarget()
        for k, v in pairs(self.curSetFollowEntity) do
            if v == playerId then
                self.curSetFollowEntity[k] = nil
                break
            end
        end
    end
end

function CommonSetFollowRotationBehavior:Death()
    for k, v in pairs(self.curSetFollowEntity) do
        local entity = Fight.Instance.entityManager:GetEntity(v)
        if entity and entity.rotateComponent and entity.rotateComponent.followTarget == self.entity.instanceId then
            entity.rotateComponent.followTarget = nil
        end
    end
    TableUtils.ClearTable(self.curSetFollowEntity)
end

