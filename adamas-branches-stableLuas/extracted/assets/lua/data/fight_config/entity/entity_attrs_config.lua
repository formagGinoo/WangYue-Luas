---@class EntityAttrsConfig
EntityAttrsConfig = EntityAttrsConfig or {}

local AttrsDefine = Config.DataAttrsDefine.AttrsType
local GetMonsterGrowPlan = Config.DataMonsterGrowPlan.GetMonsterGrowPlan
local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataPlayerAttrsDefine = Config.DataPlayerAttrsDefine.Find
---@class AttrType
local AttrType = {
    --固定值属性
    MaxLife = 1, --基础生命
    ExtraMaxLife = 101, --额外生命
    Attack = 2, --基础攻击
    ExtraAttack = 102, --额外攻击
    Defense = 3, --防御
    ExtraDefense = 103, --额外防御
    ElementAtk = 4, --元素精通(状态强度)
    ExtraElementAtk = 104, --额外状态强度
    MaxEnergy = 5, --能量
    LifeBar = 6, --生命条数
    MaxArmor = 7, --霸体值
    RunSpeed = 8, --跑速度
    WalkSpeed = 9, --前走速度
    WalkBackSpeed = 10, --后走速度
    WalkLeftSpeed = 11, --左走速度
    WalkRightSpeed = 12, --右走速度
    RotationSpeed = 13, --角速度
    Gravity = 14, --落地加速度
    Energy_ex = 15, --骇入值
    MaxLife2 = 16,
    MaxLife3 = 17,
    SprintSpeed = 18, --疾跑速度
    CommonShield = 110, --通用护盾
    BaseShield1 = 111, --护盾1
    BaseShield2 = 112, --护盾2
    BaseShield3 = 113, --护盾3
    BaseShield4 = 114, --护盾4
    BaseShield5 = 115, --护盾5
    BaseShield6 = 116, --护盾6
    BaseShield7 = 117, --护盾7
    BaseShield8 = 118, --护盾8
    BaseShield9 = 119, --护盾9

    --万分比属性
    MaxLifePercent = 21, --生命加成
    AttackPercent = 22, --攻击加成
    DefensePercent = 23, --防御加成
    ElementPercent = 24, --元素精通加成(状态强度)
    CritPercent = 25, --暴击率
    CritDefPercent = 26, --暴击抗性
    CritAtkPercent = 27, --暴击伤害
    CritDecPercent = 28, --暴伤减免
    DmgAtkPercent = 29, --伤害加成
    DmgDefercent = 30, --伤害减免
    ArmorDefPercent = 31, --霸体伤害减免
    PartAtkPercent = 32, --部位伤害加成
    PartDefPercent = 33, --部位伤害减免
    CureAtkPercent = 34, --治疗加成
    CureDefPercent = 35, --受治疗加成
    AssassinateDef = 36, --暗杀抗性

    ShieldPercent = 19,  --护盾加成
    SkillPercent = 20, --技能倍率加成
    SkillPointFront = 37,--前台日向回复
    SkillPointBack = 38,--后台日向回复
    ExSkillPointPercent = 39, --月相回复加成
    IgnoreDefPercent = 40, --忽视防御百分比
    WeaknessPercent = 41, --脆弱
    VulPercent = 42, --易伤
    SuppressPercent = 43,--压制
    ElementBreakPercent = 44, --五行击破加成
    NormalAttackSPPercent = 45, --普攻日相恢复加成

    --元素属性
    AtkPercentEl1 = 51, --物理伤害加成
    DefPercentEl1 = 52, --物理抗性
    ThroughPercentEl1 = 53, --物理穿透
    AtkPercentEl2 = 54, --金属性伤害加成
    DefPercentEl2 = 55, --金属性抗性
    ThroughPercentEl2 = 56, --金属性穿透
    AtkPercentEl3 = 57, --木属性伤害加成
    DefPercentEl3 = 58, --木属性抗性
    ThroughPercentEl3 = 59, --木属性穿透
    AtkPercentEl4 = 60, --水属性伤害加成
    DefPercentEl4 = 61, --水属性抗性
    ThroughPercentEl4 = 62, --水属性穿透
    AtkPercentEl5 = 63, --火属性伤害加成
    DefPercentEl5 = 64, --火属性抗性
    ThroughPercentEl5 = 65, --火属性穿透
    AtkPercentEl6 = 66, --土属性伤害加成
    DefPercentEl6 = 67, --土属性抗性
    ThroughPercentEl6 = 68, --土属性穿透

    PartDefPercentEl1 = 80, --部位物理抗性
    PartDefPercentEl2 = 81, --部位金属性抗性
    PartDefPercentEl3 = 82, --部位木属性抗性
    PartDefPercentEl4 = 83, --部位水属性抗性
    PartDefPercentEl5 = 84, --部位火属性抗性 
    PartDefPercentEl6 = 85, --部位土属性抗性   
    WeakPoint = 86,    -- 怪物弱点值

    MaxNormalSkillPoint = 201, --红色消耗技能点
    MaxExSkillPoint = 202, --蓝色消耗技能点
    MaxSkillPoint = 203, --技能点上限
    MaxCoreRes = 204, --核心资源上限
    EnergyCost = 205, --大招消耗能量
    MaxDodge = 206, --最大闪避值

    MaxDefineRes1 = 211,
    MaxDefineRes2 = 212,
    MaxDefineRes3 = 213,
    MaxDefineRes4 = 214,
    MaxDefineRes5 = 215,
    MaxDefineRes6 = 216,
    MaxDefineRes7 = 217,
    MaxDefineRes8 = 218,
    MaxDefineRes9 = 219,
    MaxDefineRes10 = 220,

    MaxCommonAttr1 = 301, -- 所有角色通用属性

    FallDamageReductionPercent = 601,    --坠落伤害降低
    VerticalClimbSpeed = 602,    --纵向攀爬速度
    HorizontalClimbSpeed = 603,    --横向攀爬速度
    ClimbJumpHeight = 604,    --攀爬跳跃高度
    ClimbRunSpeed = 605,    --跑墙速度
    GlideSpeed = 606,    --滑翔水平速度
    SwimSpeed = 607,    --游泳速度
    FastSwimSpeed = 608,    --速泳速度
    WalkSpeedPercent = 609,    --移动速度加成
    RunSpeedPercent = 610,    --跑步速度加成
    SprintSpeedPercent = 611,    --疾跑速度加成
    ClimbSpeedPercent = 612,    --攀爬速度加成
    HorizontalClimbSpeedPercent = 613,    --横向攀爬速度加成, 弃用
    ClimbJumpHeightPercent = 614,    --攀爬跳跃高度加成
    ClimbRunSpeedPercent = 615,    --跑墙速度加成
    GlideSpeedPercent = 616,    --滑翔水平速度加成
    SwimSpeedPercent = 617,    --游泳速度加成
    FastSwimSpeedPercent = 618,    --速泳速度加成
    DodgeCost = 619,    --闪避消耗的体力值
    WalkCost = 620,    --走路消耗体力值
    RunCost = 621,    --跑步消耗体力值
    SprintCost = 622,    --疾跑消耗体力值
    ClimbCost = 623,    --攀爬消耗体力值
    ClimbJumpCost = 624,    --攀爬跳跃消耗体力值
    ClimbRunCost = 625,    --跑墙消耗体力值
    GlideCost = 626,    --滑翔消耗体力值
    SwimCost = 627,    --游泳消耗体力值
    FastSwimCost = 628,    --速泳消耗体力值
    DodgeCostPercent = 629,    --闪避消耗的体力值加成
    WalkCostPercent = 630,    --走路消耗体力值加成
    RunCostPercent = 631,    --跑步消耗体力值加成
    SprintCostPercent = 632,    --疾跑消耗体力值加成
    ClimbCostPercent = 633,    --攀爬消耗体力值加成
    ClimbJumpCostPercent = 634,    --攀爬跳跃消耗体力值加成
    ClimbRunCostPercent = 635,    --跑墙消耗体力值加成
    GlideCostPercent = 636,    --滑翔消耗体力值加成
    SwimCostPercent = 637,    --游泳消耗体力值加成
    FastSwimCostPercent = 638,    --速泳消耗体力值加成
    DebuffDurationPercent = 655,    -- 减益效果持续时间加成
    BuffDurationPercent = 658,  -- 增益BUFF持续时间加成
    JumpCost = 660, --跳跃体力消耗
    InputSpeedPerent = 664,	--摇杆速度加成
    InflictionDebuffDurationPercent = 665,-- 施加减益效果持续时间加成
    InflictionBuffDurationPercent = 666,-- 施加增益BUFF持续时间加成

    -- 当前值，当前值ID比配置最大值ID 大1000
    CurTypeBegin = 1000,
    Life = 1001,
    Energy = 1005,
    Armor = 1007,
    NormalSkillPoint = 1201,
    ExSkillPoint = 1202, --蓝色消耗技能点
    SkillPoint = 1203,
    CoreRes = 1204,
    Dodge = 1206,
    DefineRes1 = 1211,
    DefineRes2 = 1212,
    DefineRes3 = 1213,
    DefineRes4 = 1214,
    DefineRes5 = 1215,
    DefineRes6 = 1216,
    DefineRes7 = 1217,
    DefineRes8 = 1218,
    DefineRes9 = 1219,
    DefineRes10 = 1220,
    CommonAttr1 = 1301,
}

