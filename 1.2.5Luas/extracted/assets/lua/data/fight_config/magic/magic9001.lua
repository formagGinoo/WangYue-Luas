Config = Config or {}
Config.Magic9001 = Config.Magic9001 or { }
local empty = { }
Config.Magic9001.Magics = 
{
  [ 9001001 ] = {
    MagicId = 9001001,
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
  [ 9001002 ] = {
    MagicId = 9001002,
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
  [ 9001003 ] = {
    MagicId = 9001003,
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
  [ 9001101 ] = {
    MagicId = 9001101,
    Type = 5,
    Param = {
      EntityId = 900100102,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false
    }
  },
  [ 900100400 ] = {
    MagicId = 900100400,
    Type = 6,
    Param = {
      BuffStates = {
        2
      },
    }
  }
}



Config.Magic9001.Buffs = 
{
  [ 9001004 ] = {
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
    Kinds = {
      9001004
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
      900100400
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
