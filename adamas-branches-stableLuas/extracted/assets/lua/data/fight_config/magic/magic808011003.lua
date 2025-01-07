Config = Config or {}
Config.Magic808011003 = Config.Magic808011003 or { }
local empty = { }
Config.Magic808011003.Magics = 
{
  [ 8000200101 ] = {
    MagicId = 8000200101,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 7000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 8000200201 ] = {
    MagicId = 8000200201,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 800020010200 ] = {
    MagicId = 800020010200,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 5
    }
  },
  [ 800020010201 ] = {
    MagicId = 800020010201,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 5
    }
  },
  [ 800020010202 ] = {
    MagicId = 800020010202,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 5
    }
  }
}



Config.Magic808011003.Buffs = 
{
  [ 8000200102 ] = {
    DurationFrame = 5,
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
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      800020010200,
      800020010201,
      800020010202
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
