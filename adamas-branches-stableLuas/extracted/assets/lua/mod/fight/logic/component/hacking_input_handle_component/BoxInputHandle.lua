---@class BoxInputHandle
BoxInputHandle = BaseClass("BoxInputHandle", BaseInputHandle)

---@param fight Fight
---@param entity Entity
function BoxInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config
end

function BoxInputHandle:Hacking()

end

function BoxInputHandle:StopHacking(nextHackId)

end

function BoxInputHandle:ClickDown(down)
    if down then
        Fight.Instance.buildingManager:OnBuildingTimeout(self.entity.instanceId)
    end
end

function BoxInputHandle:OnCache()
    self.fight.objectPool:Cache(BoxInputHandle, self)
end

function BoxInputHandle:__cache()
    self.fight = nil
    self.entity = nil
    self.config = nil
end

function BoxInputHandle:__delete()

end