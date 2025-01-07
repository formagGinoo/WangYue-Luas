Config = Config or {}
Config.Magic600060 = Config.Magic600060 or { }
local empty = { }
Config.Magic600060.Magics = 
{
  [ 60006000100 ] = {
    MagicId = 60006000100,
    OrginMagicId = 600060001,
    Type = 6,
    Param = {
      BuffStates = {
        10
      },
      DelayFrame = 0
    }
  },
  [ 600060005 ] = {
    MagicId = 600060005,
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
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 60006000200 ] = {
    MagicId = 60006000200,
    OrginMagicId = 600060002,
    Type = 14,
    Param = {
      behaviorName = 900000066,
      paramList = {},
      DelayFrame = 0
    }
  },
  [ 60006000600 ] = {
    MagicId = 60006000600,
    OrginMagicId = 600060006,
    Type = 28,
    Param = {
      GroupId = 0,
      DurationTime = 1.5,
      UseTimescale = false,
      EaseInTime = 0.099,
      EaseOutTime = 0.12,
      CameraFixeds = {
        PositionX = {
          CurveId = 600060006,
          CameraOffsetReferType = 0
        },
        PositionY = {
          CurveId = 600060007,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 60006000300 ] = {
    MagicId = 60006000300,
    OrginMagicId = 600060003,
    Type = 3,
    Param = {
      TimeScale = 2.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006000400 ] = {
    MagicId = 60006000400,
    OrginMagicId = 600060004,
    Type = 3,
    Param = {
      TimeScale = 0.25,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006000700 ] = {
    MagicId = 60006000700,
    OrginMagicId = 600060007,
    Type = 6,
    Param = {
      BuffStates = {
        14
      },
      DelayFrame = 0
    }
  },
  [ 60006000800 ] = {
    MagicId = 60006000800,
    OrginMagicId = 600060008,
    Type = 3,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006000900 ] = {
    MagicId = 60006000900,
    OrginMagicId = 600060009,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006000901 ] = {
    MagicId = 60006000901,
    OrginMagicId = 600060009,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006001000 ] = {
    MagicId = 60006001000,
    OrginMagicId = 600060010,
    Type = 37,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006001001 ] = {
    MagicId = 60006001001,
    OrginMagicId = 600060010,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006001100 ] = {
    MagicId = 60006001100,
    OrginMagicId = 600060011,
    Type = 3,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006001101 ] = {
    MagicId = 60006001101,
    OrginMagicId = 600060011,
    Type = 12,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 60006001102 ] = {
    MagicId = 60006001102,
    OrginMagicId = 600060011,
    Type = 37,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 600060012 ] = {
    MagicId = 600060012,
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
          StartFrequency = 3.0,
          TargetAmplitude = 0.2,
          TargetFrequency = 6.0,
          AmplitudeChangeTime = 0.165,
          FrequencyChangeTime = 0.132,
          DurationTime = 0.198,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 4,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.5,
          StartFrequency = 3.0,
          TargetAmplitude = 0.3,
          TargetFrequency = 6.0,
          AmplitudeChangeTime = 0.165,
          FrequencyChangeTime = 0.132,
          DurationTime = 0.198,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.1,
      StartAmplitude = 0.5,
      StartFrequency = 2.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.14,
      FrequencyChangeTime = 0.14,
      DurationTime = 0.14,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 600060013 ] = {
    MagicId = 600060013,
    OrginMagicId = 0,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 4,
          IsNoTimeScale = true,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.2,
          StartAmplitude = 0.8,
          StartFrequency = 3.0,
          TargetAmplitude = 0.4,
          TargetFrequency = 6.0,
          AmplitudeChangeTime = 0.165,
          FrequencyChangeTime = 0.132,
          DurationTime = 0.165,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = true,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.1,
          StartAmplitude = 0.5,
          StartFrequency = 4.0,
          TargetAmplitude = 0.2,
          TargetFrequency = 2.0,
          AmplitudeChangeTime = 0.132,
          FrequencyChangeTime = 0.132,
          DurationTime = 0.165,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 4,
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
  [ 60006001400 ] = {
    MagicId = 60006001400,
    OrginMagicId = 600060014,
    Type = 10,
    Param = {
      AttrType = 655,
      AttrValue = -1000.0,
      attrGroupType = 0,
      TempAttr = true,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  },
  [ 600060015 ] = {
    MagicId = 600060015,
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
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 600060016 ] = {
    MagicId = 600060016,
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
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  }
}



Config.Magic600060.Buffs = 
{
  [ 600060001 ] = {
    DurationFrame = 150,
    Type = 1,
    EffectType = 4,
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
    CheckKind = true,
    Kinds = {
      5003
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      60006000100
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Weihu/WeihuMo1/Effect/FxWeihuMo1CharmBody_HitCase.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      }
    },
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/5003.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = true,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 2
  },
  [ 600060002 ] = {
    DurationFrame = 180,
    Type = 1,
    EffectType = 4,
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
    CheckKind = true,
    Kinds = {
      5003
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      60006000200
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Weihu/WeihuMo1/Effect/FxWeihuMo1CharmBody_HitCase.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      }
    },
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/5003.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = true,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 2
  },
  [ 600060006 ] = {
    DurationFrame = 45,
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
      60006000600
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
  [ 600060003 ] = {
    DurationFrame = -1,
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
      60006000300
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
  [ 600060004 ] = {
    DurationFrame = 180,
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
    Kinds = {
      600060004
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      60006000400
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
  [ 600060007 ] = {
    DurationFrame = -1,
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
      60006000700
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
  [ 600060008 ] = {
    DurationFrame = 4,
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
      60006000800
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
  [ 600060009 ] = {
    DurationFrame = 3,
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
      0.0
    },
    MagicIds = {
      60006000900,
      60006000901
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
  [ 600060010 ] = {
    DurationFrame = 4,
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
      0.0
    },
    MagicIds = {
      60006001000,
      60006001001
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
  [ 600060011 ] = {
    DurationFrame = 10,
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
      60006001100,
      60006001101,
      60006001102
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
  [ 600060014 ] = {
    DurationFrame = -1,
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
      60006001400
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
