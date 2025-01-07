Config = Config or {}
Config.Magic600120 = Config.Magic600120 or { }
local empty = { }
Config.Magic600120.Magics = 
{
  [ 600120001 ] = {
    MagicId = 600120001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
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
  [ 60012000200 ] = {
    MagicId = 60012000200,
    OrginMagicId = 600120002,
    Type = 10,
    Param = {
      AttrType = 29,
      AttrValue = 0,
      attrGroupType = 0,
      TempAttr = false,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  },
  [ 600120003 ] = {
    MagicId = 600120003,
    OrginMagicId = 0,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 2,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 1.0,
          StartFrequency = 12.0,
          TargetAmplitude = 0.4,
          TargetFrequency = 3.0,
          AmplitudeChangeTime = 0.3,
          FrequencyChangeTime = 0.3,
          DurationTime = 0.4,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.4,
          StartFrequency = 12.0,
          TargetAmplitude = 0.2,
          TargetFrequency = 3.0,
          AmplitudeChangeTime = 0.3,
          FrequencyChangeTime = 0.3,
          DurationTime = 0.4,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 4,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.2,
          StartAmplitude = 3.0,
          StartFrequency = 4.0,
          TargetAmplitude = 1.0,
          TargetFrequency = 1.0,
          AmplitudeChangeTime = 0.12,
          FrequencyChangeTime = 0.12,
          DurationTime = 0.12,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.0,
      StartFrequency = 0.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 0.0,
      AmplitudeChangeTime = 0.0,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.0,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 600120010 ] = {
    MagicId = 600120010,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
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
  [ 600120011 ] = {
    MagicId = 600120011,
    OrginMagicId = 0,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 2,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.6,
          StartFrequency = 12.0,
          TargetAmplitude = 0.2,
          TargetFrequency = 6.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.3,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = -0.6,
          StartFrequency = 12.0,
          TargetAmplitude = -0.2,
          TargetFrequency = 6.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.3,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.0,
      StartFrequency = 0.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 0.0,
      AmplitudeChangeTime = 0.0,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.0,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 600120020 ] = {
    MagicId = 600120020,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
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
  [ 60012002100 ] = {
    MagicId = 60012002100,
    OrginMagicId = 600120021,
    Type = 3,
    Param = {
      TimeScale = 2.333,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 600120030 ] = {
    MagicId = 600120030,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
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
  }
}



Config.Magic600120.Buffs = 
{
  [ 600120002 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 1,
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
    Kinds = {
      600120002
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      60012000200
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
  },
  [ 600120021 ] = {
    DurationFrame = 14,
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
      0.0
    },
    MagicIds = {
      60012002100
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
