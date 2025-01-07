Config = Config or {}
Config.Magic2060101 = Config.Magic2060101 or { }
local empty = { }
Config.Magic2060101.Magics = 
{
  [ 100100 ] = {
    MagicId = 100100,
    Type = 7,
    Param = {
      BoneNames = {
        "volume"
      },
    }
  }
}



Config.Magic2060101.Buffs = 
{
  [ 1001 ] = {
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
    Kinds = {},
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100100
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
