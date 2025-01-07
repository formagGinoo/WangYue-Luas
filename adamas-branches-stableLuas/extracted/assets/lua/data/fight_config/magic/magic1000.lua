Config = Config or {}
Config.Magic1000 = Config.Magic1000 or { }
local empty = { }
Config.Magic1000.Magics = 
{
  [ 100000000 ] = {
    MagicId = 100000000,
    OrginMagicId = 1000000,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100000001 ] = {
    MagicId = 100000001,
    OrginMagicId = 1000000,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100000100 ] = {
    MagicId = 100000100,
    OrginMagicId = 1000001,
    Type = 14,
    Param = {
      behaviorName = 1000001,
      paramList = {},
      DelayFrame = 0
    }
  },
  [ 100000200 ] = {
    MagicId = 100000200,
    OrginMagicId = 1000002,
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
    OrginMagicId = 1000003,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100000400 ] = {
    MagicId = 100000400,
    OrginMagicId = 1000004,
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
    OrginMagicId = 1000005,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxShanbiPingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 100000600 ] = {
    MagicId = 100000600,
    OrginMagicId = 1000006,
    Type = 12,
    Param = {
      TimeScale = 0.02,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100000601 ] = {
    MagicId = 100000601,
    OrginMagicId = 1000006,
    Type = 13,
    Param = {
      Speed = 0.02,
      DelayFrame = 0
    }
  },
  [ 100000700 ] = {
    MagicId = 100000700,
    OrginMagicId = 1000007,
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
    OrginMagicId = 1000023,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000013,
      DelayFrame = 0
    }
  },
  [ 100002301 ] = {
    MagicId = 100002301,
    OrginMagicId = 1000023,
    Type = 13,
    Param = {
      Speed = 0.05,
      DelayFrame = 0
    }
  },
  [ 100002302 ] = {
    MagicId = 100002302,
    OrginMagicId = 1000023,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000013,
      DelayFrame = 0
    }
  },
  [ 100002400 ] = {
    MagicId = 100002400,
    OrginMagicId = 1000024,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100002401 ] = {
    MagicId = 100002401,
    OrginMagicId = 1000024,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100002200 ] = {
    MagicId = 100002200,
    OrginMagicId = 1000022,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
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
    OrginMagicId = 1000022,
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
    OrginMagicId = 1000022,
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
    OrginMagicId = 1000027,
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
    OrginMagicId = 1000028,
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
    OrginMagicId = 1000029,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000004,
      DelayFrame = 0
    }
  },
  [ 100002901 ] = {
    MagicId = 100002901,
    OrginMagicId = 1000029,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000004,
      DelayFrame = 0
    }
  },
  [ 100002902 ] = {
    MagicId = 100002902,
    OrginMagicId = 1000029,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100002903 ] = {
    MagicId = 100002903,
    OrginMagicId = 1000029,
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
    OrginMagicId = 1000030,
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
    OrginMagicId = 1000031,
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
    OrginMagicId = 1000032,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 100003300 ] = {
    MagicId = 100003300,
    OrginMagicId = 1000033,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4,
        5,
        12,
        15,
        6,
        7
      },
      DelayFrame = 0
    }
  },
  [ 100003400 ] = {
    MagicId = 100003400,
    OrginMagicId = 1000034,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 100000011,
      DelayFrame = 0
    }
  },
  [ 100003401 ] = {
    MagicId = 100003401,
    OrginMagicId = 1000034,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100003402 ] = {
    MagicId = 100003402,
    OrginMagicId = 1000034,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100003403 ] = {
    MagicId = 100003403,
    OrginMagicId = 1000034,
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
    OrginMagicId = 0,
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
  [ 100003800 ] = {
    MagicId = 100003800,
    OrginMagicId = 1000038,
    Type = 6,
    Param = {
      BuffStates = {
        6,
        7
      },
      DelayFrame = 0
    }
  },
  [ 100003900 ] = {
    MagicId = 100003900,
    OrginMagicId = 1000039,
    Type = 26,
    Param = {
      BuffKind = 5001,
      BuffEffectType = 0,
      Factor = 0.85,
      DelayFrame = 0
    }
  },
  [ 100004000 ] = {
    MagicId = 100004000,
    OrginMagicId = 1000040,
    Type = 26,
    Param = {
      BuffKind = 5002,
      BuffEffectType = 0,
      Factor = 0.85,
      DelayFrame = 0
    }
  },
  [ 100002100 ] = {
    MagicId = 100002100,
    OrginMagicId = 1000021,
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
    OrginMagicId = 1000008,
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
    OrginMagicId = 1000035,
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
    OrginMagicId = 1000009,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxQijuePingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 100001000 ] = {
    MagicId = 100001000,
    OrginMagicId = 1000010,
    Type = 12,
    Param = {
      TimeScale = 0.08,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100001001 ] = {
    MagicId = 100001001,
    OrginMagicId = 1000010,
    Type = 13,
    Param = {
      Speed = 0.08,
      DelayFrame = 0
    }
  },
  [ 100001002 ] = {
    MagicId = 100001002,
    OrginMagicId = 1000010,
    Type = 3,
    Param = {
      TimeScale = 0.08,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004100 ] = {
    MagicId = 100004100,
    OrginMagicId = 1000041,
    Type = 6,
    Param = {
      BuffStates = {
        18,
        10
      },
      DelayFrame = 0
    }
  },
  [ 100004101 ] = {
    MagicId = 100004101,
    OrginMagicId = 1000041,
    Type = 51,
    Param = {
      DelayFrame = 0
    }
  },
  [ 100004200 ] = {
    MagicId = 100004200,
    OrginMagicId = 1000042,
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
    OrginMagicId = 1000044,
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
    OrginMagicId = 1000045,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004501 ] = {
    MagicId = 100004501,
    OrginMagicId = 1000045,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100004502 ] = {
    MagicId = 100004502,
    OrginMagicId = 1000045,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004700 ] = {
    MagicId = 100004700,
    OrginMagicId = 1000047,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004701 ] = {
    MagicId = 100004701,
    OrginMagicId = 1000047,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100004702 ] = {
    MagicId = 100004702,
    OrginMagicId = 1000047,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100004703 ] = {
    MagicId = 100004703,
    OrginMagicId = 1000047,
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
    OrginMagicId = 1000048,
    Type = 8,
    Param = {
      GroupName = "Root",
      DelayFrame = 0
    }
  },
  [ 100004801 ] = {
    MagicId = 100004801,
    OrginMagicId = 1000048,
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
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 2,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 9000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1000050 ] = {
    MagicId = 1000050,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 2,
      DamageType = 62001,
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
  [ 100005500 ] = {
    MagicId = 100005500,
    OrginMagicId = 1000055,
    Type = 6,
    Param = {
      BuffStates = {
        5
      },
      DelayFrame = 0
    }
  },
  [ 100005501 ] = {
    MagicId = 100005501,
    OrginMagicId = 1000055,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 100005600 ] = {
    MagicId = 100005600,
    OrginMagicId = 1000056,
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
    OrginMagicId = 1000057,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100005800 ] = {
    MagicId = 100005800,
    OrginMagicId = 1000058,
    Type = 8,
    Param = {
      GroupName = "Root",
      DelayFrame = 0
    }
  },
  [ 1000059 ] = {
    MagicId = 1000059,
    OrginMagicId = 0,
    Type = 27,
    Param = {
      Enable = false,
      DelayFrame = 0
    }
  },
  [ 1000060 ] = {
    MagicId = 1000060,
    OrginMagicId = 0,
    Type = 27,
    Param = {
      Enable = true,
      DelayFrame = 0
    }
  },
  [ 100006100 ] = {
    MagicId = 100006100,
    OrginMagicId = 1000061,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100006200 ] = {
    MagicId = 100006200,
    OrginMagicId = 1000062,
    Type = 11,
    Param = {
      Effect = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinPingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 100006300 ] = {
    MagicId = 100006300,
    OrginMagicId = 1000063,
    Type = 11,
    Param = {
      Effect = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinSuccessPingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 1000064 ] = {
    MagicId = 1000064,
    OrginMagicId = 0,
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
    OrginMagicId = 1000065,
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
    OrginMagicId = 1000066,
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
    OrginMagicId = 1000068,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100006801 ] = {
    MagicId = 100006801,
    OrginMagicId = 1000068,
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
    OrginMagicId = 1000069,
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
    OrginMagicId = 1000070,
    Type = 26,
    Param = {
      BuffKind = 5003,
      BuffEffectType = 0,
      Factor = 0.85,
      DelayFrame = 0
    }
  },
  [ 100007100 ] = {
    MagicId = 100007100,
    OrginMagicId = 1000071,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxInHide.prefab",
      DelayFrame = 0
    }
  },
  [ 100007200 ] = {
    MagicId = 100007200,
    OrginMagicId = 1000072,
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
    OrginMagicId = 1000073,
    Type = 8,
    Param = {
      GroupName = "Bip001 Prop1",
      DelayFrame = 0
    }
  },
  [ 100007400 ] = {
    MagicId = 100007400,
    OrginMagicId = 1000074,
    Type = 8,
    Param = {
      GroupName = "Bip001 Prop2",
      DelayFrame = 0
    }
  },
  [ 100009000 ] = {
    MagicId = 100009000,
    OrginMagicId = 1000090,
    Type = 6,
    Param = {
      BuffStates = {
        17
      },
      DelayFrame = 0
    }
  },
  [ 100009100 ] = {
    MagicId = 100009100,
    OrginMagicId = 1000091,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 1000092 ] = {
    MagicId = 1000092,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1000093 ] = {
    MagicId = 1000093,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 100010000 ] = {
    MagicId = 100010000,
    OrginMagicId = 1000100,
    Type = 3,
    Param = {
      TimeScale = 0.5,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100010001 ] = {
    MagicId = 100010001,
    OrginMagicId = 1000100,
    Type = 39,
    Param = {
      ChangeType = 2,
      AdditionGravity = -8.0,
      AdditionMaxFallSpeed = -8.0,
      RemoveWhenLand = false,
      DelayFrame = 0
    }
  },
  [ 100009400 ] = {
    MagicId = 100009400,
    OrginMagicId = 1000094,
    Type = 14,
    Param = {
      behaviorName = 100605101,
      paramList = {},
      DelayFrame = 0
    }
  },
  [ 100009500 ] = {
    MagicId = 100009500,
    OrginMagicId = 1000095,
    Type = 16,
    Param = {
      Duration = 120,
      CameraTrackPath = "Character/Monster/Congshigong/CongshigongMo1/Partner/Timeline/AimConnect_Timeline.prefab",
      CameraTrackInfo = {},
      TimeIn = 0.033,
      TimeOut = 0.5,
      UseTimeScale = true,
      AutoResetVAxis = true,
      VAxisOffset = 0.0,
      AutoResetHAxis = false,
      HAxisOffset = 0.0,
      CameraCheckRadius = -999999.0,
      IngoreRotate = false,
      BindMainTargetMove = false,
      DelayFrame = 0
    }
  },
  [ 100001100 ] = {
    MagicId = 100001100,
    OrginMagicId = 1000011,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Buff/FxWuxingkezhiCamera01.prefab",
      DelayFrame = 0
    }
  },
  [ 100001200 ] = {
    MagicId = 100001200,
    OrginMagicId = 1000012,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Buff/FxWuxingkezhiCamera02.prefab",
      DelayFrame = 0
    }
  },
  [ 100001300 ] = {
    MagicId = 100001300,
    OrginMagicId = 1000013,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Buff/FxWuxingkezhiCamera03.prefab",
      DelayFrame = 0
    }
  },
  [ 100001400 ] = {
    MagicId = 100001400,
    OrginMagicId = 1000014,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Buff/FxWuxingkezhiCamera04.prefab",
      DelayFrame = 0
    }
  },
  [ 100001500 ] = {
    MagicId = 100001500,
    OrginMagicId = 1000015,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        15
      },
      DelayFrame = 0
    }
  },
  [ 100001600 ] = {
    MagicId = 100001600,
    OrginMagicId = 1000016,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        15
      },
      DelayFrame = 0
    }
  },
  [ 100001700 ] = {
    MagicId = 100001700,
    OrginMagicId = 1000017,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100001701 ] = {
    MagicId = 100001701,
    OrginMagicId = 1000017,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100001702 ] = {
    MagicId = 100001702,
    OrginMagicId = 1000017,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4,
        5,
        12,
        15,
        21,
        23,
        25
      },
      DelayFrame = 0
    }
  },
  [ 100001800 ] = {
    MagicId = 100001800,
    OrginMagicId = 1000018,
    Type = 46,
    Param = {
      shieldType = 110,
      attrType = 1,
      SkillParam = 1000,
      SkillBaseDmg = 1000,
      valueOverlay = 2,
      maxValue = 99999,
      DelayFrame = 0
    }
  },
  [ 100001900 ] = {
    MagicId = 100001900,
    OrginMagicId = 1000019,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4,
        5,
        12,
        15,
        23,
        25,
        3,
        7,
        6
      },
      DelayFrame = 0
    }
  },
  [ 100002000 ] = {
    MagicId = 100002000,
    OrginMagicId = 1000020,
    Type = 6,
    Param = {
      BuffStates = {
        18
      },
      DelayFrame = 0
    }
  },
  [ 100007500 ] = {
    MagicId = 100007500,
    OrginMagicId = 1000075,
    Type = 6,
    Param = {
      BuffStates = {
        1
      },
      DelayFrame = 0
    }
  },
  [ 100007600 ] = {
    MagicId = 100007600,
    OrginMagicId = 1000076,
    Type = 50,
    Param = {
      GroupId = 0,
      DurationTime = 0.0,
      UseTimescale = true,
      EaseInTime = 0.0,
      EaseOutTime = 0.0,
      CameraFixeds = {},
      DelayFrame = 0
    }
  },
  [ 1000077 ] = {
    MagicId = 1000077,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1000078 ] = {
    MagicId = 1000078,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1000079 ] = {
    MagicId = 1000079,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 100008000 ] = {
    MagicId = 100008000,
    OrginMagicId = 1000080,
    Type = 6,
    Param = {
      BuffStates = {
        6,
        2,
        4,
        12,
        15,
        7,
        1
      },
      DelayFrame = 0
    }
  },
  [ 100008200 ] = {
    MagicId = 100008200,
    OrginMagicId = 1000082,
    Type = 50,
    Param = {
      DelayFrame = 0
    }
  },
  [ 1000085 ] = {
    MagicId = 1000085,
    OrginMagicId = 0,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 4,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.5,
          StartFrequency = 1.5,
          TargetAmplitude = 0.05,
          TargetFrequency = 1.5,
          AmplitudeChangeTime = 0.5,
          FrequencyChangeTime = 0.0,
          DurationTime = 0.5,
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
  [ 100008700 ] = {
    MagicId = 100008700,
    OrginMagicId = 1000087,
    Type = 6,
    Param = {
      BuffStates = {
        10
      },
      DelayFrame = 0
    }
  },
  [ 100008800 ] = {
    MagicId = 100008800,
    OrginMagicId = 1000088,
    Type = 14,
    Param = {
      behaviorName = 1000088,
      paramList = {},
      DelayFrame = 0
    }
  },
  [ 100008900 ] = {
    MagicId = 100008900,
    OrginMagicId = 1000089,
    Type = 3,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1000096 ] = {
    MagicId = 1000096,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1000097 ] = {
    MagicId = 1000097,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1000098 ] = {
    MagicId = 1000098,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 1000099 ] = {
    MagicId = 1000099,
    OrginMagicId = 0,
    Type = 1,
    Param = {
      BuffId = 0,
      DelayFrame = 0
    }
  },
  [ 100010100 ] = {
    MagicId = 100010100,
    OrginMagicId = 1000101,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4,
        15,
        1
      },
      DelayFrame = 0
    }
  },
  [ 100010200 ] = {
    MagicId = 100010200,
    OrginMagicId = 1000102,
    Type = 6,
    Param = {
      BuffStates = {
        18,
        10
      },
      DelayFrame = 0
    }
  },
  [ 100010300 ] = {
    MagicId = 100010300,
    OrginMagicId = 1000103,
    Type = 30,
    Param = {
      ResetSpeed = false,
      UseGravity = false,
      BaseSpeed = 50.0,
      AccelerationY = 0.0,
      Duration = 0.0,
      MaxFallSpeed = -3.40282347E+38,
      DelayFrame = 0
    }
  },
  [ 100010700 ] = {
    MagicId = 100010700,
    OrginMagicId = 1000107,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Scene/FxSmokepingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 1000108 ] = {
    MagicId = 1000108,
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
          StartOffset = 0.0,
          StartAmplitude = 1.0,
          StartFrequency = 10.0,
          TargetAmplitude = 0.7,
          TargetFrequency = 3.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = true,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.8,
          StartFrequency = 10.0,
          TargetAmplitude = 0.5,
          TargetFrequency = 3.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
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
      DelayFrame = 25
    }
  },
  [ 100011100 ] = {
    MagicId = 100011100,
    OrginMagicId = 1000111,
    Type = 12,
    Param = {
      TimeScale = 0.03,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100011101 ] = {
    MagicId = 100011101,
    OrginMagicId = 1000111,
    Type = 13,
    Param = {
      Speed = 0.03,
      DelayFrame = 0
    }
  },
  [ 100011102 ] = {
    MagicId = 100011102,
    OrginMagicId = 1000111,
    Type = 3,
    Param = {
      TimeScale = 0.03,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1000113 ] = {
    MagicId = 1000113,
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
          StartAmplitude = 0.15,
          StartFrequency = 8.0,
          TargetAmplitude = 0.05,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.3,
          FrequencyChangeTime = 0.3,
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
          StartAmplitude = 0.15,
          StartFrequency = 8.0,
          TargetAmplitude = 0.05,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.3,
          FrequencyChangeTime = 0.3,
          DurationTime = 0.3,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 4,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.1,
          StartFrequency = 8.0,
          TargetAmplitude = 0.0,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.3,
          FrequencyChangeTime = 0.3,
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
  [ 100011400 ] = {
    MagicId = 100011400,
    OrginMagicId = 1000114,
    Type = 12,
    Param = {
      TimeScale = 0.03,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100011401 ] = {
    MagicId = 100011401,
    OrginMagicId = 1000114,
    Type = 13,
    Param = {
      Speed = 0.03,
      DelayFrame = 0
    }
  },
  [ 100011402 ] = {
    MagicId = 100011402,
    OrginMagicId = 1000114,
    Type = 3,
    Param = {
      TimeScale = 0.03,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100011500 ] = {
    MagicId = 100011500,
    OrginMagicId = 1000115,
    Type = 11,
    Param = {
      Effect = "CommonEntity/Gasholder/Effect/FxGasholder01pingmu.prefab",
      DelayFrame = 0
    }
  }
}



Config.Magic1000.Buffs = 
{
  [ 1000000 ] = {
    DurationFrame = 6,
    Type = 1,
    EffectType = 0,
    DelayFrame = 3,
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
      1000000
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
      100000000,
      100000001
    },
    FirstTimes = {
      0.0,
      0.0
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
  [ 1000001 ] = {
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
    Kinds = {
      1000001
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
      100000100
    },
    FirstTimes = {
      0.0
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
  [ 1000002 ] = {
    DurationFrame = 60,
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
      1000002
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
      100000200
    },
    FirstTimes = {
      0.0
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
  [ 1000003 ] = {
    DurationFrame = 6,
    Type = 1,
    EffectType = 0,
    DelayFrame = 3,
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
      1000003
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
      100000300
    },
    FirstTimes = {
      0.0
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
  [ 1000004 ] = {
    DurationFrame = 30,
    Type = 1,
    EffectType = 0,
    DelayFrame = 3,
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
      1000004
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
      100000400
    },
    FirstTimes = {
      0.0
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
  [ 1000005 ] = {
    DurationFrame = 30,
    Type = 1,
    EffectType = 0,
    DelayFrame = 3,
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
      1000005,
      1002
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
      100000500
    },
    FirstTimes = {
      0.0
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
  [ 1000006 ] = {
    DurationFrame = 30,
    Type = 1,
    EffectType = 0,
    DelayFrame = 3,
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
      1000006
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
      100000600,
      100000601
    },
    FirstTimes = {
      0.0,
      0.0
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
  [ 1000007 ] = {
    DurationFrame = 9,
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
      1000007
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
      100000700
    },
    FirstTimes = {
      0.0
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
  [ 1000023 ] = {
    DurationFrame = 9,
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
      1000023
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
      100002300,
      100002301,
      100002302
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000024 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 3,
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
      1000024
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
      100002400,
      100002401
    },
    FirstTimes = {
      0.0,
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWeaknessFire.prefab",
        EffectBindBones = "HitCase",
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
  [ 1000025 ] = {
    DurationFrame = 600,
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
    CheckKind = false,
    Kinds = {
      1000025
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
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
  [ 1000022 ] = {
    DurationFrame = 15,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      1000022
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
      100002200,
      100002201,
      100002202
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000027 ] = {
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
    Kinds = {
      1000027,
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
      100002700
    },
    FirstTimes = {
      0.0
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
  [ 1000028 ] = {
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
    Kinds = {
      1000028,
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
      100002800
    },
    FirstTimes = {
      0.0
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
  [ 1000029 ] = {
    DurationFrame = 30,
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
      1000029
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
      0.0,
      0.0
    },
    MagicIds = {
      100002900,
      100002901,
      100002902,
      100002903
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0,
      0.0
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
  [ 1000030 ] = {
    DurationFrame = 30000270,
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
      1000030
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100003000
    },
    FirstTimes = {
      0.0
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
  [ 1000031 ] = {
    DurationFrame = 30000270,
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
      1000031
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
      100003100
    },
    FirstTimes = {
      0.0
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
  [ 1000032 ] = {
    DurationFrame = 30000270,
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
      1000032
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
      100003200
    },
    FirstTimes = {
      0.0
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
  [ 1000033 ] = {
    DurationFrame = 12,
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
      1000033
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
      100003300
    },
    FirstTimes = {
      0.0
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
  [ 1000034 ] = {
    DurationFrame = 117,
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
      1000034
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
      0.0,
      0.0
    },
    MagicIds = {
      100003400,
      100003401,
      100003402,
      100003403
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0,
      0.0
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
  [ 1000036 ] = {
    DurationFrame = 30,
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
      1000036
    },
    Groups = {
      1000036
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWarningJump.prefab",
        EffectBindBones = "Root",
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
  [ 1000038 ] = {
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
    Kinds = {
      1000038
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100003800
    },
    FirstTimes = {
      0.0
    },
    EffectKind = 0,
    EffectInfos = {},
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/debuff_dongjie.png",
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
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 99,
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
      100003900
    },
    FirstTimes = {
      0.0
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
  [ 1000040 ] = {
    DurationFrame = 150,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 99,
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
      100004000
    },
    FirstTimes = {
      0.0
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
  [ 1000021 ] = {
    DurationFrame = 45,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      100002100
    },
    FirstTimes = {
      0.0
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
  [ 1000008 ] = {
    DurationFrame = 90,
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
      1000008
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
      100000800
    },
    FirstTimes = {
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_2.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      },
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      }
    },
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/debuff_xuanyun.png",
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
      1000035
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
      100003500
    },
    FirstTimes = {
      0.0
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
  [ 1000009 ] = {
    DurationFrame = 120,
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
      1002,
      1000009
    },
    Groups = {
      0,
      0
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100000900
    },
    FirstTimes = {
      0.0
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
  [ 1000010 ] = {
    DurationFrame = 15,
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
      1000010
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
      100001000,
      100001001,
      100001002
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000041 ] = {
    DurationFrame = 90,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      1000041
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100004100,
      100004101
    },
    FirstTimes = {
      0.0,
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_2.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      },
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      }
    },
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/debuff_xuanyun.png",
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
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 3,
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
      100004200
    },
    FirstTimes = {
      0.0
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
  [ 1000043 ] = {
    DurationFrame = 48,
    Type = 1,
    EffectType = 0,
    DelayFrame = 1,
    BindTimeScale = true,
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
      1000043
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWuxingkezhi01.prefab",
        EffectBindBones = "Bip001",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
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
  [ 1000044 ] = {
    DurationFrame = 600,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      100004400
    },
    FirstTimes = {
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      }
    },
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/debuff_xuanyun.png",
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
      0.0,
      0.0
    },
    MagicIds = {
      100004500,
      100004501,
      100004502
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000046 ] = {
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
    Kinds = {
      1000025
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxAssLockTarget.prefab",
        EffectBindBones = "HitCase",
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
  [ 1000047 ] = {
    DurationFrame = 150,
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
      1000029
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
      0.0,
      0.0
    },
    MagicIds = {
      100004700,
      100004701,
      100004702,
      100004703
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0,
      0.0
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
  [ 1000048 ] = {
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
    Kinds = {
      1000033
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100004800,
      100004801
    },
    FirstTimes = {
      0.0,
      0.0
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
  [ 1000051 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerShowL.prefab",
        EffectBindBones = "Bip001 Spine",
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
  [ 1000052 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerHideL.prefab",
        EffectBindBones = "Bip001 Spine",
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
  [ 1000053 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxPartnerCallL.prefab",
        EffectBindBones = "Bip001 Spine",
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
  [ 1000054 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxCallL.prefab",
        EffectBindBones = "Bip001 Spine",
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
  [ 1000055 ] = {
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
      0.0,
      0.0
    },
    MagicIds = {
      100005500,
      100005501
    },
    FirstTimes = {
      0.0,
      0.0
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
  [ 1000056 ] = {
    DurationFrame = 50,
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
      100005600
    },
    FirstTimes = {
      0.0
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
  [ 1000057 ] = {
    DurationFrame = 50,
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
      100005700
    },
    FirstTimes = {
      0.0
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
  [ 1000058 ] = {
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
      100005800
    },
    FirstTimes = {
      0.0
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
  [ 1000061 ] = {
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
      0.0
    },
    MagicIds = {
      100006100
    },
    FirstTimes = {
      0.0
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
  [ 1000062 ] = {
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
      100006200
    },
    FirstTimes = {
      0.0
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
  [ 1000063 ] = {
    DurationFrame = 25,
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
      100006300
    },
    FirstTimes = {
      0.0
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
  [ 1000065 ] = {
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
      100006500
    },
    FirstTimes = {
      0.0
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
  [ 1000066 ] = {
    DurationFrame = 90,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      100006600
    },
    FirstTimes = {
      0.0
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
  [ 1000067 ] = {
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxMonstersDeath.prefab",
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
  [ 1000068 ] = {
    DurationFrame = 20,
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
      100006800,
      100006801
    },
    FirstTimes = {
      0.0,
      0.0
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
  [ 1000069 ] = {
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
      100006900
    },
    FirstTimes = {
      0.0
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
  [ 1000070 ] = {
    DurationFrame = 150,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 99,
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
      100007000
    },
    FirstTimes = {
      0.0
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
  [ 1000071 ] = {
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
      100007100
    },
    FirstTimes = {
      0.0
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
  [ 1000072 ] = {
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
      0.0
    },
    MagicIds = {
      100007200
    },
    FirstTimes = {
      0.0
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
  [ 1000073 ] = {
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
    Kinds = {
      1000073,
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
      100007300
    },
    FirstTimes = {
      0.0
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
  [ 1000074 ] = {
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
    Kinds = {
      1000074,
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
      100007400
    },
    FirstTimes = {
      0.0
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
  [ 1000090 ] = {
    DurationFrame = 30,
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
      1000090
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
      100009000
    },
    FirstTimes = {
      0.0
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
  [ 1000091 ] = {
    DurationFrame = 30,
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
      100009100
    },
    FirstTimes = {
      0.0
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
  [ 1000100 ] = {
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1000100
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
      100010000,
      100010001
    },
    FirstTimes = {
      0.0,
      0.0
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
  [ 1000094 ] = {
    DurationFrame = 360,
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
    IsResetDurationFrame = true,
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
      100009400
    },
    FirstTimes = {
      0.0
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
  [ 1000095 ] = {
    DurationFrame = 135,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      100009500
    },
    FirstTimes = {
      0.0
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
  [ 1000011 ] = {
    DurationFrame = 27,
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
      1000011
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100001100
    },
    FirstTimes = {
      0.0
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
  [ 1000012 ] = {
    DurationFrame = 23,
    Type = 1,
    EffectType = 0,
    DelayFrame = 5,
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
      1000012
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100001200
    },
    FirstTimes = {
      0.0
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
  [ 1000013 ] = {
    DurationFrame = 17,
    Type = 1,
    EffectType = 0,
    DelayFrame = 10,
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
      1000013
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100001300
    },
    FirstTimes = {
      0.0
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
  [ 1000014 ] = {
    DurationFrame = 75,
    Type = 1,
    EffectType = 0,
    DelayFrame = 24,
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
      1000014
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100001400
    },
    FirstTimes = {
      0.0
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
  [ 1000015 ] = {
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
      100001500
    },
    FirstTimes = {
      0.0
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
  [ 1000016 ] = {
    DurationFrame = 30,
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
      100001600
    },
    FirstTimes = {
      0.0
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
  [ 1000017 ] = {
    DurationFrame = 30,
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1000017
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
      100001700,
      100001701,
      100001702
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000018 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 99,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
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
      100001800
    },
    FirstTimes = {
      0.0
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
  [ 1000019 ] = {
    DurationFrame = 30,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1000019
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100001900
    },
    FirstTimes = {
      0.0
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
  [ 1000020 ] = {
    DurationFrame = 60,
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
      100002000
    },
    FirstTimes = {
      0.0
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
  [ 1000075 ] = {
    DurationFrame = 999999,
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
      100007500
    },
    FirstTimes = {
      0.0
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
  [ 1000076 ] = {
    DurationFrame = 300,
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
      100007600
    },
    FirstTimes = {
      0.0
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
  [ 1000080 ] = {
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
      100008000
    },
    FirstTimes = {
      0.0
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
  [ 1000081 ] = {
    DurationFrame = 18,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxConnectStart.prefab",
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
  [ 1000082 ] = {
    DurationFrame = 3600,
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
    IsResetDurationFrame = true,
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
      100008200
    },
    FirstTimes = {
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxConnectLoop.prefab",
        EffectBindBones = "HitCase",
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
  [ 1000083 ] = {
    DurationFrame = 30,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxContractStart.prefab",
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
  [ 1000084 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxContractSuccess.prefab",
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
  [ 1000086 ] = {
    DurationFrame = 60,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxContractFail.prefab",
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
  [ 1000087 ] = {
    DurationFrame = 90,
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
      100008700
    },
    FirstTimes = {
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_2.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
        LoadToBones = false
      },
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
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
  [ 1000088 ] = {
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
      100008800
    },
    FirstTimes = {
      0.0
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
  [ 1000089 ] = {
    DurationFrame = 20,
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
      100008900
    },
    FirstTimes = {
      0.0
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
  [ 1000101 ] = {
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
    Kinds = {
      1000101
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100010100
    },
    FirstTimes = {
      0.0
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
  [ 1000102 ] = {
    DurationFrame = 120,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      1005054
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100010200
    },
    FirstTimes = {
      0.0
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxDazed_1.prefab",
        EffectBindBones = "MarkCase",
        EffectOffset = { 0.0, 0.5, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false,
        LoadToBones = false
      }
    },
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/debuff_xuanyun.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 1000103 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = true,
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
      1000103
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100010300
    },
    FirstTimes = {
      0.0
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
  [ 1000104 ] = {
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
    Kinds = {
      1000104
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddArmor_1.prefab",
        EffectBindBones = "Root",
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
  [ 1000105 ] = {
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
    Groups = {
      1000105
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "CommonEntity/FireDevice/Effect/Fx_FireDevice.prefab",
        EffectBindBones = "Fx",
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
  [ 1000106 ] = {
    DurationFrame = 128,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Scene/Fx_80002.prefab",
        EffectBindBones = "root",
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
  [ 1000107 ] = {
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
    CheckKind = true,
    Kinds = {
      1000107
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100010700
    },
    FirstTimes = {
      0.0
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
  [ 1000109 ] = {
    DurationFrame = 39,
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
    Groups = {
      1000109
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "CommonEntity/FireDevice/Effect/FxFireDeviceEnd01.prefab",
        EffectBindBones = "Fx",
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
  [ 1000110 ] = {
    DurationFrame = 66,
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
    Groups = {
      1000110
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "CommonEntity/FireDevice/Effect/FxFireDeviceEnd02.prefab",
        EffectBindBones = "Fx",
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
  [ 1000111 ] = {
    DurationFrame = 6,
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
      1000010
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
      100011100,
      100011101,
      100011102
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000112 ] = {
    DurationFrame = 18,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
      1000112
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Fight/FxWuxingkezhi02.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true,
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
  [ 1000114 ] = {
    DurationFrame = 15,
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
      1000010
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
      100011400,
      100011401,
      100011402
    },
    FirstTimes = {
      0.0,
      0.0,
      0.0
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
  [ 1000115 ] = {
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
    CheckKind = true,
    Kinds = {
      1000115
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100011500
    },
    FirstTimes = {
      0.0
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
  [ 1000201 ] = {
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
    CheckKind = true,
    Kinds = {
      1000201
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Build/FxBuildPreviewGreen.prefab",
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
  [ 1000202 ] = {
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
    CheckKind = true,
    Kinds = {
      1000202
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Build/FxBuildPreviewOrange.prefab",
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
  [ 1000116 ] = {
    DurationFrame = 110,
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "CommonEntity/Box/Effect/Fx_BoxFireDeath.prefab",
        EffectBindBones = "Root",
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
  [ 1000117 ] = {
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
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "CommonEntity/Box/Effect/Fx_BoxFire.prefab",
        EffectBindBones = "Root",
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
  }
}
