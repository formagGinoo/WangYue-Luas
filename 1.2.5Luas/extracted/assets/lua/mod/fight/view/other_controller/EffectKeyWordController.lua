---@class EffectKeyWordController
EffectKeyWordController = BaseClass("EffectKeyWordController")

local FindEffectType = {
    All = 1,
    Ids = 2,
    Radius = 3,
    Cylinder = 4
}

---@param clientFight ClientFight
function EffectKeyWordController:__init(clientFight)
    self.clientFight = clientFight
    self.keyWordList = {}
    self.removeList = {}
end

function EffectKeyWordController:CancelEffectKeyWordControl()
    for i, v in ipairs(self.keyWordList) do
        self:Done(v.effectList)
    end
    TableUtils.ClearTable(self.keyWordList)
end

function EffectKeyWordController:SetAllEffectKeyWordControl(curveId, excludedIds, isRefresh)
    local effectList = self:GetAllEffect(excludedIds)
    self:SetEffectKeyWordControl(effectList, curveId, isRefresh, FindEffectType.All, excludedIds)
end

function EffectKeyWordController:GetAllEffect(excludedIds)
    local effectList = {}
    for k, v in pairs(self.clientFight.clientEntityManager.clientEntites) do
        if v.clientTransformComponent and v.clientTransformComponent.effectUtil then
            table.insert(effectList, v.clientTransformComponent.effectUtil)
        end
        if v.clientBuffComponent then
            for _, effectPath in pairs(v.clientBuffComponent.buffs) do
                for _, clientBuff in pairs(effectPath) do
                    if clientBuff.effectUtil and not self:CheckBuffInExcludedIds(clientBuff, excludedIds) then
                        table.insert(effectList, clientBuff.effectUtil)
                    end
                end
            end
        end
    end
    return effectList
end

function EffectKeyWordController:SetEffectKeyWordControlByIds(curveId, Ids)
    local effectList = {}
    for k, v in pairs(self.clientFight.clientEntityManager.clientEntites) do
        if v.clientBuffComponent then
            for _, effectPath in pairs(v.clientBuffComponent.buffs) do
                for _, clientBuff in pairs(effectPath) do
                    if clientBuff.effectUtil and self:CheckBuffInExcludedIds(clientBuff, Ids) then
                        table.insert(effectList, clientBuff.effectUtil)
                    end
                end
            end
        end
    end
    self:SetEffectKeyWordControl(effectList, curveId, FindEffectType.Ids)
end

function EffectKeyWordController:SetEffectKeyWordControlByRadius(curveId, excludedIds, pos, radius, isRefresh)
    local effectList = self:GetEffectByRadius(excludedIds, pos, radius)
    self:SetEffectKeyWordControl(effectList, curveId, isRefresh, FindEffectType.Radius, excludedIds, pos, radius)
end

function EffectKeyWordController:GetEffectByRadius(excludedIds, pos, radius)
    local effectList = {}
    local position = Vector3(pos.x, pos.y, pos.z)
    for k, v in pairs(self.clientFight.clientEntityManager.clientEntites) do
        if v.clientTransformComponent then
            if v.clientTransformComponent.effectUtil and Vector3.Distance(position, v.clientTransformComponent.transform.position) < radius then
                table.insert(effectList, v.clientTransformComponent.effectUtil)
            end

            if v.clientBuffComponent then
                for _, effectPath in pairs(v.clientBuffComponent.buffs) do
                    for _, clientBuff in pairs(effectPath) do
                        if clientBuff.effectUtil and not self:CheckBuffInExcludedIds(clientBuff, excludedIds) and
                                Vector3.Distance(position, clientBuff.transform.position) < radius then
                            table.insert(effectList, clientBuff.effectUtil)
                        end
                    end
                end
            end
        end
    end
    return effectList
end

function EffectKeyWordController:SetEffectKeyWordControlByCylinder(curveId, excludedIds, pos, radius, height, isRefresh)
    local effectList = self:GetEffectByCylinder(excludedIds, pos, radius, height)
    self:SetEffectKeyWordControl(effectList, curveId, isRefresh, FindEffectType.Cylinder, excludedIds, pos, radius, height)
end

