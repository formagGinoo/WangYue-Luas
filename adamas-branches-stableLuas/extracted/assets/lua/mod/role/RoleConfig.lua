RoleConfig = RoleConfig or {}

RoleConfig.PageType = {
    Attribute = 1,
    Weapon = 2,
    ZhongMo = 3,
    Mai = 4,
    Skill = 5,
}

RoleConfig.PanelList = {
    [RoleConfig.PageType.Attribute] = "Prefabs/UI/Role/RoleAttributePanel.prefab",
    [RoleConfig.PageType.Weapon] =  "Prefabs/UI/Role/RoleWeaponPanel.prefab",
    [RoleConfig.PageType.Skill] =  "Prefabs/UI/Skill/RoleSkillPanel.prefab",
    [RoleConfig.PageType.Mai] =  "Prefabs/UI/Role/RolePeriod/RoleRightPartPeriodPanel.prefab",
    [RoleConfig.PageType.ZhongMo] =  "Prefabs/UI/Partner/RolePartnerPanel.prefab",
}

RoleConfig.RoleMainToggleInfo = {
    { type = RoleConfig.PageType.Attribute, icon = "RoleAttr", name = TI18N("属性"), callback = function(parent, isSelect)
        if isSelect then
            local isOpenUpgradeWindow = parent.args.isOpenUpgradeWindow
            parent.args.isOpenUpgradeWindow = false
            parent:OpenPanel(RoleAttributePanel,{uid = parent.args.uid, isOpenUpgradeWindow = isOpenUpgradeWindow})
            parent:SetIsCanEnlarge(true)
        else
            parent:GetPanel(RoleAttributePanel):PlayExitAnim()
            parent:SetIsCanEnlarge(false)
        end
    end},
    { type = RoleConfig.PageType.Weapon, icon = "RoleWeapon", name = TI18N("武器"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RoleWeaponPanel,{uid = parent.args.uid, uniqueId = parent.args._jump and parent.args._jump[2]})
        else
            parent:GetPanel(RoleWeaponPanel):PlayExitAnim()
        end
    end },
    { type = RoleConfig.PageType.ZhongMo, icon = "RolePartner", name = TI18N("月灵"), systemId = 301, callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RolePartnerPanel,{uid = parent.args.uid, uniqueId = parent.args._jump and parent.args._jump[2]})
        else
            parent:GetPanel(RolePartnerPanel):PlayExitAnim()
            parent:GetPanel(RolePartnerPanel).RolePartnerSetting3D:PlayExitAnimator()
        end
    end,checkredpoint = function()
		return mod.RoleCtrl:CheckPartnerRedPoint()
	end},
    { type = RoleConfig.PageType.Mai, icon = "RoleStar", name = TI18N("脉象"), systemId = 104, callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RolePeriodPanel,{uid = parent.args.uid})
        else
            parent:ClosePanel(RolePeriodPanel)
        end
    end, checkredpoint = function()
        return mod.RoleCtrl:CheckPeriodRedPoint()
    end },
    { type = RoleConfig.PageType.Skill, icon = "RoleSkill", name = TI18N("技能"), systemId = 103,callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(RoleSkillPanel,{uid = parent.args.uid})
        else
            parent:GetPanel(RoleSkillPanel):PlayExitAnim()
        end
    end,checkredpoint = function()
		return mod.RoleCtrl:CheckSkillRedPoint()
	end},
}

RoleConfig.RoleUpgradeToggleInfo = {
    { type = 1, icon = "RolekLevel", name = TI18N("升级"), callback = function(parent)
        parent:UpdateShow()
    end },
}