EntityAttrsConfig.AttrType = AttrType

--复合属性，类型与其外显属性一致
local TotalType =
{
    MaxLife = AttrType.MaxLife,
    Attack = AttrType.Attack,
    Defense = AttrType.Defense,
    ElementAtk = AttrType.ElementAtk,
}

EntityAttrsConfig.TotolType = TotalType

--复合属性对应的属性
EntityAttrsConfig.Totol2Attr =
{
    [TotalType.MaxLife] = {AttrType.MaxLife, AttrType.ExtraMaxLife},
    [TotalType.Attack] = {AttrType.Attack, AttrType.ExtraAttack},
    [TotalType.Defense] = {AttrType.Defense, AttrType.ExtraDefense},
    [TotalType.ElementAtk] = {AttrType.ElementAtk, AttrType.ExtraElementAtk},
}
--属性对应的复合属性
EntityAttrsConfig.Attr2Total =
{
    [AttrType.MaxLife] = TotalType.MaxLife,
    [AttrType.ExtraMaxLife] = TotalType.MaxLife,

    [AttrType.Attack] = TotalType.Attack,
    [AttrType.ExtraAttack] = TotalType.Attack,

    [AttrType.Defense] = TotalType.Defense,
    [AttrType.ExtraDefense] = TotalType.Defense,

    [AttrType.ElementAtk] = TotalType.ElementAtk,
    [AttrType.ExtraElementAtk] = TotalType.ElementAtk,
}

