Config = Config or {}
Config.Magic62003 = Config.Magic62003 or { }
local empty = { }
Config.Magic62003.Magics = 
{
  [ 62003321 ] = {
    MagicId = 62003321,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 20000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 62003621 ] = {
    MagicId = 62003621,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 99999,
      SkillParam = 0,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 62003322 ] = {
    MagicId = 62003322,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 40000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 6200300100 ] = {
    MagicId = 6200300100,
    OrginMagicId = 62003001,
    Type = 14,
    Param = {
      behaviorName = 62003001,
      paramList = {
        {
          sValue = "1000",
          bValue = false,
          type = 1,
          name = ""
        }
      },
      DelayFrame = 0
    }
  },
  [ 6200300200 ] = {
    MagicId = 6200300200,
    OrginMagicId = 62003002,
    Type = 48,
    Param = {
      paramList = {
        {
          sValue = "100",
          bValue = false,
          type = 1,
          name = ""
        }
      },
      DelayFrame = 0
    }
  },
  [ 20060001 ] = {
    MagicId = 20060001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 20070001 ] = {
    MagicId = 20070001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 20080001 ] = {
    MagicId = 20080001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 3000000100 ] = {
    MagicId = 3000000100,
    OrginMagicId = 30000001,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = -0.4,
      StartFrequency = 5.0,
      TargetAmplitude = -0.2,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.18,
      FrequencyChangeTime = 0.09,
      DurationTime = 0.18,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 3000000101 ] = {
    MagicId = 3000000101,
    OrginMagicId = 30000001,
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
      TargetAmplitude = 0.3,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.18,
      FrequencyChangeTime = 0.09,
      DurationTime = 0.18,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 3000000300 ] = {
    MagicId = 3000000300,
    OrginMagicId = 30000003,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 2,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.5,
      StartFrequency = 5.0,
      TargetAmplitude = 0.3,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.18,
      FrequencyChangeTime = 0.09,
      DurationTime = 0.18,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 3000000301 ] = {
    MagicId = 3000000301,
    OrginMagicId = 30000003,
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
      StartFrequency = 5.0,
      TargetAmplitude = 0.4,
      TargetFrequency = 3.0,
      AmplitudeChangeTime = 0.18,
      FrequencyChangeTime = 0.09,
      DurationTime = 0.18,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  },
  [ 62003005 ] = {
    MagicId = 62003005,
    OrginMagicId = 0,
    Type = 5,
    Param = {
      EntityId = 62003999,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 62003006 ] = {
    MagicId = 62003006,
    OrginMagicId = 0,
    Type = 5,
    Param = {
      EntityId = 62003998,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 62003007 ] = {
    MagicId = 62003007,
    OrginMagicId = 0,
    Type = 5,
    Param = {
      EntityId = 62003997,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  }
}



Config.Magic62003.Buffs = 
{
  [ 62003008 ] = {
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
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Thunderwuqi.prefab",
        EffectBindBones = "weapon02_01",
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
  [ 62003001 ] = {
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
      6200300100
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
  [ 62003002 ] = {
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
      6200300200
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
  [ 30000001 ] = {
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
    Kinds = {},
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      3000000100,
      3000000101
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
  [ 30000003 ] = {
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
    Kinds = {},
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      3000000300,
      3000000301
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
