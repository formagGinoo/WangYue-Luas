RoleConfig = RoleConfig or {}

RoleConfig.PageType = {
    Attribute = 1,
    Weapon = 2,
    ZhongMo = 3,
    Mai = 4,
    Skill = 5,
}

RoleConfig.RoleMainToggleInfo = {
    { type = RoleConfig.PageType.Attribute, icon = "RoleAttr", name = "属性", callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RoleAttributePanel)
            parent:SetIsCanEnlarge(true)
        else
            parent:ClosePanel(RoleAttributePanel)
            parent:SetIsCanEnlarge(false)
        end
    end},
    { type = RoleConfig.PageType.Weapon, icon = "RoleWeapon", name = "武器", callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RoleWeaponPanel)
        else
            parent:ClosePanel(RoleWeaponPanel)
        end
    end },
    { type = RoleConfig.PageType.ZhongMo, icon = "RolePartner", name = "佩从", systemId = 301, callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RolePartnerPanel)
        else
            parent:ClosePanel(RolePartnerPanel)
        end
    end,checkredpoint = function()
		return mod.RoleCtrl:CheckPartnerRedPoint()
	end},
    { type = RoleConfig.PageType.Mai, icon = "", name = "脉象", systemId = 104, callback = function()
    end },
    { type = RoleConfig.PageType.Skill, icon = "RoleSkill", name = "技能", systemId = 103,callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RoleSkillPanel)
        else
            parent:ClosePanel(RoleSkillPanel)
        end
    end,checkredpoint = function()
		return mod.RoleCtrl:CheckSkillRedPoint()
	end},
}

RoleConfig.RoleUpgradeToggleInfo = {
    { type = 1, icon = "RolekLevel", name = "升级", callback = function(parent)
        parent:UpdateShow()
    end },
}

RoleConfig.RoleStageUpToggleInfo = {
    { type = 1, icon = "RolekLevel", name = "突破", callback = function(parent)
        parent:UpdateShow()
    end },
}

RoleConfig.WeaponPowerUpType = {
    Info = 101,
    Level = 102,
    Stage = 103,
    Refine = 104
}

RoleConfig.WeaponPowerUpToggleInfo = {
    { type = RoleConfig.WeaponPowerUpType.Info, icon = "WeaponAttr", name = "详情", callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponInfoPanel)
        else
            parent:ClosePanel(WeaponInfoPanel)
        end
    end },
    { type = RoleConfig.WeaponPowerUpType.Level, icon = "WeaponLevel", name = "升级", callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponUpgradePanelV2)
        else
            parent:ClosePanel(WeaponUpgradePanelV2)
        end
    end },
    { type = RoleConfig.WeaponPowerUpType.Stage, icon = "WeaponLevel", name = "突破", callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponStageUpPanel)
        else
            parent:ClosePanel(WeaponStageUpPanel)
        end
    end },
    { type = RoleConfig.WeaponPowerUpType.Refine, icon = "WeaponRefine", name = "精炼", callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponRefinePanel)
        else
            parent:ClosePanel(WeaponRefinePanel)
        end
    end },
}

RoleConfig.PartnerPanelType = 
{
    Info = 101,
    Level = 102,
    Talent = 103,
    Mix = 104,
    Qulity = 105,
}

RoleConfig.PartnerPanelToggleInfo = 
{
    {
        type = RoleConfig.PartnerPanelType.Info,
        icon = "PartnerAttr", 
        name = "详情", 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PartnerInfoPanel)
            else
                parent:ClosePanel(PartnerInfoPanel)
            end
        end
    },
    {
        type = RoleConfig.PartnerPanelType.Level,
        icon = "PartnerLevel", 
        name = "升级", 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PartnerUpgradePanel)
            else
                parent:ClosePanel(PartnerUpgradePanel)
            end
        end
    },
    {
        type = RoleConfig.PartnerPanelType.Talent,
        icon = "PartnerSkill", 
        name = "天赋", 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PartnerTalentPanel)
            else
                parent:ClosePanel(PartnerTalentPanel)
            end
        end
    },
    {
        type = RoleConfig.PartnerPanelType.Mix,
        icon = "PartnerCompose", 
        name = "合成", 
        callback = function(parent, isSelect)
            if isSelect then
            else
            end
        end
    },
    {
        type = RoleConfig.PartnerPanelType.Qulity,
        icon = "PartnerGrow", 
        name = "资质", 
        callback = function(parent, isSelect)
            if isSelect then
            else
            end
        end
    },
}

