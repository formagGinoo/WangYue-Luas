Config = Config or {}
Config.Magic1002 = Config.Magic1002 or { }
local empty = { }
Config.Magic1002.Magics = 
{
  [ 1002101 ] = {
    MagicId = 1002101,
    Type = 5,
    Param = {
      EntityId = 100200102,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 100290000 ] = {
    MagicId = 100290000,
    Type = 8,
    Param = {
      GroupName = "NormalWeapon",
      DelayFrame = 0
    }
  },
  [ 1002001 ] = {
    MagicId = 1002001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100203000 ] = {
    MagicId = 100203000,
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
  [ 1002002 ] = {
    MagicId = 1002002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 2,
      ElementAccumulate = 2,
      SkillParam = 11000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002003 ] = {
    MagicId = 1002003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 2,
      ElementAccumulate = 2,
      SkillParam = 8500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002004 ] = {
    MagicId = 1002004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 2,
      ElementAccumulate = 2,
      SkillParam = 11000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002005 ] = {
    MagicId = 1002005,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 2,
      ElementAccumulate = 3,
      SkillParam = 20000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002010 ] = {
    MagicId = 1002010,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 2,
      ElementAccumulate = 5,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002011 ] = {
    MagicId = 1002011,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 2,
      ElementAccumulate = 5,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002040 ] = {
    MagicId = 1002040,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      ElementType = 2,
      ElementAccumulate = 3,
      SkillParam = 12000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002041 ] = {
    MagicId = 1002041,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 3000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002042 ] = {
    MagicId = 1002042,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 3300,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002050 ] = {
    MagicId = 1002050,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 50,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 22500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002051 ] = {
    MagicId = 1002051,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 50,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 150000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100204300 ] = {
    MagicId = 100204300,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4,
        15
      },
      DelayFrame = 0
    }
  },
  [ 1002172 ] = {
    MagicId = 1002172,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 170,
      ElementType = 2,
      ElementAccumulate = 2,
      SkillParam = 60000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002160 ] = {
    MagicId = 1002160,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 160,
      ElementType = 2,
      ElementAccumulate = 3,
      SkillParam = 12000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002161 ] = {
    MagicId = 1002161,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 160,
      ElementType = 2,
      ElementAccumulate = 5,
      SkillParam = 50000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100205200 ] = {
    MagicId = 100205200,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4,
        12
      },
      DelayFrame = 0
    }
  },
  [ 100204400 ] = {
    MagicId = 100204400,
    Type = 12,
    Param = {
      TimeScale = 0.2,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100204401 ] = {
    MagicId = 100204401,
    Type = 13,
    Param = {
      Speed = 0.2,
      DelayFrame = 0
    }
  },
  [ 100216200 ] = {
    MagicId = 100216200,
    Type = 12,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100216201 ] = {
    MagicId = 100216201,
    Type = 13,
    Param = {
      Speed = 0.3,
      DelayFrame = 0
    }
  },
  [ 100216300 ] = {
    MagicId = 100216300,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.1,
      StartFrequency = 1.5,
      TargetAmplitude = 0.05,
      TargetFrequency = 1.5,
      AmplitudeChangeTime = 0.5,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100204500 ] = {
    MagicId = 100204500,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -0.15,
      StartFrequency = 2.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.12,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.12,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100204501 ] = {
    MagicId = 100204501,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      Random = 1.0,
      StartOffset = 0.0,
      StartAmplitude = 0.05,
      StartFrequency = 2.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 2.0,
      AmplitudeChangeTime = 0.12,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.12,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100216400 ] = {
    MagicId = 100216400,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.2,
      StartFrequency = 1.5,
      TargetAmplitude = 0.1,
      TargetFrequency = 1.5,
      AmplitudeChangeTime = 0.5,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 100204600 ] = {
    MagicId = 100204600,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 4,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.4,
      StartFrequency = 1.5,
      TargetAmplitude = 0.1,
      TargetFrequency = 1.5,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.5,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 1002060 ] = {
    MagicId = 1002060,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 60,
      ElementType = 2,
      ElementAccumulate = 6,
      SkillParam = 42500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002061 ] = {
    MagicId = 1002061,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 60,
      ElementType = 2,
      ElementAccumulate = 3,
      SkillParam = 25500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100206200 ] = {
    MagicId = 100206200,
    Type = 12,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100206201 ] = {
    MagicId = 100206201,
    Type = 13,
    Param = {
      Speed = 0.15,
      DelayFrame = 0
    }
  },
  [ 100206202 ] = {
    MagicId = 100206202,
    Type = 3,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1002990 ] = {
    MagicId = 1002990,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 990,
      ElementType = 2,
      ElementAccumulate = 0,
      SkillParam = 12500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100200600 ] = {
    MagicId = 100200600,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100200601 ] = {
    MagicId = 100200601,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100200602 ] = {
    MagicId = 100200602,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1002012 ] = {
    MagicId = 1002012,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 2,
      ElementAccumulate = 5,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100207000 ] = {
    MagicId = 100207000,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4,
        4
      },
      DelayFrame = 0
    }
  },
  [ 1002071 ] = {
    MagicId = 1002071,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 70,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 22500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002072 ] = {
    MagicId = 1002072,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 70,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 37500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100200700 ] = {
    MagicId = 100200700,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100200701 ] = {
    MagicId = 100200701,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100200702 ] = {
    MagicId = 100200702,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100205300 ] = {
    MagicId = 100205300,
    Type = 16,
    Param = {
      CameraTrackPath = "Character/Role/Female165/KekeR31/Common/Timeline/CtKekeR31Attack051.prefab",
      TimeIn = 0.0,
      TimeOut = 0.4,
      UseTimeScale = false,
      AutoResetVAxis = true,
      VAxisOffset = 9.0,
      AutoResetHAxis = false,
      HAxisOffset = 0.0,
      DelayFrame = 0
    }
  },
  [ 100205301 ] = {
    MagicId = 100205301,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 100208000 ] = {
    MagicId = 100208000,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        15,
        4
      },
      DelayFrame = 0
    }
  },
  [ 1002013 ] = {
    MagicId = 1002013,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 2,
      ElementAccumulate = 5,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002014 ] = {
    MagicId = 1002014,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 2,
      ElementAccumulate = 3,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1002015 ] = {
    MagicId = 1002015,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 2,
      ElementAccumulate = 3,
      SkillParam = 15000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100205400 ] = {
    MagicId = 100205400,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100205401 ] = {
    MagicId = 100205401,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 1002081 ] = {
    MagicId = 1002081,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 80,
      ElementType = 2,
      ElementAccumulate = 30,
      SkillParam = 75000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 100208200 ] = {
    MagicId = 100208200,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100208201 ] = {
    MagicId = 100208201,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100201600 ] = {
    MagicId = 100201600,
    Type = 6,
    Param = {
      BuffStates = {
        10
      },
      DelayFrame = 0
    }
  },
  [ 100206300 ] = {
    MagicId = 100206300,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4,
        15
      },
      DelayFrame = 0
    }
  },
  [ 100216500 ] = {
    MagicId = 100216500,
    Type = 7,
    Param = {
      BoneNames = {
        "AimIK_R"
      },
      DelayFrame = 0
    }
  }
}