RoleConfig.RoleStageUpToggleInfo = {
    { type = 1, icon = "RolekLevel", name = TI18N("突破"), callback = function(parent)
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
    { type = RoleConfig.WeaponPowerUpType.Info, icon = "WeaponAttr", name = TI18N("详情"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponInfoPanel)
        else
            --parent:GetPanel(WeaponInfoPanel):PlayExitAnim()
            parent:ClosePanel(WeaponInfoPanel)
        end
    end },
    { type = RoleConfig.WeaponPowerUpType.Level, icon = "WeaponLevel", name = TI18N("升级"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponUpgradePanelV2)
        else
            parent:GetPanel(WeaponUpgradePanelV2):PlayExitAnim()
        end
    end },
    { type = RoleConfig.WeaponPowerUpType.Stage, icon = "WeaponLevel", name = TI18N("突破"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponStageUpPanel)
        else
            parent:GetPanel(WeaponStageUpPanel):PlayExitAnim()
        end
    end },
    { type = RoleConfig.WeaponPowerUpType.Refine, icon = "WeaponRefine", name = TI18N("精炼"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(WeaponRefinePanel)
        else
            parent:GetPanel(WeaponRefinePanel):PlayExitAnim()
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
    EXSkill = 106,
    LearnSkill = 107,
}

RoleConfig.PartnerSkillSlotType = {
    add_skill = 1,
    add_passive = 2,
    add_plate = 3,
    any = 4,
}

RoleConfig.PartnerPanelToggleInfo = 
{
    {
        type = RoleConfig.PartnerPanelType.Info,
        icon = "PartnerAttr", 
        name = TI18N("详情"), 
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
        name = TI18N("升级"), 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PartnerUpgradePanel)
            else
                parent:ClosePanel(PartnerUpgradePanel)
            end
        end
    },
    {
        type = RoleConfig.PartnerPanelType.LearnSkill,
        icon = "PartnerGrow", 
        name = TI18N("技能"), 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PartnerLearnSkillPanel)
            else
                parent:ClosePanel(PartnerLearnSkillPanel)
            end
        end
    },
    {
        type = RoleConfig.PartnerPanelType.EXSkill,
        icon = "PartnerGrow", 
        name = TI18N("雕纹"), 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PartnerEXSkillPanel)
            else
                parent:ClosePanel(PartnerEXSkillPanel)
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
    WeaponSelect = 4,       --武器选择
    Skill = 5,              --技能界面
    UnEquipPartner = 6,     --未装备月灵
    EquipPartner = 7,       --月灵界面
    FormationN1 = 8,        --编队1号位近
    FormationN2 = 9,        --编队2号位近
    FormationN3 = 10,       --编队3号位近
    Period = 11,            --脉象界面
    PeriodDetails = 12,     --脉象详情
    Enlarge = 13,           --界面放大
    SkillInfo = 14,
}

RoleConfig.PageBlurType = {
    Attr = 1,               --属性界面
    Enlarge = 2,             --武器界面
    LevelUp = 3,            --升级界面
    StageUp = 3,            --突破界面
    Weapon = 4,            --界面放大
    WeaponUp = 5,              --技能界面
    Skill = 6,     --未装备月灵
    UnEquipPartner = 7,       --月灵未佩戴界面
    Period = 9,             --脉象界面
    PeriodDetails = 10,     --脉象详情
}

RoleConfig.MaxStar = 6

local DataHeroCamera = Config.DataHeroCamera.Find
local DataHeroBlur = Config.DataHeroBlur.Find
local DataItem = Config.DataItem.Find

function RoleConfig.GetRoleCameraConfig(roleId, pageId)
	roleId = mod.RoleCtrl:GetRealRoleId(roleId) or 0
    return DataHeroCamera[UtilsBase.GetStringKeys(roleId, pageId)] or DataHeroCamera[UtilsBase.GetStringKeys(0, pageId)]
end

function RoleConfig.GetRoleBlurConfig(roleId, pageId)
    roleId = mod.RoleCtrl:GetRealRoleId(roleId) or 0
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

RoleConfig.PartnerUpgradeItems = 
{
    20411,
    20412,
    20413
}

RoleConfig.HeroBaseInfo = Config.DataHeroMain.Find
RoleConfig.HeroLevInfo = Config.DataHeroLevUpgrade.Find
local DataHeroElement = Config.DataHeroElement.Find

function RoleConfig.GetRoleConfig(roleId)
    return RoleConfig.HeroBaseInfo[roleId]
end

function RoleConfig.GetRoleStageAttr()
    
end

function RoleConfig.GetRoleEntityId(roleId)
    roleId = mod.RoleCtrl:GetRealRoleId(roleId)
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
local WeaponData = Config.DataWeapon.Find

local DataWeaponCamera = Config.DataWeaponCamera.Find
local DataWeaponQuality = Config.DataWeaponQuality.Find

local DataWeaponLevUpgrade = Config.DataWeaponLevUpgrade.Find
local DataWeaponLevAttr = Config.DataWeaponLevAttr.Find
local DataWeaponStageUpgrade = Config.DataWeaponStageUpgrade.Find
local DataWeaponStageAttr = Config.DataWeaponStageAttr.Find
local DataWeaponRefineAttr = Config.DataWeaponRefineAttr.Find

local WeaponTypeData = Config.DataWeaponType.Find
local DataWeaponAsset = Config.DataWeaponAsset.Find


function RoleConfig.GetWeaponLevelAttrs(weaponId,level)
    local key = UtilsBase.GetDoubleKeys(weaponId, level, 32)
    return DataWeaponLevAttr[key].lev_attr
end

function RoleConfig.GetWeaponStageAttrs(weaponId, stage)
    local key = UtilsBase.GetDoubleKeys(weaponId, stage, 32)
    if DataWeaponStageAttr[key] then
        return DataWeaponStageAttr[key].stage_attr
    else
        LogErrorf("配置不存在 weaponId:%s stage:%s", weaponId, stage)
    end
end

function RoleConfig.GetWeaponRefineConfig(weaponId, refineLevel)
    local key = UtilsBase.GetDoubleKeys(weaponId, refineLevel, 32)
    return DataWeaponRefineAttr[key]
end

function RoleConfig.GetStageConfig(id, stage)
    local key = UtilsBase.GetDoubleKeys(id, stage, 32)
    local type = ItemConfig.GetItemType(id)
    if type == BagEnum.BagType.Weapon then
        return DataWeaponStageUpgrade[key]
    end
end

function RoleConfig.GetWeaponLevelExp(weaponId,level)
    local quality = ItemConfig.GetItemConfig(weaponId).quality
    local key = UtilsBase.GetDoubleKeys(quality, level, 32)
	if DataWeaponLevUpgrade[key] then
		return DataWeaponLevUpgrade[key].need_exp
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
    if DataWeaponQuality[quality] then
        return DataWeaponQuality[quality]
    end
end

function RoleConfig.GetWeaponTypeConfig(typeId)
    return WeaponTypeData[typeId]
end

function RoleConfig.GetWeaponBaseAttrs(weaponId, level, stage, attrTable)
    local stageAttr = RoleConfig.GetWeaponStageAttrs(weaponId, stage) or {}
    local levelAttr = RoleConfig.GetWeaponLevelAttrs(weaponId, level)
    attrTable = attrTable or {}
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
    return DataWeaponCamera[weaponId]
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
    TI18N("默认顺序"),
    TI18N("等级顺序"),
    TI18N("品质顺序"),
    TI18N("脉象顺序"),
    TI18N("好感度顺序")
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

function RoleConfig.GetSkillAttr(skillId, level, attrs)
    attrs = attrs or {}
    local levAttr = RoleConfig.GetSkillLevelConfig(skillId, level).fight_attrs
    if levAttr then
        for key, value in pairs(levAttr) do
            attrs[value[1]] = (attrs[value[1]] or 0) + value[2]
        end
    end
    return attrs
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

--#region 月灵相关
local DataPartnerMain = Config.DataPartnerMain.Find
local DataPartnerCamera = Config.DataPartnerCamera.Find
local DataPartnerGrowGrade = Config.DataPartnerGrowGrade.Find
local DataPartnerSkillType = Config.DataPartnerSkillType.Find
local DataPartnerTalent = Config.DataPartnerTalent.Find
local DataPartnerSkill = Config.DataPartnerSkill.Find
local DataPartnerSkillLevel = Config.DataPartnerSkillLevel.Find
local DataPartnerAddAttr = Config.DataPartnerAddAttr.Find
local DataPartnerQuality =  Config.DataPartnerQuality.Find
local DataPartnerBlur = Config.DataPartnerBlur.Find
local DataPartnerLevAttr = Config.DataPartnerLevAttr.Find
local DataPartnerHeroAttr = Config.DataPartnerHeroAttr.Find
local DataPartnerSkillTag = Config.DataPartnerSkillTag.Find
local DataPartnerPlate = Config.DataPartnerPlate
local DataPartnerLevAttrPlan = Config.DataPartnerLevAttrPlan.Find
local DataPartnerSkillCommon = Config.DataPartnerSkillCommon.Find

RoleConfig.PartnerAttrRank = {
    [1] = "D",
    [2] = "C",
    [3] = "B",
    [4] = "A",
    [5] = "S",
}

RoleConfig.PartnerSkillType = {
    Skill = 1,      --战技
    BigNode = 2,    --大节点
    MidNode = 3,    --中节点
    SmallNode = 4,  --小节点
}

RoleConfig.PartnerSkillDesc = 
{
    [RoleConfig.PartnerSkillType.Skill] = TI18N("专属战技"),
    [RoleConfig.PartnerSkillType.BigNode] = TI18N("大节点"),
    [RoleConfig.PartnerSkillType.MidNode] = TI18N("中节点")
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
    PartnerBag = 6,
}

-- 1: 图文教学
-- 2: 仲魔是否获取
-- 3: 物品获取
-- 4: 累计登录
-- 5: 累计物品消耗
-- 6: 累计驾驶距离
-- 7: 累计投喂脉灵
-- 8: 累计完成肉鸽事件
-- 9: 累计购买商店物品
RoleConfig.StatisticType = {
    Teach = 1,
    PartnerGet = 2,
    ItemGet = 3,
    Login = 4,
    ItemExpend = 5,
    TrafficTotalDistance = 6,
    FeedMaiLing = 7,
    Rogue = 8,
    ShopGoods = 9,
}

function RoleConfig.GetPartnerCameraConfig(partnerId, pageId)
    return DataPartnerCamera[UtilsBase.GetStringKeys(partnerId, pageId)] or DataPartnerCamera[UtilsBase.GetStringKeys(0, pageId)]
end

function RoleConfig.GetPartnerBlurConfig(partnerId,pageId)
    return DataPartnerBlur[UtilsBase.GetDoubleKeys(partnerId, pageId)] or DataPartnerBlur[UtilsBase.GetDoubleKeys(0, pageId)]
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

-- 获取是否是推荐属性
function RoleConfig.CheckPartnerPerfectAttr(roleId, attrType)
    if DataPartnerHeroAttr[roleId] then
        for i, attrId in ipairs(DataPartnerHeroAttr[roleId].ui_show_attr) do
            if attrId == attrType then
                return true
            end
        end
    end
    return false
end

--属性总览需要显示的属性
function RoleConfig.PartnerAttrShowList(roleId)
    local attrShowList = {}
    -- 需要显示的属性id
    local showList = TableUtils.CopyTable(DataPartnerHeroAttr[0].ui_show_attr)
    -- 优先排序的
    if DataPartnerHeroAttr[roleId] then
        local specifiedValues =  TableUtils.CopyTable(DataPartnerHeroAttr[roleId].ui_show_attr)
        for i, specAttrId in ipairs(specifiedValues) do
            for _, tempAttrId in pairs(showList) do
                if specAttrId == tempAttrId then
                    table.insert(attrShowList, specAttrId)
                end
            end
        end
    end
    for _, attrId in ipairs(showList) do
        local isSame = false
        for _, attrShowId in ipairs(attrShowList) do
            if attrShowId == attrId then
                isSame = true
            end
        end
        if isSame == false then
            table.insert(attrShowList, attrId)
        end
    end
    return attrShowList
end

-- 通过配从Id获取升级方案
function RoleConfig.GetPartnerLevPlan(partnerId)
    return DataPartnerLevAttr[partnerId]
end

-- 根据等级和方案id查找升级属性和技能点
function RoleConfig.GetPartnerPlanByIdAndLev(planId, lev)
    return DataPartnerLevAttrPlan[string.format("%s_%s", planId, lev)]
end

-- 主动被动标签资源
function RoleConfig.GetPartnerSkillTagConfig(tag)
    return DataPartnerSkillTag[tag]
end

function RoleConfig.GetPartnerConfig(partnerId)
    return DataPartnerMain[partnerId]
end

function RoleConfig.GetPartnerTalentSkill(partnerId)
    --TODO 容错
    return RoleConfig.GetPartnerConfig(partnerId).skill or {}
end

function RoleConfig.GetPartnerSkillConfig(skillId)
    return DataPartnerSkill[skillId]
end

function RoleConfig.GetPartnerSkillTypeConfig(type)
    return DataPartnerSkillType[type]
end

function RoleConfig.GetPartnerSkillLevelConfig(skillId, lev)
--弃用
    local key = UtilsBase.GetDoubleKeys(skillId, lev, 32)
    return DataPartnerSkillLevel[key]
end

function RoleConfig.GetPartnerTalentConfig(talentId)
    return DataPartnerTalent[talentId]
end

function RoleConfig.GetPartnerAttr(partnerId, lev, attrType)
    local planId = RoleConfig.GetPartnerLevPlan(partnerId).plan
    local attrs = RoleConfig.GetPartnerPlanByIdAndLev(planId, lev).lev_attr
    for i, info in ipairs(attrs) do
        if info[1] == attrType then
            return info[2]
        end
    end
    return 0
end

-- 增加通过月灵获得的角色属性
function RoleConfig.GetPartnerBaseAttrs(partnerId, lev, res)
    res = res or {}
    local planId = RoleConfig.GetPartnerLevPlan(partnerId).plan
    local attrs = RoleConfig.GetPartnerPlanByIdAndLev(planId, lev).lev_attr
    for k, v in pairs(attrs) do
        res[v[1]] = (res[v[1]] or 0) + v[2]
    end
    return res
end

-- 增加通过月灵巅峰盘+获得的属性
function RoleConfig.GetPartnerPlateAttr(partnerData, res)
    local res = res or {}
    -- 巅峰盘战技带来的
    for _, skill in pairs(partnerData.skill_list) do
        local config = RoleConfig.GetPartnerSkillConfig(skill.key)
        for key, v in pairs(config.fight_attrs) do
            res[v[1]] = (res[v[1]] or 0) + v[2]
        end
    end
    --巅峰盘加点带来的
    for _, panel in pairs(partnerData.panel_list) do
		for k, skill in pairs(panel.skill_list) do
			if skill.is_active then
				local config = RoleConfig.GetPartnerSkillConfig(skill.skill_id)
				for key, v in pairs(config.fight_attrs) do
                    res[v[1]] = (res[v[1]] or 0) + v[2]
                end

			end
		end
	end
    return res
end

-- 增加通过月灵巅峰盘+获得的属性
function RoleConfig.GetPartnerPassiveSkillAttr(partnerData, res)
    local res = res or {}
    for _, skill in pairs(partnerData.passive_skill_list) do
        local config = RoleConfig.GetPartnerSkillConfig(skill.value)
        for key, v in pairs(config.fight_attrs) do
            res[v[1]] = (res[v[1]] or 0) + v[2]
        end
    end
    return res
end

-- 获取月灵最大等级
function RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    local planId = RoleConfig.GetPartnerLevPlan(partnerId)
    local maxLevel = 1
    while RoleConfig.GetPartnerPlanByIdAndLev(planId.plan, maxLevel) ~= nil do
        maxLevel = maxLevel + 1
    end
    return maxLevel - 1
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

-- 最多多少个被动技能
function RoleConfig.GetPartnerPassiveSkillCount(partnerId)
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    local num = 0
    for i = 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, i)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config and config.add_passive then
            num = num + config.add_passive or 0
        end
    end
    return num
