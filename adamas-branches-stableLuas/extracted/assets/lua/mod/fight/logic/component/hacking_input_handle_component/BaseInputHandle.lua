---@class BaseInputHandle
BaseInputHandle = BaseClass("BaseInputHandle", PoolBaseClass)

function BaseInputHandle:__Init()
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

function BaseInputHandle:StopHacking(nextHackId)
end

function BaseInputHandle:ClickUp(down)
end

function BaseInputHandle:ClickDown(down)
end

function BaseInputHandle:ClickLeft(down)
end

function BaseInputHandle:ClickRight(down)
    -- if down then
    --     BehaviorFunctions.ExitHackingMode()
    --     BehaviorFunctions.EnterBuildMode(self.entity.instanceId)
    -- end
end

function BaseInputHandle:GetUpOperateState()
    return FightEnum.HackOperateState.Normal
end

function BaseInputHandle:GetDownOperateState()
    return FightEnum.HackOperateState.Normal
end

function BaseInputHandle:GetLeftOperateState()
    return FightEnum.HackOperateState.Normal
end

function BaseInputHandle:GetRightOperateState()
    return FightEnum.HackOperateState.Normal
end

function BaseInputHandle:OnCache()
    LogError("请在BaseInputHandle的子类中重写OnCache方法")
    self.fight.objectPool:Cache(BaseInputHandle, self)
end

function BaseInputHandle:__cache()

end

function BaseInputHandle:__delete()

end