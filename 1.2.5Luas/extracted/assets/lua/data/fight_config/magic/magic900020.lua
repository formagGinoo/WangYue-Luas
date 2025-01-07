Config = Config or {}
Config.Magic900020 = Config.Magic900020 or { }
local empty = { }
Config.Magic900020.Magics = 
{
  [ 90002001 ] = {
    MagicId = 90002001,
    Type = 5,
    Param = {
      EntityId = 91002400102,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 90002002 ] = {
    MagicId = 90002002,
    Type = 5,
    Param = {
      EntityId = 90002000203,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 900020001 ] = {
    MagicId = 900020001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 11500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 900020002 ] = {
    MagicId = 900020002,
    Type = 5,
    Param = {
      EntityId = 90002001202,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false,
      DelayFrame = 0
    }
  },
  [ 91002500100 ] = {
    MagicId = 91002500100,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        12
      },
      DelayFrame = 0
    }
  },
  [ 9000200300 ] = {
    MagicId = 9000200300,
    Type = 12,
    Param = {
      TimeScale = 0.06,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9000200301 ] = {
    MagicId = 9000200301,
    Type = 13,
    Param = {
      Speed = 0.06,
      DelayFrame = 0
    }
  },
  [ 9000200302 ] = {
    MagicId = 9000200302,
    Type = 3,
    Param = {
      TimeScale = 0.06,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9000200400 ] = {
    MagicId = 9000200400,
    Type = 12,
    Param = {
      TimeScale = 0.075,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9000200401 ] = {
    MagicId = 9000200401,
    Type = 13,
    Param = {
      Speed = 0.075,
      DelayFrame = 0
    }
  },
  [ 9000200402 ] = {
    MagicId = 9000200402,
    Type = 3,
    Param = {
      TimeScale = 0.075,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 900020003 ] = {
    MagicId = 900020003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 16500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 900020004 ] = {
    MagicId = 900020004,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 4,
      ElementAccumulate = 0,
      SkillParam = 18500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  }
}



Config.Magic900020.Buffs = 
{
  [ 910025001 ] = {
    DurationFrame = -2147483648,
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
      91002500100
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
  [ 90002003 ] = {
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
      90002003
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
      9000200300,
      9000200301,
      9000200302
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
  [ 90002004 ] = {
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
      90002004
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
      9000200400,
      9000200401,
      9000200402
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
