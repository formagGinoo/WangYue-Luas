---@class DroneInputHandle
DroneInputHandle = BaseClass("DroneInputHandle", BaseInputHandle)

---@param fight Fight
---@param entity Entity
function DroneInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.curDriveId = nil
end

function DroneInputHandle:Hacking()

end

function DroneInputHandle:StopHacking(nextHackId)

end

function DroneInputHandle:ClickUp(down)
    if down then
        Fight.Instance.hackManager:ExitHackingMode()
        Fight.Instance.entityManager:CallBehaviorFun("onDroneDrive", self.entity.instanceId ,BehaviorFunctions.GetCtrlEntity())
    end
end

function DroneInputHandle:ClickDown(down)
    if down then
        Fight.Instance.buildingManager:OnBuildingTimeout(self.entity.instanceId)
    end
end

function DroneInputHandle:OnCache()
    self.fight.objectPool:Cache(DroneInputHandle, self)
end

function DroneInputHandle:__cache()
    self.fight = nil
    self.entity = nil
    self.curDriveId = nil
    self.driver = nil
end

function DroneInputHandle:__delete()

end