Config = Config or {}
Config.Magic910040 = Config.Magic910040 or { }
local empty = { }
Config.Magic910040.Magics = 
{
  [ 91004021 ] = {
    MagicId = 91004021,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 91004011 ] = {
    MagicId = 91004011,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 91004031 ] = {
    MagicId = 91004031,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 8000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 91004041 ] = {
    MagicId = 91004041,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 91004042 ] = {
    MagicId = 91004042,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 8000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 91004051 ] = {
    MagicId = 91004051,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 9100409100 ] = {
    MagicId = 9100409100,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0
    }
  },
  [ 9100409200 ] = {
    MagicId = 9100409200,
    Type = 4,
    Param = {
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 25.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.15,
      Sign = 1,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9100409300 ] = {
    MagicId = 9100409300,
    Type = 4,
    Param = {
      ShakeType = 2,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.0,
      StartFrequency = 25.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.15,
      Sign = 1,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9100409400 ] = {
    MagicId = 9100409400,
    Type = 4,
    Param = {
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 15.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.15,
      Sign = 1,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9100409500 ] = {
    MagicId = 9100409500,
    Type = 4,
    Param = {
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 25.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.15,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9100409600 ] = {
    MagicId = 9100409600,
    Type = 4,
    Param = {
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 25.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.15,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.15,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9100409700 ] = {
    MagicId = 9100409700,
    Type = 4,
    Param = {
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 25.0,
      TargetAmplitude = 0.5,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.15,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false
    }
  },
  [ 9100409000 ] = {
    MagicId = 9100409000,
    Type = 3,
    Param = {
      TimeScale = 0.06,
      CurveId = 0
    }
  }
}



Config.Magic910040.Buffs = 
{
  [ 91004091 ] = {
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
      91004091
    },
    Groups = {
      3,
      1,
      2
    },
    Interval = {
      0.0
    },
    MagicIds = {
      9100409100
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
  [ 91004092 ] = {
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
      91004092
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
      9100409200
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
  [ 91004093 ] = {
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
      91004093
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
      9100409300
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
  [ 91004094 ] = {
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
      91004094
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
      9100409400
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
  [ 91004095 ] = {
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
      91004095
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
      9100409500
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
  [ 91004096 ] = {
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
      91004096
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
      9100409600
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
  [ 91004097 ] = {
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
      91004097
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
      9100409700
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
  [ 91004090 ] = {
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
      91004090
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
      9100409000
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
