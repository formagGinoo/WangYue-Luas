---@class HackingInputHandleComponent
HackingInputHandleComponent = BaseClass("HackingInputHandleComponent", PoolBaseClass)

local HackingType2InputHandle = {
    [FightEnum.HackingType.Drone] = DroneInputHandle,
    [FightEnum.HackingType.Camera] = CameraInputHandle,
    [FightEnum.HackingType.Npc] = NpcInputHandle,
    [FightEnum.HackingType.Box] = BoxInputHandle,
}

function HackingInputHandleComponent:__init()
end

function HackingInputHandleComponent:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.config = entity:GetComponentConfig(FightEnum.ComponentType.HackingInputHandle)
    self.inputHandle = self.fight.objectPool:Get(HackingType2InputHandle[self.config.HackingType])
    self.inputHandle:Init(fight, entity, self.config)
end

---获取骇入组件配置，包括类型和独特信息
function HackingInputHandleComponent:GetConfig()
    return self.config
end

function HackingInputHandleComponent:Update()
    self.inputHandle:Update()
end

function HackingInputHandleComponent:Hacking()
    self.fight.entityManager:CallBehaviorFun("Hacking", self.entity.instanceId)
    self.inputHandle:Hacking()
end

function HackingInputHandleComponent:StopHacking()
    self.fight.entityManager:CallBehaviorFun("StopHacking", self.entity.instanceId)
    self.inputHandle:StopHacking()
end

function HackingInputHandleComponent:ClickUp(down)
    if not down then
        self.fight.entityManager:CallBehaviorFun("HackingClickUp", self.entity.instanceId)
    end
    self.inputHandle:ClickUp(down)
end

function HackingInputHandleComponent:ClickDown(down)
    if not down then
        self.fight.entityManager:CallBehaviorFun("HackingClickDown", self.entity.instanceId)
    end
    self.inputHandle:ClickDown(down)
end

function HackingInputHandleComponent:ClickLeft(down)
    if not down then
        self.fight.entityManager:CallBehaviorFun("HackingClickLeft", self.entity.instanceId)
    end
    self.inputHandle:ClickLeft(down)
end
function HackingInputHandleComponent:ClickRight(down)
    if not down then
        self.fight.entityManager:CallBehaviorFun("HackingClickRight", self.entity.instanceId)
    end
    self.inputHandle:ClickRight(down)
end

function HackingInputHandleComponent:OnCache()
    self.fight.objectPool:Cache(HackingInputHandleComponent, self)
end

function HackingInputHandleComponent:__cache()
    self.fight = nil
    self.entity = nil
end

function HackingInputHandleComponent:__delete()

end