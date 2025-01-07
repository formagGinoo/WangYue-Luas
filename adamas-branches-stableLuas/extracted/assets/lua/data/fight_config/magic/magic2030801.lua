Config = Config or {}
Config.Magic2030801 = Config.Magic2030801 or { }
local empty = { }
Config.Magic2030801.Magics = 
{
  [ 20308010100 ] = {
    MagicId = 20308010100,
    Type = 7,
    Param = {
      BoneNames = {
        "ElectEffect"
      },
      DelayFrame = 0
    }
  }
}



Config.Magic2030801.Buffs = 
{
  [ 203080101 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
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
      203080101
    },
    Groups = {
      203080101
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      20308010100
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