end

function RoleConfig.GetPartenrPassiveSkillCountByLev(partnerId, lev)
    local num = 0
    local key = UtilsBase.GetStringKeys(partnerId, lev)
    local config = Config.DataPartnerSkillRandom.Find[key]
    if config and config.add_passive then
        num = num + config.add_passive or 0
    end
    return num
end

-- 最多有几个战技
function RoleConfig.GetPartnerSkillCount(partnerId)
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    local num = 0
    for i = 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, i)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config and  config.add_skill then
            for _, v in pairs(config.add_skill) do
                if v ~= 0 then
                    num = num + 1
                end
            end
        end
    end
    return num
end

function RoleConfig.GetPartenrSkillCountByLev(partnerId, lev)
    local num = 0
    local key = UtilsBase.GetStringKeys(partnerId, lev)
    local config = Config.DataPartnerSkillRandom.Find[key]
    if config and config.add_skill then
        for _, v in pairs(config.add_skill) do
            if v ~= 0 then
                num = num + 1
            end
        end
    end
    return num
end

function RoleConfig.GetPartnerSkillList(partnerId, lev)
    local count = RoleConfig.GetPartnerSkillCount(partnerId)
    local maxLev = lev or RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    local skillList = {}
    for i = 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, i)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config and config.add_skill then
            for k, v in pairs(config.add_skill) do
                if v ~= 0 then
                    table.insert(skillList, v)
                end
            end
        end
    end
    return skillList
