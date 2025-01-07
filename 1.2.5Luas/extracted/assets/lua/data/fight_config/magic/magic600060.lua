Config = Config or {}
Config.Magic600060 = Config.Magic600060 or { }
local empty = { }
Config.Magic600060.Magics = 
{
  [ 60006000100 ] = {
    MagicId = 60006000100,
    Type = 6,
    Param = {
      BuffStates = {
        10
      },
      DelayFrame = 0
    }
  },
  [ 600060005 ] = {
    MagicId = 600060005,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true,
      DelayFrame = 0
    }
  },
  [ 60006000200 ] = {
    MagicId = 60006000200,
    Type = 6,
    Param = {
      BuffStates = {
        10
      },
      DelayFrame = 0
    }
  }
}



Config.Magic600060.Buffs = 
{
  [ 600060001 ] = {
    DurationFrame = 90,
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
      5003
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      60006000100
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Weihu/WeihuMo1/Effect/FxCharm_HitCase.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      }
    },
    isDebuff = true,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/5003.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = true,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 2
  },
  [ 600060002 ] = {
    DurationFrame = 180,
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
      5003
    },
    Groups = {},
    Interval = {
      0.0
    },
    MagicIds = {
      60006000200
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/Weihu/WeihuMo1/Effect/FxCharm_HitCase.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = true
      }
    },
    isDebuff = true,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/5003.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = true,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 2
  }
}
