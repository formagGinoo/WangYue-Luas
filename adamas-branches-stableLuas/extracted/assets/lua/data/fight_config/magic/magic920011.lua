Config = Config or {}
Config.Magic920011 = Config.Magic920011 or { }
local empty = { }
Config.Magic920011.Magics = 
{
  [ 92001001 ] = {
    MagicId = 92001001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 92001002 ] = {
    MagicId = 92001002,
    Type = 5,
    Param = {
      EntityId = 9200100402,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 92001003 ] = {
    MagicId = 92001003,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 1,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.35,
      StartFrequency = 20.0,
      TargetAmplitude = 0.5,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.15,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 9200100400 ] = {
    MagicId = 9200100400,
    Type = 3,
    Param = {
      TimeScale = 0.2,
      CurveId = 0,
      DelayFrame = 0
    }
  }
}



Config.Magic920011.Buffs = 
{
  [ 92001004 ] = {
    DurationFrame = 7,
    Type = 1,
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
    Interval = {
      0.0
    },
    MagicIds = {
      9200100400
    },
    EffectKind = 0,
    EffectInfos = {},
    isDebuff = false,
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
