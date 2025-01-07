Config = Config or {}
Config.Magic2000 = Config.Magic2000 or { }
local empty = { }
Config.Magic2000.Magics = 
{
  [ 200000103 ] = {
    MagicId = 200000103,
    Type = 14,
    Param = {
      behaviorName = 200000103,
      DelayFrame = 0
    }
  },
  [ 20000010100 ] = {
    MagicId = 20000010100,
    Type = 21,
    Param = {
      DelayFrame = 0
    }
  },
  [ 20000000800 ] = {
    MagicId = 20000000800,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 20000000801 ] = {
    MagicId = 20000000801,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 20000000802 ] = {
    MagicId = 20000000802,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 200000010 ] = {
    MagicId = 200000010,
    Type = 10,
    Param = {
      AttrType = 1001,
      AttrValue = 1000,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 200000011 ] = {
    MagicId = 200000011,
    Type = 19,
    Param = {
      DelayFrame = 0
    }
  },
  [ 200000012 ] = {
    MagicId = 200000012,
    Type = 20,
    Param = {
      EntityState = 3,
      DelayFrame = 0
    }
  },
  [ 200000013 ] = {
    MagicId = 200000013,
    Type = 10,
    Param = {
      AttrType = 1001,
      AttrValue = 4000,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 200000014 ] = {
    MagicId = 200000014,
    Type = 10,
    Param = {
      AttrType = 1001,
      AttrValue = 8000,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 20000001500 ] = {
    MagicId = 20000001500,
    Type = 10,
    Param = {
      AttrType = 2,
      AttrValue = 50,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000010200 ] = {
    MagicId = 20000010200,
    Type = 6,
    Param = {
      BuffStates = {
        11
      },
      DelayFrame = 0
    }
  },
  [ 200000104 ] = {
    MagicId = 200000104,
    Type = 14,
    Param = {
      behaviorName = 200000104,
      DelayFrame = 0
    }
  },
  [ 20000010500 ] = {
    MagicId = 20000010500,
    Type = 10,
    Param = {
      AttrType = 8,
      AttrValue = -25000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000010501 ] = {
    MagicId = 20000010501,
    Type = 10,
    Param = {
      AttrType = 9,
      AttrValue = -10000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000010502 ] = {
    MagicId = 20000010502,
    Type = 10,
    Param = {
      AttrType = 10,
      AttrValue = -10000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000010503 ] = {
    MagicId = 20000010503,
    Type = 10,
    Param = {
      AttrType = 11,
      AttrValue = -10000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000010504 ] = {
    MagicId = 20000010504,
    Type = 10,
    Param = {
      AttrType = 12,
      AttrValue = -10000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000010505 ] = {
    MagicId = 20000010505,
    Type = 10,
    Param = {
      AttrType = 18,
      AttrValue = -50000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 200000001 ] = {
    MagicId = 200000001,
    Type = 10,
    Param = {
      AttrType = 1204,
      AttrValue = 999,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 200000107 ] = {
    MagicId = 200000107,
    Type = 5,
    Param = {
      EntityId = 200000105,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 20000000900 ] = {
    MagicId = 20000000900,
    Type = 6,
    Param = {
      BuffStates = {
        9
      },
      DelayFrame = 0
    }
  },
  [ 20000010800 ] = {
    MagicId = 20000010800,
    Type = 3,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 20000010900 ] = {
    MagicId = 20000010900,
    Type = 11,
    Param = {
      Effect = "Effect/Prefab/Fight/FxWhitePingmu.prefab",
      DelayFrame = 0
    }
  },
  [ 200000110 ] = {
    MagicId = 200000110,
    Type = 36,
    Param = {
      IsPrecentRevive = true,
      ReviveValue = 10.0,
      DelayFrame = 0
    }
  },
  [ 200000111 ] = {
    MagicId = 200000111,
    Type = 36,
    Param = {
      IsPrecentRevive = true,
      ReviveValue = 100.0,
      DelayFrame = 0
    }
  },
  [ 200000112 ] = {
    MagicId = 200000112,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.1,
      StartFrequency = 30.0,
      TargetAmplitude = 0.05,
      TargetFrequency = 20.0,
      AmplitudeChangeTime = 0.05,
      FrequencyChangeTime = 0.1,
      DurationTime = 0.1,
      Sign = 41,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 200000113 ] = {
    MagicId = 200000113,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 1,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.3,
      StartFrequency = 25.0,
      TargetAmplitude = 0.05,
      TargetFrequency = 15.0,
      AmplitudeChangeTime = 0.2,
      FrequencyChangeTime = 0.2,
      DurationTime = 0.2,
      Sign = 42,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 20000011400 ] = {
    MagicId = 20000011400,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 20000011401 ] = {
    MagicId = 20000011401,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 200000201 ] = {
    MagicId = 200000201,
    Type = 10,
    Param = {
      AttrType = 1001,
      AttrValue = 2500,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 200000202 ] = {
    MagicId = 200000202,
    Type = 10,
    Param = {
      AttrType = 1001,
      AttrValue = 2500,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 200000203 ] = {
    MagicId = 200000203,
    Type = 10,
    Param = {
      AttrType = 1001,
      AttrValue = 2500,
      attrGroupType = 1,
      TempAttr = false,
      DelayFrame = 0
    }
  },
  [ 200000206 ] = {
    MagicId = 200000206,
    Type = 36,
    Param = {
      IsPrecentRevive = false,
      ReviveValue = 300.0,
      DelayFrame = 0
    }
  },
  [ 200000204 ] = {
    MagicId = 200000204,
    Type = 36,
    Param = {
      IsPrecentRevive = false,
      ReviveValue = 500.0,
      DelayFrame = 0
    }
  },
  [ 200000205 ] = {
    MagicId = 200000205,
    Type = 36,
    Param = {
      IsPrecentRevive = false,
      ReviveValue = 1000.0,
      DelayFrame = 0
    }
  },
  [ 20000020700 ] = {
    MagicId = 20000020700,
    Type = 10,
    Param = {
      AttrType = 2,
      AttrValue = 140,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000020701 ] = {
    MagicId = 20000020701,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 800,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000021200 ] = {
    MagicId = 20000021200,
    Type = 10,
    Param = {
      AttrType = 3,
      AttrValue = 90,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000021100 ] = {
    MagicId = 20000021100,
    Type = 10,
    Param = {
      AttrType = 3,
      AttrValue = 110,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000021000 ] = {
    MagicId = 20000021000,
    Type = 10,
    Param = {
      AttrType = 3,
      AttrValue = 100,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000020900 ] = {
    MagicId = 20000020900,
    Type = 10,
    Param = {
      AttrType = 2,
      AttrValue = 120,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000020901 ] = {
    MagicId = 20000020901,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 1000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000020800 ] = {
    MagicId = 20000020800,
    Type = 10,
    Param = {
      AttrType = 2,
      AttrValue = 160,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000020801 ] = {
    MagicId = 20000020801,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 600,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000021300 ] = {
    MagicId = 20000021300,
    Type = 10,
    Param = {
      AttrType = 611,
      AttrValue = 2500,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000021400 ] = {
    MagicId = 20000021400,
    Type = 10,
    Param = {
      AttrType = 611,
      AttrValue = 3000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 20000021500 ] = {
    MagicId = 20000021500,
    Type = 10,
    Param = {
      AttrType = 611,
      AttrValue = 2000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  }
}



Config.Magic2000.Buffs = 
{
  [ 200000101 ] = {
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
      200000101
    },
    Groups = {
      200000101
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000010100
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
  [ 200000008 ] = {
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
      200000008,
      1005
    },
    Groups = {
      200000008
    },
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      20000000800,
      20000000801,
      20000000802
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
  [ 200000015 ] = {
    DurationFrame = 9001,
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
      200000015
    },
    Groups = {
      200000015
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000001500
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
  [ 200000102 ] = {
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
      200000102
    },
    Groups = {
      200000102
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000010200
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
  [ 200000105 ] = {
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
      200000105
    },
    Groups = {
      200000105
    },
    Interval = {
      -1.0,
      -1.0,
      -1.0,
      -1.0,
      -1.0,
      -1.0
    },
    MagicIds = {
      20000010500,
      20000010501,
      20000010502,
      20000010503,
      20000010504,
      20000010505
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
  [ 200000106 ] = {
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
      200000106
    },
    Groups = {
      200000106
    },
    Interval = {},
    MagicIds = {},
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
  [ 200000009 ] = {
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
      200000009
    },
    Groups = {
      200000009
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000000900
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
  [ 200000108 ] = {
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
      200000108
    },
    Groups = {
      200000108
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000010800
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
  [ 200000109 ] = {
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
      20000010900
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
  [ 200000114 ] = {
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
      200000114
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
      20000011400,
      20000011401
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
  [ 200000207 ] = {
    DurationFrame = 9001,
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
      200000015
    },
    Groups = {
      200000015
    },
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      20000020700,
      20000020701
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
  [ 200000212 ] = {
    DurationFrame = 10501,
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
      200000210
    },
    Groups = {
      200000210
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000021200
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
  [ 200000211 ] = {
    DurationFrame = 7501,
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
      200000210
    },
    Groups = {
      200000210
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000021100
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
  [ 200000210 ] = {
    DurationFrame = 9001,
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
      200000210
    },
    Groups = {
      200000210
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000021000
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
  [ 200000209 ] = {
    DurationFrame = 9001,
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
      200000015
    },
    Groups = {
      200000015
    },
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      20000020900,
      20000020901
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
  [ 200000208 ] = {
    DurationFrame = 9001,
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
      200000015
    },
    Groups = {
      200000015
    },
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      20000020800,
      20000020801
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
  [ 200000213 ] = {
    DurationFrame = 3001,
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
      200000213
    },
    Groups = {
      200000210
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000021300
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
  [ 200000214 ] = {
    DurationFrame = 2401,
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
      200000213
    },
    Groups = {
      200000210
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000021400
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
  [ 200000215 ] = {
    DurationFrame = 3601,
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
      200000213
    },
    Groups = {
      200000210
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20000021500
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
