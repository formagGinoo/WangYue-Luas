Config = Config or {}
Config.Magic62001 = Config.Magic62001 or { }
local empty = { }
Config.Magic62001.Magics = 
{
  [ 62001011 ] = {
    MagicId = 62001011,
    Type = 5,
    Param = {
      EntityId = 6200199902,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 6200100100 ] = {
    MagicId = 6200100100,
    Type = 6,
    Param = {
      BuffStates = {
        6,
        2,
        4,
        5,
        12,
        15,
        7
      },
      DelayFrame = 0
    }
  },
  [ 6200100200 ] = {
    MagicId = 6200100200,
    Type = 8,
    Param = {
      GroupName = "Bip001",
      DelayFrame = 0
    }
  },
  [ 620010101 ] = {
    MagicId = 620010101,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 6200100300 ] = {
    MagicId = 6200100300,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200100400 ] = {
    MagicId = 6200100400,
    Type = 3,
    Param = {
      TimeScale = 0.01,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 62001010200 ] = {
    MagicId = 62001010200,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 6200101200 ] = {
    MagicId = 6200101200,
    Type = 16,
    Param = {
      CameraTrackPath = "Character/Monster/Beilubeite/BeilubeiteMb1/Partner/Timeline/AssassinStart2_Timeline.prefab",
      TimeIn = 0.09,
      TimeOut = 0.09,
      UseTimeScale = true,
      AutoResetVAxis = true,
      VAxisOffset = 0.0,
      AutoResetHAxis = false,
      HAxisOffset = 0.0,
      DelayFrame = 0
    }
  },
  [ 6200101201 ] = {
    MagicId = 6200101201,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 6200101300 ] = {
    MagicId = 6200101300,
    Type = 16,
    Param = {
      CameraTrackPath = "Character/Monster/Beilubeite/BeilubeiteMb1/Partner/Timeline/AssassinSuccess2_Timeline.prefab",
      TimeIn = 0.0,
      TimeOut = 0.12,
      UseTimeScale = true,
      AutoResetVAxis = true,
      VAxisOffset = 0.0,
      AutoResetHAxis = true,
      HAxisOffset = 0.0,
      DelayFrame = 0
    }
  },
  [ 6200101301 ] = {
    MagicId = 6200101301,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 6200101400 ] = {
    MagicId = 6200101400,
    Type = 16,
    Param = {
      CameraTrackPath = "Character/Monster/Beilubeite/BeilubeiteMb1/Partner/Timeline/AssassinFail_Timeline.prefab",
      TimeIn = 0.0,
      TimeOut = 0.12,
      UseTimeScale = true,
      AutoResetVAxis = true,
      VAxisOffset = 0.0,
      AutoResetHAxis = true,
      HAxisOffset = 0.0,
      DelayFrame = 0
    }
  },
  [ 6200101401 ] = {
    MagicId = 6200101401,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 62001015 ] = {
    MagicId = 62001015,
    Type = 27,
    Param = {
      Enable = false,
      DelayFrame = 0
    }
  },
  [ 62001016 ] = {
    MagicId = 62001016,
    Type = 27,
    Param = {
      Enable = true,
      DelayFrame = 0
    }
  },
  [ 6200101700 ] = {
    MagicId = 6200101700,
    Type = 16,
    Param = {
      CameraTrackPath = "Character/Monster/Beilubeite/BeilubeiteMb1/Partner/Timeline/AssassinSuccess2_Timeline.prefab",
      TimeIn = 0.0,
      TimeOut = 0.5,
      UseTimeScale = true,
      AutoResetVAxis = true,
      VAxisOffset = 0.0,
      AutoResetHAxis = true,
      HAxisOffset = 0.0,
      DelayFrame = 0
    }
  },
  [ 6200101701 ] = {
    MagicId = 6200101701,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 6200101800 ] = {
    MagicId = 6200101800,
    Type = 23,
    Param = {
      GroupId = 0,
      DurationTime = 0.396,
      UseTimescale = false,
      EaseInTime = 0.0,
      EaseOutTime = 0.0,
      CameraOffsets = {
        PositionZ = {
          CurveId = 1000104,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 6200101900 ] = {
    MagicId = 6200101900,
    Type = 23,
    Param = {
      GroupId = 0,
      DurationTime = 0.165,
      UseTimescale = true,
      EaseInTime = 0.0,
      EaseOutTime = 0.0,
      CameraOffsets = {
        PositionX = {
          CurveId = 100000028,
          CameraOffsetReferType = 1
        },
        PositionZ = {
          CurveId = 100000029,
          CameraOffsetReferType = 1
        }
      },
      DelayFrame = 0
    }
  },
  [ 6200102000 ] = {
    MagicId = 6200102000,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 2,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 2.0,
          StartFrequency = 5.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 2.0,
          AmplitudeChangeTime = 0.4,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.198,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 4,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 10.0,
          StartFrequency = 1.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 0.0,
          AmplitudeChangeTime = 0.0,
          FrequencyChangeTime = 0.0,
          DurationTime = 0.099,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 2,
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
  [ 6200102100 ] = {
    MagicId = 6200102100,
    Type = 23,
    Param = {
      GroupId = 0,
      DurationTime = 1.0,
      UseTimescale = false,
      EaseInTime = 0.033,
      EaseOutTime = 0.066,
      CameraOffsets = {
        PositionZ = {
          CurveId = 100000023,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 6200102200 ] = {
    MagicId = 6200102200,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.5,
          StartFrequency = 7.0,
          TargetAmplitude = 0.02,
          TargetFrequency = 3.0,
          AmplitudeChangeTime = 0.25,
          FrequencyChangeTime = 0.15,
          DurationTime = 0.264,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 4,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 1.0,
          StartFrequency = 7.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 3.0,
          AmplitudeChangeTime = 0.25,
          FrequencyChangeTime = 0.15,
          DurationTime = 0.264,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 2,
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
  [ 62001023 ] = {
    MagicId = 62001023,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1017001 ] = {
    MagicId = 1017001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 25000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1017002 ] = {
    MagicId = 1017002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 20000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1017003 ] = {
    MagicId = 1017003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 45000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1017004 ] = {
    MagicId = 1017004,
    Type = 5,
    Param = {
      EntityId = 6200101716,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 1017005 ] = {
    MagicId = 1017005,
    Type = 5,
    Param = {
      EntityId = 6200101717,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 1017006 ] = {
    MagicId = 1017006,
    Type = 5,
    Param = {
      EntityId = 6200101718,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 101700700 ] = {
    MagicId = 101700700,
    Type = 3,
    Param = {
      TimeScale = 0.2,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 101700800 ] = {
    MagicId = 101700800,
    Type = 3,
    Param = {
      TimeScale = 0.2,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 101700900 ] = {
    MagicId = 101700900,
    Type = 3,
    Param = {
      TimeScale = 0.2,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1017010 ] = {
    MagicId = 1017010,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.65,
      StartFrequency = 20.0,
      TargetAmplitude = 0.4,
      TargetFrequency = 15.0,
      AmplitudeChangeTime = 0.45,
      FrequencyChangeTime = 0.45,
      DurationTime = 0.45,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 9200101500 ] = {
    MagicId = 9200101500,
    Type = 3,
    Param = {
      TimeScale = 0.06,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6200102400 ] = {
    MagicId = 6200102400,
    Type = 3,
    Param = {
      TimeScale = 0.09,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1017011 ] = {
    MagicId = 1017011,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.65,
      StartFrequency = 20.0,
      TargetAmplitude = 0.4,
      TargetFrequency = 15.0,
      AmplitudeChangeTime = 0.45,
      FrequencyChangeTime = 0.45,
      DurationTime = 0.45,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1017012 ] = {
    MagicId = 1017012,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.65,
      StartFrequency = 20.0,
      TargetAmplitude = 0.4,
      TargetFrequency = 15.0,
      AmplitudeChangeTime = 0.45,
      FrequencyChangeTime = 0.45,
      DurationTime = 0.45,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1017013 ] = {
    MagicId = 1017013,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.65,
      StartFrequency = 20.0,
      TargetAmplitude = 0.4,
      TargetFrequency = 15.0,
      AmplitudeChangeTime = 0.45,
      FrequencyChangeTime = 0.45,
      DurationTime = 0.45,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6200102600 ] = {
    MagicId = 6200102600,
    Type = 23,
    Param = {
      GroupId = 0,
      DurationTime = 0.693,
      UseTimescale = true,
      EaseInTime = 0.033,
      EaseOutTime = 0.066,
      CameraOffsets = {
        PositionZ = {
          CurveId = 100000026,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 6200102700 ] = {
    MagicId = 6200102700,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  }
}



Config.Magic62001.Buffs = 
{
  [ 62001001 ] = {
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
    Interval = {
      0.0
    },
    MagicIds = {
      6200100100
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
  [ 62001002 ] = {
    DurationFrame = 10,
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
      6200100200
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
  [ 62001003 ] = {
    DurationFrame = 8,
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
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      6200100300
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
  [ 62001004 ] = {
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
    Kinds = {
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      6200100400
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
  [ 620010102 ] = {
    DurationFrame = 100,
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
      62001010200
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
  [ 62001012 ] = {
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
    Kinds = {},
    Groups = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      6200101200,
      6200101201
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
  [ 62001013 ] = {
    DurationFrame = 70,
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
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      6200101300,
      6200101301
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
  [ 62001014 ] = {
    DurationFrame = 35,
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
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      6200101400,
      6200101401
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
  [ 62001017 ] = {
    DurationFrame = 70,
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
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      6200101700,
      6200101701
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
  [ 62001018 ] = {
    DurationFrame = 13,
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
      6200101800
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
  [ 62001019 ] = {
    DurationFrame = 6,
    Type = 1,
    DelayFrame = 1,
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
      6200101900
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
  [ 62001020 ] = {
    DurationFrame = 15,
    Type = 1,
    DelayFrame = 1,
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
      6200102000
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
  [ 62001021 ] = {
    DurationFrame = 30,
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
      6200102100
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
  [ 62001022 ] = {
    DurationFrame = 8,
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
      6200102200
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
  [ 1017007 ] = {
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
    Kinds = {
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      101700700
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
  [ 1017008 ] = {
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
    Kinds = {
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      101700800
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
  [ 1017009 ] = {
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
    Kinds = {
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      101700900
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
  [ 92001015 ] = {
    DurationFrame = 10,
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
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      9200101500
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
  [ 62001024 ] = {
    DurationFrame = 10,
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
      0
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0
    },
    MagicIds = {
      6200102400
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
  [ 62001026 ] = {
    DurationFrame = 30,
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
      6200102600
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
  [ 62001027 ] = {
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
    Interval = {
      0.0
    },
    MagicIds = {
      6200102700
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
