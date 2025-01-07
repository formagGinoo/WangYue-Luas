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
ItemConfig.QualityIcon =
{
    [1] = "Textures/Icon/Single/QualityIcon/v4_unique_caijipinzhi_bai.png",
    [2] = "Textures/Icon/Single/QualityIcon/v4_unique_caijipinzhi_lv.png",
    [3] = "Textures/Icon/Single/QualityIcon/v4_unique_caijipinzhi_lan.png",
    [4] = "Textures/Icon/Single/QualityIcon/v4_unique_caijipinzhi_zi.png",
    [5] = "Textures/Icon/Single/QualityIcon/v4_unique_caijipinzhi_cheng.png",
}

ItemConfig.StrengthId = 5

local ItemData = Config.DataItem
local BagTagData = Config.DataBagTag
local DataReward = Config.DataReward
local ItemTypeData = Config.DataItemType

local WeaponData = Config.DataWeapon.Find
local DataHeroMain = Config.DataHeroMain.Find
local DataHeroModel = Config.DataUiModel.data_ui_model
local PartnerData = Config.DataPartnerMain.Find
local VehicleData = Config.DataVehicle.Find
local RobotData = Config.DataRobotHero.Find
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
    elseif itemId >= 4000001 and itemId <= 4999999 then
        return BagEnum.BagType.Vehicle
    elseif itemId >= 11000001 and itemId <= 11999999 then
        return BagEnum.BagType.Robot
    end
end

function ItemConfig.GetItemConfig(itemId)
    local type = ItemConfig.GetItemType(itemId)
    if type == BagEnum.BagType.Weapon then
        return WeaponData[itemId]
    elseif type == BagEnum.BagType.Role then
        return DataHeroMain[itemId]
    elseif type == BagEnum.BagType.Partner then
        return PartnerData[itemId]
    elseif type == BagEnum.BagType.Vehicle then
        return VehicleData[itemId]
    elseif type == BagEnum.BagType.Robot then
        return RobotData[itemId]
    end

    return ItemData.Find[itemId]
end

function ItemConfig.GetItemIcon(itemId)
    local type = ItemConfig.GetItemType(itemId)

    if type == BagEnum.BagType.Role then
        return DataHeroMain[itemId].rhead_icon
    elseif type == BagEnum.BagType.Partner then
        return PartnerData[itemId].head_icon
	elseif type == BagEnum.BagType.Weapon then
        return WeaponData[itemId].icon
    elseif type == BagEnum.BagType.Vehicle then
        return VehicleData[itemId].vehicle_icon
    end
	
	return ItemData.Find[itemId].icon
end

function ItemConfig.GetItemIconCircle(itemId)
    local type = ItemConfig.GetItemType(itemId)

    if type == BagEnum.BagType.Role then
        return DataHeroMain[itemId].chead_icon
    elseif type == BagEnum.BagType.Partner then
        return PartnerData[itemId].chead_icon
	elseif type == BagEnum.BagType.Weapon then
        return WeaponData[itemId].icon
    elseif type == BagEnum.BagType.Vehicle then
        return VehicleData[itemId].vehicle_icon
    end
	
	return ItemData.Find[itemId].icon
end

function ItemConfig.GetBagTypeConfig(bagType)
    return BagTagData[bagType]
end

function ItemConfig.GetItemTypeConfig(itemType)
return ItemTypeData.Find[itemType]
end

function ItemConfig.GetQualityName(itemId)
    local item = ItemData.Find[itemId]
    local color = ItemConfig.QualityColor[item.quality]
    return string.format("<color=#%s>%s</color>", color, item.name)
end

function ItemConfig.GetItemIds_ItemType(itemType)
    if ItemIDRecord[itemType] then
        return ItemIDRecord[itemType]
    end

    if not ItemIDRecord then ItemIDRecord = {} end
    local ids = {}
    for k, v in pairs(ItemData.Find) do
        if v.type == itemType then
            table.insert(ids, k)
        end
    end

    ItemIDRecord[itemType] = ids
    return ids
