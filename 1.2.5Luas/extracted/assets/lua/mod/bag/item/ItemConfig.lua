ItemConfig = ItemConfig or {}

ItemConfig.QualityColor =
{
    [1] = "CBCDD2ff",
    [2] = "00C8A2ff",
    [3] = "84B7FEff",
    [4] = "e53cfeff",
    [5] = "ff7c07ff",
    [6] = "f04138ff"
}

local ItemData = Config.DataItem
local WeaponData = Config.DataWeapon
local DataHeroMain = Config.DataHeroMain.Find
local DataHeroModel = Config.DataUiModel.data_ui_model
local PartnerData = Config.DataPartnerMain.Find
local ItemIDRecord = {}

function ItemConfig.GetItemType(itemId)
    if itemId >= 1 and itemId <= 999 then
        return BagEnum.BagType.Currency
    elseif itemId >= 1001 and itemId <= 999999 then
        return BagEnum.BagType.Item
    elseif itemId >= 1000001 and itemId <= 1999999 then
        return BagEnum.BagType.Role
    elseif itemId >= 2000001 and itemId <= 2999999 then
        return BagEnum.BagType.Weapon
    elseif itemId >= 3000001 and itemId <= 3999999 then
        return BagEnum.BagType.Partner
    end
end

function ItemConfig.GetItemConfig(itemId)
    local type = ItemConfig.GetItemType(itemId)
    if type == BagEnum.BagType.Weapon then
        return WeaponData.data_weapon[itemId]
    elseif type == BagEnum.BagType.Role then
        return DataHeroMain[itemId]
    elseif type == BagEnum.BagType.Partner then
        return PartnerData[itemId]
    end

    return ItemData.data_item[itemId]
end

function ItemConfig.GetItemIcon(itemId)
    local type = ItemConfig.GetItemType(itemId)

    if type == BagEnum.BagType.Role then
        return DataHeroMain[itemId].rhead_icon
    elseif type == BagEnum.BagType.Partner then
        return PartnerData[itemId].head_icon
	elseif type == BagEnum.BagType.Weapon then
        return WeaponData.data_weapon[itemId].icon
    end
	
	return ItemData.data_item[itemId].icon
end

function ItemConfig.GetBagTypeConfig(bagType)
    return ItemData.data_bag_tag[bagType]
end

function ItemConfig.GetSourceConfig(sourceId)
    return ItemData.data_gain_way[sourceId]
end

function ItemConfig.GetItemTypeConfig(itemType)
    return ItemData.data_item_type[itemType]
end

function ItemConfig.GetQualityName(itemId)
    local item = ItemData.data_item[itemId]
    local color = ItemConfig.QualityColor[item.quality]
    return string.format("<color=#%s>%s</color>", color, item.name)
end

function ItemConfig.GetItemIds_ItemType(itemType)
    if ItemIDRecord[itemType] then
        return ItemIDRecord[itemType]
    end

    if not ItemIDRecord then ItemIDRecord = {} end
    local ids = {}
    for k, v in pairs(ItemData.data_item) do
        if v.type == itemType then
            table.insert(ids, k)
        end
    end

    ItemIDRecord[itemType] = ids
    return ids
end

function ItemConfig:GetPreviewModel(id)
    local uiModel = ItemConfig.GetItemConfig(id).ui_model
    local config = DataHeroModel[uiModel]
    return config.model_path, config.ui_controller_path, config.ui_hide_node
end

--返回用于显示的物品数量
function ItemConfig.GetItemCountInfo(curCount, needCount)
    local str = ""
    if curCount < needCount then
        str = string.format("<color=#ff5c5c>%s</color>/<color=#FFFFFF>%s</color>", curCount, needCount)
    else
        str = string.format("<color=#FFFFFF>%s/%s</color>", curCount, needCount)
    end
    return str
end

function ItemConfig.GetGoldShowCount(curCount, needCount)
    local str = ""
    if curCount < needCount then
        str = string.format("<color=#ff5c5c>%s</color>", needCount)
    else
        str = string.format("<color=#53586A>%s</color>", needCount)
    end
    
    return str
end

-- TODO 补充其他的途径获取配置 eq -> getSourceConfigById..

local DataReward = Config.DataItem.data_reward

function ItemConfig.GetReward(id)
    return DataReward[id].reward_list
end

ItemConfig.RewardSrc = {
    UnKnown = 0,
	Task = 1,
	Duplicate = 2, --副本
	GiftBag = 3,
    ExplorAward = 4,
    TreasureBox = 5,
    ItemCell = 6,
    ItemDrop = 7,
    ItemUse = 8,
    HeroActivateConv = 9,
    HeroLevUp = 10,
    HeroLevUpReturn = 11,
    HeroStageUp = 12,
    HeroStarUp = 13,
    HeroSkillLevUp = 14,
    Collect = 15,
    AutoCollect = 16,
    WeaponLevUp = 17,
    WeaponLevUpReturn = 18,
    WeaponStageUp = 19,
    WeaponRefine = 20,
    PartnerLevelUp = 31,
    PartnerSkillLevelUp = 32,
    UnLock = 35,
	Mailing = 36,
    MercenaryClearAlert = 37,
    MercenaryHit = 38, 
    MercenaryRankReward = 39,
    Shop = 41,
    WorldLevel = 42,
    Teach = 51,
	Activation = 52,
	ActivationFinish = 53,
    Alchemy = 54,
    GM = 999,
}

function ItemConfig.IsShowTip(type)
    if type == ItemConfig.RewardSrc.Shop
    or type == ItemConfig.RewardSrc.WorldLevel
    or type == ItemConfig.RewardSrc.MercenaryRankReward
    or type == ItemConfig.RewardSrc.Activation
     then
        return true
    end
end

function ItemConfig.GetPartnerGroupInfo(partnerId)
    return PartnerData[partnerId]
end

function ItemConfig.IsPartner(id)
    if PartnerData[id] then
        return true
    end
    return false
end