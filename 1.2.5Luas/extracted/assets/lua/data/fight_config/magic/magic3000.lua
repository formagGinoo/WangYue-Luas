Config = Config or {}
Config.Magic3000 = Config.Magic3000 or { }
local empty = { }
Config.Magic3000.Magics = 
{
  [ 30000141100 ] = {
    MagicId = 30000141100,
    Type = 14,
    Param = {
      behaviorName = 300001411,
      DelayFrame = 0
    }
  },
  [ 30000140100 ] = {
    MagicId = 30000140100,
    Type = 10,
    Param = {
      AttrType = 22,
      AttrValue = 1000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000140200 ] = {
    MagicId = 30000140200,
    Type = 10,
    Param = {
      AttrType = 22,
      AttrValue = 1500,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000140300 ] = {
    MagicId = 30000140300,
    Type = 10,
    Param = {
      AttrType = 22,
      AttrValue = 2000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000140400 ] = {
    MagicId = 30000140400,
    Type = 10,
    Param = {
      AttrType = 22,
      AttrValue = 2500,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000140500 ] = {
    MagicId = 30000140500,
    Type = 10,
    Param = {
      AttrType = 22,
      AttrValue = 3000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000151100 ] = {
    MagicId = 30000151100,
    Type = 14,
    Param = {
      behaviorName = 300001511,
      DelayFrame = 0
    }
  },
  [ 30000150100 ] = {
    MagicId = 30000150100,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 500,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000150200 ] = {
    MagicId = 30000150200,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 600,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000150300 ] = {
    MagicId = 30000150300,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 700,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000150400 ] = {
    MagicId = 30000150400,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 800,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000150500 ] = {
    MagicId = 30000150500,
    Type = 10,
    Param = {
      AttrType = 25,
      AttrValue = 900,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000151200 ] = {
    MagicId = 30000151200,
    Type = 14,
    Param = {
      behaviorName = 300001512,
      DelayFrame = 0
    }
  },
  [ 30000151300 ] = {
    MagicId = 30000151300,
    Type = 14,
    Param = {
      behaviorName = 300001513,
      DelayFrame = 0
    }
  },
  [ 30000151400 ] = {
    MagicId = 30000151400,
    Type = 14,
    Param = {
      behaviorName = 300001514,
      DelayFrame = 0
    }
  },
  [ 30000151500 ] = {
    MagicId = 30000151500,
    Type = 14,
    Param = {
      behaviorName = 300001515,
      DelayFrame = 0
    }
  },
  [ 30000131100 ] = {
    MagicId = 30000131100,
    Type = 10,
    Param = {
      AttrType = 57,
      AttrValue = 2000,
      attrGroupType = 1,
      TempAttr = true,
      DelayFrame = 0
    }
  },
  [ 30000130100 ] = {
    MagicId = 30000130100,
    Type = 14,
    Param = {
      behaviorName = 300001301,
      DelayFrame = 0
    }
  }
}



Config.Magic3000.Buffs = 
{
  [ 300001411 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001411
    },
    Groups = {
      300001411
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000141100
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001401 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001401
    },
    Groups = {
      300001401
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000140100
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001402 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001302
    },
    Groups = {
      300001302
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000140200
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001403 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001403
    },
    Groups = {
      300001403
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000140300
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001404 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001404
    },
    Groups = {
      300001404
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000140400
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001405 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001405
    },
    Groups = {
      300001405
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000140500
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001511 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001511
    },
    Groups = {
      300001511
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000151100
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001501 ] = {
    DurationFrame = 91,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 4,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      300001501
    },
    Groups = {
      300001501
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000150100
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddAttack.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
    isDebuff = false,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/buff_B.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001502 ] = {
    DurationFrame = 91,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 4,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      300001502
    },
    Groups = {
      300001502
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000150200
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddAttack.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
    isDebuff = false,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/buff_B.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001503 ] = {
    DurationFrame = 91,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 4,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      300001503
    },
    Groups = {
      300001503
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000150300
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddAttack.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
    isDebuff = false,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/buff_B.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001504 ] = {
    DurationFrame = 91,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 4,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      300001504
    },
    Groups = {
      300001504
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000150400
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddAttack.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
    isDebuff = false,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/buff_B.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001505 ] = {
    DurationFrame = 91,
    Type = 1,
    DelayFrame = 0,
    BindTimeScale = false,
    MaxLimit = 4,
    IsResetDurationFrame = false,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      300001505
    },
    Groups = {
      300001505
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000150500
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddAttack.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
    isDebuff = false,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/buff_B.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001512 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001512
    },
    Groups = {
      300001512
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000151200
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001513 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001513
    },
    Groups = {
      300001513
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000151300
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001514 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001514
    },
    Groups = {
      300001514
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000151400
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001515 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001515
    },
    Groups = {
      300001515
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000151500
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001311 ] = {
    DurationFrame = 150,
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
    CheckKind = false,
    Kinds = {
      300001311
    },
    Groups = {
      300001311
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000131100
    },
    EffectKind = 0,
    EffectInfos = {
      {
        EffectPath = "Effect/Prefab/Buff/FxAddAttack.prefab",
        EffectBindBones = "HitCase",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false
      }
    },
    isDebuff = false,
    elementType = 6,
    buffIconPath = "Textures/Icon/Single/BuffIcon/buff_B.png",
    showPriority = 0,
    isShowNum = false,
    isShowTips = false,
    tipsName = "",
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  },
  [ 300001301 ] = {
    DurationFrame = -1,
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
    CheckKind = false,
    Kinds = {
      300001301
    },
    Groups = {
      300001301
    },
    Interval = {
      0.0
    },
    MagicIds = {
      30000130100
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
    tipsDesc = "",
    TriggerRemoveNum = 0,
    DeriveList = {},
    effectFontType = 0
  }
}
