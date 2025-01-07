CommonSetFollowMoveBehavior = BaseClass("CommonSetFollowMoveBehavior", BehaviorBase)

function CommonSetFollowMoveBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonSetFollowMoveBehavior:InitConfig(fight, entity)
    self.fight = fight
    self.entity = entity
end