Config.Magic1002.Buffs = 
{
  [ 1002900 ] = {
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
      1002900,
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
      100290000
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
  [ 1002901 ] = {
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
      1002901,
      1006
    },
    Groups = {
      1,
      2,
      3
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
  [ 1002030 ] = {
    DurationFrame = 19,
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
      1002030
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
      100203000
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
  [ 1002043 ] = {
    DurationFrame = 40,
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
      1002043
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100204300
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
  [ 1002052 ] = {
    DurationFrame = 106,
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
      1002052
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
      100205200
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
  [ 1002044 ] = {
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
      1002044
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
      100204400,
      100204401
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
  [ 1002162 ] = {
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
      1002162
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
      100216200,
      100216201
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
  [ 1002163 ] = {
    DurationFrame = 34,
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
      1002163
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
      100216300
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
  [ 1002045 ] = {
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
      1002045
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
      100204500,
      100204501
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
  [ 1002164 ] = {
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
    Kinds = {
      1002164
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
      100216400
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
  [ 1002046 ] = {
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
    Kinds = {
      1002046
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
      100204600
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
  [ 1002062 ] = {
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
      100206200,
      100206201,
      100206202
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
  [ 1002006 ] = {
    DurationFrame = 2,
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
      1002006
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
      100200600,
      100200601,
      100200602
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
  [ 1002070 ] = {
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
    Kinds = {
      1002070
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
      100207000
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
  [ 1002007 ] = {
    DurationFrame = 1,
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
      1002007
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
      100200700,
      100200701,
      100200702
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
  [ 1002053 ] = {
    DurationFrame = 73,
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
      1002053
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
      100205300,
      100205301
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
  [ 1002080 ] = {
    DurationFrame = 44,
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
      1002080
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
      100208000
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
  [ 1002054 ] = {
    DurationFrame = 91,
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
      1002054
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
      100205400,
      100205401
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
  [ 1002082 ] = {
    DurationFrame = 29,
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
      1002082
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
      100208200,
      100208201
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
  [ 1002016 ] = {
    DurationFrame = 30,
    Type = 3,
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
      1002016
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
      100201600
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
    isDebuff = true,
    elementType = 2,
    buffIconPath = "Textures/Icon/Single/BuffIcon/5002.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 11
  },
  [ 1002063 ] = {
    DurationFrame = 27,
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
      1002063
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
      100206300
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
  [ 1002165 ] = {
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
      1002165
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
      100216500
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