EntityAttrsConfig.AttrType2MaxType = {
    [AttrType.Life] = AttrType.MaxLife,
    [AttrType.Energy] = AttrType.MaxEnergy,
    [AttrType.Armor] = AttrType.MaxArmor,
    [AttrType.SkillPoint] = AttrType.MaxSkillPoint,
    [AttrType.CoreRes] = AttrType.MaxCoreRes,
    [AttrType.Dodge] = AttrType.MaxDodge,
    [AttrType.NormalSkillPoint] = AttrType.MaxNormalSkillPoint,
    [AttrType.ExSkillPoint] = AttrType.MaxExSkillPoint,
    [AttrType.DefineRes1] = AttrType.MaxDefineRes1,
    [AttrType.DefineRes2] = AttrType.MaxDefineRes2,
    [AttrType.DefineRes3] = AttrType.MaxDefineRes3,
    [AttrType.DefineRes4] = AttrType.MaxDefineRes4,
    [AttrType.DefineRes5] = AttrType.MaxDefineRes5,
    [AttrType.DefineRes6] = AttrType.MaxDefineRes6,
    [AttrType.DefineRes7] = AttrType.MaxDefineRes7,
    [AttrType.DefineRes8] = AttrType.MaxDefineRes8,
    [AttrType.DefineRes9] = AttrType.MaxDefineRes9,
    [AttrType.DefineRes10] = AttrType.MaxDefineRes10,
    [AttrType.CommonAttr1] = AttrType.MaxCommonAttr1,
}

