Config = Config or {}
Config.Entity900042 = Config.Entity900042 or { }
local empty = { }
Config.Entity900042 = 
{
  [ 900042 ] = {
    EntityId = 900042,
    EntityName = "900042",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo3/CongshiMo3.prefab",
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
        Animator = "Character/Monster/Congshi/CongshiMo3/CongshiMo3.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              RightSlightHit = 0.0,
              LeftSlightHit = 0.0,
              LeftHeavyHit = 0.0,
              RightHeavyHit = 0.0,
              HitDown = 0.0,
              Stun = 0.297
            }
          }
        }
      },
      Behavior = {
        Behaviors = {
          "900042"
        },
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 1,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Move = {
        pivot = 0.84204,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        GlideBindNode = "",
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
        ConfigName = "CongshiMo3",
        LogicMoveConfigs = {
          Attack004 = 2,
          Attack005 = 2,
          Attack006 = 2,
          Attack007 = 2,
          Attack001Tandao = 2,
          Attack003Tandao = 2
        },        BindRotation = false,

      },
      State = {
        DyingTime = 1.5,
        DeathTime = 1.5,
        ReviveTime = 0.0,
        BornTime = 2.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 0.93,
            ForceTime = 0.93,
            FusionChangeTime = 0.4,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 0.93,
            ForceTime = 0.93,
            FusionChangeTime = 0.4,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.3,
            ForceTime = 1.3,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.3,
            ForceTime = 1.3,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.5,
            ForceTime = 1.5,
            FusionChangeTime = 1.5,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.333,
            ForceTime = 0.333,
            FusionChangeTime = 0.333,
            IgnoreHitTime = 0.0
          },
          [ 73 ] = {
            Time = 0.333,
            ForceTime = 0.333,
            FusionChangeTime = 0.333,
            IgnoreHitTime = 0.0
          },
          [ 75 ] = {
            Time = 0.467,
            ForceTime = 0.467,
            FusionChangeTime = 0.467,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.7,
            ForceTime = 0.7,
            FusionChangeTime = 0.7,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 0.0,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 1.9,
            ForceTime = 1.9,
            FusionChangeTime = 0.7,
            IgnoreHitTime = 0.0
          }
        },
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 1.0,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "body",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { -0.05473239, 0.0017447772, -0.41943863 },
                LocalEuler = { 0.0, 270.0, 270.0 },
                LocalScale = { 1.0, 0.7, 1.0 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          },
          {
            Name = "head",
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, -0.16, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.8, 0.8, 0.8 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 1.56,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      },
      Part = {
        PartList = {
          {
            Name = "body",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 10000.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "",
            attackTransformName = "",
            hitTransformName = "",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { -0.05473239, 0.0017447772, -0.41943863 },
                LocalEuler = { 0.0, 270.0, 270.0 },
                LocalScale = { 1.0, 0.7, 1.0 }
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
            Name = "head",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 10000.0
            },
            PartType = 1,
            PartWeakType = 1,
            WeakTrasnforms = {
              "CongshiMo3_mask",
              "CongshiMo3_hair"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, -0.16, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.8, 0.8, 0.8 }
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
      Skill = {
        Skills = {
          [ 90004201 ] = {
            TotalFrame = 72,
            ForceFrame = 71,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack001",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9000420101,
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
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 13,
                  EventType = 3,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 900000107,
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
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 90004201002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 1.1,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 24,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 0.0,
                  RotateFrame = 15,
                  FrameTime = 25,
                  EventType = 8,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 9000420102,
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
                  FrameTime = 33,
                  EventType = 1,

                },
                {

                  EntityId = 90004201001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.3,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 1.1,
                  TerriaOffsetY = 0.0,
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
            }
          },
          [ 90004202 ] = {
            TotalFrame = 93,
            ForceFrame = 92,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9000420201,
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
                  FrameTime = 4,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  RotateFrame = 33,
                  FrameTime = 4,
                  EventType = 8,

                }
              },
              [ 8 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 8,
                  EventType = 3,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 900000107,
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
                  FrameTime = 14,
                  EventType = 1,

                }
              },
              [ 20 ] = {
                {

                  EntityId = 90004202002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.83,
                  BornOffsetZ = 0.92,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 20,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 9000420202,
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
                  FrameTime = 25,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  EntityId = 90004202001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.83,
                  BornOffsetZ = 0.92,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 28,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004203 ] = {
            TotalFrame = 69,
            ForceFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack003",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 11 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 11,
                  EventType = 3,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 900000107,
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
                  FrameTime = 17,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 0.0,
                  RotateFrame = 16,
                  FrameTime = 22,
                  EventType = 8,

                }
              },
              [ 23 ] = {
                {

                  EntityId = 90004203002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.187,
                  BornOffsetY = 1.119,
                  BornOffsetZ = 1.1,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 23,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 9000420303,
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
                  FrameTime = 30,
                  EventType = 1,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 90004203001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.187,
                  BornOffsetY = 1.119,
                  BornOffsetZ = 1.1,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 31,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004204 ] = {
            TotalFrame = 29,
            ForceFrame = 28,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Alert",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 90004205 ] = {
            TotalFrame = 37,
            ForceFrame = 36,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshiMo3_Atk005",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Warning001",
                  StartFrame = 15,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 37,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  EntityId = 9000420501,
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
                  FrameTime = 0,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004206 ] = {
            TotalFrame = 36,
            ForceFrame = 35,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshiMo3_Atk006",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Warning002",
                  StartFrame = 15,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 21,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 9000420601,
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
                  FrameTime = 18,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004207 ] = {
            TotalFrame = 38,
            ForceFrame = 37,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "StandUp002",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 38,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90004208 ] = {
            TotalFrame = 38,
            ForceFrame = 38,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack001Tandao",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  MagicId = 900000001,
                  LifeBindBuff = true,
                  Count = 0,
                  FrameTime = 0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90004209 ] = {
            TotalFrame = 4,
            ForceFrame = 4,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "BeAssassin",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  MagicId = 900000054,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 10,

                }
              },
            }
          },
          [ 90004210 ] = {
            TotalFrame = 41,
            ForceFrame = 40,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack003Tandao",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  MagicId = 900000001,
                  LifeBindBuff = true,
                  Count = 0,
                  FrameTime = 0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90004211 ] = {
            TotalFrame = 89,
            ForceFrame = 88,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Palsy",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 90004212 ] = {
            TotalFrame = 94,
            ForceFrame = 93,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "WeaknessClean",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 90004214 ] = {
            TotalFrame = 74,
            ForceFrame = 72,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshiMo3_Atk014",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack004",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 9000420101,
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
                  FrameTime = 9,
                  EventType = 1,

                }
              },
              [ 10 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 20,
                  FrameTime = 10,
                  EventType = 8,

                }
              },
              [ 17 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 17,
                  EventType = 3,

                },
                {

                  EntityId = 900000004,
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
                  FrameTime = 17,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 7,
                  FrameTime = 34,
                  EventType = 8,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 9000420102,
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
                  FrameTime = 37,
                  EventType = 1,

                },
                {

                  EntityId = 90004201001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.3,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 1.1,
                  TerriaOffsetY = 0.0,
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
              [ 45 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 45,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004215 ] = {
            TotalFrame = 105,
            ForceFrame = 103,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 9000420201,
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
                  FrameTime = 0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 30,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 20 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 20,
                  EventType = 3,

                },
                {

                  EntityId = 900000004,
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
                  FrameTime = 20,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 9000420202,
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
                  FrameTime = 37,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 5,
                  FrameTime = 37,
                  EventType = 8,

                }
              },
              [ 40 ] = {
                {

                  EntityId = 90004202001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.83,
                  BornOffsetZ = 1.2,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 40,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 51,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004216 ] = {
            TotalFrame = 70,
            ForceFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshiMo3_Atk016",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack006",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 19,
                  FrameTime = 6,
                  EventType = 8,

                }
              },
              [ 11 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 11,
                  EventType = 3,

                },
                {

                  EntityId = 900000004,
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
                  FrameTime = 11,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 5,
                  FrameTime = 28,
                  EventType = 8,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 9000420303,
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
                  FrameTime = 31,
                  EventType = 1,

                },
                {

                  EntityId = 90004203001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.187,
                  BornOffsetY = 1.119,
                  BornOffsetZ = 1.1,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 31,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 36,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004217 ] = {
            TotalFrame = 108,
            ForceFrame = 106,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshiMo3_Atk017",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack007",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9000420201,
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
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 10 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 30,
                  FrameTime = 10,
                  EventType = 8,

                }
              },
              [ 25 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 25,
                  EventType = 3,

                },
                {

                  EntityId = 900000004,
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
                  FrameTime = 25,
                  EventType = 1,

                }
              },
              [ 42 ] = {
                {

                  EntityId = 9000420202,
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
                  FrameTime = 42,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 5,
                  FrameTime = 42,
                  EventType = 8,

                }
              },
              [ 45 ] = {
                {

                  EntityId = 90004202001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.83,
                  BornOffsetZ = 1.2,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 45,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 51,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004262 ] = {
            TotalFrame = 26,
            ForceFrame = 26,
            SkillBreakSkillFrame = 26,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "BackLeavyHit",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          }
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Attributes = {
        DefaultAttrID = 900042,
      },
      LifeBar = {
        Prefab = "Prefabs/UI/Fight/LifeBar/MonsterLifeBarObj.prefab",
        LifeBarLength = 250.0,
        ShowArmorBar = false,
        TransformName = "Bip001 Head",
        OffsetWorldY = 0.3,
        OffsetX = 0.1,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        canShowInBody = false,
        lockPosition = false,
        headRadius = 0.0,
        ShowType = 2,
        ShowTime = 0.0,
        DetailDistance = 20.0,
        SimpleDistance = 30.0
      },
      Ik = {
        shakeLeftFrontId = 9000401,
        shakeLeftBackId = 9000402,
        shakeRightFrontId = 9000402,
        shakeRightBackId = 9000401,
        shakeDistanceRatio = 1.0,
        Look = {
          IsLookCtrlObject = false
        },
        Looked = {
          lookTransform = "Head",
          weight = 3000
        }
      },
      Death = {
        DeathList = {
          {
            DeathReason = 1,
            DeathTime = 1.6,
            deathCondition = {
              DrownHeight = 1.35,
              CheckPower = false
            }
          },
          {
            DeathReason = 2,
            DeathTime = -1.0,
            deathCondition = {
              TerrainDeathList = {
                {
                  TerrainDeath = 20,
                  TerrainDeathHeight = 1.35,
                  TerrainDeathTime = -1.0,
                  AccelerationY = -0.6
                }
              },
            }
          }
        },
      },
      ElementState = {
        ElementType = 4,
        ElementMaxAccumulateDict = {
          Gold = 150,
          Fire = 150
        }
      },
      FindPath = empty,
      Condition = {
        ConditionParamsList = {
          {
            Interval = 2.0,
            Count = -1,
            ConditionList = {
              {

                Count = 15,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountInterval = 6.0,
                HitDuration = 0.0,
                ConditionType = 2
              }
            },
            MeetConditionEventList = {
              {

                Duration = 2.0,
                MeetConditionEventType = 2
              }
            },
          }
        },
      }
    }
  },
  [ 90004201001 ] = {
    EntityId = 90004201001,
    EntityName = "90004201001",
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
        Frame = 3,
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
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 7,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.7,
        Height = 2.0,
        Width = 1.8,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 0.9,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          900000046
        },
        MagicsByTarget = {
          90004201,
          900000014,
          900000047,
          900000030
        },
        SoundsByTarget = {
          "CongshiMo3_Atk014_Hit"
        },
        WwisePTRC = {
          paramName = "CongshiMo3_Atk014_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 9000420103,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 0.0,
            AmplitudeChangeTime = 0.0,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.0,
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
        GlideBindNode = "",
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
  [ 90004202001 ] = {
    EntityId = 90004202001,
    EntityName = "90004202001",
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
        Frame = 3,
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
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 7,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.8,
        Height = 1.8,
        Width = 1.8,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 0.9,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          900000048
        },
        MagicsByTarget = {
          90004202,
          900000014,
          900000030,
          900000049
        },
        SoundsByTarget = {
          "CongshiMo3_Atk017_Hit"
        },
        WwisePTRC = {
          paramName = "CongshiMo3_Atk017_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 9000420103,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
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
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 0.0,
            AmplitudeChangeTime = 0.0,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.0,
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
        GlideBindNode = "",
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
  [ 90004203001 ] = {
    EntityId = 90004203001,
    EntityName = "90004203001",
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
        Frame = 3,
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
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 10,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.8,
        Height = 1.6,
        Width = 1.6,
        OffsetX = 0.0,
        OffsetY = 0.8,
        OffsetZ = 0.8,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          900000050
        },
        MagicsByTarget = {
          90004203,
          900000014,
          900000051,
          900000030
        },
        SoundsByTarget = {
          "CongshiMo3_Atk016_Hit"
        },
        WwisePTRC = {
          paramName = "CongshiMo3_Atk016_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 9000420302,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
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
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 0.0,
            AmplitudeChangeTime = 0.0,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.0,
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
        GlideBindNode = "",
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
  [ 9000420101 ] = {
    EntityId = 9000420101,
    EntityName = "9000420101",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "WeaponCaseRight",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk001WpCaseRight.prefab",
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
  [ 9000420201 ] = {
    EntityId = 9000420201,
    EntityName = "9000420201",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "WeaponCaseRight",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk002WpCaseRight.prefab",
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
  [ 9000420301 ] = {
    EntityId = 9000420301,
    EntityName = "9000420301",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 L Forearm",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk003Bip001LForearm.prefab",
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
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000420102 ] = {
    EntityId = 9000420102,
    EntityName = "9000420102",
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
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk001.prefab",
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
  [ 9000420202 ] = {
    EntityId = 9000420202,
    EntityName = "9000420202",
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
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk002.prefab",
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
  [ 9000420103 ] = {
    EntityId = 9000420103,
    EntityName = "9000420103",
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
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk001H.prefab",
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
        Frame = 16,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000420302 ] = {
    EntityId = 9000420302,
    EntityName = "9000420302",
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
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk003H.prefab",
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
        Frame = 16,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000420303 ] = {
    EntityId = 9000420303,
    EntityName = "9000420303",
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
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Atk003.prefab",
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
        Frame = 82,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000420501 ] = {
    EntityId = 9000420501,
    EntityName = "9000420501",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 Head",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Warning001.prefab",
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
        Frame = 52,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000420601 ] = {
    EntityId = 9000420601,
    EntityName = "9000420601",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 Head",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo3/Effect/FxCongshiMo3Warning002.prefab",
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
  [ 90004201002 ] = {
    EntityId = 90004201002,
    EntityName = "90004201002",
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
        Camp = 1
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
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 1.5,
        Width = 2.6,
        OffsetX = 0.0,
        OffsetY = 0.8,
        OffsetZ = 1.3,
        Repetition = true,
        IntervalFrame = 1,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 7,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 90004201001,
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
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 0.0,
            AmplitudeChangeTime = 0.0,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.0,
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
        GlideBindNode = "",
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
  [ 90004202002 ] = {
    EntityId = 90004202002,
    EntityName = "90004202002",
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
        Camp = 1
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
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 1.6,
        Width = 2.6,
        OffsetX = 0.0,
        OffsetY = 0.8,
        OffsetZ = 1.3,
        Repetition = true,
        IntervalFrame = 1,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 7,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 90004202001,
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
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 0.0,
            AmplitudeChangeTime = 0.0,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.0,
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
        GlideBindNode = "",
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
  [ 90004203002 ] = {
    EntityId = 90004203002,
    EntityName = "90004203002",
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
        Camp = 1
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
        DurationFrame = 8,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 1.5,
        Width = 2.6,
        OffsetX = 0.0,
        OffsetY = 0.8,
        OffsetZ = 1.3,
        Repetition = true,
        IntervalFrame = 1,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 7,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 90004203001,
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
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.0,
            StartFrequency = 0.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 0.0,
            AmplitudeChangeTime = 0.0,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.0,
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
        GlideBindNode = "",
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
  }
}
