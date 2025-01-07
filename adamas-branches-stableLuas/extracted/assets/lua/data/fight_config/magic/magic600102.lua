Config = Config or {}
Config.Magic600102 = Config.Magic600102 or { }
local empty = { }
Config.Magic600102.Magics = 
{
  [ 6001020300 ] = {
    MagicId = 6001020300,
    OrginMagicId = 60010203,
    Type = 10,
    Param = {
      AttrType = 30,
      AttrValue = 1000.0,
      attrGroupType = 0,
      TempAttr = true,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  },
  [ 600102003 ] = {
    MagicId = 600102003,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 6001020031 ] = {
    MagicId = 6001020031,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 3000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 6001020200 ] = {
    MagicId = 6001020200,
    OrginMagicId = 60010202,
    Type = 3,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6001020201 ] = {
    MagicId = 6001020201,
    OrginMagicId = 60010202,
    Type = 12,
    Param = {
      TimeScale = 0.15,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6001020400 ] = {
    MagicId = 6001020400,
    OrginMagicId = 60010204,
    Type = 3,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6001020401 ] = {
    MagicId = 6001020401,
    OrginMagicId = 60010204,
    Type = 12,
    Param = {
      TimeScale = 0.1,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 6001020500 ] = {
    MagicId = 6001020500,
    OrginMagicId = 60010205,
    Type = 10,
    Param = {
      AttrType = 29,
      AttrValue = 1000.0,
      attrGroupType = 0,
      TempAttr = true,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  },
  [ 60010201001 ] = {
    MagicId = 60010201001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 60010201002 ] = {
    MagicId = 60010201002,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 60010201301 ] = {
    MagicId = 60010201301,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 60010201401 ] = {
    MagicId = 60010201401,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 0,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  }
}



Config.Magic600102.Buffs = 
{
  [ 60010201 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 16,
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
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/JiDuLingKe/JiDuLingKeMb3/Effcet/FxJidulingkeAlert_Loop_Weapon_030_RootBone.prefab",
        EffectBindBones = "Weapon_030_RootBone",
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
  [ 60010203 ] = {
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
      10011002
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      6001020300
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
  [ 60010202 ] = {
    DurationFrame = 22,
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
      0.0,
      0.0
    },
    MagicIds = {
      6001020200,
      6001020201
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
  [ 60010204 ] = {
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
      6001020400,
      6001020401
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
  [ 60010205 ] = {
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
      6001020500
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
