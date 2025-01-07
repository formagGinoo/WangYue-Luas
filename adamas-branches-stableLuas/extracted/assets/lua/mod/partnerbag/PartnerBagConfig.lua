PartnerBagConfig = {}

local PartnerWorkMain = Config.DataPartnerWorkMain.Find
local PartnerWorkCareer = Config.DataPartnerWorkCareer.Find
local PartnerWorkAffix = Config.DataPartnerWorkAffix.Find
local PartnerWorkCommon = Config.DataPartnerWorkCommon.Find
local PartnerWorkCareerLevel = Config.DataPartnerWorkCareerLevel.Find

PartnerBagConfig.PartnerWorkCommonEnum = {
    PartnerHungerPercent = "PartnerHungerPercent", -- 低于多少万分比的饱食度时，月灵进入饥饿状态
    PartnerSadPercent = "PartnerSadPercent", -- 低于多少万分比的san值时，月灵进入抑郁状态
    PartnerFusionJumpId = "PartnerFusionJumpId", -- 融合按钮ui跳转id
}


--佩丛工作状态枚举
PartnerBagConfig.PartnerWorkStatusEnum = {
    None = 0, --无
    Work = 1, --工作
    Eat = 2, --吃饭
    Sleep = 3, --睡觉
}

--排序
PartnerBagConfig.SortType = {
    SortByQuality = 1, -- 按品质排序
    SortByLevel = 2, -- 按等级排序
    SortByCareerLevel = 3, -- 按职业等级排序
}

--排序对应名字
PartnerBagConfig.PartnerSortTypeToName = {
    [PartnerBagConfig.SortType.SortByQuality] = TI18N("品质顺序"),
    [PartnerBagConfig.SortType.SortByLevel] = TI18N("等级顺序"),
    [PartnerBagConfig.SortType.SortByCareerLevel] = TI18N("职业等级顺序"),
}

--佩丛职业特性枚举
PartnerBagConfig.PartnerWorkAffixEnum = {
    SpeedUp = 1, --工作速度值加成
    FeedMaxUp = 2, --饱食度上限增加
    SanMaxUp = 3, --san值上限增加
    FeedDown = 4, --工作时饱食度下降值
    SanDown = 5, --工作时san值下降值
    SanRev = 6, --san值回复
}

--佩丛技能
PartnerBagConfig.PartnerSkillType = {
    FightSkill = 21, --战斗技能
    ExploreSkill = 22, --探索技能
    SelfPassiveSkill = 23, --专属被动
}

--佩丛技能对应技能名
PartnerBagConfig.PartnerSkillTypeToName = {
    [PartnerBagConfig.PartnerSkillType.FightSkill] = TI18N("战斗技能"), --战斗技能
    [PartnerBagConfig.PartnerSkillType.ExploreSkill] = TI18N("探索技能"), --探索技能
    [PartnerBagConfig.PartnerSkillType.SelfPassiveSkill] = TI18N("专属被动"), --专属被动
}


--佩丛背包详情界面页签
PartnerBagConfig.PartnerBagPanelType =
{
    Attr = 101,
    Work = 102,
    Skill = 103,
}

PartnerBagConfig.PartnerDetailsToggleInfo = {
    { type = PartnerBagConfig.PartnerBagPanelType.Attr, icon = "PartnerAttr", name = TI18N("属性"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(PartnerBagAttrPanel, {uniqueId = parent.args.unique_id})
        else
            parent:ClosePanel(PartnerBagAttrPanel)
        end
    end },
    { type = PartnerBagConfig.PartnerBagPanelType.Work, icon = "PartnerCompose", name = TI18N("工作"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(PartnerBagWorkPanel, {uniqueId = parent.args.unique_id})
        else
            parent:ClosePanel(PartnerBagWorkPanel)
        end
    end },
    { type = PartnerBagConfig.PartnerBagPanelType.Skill, icon = "PartnerSkill", name = TI18N("技能"), callback = function(parent, isSelect)
        if isSelect then
            parent:OpenPanel(PartnerBagSkillPanel, {uniqueId = parent.args.unique_id})
        else
            parent:ClosePanel(PartnerBagSkillPanel)
        end
    end },
}

function PartnerBagConfig.GetSortTypeName(sortType)
    return PartnerBagConfig.PartnerSortTypeToName[sortType]
end

function PartnerBagConfig.GetPartnerMaxCareerLv(template_id)
    local baseCfg = PartnerWorkMain[template_id]
    local maxCareerLv = 0
    if not baseCfg then 
        return maxCareerLv
    end
    
    for i, v in ipairs(baseCfg.career) do
        if v[2] and v[2] > maxCareerLv then
            maxCareerLv = v[2]
        end
    end
    return maxCareerLv
end

function PartnerBagConfig.GetPartnerMaxCareerIdAndLv(template_id)
    local baseCfg = PartnerWorkMain[template_id]
    if not baseCfg then
        return 0, 0
    end
    local maxCareerId = 0
    local maxCareerLv = 0
    
    for i, v in ipairs(baseCfg.career) do
        if v[2] and v[2] > maxCareerLv then
            maxCareerId = v[1]
            maxCareerLv = v[2]
        end
    end
    return maxCareerId, maxCareerLv
end

function PartnerBagConfig.GetPartnerMaxCareerIdAndLvBySort(template_id)
    local baseCfg = PartnerWorkMain[template_id]
    if not baseCfg then
        return 0, 0
    end
    local tb = TableUtils.CopyTable(baseCfg.career)
    local maxCareerId = 0
    local maxCareerLv = 0
    
    table.sort(tb, function(a, b)
        if a[2] ~= b[2] then
            return a[2] > b[2]
        end
        if a[1] ~= b[1] then
            return a[1] < b[1]
        end
        return false
    end)
    maxCareerId = baseCfg.career[1][1]
    maxCareerLv = baseCfg.career[1][2]
    return maxCareerId, maxCareerLv
end

function PartnerBagConfig.GetPartnerWorkConfig(template_id)
    return PartnerWorkMain[template_id]
end

function PartnerBagConfig.GetPartnerAllWorkCareer()
    return PartnerWorkCareer
end

function PartnerBagConfig.GetPartnerWorkCareerCfgById(careerId)
    return PartnerWorkCareer[careerId]
end

function PartnerBagConfig.GetPartnerWorkAffixCfg(affixId, lv)
    local key = UtilsBase.GetDoubleKeys(affixId, lv)
    return PartnerWorkAffix[key]
end

function PartnerBagConfig.GetPartnerWorkCommonCfg(key)
    return PartnerWorkCommon[key].int_val
end

function PartnerBagConfig.GetPartnerWorkCareerLevelCfg(careerId, careerLv)
    local key = UtilsBase.GetDoubleKeys(careerId, careerLv)
    return PartnerWorkCareerLevel[key]
end

