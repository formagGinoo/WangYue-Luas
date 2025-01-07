UnlockManager = BaseClass("UnlockManager")

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

local DataUnlockEntity = Config.DataUnlockEntity.Find

function UnlockManager:__init(fight)
	self.fight = fight
    self.clientFight = fight.clientFight
    self.assetsNodeManager = self.clientFight.assetsNodeManager

    self.conditionToEcoId = {}
end

function UnlockManager:StartFight()
    self:AddConditionListener()
end

function UnlockManager:AddConditionListener()
    local conditionMgr = Fight.Instance.conditionManager
    for _, cfg in pairs(DataUnlockEntity) do
        local conditionId = cfg.condition_id
        if conditionId ~= 0 and not conditionMgr:CheckConditionByConfig(conditionId) then
            self.conditionToEcoId[conditionId] = self.conditionToEcoId[conditionId] or {}
            _tInsert(self.conditionToEcoId[conditionId], cfg.eco_id)
            conditionMgr:AddListener(conditionId, self:ToFunc("OnConditionSuc"))
        end
    end
end

function UnlockManager:OnConditionSuc(conditionId)
    local map = self.conditionToEcoId[conditionId]
    for _, insId in pairs(map) do
        Fight.Instance.entityManager:CallBehaviorFun("UnlockConditionSuc", insId)
    end
end

function UnlockManager:CheckUnlockPartner(isTip)
    local bagCtrl = mod.BagCtrl
    local partnerMap = bagCtrl:GetBagByType(BagEnum.BagType.Partner)
    if not partnerMap or #partnerMap <= 0 then 
        MsgBoxManager.Instance:ShowTips(TI18N("未携带可开锁月灵"))
        return
    end

    local unlockMap = {}

    -- 检查当前持有的月灵是否有带有开锁技能
    for _, data in pairs(partnerMap) do
        local partnerId = data.template_id
        for _, skill_info in pairs(data.skill_list) do
            local id = skill_info.key
            local lv = skill_info.value
            local unlockCfg = UnlockConfig.GetUnlockSkillLevelCfg(id, lv)
            if not unlockCfg then
                goto continue
            end
            local partnerCfg = ItemConfig.GetItemConfig(partnerId)
            local insert = {
                partnerId = partnerId,
                uniqueId = data.unique_id,
                skillId = id,
                skillLv = lv,
                quality = partnerCfg.quality,
                sortVal = partnerCfg.order_id,
                lev = data.lev,
                entity_id = partnerCfg.entity_id
            }
            _tInsert(unlockMap, insert)
            break

            ::continue::
        end
    end

    local isPass = #unlockMap > 0
    if not isPass and isTip then
        MsgBoxManager.Instance:ShowTips(TI18N("未携带可开锁月灵"))
        return
    end

    if not self.isInitPartner then
        for _, data in pairs(unlockMap) do
            self.assetsNodeManager:LoadEntity(data.entity_id)
        end
        self.isInitPartner = true
    end

    return isPass, unlockMap
end

function UnlockManager:CheckUnlockCondition(ecoId, isNotShowTip)
    local cfg = UnlockConfig.GetUnlockInitCfg(ecoId)
    if not cfg then return end
    local conditionId = cfg.condition_id
    local isComplete = self.fight.Instance.conditionManager:CheckConditionByConfig(conditionId)
    if not isComplete then
        if not isNotShowTip then
            local conditionCfg = Config.DataCondition.data_condition[conditionId]
            MsgBoxManager.Instance:ShowTips(TI18N(conditionCfg.description))
        end
        return
    end

    return isComplete
end

function UnlockManager:OpenUnlockPreparePnl(ecoId)
    local selectPartner = self:GetSelectPartner(true)
    if not selectPartner then return end
    if not self:CheckUnlockCondition(ecoId) then return end

    local cb = function()
	    WindowManager.Instance:OpenWindow(UnlockPrepareWindow, {ecoId = ecoId})
    end
    self.assetsNodeManager:LoadEntity(selectPartner.entity_id, cb)
    return true
end

function UnlockManager:GetPartnerMap()
    local _, map = self:CheckUnlockPartner()
    return map
end

function UnlockManager:CheckCostUnlockItem(ecoId)
    local cfg = UnlockConfig.GetUnlockInitCfg(ecoId)
    if not cfg then return end
    local costId = cfg.cost_id
    local costNum = cfg.cos_num
    local itemNum = mod.BagCtrl:GetItemCountById(costId)
    return itemNum >= costNum
end

function UnlockManager:GetSelectPartner(isTip)
    local isPartner, map = self:CheckUnlockPartner(isTip)
    if not isPartner then return end

    _tSort(map, function (a, b)
        if a.skillLv ~= b.skillLv then
            return a.skillLv > b.skillLv
        end

        if a.quality ~= b.quality then
            return a.quality > b.quality
        end

        if a.sortVal ~= b.sortVal then
            return a.sortVal > b.sortVal
        end
        return false
    end)

    return map[1]
end

function UnlockManager:CreatPartner(partner)
    self:DestoryPartner()
    local player = Fight.Instance.playerManager:GetPlayer()
	local playerObject = player:GetCtrlEntityObject()
    local pos = playerObject.transformComponent.position
    local playTrans = playerObject.clientTransformComponent.transform

    local entityId = partner.entity_id
    local entity = self.fight.entityManager:CreateEntity(entityId, nil, nil, nil, nil, {partnerUnId = partner.uniqueId})
    local entiy_trans = entity.clientTransformComponent.transform
    entiy_trans:SetParent(playTrans)
    UnityUtils.SetLocalPosition(entiy_trans, -0.71, 0, -0.33)
    UnityUtils.SetLocalEulerAngles(entiy_trans, 0, 42, 0)
	-- local rotation = Quat.Euler(0, 42, 0)
	-- entity.transformComponent:SetRotation(rotation)
    -- entity.clientTransformComponent:Async()
    self.entity = entity
end

function UnlockManager:DestoryPartner()
    if self.entity then
        self.fight.entityManager:RemoveEntity(self.entity.instanceId)
    end
    self.entity = nil
end

function UnlockManager:GetEntityInstanceId()
    if not self.entity then return end
    return self.entity.instanceId
end