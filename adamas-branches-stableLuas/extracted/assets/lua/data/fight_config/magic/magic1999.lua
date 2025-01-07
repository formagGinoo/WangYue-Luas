Config = Config or {}
Config.Magic1999 = Config.Magic1999 or { }
local empty = { }
Config.Magic1999.Magics = 
{
  [ 1999001 ] = {
    MagicId = 1999001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 1999002 ] = {
    MagicId = 1999002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 1999003 ] = {
    MagicId = 1999003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 1999101 ] = {
    MagicId = 1999101,
    Type = 5,
    Param = {
      EntityId = 199900102,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false
    }
  },
  [ 199900400 ] = {
    MagicId = 199900400,
    Type = 6,
    Param = {
      BuffStates = {
        2
      },
    }
  },
  [ 199990100 ] = {
    MagicId = 199990100,
    Type = 9,
    Param = {
      Radius = 1.0,
      StartSpeed = 2.5,
      EndSpeed = 0.0
    }
  },
  [ 199990200 ] = {
    MagicId = 199990200,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2
      },
    }
  },
  [ 199990300 ] = {
    MagicId = 199990300,
    Type = 6,
    Param = {
      BuffStates = {
        2
      },
    }
  }
}



Config.Magic1999.Buffs = 
{
  [ 1999004 ] = {
    DurationFrame = 299973,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1999004
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
      199900400
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
    tipsDesc = ""
  },
  [ 1999901 ] = {
    DurationFrame = 4,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1999901
    },
    Groups = {
      1,
      2,
      3
    },
    Interval = {
      0.03
    },
    MagicIds = {
      199990100
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
    tipsDesc = ""
  },
  [ 1999902 ] = {
    DurationFrame = 2,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1999902
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
      199990200
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
    tipsDesc = ""
  },
  [ 1999903 ] = {
    DurationFrame = 61,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1999903
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
      199990300
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
    tipsDesc = ""
  }
}
