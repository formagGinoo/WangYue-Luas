Config = Config or {}
Config.Magic900030 = Config.Magic900030 or { }
local empty = { }
Config.Magic900030.Magics = 
{
  [ 90003001 ] = {
    MagicId = 90003001,
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
  [ 90003002 ] = {
    MagicId = 90003002,
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
  [ 90003004 ] = {
    MagicId = 90003004,
    Type = 6,
    Param = {
      BuffStates = {
        2
      },
    }
  },
  [ 9000300300 ] = {
    MagicId = 9000300300,
    Type = 10,
    Param = {
      AttrType = 3,
      AttrValue = 3000,
      attrGroupType = 2,
      TempAttr = true
    }
  }
}



Config.Magic900030.Buffs = 
{
  [ 90003003 ] = {
    DurationFrame = 301,
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
      9000300300
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
