Config = Config or {}
Config.Magic2030208 = Config.Magic2030208 or { }
local empty = { }
Config.Magic2030208.Magics = 
{
  [ 20302080100 ] = {
    MagicId = 20302080100,
    Type = 7,
    Param = {
      BoneNames = {
        "SpecialTree_10020001_06a_Plain",
        "SpecialTree_10020001_06b_Plain"
      },
    }
  }
}



Config.Magic2030208.Buffs = 
{
  [ 203020801 ] = {
    DurationFrame = -1,
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
      203020801
    },
    Groups = {
      203020801
    },
    Interval = {
      0.0
    },
    MagicIds = {
      20302080100
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
