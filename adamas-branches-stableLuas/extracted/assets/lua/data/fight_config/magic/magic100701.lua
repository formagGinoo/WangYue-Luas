Config = Config or {}
Config.Magic100701 = Config.Magic100701 or { }
local empty = { }
Config.Magic100701.Magics = 
{
  [ 1007010100 ] = {
    MagicId = 1007010100,
    Type = 7,
    Param = {
      BoneNames = {
        "UmbrellaW5M01"
      },
      DelayFrame = 0
    }
  },
  [ 10070102 ] = {
    MagicId = 10070102,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 4,
      ElementType = 5,
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



Config.Magic100701.Buffs = 
{
  [ 10070101 ] = {
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
    Kinds = {
      10070101,
      1006
    },
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
      1007010100
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