RoleConfig.PartnerShowType = {
    defGet = 1,
    showEffect = 2,
}

RoleConfig.PageCameraType = {
    Attr = 1,               --属性界面
    Weapon = 2,             --武器界面
    LevelUp = 3,            --升级界面
    StageUp = 3,            --突破界面
    Enlarge = 3,            --界面放大
    WeaponSelect = 4,       --武器选择
    Skill = 5,              --技能界面
    UnEquipPartner = 6,     --未装备佩从
    EquipPartner = 7,       --佩从界面
    FormationN1 = 8,        --编队1号位近
    FormationN2 = 9,        --编队2号位近
    FormationN3 = 10,       --编队3号位近
}

RoleConfig.PageBlurType = {
    Attr = 1,               --属性界面
    Enlarge = 2,             --武器界面
    LevelUp = 3,            --升级界面
    StageUp = 3,            --突破界面
    Weapon = 4,            --界面放大
    WeaponUp = 5,              --技能界面
    Skill = 6,     --未装备佩从
    UnEquipPartner = 7,       --佩从未佩戴界面
    EquipPartner = 7,       --佩从界面
}

local DataHeroCamera = Config.DataHeroCamera.Find
local DataHeroBlur = Config.DataHeroBlur.Find

function RoleConfig.GetRoleCameraConfig(roleId, pageId)
	roleId = roleId or 0
    return DataHeroCamera[UtilsBase.GetStringKeys(roleId, pageId)] or DataHeroCamera[UtilsBase.GetStringKeys(0, pageId)]
end

function RoleConfig.GetRoleBlurConfig(roleId, pageId)
    roleId = roleId or 0
    return DataHeroBlur[UtilsBase.GetDoubleKeys(roleId, pageId)] or DataHeroBlur[UtilsBase.GetDoubleKeys(0, pageId)]
end

RoleConfig.Idx2Element = {
    [2] = "gold",
    [3] = "wood",
    [4] = "water",
    [5] = "fire",
    [6] = "earth",
}

RoleConfig.UpgradeItems = {
    20101,
    20102,
    20103
}

RoleConfig.WeaponUpgradeItems = 
{
    20201,
    20202,
    20203
}

RoleConfig.HeroBaseInfo = Config.DataHeroMain.Find
RoleConfig.HeroLevInfo = Config.DataHeroLevUpgrade.Find
local DataHeroElement = Config.DataHeroElement.Find

function RoleConfig.GetRoleConfig(roleId)
    return RoleConfig.HeroBaseInfo[roleId]
end

function RoleConfig.GetRoleEntityId(roleId)
    local config = RoleConfig.HeroBaseInfo[roleId]
    if config then
        return config.entity_id
    end
end

function RoleConfig.GetAElementIcon(element)
    return DataHeroElement[element].element_icon_big
end

local DataAttrsDefine = Config.DataAttrsDefine.Find

function RoleConfig.GetAttrConfig(id)
    return DataAttrsDefine[id]
end

--返回属性名称以及用于显示的值
function RoleConfig.GetShowAttr(attrType, attrValue)
    local config = RoleConfig.GetAttrConfig(attrType)
    if FightEnum.AttrValueType.Percent == config.value_type then
        attrValue = attrValue / 100 .."%"
    end
    return config.name, attrValue
end

function RoleConfig.GetAttrPriority(attrType)
    local config = RoleConfig.GetAttrConfig(attrType)
    return config.priority or 0
end

function RoleConfig.GetRoleDmgType(roleId)
    return RoleConfig.HeroBaseInfo[roleId].dmgtype
end

