Config = Config or {}
Config.Magic1005 = Config.Magic1005 or { }
local empty = { }
Config.Magic1005.Magics = 
{
  [ 1005001 ] = {
    MagicId = 1005001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 6,
      ElementAccumulate = 2,
      SkillParam = 6000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1005002 ] = {
    MagicId = 1005002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 6,
      ElementAccumulate = 2,
      SkillParam = 5500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1005003 ] = {
    MagicId = 1005003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 6,
      ElementAccumulate = 2,
      SkillParam = 7000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1005004 ] = {
    MagicId = 1005004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 6,
      ElementAccumulate = 2,
      SkillParam = 11000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 1005005 ] = {
    MagicId = 1005005,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 6,
      ElementAccumulate = 2,
      SkillParam = 12000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 100509900 ] = {
    MagicId = 100509900,
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
  [ 1005050 ] = {
    MagicId = 1005050,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 50,
      ElementType = 6,
      ElementAccumulate = 25,
      SkillParam = 210000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = false,
      DelayFrame = 0
    }
  },
  [ 100505500 ] = {
    MagicId = 100505500,
    Type = 16,
    Param = {
      CameraTrackPath = "Character/Role/Male154/YixiangR31/Common/Timeline/CtYixiangR31M11Attack050.prefab",
      TimeIn = 0.0,
      TimeOut = 0.03,
      UseTimeScale = false,
      AutoResetVAxis = true,
      VAxisOffset = 0.0,
      AutoResetHAxis = true,
      HAxisOffset = 0.0,
      DelayFrame = 0
    }
  },
  [ 100505501 ] = {
    MagicId = 100505501,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 1005010 ] = {
    MagicId = 1005010,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 85000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1005011 ] = {
    MagicId = 1005011,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 55000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1005012 ] = {
    MagicId = 1005012,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 12,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 55000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1005013 ] = {
    MagicId = 1005013,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 12,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 107500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1005014 ] = {
    MagicId = 1005014,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 1005015 ] = {
    MagicId = 1005015,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  }
}



Config.Magic1005.Buffs = 
{
  [ 1005099 ] = {
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
      100509900
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
  [ 1005051 ] = {
    DurationFrame = 16,
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
      1005051
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff01.prefab",
        EffectBindBones = "Root",
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
  [ 1005052 ] = {
    DurationFrame = 25,
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
      1005052
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff01wuqi_000.prefab",
        EffectBindBones = "wuqi_000",
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
  [ 1005053 ] = {
    DurationFrame = 9,
    Type = 1,
    DelayFrame = 16,
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
      1005053
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff02.prefab",
        EffectBindBones = "Root",
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
  [ 1005054 ] = {
    DurationFrame = -1,
    Type = 1,
    DelayFrame = 16,
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
      1005054
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff.prefab",
        EffectBindBones = "Root",
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
  [ 1005055 ] = {
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
      1005055,
      1003
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
      100505500,
      100505501
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