end

function RoleConfig.GetPartnerNextUnlockSkillByType(partnerId, level, type)
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    if level >= maxLev then
        return
    end
    for lev = level + 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, lev)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config then
            if type == RoleConfig.PartnerSkillSlotType.add_skill then
                if #config.add_skill > 0 then
                    return lev, config
                end
            elseif type == RoleConfig.PartnerSkillSlotType.add_passive then
                if config.add_passive > 0 then
                    return lev, config
                end
            elseif type == RoleConfig.PartnerSkillSlotType.add_plate then
                if config.add_plate > 0 then
                    return lev, config
                end
            elseif type == RoleConfig.PartnerSkillSlotType.any then
                if #config.add_skill > 0 or config.add_passive > 0 or config.add_plate > 0 then
                    return lev, config
                end
            end
        end
    end
end


function RoleConfig.GetPartnerNextUnlockSkillCount(partnerId, level)
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    if level >= maxLev then
        return
    end
    for i = level + 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, i)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config and config.add_skill then
            return i, config
        end
    end
end

function RoleConfig.GetPartnerAllUnlockSkillByLevel(partnerId, level)
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerId)
    if level >= maxLev then
        return
    end
    local unLockSkillList = {}
    for i = level + 1, maxLev, 1 do
        local key = UtilsBase.GetStringKeys(partnerId, i)
        local config = Config.DataPartnerSkillRandom.Find[key]
        if config and config.add_skill then
            table.insert(unLockSkillList, config)
        end
    end
    return unLockSkillList
