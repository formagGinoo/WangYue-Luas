Config = Config or {}
Config.Magic900150 = Config.Magic900150 or { }
local empty = { }
Config.Magic900150.Magics = 
{
  [ 90015001001 ] = {
    MagicId = 90015001001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  }
}



Config.Magic900150.Buffs = 
{
  [ 90015001 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {},
    Groups = {
      90015001
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Animal/Yuekongyuan/Effect/FxYuekongyuanDanger.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = true
      }
    },
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
  [ 90015002 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {},
    Groups = {
      90015001
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    FirstTimes = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Animal/Yuekongyuan/Effect/FxYuekongyuanPeace.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = true
      }
    },
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
