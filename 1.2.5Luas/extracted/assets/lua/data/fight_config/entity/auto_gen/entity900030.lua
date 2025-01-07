Config = Config or {}
Config.Entity900030 = Config.Entity900030 or { }
local empty = { }
Config.Entity900030 = 
{
  [ 900030 ] = {
    EntityId = 900030,
    EntityName = "900030",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/CongshidunMo1.prefab",
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
        Animator = "Character/Monster/Congshidun/CongshidunMo1/CongshidunMo1.controller",
        AnimationConfigID = "",

      },
      Behavior = {
        Behaviors = {
          "900030"
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
        ConfigName = "CongshidunMo1",
        BindRotation = false,

      },
      State = {
        DyingTime = 1.5,
        DeathTime = 1.5,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 0.93,
            ForceTime = 0.93,
            FusionChangeTime = 0.93,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 0.93,
            ForceTime = 0.93,
            FusionChangeTime = 0.93,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.27,
            ForceTime = 1.27,
            FusionChangeTime = 1.27,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.27,
            ForceTime = 1.27,
            FusionChangeTime = 1.27,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 0.0,
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
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 0.0,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 1.9,
            ForceTime = 1.9,
            FusionChangeTime = 1.9,
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
                LocalPosition = { 0.035267625, 0.00174492621, -0.369438648 },
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
                LocalPosition = { 0.0, -0.19, 0.0 },
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
            WeakTrasnforms = {
              "CongshiMo1_hair",
              "CongshiMo1_mask"
            },
            lockTransformName = "",
            attackTransformName = "",
            hitTransformName = "",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { 0.035267625, 0.00174492621, -0.369438648 },
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
              DamageParam = 12000.0
            },
            PartType = 1,
            PartWeakType = 1,
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, -0.19, 0.0 },
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Attributes = {
        DefaultAttrID = 900010,
      },
      Skill = {
        Skills = {
          [ 90003001 ] = {
            TotalFrame = 66,
            ForceFrame = 65,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshidunMo1_Atk001",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack001",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9000300102,
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
              [ 12 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 12,
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
                  FrameTime = 12,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 0.0,
                  RotateFrame = 14,
                  FrameTime = 28,
                  EventType = 8,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 9000300101,
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
              [ 32 ] = {
                {

                  EntityId = 90003001001,
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
                  FrameTime = 32,
                  EventType = 1,

                }
              },
            }
          },
          [ 90003002 ] = {
            TotalFrame = 34,
            ForceFrame = 33,
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
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90003009 ] = {
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
          [ 90003010 ] = {
            TotalFrame = 47,
            ForceFrame = 46,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack010",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 90003011 ] = {
            TotalFrame = 27,
            ForceFrame = 26,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshidunMo1_Atk011",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack011",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 90003003,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  EntityId = 9000301101,
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
              [ 27 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 27,
                  EventType = 9,

                }
              },
            }
          },
          [ 90003012 ] = {
            TotalFrame = 83,
            ForceFrame = 82,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "CongshidunMo1_Atk012",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack012",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 9000301201,
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

                  EntityId = 9000301202,
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
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  Type = 9999,
                  Frame = 45,
                  FrameTime = 4,
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
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 0.0,
                  RotateFrame = 40,
                  FrameTime = 6,
                  EventType = 8,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 90003001012,
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
                  FrameTime = 24,
                  EventType = 1,

                }
              },
              [ 49 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 49,
                  EventType = 9,

                }
              },
            }
          },
          [ 90003013 ] = {
            TotalFrame = 19,
            ForceFrame = 18,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack013",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 1,
                  SpeedOffset = 0.0,
                  Acceleration = 0.0,
                  RotateFrame = 0,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90003014 ] = {
            TotalFrame = 29,
            ForceFrame = 29,
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

                },
                {

                  EventName = "CongshidunMo1_Alert",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
            }
          },
          [ 90003015 ] = {
            TotalFrame = 52,
            ForceFrame = 52,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Warning001",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 9000301501,
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
          [ 90003016 ] = {
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
          [ 90003062 ] = {
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
        ElementType = 3,
        ElementMaxAccumulateDict = {
          Fire = 100
        }
      },
      FindPath = empty}
  },
  [ 90003001001 ] = {
    EntityId = 90003001001,
    EntityName = "90003001001",
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
        DurationFrame = 31,
        ShapeType = 2,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.8,
        Height = 1.8,
        Width = 1.3,
        OffsetX = 0.0,
        OffsetY = 0.76,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          90003001,
          900000014,
          900000015
        },
        SoundsByTarget = {
          "CongshidunMo1_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "CongshidunMo1_Atk001_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 9000300103,
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
  [ 90003001012 ] = {
    EntityId = 90003001012,
    EntityName = "90003001012",
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
        Frame = 25,
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
        DurationFrame = 25,
        ShapeType = 2,
        Radius = 1.2,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.2,
        Height = 1.8,
        Width = 2.2,
        OffsetX = 0.0,
        OffsetY = 0.8,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          90003002,
          900000014,
          900000015
        },
        SoundsByTarget = {
          "CongshidunMo1_Atk012_Hit"
        },
        WwisePTRC = {
          paramName = "CongshidunMo1_Atk012_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 9000300103,
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
          SpeedZ = 2.0,
          SpeedZAcceleration = -2.5,
          SpeedZTime = 0.8,
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
        BindChild = "",

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000300101 ] = {
    EntityId = 9000300101,
    EntityName = "9000300101",
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
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Atk001.prefab",
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
  [ 9000300102 ] = {
    EntityId = 9000300102,
    EntityName = "9000300102",
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
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Atk001WpCaseRight.prefab",
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
  [ 9000301101 ] = {
    EntityId = 9000301101,
    EntityName = "9000301101",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "WeaponCaseLeft",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Atk011WpCaseLeft.prefab",
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
        Frame = 25,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000300103 ] = {
    EntityId = 9000300103,
    EntityName = "9000300103",
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
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Atk001H.prefab",
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
  [ 9000301201 ] = {
    EntityId = 9000301201,
    EntityName = "9000301201",
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
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Atk012.prefab",
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
        Frame = 94,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000301202 ] = {
    EntityId = 9000301202,
    EntityName = "9000301202",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "WeaponCaseLeft",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Atk012WpCaseLeft.prefab",
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
        Frame = 64,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9000301501 ] = {
    EntityId = 9000301501,
    EntityName = "9000301501",
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
        Prefab = "Character/Monster/Congshidun/CongshidunMo1/Effect/FxCongshidunMo1Warning001.prefab",
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
        Frame = 43,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90003001002 ] = {
    EntityId = 90003001002,
    EntityName = "90003001002",
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
        DurationFrame = 7,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 1.5,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 3,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 90003001001,
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
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
