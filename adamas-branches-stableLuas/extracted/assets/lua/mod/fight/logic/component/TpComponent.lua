---@class TpComponent
TpComponent = BaseClass("TpComponent", PoolBaseClass)
local _tinsert = table.insert

function TpComponent:__init()
	self.commonBehavior = {}
end

function TpComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	local config = entity:GetComponentConfig(FightEnum.ComponentType.Tp)
    self.entityMgr = fight.entityManager

    self.tpType = config.TpType
    self.isTp = config.IsTp
    self.tpDelayTime = config.TpDelayTime
    self.tpList = config.TpList or {}

    self.LimitTagList = config.LimitTagList or {}

    EventMgr.Instance:AddListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
end

function TpComponent:LateInit()
    self.triggerComponent = self.entity.triggerComponent
    if not self.entity.triggerComponent then
        LogError("当前传送对象缺少交互组件")
    end
    self.triggerComponent:ExtraAddTriggerLayer(FightEnum.Layer.Entity)
end

function TpComponent:Update()

end

function TpComponent:OnEnterTriggerLayer(instanceId, layer, enterObjInsId)
    if not self:CheckTpEntityTag(enterObjInsId) then
        LogError("传送对象标签匹配失败")
        return
    end

    -- 设定了可传送的目标
    if #self.tpList > 0 then
        self:RandomFixedTp()
        return
    end

    local tpMap = self.entityMgr:GetTpEntityMapByTpType(self.tpType, instanceId)
    if #tpMap <= 0 then
        LogError("缺少对应的传送目标")
        return
    end

    -- 这里对这个列表进行一个排序，取下一个大于当前insId的传送点，如果没有则取最小的
    table.sort(tpMap, function (a, b)
        return a < b
    end)
    
    local selectInsId
    for _, val in ipairs(tpMap) do
        if val > instanceId then
            selectInsId = val
            break
        end
    end

    if not selectInsId then
        selectInsId = tpMap[1]
    end

    self:StartTp(selectInsId, enterObjInsId)
end

function TpComponent:RandomFixedTp(enterObjInsId)
    local randomMap = {}
    for _, ecoId in pairs(self.tpList) do
        local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
        if instanceId then
            _tinsert(randomMap, instanceId)
        end
    end
    if #randomMap <= 0 then return end

    local randomIdx = math.random(1, #randomMap)
    local tpEcoId = randomMap[randomIdx]
    local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(tpEcoId)
    self:StartTp(instanceId, enterObjInsId)
end

function TpComponent:CheckTpEntityTag(tpInsId)
    if #self.LimitTagList <= 0 then return true end
    local tpEntity = BehaviorFunctions.GetEntity(tpInsId)
    if not tpEntity then return end
    local tagComponent = tpEntity.tagComponent
    if not tagComponent then return end

    for _, data in pairs(self.LimitTagList) do
        if data.Tag == tagComponent.tag and 
            data.NpcTag == tagComponent.npcTag and 
            data.SceneObjectTag == tagComponent.sceneObjectTag then
            return true
        end
    end

    return false
end

function TpComponent:StartTp(targetInsId, tpInsId)
    local targetEntity = BehaviorFunctions.GetEntity(targetInsId)
    local pos = targetEntity.transformComponent.position

    local tpEntity = BehaviorFunctions.GetEntity(tpInsId)
    if not tpEntity then return end
    LuaTimerManager.Instance:AddTimer(1, self.tpDelayTime, function()
        tpEntity.transformComponent:SetPosition(pos.x, pos.y, pos.z + 3)
    end)
end

function TpComponent:CheckEntityTp()
    return true
end

function TpComponent:OnCache()
	self.fight.objectPool:Cache(TpComponent,self)
end

function TpComponent:__cache()

end

function TpComponent:__delete()

end


