Config = Config or {}
Config.Magic92002 = Config.Magic92002 or { }
local empty = { }
Config.Magic92002.Magics = 
{
  [ 1001001 ] = {
    MagicId = 1001001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 2,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1001002 ] = {
    MagicId = 1001002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.6,
      StartFrequency = 20.0,
      TargetAmplitude = 0.45,
      TargetFrequency = 15.0,
      AmplitudeChangeTime = 0.35,
      FrequencyChangeTime = 0.35,
      DurationTime = 0.35,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1001003 ] = {
    MagicId = 1001003,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.2,
      StartFrequency = 5.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 7.0,
      AmplitudeChangeTime = 1.0,
      FrequencyChangeTime = 1.0,
      DurationTime = 1.0,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 100199100 ] = {
    MagicId = 100199100,
    Type = 3,
    Param = {
      TimeScale = 0.05,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100199101 ] = {
    MagicId = 100199101,
    Type = 13,
    Param = {
      Speed = 0.05,
      DelayFrame = 0
    }
  },
  [ 100199102 ] = {
    MagicId = 100199102,
    Type = 37,
    Param = {
      TimeScale = 0.05,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1001004 ] = {
    MagicId = 1001004,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 30.0,
      StartFrequency = 10.0,
      TargetAmplitude = 10.0,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.5,
      FrequencyChangeTime = 0.5,
      DurationTime = 3.0,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1040001 ] = {
    MagicId = 1040001,
    Type = 5,
    Param = {
      EntityId = 9200204004,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = true,
      DelayFrame = 0
    }
  },
  [ 1042001 ] = {
    MagicId = 1042001,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.1,
      StartFrequency = 5.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 8.0,
      AmplitudeChangeTime = 0.1,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1042001,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1042002 ] = {
    MagicId = 1042002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.7,
      StartFrequency = 7.0,
      TargetAmplitude = 1.2,
      TargetFrequency = 14.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1042002,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1033001 ] = {
    MagicId = 1033001,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.1,
      StartFrequency = 5.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 8.0,
      AmplitudeChangeTime = 0.1,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1033001,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1033002 ] = {
    MagicId = 1033002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 3.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.1,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1033002,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1033003 ] = {
    MagicId = 1033003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1033004 ] = {
    MagicId = 1033004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1033005 ] = {
    MagicId = 1033005,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.5,
      StartFrequency = 5.0,
      TargetAmplitude = 2.0,
      TargetFrequency = 8.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1033005,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1033006 ] = {
    MagicId = 1033006,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 3.0,
      StartFrequency = 5.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1033006,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1042003 ] = {
    MagicId = 1042003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1042004 ] = {
    MagicId = 1042004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1042005 ] = {
    MagicId = 1042005,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 6,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.5,
      StartFrequency = 6.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1042005,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1042006 ] = {
    MagicId = 1042006,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 6,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 10.0,
      TargetAmplitude = 0.5,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1042006,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1040002 ] = {
    MagicId = 1040002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.2,
      StartFrequency = 3.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1040002,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1040003 ] = {
    MagicId = 1040003,
    Type = 5,
    Param = {
      EntityId = 92002040001,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = true,
      DelayFrame = 0
    }
  },
  [ 1040004 ] = {
    MagicId = 1040004,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.5,
      StartFrequency = 7.0,
      TargetAmplitude = 0.4,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.4,
      FrequencyChangeTime = 0.4,
      DurationTime = 0.4,
      Sign = 1040004,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1002001 ] = {
    MagicId = 1002001,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.0,
      StartFrequency = 2.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1002001,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1002002 ] = {
    MagicId = 1002002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.2,
      StartFrequency = 1.0,
      TargetAmplitude = 0.05,
      TargetFrequency = 8.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1002002,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1054001 ] = {
    MagicId = 1054001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1001994 ] = {
    MagicId = 1001994,
    Type = 7,
    Param = {
      BoneNames = {
        "BaxilikesiMb1Low_Tail"
      },
      DelayFrame = 0
    }
  },
  [ 1045001 ] = {
    MagicId = 1045001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1045002 ] = {
    MagicId = 1045002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1043001 ] = {
    MagicId = 1043001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1044001 ] = {
    MagicId = 1044001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1053001 ] = {
    MagicId = 1053001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 100199300 ] = {
    MagicId = 100199300,
    Type = 6,
    Param = {
      BuffStates = {
        6
      },
      DelayFrame = 0
    }
  },
  [ 1040005 ] = {
    MagicId = 1040005,
    Type = 5,
    Param = {
      EntityId = 9200204004,
      BindOffsetX = 0.0,
      BindOffsetY = -1.75,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 1040006 ] = {
    MagicId = 1040006,
    Type = 5,
    Param = {
      EntityId = 92002040001,
      BindOffsetX = 0.0,
      BindOffsetY = -1.75,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 101300100 ] = {
    MagicId = 101300100,
    Type = 37,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 101300101 ] = {
    MagicId = 101300101,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 101300102 ] = {
    MagicId = 101300102,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 1013002 ] = {
    MagicId = 1013002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.5,
      StartFrequency = 8.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.4,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1032001 ] = {
    MagicId = 1032001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 100199200 ] = {
    MagicId = 100199200,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100199201 ] = {
    MagicId = 100199201,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100199202 ] = {
    MagicId = 100199202,
    Type = 37,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1034001 ] = {
    MagicId = 1034001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 5,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 100199500 ] = {
    MagicId = 100199500,
    Type = 5,
    Param = {
      EntityId = 9200209901,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 100199501 ] = {
    MagicId = 100199501,
    Type = 5,
    Param = {
      EntityId = 9200209902,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 100199502 ] = {
    MagicId = 100199502,
    Type = 5,
    Param = {
      EntityId = 9200209903,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 1041001 ] = {
    MagicId = 1041001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1071001 ] = {
    MagicId = 1071001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 5,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1001998 ] = {
    MagicId = 1001998,
    Type = 5,
    Param = {
      EntityId = 9200201601,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 1051001 ] = {
    MagicId = 1051001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 100900100 ] = {
    MagicId = 100900100,
    Type = 5,
    Param = {
      EntityId = 9200200902,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 109300100 ] = {
    MagicId = 109300100,
    Type = 6,
    Param = {
      BuffStates = {
        14,
        1,
        6
      },
      DelayFrame = 0
    }
  },
  [ 1093002 ] = {
    MagicId = 1093002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.02,
      StartFrequency = 5.0,
      TargetAmplitude = 0.04,
      TargetFrequency = 7.0,
      AmplitudeChangeTime = 1.3,
      FrequencyChangeTime = 1.3,
      DurationTime = 1.3,
      Sign = 1093002,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1093003 ] = {
    MagicId = 1093003,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.04,
      StartFrequency = 7.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.6,
      FrequencyChangeTime = 0.6,
      DurationTime = 0.6,
      Sign = 1093003,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1093004 ] = {
    MagicId = 1093004,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.1,
      StartFrequency = 10.0,
      TargetAmplitude = 0.12,
      TargetFrequency = 12.0,
      AmplitudeChangeTime = 2.5,
      FrequencyChangeTime = 2.5,
      DurationTime = 2.5,
      Sign = 1093004,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1093005 ] = {
    MagicId = 1093005,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.5,
      StartFrequency = 15.0,
      TargetAmplitude = 1.7,
      TargetFrequency = 13.0,
      AmplitudeChangeTime = 0.7,
      FrequencyChangeTime = 0.7,
      DurationTime = 0.7,
      Sign = 1093005,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1093006 ] = {
    MagicId = 1093006,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.7,
      StartFrequency = 13.0,
      TargetAmplitude = 0.01,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.5,
      FrequencyChangeTime = 0.5,
      DurationTime = 0.5,
      Sign = 1093006,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1093007 ] = {
    MagicId = 1093007,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.5,
      StartFrequency = 5.0,
      TargetAmplitude = 0.01,
      TargetFrequency = 1.0,
      AmplitudeChangeTime = 0.4,
      FrequencyChangeTime = 0.4,
      DurationTime = 0.4,
      Sign = 1093007,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1093008 ] = {
    MagicId = 1093008,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 109300900 ] = {
    MagicId = 109300900,
    Type = 8,
    Param = {
      GroupName = "Model",
      DelayFrame = 0
    }
  },
  [ 109300901 ] = {
    MagicId = 109300901,
    Type = 7,
    Param = {
      BoneNames = {
        "Bip002"
      },
      DelayFrame = 0
    }
  },
  [ 109300902 ] = {
    MagicId = 109300902,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        5
      },
      DelayFrame = 0
    }
  },
  [ 1001005 ] = {
    MagicId = 1001005,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.3,
      StartFrequency = 10.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.5,
      FrequencyChangeTime = 0.5,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100199000 ] = {
    MagicId = 100199000,
    Type = 6,
    Param = {
      BuffStates = {
        27
      },
      DelayFrame = 0
    }
  },
  [ 120100100 ] = {
    MagicId = 120100100,
    Type = 9,
    Param = {
      Radius = 30.0,
      StartSpeed = 60.0,
      EndSpeed = 0.0,
      OffsetX = 0.0,
      OffsetZ = 0.0,
      DelayFrame = 0
    }
  },
  [ 1201002 ] = {
    MagicId = 1201002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.3,
      StartFrequency = 7.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 7.0,
      AmplitudeChangeTime = 2.0,
      FrequencyChangeTime = 1.5,
      DurationTime = 2.0,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1201003 ] = {
    MagicId = 1201003,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.3,
      StartFrequency = 7.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 4.0,
      AmplitudeChangeTime = 1.0,
      FrequencyChangeTime = 1.0,
      DurationTime = 1.0,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 120100400 ] = {
    MagicId = 120100400,
    Type = 28,
    Param = {
      GroupId = 0,
      DurationTime = 95.0,
      UseTimescale = true,
      EaseInTime = 0.0,
      EaseOutTime = 0.0,
      CameraFixeds = {
        PositionX = {
          CurveId = 201002,
          CameraOffsetReferType = 0
        },
        PositionY = {
          CurveId = 201004,
          CameraOffsetReferType = 0
        },
        PositionZ = {
          CurveId = 201003,
          CameraOffsetReferType = 0
        }
      },
      DelayFrame = 0
    }
  },
  [ 104600100 ] = {
    MagicId = 104600100,
    Type = 9,
    Param = {
      Radius = 20.0,
      StartSpeed = 60.0,
      EndSpeed = 0.0,
      OffsetX = 0.0,
      OffsetZ = 0.0,
      DelayFrame = 0
    }
  },
  [ 1020001 ] = {
    MagicId = 1020001,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 2.0,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 1.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.35,
          FrequencyChangeTime = 0.35,
          DurationTime = 0.35,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 6.0,
      StartFrequency = 1.0,
      TargetAmplitude = 0.5,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1020001,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1020002 ] = {
    MagicId = 1020002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 2.0,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 1.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.35,
          FrequencyChangeTime = 0.35,
          DurationTime = 0.35,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 5.0,
      StartFrequency = 1.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1020002,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1020003 ] = {
    MagicId = 1020003,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 2.0,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 1.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.35,
          FrequencyChangeTime = 0.35,
          DurationTime = 0.35,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.5,
      StartFrequency = 3.0,
      TargetAmplitude = 0.01,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.8,
      FrequencyChangeTime = 0.8,
      DurationTime = 0.8,
      Sign = 1020002,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1020004 ] = {
    MagicId = 1020004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 102000500 ] = {
    MagicId = 102000500,
    Type = 3,
    Param = {
      TimeScale = 0.5,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 102000501 ] = {
    MagicId = 102000501,
    Type = 13,
    Param = {
      Speed = 0.5,
      DelayFrame = 0
    }
  },
  [ 1020006 ] = {
    MagicId = 1020006,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 2.0,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 1.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.35,
          FrequencyChangeTime = 0.35,
          DurationTime = 0.35,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.5,
      StartFrequency = 3.0,
      TargetAmplitude = 1.0,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.3,
      DurationTime = 0.3,
      Sign = 1020006,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1020007 ] = {
    MagicId = 1020007,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 2.0,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.2,
          FrequencyChangeTime = 0.2,
          DurationTime = 0.2,
          Sign = 0.0,
          DistanceDampingId = 0.0
        },
        {
          ShakeType = 3,
          IsNoTimeScale = false,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 1.0,
          StartAmplitude = 5.0,
          StartFrequency = 2.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 5.0,
          AmplitudeChangeTime = 0.35,
          FrequencyChangeTime = 0.35,
          DurationTime = 0.35,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 4.0,
      StartFrequency = 1.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 1020006,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 107300100 ] = {
    MagicId = 107300100,
    Type = 3,
    Param = {
      TimeScale = 0.05,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1073002 ] = {
    MagicId = 1073002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 2,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 107300300 ] = {
    MagicId = 107300300,
    Type = 3,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1073004 ] = {
    MagicId = 1073004,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 1.0,
      StartAmplitude = 2.0,
      StartFrequency = 3.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.7,
      FrequencyChangeTime = 0.5,
      DurationTime = 1.2,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 102000800 ] = {
    MagicId = 102000800,
    Type = 5,
    Param = {
      EntityId = 9200201904,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 102000900 ] = {
    MagicId = 102000900,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 5.0,
      StartFrequency = 1.0,
      TargetAmplitude = 1.0,
      TargetFrequency = 5.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = true,
      DelayFrame = 0
    }
  },
  [ 1098002 ] = {
    MagicId = 1098002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1001985 ] = {
    MagicId = 1001985,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.3,
      StartFrequency = 1.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1021001 ] = {
    MagicId = 1021001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 2,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1021002 ] = {
    MagicId = 1021002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 2,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1038001 ] = {
    MagicId = 1038001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1039001 ] = {
    MagicId = 1039001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1055001 ] = {
    MagicId = 1055001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1056001 ] = {
    MagicId = 1056001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  }
}



Config.Magic92002.Buffs = 
{
  [ 1001991 ] = {
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100199100,
      100199101,
      100199102
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
  [ 1001993 ] = {
    DurationFrame = 202,
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
      100199300
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
  [ 1013001 ] = {
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      101300100,
      101300101,
      101300102
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
  [ 1001992 ] = {
    DurationFrame = 4,
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100199200,
      100199201,
      100199202
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
  [ 1001995 ] = {
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
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100199500,
      100199501,
      100199502
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
  [ 1009001 ] = {
    DurationFrame = 166,
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
      100900100
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
  [ 1001999 ] = {
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiBuffBip002Spine2.prefab",
        EffectBindBones = "Bip002 Spine2",
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
  [ 1093001 ] = {
    DurationFrame = 151,
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
      1004
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      109300100
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
  [ 1093009 ] = {
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
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      109300900,
      109300901,
      109300902
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
  [ 1001990 ] = {
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
      100199000
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
  [ 1201001 ] = {
    DurationFrame = 31,
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
      0.03
    },
    MagicIds = {
      120100100
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
  [ 1201004 ] = {
    DurationFrame = 95,
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
      120100400
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
  [ 1098001 ] = {
    DurationFrame = -1,
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
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiAtk099.prefab",
        EffectBindBones = "BaxilikesiMb1Low",
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
  [ 1046001 ] = {
    DurationFrame = 31,
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
      0.03
    },
    MagicIds = {
      104600100
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
  [ 1020005 ] = {
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
      102000500,
      102000501
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
  [ 1073001 ] = {
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      107300100
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
  [ 1073003 ] = {
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      107300300
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
  [ 1020008 ] = {
    DurationFrame = -1,
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
      1020008
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      102000800
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
  [ 1020009 ] = {
    DurationFrame = 30,
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
      1020009
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      102000900
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
  [ 1001981 ] = {
    DurationFrame = 10,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 10,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1001981
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiBeenDamage_Body.prefab",
        EffectBindBones = "BaxilikesiMb1Low_Body",
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
    TriggerRemoveNum = 1,
    DeriveList = {
      {
        buffId = 1001981,
        removeNum = 1
      }
    },
    effectFontType = 0
  },
  [ 1001982 ] = {
    DurationFrame = 10,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 10,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1001982
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiBeenDamage_Head.prefab",
        EffectBindBones = "BaxilikesiMb1Low_Head",
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
    TriggerRemoveNum = 1,
    DeriveList = {
      {
        buffId = 1001982,
        removeNum = 1
      }
    },
    effectFontType = 0
  },
  [ 1001983 ] = {
    DurationFrame = 10,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 10,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1001983
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiBeenDamage_Head.prefab",
        EffectBindBones = "BaxilikesiMb1Low_Core",
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
    TriggerRemoveNum = 1,
    DeriveList = {
      {
        buffId = 1001983,
        removeNum = 1
      }
    },
    effectFontType = 0
  },
  [ 1001984 ] = {
    DurationFrame = 10,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = true,
    MaxLimit = 10,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1001984
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiBeenDamage_Tail.prefab",
        EffectBindBones = "BaxilikesiMb1Low_Tail",
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
    TriggerRemoveNum = 1,
    DeriveList = {
      {
        buffId = 1001984,
        removeNum = 1
      }
    },
    effectFontType = 0
  }
}
