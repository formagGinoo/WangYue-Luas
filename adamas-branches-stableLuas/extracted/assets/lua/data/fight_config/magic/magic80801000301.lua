Config = Config or {}
Config.Magic80801000301 = Config.Magic80801000301 or { }
local empty = { }
Config.Magic80801000301.Magics = 
{
  [ 808010003010300 ] = {
    MagicId = 808010003010300,
    OrginMagicId = 8080100030103,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 5
    }
  },
  [ 808010003010301 ] = {
    MagicId = 808010003010301,
    OrginMagicId = 8080100030103,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 5
    }
  },
  [ 808010003010302 ] = {
    MagicId = 808010003010302,
    OrginMagicId = 8080100030103,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 5
    }
  },
  [ 8080100030102 ] = {
    MagicId = 8080100030102,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 8080100030101 ] = {
    MagicId = 8080100030101,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 7000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  }
}



Config.Magic80801000301.Buffs = 
{
  [ 8080100030103 ] = {
    DurationFrame = 5,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
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
      808010003010300,
      808010003010301,
      808010003010302
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
