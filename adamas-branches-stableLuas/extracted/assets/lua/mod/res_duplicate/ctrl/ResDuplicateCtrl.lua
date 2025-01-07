ResDuplicateCtrl = BaseClass("ResDuplicateCtrl",Controller)

local _tinsert = table.insert
function ResDuplicateCtrl:__init()
end

function ResDuplicateCtrl:EnterResDuplicateId(duplicateId)
    mod.DuplicateCtrl.fightResult = FightEnum.FightResult.None
    mod.ResDuplicateFacade:SendMsg("duplicate_resource_enter", duplicateId)
end

function ResDuplicateCtrl:RecvEnterResDuplicate(data)
    self.enterDupData = data
end

function ResDuplicateCtrl:CheckResDup(dupId)
    if not self.enterDupData then return end
    local enterDupId = self.enterDupData.system_duplicate_id
    local dupCfg = ResDuplicateConfig.GetDuplicateInfo(enterDupId)
    if dupCfg.duplicate_id ~= dupId then return end
    return true
end

function ResDuplicateCtrl:QuitDuplicate()
    mod.DuplicateFacade:SendMsg("duplicate_quit_base")
end

function ResDuplicateCtrl:RecvQuitResDuplicate(data)
    self.enterDupData = nil
end

function ResDuplicateCtrl:ResDuplicateFinish()
    local kill_mon_list = {}
    mod.ResDuplicateFacade:SendMsg("duplicate_resource_finish", self.enterDupData.system_duplicate_id, kill_mon_list, true)
end

function ResDuplicateCtrl:RecvResDuplicateFinish(data)
   self.finishDupId = data.system_duplicate_id
--    self:QuitDuplicate()
end

function ResDuplicateCtrl:GetEnterDupData()
    return self.enterDupData
end

function ResDuplicateCtrl:GetCurResOpenMaxDuplicateId(resId)
    local duplicateList = ResDuplicateConfig.GetResourceDuplicateMainById(resId)
    local conditionMgr = Fight.Instance.conditionManager

    local selectDupId
    for _, dupId in ipairs(duplicateList) do
        if dupId ~= 0 then --这里读的是systemDuplicateId
            local dupCfg = ResDuplicateConfig.GetDuplicateInfo(dupId)
            local conditionId = dupCfg.condition
            if conditionMgr:CheckConditionByConfig(conditionId) then
                selectDupId = dupId
            end
        end
    end

    return selectDupId
end

function ResDuplicateCtrl:CheckFightCost(costVal)
    local costId = ResDuplicateConfig.FightCostResId
    local curVal = mod.BagCtrl:GetItemCountById(costId)
    if costId == ItemConfig.StrengthId then
        curVal = mod.BagCtrl:GetStrengthData()
    end

    if curVal < costVal then
        PanelManager.Instance:OpenPanel(StrengthExchangePanel)
        return false
    end

    return true
end

function ResDuplicateCtrl:CheckResourceEcoHit(ecoId)
    local costCfg = ResDuplicateConfig.GetResourceEcoHitCost(ecoId)
    if not costCfg then return end
    local costVal = costCfg.cost_energy
    local costId = ResDuplicateConfig.FightCostResId
    local curVal = mod.BagCtrl:GetItemCountById(costId)
    local itemCfg = ItemConfig.GetItemConfig(costId)
    local name = itemCfg.name
    local desc = string.format(TI18N("是否消耗%s%s领取奖励"), costVal, name)

    local cb = function ()
        if self:CheckFightCost(costVal) then
            Fight.Instance.entityManager:CallBehaviorFun("ResEcoHitCostCheckSuc", ecoId)
        end
    end

    PanelManager.Instance:OpenPanel(DuplicateTipPanel, {sureCallBack = cb, tip = desc})
end