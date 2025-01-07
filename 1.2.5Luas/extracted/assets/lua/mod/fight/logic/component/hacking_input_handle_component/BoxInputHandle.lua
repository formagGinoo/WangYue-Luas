---@class BoxInputHandle
BoxInputHandle = BaseClass("BoxInputHandle", BaseInputHandle)

function BoxInputHandle:__init()
end

---@param fight Fight
---@param entity Entity
function BoxInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config
end

function BoxInputHandle:Hacking()

end

function BoxInputHandle:StopHacking()

end

function BoxInputHandle:ClickUp(down)
    if not down then
        self.entity.timeoutDeathComponent:SetDeath()
    end
end

function BoxInputHandle:ClickDown(down)

end

function BoxInputHandle:ClickLeft(down)

end

function BoxInputHandle:ClickRight(down)

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