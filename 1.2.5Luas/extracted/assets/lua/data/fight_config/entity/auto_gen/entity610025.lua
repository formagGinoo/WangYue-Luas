Config = Config or {}
Config.Entity610025 = Config.Entity610025 or { }
local empty = { }
Config.Entity610025 = 
{
  [ 610025 ] = {
    EntityId = 610025,
    EntityName = "610025",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMe2/ShilongMe2.prefab",
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
        Animator = "Character/Monster/Shilong/ShilongMe2/ShilongMe2.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              Stun = 0.25
            }
          }
        }
      },
      Attributes = {
        DefaultAttrID = 610025,
        AttributeEventList = {
          {
            AttrType = 1007,
            RecoverEvent = {
              Time = 1.0,
              RecoverAttrType = 1007,
              RecoverAttrValue = 500,
              StopDmgCondition = {
                Time = 10.0
              }
            },
            EmptyEvent = {
              Time = 10.0,
              SelfMagicList = {
                900000003,
                900000004
              },
              PlayerMagicList = {
                900000005
              },
              EndMagicList = {
                900000006
              },
            }
          }
        },
      },
      Behavior = {
        Behaviors = {
          "610025"
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
      Rotate = {
        Speed = 60
      },
      State = {
        DyingTime = 2.83,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 1.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.2,
            ForceTime = 0.66,
            FusionChangeTime = 0.66,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.2,
            ForceTime = 0.66,
            FusionChangeTime = 0.66,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 0.9,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 0.9,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 73 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 75 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.7,
            ForceTime = 0.7,
            FusionChangeTime = 0.7,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 2.0,
            ForceTime = 1.73,
            FusionChangeTime = 1.73,
            IgnoreHitTime = 1.73
          }
        },
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Body",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Bip001",
                LocalPosition = { -0.57, 0.0, -0.07 },
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
        Height = 2.0,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
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
      Hit = {
        GravityAcceleration = -0.2,
        ReboundCoefficient = 0.3,
        ReboundTimes = 1.0,
        MinSpeed = 5.0,
        SpeedZCoefficient = 0.0,

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Skill = {
        Skills = {
          [ 610025001 ] = {
            TotalFrame = 78,
            ForceFrame = 78,
            SkillBreakSkillFrame = 78,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 6000009,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack053",
                  StartFrame = 70,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 40 ] = {
                {

                  Type = 6000010,
                  Frame = 1,
                  FrameTime = 40,
                  EventType = 3,

                }
              },
            }
          },
          [ 610025002 ] = {
            TotalFrame = 90,
            ForceFrame = 90,
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
                SkillIcon = "PartnerUpAtk",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 250.0,
                  Acceleration = 0.0,
                  RotateFrame = 30,
                  FrameTime = 0,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      610025002
                    },
                  }
                }
              },
              [ 34 ] = {
                {                  DurationUpdateTargetFrame = 6,
                  OffsetType = 2,
                  TargetHPositionOffset = 1.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 34,
                  EventType = 18,

                }
              },
              [ 35 ] = {
                {

                  EntityId = 90002000202,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 35,
                  EventType = 1,

                }
              },
              [ 38 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 250.0,
                  Acceleration = 0.0,
                  RotateFrame = 22,
                  FrameTime = 38,
                  EventType = 8,

                }
              },
              [ 41 ] = {
                {

                  EntityId = 610025002001,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 41,
                  EventType = 1,

                },
                {

                  EntityId = 90002000201,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 41,
                  EventType = 1,

                }
              },
              [ 60 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 60,
                  EventType = 9,

                }
              },
              [ 68 ] = {
                {

                  Type = 610025002,
                  Frame = 1,
                  FrameTime = 68,
                  EventType = 3,

                }
              },
              [ 73 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 300.0,
                  Acceleration = 0.0,
                  RotateFrame = 17,
                  FrameTime = 73,
                  EventType = 8,

                }
              },
            }
          },
          [ 610025003 ] = {
            TotalFrame = 40,
            ForceFrame = 40,
            SkillBreakSkillFrame = 40,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 5.0,
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
                SkillIcon = "PartnerHideAtk",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  EntityId = 61002500301,
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
                  FrameTime = 0,
                  EventType = 1,

                },
                {

                  Name = "Attack056",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 6 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 10.0,
                  Acceleration = -2.0,
                  MoveFrame = 12,
                  InputSpeed = 6.0,
                  MinDistance = -100.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 4,
                  FrameTime = 6,
                  EventType = 7,

                }
              },
              [ 30 ] = {
                {

                  RotateType = 3,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 52,
                  FrameTime = 30,
                  EventType = 8,

                },
                {

                  Direction = 2,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  MoveFrame = 7,
                  InputSpeed = 6.0,
                  MinDistance = 0.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 4,
                  FrameTime = 30,
                  EventType = 7,

                }
              },
              [ 40 ] = {
                {

                  Type = 610025099,
                  Frame = 1,
                  FrameTime = 40,
                  EventType = 3,

                }
              },
            }
          },
          [ 610025005 ] = {
            TotalFrame = 42,
            ForceFrame = 42,
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
                SkillIcon = "PartnerHideDown",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 610025777,
                  Frame = 1,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  Name = "Attack055",
                  StartFrame = 6,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 12 ] = {
                {

                  AddType = 1,
                  BuffId = 610025013,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 12,
                  EventType = 9,

                }
              },
              [ 13 ] = {
                {

                  Direction = 2,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  MoveFrame = 52,
                  InputSpeed = 6.0,
                  MinDistance = -100.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 4,
                  FrameTime = 13,
                  EventType = 7,

                },
                {

                  RotateType = 3,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 52,
                  FrameTime = 13,
                  EventType = 8,

                }
              },
              [ 14 ] = {
                {

                  Type = 610025010,
                  Frame = 999999,
                  FrameTime = 14,
                  EventType = 3,

                },
                {

                  Type = 610025011,
                  Frame = 1,
                  FrameTime = 14,
                  EventType = 3,

                }
              },
              [ 28 ] = {
                {

                  AddType = 1,
                  BuffId = 610025012,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 28,
                  EventType = 9,

                }
              },
              [ 42 ] = {
                {

                  Type = 610025099,
                  Frame = 1,
                  FrameTime = 42,
                  EventType = 3,

                }
              },
            }
          },
          [ 610025011 ] = {
            TotalFrame = 84,
            ForceFrame = 84,
            SkillBreakSkillFrame = 82,
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
                SkillIcon = "PartnerHideDown",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  XZEnable = false,
                  YEnable = true,
                  FrameTime = 0,
                  EventType = 22,

                },
                {

                  PostProcessType = -1,
                  PostProcessParams = {
                    EnterTime = 15,
                    ExitTime = 15,
                    ColorFilter = { 0.160377383, 0.160377383, 0.160377383, 1.0 },
                    StencilRef = 4.0,
                    ReadMask = 255.0,
                    WriteMask = 255.0,
                    StencilCompare = 5,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = -1,
                    Duration = 9999,
                    ID = 30
                  },
                  LifeBindSkill = true,
                  FrameTime = 0,
                  EventType = 16,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  Name = "Attack051",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 32 ] = {
                {

                  Direction = 2,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  MoveFrame = 52,
                  InputSpeed = 6.0,
                  MinDistance = 0.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 4,
                  FrameTime = 32,
                  EventType = 7,

                },
                {

                  RotateType = 3,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 52,
                  FrameTime = 32,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 610025012,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 32,
                  EventType = 9,

                },
                {

                  Type = 610025010,
                  Frame = 999999,
                  FrameTime = 32,
                  EventType = 3,

                }
              },
              [ 39 ] = {
                {

                  Type = 610025011,
                  Frame = 1,
                  FrameTime = 39,
                  EventType = 3,

                }
              },
              [ 60 ] = {
                {

                  AddType = 1,
                  BuffId = 610025013,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 60,
                  EventType = 9,

                }
              },
              [ 75 ] = {
                {

                  XZEnable = true,
                  YEnable = true,
                  FrameTime = 75,
                  EventType = 22,

                }
              },
              [ 82 ] = {
                {

                  Type = 610025099,
                  Frame = 1,
                  FrameTime = 82,
                  EventType = 3,

                }
              },
            }
          },
          [ 610025012 ] = {
            TotalFrame = 148,
            ForceFrame = 148,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 0.0,
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
                SkillIcon = "PartnerHideAtk",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack053",
                  StartFrame = 5,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  XZEnable = false,
                  YEnable = true,
                  FrameTime = 0,
                  EventType = 22,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 91002501204,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 1,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = 0,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 13,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      610025999
                    },
                  }
                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 150.0,
                  Acceleration = 0.0,
                  RotateFrame = 26,
                  FrameTime = 13,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      610025999
                    },
                  }
                }
              },
              [ 14 ] = {
                {

                  Name = "Attack053",
                  StartFrame = 23,
                  FrameTime = 14,
                  EventType = 2,

                }
              },
              [ 15 ] = {
                {

                  XZEnable = true,
                  YEnable = true,
                  FrameTime = 15,
                  EventType = 22,

                }
              },
              [ 16 ] = {
                {

                  Type = 610025013,
                  Frame = 1,
                  FrameTime = 16,
                  EventType = 3,

                },
                {

                  AddType = 2,
                  BuffId = 900000007,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 16,
                  EventType = 9,

                },
                {

                  EntityId = 610025012001,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                },
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 16,
                  EventType = 9,

                }
              },
              [ 25 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 200.0,
                  Acceleration = 0.0,
                  RotateFrame = 28,
                  FrameTime = 25,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      610025999
                    },
                  }
                }
              },
              [ 54 ] = {
                {

                  Type = 610025012,
                  Frame = 1,
                  FrameTime = 54,
                  EventType = 3,

                }
              },
              [ 97 ] = {
                {

                  AddType = 2,
                  BuffId = 900000013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 97,
                  EventType = 9,

                }
              },
              [ 105 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 120.0,
                  Acceleration = 0.0,
                  RotateFrame = 10,
                  FrameTime = 105,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      610025999
                    },
                  }
                }
              },
            }
          },
          [ 610025013 ] = {
            TotalFrame = 999999,
            ForceFrame = 999999,
            SkillBreakSkillFrame = 999999,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 610025010,
                  Frame = 999999,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  Direction = 2,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  MoveFrame = 999999,
                  InputSpeed = 6.0,
                  MinDistance = -100.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 0,
                  EventType = 7,

                },
                {

                  RotateType = 3,
                  UseSelfSpeed = 0,
                  SpeedOffset = 5000.0,
                  Acceleration = 0.0,
                  RotateFrame = 999999,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  Name = "Attack052",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 610025014 ] = {
            TotalFrame = 50,
            ForceFrame = 50,
            SkillBreakSkillFrame = 50,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 0.0,
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
                SkillIcon = "PartnerSmashing",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 610025777,
                  Frame = 1,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack054",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 61002501401,
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
              [ 16 ] = {
                {

                  AddType = 2,
                  BuffId = 900000007,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 16,
                  EventType = 9,

                }
              },
              [ 23 ] = {
                {

                  Type = 610025013,
                  Frame = 1,
                  FrameTime = 23,
                  EventType = 3,

                },
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 23,
                  EventType = 9,

                }
              },
              [ 37 ] = {
                {

                  Type = 610025012,
                  Frame = 1,
                  FrameTime = 37,
                  EventType = 3,

                }
              },
            }
          }
        }
      },
      ElementState = {
        ElementType = 1,

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
              Active = true,
              SkillId = 610025003,

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
              SkillId = 610025005,

            },
            F = {
              Active = false,
              SkillId = 0,

            },
            SkillUpdateList = {
              610025012,
              610025002,
              610025014
            },
          }
        }
      },
      HandleMoveInput = empty,
      Move = {
        pivot = 0.65156,
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
        ConfigName = "ShilongMe2",
        LogicMoveConfigs = {
          Attack051 = 2,
          Attack052 = 2,
          Attack053 = 2,
          Attack055 = 2,
          Attack054 = 2,
          Attack056 = 2
        },        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

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
  [ 610025012001 ] = {
    EntityId = 610025012001,
    EntityName = "610025012001",
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
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 1,
        Radius = 1.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 10000.0,
        Height = 10000.0,
        Width = 10000.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
          610025005
        },
        MagicsByTarget = {
          900000002,
          900000019,
          610025006
        },
        CreateHitEntities = {
          {
            EntityId = 61002500203,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
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
          SpeedY = 15.0,
          SpeedZHitFly = 2.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.8,
            StartFrequency = 20.0,
            TargetAmplitude = 0.5,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
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
  [ 61002501201 ] = {
    EntityId = 61002501201,
    EntityName = "61002501201",
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
        Prefab = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk052.prefab",
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
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 610025002001 ] = {
    EntityId = 610025002001,
    EntityName = "610025002001",
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
      Time = {
        DefalutTimeScale = 1.0
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
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.5,
        Height = 2.0,
        Width = 1.5,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 0.75,
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
          610025005
        },
        MagicsByTargetBeforeHit = {
          610025002,
          900000002,
          610025001
        },
        MagicsByTarget = {
          610025006
        },
        CreateHitEntities = {
          {
            EntityId = 61002500203,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
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
            StartAmplitude = 0.35,
            StartFrequency = 20.0,
            TargetAmplitude = 0.5,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
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
        BindChild = "Bip001",

      }
    }
  },
  [ 61002500202 ] = {
    EntityId = 61002500202,
    EntityName = "61002500202",
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
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk002_H.prefab",
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
  [ 61002500203 ] = {
    EntityId = 61002500203,
    EntityName = "61002500203",
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
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk002_H.prefab",
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
        Frame = 169,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 61002500102 ] = {
    EntityId = 61002500102,
    EntityName = "61002500102",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk001H.prefab",
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
        Frame = 37,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 61002502201 ] = {
    EntityId = 61002502201,
    EntityName = "61002502201",
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
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxDive002.prefab",
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
        Frame = 103,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 61002501401 ] = {
    EntityId = 61002501401,
    EntityName = "61002501401",
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
        Prefab = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk054.prefab",
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
        Frame = 65,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 61002500501 ] = {
    EntityId = 61002500501,
    EntityName = "61002500501",
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
        Prefab = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk055.prefab",
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
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 61002500301 ] = {
    EntityId = 61002500301,
    EntityName = "61002500301",
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
        Prefab = "Character/Monster/Shilong/ShilongMe2/Common/Effect/FxShilongMe2Atk056.prefab",
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
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
