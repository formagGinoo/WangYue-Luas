---@class OtherInputHandle
OtherInputHandle = BaseClass("OtherInputHandle", BaseInputHandle)

---@param fight Fight
---@param entity Entity
function OtherInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config
end

function OtherInputHandle:Hacking()

end

function OtherInputHandle:StopHacking(nextHackId)

end

function OtherInputHandle:ClickDown(down)
    if self.config.DownButtonBindDestroy and down then
        Fight.Instance.buildingManager:OnBuildingTimeout(self.entity.instanceId)
    end
end

function OtherInputHandle:OnCache()
    self.fight.objectPool:Cache(OtherInputHandle, self)
end

function OtherInputHandle:__cache()
    self.fight = nil
    self.entity = nil
    self.config = nil
end

function OtherInputHandle:__delete()

end