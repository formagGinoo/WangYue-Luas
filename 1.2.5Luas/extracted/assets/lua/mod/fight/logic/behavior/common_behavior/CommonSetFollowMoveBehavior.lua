CommonSetFollowMoveBehavior = BaseClass("CommonSetFollowMoveBehavior", BehaviorBase)

---@param fight Fight
---@param entity Entity
function CommonSetFollowMoveBehavior:InitConfig(fight, entity)
    self.fight = fight
    self.entity = entity
    self.curSetFollowEntity = {}
end

function CommonSetFollowMoveBehavior:EnterTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    local entity = Fight.Instance.entityManager:GetEntity(playerId)
    if entity and entity.moveComponent then
        entity.moveComponent:SetFollowTarget(self.entity.instanceId)
        table.insert(self.curSetFollowEntity, playerId)
    end
end

function CommonSetFollowMoveBehavior:ExitTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    local entity = Fight.Instance.entityManager:GetEntity(playerId)
    if entity and entity.moveComponent then
        entity.moveComponent:RemoveFollowTarget()
        for k, v in pairs(self.curSetFollowEntity) do
            if v == playerId then
                self.curSetFollowEntity[k] = nil
                break
            end
        end
    end
end

function CommonSetFollowMoveBehavior:Death()
    for k, v in pairs(self.curSetFollowEntity) do
        local entity = Fight.Instance.entityManager:GetEntity(v)
        if entity and entity.moveComponent and  entity.moveComponent.followTarget == self.entity.instanceId then
            entity.moveComponent.followTarget = nil
        end
    end
    TableUtils.ClearTable(self.curSetFollowEntity)
end