--#region 武器相关
local WeaponData = Config.DataWeapon
local WeaponLevData = Config.DataWeaponLevel
local WeaponTypeData = Config.DataWeapon.data_weapon_type
local DataWeaponAsset = Config.DataWeapon.data_weapon_asset

function RoleConfig.GetWeaponLevelAttrs(weaponId,level)
    local key = UtilsBase.GetDoubleKeys(weaponId, level, 32)
    return WeaponLevData.data_weapon_lev_attr[key].lev_attr
end

function RoleConfig.GetWeaponStageAttrs(weaponId, stage)
    local key = UtilsBase.GetDoubleKeys(weaponId, stage, 32)
    if WeaponLevData.data_weapon_stage_attr[key] then
        return WeaponLevData.data_weapon_stage_attr[key].stage_attr
    end
end

function RoleConfig.GetWeaponRefineConfig(weaponId, refineLevel)
    local key = UtilsBase.GetDoubleKeys(weaponId, refineLevel, 32)
    return WeaponLevData.data_weapon_refine_attr[key]
end

function RoleConfig.GetStageConfig(id, stage)
    local key = UtilsBase.GetDoubleKeys(id, stage, 32)
    local type = ItemConfig.GetItemType(id)
    if type == BagEnum.BagType.Weapon then
        return WeaponLevData.data_weapon_stage_upgrade[key]
    end
end

function RoleConfig.GetWeaponLevelExp(weaponId,level)
    local quality = ItemConfig.GetItemConfig(weaponId).quality
    local key = UtilsBase.GetDoubleKeys(quality, level, 32)
	if WeaponLevData.data_weapon_lev_upgrade[key] then
		return WeaponLevData.data_weapon_lev_upgrade[key].need_exp
	end
end

function RoleConfig.GetWeaponAsset(weaponId)
    if DataWeaponAsset[ItemConfig.GetItemConfig(weaponId).asset_id] then
        return DataWeaponAsset[ItemConfig.GetItemConfig(weaponId).asset_id].model_config
    else
        LogError(string.format("获取武器【%s】的资源【%s】失败", weaponId, ItemConfig.GetItemConfig(weaponId).asset_id))
    end

end

function RoleConfig.GetWeaponQualityConfig(weaponId)
	local quality = ItemConfig.GetItemConfig(weaponId).quality
    if WeaponData.data_weapon_quality[quality] then
        return WeaponData.data_weapon_quality[quality]
    end
end

function RoleConfig.GetWeaponTypeConfig(typeId)
    return WeaponTypeData[typeId]
end

function RoleConfig.GetWeaponBaseAttrs(weaponId, level, stage)
    local stageAttr = RoleConfig.GetWeaponStageAttrs(weaponId, stage) or {}
    local levelAttr = RoleConfig.GetWeaponLevelAttrs(weaponId, level)
    local attrTable = {}
    for k, v in ipairs(levelAttr) do
        if attrTable[v[1]] then
            attrTable[v[1]] =  attrTable[v[1]] + v[2]
        else
            attrTable[v[1]] = v[2]
        end
    end
    for k, v in ipairs(stageAttr) do
        if attrTable[v[1]] then
            attrTable[v[1]] =  attrTable[v[1]] + v[2]
        else
            attrTable[v[1]] = v[2]
        end
    end
    return attrTable
end

function RoleConfig:GetAttrPriorityTable(attrTable)
    local attrs = {}
    for key, value in pairs(attrTable) do
        local attr = {key = key, priority = 1}
        table.insert(attrs, attr)
    end

    table.sort(attrs, function (a, b)
        return a.priority > b.priority
    end)
end

function RoleConfig.GetWeaponCameraConfig(weaponId)
    return WeaponData.data_weapon_camera[weaponId]
end


RoleConfig.RoleSortType =
{
    default = 1,
    level = 2,
    quality = 3,
    MaiXiang = 4,
    HaoGan = 5
}

RoleConfig.RoleSortText =
{
    "默认顺序",
    "等级顺序",
    "品质顺序",
    "脉象顺序",
    "好感度顺序"
}

--#endregion

