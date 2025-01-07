Config = Config or {}
Config.Magic1005 = Config.Magic1005 or { }
local empty = { }
Config.Magic1005.Magics = 
{
  [ 1005001 ] = {
    MagicId = 1005001,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 284,
      SkillParam = 12000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005002 ] = {
    MagicId = 1005002,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 189,
      SkillParam = 8000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005003 ] = {
    MagicId = 1005003,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 165,
      SkillParam = 7000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005004 ] = {
    MagicId = 1005004,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 307,
      SkillParam = 13000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005005 ] = {
    MagicId = 1005005,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 331,
      SkillParam = 14000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 100509900 ] = {
    MagicId = 100509900,
    OrginMagicId = 1005099,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4
      },
      DelayFrame = 0
    }
  },
  [ 100509901 ] = {
    MagicId = 100509901,
    OrginMagicId = 1005099,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100509902 ] = {
    MagicId = 100509902,
    OrginMagicId = 1005099,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 1005050 ] = {
    MagicId = 1005050,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 50,
      DamageSkillType = 16,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 140000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 100505200 ] = {
    MagicId = 100505200,
    OrginMagicId = 1005052,
    Type = 47,
    Param = {
      effectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff01gunzi.prefab",
      Offset = { 0.0, 0.0, 0.0 },
      DelayFrame = 0
    }
  },
  [ 100505500 ] = {
    MagicId = 100505500,
    OrginMagicId = 1005055,
    Type = 16,
    Param = {
      Duration = -1,
      CameraTrackPath = "Character/Role/Male154/YixiangR31/Common/Timeline/CtYixiangR31M11Attack050.prefab",
      CameraTrackInfo = {
        {
          m_cameraTrackName = "YixiangR31M11_face",
          m_cameraBindBones = "YixiangR31M11_face"
        }
      },
      TimeIn = 0.0,
      TimeOut = 0.5,
      UseTimeScale = false,
      AutoResetVAxis = true,
      VAxisOffset = 8.0,
      AutoResetHAxis = true,
      HAxisOffset = 0.0,
      CameraCheckRadius = -999999.0,
      IngoreRotate = false,
      BindMainTargetMove = false,
      DelayFrame = 0
    }
  },
  [ 100505501 ] = {
    MagicId = 100505501,
    OrginMagicId = 1005055,
    Type = 24,
    Param = {
      Pause = true,
      DelayFrame = 0
    }
  },
  [ 1005010 ] = {
    MagicId = 1005010,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      DamageSkillType = 4,
      ElementType = 6,
      ElementAccumulate = 355,
      SkillParam = 15000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005011 ] = {
    MagicId = 1005011,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 10,
      DamageSkillType = 4,
      ElementType = 6,
      ElementAccumulate = 591,
      SkillParam = 25000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005012 ] = {
    MagicId = 1005012,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 12,
      DamageSkillType = 4,
      ElementType = 6,
      ElementAccumulate = 709,
      SkillParam = 30000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005013 ] = {
    MagicId = 1005013,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 12,
      DamageSkillType = 4,
      ElementType = 6,
      ElementAccumulate = 1300,
      SkillParam = 55000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 100501400 ] = {
    MagicId = 100501400,
    OrginMagicId = 1005014,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4,
        15
      },
      DelayFrame = 0
    }
  },
  [ 100501500 ] = {
    MagicId = 100501500,
    OrginMagicId = 1005015,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 1005010001,
      DelayFrame = 0
    }
  },
  [ 100501501 ] = {
    MagicId = 100501501,
    OrginMagicId = 1005015,
    Type = 13,
    Param = {
      Speed = 0.1,
      DelayFrame = 0
    }
  },
  [ 100501502 ] = {
    MagicId = 100501502,
    OrginMagicId = 1005015,
    Type = 3,
    Param = {
      TimeScale = 0.0,
      CurveId = 1005010001,
      DelayFrame = 0
    }
  },
  [ 1005080 ] = {
    MagicId = 1005080,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 80,
      DamageSkillType = 512,
      ElementType = 6,
      ElementAccumulate = 1891,
      SkillParam = 80000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 100505600 ] = {
    MagicId = 100505600,
    OrginMagicId = 1005056,
    Type = 6,
    Param = {
      BuffStates = {
        1,
        2,
        4,
        5,
        12,
        15,
        23
      },
      DelayFrame = 0
    }
  },
  [ 100505700 ] = {
    MagicId = 100505700,
    OrginMagicId = 1005057,
    Type = 12,
    Param = {
      TimeScale = 0.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100505701 ] = {
    MagicId = 100505701,
    OrginMagicId = 1005057,
    Type = 13,
    Param = {
      Speed = 0.0,
      DelayFrame = 0
    }
  },
  [ 100508100 ] = {
    MagicId = 100508100,
    OrginMagicId = 1005081,
    Type = 6,
    Param = {
      BuffStates = {
        2,
        4,
        15
      },
      DelayFrame = 0
    }
  },
  [ 100500800 ] = {
    MagicId = 100500800,
    OrginMagicId = 1005008,
    Type = 3,
    Param = {
      TimeScale = 2.0,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1005040 ] = {
    MagicId = 1005040,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 8,
      ElementType = 6,
      ElementAccumulate = 284,
      SkillParam = 12000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005041 ] = {
    MagicId = 1005041,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 8,
      ElementType = 6,
      ElementAccumulate = 236,
      SkillParam = 10000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005042 ] = {
    MagicId = 1005042,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 8,
      ElementType = 6,
      ElementAccumulate = 473,
      SkillParam = 20000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005043 ] = {
    MagicId = 1005043,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 8,
      ElementType = 6,
      ElementAccumulate = 851,
      SkillParam = 36000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005044 ] = {
    MagicId = 1005044,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 8,
      ElementType = 6,
      ElementAccumulate = 1702,
      SkillParam = 72000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005045 ] = {
    MagicId = 1005045,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 8,
      ElementType = 6,
      ElementAccumulate = 2553,
      SkillParam = 108000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 1005172 ] = {
    MagicId = 1005172,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 172,
      DamageSkillType = 4096,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 6000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005006 ] = {
    MagicId = 1005006,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 473,
      SkillParam = 20000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005007 ] = {
    MagicId = 1005007,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 567,
      SkillParam = 24000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005009 ] = {
    MagicId = 1005009,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 2,
      ElementType = 1,
      ElementAccumulate = 662,
      SkillParam = 28000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = false,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 1005100200 ] = {
    MagicId = 1005100200,
    OrginMagicId = 10051002,
    Type = 10,
    Param = {
      AttrType = 66,
      AttrValue = 1500.0,
      attrGroupType = 0,
      TempAttr = false,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  },
  [ 1005100600 ] = {
    MagicId = 1005100600,
    OrginMagicId = 10051006,
    Type = 10,
    Param = {
      AttrType = 44,
      AttrValue = 1000.0,
      attrGroupType = 0,
      TempAttr = false,
      HaveMaxValue = false,
      MaxValue = 0,
      KeepRatioStart = false,
      KeepRatioEnd = false,
      DelayFrame = 0
    }
  },
  [ 1005059 ] = {
    MagicId = 1005059,
    OrginMagicId = 0,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 40,
      DamageSkillType = 16,
      ElementType = 6,
      ElementAccumulate = 0,
      SkillParam = 39000,
      DmgAttrType = 2,
      SkillBaseDmg = 0,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 3,
      DelayFrame = 0
    }
  },
  [ 100506300 ] = {
    MagicId = 100506300,
    OrginMagicId = 1005063,
    Type = 3,
    Param = {
      TimeScale = 0.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 100506400 ] = {
    MagicId = 100506400,
    OrginMagicId = 1005064,
    Type = 3,
    Param = {
      TimeScale = 1.3,
      CurveId = 0,
      DelayFrame = 0
    }
  },
  [ 1005100100 ] = {
    MagicId = 1005100100,
    OrginMagicId = 10051001,
    Type = 48,
    Param = {
      paramList = {
        {
          sValue = "1000",
          bValue = false,
          type = 1,
          name = ""
        }
      },
      DelayFrame = 0
    }
  },
  [ 1005100300 ] = {
    MagicId = 1005100300,
    OrginMagicId = 10051003,
    Type = 48,
    Param = {
      paramList = {
        {
          sValue = "2000",
          bValue = false,
          type = 1,
          name = ""
        }
      },
      DelayFrame = 0
    }
  },
  [ 1005100500 ] = {
    MagicId = 1005100500,
    OrginMagicId = 10051005,
    Type = 48,
    Param = {
      paramList = {
        {
          sValue = "2500",
          bValue = false,
          type = 1,
          name = ""
        }
      },
      DelayFrame = 0
    }
  }
}



Config.Magic1005.Buffs = 
{
  [ 1005099 ] = {
    DurationFrame = 90,
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
    Kinds = {
      1005099
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100509900,
      100509901,
      100509902
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
  },
  [ 1005051 ] = {
    DurationFrame = 32,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005051
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff01.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = false
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
  [ 1005052 ] = {
    DurationFrame = 29,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005052
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100505200
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
  },
  [ 1005053 ] = {
    DurationFrame = 9,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005053
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff02.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = false,
        OnlyUpdateY = false,
        LoadToBones = false
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
  [ 1005054 ] = {
    DurationFrame = 600,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false,
        LoadToBones = false
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
  [ 1005055 ] = {
    DurationFrame = 90,
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
    Kinds = {
      1005055,
      1003
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100505500,
      100505501
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
  },
  [ 1005014 ] = {
    DurationFrame = 90,
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005014
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100501400
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
  },
  [ 1005015 ] = {
    DurationFrame = 9,
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005015
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0,
      0.0
    },
    MagicIds = {
      100501500,
      100501501,
      100501502
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
  },
  [ 1005056 ] = {
    DurationFrame = 90,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005056
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100505600
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
  },
  [ 1005057 ] = {
    DurationFrame = 74,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
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
    Kinds = {
      1005057
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0,
      0.0
    },
    MagicIds = {
      100505700,
      100505701
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
  },
  [ 1005081 ] = {
    DurationFrame = 15,
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
    Kinds = {
      1005081
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100508100
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
  },
  [ 1005008 ] = {
    DurationFrame = 99,
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005008
    },
    Groups = {
      1,
      2,
      3
    },
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100500800
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
  },
  [ 10051002 ] = {
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
    Kinds = {
      10051002
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      1005100200
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
  },
  [ 10051006 ] = {
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
    Kinds = {
      10051006
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      1005100600
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
  },
  [ 1005058 ] = {
    DurationFrame = 720,
    Type = 1,
    EffectType = 0,
    DelayFrame = 0,
    BindTimeScale = true,
    BindRefEntity = false,
    MaxLimit = 1,
    IsBuffLayer = false,
    MaxBuffLayer = 1,
    DecLayer = 1,
    DecLayerFrame = 2.0,
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      1005058
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
        EffectPath = "Character/Role/Male154/YixiangR31/Common/Effect/FxYixiangR31M11Atk050Buff.prefab",
        EffectBindBones = "Root",
        EffectOffset = { 0.0, 0.0, 0.0 },
        DontBindRotation = true,
        OnlyUpdateY = false,
        LoadToBones = false
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
  [ 1005063 ] = {
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
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100506300
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
  },
  [ 1005064 ] = {
    DurationFrame = 2,
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
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      100506400
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
  },
  [ 10051001 ] = {
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      10051001
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      1005100100
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
  },
  [ 10051003 ] = {
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      10051003
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      1005100300
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
  },
  [ 10051005 ] = {
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
    IsResetDurationFrame = true,
    BindAttrType = false,
    AttrValueType = 0,
    BuffValueType = 0,
    NeedValue = 0.0,
    FinishBuffId = 0,
    CheckKind = false,
    Kinds = {
      10051005
    },
    Groups = {},
    ImmunityId = {},
    ImmunityKind = {},
    Interval = {
      0.0
    },
    MagicIds = {
      1005100500
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
