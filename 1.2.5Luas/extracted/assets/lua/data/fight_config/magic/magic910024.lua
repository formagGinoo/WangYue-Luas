Config = Config or {}
Config.Magic910024 = Config.Magic910024 or { }
local empty = { }
Config.Magic910024.Magics = 
{
  [ 910024001 ] = {
    MagicId = 910024001,
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
  [ 910024002 ] = {
    MagicId = 910024002,
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
  [ 910024003 ] = {
    MagicId = 910024003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 6500,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910024004 ] = {
    MagicId = 910024004,
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
  [ 910024005 ] = {
    MagicId = 910024005,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 8750,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910024006 ] = {
    MagicId = 910024006,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 12750,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910024007 ] = {
    MagicId = 910024007,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 17600,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910024008 ] = {
    MagicId = 910024008,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 16600,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 910024009 ] = {
    MagicId = 910024009,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 5,
      ElementAccumulate = 0,
      SkillParam = 22150,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 9100240100 ] = {
    MagicId = 9100240100,
    Type = 12,
    Param = {
      TimeScale = 0.07,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9100240101 ] = {
    MagicId = 9100240101,
    Type = 13,
    Param = {
      Speed = 0.07,
      DelayFrame = 0
    }
  },
  [ 9100240102 ] = {
    MagicId = 9100240102,
    Type = 3,
    Param = {
      TimeScale = 0.07,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9100240200 ] = {
    MagicId = 9100240200,
    Type = 12,
    Param = {
      TimeScale = 0.085,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9100240201 ] = {
    MagicId = 9100240201,
    Type = 13,
    Param = {
      Speed = 0.085,
      DelayFrame = 0
    }
  },
  [ 9100240202 ] = {
    MagicId = 9100240202,
    Type = 3,
    Param = {
      TimeScale = 0.085,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9100240300 ] = {
    MagicId = 9100240300,
    Type = 12,
    Param = {
      TimeScale = 0.11,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 9100240301 ] = {
    MagicId = 9100240301,
    Type = 13,
    Param = {
      Speed = 0.11,
      DelayFrame = 0
    }
  },
  [ 9100240302 ] = {
    MagicId = 9100240302,
    Type = 3,
    Param = {
      TimeScale = 0.11,
      CurveId = 0,
      DelayFrame = 0
    }
  }
}



Config.Magic910024.Buffs = 
{
  [ 91002401 ] = {
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
      91002401
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
      9100240100,
      9100240101,
      9100240102
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
  [ 91002402 ] = {
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
      91002402
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
      9100240200,
      9100240201,
      9100240202
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
  [ 91002403 ] = {
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
      91002403
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
      9100240300,
      9100240301,
      9100240302
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
