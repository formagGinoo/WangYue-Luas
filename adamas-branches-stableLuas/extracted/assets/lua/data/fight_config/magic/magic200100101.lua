Config = Config or {}
Config.Magic200100101 = Config.Magic200100101 or { }
local empty = { }
Config.Magic200100101.Magics = 
{
  [ 20010010100200 ] = {
    MagicId = 20010010100200,
    Type = 6,
    Param = {
      BuffStates = {
        5
      },
    }
  },
  [ 20010010100100 ] = {
    MagicId = 20010010100100,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 0
    }
  },
  [ 20010010100101 ] = {
    MagicId = 20010010100101,
    Type = 6,
    Param = {
      BuffStates = {
        9
      },
    }
  },
  [ 200100101003 ] = {
    MagicId = 200100101003,
    Type = 10,
    Param = {
      AttrType = 1005,
      AttrValue = 100,
      attrGroupType = 1,
      TempAttr = false
    }
  },
  [ 200100101004 ] = {
    MagicId = 200100101004,
    Type = 10,
    Param = {
      AttrType = 1201,
      AttrValue = 1,
      attrGroupType = 1,
      TempAttr = false
    }
  },
  [ 200100101005 ] = {
    MagicId = 200100101005,
    Type = 10,
    Param = {
      AttrType = 1204,
      AttrValue = 300,
      attrGroupType = 1,
      TempAttr = false
    }
  }
}



Config.Magic200100101.Buffs = 
{
  [ 200100101002 ] = {
    DurationFrame = 0,
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
    Kinds = {},
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      20010010100200
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
  [ 200100101001 ] = {
    DurationFrame = 0,
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
    Kinds = {},
    Groups = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      20010010100100,
      20010010100101
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
