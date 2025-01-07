MercenaryHuntConfig = MercenaryHuntConfig or {}

MercenaryHuntConfig.MercenaryDiscoverState = {
    None = 0,
    Discover = 1
}

MercenaryHuntConfig.MercenaryChaseState = {
    None = 0,
    Chase = 1
}

MercenaryHuntConfig.AlertState = {
    Dec = 0,
    Stop = 1,
}

MercenaryHuntConfig.ShowTipType = {
    Discover = 1,
    Fight = 2,
}

MercenaryHuntConfig.MaxLvText = TI18N("满级")

local MercenaryHuntInfoCfg = Config.DataMercenaryInfo.Find
local MercenaryNameConfig = Config.DataMercenaryName.Find
local MercenaryTipConfig = Config.DataMercenaryTip.Find
local MercenaryHuntRankConfig = Config.DataMercenaryRankLv.Find
local MercenaryEcoConfig = Config.DataMercenaryEco.Find
local MercenaryHuntMainConfig = Config.DataMercenaryMain.Find
local DataItemConfig = Config.DataItem.data_reward
local DataMercenaryCommon = Config.DataMercenaryCommon.Find

MercenaryHuntConfig.ChaseCD = DataMercenaryCommon.ChaseCD.int_val / 100 -- 百分比
MercenaryHuntConfig.ChaseRadius = DataMercenaryCommon.ChaseRadius.int_val
MercenaryHuntConfig.NearbyRadius = DataMercenaryCommon.NearbyRadius.int_val
MercenaryHuntConfig.ChaseMinRadius = DataMercenaryCommon.ChaseMinRadius.int_val
MercenaryHuntConfig.ChaseMaxRadius = DataMercenaryCommon.ChaseMaxRadius.int_val

function MercenaryHuntConfig.GetMercenaryHuntMainConfig(id)
    return MercenaryHuntMainConfig[id]
end

function MercenaryHuntConfig.GetMercenaryInfoConfig(id, stage)
    local key = UtilsBase.GetDoubleKeys(id, stage, 32)
    return MercenaryHuntInfoCfg[key]
end

function MercenaryHuntConfig.GetMercenaryName(id, index)
    local allInfo = MercenaryNameConfig[id]
    local name = allInfo.name_info[index]
    return name
end

function MercenaryHuntConfig.GetMercenaryHuntRankLvConfig(ranklv)
    return MercenaryHuntRankConfig[ranklv]
end

function MercenaryHuntConfig:GetMercenaryEcoConfig(ecoId)
    return MercenaryEcoConfig[ecoId]
end

function MercenaryHuntConfig.GetMercenaryTip(id)
    return MercenaryTipConfig[id]
end

function MercenaryHuntConfig.GetRankLvByExp(exp)
    local lv = 0
    for i,_ in ipairs(MercenaryHuntRankConfig) do
        if exp >= MercenaryHuntRankConfig[i].need_val then
            lv = i
        else
            return lv
        end
    end
    return lv
end

-- 到下一级已经获得的经验
function MercenaryHuntConfig.GetHasExpToNextLv(exp)
    local nowLv = MercenaryHuntConfig.GetRankLvByExp(exp)
    local alreadyHaveExp = MercenaryHuntRankConfig[nowLv] and MercenaryHuntRankConfig[nowLv].need_val or 0
    return exp - alreadyHaveExp
end

--到下一级总共需要的经验
function MercenaryHuntConfig.GetExpToNextLv(exp)
    local nowLv = MercenaryHuntConfig.GetRankLvByExp(exp)
    -- 没有下一级了
    if not MercenaryHuntRankConfig[nowLv + 1] then
        return 0
    end
    local alreadyHaveExp = MercenaryHuntRankConfig[nowLv] and MercenaryHuntRankConfig[nowLv].need_val or 0
    local expToNextLv = MercenaryHuntRankConfig[nowLv + 1].need_val - alreadyHaveExp
    return expToNextLv
end

function MercenaryHuntConfig.GetItemListByRewardId(rewardId)
    return DataItemConfig[rewardId].reward_list
end

function MercenaryHuntConfig.GetMercenaryInfoByIdAndAlertValue(id,alert_val)
    local key
    if id == nil or id == 0 then
        return 
    end
    for i = 1, 10, 1 do
        key = UtilsBase.GetDoubleKeys(id, i, 32)
        if MercenaryHuntInfoCfg[key].alert_val >= alert_val then
            return MercenaryHuntInfoCfg[key]
        end
    end
end

function MercenaryHuntConfig.GetMercenaryInfoMaxStageById(id)
    local key
    for i = 1, 10, 1 do
        key = UtilsBase.GetDoubleKeys(id, i, 32)
        if MercenaryHuntInfoCfg[key] == nil then
            return i - 1
        end
    end
end

function MercenaryHuntConfig.GetCostListByIdAndAlertVal(id,alert_val)
    local key
    local cost = {}
    for i = 1, 10, 1 do
        key = UtilsBase.GetDoubleKeys(id, i, 32)
        if MercenaryHuntInfoCfg[key] == nil then break end
        if MercenaryHuntInfoCfg[key].alert_val <= alert_val then
            if cost[1] == nil then
                cost[1] = MercenaryHuntInfoCfg[key].clear_alert_cost[1]
                cost[2] = MercenaryHuntInfoCfg[key].clear_alert_cost[2]
            else
                cost[2] = cost[2] + MercenaryHuntInfoCfg[key].clear_alert_cost[2]
            end
        end
    end
    return cost
end

function MercenaryHuntConfig.GetHunterFullName(preNameId, nameId, preNameIndex, nameIndex)
    local preName = MercenaryHuntConfig.GetMercenaryName(preNameId, preNameIndex)
    local name = MercenaryHuntConfig.GetMercenaryName(nameId, nameIndex)
    return preName .. name
end

function MercenaryHuntConfig.RefreshCell(index, go, cellList, rewardList)
	if not go then
        return 
    end
    local awardItem
    local awardObj
    if cellList[index] then
        awardItem = cellList[index].awardItem
        awardObj = cellList[index].awardObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
		awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
		if not awardItem then
			awardItem = CommonItem.New()
		end
        awardObj = uiContainer.CommonItem
        cellList[index] = {}
        cellList[index].awardItem = awardItem
        cellList[index].awardObj = awardObj
    end
	local awardItemInfo = ItemConfig.GetItemConfig(rewardList[index][1])
	awardItemInfo.template_id = rewardList[index][1]
	awardItem:InitItem(awardObj, awardItemInfo, true)
    awardItem:SetNum(rewardList[index][2])
end

function MercenaryHuntConfig.GetForbidHuntArea()
    return DataMercenaryCommon.ForbidHuntArea.int_tab
end