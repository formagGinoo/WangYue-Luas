Config = Config or {}
Config.Magic62004 = Config.Magic62004 or { }
local empty = { }
Config.Magic62004.Magics = 
{
  [ 62004004 ] = {
    MagicId = 62004004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 30000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 6200400500 ] = {
    MagicId = 6200400500,
    Type = 3,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200400501 ] = {
    MagicId = 6200400501,
    Type = 37,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200400100 ] = {
    MagicId = 6200400100,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        27,
        4,
        15,
        19,
        23,
        25,
        12
      },
      DelayFrame = 0
    }
  },
  [ 6200400200 ] = {
    MagicId = 6200400200,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -2.0,
      StartFrequency = 5.0,
      TargetAmplitude = -0.5,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.3,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200400201 ] = {
    MagicId = 6200400201,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -0.8,
      StartFrequency = 5.0,
      TargetAmplitude = -0.1,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.3,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200400202 ] = {
    MagicId = 6200400202,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.8,
      StartFrequency = 5.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.3,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200400300 ] = {
    MagicId = 6200400300,
    Type = 23,
    Param = {
      GroupId = 0,
      DurationTime = 1.5,
      UseTimescale = false,
      EaseInTime = 0.0,
      EaseOutTime = 0.3,
      CameraOffsets = {
        PositionZ = {
          CurveId = 100000012,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 6200400600 ] = {
    MagicId = 6200400600,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200400601 ] = {
    MagicId = 6200400601,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 62004007 ] = {
    MagicId = 62004007,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.45,
      StartFrequency = 20.0,
      TargetAmplitude = 0.2,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.35,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200400800 ] = {
    MagicId = 6200400800,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 6200400900 ] = {
    MagicId = 6200400900,
    Type = 12,
    Param = {
      TimeScale = 0.05,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200400901 ] = {
    MagicId = 6200400901,
    Type = 13,
    Param = {
      Speed = 0.05,
      DelayFrame = 0
    }
  },
  [ 6200400902 ] = {
    MagicId = 6200400902,
    Type = 3,
    Param = {
      TimeScale = 0.05,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200401000 ] = {
    MagicId = 6200401000,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -2.0,
      StartFrequency = 3.0,
      TargetAmplitude = -0.1,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401001 ] = {
    MagicId = 6200401001,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.05,
      StartFrequency = 3.0,
      TargetAmplitude = 0.02,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401002 ] = {
    MagicId = 6200401002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.03,
      StartFrequency = 3.0,
      TargetAmplitude = 0.01,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401100 ] = {
    MagicId = 6200401100,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.05,
      StartAmplitude = -3.5,
      StartFrequency = 10.0,
      TargetAmplitude = -0.25,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.25,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401101 ] = {
    MagicId = 6200401101,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.05,
      StartAmplitude = -0.1,
      StartFrequency = 10.0,
      TargetAmplitude = -0.05,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.25,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401102 ] = {
    MagicId = 6200401102,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -2.5,
      StartFrequency = 10.0,
      TargetAmplitude = -0.25,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401200 ] = {
    MagicId = 6200401200,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.5,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -2.0,
      StartFrequency = 5.0,
      TargetAmplitude = -0.5,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.3,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401201 ] = {
    MagicId = 6200401201,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.5,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -0.8,
      StartFrequency = 5.0,
      TargetAmplitude = -0.1,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.3,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401202 ] = {
    MagicId = 6200401202,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.5,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.8,
      StartFrequency = 5.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.3,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200401300 ] = {
    MagicId = 6200401300,
    Type = 41,
    Param = {
      Flags = 0,
      DelayFrame = 0
    }
  },
  [ 6200401301 ] = {
    MagicId = 6200401301,
    Type = 42,
    Param = {
      Flags = 509,
      DelayFrame = 0
    }
  },
  [ 6200401302 ] = {
    MagicId = 6200401302,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4,
        5,
        12,
        15
      },
      DelayFrame = 0
    }
  },
  [ 6200401400 ] = {
    MagicId = 6200401400,
    Type = 15,
    Param = {
      TimelinePath = "Character/Monster/Xuanyuanwufu/XuanyuanwufuMb1/Timeline/Attack604_Timeline.prefab",
      TimeIn = 0.5,
      TimeOut = 0.5,
      UseTimeScale = false,
      IngoreRotate = false,
      UnlockMainMove = false,
      UnlockTargetMove = false,
      IngoreSyncTargetPos = false,
      BindMainTargetMove = false,
      BindMoveFrame = 0,
      DelayFrame = 0
    }
  },
  [ 62004015 ] = {
    MagicId = 62004015,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 62004016 ] = {
    MagicId = 62004016,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 62004017 ] = {
    MagicId = 62004017,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 62004018 ] = {
    MagicId = 62004018,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 20000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 62004019 ] = {
    MagicId = 62004019,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 25000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 6200402000 ] = {
    MagicId = 6200402000,
    Type = 30,
    Param = {
      ResetSpeed = false,
      UseGravity = false,
      BaseSpeed = -300.0,
      AccelerationY = -500.0,
      Duration = 3.0,
      MaxFallSpeed = -9000.0,
      DelayFrame = 0
    }
  },
  [ 6200460300 ] = {
    MagicId = 6200460300,
    Type = 14,
    Param = {
      behaviorName = 600000044,
      DelayFrame = 0
    }
  }
}



Config.Magic62004.Buffs = 
{
  [ 62004005 ] = {
    DurationFrame = 5,
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      6200400500,
      6200400501
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
  },
  [ 62004001 ] = {
    DurationFrame = 6,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      62004001
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
      6200400100
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
  },
  [ 62004002 ] = {
    DurationFrame = 15,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      62004002
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
      0.0,
      0.0
    },
    MagicIds = {
      6200400200,
      6200400201,
      6200400202
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
  },
  [ 62004003 ] = {
    DurationFrame = 45,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1000021
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
      6200400300
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
  },
  [ 62004006 ] = {
    DurationFrame = 3,
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      6200400600,
      6200400601
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
  },
  [ 62004008 ] = {
    DurationFrame = 15,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      62004008
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
      6200400800
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
  },
  [ 62004009 ] = {
    DurationFrame = 12,
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
    Kinds = {
      62004009
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
      0.0,
      0.0
    },
    MagicIds = {
      6200400900,
      6200400901,
      6200400902
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
  },
  [ 62004010 ] = {
    DurationFrame = 15,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      62004010
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
      0.0,
      0.0
    },
    MagicIds = {
      6200401000,
      6200401001,
      6200401002
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
  },
  [ 62004011 ] = {
    DurationFrame = 15,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      62004011
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
      0.0,
      0.0
    },
    MagicIds = {
      6200401100,
      6200401101,
      6200401102
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
  },
  [ 62004012 ] = {
    DurationFrame = 15,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      62004012
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
      0.0,
      0.0
    },
    MagicIds = {
      6200401200,
      6200401201,
      6200401202
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
  },
  [ 62004013 ] = {
    DurationFrame = -1,
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
    Kinds = {
      62004013
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      6200401300,
      6200401301,
      6200401302
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
  },
  [ 62004014 ] = {
    DurationFrame = 105,
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      6200401400
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
  },
  [ 62004020 ] = {
    DurationFrame = 3,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
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
      0.0
    },
    MagicIds = {
      6200402000
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
  },
  [ 62004603 ] = {
    DurationFrame = -1,
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      6200460300
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
