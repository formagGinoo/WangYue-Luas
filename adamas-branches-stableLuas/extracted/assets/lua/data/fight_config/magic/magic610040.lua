Config = Config or {}
Config.Magic610040 = Config.Magic610040 or { }
local empty = { }
Config.Magic610040.Magics = 
{
  [ 61004001 ] = {
    MagicId = 61004001,
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
  [ 6100400600 ] = {
    MagicId = 6100400600,
    Type = 10,
    Param = {
      AttrType = 29,
      AttrValue = 1500,
      attrGroupType = 1,
      TempAttr = true,
      HaveMaxValue = false,
      MaxValue = 0,
      DelayFrame = 0
    }
  },
  [ 61004005 ] = {
    MagicId = 61004005,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 25000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 6100400400 ] = {
    MagicId = 6100400400,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6100400200 ] = {
    MagicId = 6100400200,
    Type = 6,
    Param = {
      BuffStates = {
        18,
        15
      },
      DelayFrame = 0
    }
  },
  [ 6100400300 ] = {
    MagicId = 6100400300,
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
      TargetAmplitude = -0.3,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.09,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.09,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6100400301 ] = {
    MagicId = 6100400301,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 3,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 2.0,
      StartFrequency = 5.0,
      TargetAmplitude = 0.6,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.132,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.165,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 6100400700 ] = {
    MagicId = 6100400700,
    Type = 3,
    Param = {
      TimeScale = 0.7,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6100400800 ] = {
    MagicId = 6100400800,
    Type = 15,
    Param = {
      TimelinePath = "Character/Monster/MCongshichui/CongshichuiMe1/Timeline/Attack615_Timeline.prefab",
      TimeIn = 0.33,
      TimeOut = 0.15,
      UseTimeScale = false,
      IngoreRotate = false,
      UnlockMainMove = false,
      UnlockTargetMove = false,
      IngoreSyncTargetPos = false,
      BindMainTargetMove = false,
      BindMoveFrame = 0,
      DelayFrame = 0
    }
  }
}



Config.Magic610040.Buffs = 
{
  [ 61004006 ] = {
    DurationFrame = 300,
    Type = 1,
    EffectType = 0,
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
      6100400600
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/MCongshichui/CongshichuiMe1/Effect/Fx_CongshiChuiP_buff.prefab",
        EffectBindBones = "",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
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
  [ 61004004 ] = {
    DurationFrame = 4,
    Type = 1,
    EffectType = 0,
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
      6100400400
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
  [ 61004002 ] = {
    DurationFrame = 10,
    Type = 1,
    EffectType = 0,
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
      6100400200
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
  [ 61004003 ] = {
    DurationFrame = 7,
    Type = 1,
    EffectType = 0,
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
      6100400300,
      6100400301
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
  [ 61004007 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
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
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      6100400700
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
  [ 61004008 ] = {
    DurationFrame = 104,
    Type = 1,
    EffectType = 0,
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
      6100400800
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