--#region 技能相关
local DataSkill = Config.DataSkill
local DataSkillLevel = Config.DataSkillLevel.Find
local DataSkillUiType = Config.DataSkillUiType.Find
local DataSkillType = Config.DataSkillType.Find
local DataHeroLevel = Config.DataHeroStageUpgrade

function RoleConfig.GetRoleSkill(roleId)
    return DataSkill.FindbyRoleId[roleId]
end

function RoleConfig.GetSkillConfig(skillId)
    return DataSkill.Find[skillId]
end

function RoleConfig.GetSkillLevelConfig(skillId, level)
    local index = UtilsBase.GetStringKeys(skillId, level)
    return DataSkillLevel[index]
end

function RoleConfig.GetSkillUiConfig(skillId)
    local config = RoleConfig.GetSkillConfig(skillId)
    if config then
        return DataSkillUiType[config.ui_type]
    end
end

function RoleConfig.GetSkillTypeName(type)
    if DataSkillType[type] then
        return DataSkillType[type].name
    end
end

function RoleConfig.GetRoleSkillLevelLimit(roleId, stage)
    local key = UtilsBase.GetStringKeys(roleId, stage)
    if DataHeroLevel.Find then
        return DataHeroLevel.Find[key].limit_hero_skill_lev
    end
end

function RoleConfig.GetSkillUnlockStage(skillId)
    if DataHeroLevel.FindDeblockSkillIdInfo[skillId] then
        return DataHeroLevel.FindDeblockSkillIdInfo[skillId].stage
    end
end

--#endregion

--#region 佩从相关
local DataPartnerMain = Config.DataPartnerMain.Find
local DataPartnerCamera = Config.DataPartnerCamera.Find
local DataPartnerGrowGrade = Config.DataPartnerGrowGrade.Find
local DataPartnerSkillType = Config.DataPartnerSkillType.Find
local DataPartnerTalent = Config.DataPartnerTalent.Find
local DataPartnerSkill = Config.DataPartnerSkill
local DataPartnerSkillLevel = Config.DataPartnerSkillLevel.Find
local DataPartnerAddAttr = Config.DataPartnerAddAttr.Find
local DataPartnerQuality =  Config.DataPartnerQuality.Find

RoleConfig.PartnerMaxLev = 20
RoleConfig.PartnerAttrRank = {
    [1] = "D",
    [2] = "C",
    [3] = "B",
    [4] = "A",
    [5] = "S",
}

RoleConfig.PartnerSkillType = {
    Talent = 1,
    Specificity = 2,
    Common = 3,
}

RoleConfig.PartnerSkillDesc = 
{
    [RoleConfig.PartnerSkillType.Talent] = "职业天赋",
    [RoleConfig.PartnerSkillType.Specificity] = "专属战技",
    [RoleConfig.PartnerSkillType.Common] = "通用战技"
}


function RoleConfig.GetPartnerEntityId(partnerId)
    if partnerId then
        if DataPartnerMain[partnerId] then
            return DataPartnerMain[partnerId].entity_id
        end
        return partnerId
    end
end

RoleConfig.PartnerCameraType = 
{
    Normal = 1,
    Select = 2,
    Info = 3,
    Level = 4,
    Talent = 5,
}

RoleConfig.StatisticType = {
    Teach = 1,
    PartnerGet = 2,
}

function RoleConfig.GetPartnerCameraConfig(partnerId, pageId)
    return DataPartnerCamera[UtilsBase.GetStringKeys(partnerId, pageId)] or DataPartnerCamera[UtilsBase.GetStringKeys(0, pageId)]
end

function RoleConfig.GetPartnerAttrRank(attrType, attrValue)
    local weightSetting = DataPartnerGrowGrade[attrType].grow_weight
    for i = #weightSetting, 1, -1 do
        if attrValue >= weightSetting[i].min_value then
            local icon = string.format("Textures/Icon/Single/Partner/rank_%s.png",RoleConfig.PartnerAttrRank[weightSetting[i].result])
            return weightSetting[i].result, icon
        end
    end
end

function RoleConfig.GetPartnerConfig(partnerId)
    return DataPartnerMain[partnerId]
