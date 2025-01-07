Config = Config or {}
Config.Entity62001 = Config.Entity62001 or { }
local empty = { }
Config.Entity62001 = 
{
  [ 62001 ] = {
    EntityId = 62001,
    EntityName = "62001",
    Components = {
      Skill = {
        Skills = {
          [ 62001001 ] = {
            TotalFrame = 16,
            ForceFrame = 16,
            SkillBreakSkillFrame = 16,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 3.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "20034",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "AssassinSkill",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  PostProcessType = 1,
                  PostProcessParams = {
                    SplitDirection = 0,
                    Amount = 0.25,
                    Speed = 0.0,
                    Fading = 1.0,
                    FadingCurveId = 100000024,
                    CenterFading = 1.0,
                    AmountR = -1.0,
                    AmountB = 1.0,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 1,
                    Duration = 4,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 0,
                  EventType = 16,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.3,
                    Dir = 0,
                    Radius = 0.8,
                    Alpha = 1.0,
                    AlphaCurveId = 100000022,
                    Direction = 0,
                    Count = 20,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 0,
                  EventType = 16,

                },
                {

                  AddType = 1,
                  BuffId = 1000062,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "ShowPartner",
                  StartFrame = 1,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 5,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 11 ] = {
                {

                  Name = "AssassinRushing",
                  StartFrame = 1,
                  FrameTime = 11,
                  EventType = 2,

                },
                {                  DurationUpdateTargetFrame = 4,
                  OffsetType = 1,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, -1.5 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 11,
                  EventType = 18,

                }
              },
              [ 15 ] = {
                {

                  Type = 62001011,
                  Frame = 1,
                  FrameTime = 15,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001002 ] = {
            TotalFrame = 55,
            ForceFrame = 55,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 62001017,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "AssassinSuccess2",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 6200100301,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 12,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 62001009001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 14,
                  EventType = 1,

                },
                {

                  Type = 62001002,
                  Frame = 1,
                  FrameTime = 14,
                  EventType = 3,

                }
              },
              [ 29 ] = {
                {

                  AddType = 1,
                  BuffId = 1000063,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 29,
                  EventType = 9,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 6200100402,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 30,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 62001020,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 30,
                  EventType = 9,

                }
              },
              [ 55 ] = {
                {

                  Type = 62001999,
                  Frame = 2,
                  FrameTime = 55,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001003 ] = {
            TotalFrame = 55,
            ForceFrame = 55,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 62001017,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "AssassinSuccess2",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 6200100301,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 12,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 62001004001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 14,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 6200100203,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  Type = 62001002,
                  Frame = 1,
                  FrameTime = 30,
                  EventType = 3,

                },
                {

                  EntityId = 6200100402,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 30,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 62001020,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 30,
                  EventType = 9,

                }
              },
              [ 55 ] = {
                {

                  Type = 62001999,
                  Frame = 2,
                  FrameTime = 55,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001004 ] = {
            TotalFrame = 0,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Assassin_Touch",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 43.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 1,
                  EventType = 12,

                }
              },
              [ 9 ] = {
                {

                  RotateType = 4,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 4,
                  FrameTime = 9,
                  EventType = 8,

                }
              },
              [ 10 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = -0.3,
                  TargetVPositionOffset = -0.2,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = 3,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 10,
                  EventType = 18,

                }
              },
              [ 12 ] = {
                {

                  Type = 62001004,
                  Frame = 1,
                  FrameTime = 12,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001005 ] = {
            TotalFrame = 15,
            ForceFrame = 15,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = true,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 0.0,
                  MaxFallSpeed = -999.0,
                  FrameTime = 0,
                  EventType = 12,

                },
                {

                  Name = "AssassinFinishFall",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 15 ] = {
                {

                  Type = 62001999,
                  Frame = 1,
                  FrameTime = 15,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001006 ] = {
            TotalFrame = 10,
            ForceFrame = 10,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "AssassinFinishEnd",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  Type = 62001006,
                  Frame = 1,
                  FrameTime = 10,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001007 ] = {
            TotalFrame = 14,
            ForceFrame = 14,
            SkillBreakSkillFrame = 14,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 10.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "20034",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "AssassinSkill",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 3 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.3,
                    Dir = 0,
                    Radius = 0.8,
                    Alpha = 1.0,
                    AlphaCurveId = 100000022,
                    Direction = 0,
                    Count = 20,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 3,
                  EventType = 16,

                },
                {

                  PostProcessType = 1,
                  PostProcessParams = {
                    SplitDirection = 0,
                    Amount = 0.25,
                    Speed = 0.0,
                    Fading = 1.0,
                    FadingCurveId = 100000024,
                    CenterFading = 1.0,
                    AmountR = -1.0,
                    AmountB = 1.0,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 1,
                    Duration = 4,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 3,
                  EventType = 16,

                },
                {

                  AddType = 1,
                  BuffId = 1000062,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 3,
                  EventType = 9,

                },
                {

                  Name = "FallAssasinLoop",
                  StartFrame = 0,
                  FrameTime = 3,
                  EventType = 2,

                },
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 6,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.2,
                  TargetVPositionOffset = -0.5,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = 6,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 3,
                  EventType = 18,

                }
              },
              [ 4 ] = {
                {

                  MagicId = 1000053,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 10,

                }
              },
              [ 10 ] = {
                {

                  Type = 62001020,
                  Frame = 1,
                  FrameTime = 10,
                  EventType = 3,

                },
                {

                  Name = "FallAssasinTouch",
                  StartFrame = 0,
                  FrameTime = 10,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  Type = 62001007,
                  Frame = 1,
                  FrameTime = 13,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001008 ] = {
            TotalFrame = 105,
            ForceFrame = 105,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 10.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "20034",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "XumuR11RedSkill",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack008",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 32,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 6200100802,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  MoveFrame = 105,
                  InputSpeed = 0.0,
                  MinDistance = 0.5,
                  IgnoreYAxis = true,
                  SkillMoveDone = 4,
                  FrameTime = 25,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      62001008
                    },
                  }
                }
              },
              [ 32 ] = {
                {

                  EntityId = 6200100801,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 62001008001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -1.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 2.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 33,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 6200100803,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 95 ] = {
                {

                  Type = 62001,
                  Frame = 10,
                  FrameTime = 95,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001009 ] = {
            TotalFrame = 13,
            ForceFrame = 13,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Assassin_Touch",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 43.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 1,
                  EventType = 12,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 4,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 4,
                  FrameTime = 4,
                  EventType = 8,

                }
              },
              [ 5 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = 3,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 5,
                  EventType = 18,

                }
              },
              [ 8 ] = {
                {

                  Type = 62001009,
                  Frame = 1,
                  FrameTime = 8,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001010 ] = {
            TotalFrame = 35,
            ForceFrame = 35,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 62001014,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "AssassinFail",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  Type = 62001010,
                  Frame = 1,
                  FrameTime = 4,
                  EventType = 3,

                }
              },
              [ 31 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = true,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 0.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 31,
                  EventType = 12,

                }
              },
              [ 34 ] = {
                {

                  Type = 62001999,
                  Frame = 2,
                  FrameTime = 34,
                  EventType = 3,

                }
              },
              [ 999 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 24.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 999,
                  EventType = 12,

                }
              },
            }
          },
          [ 62001011 ] = {
            TotalFrame = 36,
            ForceFrame = 36,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Assassin_Start2",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 62001012,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 1,
                  EventType = 10,

                }
              },
              [ 8 ] = {
                {

                  Type = 62001062,
                  Frame = 1,
                  FrameTime = 8,
                  EventType = 3,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 6200100401,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.5,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 9,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  MagicId = 62001015,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 22,
                  EventType = 10,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 29 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 4,
                  OffsetType = 2,
                  TargetHPositionOffset = 1.0,
                  TargetVPositionOffset = -0.5,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = 4,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 29,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 32 ] = {
                {

                  Type = 62001101,
                  Frame = 1,
                  FrameTime = 32,
                  EventType = 3,

                }
              },
              [ 33 ] = {
                {

                  MagicId = 62001016,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 33,
                  EventType = 10,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 35 ] = {
                {

                  Type = 62001001,
                  Frame = 1,
                  FrameTime = 35,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001012 ] = {
            TotalFrame = 20,
            ForceFrame = 20,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000053,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack016",
                  StartFrame = 174,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  AddType = 1,
                  BuffId = 62001018,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 1,
                  EventType = 9,

                }
              },
            }
          },
          [ 62001013 ] = {
            TotalFrame = 24,
            ForceFrame = 24,
            SkillBreakSkillFrame = 24,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  PostProcessType = 1,
                  PostProcessParams = {
                    SplitDirection = 0,
                    Amount = 0.25,
                    Speed = 0.0,
                    Fading = 1.0,
                    FadingCurveId = 100000024,
                    CenterFading = 1.0,
                    AmountR = -1.0,
                    AmountB = 1.0,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 1,
                    Duration = 4,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 0,
                  EventType = 16,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.3,
                    Dir = 0,
                    Radius = 0.8,
                    Alpha = 1.0,
                    AlphaCurveId = 100000022,
                    Direction = 0,
                    Count = 20,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 0,
                  EventType = 16,

                },
                {

                  Name = "GlideAssassinStart",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 5 ] = {
                {

                  AddType = 1,
                  BuffId = 1000062,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 5,
                  EventType = 9,

                },
                {

                  Name = "GlideAssassinLoop",
                  StartFrame = 0,
                  FrameTime = 5,
                  EventType = 2,

                },
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 12,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.2,
                  TargetVPositionOffset = -0.5,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 12,
                  VDurationMoveFrame = 12,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 5,
                  EventType = 18,

                }
              },
              [ 6 ] = {
                {

                  MagicId = 1000053,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 6,
                  EventType = 10,

                }
              },
              [ 17 ] = {
                {

                  Type = 62001020,
                  Frame = 1,
                  FrameTime = 17,
                  EventType = 3,

                },
                {

                  Name = "GlideAssassinTouch",
                  StartFrame = 0,
                  FrameTime = 17,
                  EventType = 2,

                }
              },
              [ 23 ] = {
                {

                  Type = 62001013,
                  Frame = 1,
                  FrameTime = 23,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001017 ] = {
            TotalFrame = 160,
            ForceFrame = 160,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 20.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "20034",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "XumuR11RedSkill",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack017",
                  StartFrame = 8,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 6200101714,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 0,
                  EventType = 1,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  MoveFrame = 60,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  IgnoreYAxis = true,
                  SkillMoveDone = 4,
                  FrameTime = 0,
                  EventType = 7,

                }
              },
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 2,
                  EventType = 8,

                }
              },
              [ 14 ] = {
                {                  DurationUpdateTargetFrame = 6,
                  OffsetType = 2,
                  TargetHPositionOffset = 3.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 14,
                  EventType = 18,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 6200101711,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 17,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 62001017011,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 19 ] = {
                {

                  Name = "Attack017",
                  StartFrame = 37,
                  FrameTime = 19,
                  EventType = 2,

                }
              },
              [ 24 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 240.0,
                  Acceleration = 240.0,
                  RotateFrame = 8,
                  FrameTime = 24,
                  EventType = 8,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 6200101712,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 30,
                  EventType = 1,

                }
              },
              [ 32 ] = {
                {

                  EntityId = 62001017012,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.5,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 2.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 6200101713,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 37,
                  EventType = 1,

                }
              },
              [ 40 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 20,
                  FrameTime = 40,
                  EventType = 8,

                }
              },
              [ 48 ] = {
                {

                  EntityId = 9200199905,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 48,
                  EventType = 1,

                }
              },
              [ 59 ] = {
                {

                  AddType = 1,
                  BuffId = 62001026,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 59,
                  EventType = 9,

                }
              },
              [ 70 ] = {
                {                  DurationUpdateTargetFrame = 6,
                  OffsetType = 2,
                  TargetHPositionOffset = 5.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 70,
                  EventType = 18,

                }
              },
              [ 80 ] = {
                {

                  MagicId = 1017010,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 80,
                  EventType = 10,

                },
                {

                  EntityId = 62001017013,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 80,
                  EventType = 1,

                }
              },
              [ 127 ] = {
                {

                  Type = 600000006,
                  Frame = 1,
                  FrameTime = 127,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001020 ] = {
            TotalFrame = 41,
            ForceFrame = 40,
            SkillBreakSkillFrame = 40,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "RightSlightHit",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 6000009,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
            }
          },
          [ 62001099 ] = {
            TotalFrame = 52,
            ForceFrame = 52,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 3 ] = {
                {

                  Name = "AssassinRushing",
                  StartFrame = 1,
                  FrameTime = 3,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 8,
                  FrameTime = 3,
                  EventType = 8,

                },
                {                  DurationUpdateTargetFrame = 5,
                  OffsetType = 1,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, -2.0 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 3,
                  EventType = 18,

                }
              },
              [ 4 ] = {
                {

                  MagicId = 1000053,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 10,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 43.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 4,
                  EventType = 12,

                }
              },
              [ 8 ] = {
                {

                  Name = "Assassin_Touch",
                  StartFrame = 0,
                  FrameTime = 8,
                  EventType = 2,

                }
              },
              [ 17 ] = {
                {

                  RotateType = 4,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 4,
                  FrameTime = 17,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = -0.5,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = -1,
                  VDurationMoveFrame = 3,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 18,
                  EventType = 18,

                }
              },
              [ 21 ] = {
                {

                  Name = "Assassin_Start",
                  StartFrame = 0,
                  FrameTime = 21,
                  EventType = 2,

                }
              },
              [ 22 ] = {
                {

                  MagicId = 62001012,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 22,
                  EventType = 10,

                }
              },
              [ 43 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 7,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = -1,
                  VDurationMoveFrame = 7,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 43,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  MagicId = 62001015,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 43,
                  EventType = 10,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 45 ] = {
                {

                  Type = 62001101,
                  Frame = 1,
                  FrameTime = 45,
                  EventType = 3,

                }
              },
              [ 46 ] = {
                {

                  MagicId = 62001016,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 46,
                  EventType = 10,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 52 ] = {
                {

                  Type = 62001001,
                  Frame = 1,
                  FrameTime = 52,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001101 ] = {
            TotalFrame = 7,
            ForceFrame = 7,
            SkillBreakSkillFrame = 7,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  XZEnable = true,
                  YEnable = false,
                  FrameTime = 0,
                  EventType = 22,

                },
                {

                  XZEnable = true,
                  YEnable = true,
                  FrameTime = 0,
                  EventType = 22,

                },
                {

                  PostProcessType = 1,
                  PostProcessParams = {
                    SplitDirection = 0,
                    Amount = 0.25,
                    Speed = 0.0,
                    Fading = 1.0,
                    FadingCurveId = 100000024,
                    CenterFading = 1.0,
                    AmountR = -1.0,
                    AmountB = 1.0,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 1,
                    Duration = 4,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 0,
                  EventType = 16,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.3,
                    Dir = 0,
                    Radius = 0.8,
                    Alpha = 1.0,
                    AlphaCurveId = 100000022,
                    Direction = 0,
                    Count = 20,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 0,
                  EventType = 16,

                },
                {

                  AddType = 1,
                  BuffId = 1000062,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "AssassinRushing",
                  StartFrame = 1,
                  FrameTime = 0,
                  EventType = 2,

                },
                {                  DurationUpdateTargetFrame = 5,
                  OffsetType = 1,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, -1.5 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 0,
                  EventType = 18,

                }
              },
              [ 1 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 8,
                  FrameTime = 1,
                  EventType = 8,

                }
              },
              [ 6 ] = {
                {

                  Type = 62001011,
                  Frame = 1,
                  FrameTime = 6,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001102 ] = {
            TotalFrame = 36,
            ForceFrame = 36,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 62001017,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "AssassinSuccess1",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 6200100301,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 13,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  Type = 62001002,
                  Frame = 1,
                  FrameTime = 14,
                  EventType = 3,

                },
                {

                  EntityId = 62001009001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 14,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  Type = 62001999,
                  Frame = 2,
                  FrameTime = 35,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001103 ] = {
            TotalFrame = 36,
            ForceFrame = 36,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 62001017,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "AssassinSuccess1",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 6200100301,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 13,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  Type = 62001003,
                  Frame = 1,
                  FrameTime = 14,
                  EventType = 3,

                },
                {

                  EntityId = 62001004001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 14,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  Type = 62001999,
                  Frame = 2,
                  FrameTime = 35,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001105 ] = {
            TotalFrame = 15,
            ForceFrame = 15,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "AssassinFinishFall",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 15 ] = {
                {

                  Type = 62001999,
                  Frame = 1,
                  FrameTime = 15,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001106 ] = {
            TotalFrame = 10,
            ForceFrame = 10,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "AssassinFinishEnd",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  Type = 62001006,
                  Frame = 1,
                  FrameTime = 10,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001107 ] = {
            TotalFrame = 10,
            ForceFrame = 10,
            SkillBreakSkillFrame = 10,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 3 ] = {
                {

                  Name = "FallAssasinLoop",
                  StartFrame = 0,
                  FrameTime = 3,
                  EventType = 2,

                },
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 7,
                  OffsetType = 2,
                  TargetHPositionOffset = -0.3,
                  TargetVPositionOffset = -0.2,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 7,
                  VDurationMoveFrame = 7,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 3,
                  EventType = 18,

                }
              },
              [ 4 ] = {
                {

                  MagicId = 1000053,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 10,

                }
              },
              [ 10 ] = {
                {

                  Type = 62001007,
                  Frame = 1,
                  FrameTime = 10,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001109 ] = {
            TotalFrame = 13,
            ForceFrame = 13,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Assassin_Touch",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 43.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 1,
                  EventType = 12,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 4,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 4,
                  FrameTime = 4,
                  EventType = 8,

                }
              },
              [ 5 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = -0.3,
                  TargetVPositionOffset = -0.2,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = 3,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 5,
                  EventType = 18,

                }
              },
              [ 8 ] = {
                {

                  Type = 62001009,
                  Frame = 1,
                  FrameTime = 8,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001110 ] = {
            TotalFrame = 35,
            ForceFrame = 35,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 62001014,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "AssassinFail",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 31 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = true,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 0.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 31,
                  EventType = 12,

                }
              },
              [ 34 ] = {
                {

                  Type = 62001999,
                  Frame = 2,
                  FrameTime = 34,
                  EventType = 3,

                }
              },
              [ 999 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 24.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 999,
                  EventType = 12,

                }
              },
            }
          },
          [ 62001111 ] = {
            TotalFrame = 44,
            ForceFrame = 44,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Assassin_Start",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 62001012,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 1,
                  EventType = 10,

                }
              },
              [ 22 ] = {
                {

                  BoneName = "AssassinCase",
                  DurationUpdateTargetFrame = 4,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = 4,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 22,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  MagicId = 62001015,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 22,
                  EventType = 10,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 24 ] = {
                {

                  Type = 62001101,
                  Frame = 1,
                  FrameTime = 24,
                  EventType = 3,

                }
              },
              [ 25 ] = {
                {

                  MagicId = 62001016,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 25,
                  EventType = 10,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 31 ] = {
                {

                  Type = 62001001,
                  Frame = 1,
                  FrameTime = 31,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001997 ] = {
            TotalFrame = 0,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  XZEnable = true,
                  YEnable = false,
                  FrameTime = 0,
                  EventType = 22,

                },
                {

                  Name = "Attack016",
                  StartFrame = 172,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 7 ] = {
                {

                  PostProcessType = 1,
                  PostProcessParams = {
                    SplitDirection = 0,
                    Amount = 0.25,
                    Speed = 0.0,
                    Fading = 1.0,
                    FadingCurveId = 100000024,
                    CenterFading = 1.0,
                    AmountR = -1.0,
                    AmountB = 1.0,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 1,
                    Duration = 4,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 7,
                  EventType = 16,

                }
              },
              [ 8 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 0.7,
                    Alpha = 1.0,
                    AlphaCurveId = 100000022,
                    Direction = 0,
                    Count = 20,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 8,
                  EventType = 16,

                }
              },
              [ 9 ] = {
                {

                  XZEnable = true,
                  YEnable = true,
                  FrameTime = 9,
                  EventType = 22,

                }
              },
              [ 11 ] = {
                {

                  Name = "AssassinRushStart",
                  StartFrame = 0,
                  FrameTime = 11,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  Type = 62001997,
                  Frame = 1,
                  FrameTime = 13,
                  EventType = 3,

                },
                {

                  Name = "Attack016",
                  StartFrame = 199,
                  FrameTime = 13,
                  EventType = 2,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  AddType = 1,
                  BuffId = 1000062,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 13,
                  EventType = 9,

                },
                {

                  Name = "AssassinRushing",
                  StartFrame = 1,
                  FrameTime = 13,
                  EventType = 2,

                },
                {                  DurationUpdateTargetFrame = 4,
                  OffsetType = 1,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, -1.5 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 13,
                  EventType = 18,

                }
              },
              [ 14 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 720.0,
                  RotateFrame = 8,
                  FrameTime = 14,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  Type = 62001011,
                  Frame = 1,
                  FrameTime = 18,
                  EventType = 3,

                }
              },
            }
          },
          [ 62001998 ] = {
            TotalFrame = 0,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 57,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1001046,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.05,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 0,
                  EventType = 4,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 1,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
              [ 23 ] = {
                {

                  AddType = 1,
                  BuffId = 1000051,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 23,
                  EventType = 9,

                }
              },
              [ 29 ] = {
                {

                  Type = 10600001,
                  Frame = 1,
                  FrameTime = 29,
                  EventType = 3,

                }
              },
              [ 30 ] = {
                {

                  MagicId = 1000053,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 30,
                  EventType = 10,

                }
              },
              [ 50 ] = {
                {

                  MagicId = 1000048,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 50,
                  EventType = 10,

                }
              },
            }
          },
          [ 62001999 ] = {
            TotalFrame = 197,
            ForceFrame = 135,
            SkillBreakSkillFrame = 135,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 57,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1001046,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.05,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 0,
                  EventType = 4,

                }
              },
              [ 50 ] = {
                {

                  Name = "Attack160",
                  StartFrame = 0,
                  FrameTime = 50,
                  EventType = 2,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 48.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 50,
                  EventType = 12,

                },
                {

                  Type = 10010000,
                  Frame = 24,
                  FrameTime = 50,
                  EventType = 3,

                },
                {

                  Type = 10010001,
                  Frame = 24,
                  FrameTime = 50,
                  EventType = 3,

                }
              },
              [ 51 ] = {
                {

                  AddType = 1,
                  BuffId = 1001998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 51,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 3600.0,
                  Acceleration = 3600.0,
                  RotateFrame = 2,
                  FrameTime = 51,
                  EventType = 8,

                },
                {

                  MagicId = 100199803,
                  LifeBindBuff = true,
                  Count = 0,
                  FrameTime = 51,
                  EventType = 10,

                },
                {

                  AddType = 1,
                  BuffId = 1001045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 51,
                  EventType = 9,

                },
                {

                  PostProcessType = 1,
                  PostProcessParams = {
                    SplitDirection = 0,
                    Amount = 0.25,
                    Speed = 0.0,
                    Fading = 1.0,
                    FadingCurveId = 1001992,
                    CenterFading = 1.0,
                    AmountR = -1.0,
                    AmountB = 1.0,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 1,
                    Duration = 6,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 51,
                  EventType = 16,

                }
              },
              [ 52 ] = {
                {                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = 1.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 52,
                  EventType = 18,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 1001998001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                },
                {

                  MagicId = 100199805,
                  LifeBindBuff = true,
                  Count = 0,
                  FrameTime = 53,
                  EventType = 10,

                }
              },
              [ 54 ] = {
                {

                  AddType = 2,
                  BuffId = 1001998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 54,
                  EventType = 9,

                },
                {

                  EntityId = 100116001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                }
              },
              [ 57 ] = {
                {

                  EntityId = 1001998002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 57,
                  EventType = 1,

                }
              },
              [ 72 ] = {
                {

                  Name = "Attack101",
                  StartFrame = 0,
                  FrameTime = 72,
                  EventType = 2,

                }
              },
              [ 74 ] = {
                {

                  EntityId = 1001101001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 74,
                  EventType = 1,

                }
              },
              [ 75 ] = {
                {

                  EntityId = 100110101,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 75,
                  EventType = 1,

                }
              },
              [ 77 ] = {
                {

                  Name = "Attack102",
                  StartFrame = 0,
                  FrameTime = 77,
                  EventType = 2,

                }
              },
              [ 81 ] = {
                {

                  EntityId = 1001102001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 81,
                  EventType = 1,

                }
              },
              [ 82 ] = {
                {

                  EntityId = 100110201,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 82,
                  EventType = 1,

                }
              },
              [ 85 ] = {
                {

                  Name = "Attack103",
                  StartFrame = 0,
                  FrameTime = 85,
                  EventType = 2,

                }
              },
              [ 86 ] = {
                {

                  AddType = 1,
                  BuffId = 1001999,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 86,
                  EventType = 9,

                }
              },
              [ 88 ] = {
                {

                  EntityId = 1001998005,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 88,
                  EventType = 1,

                }
              },
              [ 89 ] = {
                {

                  EntityId = 100110301,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 89,
                  EventType = 1,

                }
              },
              [ 90 ] = {
                {

                  MagicId = 100199804,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 90,
                  EventType = 10,

                }
              },
              [ 105 ] = {
                {

                  EntityId = 100108101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 105,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1001045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 105,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 3600.0,
                  Acceleration = 0.0,
                  RotateFrame = 3,
                  FrameTime = 105,
                  EventType = 8,

                },
                {

                  Name = "Attack081",
                  StartFrame = 0,
                  FrameTime = 105,
                  EventType = 2,

                }
              },
              [ 106 ] = {
                {

                  AddType = 1,
                  BuffId = 1001999,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 106,
                  EventType = 9,

                }
              },
              [ 108 ] = {
                {                  DurationUpdateTargetFrame = 1,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.5,
                  TargetVPositionOffset = -0.5,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 108,
                  EventType = 18,

                }
              },
              [ 109 ] = {
                {

                  EntityId = 1001081001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 109,
                  EventType = 1,

                }
              },
              [ 116 ] = {
                {

                  AddType = 2,
                  BuffId = 1001045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 116,
                  EventType = 9,

                }
              },
              [ 117 ] = {
                {

                  AddType = 1,
                  BuffId = 1001081,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 117,
                  EventType = 9,

                },
                {

                  Name = "Attack082",
                  StartFrame = 2,
                  FrameTime = 117,
                  EventType = 2,

                }
              },
            }
          }
        }
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/BeilubeiteMb1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      Animator = {
        Animator = "Character/Monster/Beilubeite/BeilubeiteMb1/BeilubeiteMb1P.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              AssassinRushing = 0.0
            }
          }
        }
      },
      Behavior = {
        Behaviors = {
          "62001"
        },
      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 1,
        NpcTag = 5,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Move = {
        pivot = 1.27,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 1,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "BeilubeiteMb1P",
        LogicMoveConfigs = {
          Attack010 = 6,
          Attack001 = 6,
          Attack002 = 6,
          Attack003 = 6,
          Attack004 = 6,
          Attack006 = 6,
          Attack007 = 6,
          Attack008 = 6,
          Attack014 = 6,
          Attack009 = 6,
          Attack013 = 6,
          Attack016 = 6,
          Attack017 = 6,
          Attack015 = 6,
          Attack005 = 6,
          Attack904 = 6,
          Attack906 = 6,
          AssassinFail = 2,
          AssassinFinishEnd = 2,
          AssassinFinishFall = 2,
          AssassinRushing = 2,
          AssassinRushStart = 2,
          AssassinSuccess = 6,
          Assassin_Start = 6,
          Assassin_Touch = 2,
          Assassin_Success = 2,
          AssassinSuccess1 = 2,
          GlideAssasinLoop = 2,
          AssassinSuccess2 = 2,
          Assassin_Start2 = 2,
          ShowPartner = 2
        },        BindRotation = false,

      },
      Rotate = {
        Speed = 60
      },
      State = {
        DyingTime = 3.0,
        DeathTime = 1.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 3.733,

      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 1.2,
        Priority = 8,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Body",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Bip001",
                LocalPosition = { 0.0, 0.0, -0.32 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.8893, 1.8865, 1.8454951 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          },
          {
            Name = "Head",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 102.55999 },
                LocalScale = { 0.74586004, 0.37293002, 0.74586004 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Attributes = {
        DefaultAttrID = 62001,
      },
      ElementState = {
        ElementType = 2,
        ElementMaxAccumulateDict = {
          Gold = 100
        }
      },
      Part = {
        PartList = {
          {
            Name = "Body",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HitCase",
            attackTransformName = "HitCase",
            hitTransformName = "HitCase",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Bip001",
                LocalPosition = { 0.0, 0.0, -0.4005 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.8893, 1.8865, 1.8454951 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          },
          {
            Name = "Head",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 14000.0
            },
            PartType = 0,
            PartWeakType = 0,
            WeakTrasnforms = {
              "BeilubeiteMb1_face",
              "BeilubeiteMb1_hair"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 102.55999 },
                LocalScale = { 0.74586004, 0.37293002, 0.74586004 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          }
        },

      },
      SkillSet = {
        UISets = {
          [ 1 ] = {
            ShowId = 1,
            UISetNote = "",
            BindRes1 = 0,
            BindRes2 = 0,
            CoreUIConfig = {
              BindRes = 0,
              Scale = 1.0,
              LocationOffset = { 0.0, 0.0, 0.0 },
              ScreenOffset = { 0.0, 0.0, 0.0 }
            },            J = {
              Active = false,
              SkillId = 0,

            },
            K = {
              Active = false,
              SkillId = 0,

            },
            L = {
              Active = false,
              SkillId = 0,

            },
            I = {
              Active = false,
              SkillId = 0,

            },
            O = {
              Active = false,
              SkillId = 0,

            },
            R = {
              Active = true,
              SkillId = 62001001,

            },
            F = {
              Active = false,
              SkillId = 0,

            },
            SkillUpdateList = {
              62001008,
              62001007,
              62001017,
              62001013
            },
          }
        }
      },
      CommonBehavior = {
        CommonBehaviors = {
          Partner = {
            ComponentBehaviorName = "CommonPartnerBehavior",
            CommonBehaviorParms = {
              [ "进场时间" ] = 0.0,
              [ "退场时间" ] = 0.0,
              [ "退场动作开始帧数" ] = 0.0,
              [ "退场结束时间" ] = 1.5
            }
          }
        }
      }
    }
  },
  [ 6200101001 ] = {
    EntityId = 6200101001,
    EntityName = "6200101001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk010Canying.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 46,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101002 ] = {
    EntityId = 6200101002,
    EntityName = "6200101002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk010H01.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001004001 ] = {
    EntityId = 62001004001,
    EntityName = "62001004001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 8,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelfBeforeHit = {
          1000061,
          62001019
        },
        MagicsByTargetBeforeHit = {
          620010102,
          1000049,
          1000068
        },
        CreateHitEntities = {
          {
            EntityId = 6200100203,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 1.5,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 30.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = -75.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.5,
            StartFrequency = 10.0,
            TargetAmplitude = 0.25,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.4,
            FrequencyChangeTime = 0.4,
            DurationTime = 0.4,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
        PostProcessParamsList = {
          {

            ColorStyleAlpha = 1.0,
            GrayCenter = 0.2,
            GrayOffset = 0.1,
            GrayOffsetCurveId = 6200100103,
            BlackAreaColor = { 0.0, 0.0, 0.0, 1.0 },
            WhiteAreaColor = { 1.0, 1.0, 1.0, 1.0 },
            ColorInvert = false,
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 0,
            Duration = 7,
            ID = 30
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "BeilubeiteMb1",
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001009001 ] = {
    EntityId = 62001009001,
    EntityName = "62001009001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 8,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelfBeforeHit = {
          1000061,
          62001019
        },
        MagicsByTargetBeforeHit = {
          620010102,
          1000050,
          1000068
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 1.5,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 30.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = -75.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 0.5,
            AmplitudeChangeTime = 0.1,
            FrequencyChangeTime = 0.1,
            DurationTime = 0.1,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
        PostProcessParamsList = {
          {

            ColorStyleAlpha = 1.0,
            GrayCenter = 0.2,
            GrayOffset = 0.1,
            GrayOffsetCurveId = 6200100103,
            BlackAreaColor = { 0.0, 0.0, 0.0, 1.0 },
            WhiteAreaColor = { 1.0, 1.0, 1.0, 1.0 },
            ColorInvert = false,
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 0,
            Duration = 5,
            ID = 30
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001010004 ] = {
    EntityId = 62001010004,
    EntityName = "62001010004",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk010daoguang1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200199902 ] = {
    EntityId = 6200199902,
    EntityName = "6200199902",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxyinshenStart.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 61,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001008004 ] = {
    EntityId = 62001008004,
    EntityName = "62001008004",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk008H.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001008002 ] = {
    EntityId = 62001008002,
    EntityName = "62001008002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 7,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.8,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 3,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 92001008001,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001008001 ] = {
    EntityId = 62001008001,
    EntityName = "62001008001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 8,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.2,
        Height = 4.0,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelf = {
          62001003
        },
        MagicsByTargetBeforeHit = {
          620010102
        },
        MagicsByTarget = {
          62001004,
          620010101,
          1008002
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 30.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = -75.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.5,
            StartFrequency = 10.0,
            TargetAmplitude = 0.25,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.4,
            FrequencyChangeTime = 0.4,
            DurationTime = 0.4,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            ColorStyleAlpha = 1.0,
            GrayCenter = 0.2,
            GrayOffset = 0.1,
            GrayOffsetCurveId = 6200100103,
            BlackAreaColor = { 0.0, 0.0, 0.0, 1.0 },
            WhiteAreaColor = { 1.0, 1.0, 1.0, 1.0 },
            ColorInvert = false,
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 0,
            Duration = 5,
            ID = 30
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "BeilubeiteMb1",
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100803 ] = {
    EntityId = 6200100803,
    EntityName = "6200100803",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk008Dilie.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 91,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100802 ] = {
    EntityId = 6200100802,
    EntityName = "6200100802",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bone122",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk008tuowei.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 20,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100801 ] = {
    EntityId = 6200100801,
    EntityName = "6200100801",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk008Dilie01.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 91,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001001001 ] = {
    EntityId = 62001001001,
    EntityName = "62001001001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 8,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.2,
        Height = 4.0,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelf = {
          62001003
        },
        MagicsByTarget = {
          620010101
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 30.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = -75.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.5,
            StartFrequency = 10.0,
            TargetAmplitude = 0.25,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.4,
            FrequencyChangeTime = 0.4,
            DurationTime = 0.4,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            ColorStyleAlpha = 1.0,
            GrayCenter = 0.2,
            GrayOffset = 0.1,
            GrayOffsetCurveId = 6200100103,
            BlackAreaColor = { 0.0, 0.0, 0.0, 1.0 },
            WhiteAreaColor = { 1.0, 1.0, 1.0, 1.0 },
            ColorInvert = false,
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 0,
            Duration = 7,
            ID = 30
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "BeilubeiteMb1",
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100201 ] = {
    EntityId = 6200100201,
    EntityName = "6200100201",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinSuccessDG1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 28,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100202 ] = {
    EntityId = 6200100202,
    EntityName = "6200100202",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 Neck",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinSuccessH1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "Bip001 Neck",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100301 ] = {
    EntityId = 6200100301,
    EntityName = "6200100301",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinSuccessDG1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 28,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100203 ] = {
    EntityId = 6200100203,
    EntityName = "6200100203",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 Neck",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinH1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "Bip001 Neck",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101711 ] = {
    EntityId = 6200101711,
    EntityName = "6200101711",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, -0.8, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017Daoguang1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 91,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101712 ] = {
    EntityId = 6200101712,
    EntityName = "6200101712",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, -0.6, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017Daoguang2.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 91,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101713 ] = {
    EntityId = 6200101713,
    EntityName = "6200101713",
    Components = {
      Effect = {
        IsBind = true,
        BindOffset = { 0.0, -1.85, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017Daoguang3.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101714 ] = {
    EntityId = 6200101714,
    EntityName = "6200101714",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bone122",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017tuowei.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 154,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101715 ] = {
    EntityId = 6200101715,
    EntityName = "6200101715",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017Dilie.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 91,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101716 ] = {
    EntityId = 6200101716,
    EntityName = "6200101716",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017H.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101717 ] = {
    EntityId = 6200101717,
    EntityName = "6200101717",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017H01.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200101718 ] = {
    EntityId = 6200101718,
    EntityName = "6200101718",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/BeilubeiteFxAtk017H02.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001017011 ] = {
    EntityId = 62001017011,
    EntityName = "62001017011",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 8,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 6,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 5.5,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.2,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          62001024,
          1017011
        },
        MagicsByTarget = {
          1017001,
          1017004,
          1017007
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.25,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.6,
            StartFrequency = 10.0,
            TargetAmplitude = 0.35,
            TargetFrequency = 5.0,
            AmplitudeChangeTime = 0.3,
            FrequencyChangeTime = 0.3,
            DurationTime = 0.3,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001017012 ] = {
    EntityId = 62001017012,
    EntityName = "62001017012",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 4.0,
        Width = 7.5,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 2.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          62001024,
          1017012
        },
        MagicsByTarget = {
          1017002,
          1017005,
          1017008
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.35,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.5,
            StartFrequency = 10.0,
            TargetAmplitude = 0.35,
            TargetFrequency = 5.0,
            AmplitudeChangeTime = 0.3,
            FrequencyChangeTime = 0.3,
            DurationTime = 0.3,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 62001017013 ] = {
    EntityId = 62001017013,
    EntityName = "62001017013",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 7.0,
        Width = 17.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelf = {
          62001003,
          1017013
        },
        MagicsByTarget = {
          1017003,
          1017006,
          62001004
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 8.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.4,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100401 ] = {
    EntityId = 6200100401,
    EntityName = "6200100401",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinJump.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 24,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6200100402 ] = {
    EntityId = 6200100402,
    EntityName = "6200100402",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/Effect/FxAssassinJump1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 24,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
