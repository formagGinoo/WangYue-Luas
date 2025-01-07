Config = Config or {}
Config.Magic610025 = Config.Magic610025 or { }
local empty = { }
Config.Magic610025.Magics = 
{
  [ 61002500100 ] = {
    MagicId = 61002500100,
    OrginMagicId = 610025001,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 610025002 ] = {
    MagicId = 610025002,
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
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 610025003 ] = {
    MagicId = 610025003,
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
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 61002500500 ] = {
    MagicId = 61002500500,
    OrginMagicId = 610025005,
    Type = 3,
    Param = {
      TimeScale = 0.05,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 61002500600 ] = {
    MagicId = 61002500600,
    OrginMagicId = 610025006,
    Type = 3,
    Param = {
      TimeScale = 0.02,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 61002501600 ] = {
    MagicId = 61002501600,
    OrginMagicId = 610025016,
    Type = 6,
    Param = {
      BuffStates = {
        14
      },
      DelayFrame = 0
    }
  },
  [ 610025004 ] = {
    MagicId = 610025004,
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
  [ 61002500700 ] = {
    MagicId = 61002500700,
    OrginMagicId = 610025007,
    Type = 3,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 61002500701 ] = {
    MagicId = 61002500701,
    OrginMagicId = 610025007,
    Type = 12,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 61002500800 ] = {
    MagicId = 61002500800,
    OrginMagicId = 610025008,
    Type = 3,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 610025009 ] = {
    MagicId = 610025009,
    OrginMagicId = 0,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.2,
          StartAmplitude = -1.0,
          StartFrequency = 2.0,
          TargetAmplitude = -0.5,
          TargetFrequency = 4.0,
          AmplitudeChangeTime = 0.132,
          FrequencyChangeTime = 0.165,
          DurationTime = 0.198,
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
  [ 610025017 ] = {
    MagicId = 610025017,
    OrginMagicId = 0,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = true,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.2,
          StartAmplitude = 0.8,
          StartFrequency = 8.0,
          TargetAmplitude = 0.2,
          TargetFrequency = 16.0,
          AmplitudeChangeTime = 0.297,
          FrequencyChangeTime = 0.231,
          DurationTime = 0.393,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 4,
          IsNoTimeScale = true,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.2,
          StartAmplitude = 1.0,
          StartFrequency = 3.0,
          TargetAmplitude = 0.6,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.132,
          FrequencyChangeTime = 0.099,
          DurationTime = 0.165,
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
  [ 61002501800 ] = {
    MagicId = 61002501800,
    OrginMagicId = 610025018,
    Type = 10,
    Param = {
      AttrType = 30,
      AttrValue = 1000,
      attrGroupType = 0,
      TempAttr = true,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  }
}



Config.Magic610025.Buffs = 
{
  [ 610025001 ] = {
    DurationFrame = 100,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      61002500100
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
  [ 610025012 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk052.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = false
      }
    },
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
  [ 610025013 ] = {
    DurationFrame = 63,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk055.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = false
      }
    },
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
  [ 610025005 ] = {
    DurationFrame = 8,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      0
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
      61002500500
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
  [ 610025006 ] = {
    DurationFrame = 7,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      0
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
      61002500600
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
  [ 610025010 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxHideSafe.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false,
        LoadToBones = false
      }
    },
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
  [ 610025011 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxHideWarn.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false,
        LoadToBones = false
      }
    },
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
  [ 610025014 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
    Interval = {},
    MagicIds = {},
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
  [ 610025015 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk052feishi.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = false
      }
    },
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
  [ 610025016 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      61002501600
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
  [ 610025007 ] = {
    DurationFrame = 20,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      0
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      61002500700,
      61002500701
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
  [ 610025008 ] = {
    DurationFrame = 19,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      0
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
      61002500800
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
  [ 610025018 ] = {
    DurationFrame = 150,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
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
      61002501800
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
