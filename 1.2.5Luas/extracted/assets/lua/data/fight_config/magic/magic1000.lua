Config = Config or {}
Config.Magic1000 = Config.Magic1000 or { }
local empty = { }
Config.Magic1000.Magics = 
{
  [ 100000000 ] = {
    MagicId = 100000000,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100000001 ] = {
    MagicId = 100000001,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100000100 ] = {
    MagicId = 100000100,
    Type = 14,
    Param = {
      behaviorName = 1000001,
      DelayFrame = 0
    }
  },
  [ 100000200 ] = {
    MagicId = 100000200,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        12
      },
      DelayFrame = 0
    }
  },
  [ 100000300 ] = {
    MagicId = 100000300,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100000400 ] = {
    MagicId = 100000400,
    Type = 6,
    Param = {
      BuffStates = {
        12,
        2
      },
      DelayFrame = 0
    }
  },
  [ 100000500 ] = {
    MagicId = 100000500,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxShanbiPingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 100000600 ] = {
    MagicId = 100000600,
    Type = 12,
    Param = {
      TimeScale = 0.02,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100000601 ] = {
    MagicId = 100000601,
    Type = 13,
    Param = {
      Speed = 0.02,
      DelayFrame = 0
    }
  },
  [ 100000700 ] = {
    MagicId = 100000700,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4
      },
      DelayFrame = 0
    }
  },
  [ 100002300 ] = {
    MagicId = 100002300,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000013,
      DelayFrame = 0
    }
  },
  [ 100002301 ] = {
    MagicId = 100002301,
    Type = 13,
    Param = {
      Speed = 0.05,
      DelayFrame = 0
    }
  },
  [ 100002302 ] = {
    MagicId = 100002302,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000013,
      DelayFrame = 0
    }
  },
  [ 100002200 ] = {
    MagicId = 100002200,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -5.0,
      StartFrequency = 7.0,
      TargetAmplitude = -0.1,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.15,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100002201 ] = {
    MagicId = 100002201,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.05,
      StartFrequency = 7.0,
      TargetAmplitude = 0.02,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.15,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100002202 ] = {
    MagicId = 100002202,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.03,
      StartFrequency = 7.0,
      TargetAmplitude = 0.01,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.15,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100002700 ] = {
    MagicId = 100002700,
    Type = 7,
    Param = {
      BoneNames = {
        "WeaponCaseLeft"
      },
      DelayFrame = 0
    }
  },
  [ 100002800 ] = {
    MagicId = 100002800,
    Type = 7,
    Param = {
      BoneNames = {
        "WeaponCasRight"
      },
      DelayFrame = 0
    }
  },
  [ 100002900 ] = {
    MagicId = 100002900,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000004,
      DelayFrame = 0
    }
  },
  [ 100002901 ] = {
    MagicId = 100002901,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000004,
      DelayFrame = 0
    }
  },
  [ 100002902 ] = {
    MagicId = 100002902,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100002903 ] = {
    MagicId = 100002903,
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
  [ 100003000 ] = {
    MagicId = 100003000,
    Type = 28,
    Param = {
      GroupId = 0,
      DurationTime = 999999.0,
      UseTimescale = false,
      EaseInTime = 0.0,
      EaseOutTime = 0.3,
      CameraFixeds = {
        PositionZ = {
          CurveId = 100000002,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 100003100 ] = {
    MagicId = 100003100,
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
  [ 100003200 ] = {
    MagicId = 100003200,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 100003300 ] = {
    MagicId = 100003300,
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
  [ 100003400 ] = {
    MagicId = 100003400,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000011,
      DelayFrame = 0
    }
  },
  [ 100003401 ] = {
    MagicId = 100003401,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100003402 ] = {
    MagicId = 100003402,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100003403 ] = {
    MagicId = 100003403,
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
  [ 1000037 ] = {
    MagicId = 1000037,
    Type = 5,
    Param = {
      EntityId = 1000000014,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = true,
      DelayFrame = 0
    }
  },
  [ 100003900 ] = {
    MagicId = 100003900,
    Type = 26,
    Param = {
      BuffKind = 5001,
      Factor = 0.85,
      DelayFrame = 0
    }
  },
  [ 100004000 ] = {
    MagicId = 100004000,
    Type = 26,
    Param = {
      BuffKind = 5002,
      Factor = 0.85,
      DelayFrame = 0
    }
  },
  [ 100002100 ] = {
    MagicId = 100002100,
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
  [ 100000800 ] = {
    MagicId = 100000800,
    Type = 6,
    Param = {
      BuffStates = {
        10
      },
      DelayFrame = 0
    }
  },
  [ 100003500 ] = {
    MagicId = 100003500,
    Type = 6,
    Param = {
      BuffStates = {
        17
      },
      DelayFrame = 0
    }
  },
  [ 100000900 ] = {
    MagicId = 100000900,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxQijuePingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 100001000 ] = {
    MagicId = 100001000,
    Type = 12,
    Param = {
      TimeScale = 0.08,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100001001 ] = {
    MagicId = 100001001,
    Type = 13,
    Param = {
      Speed = 0.08,
      DelayFrame = 0
    }
  },
  [ 100001002 ] = {
    MagicId = 100001002,
    Type = 3,
    Param = {
      TimeScale = 0.08,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004100 ] = {
    MagicId = 100004100,
    Type = 6,
    Param = {
      BuffStates = {
        18,
        10
      },
      DelayFrame = 0
    }
  },
  [ 100004200 ] = {
    MagicId = 100004200,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 100004400 ] = {
    MagicId = 100004400,
    Type = 6,
    Param = {
      BuffStates = {
        18,
        10
      },
      DelayFrame = 0
    }
  },
  [ 100004500 ] = {
    MagicId = 100004500,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004501 ] = {
    MagicId = 100004501,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100004502 ] = {
    MagicId = 100004502,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004700 ] = {
    MagicId = 100004700,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004701 ] = {
    MagicId = 100004701,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004702 ] = {
    MagicId = 100004702,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100004703 ] = {
    MagicId = 100004703,
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
  [ 100004800 ] = {
    MagicId = 100004800,
    Type = 8,
    Param = {
      GroupName = "Root",
      DelayFrame = 0
    }
  },
  [ 100004801 ] = {
    MagicId = 100004801,
    Type = 6,
    Param = {
      BuffStates = {
        6,
        7,
        1,
        2,
        15,
        12,
        5,
        21
      },
      DelayFrame = 0
    }
  },
  [ 1000049 ] = {
    MagicId = 1000049,
    Type = 2,
    Param = {
      DamageKind = 2,
      DamageType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 9000,
      SkillBaseDmg = 0,
      MagicId = 0,
      IsUseOwnerAttr = false,
      DelayFrame = 0
    }
  },
  [ 1000050 ] = {
    MagicId = 1000050,
    Type = 2,
    Param = {
      DamageKind = 2,
      DamageType = 62001,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      IsUseOwnerAttr = false,
      DelayFrame = 0
    }
  },
  [ 100005500 ] = {
    MagicId = 100005500,
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
  [ 100005600 ] = {
    MagicId = 100005600,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        12,
        4,
        5,
        6,
        7,
        15
      },
      DelayFrame = 0
    }
  },
  [ 100005700 ] = {
    MagicId = 100005700,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100005800 ] = {
    MagicId = 100005800,
    Type = 8,
    Param = {
      GroupName = "Root",
      DelayFrame = 0
    }
  },
  [ 1000059 ] = {
    MagicId = 1000059,
    Type = 27,
    Param = {
      Enable = false,
      DelayFrame = 0
    }
  },
  [ 1000060 ] = {
    MagicId = 1000060,
    Type = 27,
    Param = {
      Enable = true,
      DelayFrame = 0
    }
  },
  [ 100006100 ] = {
    MagicId = 100006100,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100006200 ] = {
    MagicId = 100006200,
    Type = 11,
    Param = {
      Effect = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinPingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 100006300 ] = {
    MagicId = 100006300,
    Type = 11,
    Param = {
      Effect = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinSuccessPingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 1000064 ] = {
    MagicId = 1000064,
    Type = 5,
    Param = {
      EntityId = 1000000017,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = -0.5,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 100006500 ] = {
    MagicId = 100006500,
    Type = 6,
    Param = {
      BuffStates = {
        6,
        7,
        5,
        15,
        12
      },
      DelayFrame = 0
    }
  },
  [ 100006600 ] = {
    MagicId = 100006600,
    Type = 6,
    Param = {
      BuffStates = {
        14
      },
      DelayFrame = 0
    }
  },
  [ 100006800 ] = {
    MagicId = 100006800,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100006801 ] = {
    MagicId = 100006801,
    Type = 6,
    Param = {
      BuffStates = {
        15
      },
      DelayFrame = 0
    }
  },
  [ 100006900 ] = {
    MagicId = 100006900,
    Type = 6,
    Param = {
      BuffStates = {
        6,
        2,
        4,
        5,
        12,
        15,
        7,
        20
      },
      DelayFrame = 0
    }
  },
  [ 100007000 ] = {
    MagicId = 100007000,
    Type = 26,
    Param = {
      BuffKind = 5003,
      Factor = 0.85,
      DelayFrame = 0
    }
  },
  [ 100007100 ] = {
    MagicId = 100007100,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxInHide.prefab",
      DelayFrame = 0
    }
  },
  [ 100007200 ] = {
    MagicId = 100007200,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 100007300 ] = {
    MagicId = 100007300,
    Type = 8,
    Param = {
      GroupName = "Bip001 Prop1",
      DelayFrame = 0
    }
  },
  [ 100007400 ] = {
    MagicId = 100007400,
    Type = 8,
    Param = {
      GroupName = "Bip001 Prop2",
      DelayFrame = 0
    }
  },
  [ 100007500 ] = {
    MagicId = 100007500,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Buff/FxHackBlackCamera.prefab",
      DelayFrame = 0
    }
  },
  [ 100008400 ] = {
    MagicId = 100008400,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Buff/FxHackBlackCamera2.prefab",
      DelayFrame = 0
    }
  },
  [ 100009000 ] = {
    MagicId = 100009000,
    Type = 6,
    Param = {
      BuffStates = {
        17
      },
      DelayFrame = 0
    }
  }
}



Config.Magic1000.Buffs = 
{
  [ 1000000 ] = {
    DurationFrame = 6,
    Type = 1,
    DelayFrame = 3,
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
      1000000
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100000000,
      100000001
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
  [ 1000001 ] = {
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
      1000001
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
      100000100
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
  [ 1000002 ] = {
    DurationFrame = 60,
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
      1000002
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
      100000200
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
  [ 1000003 ] = {
    DurationFrame = 6,
    Type = 1,
    DelayFrame = 3,
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
      1000003
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
      100000300
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
  [ 1000004 ] = {
    DurationFrame = 30,
    Type = 1,
    DelayFrame = 3,
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
      1000004
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
      100000400
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
  [ 1000005 ] = {
    DurationFrame = 30,
    Type = 1,
    DelayFrame = 3,
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
      1000005,
      1002
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
      100000500
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
  [ 1000006 ] = {
    DurationFrame = 30,
    Type = 1,
    DelayFrame = 3,
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
      1000006
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100000600,
      100000601
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
  [ 1000007 ] = {
    DurationFrame = 9,
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
      1000007
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
      100000700
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
  [ 1000023 ] = {
    DurationFrame = 9,
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
      1000023
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100002300,
      100002301,
      100002302
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
  [ 1000024 ] = {
    DurationFrame = 600,
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
      1000024
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWeaknessFire.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000025 ] = {
    DurationFrame = 600,
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
      1000025
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWeaknessThunder.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000022 ] = {
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
      1000022
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100002200,
      100002201,
      100002202
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
  [ 1000027 ] = {
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
      1000027,
      1006
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
      100002700
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
  [ 1000028 ] = {
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
      1000028,
      1006
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
      100002800
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
  [ 1000029 ] = {
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
    Kinds = {
      1000029
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100002900,
      100002901,
      100002902,
      100002903
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
  [ 1000030 ] = {
    DurationFrame = 30000270,
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
      1000030
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100003000
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
  [ 1000031 ] = {
    DurationFrame = 30000270,
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
      1000031
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
      100003100
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
  [ 1000032 ] = {
    DurationFrame = 30000270,
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
      1000032
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
      100003200
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
  [ 1000033 ] = {
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
      1000033
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
      100003300
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
  [ 1000034 ] = {
    DurationFrame = 117,
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
      1000034
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100003400,
      100003401,
      100003402,
      100003403
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
  [ 1000036 ] = {
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
    Kinds = {
      1000036
    },
    Groups = {
      1000036
    },
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWarningJump.prefab",
        EffectBindBones = "Role",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
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
  [ 1000038 ] = {
    DurationFrame = 300,
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
      50001
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxFrozen.prefab",
        EffectBindBones = "Role",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000039 ] = {
    DurationFrame = 150,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 99,
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
      100003900
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
  [ 1000040 ] = {
    DurationFrame = 150,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 99,
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
      100004000
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
  [ 1000021 ] = {
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
    Interval = {
      0.0
    },
    MagicIds = {
      100002100
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
  [ 1000008 ] = {
    DurationFrame = 90,
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
      1000008
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
      100000800
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_2.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      },
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      }
    },
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
  [ 1000035 ] = {
    DurationFrame = 18,
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
      1000035
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
      100003500
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
  [ 1000009 ] = {
    DurationFrame = 120,
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
      1002,
      1000009
    },
    Groups = {
      0,
      0
    },
    Interval = {
      0.0
    },
    MagicIds = {
      100000900
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
  [ 1000010 ] = {
    DurationFrame = 15,
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
      1000010
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100001000,
      100001001,
      100001002
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
  [ 1000041 ] = {
    DurationFrame = 90,
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
      1000041
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100004100
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_2.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      },
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      }
    },
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
  [ 1000042 ] = {
    DurationFrame = 30,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 3,
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
      100004200
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
  [ 1000043 ] = {
    DurationFrame = 48,
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
      1000043
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWuxingkezhi01.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      }
    },
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
  [ 1000044 ] = {
    DurationFrame = 600,
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
      0.0
    },
    MagicIds = {
      100004400
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_2.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      },
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      }
    },
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
  [ 1000045 ] = {
    DurationFrame = 900,
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
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100004500,
      100004501,
      100004502
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
  [ 1000046 ] = {
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
      1000025
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxAssLockTarget.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000047 ] = {
    DurationFrame = 150,
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
      1000029
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.0,
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100004700,
      100004701,
      100004702,
      100004703
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
  [ 1000048 ] = {
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
      1000033
    },
    Groups = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100004800,
      100004801
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
  [ 1000051 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerShow.prefab",
        EffectBindBones = "Bip001 Spine",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000052 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerHide.prefab",
        EffectBindBones = "Bip001 Spine",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000053 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerShowBody.prefab",
        EffectBindBones = "Bip001 Spine",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000054 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerShowBody1.prefab",
        EffectBindBones = "Bip001 Spine",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000055 ] = {
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
      100005500
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
  [ 1000056 ] = {
    DurationFrame = 50,
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
      100005600
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
  [ 1000057 ] = {
    DurationFrame = 50,
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
      100005700
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
  [ 1000058 ] = {
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
      100005800
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
  [ 1000061 ] = {
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
      100006100
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
  [ 1000062 ] = {
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
      100006200
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
  [ 1000063 ] = {
    DurationFrame = 25,
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
      100006300
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
  [ 1000065 ] = {
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
      100006500
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
  [ 1000066 ] = {
    DurationFrame = 90,
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
      0.0
    },
    MagicIds = {
      100006600
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
  [ 1000067 ] = {
    DurationFrame = 45,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxMonstersDeath.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000068 ] = {
    DurationFrame = 20,
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
      0.0,
      0.0
    },
    MagicIds = {
      100006800,
      100006801
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
  [ 1000069 ] = {
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
      100006900
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
  [ 1000070 ] = {
    DurationFrame = 150,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 99,
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
      100007000
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
  [ 1000071 ] = {
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
      100007100
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
  [ 1000072 ] = {
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
      100007200
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
  [ 1000073 ] = {
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
      1000073,
      1006
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
      100007300
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
  [ 1000074 ] = {
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
      1000074,
      1006
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
      100007400
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
  [ 1000075 ] = {
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
      100007500
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
  [ 1000076 ] = {
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxHackBlack.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000077 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000077
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxHackBlack_1.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000078 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000078
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxHackBlack_2.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000079 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000079
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxBuildAllow.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000080 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000080
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxBuildNotAllow.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000081 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000081
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxCanBuild.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000082 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000082
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxBuildBox.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000083 ] = {
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
    CheckKind = true,
    Kinds = {
      1000083,
      1010
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxRemoveBox.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000084 ] = {
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
      100008400
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
  [ 1000085 ] = {
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
    CheckKind = true,
    Kinds = {
      1010,
      1000082
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxBuild.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000086 ] = {
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
    CheckKind = true,
    Kinds = {
      1000083,
      1010
    },
    Groups = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/FxBuildEnd.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
      }
    },
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
  [ 1000090 ] = {
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
    Kinds = {
      1000090
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
      100009000
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