end

function RoleConfig.GetPartnerPlateSkillRamdom(partnerId, point)
    local skillMap = {}
    local skillList = {}
    local key = UtilsBase.GetStringKeys(partnerId, point)
    local config = Config.DataPartnerPlateRandomLib.Find[key]
    if not config then
        return {}
    end
    for _, skill in pairs(config.skill_weight) do
        if not skillMap[skill[1]] and skill[1] ~= 0 then
            skillMap[skill[1]] = true
            table.insert(skillList, skill[1])
        end
    end
    return skillList
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

function RoleConfig.GetPartnerSkillRandomConfig(partnerId, level)
    local key = UtilsBase.GetStringKeys(partnerId, level)
    if not key then
        return
    end
    return Config.DataPartnerSkillRandom.Find[key]
end

--获取月灵固定技能id列表、被动技能数量、巅峰盘数量
function RoleConfig.GetPartnerAllSkillsFromOldToNewLev(partnerId, oldLev, newLev)
    if newLev < oldLev then
        LogError("传入的月灵新等级小于旧等级")
        return
    end
    local add_skill = {}
    local add_passive = 0
    local add_plate = 0
    for lev = oldLev + 1, newLev, 1 do
        local config = RoleConfig.GetPartnerSkillRandomConfig(partnerId, lev)
        if config and config.add_skill then
            for i, id in ipairs(config.add_skill) do
                if id ~= 0 then
                    table.insert(add_skill, id)
                end
            end
        end
        if config and config.add_passive then
            add_passive = add_passive + config.add_passive
        end
        if config and config.add_plate then
            add_plate = add_plate + config.add_plate
        end
    end
    return {add_skill = add_skill, add_passive = add_passive, add_plate = add_plate}