end

function ItemConfig:GetPreviewModel(id)
    local config = ItemConfig.GetItemConfig(id)
    local uiModel = config.ui_model
    local config = DataHeroModel[uiModel]
    return config.model_path, config.ui_controller_path, config.ui_hide_node
end

function ItemConfig.GetUiModeViewInfo(uiModel)
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
        str = string.format("<color=#f95240>%s</color>", needCount)
    else
        str = string.format("<color=#000000>%s</color>", needCount)
    end
    
    return str
end

-- TODO 补充其他的途径获取配置 eq -> getSourceConfigById..



function ItemConfig.GetReward(id)
    return DataReward.Find[id].reward_list
end

function ItemConfig.GetReward2(id)
    local list = DataReward.Find[id].reward_list
    local newList = {}
    for _, data in ipairs(list) do
        if data[1] ~= 0 then
            table.insert(newList, data)
        end
    end
    return newList
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
    PartnerLevelUp = 31,--月灵升级，返回月灵天赋材料
    PartnerSkillLevelUp = 32, --月灵天赋
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
    Trade = 61,
	Exchange = 62,
    Draw = 63,
    Strength = 64,-- 体力礼包
    Purchase = 65, --充值
    PurchasePackage = 66, --充值礼包
    MonthCard = 67,-- 月卡
    ResDuplicate = 68,-- 资源副本
    TaskChapterItem = 72, --章节弹窗
    DailySignIn = 74, --七日签到
    DailyTask = 75, --七日历程
    RogueLike = 77, --肉鸽卡牌奖励
    RogueSeasonReward = 78, --肉鸽赛季奖励
    Identity = 80,
	NightMareDup = 83, --梦魇副本
    CitySimulation = 84,
    RandomGiftPack = 86,    -- 随机礼包
    CatchPartner = 90, -- 缔结月灵
    RandomEvent = 91, --随机事件
    AssetTask = 93, -- 资产任务
    PartnerCenter = 95, -- 月灵中心
    GM = 999,
}

ItemConfig.ShowTipsList = 
{
    [ItemConfig.RewardSrc.Shop] = 1,
    [ItemConfig.RewardSrc.WorldLevel] = 2,
    [ItemConfig.RewardSrc.MercenaryRankReward] = 3,
    [ItemConfig.RewardSrc.Activation] = 4,
    [ItemConfig.RewardSrc.Trade] = 5,
    [ItemConfig.RewardSrc.PartnerLevelUp] = 6,
    [ItemConfig.RewardSrc.Exchange] = 7,
    [ItemConfig.RewardSrc.GiftBag] = 8,
    [ItemConfig.RewardSrc.Strength] = 9,
    [ItemConfig.RewardSrc.MonthCard] = 10,
    --[ItemConfig.RewardSrc.ResDuplicate] = 11,
    [ItemConfig.RewardSrc.Purchase] = 12,
    [ItemConfig.RewardSrc.PurchasePackage] = 13,
    [ItemConfig.RewardSrc.TaskChapterItem] = 14,
    --[ItemConfig.RewardSrc.Duplicate] = 15,
    [ItemConfig.RewardSrc.DailySignIn] = 16,
    [ItemConfig.RewardSrc.DailyTask] = 17,
    [ItemConfig.RewardSrc.RogueLike] = 18,
    [ItemConfig.RewardSrc.Identity] = 19,
    [ItemConfig.RewardSrc.RogueSeasonReward] = 20,
    --[ItemConfig.RewardSrc.CitySimulation] = 21,
    [ItemConfig.RewardSrc.RandomGiftPack] = 22,
    [ItemConfig.RewardSrc.AssetTask] = 23,
    [ItemConfig.RewardSrc.PartnerCenter] = 24,
}

function ItemConfig.IsShowTip(type)
    if ItemConfig.ShowTipsList[type] then
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