EntityAttrsConfig.Attr2AttrPercent = {
    [AttrType.MaxLife] = AttrType.MaxLifePercent,
    [AttrType.Attack] = AttrType.AttackPercent,
    [AttrType.Defense] = AttrType.DefensePercent,
    [AttrType.ElementAtk] = AttrType.ElementPercent,
    [AttrType.WalkSpeed] = AttrType.WalkSpeedPercent,
    [AttrType.RunSpeed] = AttrType.RunSpeedPercent,
    [AttrType.SprintSpeed] = AttrType.SprintSpeedPercent,
    [AttrType.VerticalClimbSpeed] = AttrType.ClimbSpeedPercent,
    [AttrType.HorizontalClimbSpeed] = AttrType.ClimbSpeedPercent,
    [AttrType.ClimbJumpHeight] = AttrType.ClimbJumpHeightPercent,
    [AttrType.ClimbRunSpeed] = AttrType.ClimbRunSpeedPercent,
    [AttrType.GlideSpeed] = AttrType.GlideSpeedPercent,
    [AttrType.SwimSpeed] = AttrType.SwimSpeedPercent,
    [AttrType.FastSwimSpeed] = AttrType.FastSwimSpeedPercent,
    [AttrType.DodgeCost] = AttrType.DodgeCostPercent,
    [AttrType.WalkCost] = AttrType.WalkCostPercent,
    [AttrType.RunCost] = AttrType.RunCostPercent,
    [AttrType.SprintCost] = AttrType.SprintCostPercent,
    [AttrType.ClimbCost] = AttrType.ClimbCostPercent,
    [AttrType.ClimbJumpCost] = AttrType.ClimbJumpCostPercent,
    [AttrType.ClimbRunCost] = AttrType.ClimbRunCostPercent,
    [AttrType.GlideCost] = AttrType.GlideCostPercent,
    [AttrType.SwimCost] = AttrType.SwimCostPercent,
    [AttrType.FastSwimCost] = AttrType.FastSwimCostPercent,
}

EntityAttrsConfig.AttrPercent2Attr = {
    [AttrType.MaxLifePercent] = {AttrType.MaxLife},
    [AttrType.AttackPercent] = {AttrType.Attack},
    [AttrType.DefensePercent] = {AttrType.Defense},
    [AttrType.ElementPercent] = {AttrType.ElementAtk},
    [AttrType.WalkSpeedPercent] = {AttrType.WalkSpeed},
    [AttrType.RunSpeedPercent] = {AttrType.RunSpeed},
    [AttrType.SprintSpeedPercent] = {AttrType.SprintSpeed},
    [AttrType.DodgeCostPercent] = {AttrType.DodgeCost},
    [AttrType.WalkCostPercent] = {AttrType.WalkCost},
    [AttrType.RunCostPercent] = {AttrType.RunCost},
    [AttrType.SprintCostPercent] = {AttrType.SprintCost},
    [AttrType.ClimbCostPercent] = {AttrType.ClimbCost},
    [AttrType.ClimbJumpCostPercent] = {AttrType.ClimbJumpCost},
    [AttrType.ClimbRunCostPercent] = {AttrType.ClimbRunCost},
    [AttrType.GlideCostPercent] = {AttrType.GlideCost},
    [AttrType.SwimCostPercent] = {AttrType.SwimCost},
    [AttrType.FastSwimCostPercent] = {AttrType.FastSwimCost},
    [AttrType.ClimbSpeedPercent] = {AttrType.VerticalClimbSpeed, AttrType.HorizontalClimbSpeed},
    [AttrType.ClimbJumpHeightPercent] = {AttrType.ClimbJumpHeight},
    [AttrType.ClimbRunSpeedPercent] = {AttrType.ClimbRunSpeed},
    [AttrType.GlideSpeedPercent] = {AttrType.GlideSpeed},
    [AttrType.SwimSpeedPercent] = {AttrType.SwimSpeed},
    [AttrType.FastSwimSpeedPercent] = {AttrType.FastSwimSpeed},
}