end

function RoleConfig.CalculatePartnerBack(skills, items)
    items = items or {}
    for index, skill in pairs(skills) do
        local config = RoleConfig.GetPartnerSkillConfig(skill.key)
        if skill.value > 1 then
            if config.type == RoleConfig.PartnerSkillType.Talent then
                for i = 2, skill.value, 1 do
                    local skillConfig = RoleConfig.GetPartnerSkillLevelConfig(skill.key, i)
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

function RoleConfig.GetPlateSize(template_id)
    return #DataPartnerPlate.FindbyPartnerId[template_id]
end

function RoleConfig.GetSkillPoint(partnerId, lev)
    local key = UtilsBase.GetStringKeys(DataPartnerLevAttr[partnerId].plan, lev)
    return DataPartnerLevAttrPlan[key].skill_point
end

function RoleConfig.GetPartnerPointMoney()
    return DataPartnerSkillCommon["plate_modify_cost"].int_val
end

function RoleConfig.GetAllPartnerSkills(partnerData, res)
    res = res or {}
    for k, skill in pairs(partnerData.skill_list) do
        table.insert(res, skill.key)
    end

    for k, panel in pairs(partnerData.panel_list) do
        for k, skill in pairs(panel.skill_list) do
            if skill.is_active then
                table.insert(res,skill.skill_id)
            end
        end
    end
    for k, passive_skill in pairs(partnerData.passive_skill_list) do
        table.insert(res, passive_skill.value)
    end
    return res
