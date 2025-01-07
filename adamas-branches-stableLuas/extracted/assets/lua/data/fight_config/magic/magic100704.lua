Config = Config or {}
Config.Magic100704 = Config.Magic100704 or { }
local empty = { }
Config.Magic100704.Magics = 
{
  [ 1007040100 ] = {
    MagicId = 1007040100,
    Type = 8,
    Param = {
      GroupName = "XianheM01",
      DelayFrame = 0
    }
  },
  [ 10070402 ] = {
    MagicId = 10070402,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 4,
      ElementType = 1,
      ElementAccumulate = 536,
      SkillParam = 28000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 2,
      DelayFrame = 0
    }
  }
}



Config.Magic100704.Buffs = 
{
  [ 10070401 ] = {
    DurationFrame = 99,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {},
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      1007040100
    },
    EffectKind = 0,
    EffectInfos = {},
    elementType = 6,
    buffIconPath = "",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  }
}
