Config = Config or {}
Config.Magic910025 = Config.Magic910025 or { }
local empty = { }
Config.Magic910025.Magics = 
{
  [ 910025007 ] = {
    MagicId = 910025007,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 19250,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910025002 ] = {
    MagicId = 910025002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 22500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910025003 ] = {
    MagicId = 910025003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 5,
      ElementAccumulate = 0,
      SkillParam = 18800,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 91002500400 ] = {
    MagicId = 91002500400,
    Type = 12,
    Param = {
      TimeScale = 0.07,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 91002500401 ] = {
    MagicId = 91002500401,
    Type = 13,
    Param = {
      Speed = 0.07,
      DelayFrame = 0
    }
  },
  [ 91002500402 ] = {
    MagicId = 91002500402,
    Type = 3,
    Param = {
      TimeScale = 0.07,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 91002500500 ] = {
    MagicId = 91002500500,
    Type = 12,
    Param = {
      TimeScale = 0.08,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 91002500501 ] = {
    MagicId = 91002500501,
    Type = 13,
    Param = {
      Speed = 0.08,
      DelayFrame = 0
    }
  },
  [ 91002500502 ] = {
    MagicId = 91002500502,
    Type = 3,
    Param = {
      TimeScale = 0.08,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 91002500600 ] = {
    MagicId = 91002500600,
    Type = 12,
    Param = {
      TimeScale = 0.09,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 91002500601 ] = {
    MagicId = 91002500601,
    Type = 13,
    Param = {
      Speed = 0.09,
      DelayFrame = 0
    }
  },
  [ 91002500602 ] = {
    MagicId = 91002500602,
    Type = 3,
    Param = {
      TimeScale = 0.09,
      CurveId = 0,
      DelayFrame = 0
    }
  }
}



Config.Magic910025.Buffs = 
{
  [ 910025004 ] = {
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
      910025004
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
      91002500400,
      91002500401,
      91002500402
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
  [ 910025005 ] = {
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
      910025005
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
      91002500500,
      91002500501,
      91002500502
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
  [ 910025006 ] = {
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
      910025006
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
      91002500600,
      91002500601,
      91002500602
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