EntityAttrsConfig.SpecialType =
{
    [AttrType.IgnoreDefPercent] = AttrType.IgnoreDefPercent,
}

EntityAttrsConfig.ShieldType =
{
    [AttrType.CommonShield]  = AttrType.CommonShield,
    [AttrType.BaseShield1]  = AttrType.BaseShield1,
    [AttrType.BaseShield2]  = AttrType.BaseShield2,
    [AttrType.BaseShield3]  = AttrType.BaseShield3,
    [AttrType.BaseShield4]  = AttrType.BaseShield4,
    [AttrType.BaseShield5]  = AttrType.BaseShield5,
    [AttrType.BaseShield6]  = AttrType.BaseShield6,
    [AttrType.BaseShield7]  = AttrType.BaseShield7,
    [AttrType.BaseShield8]  = AttrType.BaseShield8,
    [AttrType.BaseShield9]  = AttrType.BaseShield9,
}

--弃用改为配表
EntityAttrsConfig.AllowLessThanZero =
{
    [AttrType.DefPercentEl1] = AttrType.DefPercentEl1,
    [AttrType.DefPercentEl2] = AttrType.DefPercentEl2,
    [AttrType.DefPercentEl3] = AttrType.DefPercentEl3,
    [AttrType.DefPercentEl4] = AttrType.DefPercentEl4,
    [AttrType.DefPercentEl5] = AttrType.DefPercentEl5,
    [AttrType.DefPercentEl6] = AttrType.DefPercentEl6,


    [AttrType.PartDefPercentEl1] = AttrType.PartDefPercentEl1,
    [AttrType.PartDefPercentEl2] = AttrType.PartDefPercentEl2,
    [AttrType.PartDefPercentEl3] = AttrType.PartDefPercentEl3,
    [AttrType.PartDefPercentEl4] = AttrType.PartDefPercentEl4,
    [AttrType.PartDefPercentEl5] = AttrType.PartDefPercentEl5,
    [AttrType.PartDefPercentEl6] = AttrType.PartDefPercentEl6,

	[AttrType.DebuffDurationPercent] = AttrType.DebuffDurationPercent,
	[AttrType.BuffDurationPercent] = AttrType.BuffDurationPercent,

    [AttrType.InflictionDebuffDurationPercent] = AttrType.InflictionDebuffDurationPercent,
	[AttrType.InflictionBuffDurationPercent] = AttrType.InflictionBuffDurationPercent,
}

--越在前越先被扣
EntityAttrsConfig.ShieldPriority =
{
    {AttrType.BaseShield1},
    {AttrType.BaseShield2},
    {AttrType.BaseShield3},
    {AttrType.BaseShield4},
    {AttrType.BaseShield5, AttrType.CommonShield},
    {AttrType.BaseShield6},
    {AttrType.BaseShield7},
    {AttrType.BaseShield8},
    {AttrType.BaseShield9},
}

function EntityAttrsConfig.GetHeroBaseAttr(heroConfigId, level, res)
    local hero_id = mod.RoleCtrl:GetRealRoleId(heroConfigId)
    local attrId = UtilsBase.GetStringKeys(hero_id, level)
    local hero_attrs = Config.DataHeroLevAttr.Find[attrId]
    assert(hero_attrs, "GetHeroBaseAttr attrs null " .. attrId)
    return EntityAttrsConfig.GetBaseAttr(hero_attrs.lev_attr, res)
end

function EntityAttrsConfig.GetHeroStageAttr(heroConfigId, stage, res)
    local hero_id = mod.RoleCtrl:GetRealRoleId(heroConfigId)
    local attrId = UtilsBase.GetStringKeys(hero_id, stage)
    local hero_attrs = Config.DataHeroStageAttr.Find[attrId]
    assert(hero_attrs, "GetHeroStageAttr attrs null " .. attrId)
    return EntityAttrsConfig.GetStageAttr(hero_attrs.stage_attr, res)
end