end
--#endregion

function RoleConfig.GetRolePeriodInfo(roleId, periodIndex)
    roleId = mod.RoleCtrl:GetRealRoleId(roleId)
    local key = UtilsBase.GetStringKeys(roleId, periodIndex)
    return Config.DataHeroStar.Find[key]
end

function RoleConfig.GetRolePeriodSkillAttr(roleId, periodIndex)
    local preiodInfo = RoleConfig.GetRolePeriodInfo(roleId, periodIndex)
    if not preiodInfo then
        return nil
    end

    local skillInfo = RoleConfig.GetSkillLevelConfig(preiodInfo.skill_id, 1)
    if not skillInfo or not skillInfo.fight_attrs then
        return nil
    end

    return skillInfo.fight_attrs
end

function RoleConfig.GetMagicData(value)
    if type(value) == "number" then
        return value, 1
    elseif type(value) == "table" then
        return value[1], value[2] or 1
    end
end

function RoleConfig.SetSkillLevel(skillCfg, level, skillMap, magicMap, entityMap)
    if not skillCfg or not level then return end
    if skillCfg.fight_skills then
        for _, value in pairs(skillCfg.fight_skills) do
            if value ~= 0 then skillMap[value] = level end
        end
    end
    if skillCfg.fight_magics then
        for _, value in pairs(skillCfg.fight_magics) do
            if value ~= 0 then magicMap[value] = level end
        end
    end
    if skillCfg.fight_entities then
        for _, value in pairs(skillCfg.fight_entities) do
            if value ~= 0 then entityMap[value] = level end
        end
    end
end