---@class BaseInputHandle
BaseInputHandle = BaseClass("BaseInputHandle", PoolBaseClass)

function BaseInputHandle:__init()
end

---@param fight Fight
---@param entity Entity
function BaseInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config
end

function BaseInputHandle:Hacking()
end

function BaseInputHandle:StopHacking()
end

function BaseInputHandle:Update()
end

function BaseInputHandle:ClickUp(down)
end

function BaseInputHandle:ClickDown(down)
end

function BaseInputHandle:ClickLeft(down)
end

function BaseInputHandle:ClickRight(down)
end

function BaseInputHandle:OnCache()
    self.fight.objectPool:Cache(BaseInputHandle, self)
end

function BaseInputHandle:__cache()

end

function BaseInputHandle:__delete()

end