function EntityAttrsConfig.GetMonsterBaseAttr(monsterConfigId, level)
    local baseCfg = Config.DataMonsterAttr.Find[monsterConfigId]

    if not baseCfg or not next(baseCfg) then
        LogError("monster base attr is null, monsterAttrId = " .. monsterConfigId)
        return
    end

    local attrs = {}
    for k, v in pairs(baseCfg) do
        if k ~= "id" then
            attrs[AttrsDefine[k][1]] = v
        end
    end

    local growCfg = Config.DataMonsterGrowAttr.Find[monsterConfigId]
    if growCfg and next(growCfg) then
        for k, v in pairs(growCfg) do
            if k == "id" then
                goto continue
            end

            local attrType = AttrsDefine[k][1]
            local growDatas = GetMonsterGrowPlan[v]
            if not attrs[attrType] or not growDatas then
                goto continue
            end

            --TODO 优化:给属性成长方案做等级映射,减少这里的遍历
            --找到对应的等级
            local count = #growDatas
            for i, growData in ipairs(growDatas) do
                if level <= growData[2] and level >= growData[1] or i == count then
                    local rate = growData[3] / 10000
                    attrs[attrType] = attrs[attrType] * rate
                    break
                end
            end

            :: continue ::
        end
    end

    for k, v in pairs(AttrType) do
        if not attrs[v] then
            attrs[v] = 0
        end
    end

    attrs[AttrType.Life] = attrs[AttrType.MaxLife]

    return attrs
end

function EntityAttrsConfig.GetBaseAttr(attrsConfig, attrs)
    attrs = attrs or {}
    for k, v in pairs(attrsConfig) do
        local attrType = AttrsDefine[k][1]
        if attrType == nil then
            print(attrs[attrType], attrType, k, v)
        end
        attrs[attrType] = (attrs[attrType] or 0) + v
    end

    for k, v in pairs(AttrType) do
        if not attrs[v] then
            attrs[v] = 0
        end
    end

    attrs[AttrType.Life] = attrs[AttrType.MaxLife]

    return attrs
end

function EntityAttrsConfig.GetStageAttr(attrsConfig, attrs)
    attrs = attrs or {}
    for k, v in pairs(attrsConfig) do
        local attrType = v[1]
        local value = v[2]
        attrs[attrType] = (attrs[attrType] or 0) + value
    end

    for k, v in pairs(AttrType) do
        if not attrs[v] then
            attrs[v] = 0
        end
    end

    attrs[AttrType.Life] = attrs[AttrType.MaxLife]

    return attrs
end

function EntityAttrsConfig.GetPlayAttrName(type)
    if DataPlayerAttrsDefine[type] then
        return DataPlayerAttrsDefine[type].name
    elseif type > 1000 then
        return "(当前)"..DataPlayerAttrsDefine[type - 1000].name
    end
    return "未定义"
end
function EntityAttrsConfig.GetAttrName(type)
    if DataAttrsDefine[type] then
        return DataAttrsDefine[type].name
    elseif type > 1000 then
        return "(当前)"..DataAttrsDefine[type - 1000].name
    end
    return "未定义"
end

local defaultMax = 9999999
function EntityAttrsConfig.GetEntityAttrValue(attrType, value)
    if DataAttrsDefine[attrType] then
        local min = DataAttrsDefine[attrType].min_value
        local max = DataAttrsDefine[attrType].max_value == 0 and defaultMax or DataAttrsDefine[attrType].max_value
        if DataAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
            min = min * 0.0001
            max = max * 0.0001
        end
        return MathX.Clamp(value, min, max)
    else
        return math.max(0, value)
    end
end

function EntityAttrsConfig.GetPlayAttrValue(attrType, value)
    if DataPlayerAttrsDefine[attrType] then
        local min = DataPlayerAttrsDefine[attrType].min_value
        local max = DataPlayerAttrsDefine[attrType].max_value == 0 and defaultMax or DataPlayerAttrsDefine[attrType].max_value
        if DataPlayerAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
            min = min * 0.0001
            max = max * 0.0001
        end
        return MathX.Clamp(value, min, max)
    else
        return math.max(0, value)
    end
end