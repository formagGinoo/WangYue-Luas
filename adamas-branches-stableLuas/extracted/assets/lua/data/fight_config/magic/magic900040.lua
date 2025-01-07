Config = Config or {}
Config.Magic900040 = Config.Magic900040 or { }
local empty = { }
Config.Magic900040.Magics = 
{
  [ 90004003 ] = {
    MagicId = 90004003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 11000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 90004001 ] = {
    MagicId = 90004001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 90004002 ] = {
    MagicId = 90004002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 12000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 90004004 ] = {
    MagicId = 90004004,
    Type = 5,
    Param = {
      EntityId = 900000105,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = true
    }
  },
  [ 9000400500 ] = {
    MagicId = 9000400500,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0
    }
  },
  [ 9000400501 ] = {
    MagicId = 9000400501,
    Type = 13,
    Param = {
      Speed = 0.1
    }
  },
  [ 9000400502 ] = {
    MagicId = 9000400502,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0
    }
  },
  [ 9000400600 ] = {
    MagicId = 9000400600,
    Type = 4,
    Param = {
      ShakeType = 2,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.2,
      StartFrequency = 7.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 7.0,
      AmplitudeChangeTime = 0.14,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.14,
      Sign = 1,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9000400601 ] = {
    MagicId = 9000400601,
    Type = 4,
    Param = {
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -0.04,
      StartFrequency = 7.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 7.0,
      AmplitudeChangeTime = 0.14,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.14,
      Sign = 2,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9000400602 ] = {
    MagicId = 9000400602,
    Type = 4,
    Param = {
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -1.0,
      StartFrequency = 7.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 7.0,
      AmplitudeChangeTime = 0.14,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.14,
      Sign = 3,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  }
}



Config.Magic900040.Buffs = 
{
  [ 90004005 ] = {
    DurationFrame = 2,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      90004005
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
      9000400500,
      9000400501,
      9000400502
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
    tipsDesc = ""
  },
  [ 90004006 ] = {
    DurationFrame = 5,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      90004006
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
      9000400600,
      9000400601,
      9000400602
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
    tipsDesc = ""
  }
}
