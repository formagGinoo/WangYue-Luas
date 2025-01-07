Config = Config or {}
Config.Magic900102 = Config.Magic900102 or { }
local empty = { }
Config.Magic900102.Magics = 
{
  [ 900102041 ] = {
    MagicId = 900102041,
    Type = 36,
    Param = {
      IsPrecentRevive = true,
      ReviveValue = 30.0,
      DelayFrame = 0
    }
  },
  [ 9001020011 ] = {
    MagicId = 9001020011,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 7000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 900102002 ] = {
    MagicId = 900102002,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 5000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 900102003 ] = {
    MagicId = 900102003,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 9001020012 ] = {
    MagicId = 9001020012,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 8000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 9001020031 ] = {
    MagicId = 9001020031,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 3000,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 9001020300 ] = {
    MagicId = 9001020300,
    Type = 10,
    Param = {
      AttrType = 30,
      AttrValue = 5000,
      attrGroupType = 1,
      TempAttr = false,
      HaveMaxValue = false,
      MaxValue = 0,
      DelayFrame = 0
    }
  }
}



Config.Magic900102.Buffs = 
{
  [ 90010201 ] = {
    DurationFrame = -1,
    Type = 1,
    EffectType = 0,
    DelayFrame = 16,
    BindTimeScale = true,
    MaxLimit = 1,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005054
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {},
    MagicIds = {},
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/JiDuLingKe/JiDuLingKeMb3/Effcet/FxJidulingkeAlert_Loop_Weapon_030_RootBone.prefab",
        EffectBindBones = "Weapon_030_RootBone",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
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
  [ 90010203 ] = {
    DurationFrame = 180,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 1,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {},
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      9001020300
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Character/Monster/JiDuLingKe/JiDuLingKeMb3/Effcet/FxJidulingkeAtk003Buff.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false
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