function EffectKeyWordController:GetEffectByCylinder(excludedIds, pos, radius, height)
    local effectList = {}
    local position = Vector3(pos.x, pos.y, pos.z)
    local po1 = Vector2(pos.x, pos.z)
    for k, v in pairs(self.clientFight.clientEntityManager.clientEntites) do
        if v.clientTransformComponent then
            local po2 = Vector2(v.clientTransformComponent.transform.position.x, v.clientTransformComponent.transform.position.z)
            if v.clientTransformComponent.effectUtil and Vector2.Distance(po1, po2) < radius and math.abs(v.clientTransformComponent.transform.position.y - position.y) < height / 2 then
                table.insert(effectList, v.clientTransformComponent.effectUtil)
            end

            if v.clientBuffComponent then
                for _, effectPath in pairs(v.clientBuffComponent.buffs) do
                    for _, clientBuff in pairs(effectPath) do
                        if clientBuff.effectUtil and not self:CheckBuffInExcludedIds(clientBuff, excludedIds) and
                                Vector2.Distance(po1, po2) < radius and math.abs(v.clientTransformComponent.transform.position.y - position.y) < height / 2 then
                            table.insert(effectList, clientBuff.effectUtil)
                        end
                    end
                end
            end
        end
    end
    return effectList
end

---@private
function EffectKeyWordController:CheckBuffInExcludedIds(clientBuff, excludedIds)
    for k, v in pairs(excludedIds or {}) do
        if clientBuff.clientEntity.entity.owner and clientBuff.clientEntity.entity.owner.instanceId == v.instanceId and clientBuff.buffId == v.buffId then
            return true
        end
    end
    return false
end

---@private
function EffectKeyWordController:SetEffectKeyWordControl(effectList, curveId, isRefresh, type, excludedIds, pos, radius, height)
    local instanceId = BehaviorFunctions.GetCtrlEntity()
    local entity = BehaviorFunctions.GetEntity(instanceId)
    local curve = CurveConfig.GetCurve(entity.entityId, curveId, 1000)
    if not curve then
        LogError("找不到曲线,id = " .. curveId .. " entity " .. entity.entityId)
        return
    end
    table.insert(self.keyWordList, { effectList = effectList, curve = curve, time = 0, isRefresh = isRefresh,
                                     type = type, pos = pos, radius = radius, height = height, excludedIds = excludedIds })
    self:SetKeywordEnable(effectList, true)
end

function EffectKeyWordController:Update(lerpTime)
    for i, v in pairs(self.removeList) do
        self:Done(self.keyWordList[v].effectList)
        self.keyWordList[v] = nil
    end
    TableUtils.ClearTable(self.removeList)

    for i, v in ipairs(self.keyWordList) do
        v.time = v.time + Global.deltaTime
        local lastFrame = math.floor(v.time * 30)
        local lastValue = 0
        if v.curve[lastFrame] then
            lastValue = v.curve[lastFrame]
        end
        local curValue = 0
        if v.curve[lastFrame + 1] then
            curValue = v.curve[lastFrame + 1]
            local value = lastValue + (curValue - lastValue) * lerpTime

            if v.isRefresh then
                self:SetKeywordValue(v.effectList, 1)
                if v.type == FindEffectType.All then
                    v.effectList = self:GetAllEffect(v.excludedIds)
                elseif v.type == FindEffectType.Radius then
                    v.effectList = self:GetEffectByRadius(v.excludedIds, v.pos, v.radius)
                elseif v.type == FindEffectType.Cylinder then
                    v.effectList = self:GetEffectByCylinder(v.excludedIds, v.pos, v.radius, v.height)
                end
            end
            self:SetKeywordEnable(v.effectList, true)
            self:SetKeywordValue(v.effectList, value)
        else
            table.insert(self.removeList, i)
        end
    end
end

function EffectKeyWordController:Done(effectList)
    self:SetKeywordValue(effectList, 1)
    self:SetKeywordEnable(effectList, false)
end

function EffectKeyWordController:SetKeywordValue(effectList, value)
    for k, v in pairs(effectList) do
        v:SetKeywordValue("_FadeInensity", value)
    end
end

function EffectKeyWordController:SetKeywordEnable(effectList, enable)
    for k, v in pairs(effectList) do
        v:SetKeywordEnable("_FADE_ON", enable)
    end
end

function EffectKeyWordController:__delete()

end