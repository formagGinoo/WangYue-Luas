---@class EntityAttrsConfig
EntityAttrsConfig = EntityAttrsConfig or {}

local AttrsDefine = Config.DataAttrsDefine.AttrsType

---@class AttrType
local AttrType = {
    --固定值属性
    MaxLife = 1, --生命
    Attack = 2, --攻击
    Defense = 3, --防御
    ElementAtk = 4, --元素精通
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

    --万分比属性
    MaxLifePercent = 21, --生命加成
    AttackPercent = 22, --攻击加成
    DefensePercent = 23, --防御加成
    ElementPercent = 24, --元素精通加成
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
    AtkPercentEl6 = 66, --暗属性伤害加成
    DefPercentEl6 = 67, --暗属性抗性
    ThroughPercentEl6 = 68, --暗属性穿透


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
    VerticalClimbSpeedPercent = 612,    --纵向攀爬速度加成
    HorizontalClimbSpeedPercent = 613,    --横向攀爬速度加成
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
    [AttrType.VerticalClimbSpeed] = AttrType.VerticalClimbSpeedPercent,
    [AttrType.HorizontalClimbSpeed] = AttrType.HorizontalClimbSpeedPercent,
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
    [AttrType.MaxLifePercent] = AttrType.MaxLife,
    [AttrType.AttackPercent] = AttrType.Attack,
    [AttrType.DefensePercent] = AttrType.Defense,
    [AttrType.ElementPercent] = AttrType.ElementAtk,
    [AttrType.WalkSpeedPercent] = AttrType.WalkSpeed,
    [AttrType.RunSpeedPercent] = AttrType.RunSpeed,
    [AttrType.SprintSpeedPercent] = AttrType.SprintSpeed,
    [AttrType.DodgeCostPercent] = AttrType.DodgeCost,
    [AttrType.WalkCostPercent] = AttrType.WalkCost,
    [AttrType.RunCostPercent] = AttrType.RunCost,
    [AttrType.SprintCostPercent] = AttrType.SprintCost,
    [AttrType.ClimbCostPercent] = AttrType.ClimbCost,
    [AttrType.ClimbJumpCostPercent] = AttrType.ClimbJumpCost,
    [AttrType.ClimbRunCostPercent] = AttrType.ClimbRunCost,
    [AttrType.GlideCostPercent] = AttrType.GlideCost,
    [AttrType.SwimCostPercent] = AttrType.SwimCost,
    [AttrType.FastSwimCostPercent] = AttrType.FastSwimCost,
    [AttrType.VerticalClimbSpeedPercent] = AttrType.VerticalClimbSpeed,
    [AttrType.HorizontalClimbSpeedPercent] = AttrType.HorizontalClimbSpeed,
    [AttrType.ClimbJumpHeightPercent] = AttrType.ClimbJumpHeight,
    [AttrType.ClimbRunSpeedPercent] = AttrType.ClimbRunSpeed,
    [AttrType.GlideSpeedPercent] = AttrType.GlideSpeed,
    [AttrType.SwimSpeedPercent] = AttrType.SwimSpeed,
    [AttrType.FastSwimSpeedPercent] = AttrType.FastSwimSpeed,
}

function EntityAttrsConfig.GetHeroBaseAttr(heroConfigId, level)
    local attrId = UtilsBase.GetStringKeys(heroConfigId, level)
    local hero_attrs = Config.DataHeroLevAttr.Find[attrId]
    assert(hero_attrs, "GetHeroBaseAttr attrs null " .. attrId)
    return EntityAttrsConfig.GetBaseAttr(hero_attrs.lev_attr)
end

function EntityAttrsConfig.GetHeroStageAttr(heroConfigId, stage)
    local attrId = UtilsBase.GetStringKeys(heroConfigId, stage)
    local hero_attrs = Config.DataHeroStageAttr.Find[attrId]
    assert(hero_attrs, "GetHeroStageAttr attrs null " .. attrId)
    return EntityAttrsConfig.GetStageAttr(hero_attrs.stage_attr)
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
            if not attrs[attrType] then
                attrs[attrType] = 0
            end

            attrs[attrType] = attrs[attrType] + (v * level)

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

function EntityAttrsConfig.GetBaseAttr(attrsConfig)
    local attrs = {}
    for k, v in pairs(attrsConfig) do
        local attrType = AttrsDefine[k][1]
        if attrType == nil then
            print(attrs[attrType], attrType, k, v)
        end
        attrs[attrType] = v
    end

    for k, v in pairs(AttrType) do
        if not attrs[v] then
            attrs[v] = 0
        end
    end

    attrs[AttrType.Life] = attrs[AttrType.MaxLife]

    return attrs
end

function EntityAttrsConfig.GetStageAttr(attrsConfig)
    local attrs = {}
    for k, v in pairs(attrsConfig) do
        local attrType = v[1]
        local value = v[2]
        attrs[attrType] = value
    end

    for k, v in pairs(AttrType) do
        if not attrs[v] then
            attrs[v] = 0
        end
    end

    attrs[AttrType.Life] = attrs[AttrType.MaxLife]

    return attrs
end