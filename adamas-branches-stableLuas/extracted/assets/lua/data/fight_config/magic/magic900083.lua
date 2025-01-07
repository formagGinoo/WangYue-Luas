Config = Config or {}
Config.Magic900083 = Config.Magic900083 or { }
local empty = { }
Config.Magic900083.Magics = 
{
  [ 900083001 ] = {
    MagicId = 900083001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 12650,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 900083004 ] = {
    MagicId = 900083004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 3,
      ElementAccumulate = 8,
      SkillParam = 16650,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 9000830100 ] = {
    MagicId = 9000830100,
    Type = 6,
    Param = {
      BuffStates = {
        14
      },
      DelayFrame = 0
    }
  },
  [ 9000830200 ] = {
    MagicId = 9000830200,
    Type = 30,
    Param = {
      ResetSpeed = false,
      UseGravity = false,
      BaseSpeed = 0.0,
      AccelerationY = 0.0,
      Duration = 99999.0,
      MaxFallSpeed = 0.0,
      DelayFrame = 0
    }
  },
  [ 9000830300 ] = {
    MagicId = 9000830300,
    Type = 30,
    Param = {
      ResetSpeed = true,
      UseGravity = true,
      BaseSpeed = 0.0,
      AccelerationY = -10.0,
      Duration = 7.0,
      MaxFallSpeed = -10.0,
      DelayFrame = 0
    }
  },
  [ 9000830400 ] = {
    MagicId = 9000830400,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2
      },
      DelayFrame = 0
    }
  },
  [ 90008305 ] = {
    MagicId = 90008305,
    Type = 6,
    Param = {
      BuffStates = {
        16
      },
      DelayFrame = 0
    }
  }
}



Config.Magic900083.Buffs = 
{
  [ 90008301 ] = {
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
    CheckKind = true,
    Kinds = {
      90008301
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      9000830100
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
  [ 90008302 ] = {
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
    CheckKind = true,
    Kinds = {
      90008302
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      9000830200
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
  [ 90008303 ] = {
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
    CheckKind = true,
    Kinds = {
      90008303
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      9000830300
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
  [ 90008304 ] = {
    DurationFrame = 20,
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
      90008304
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      9000830400
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