end

function RoleConfig.GetPartnerTalentSkill(partnerId)
    return RoleConfig.GetPartnerConfig(partnerId).skill
end

function RoleConfig.GetPartnerSkillConfig(skillId)
    return DataPartnerSkill.Find[skillId]
end

function RoleConfig.GetPartnerSkillTypeConfig(type)
    return DataPartnerSkillType[type]
end

function RoleConfig.GetPartnerSkillLevelConfig(skillId, lev)
    local key = UtilsBase.GetDoubleKeys(skillId, lev, 32)
    return DataPartnerSkillLevel[key]
end

function RoleConfig.GetPartnerTalentConfig(talentId)
    return DataPartnerTalent[talentId]
end

function RoleConfig.GetPartnerAttr(partnerId, lev, attrType, addValue)
    local addAttrId = RoleConfig.GetPartnerConfig(partnerId).add_attr_id
    local attrKey = RoleConfig.GetAttrConfig(attrType).refer_name
    local baseAttr = DataPartnerAddAttr[addAttrId].lev_attr[attrKey]
    return baseAttr + lev * addValue
end

function RoleConfig.GetPartnerQualityConfig(partnerId)
    local config = RoleConfig.GetPartnerConfig(partnerId)
    return DataPartnerQuality[config.quality]
end

function RoleConfig.GetPartnerSkillMaxLev(partnerId)
    return RoleConfig.GetPartnerConfig(partnerId).skill_level_limit
end

function RoleConfig.GetPartnerLevelExp(partnerId, level)
	local quality = RoleConfig.GetPartnerConfig(partnerId).quality
    local key = UtilsBase.GetStringKeys(quality, level)
    return Config.DataPartnerLevUpgrade.Find[key] and Config.DataPartnerLevUpgrade.Find[key].need_exp
end

function RoleConfig.GetPartnerBaseExp(partnerId)
    if Config.DataPartnerExp[partnerId] then
        local config = Config.DataPartnerExp.Find[partnerId]
        return config.exp, config.cost
    end
    local quality = RoleConfig.GetPartnerConfig(partnerId).quality
    local config = Config.DataPartnerExp.Find[quality]
    if config then
        return config.exp, config.cost
    end
    return 0, 0
end

function RoleConfig.GetPartnerNextUnlockSkillCount(partnerId, level)
    local maxLev = RoleConfig.PartnerMaxLev
    if level >= maxLev then
        return
    end
    for i = level + 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, i)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config then
            return i, config.random_num
        end
    end
end

function RoleConfig.GetPartnerSkillRandom(partnerId, level)
    local skillMap = {}
    local skillList = {}
    local key = UtilsBase.GetStringKeys(partnerId, level)
    local config = Config.DataPartnerSkillRandom.Find[key]
    for _, value in pairs(config.random_lib) do
        if value ~= 0 then
            for _, skill in ipairs(Config.DataPartnerSkillRandomLib.Find[value].weight) do
                if not skillMap[skill[1]] then
                    skillMap[skill[1]] = true
                    local priority = RoleConfig.GetPartnerSkillConfig(skill[1]).priority
                    table.insert(skillList, skill[1])
                end
            end
        end
    end
    table.sort(skillList,function (a, b)
        return RoleConfig.GetPartnerSkillConfig(a).priority > RoleConfig.GetPartnerSkillConfig(b).priority
    end)
    return skillList
end

function RoleConfig.CalculatePartnerBack(skills, items)
    items = items or {}
    for index, skill in pairs(skills) do
        local config = RoleConfig.GetPartnerSkillConfig(skill.key)
        if skill.value > 1 then
            if config.type == RoleConfig.PartnerSkillType.Talent then
                for i = 2, skill.value, 1 do
                    local skillConfig = RoleConfig.GetPartnerSkillLevelConfig(skill.key, skill.value)
                    for _, value in pairs(skillConfig.need_item) do
                        items[value[1]] = items[value[1]] or 0
                        items[value[1]] = items[value[1]] + value[2]
                    end
                end
            end
        end
    end
    return items
end

--#endregion