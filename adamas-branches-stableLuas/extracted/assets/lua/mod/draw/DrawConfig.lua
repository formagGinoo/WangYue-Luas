DrawConfig = DrawConfig or {}
local _tinsert = table.insert
local _tsort = table.sort

local DataDraw = Config.DataDraw.Find
local DataDrawShowProbability = Config.DataDrawShowProbability.Find
local DataDrawShowProbabilityGroupByDrawId = Config.DataDrawShowProbability.FindbyDrawId
local DataDrawShowItem = Config.DataDrawShowItem.Find
local DataDrawRule = Config.DataDrawRule.Find
local DataDrawPage = Config.DataDrawPage.Find
local DataDrawItemQuality = Config.DataDrawItemQuality.Find
local DataDrawGroup = Config.DataDrawGroup.Find
local DataItem = Config.DataItem.Find
local DataWeapon = Config.DataWeapon.Find
local DataHero = Config.DataHeroMain.Find
local DataItemExchange = Config.DataItemExchange.Find
local DataItemExchangeGroup = Config.DataItemExchange.FindbyTargetId
local DataHeroElement = Config.DataHeroElement.Find

local DataItemExtra = Config.DataItemExtra.Find
local DataItemExtraById = Config.DataItemExtra.FindbyId

local DataHeroStand = Config.DataHeroStand.Find
local DataWeaponStand = Config.DataWeaponStand

DrawConfig.DrawItemIconPath = "Textures/Icon/Single/ItemIcon/10001.png"
DrawConfig.ValuableDrawItemIconPath = "Textures/Icon/Single/ItemIcon/10001.png"

function DrawConfig.GetAllPools()
    return DataDraw
end

function DrawConfig.PoolSortFunc(pool1, pool2)
    return pool1.sort > pool2.sort
end

function DrawConfig.PoolGroupSortFunc(group1, group2)
    return DataDrawPage[group1.tagId].sort > DataDrawPage[group2.tagId].sort
end

function DrawConfig.GetDrawPrefabPath(pool)
    return string.format("Prefabs/UI/Draw/DrawContainer/%s.prefab", pool.prefeb)
end

function DrawConfig.GetDrawPrefabPathByPoolId(poolId)
    return string.format("Prefabs/UI/Draw/DrawContainer/%s.prefab", DataDraw[poolId].prefeb)
end

function DrawConfig.GetPoolPageId(pool)
    return DataDrawGroup[pool.group].page
end

function DrawConfig.GetPageInfo(pageId)
    return DataDrawPage[pageId]
end

function DrawConfig.GetPoolInfo(poolId)
    return DataDraw[poolId]
end

function DrawConfig.GetPoolShowInfo(poolId)
    return DataDrawShowItem[poolId]
end

function DrawConfig.GetPoolGroupIdByPoolId(poolId)
    return DataDraw[poolId].group
end

function DrawConfig.GetGroupInfoByPoolId(poolId)
    return DataDrawGroup[DataDraw[poolId].group]
end

function DrawConfig.GetGroupInfo(groupId)
    return DataDrawGroup[groupId]
end

function DrawConfig.GetItemInfo(itemId)
    local items = DataItem[itemId]
    local standInfo = nil
    if items then
        --物品
        return { id = itemId, type = DrawEnum.DrawItemType.Item, name = items.name, stand_icon = items.icon, quality = items.quality }
    end
    items = DataWeapon[itemId]

    if items then
        --武器
        standInfo = DataWeaponStand[UtilsBase.GetStringKeys(itemId, 2)]
        if not standInfo then
            standInfo = DataWeaponStand[UtilsBase.GetStringKeys(0, 2)]
        end
        return { id = itemId, type = DrawEnum.DrawItemType.Weapon, name = items.name, stand_icon = items.stand_icon, quality = items.quality, 
        standInfo = standInfo }
    end
    items = DataHero[itemId]
    if items then
        --人物
        standInfo = DataHeroStand[UtilsBase.GetStringKeys(itemId, 2)]
        if not standInfo then
            standInfo = DataHeroStand[UtilsBase.GetStringKeys(0, 2)]
        end
        return { id = itemId, type = DrawEnum.DrawItemType.Hero, name = items.name, stand_icon = items.stand_icon, quality = items.quality, 
        elementIconPath = DataHeroElement[items.element].element_icon_draw, standInfo = standInfo }
    end
end

function DrawConfig.GetItemName(itemId)
    local items = DataItem[itemId]
    if items then
        return items.name
    end
    items = DataWeapon[itemId]
    if items then
        return items.name
    end
    items = DataHero[itemId]
    if items then
        return items.name
    end
end

function DrawConfig.GetItemIconPath(itemId)
    return DataItem[itemId].icon
end

function DrawConfig.GetPoolCostItem(poolId)
    return DataDraw[poolId].cost_id
end

function DrawConfig.GetExchangeIndexByItemId(itemId)
    return DataItemExchangeGroup[itemId]
end

function DrawConfig.GetExchangeInfo(fromId, toId)
    local indexList = DrawConfig.GetExchangeIndexByItemId(toId)
    if not indexList then
        LogError(string.format("%d 找不到对应的兑换索引", toId))
        return 
    end

    for _, index in pairs(indexList) do
        local info = DataItemExchange[index]
        if info.target_id == toId and fromId == info.consume[1][1] then
            return {key = info.id, fromId = info.consume[1][1], fromNum = info.consume[1][2], toId = info.target_id, toNum = info.target_num}
        end
    end
    
    return nil
end

function DrawConfig.GetPoolBaseRuleInfo(groupId)
    return DataDrawRule[groupId]
end

function DrawConfig.GetGroupProbability(poolId)
    local keyList = DataDrawShowProbabilityGroupByDrawId[poolId]
    if not keyList then
        LogError(string.format("卡池组 %d 找不到对应的概率信息", poolId))
        return
    end

    local tb = {}
    for index, _ in pairs(keyList) do
        _tinsert(tb, DataDrawShowProbability[index])
    end
    _tsort(tb, function (a, b) return a.id < b.id end)

    return tb
end

function DrawConfig.GetItemExtraInfo(itemId, count)
    local groupInfo = DataItemExtraById[itemId]
    if not groupInfo then
        return nil
    end
    local res = nil
    for k, v in pairs(groupInfo) do
        if count >= DataItemExtra[v].count then
            res = DataItemExtra[v]
        end 
    end
    
    return res
end


-- 弱海
DrawConfig.ValuableDrawItemId = 3
-- 归一
DrawConfig.ValuableCurrencyItemId = 4
-- 弱海换常驻抽卡券
DrawConfig.ValuableDrawExchangeDrawItem = 3

-- 归一换弱海 兑换Id
DrawConfig.ValuableCurrencyItemExchangeValuableDraw = 2
