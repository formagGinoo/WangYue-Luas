Config = Config or {}
Config.Entity900020 = Config.Entity900020 or { }
local empty = { }
Config.Entity900020 = 
{
  [ 900020 ] = {
    EntityId = 900020,
    EntityName = "900020",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMo1/ShilongMo1.prefab",
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
        Animator = "Character/Monster/Shilong/ShilongMo1/ShilongMo1.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              Stun = 0.25,
              RightSlightHit = 0.0,
              LeftSlightHit = 0.0,
              RightHeavyHit = 0.0,
              LeftHeavyHit = 0.0,
              AnyState = 0.12,
              HitDown = 0.0
            }
          }
        }
      },
      Behavior = {
        Behaviors = {
          "900020"
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
        pivot = 0.71,
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
        ConfigName = "ShilongMo2",
        LogicMoveConfigs = {
          Dive001 = 4
        },        BindRotation = false,

      },
      State = {
        DyingTime = 2.8333,
        DeathTime = 0.73333,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 1.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.2,
            ForceTime = 0.6667,
            FusionChangeTime = 0.6667,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.2,
            ForceTime = 0.6667,
            FusionChangeTime = 0.6667,
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
            ForceTime = 1.7333,
            FusionChangeTime = 1.7333,
            IgnoreHitTime = 1.7333
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
                ShapeType = 3,
                ParentName = "ShilongMo1",
                LocalPosition = { 0.0, 1.1, 0.24 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.2, 1.1, 1.2 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 2,
            FollowBone = "ColliderPosition"
          }
        },
        CollisionRadius = 0.5,
        Height = 1.7,
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
            lockTransformName = "",
            attackTransformName = "",
            hitTransformName = "",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Pelvis",
                LocalPosition = { -0.3620001, 0.0, 0.0149999559 },
                LocalEuler = { 0.0, 182.3603, 270.0 },
                LocalScale = { 1.0, 1.0, 1.0 }
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
            PartType = 0,
            PartWeakType = 1,
            WeakTrasnforms = {
              ""
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, -0.057, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.283923984, 1.0 }
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
        DefaultName = "普通土石龙",
        DefaultAttrID = 900020,
      },
      Skill = {
        Skills = {
          [ 900020001 ] = {
            TotalFrame = 90,
            ForceFrame = 90,
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
              [ 3 ] = {
                {

                  Type = 9999,
                  Frame = 25,
                  FrameTime = 3,
                  EventType = 3,

                },
                {

                  EntityId = 900000004,
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
                  FrameTime = 3,
                  EventType = 1,

                }
              },
              [ 9 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 22,
                  FrameTime = 9,
                  EventType = 8,

                }
              },
              [ 22 ] = {
                {

                  EntityId = 90002000101,
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
                  FrameTime = 22,
                  EventType = 1,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 900020001001,
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
                  FrameTime = 24,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 37,
                  EventType = 8,

                }
              },
              [ 56 ] = {
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 56,
                  EventType = 9,

                }
              },
            }
          },
          [ 900020002 ] = {
            TotalFrame = 90,
            ForceFrame = 90,
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
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 1,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 30,
                  FrameTime = 2,
                  EventType = 8,

                }
              },
              [ 12 ] = {
                {

                  Type = 9999,
                  Frame = 32,
                  FrameTime = 12,
                  EventType = 3,

                },
                {

                  EntityId = 900000004,
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
                  FrameTime = 12,
                  EventType = 1,

                }
              },
              [ 32 ] = {
                {

                  EntityId = 900020002001,
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
                  FrameTime = 32,
                  EventType = 1,

                }
              },
              [ 33 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 30.0,
                  Acceleration = -2.0,
                  MoveFrame = 7,
                  InputSpeed = 0.0,
                  MinDistance = 0.3,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 33,
                  EventType = 7,

                },
                {

                  EntityId = 90002000202,
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
                  FrameTime = 33,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 36,
                  EventType = 8,

                }
              },
              [ 39 ] = {
                {

                  EntityId = 90002000201,
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
                  FrameTime = 39,
                  EventType = 1,

                }
              },
              [ 60 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 60,
                  EventType = 9,

                }
              },
            }
          },
          [ 900020003 ] = {
            TotalFrame = 69,
            ForceFrame = 69,
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

                }
              },
              [ 10 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 25,
                  EventType = 1,

                }
              },
            }
          },
          [ 900020004 ] = {
            TotalFrame = 75,
            ForceFrame = 75,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack006",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 6,
                  EventType = 1,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 12,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 25,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 35,
                  EventType = 1,

                }
              },
              [ 50 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 50,
                  EventType = 1,

                }
              },
            }
          },
          [ 900020005 ] = {
            TotalFrame = 174,
            ForceFrame = 174,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack007",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 102 ] = {
                {

                  EntityId = 90002000001,
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
                  FrameTime = 102,
                  EventType = 1,

                }
              },
            }
          },
          [ 900020009 ] = {
            TotalFrame = 5,
            ForceFrame = 5,
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
          [ 900020012 ] = {
            TotalFrame = 160,
            ForceFrame = 160,
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
              [ 11 ] = {
                {

                  EntityId = 90002001101,
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
                  FrameTime = 11,
                  EventType = 1,

                }
              },
              [ 67 ] = {
                {

                  EntityId = 90002001102,
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
                  FrameTime = 67,
                  EventType = 1,

                }
              },
              [ 68 ] = {
                {

                  EntityId = 90002001103,
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
                  FrameTime = 68,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 52,
                  FrameTime = 68,
                  EventType = 8,

                }
              },
              [ 90 ] = {
                {

                  Name = "Attack012",
                  StartFrame = 0,
                  FrameTime = 90,
                  EventType = 2,

                }
              },
              [ 100 ] = {
                {

                  EntityId = 900000004,
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
                  FrameTime = 100,
                  EventType = 1,

                },
                {

                  Type = 9999,
                  Frame = 45,
                  FrameTime = 100,
                  EventType = 3,

                }
              },
              [ 120 ] = {
                {

                  EntityId = 900020012001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.577,
                  BornOffsetY = 0.611,
                  BornOffsetZ = 1.415,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = true,
                  LookAngleRange = 15.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 120,
                  EventType = 1,

                }
              },
              [ 140 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 140,
                  EventType = 9,

                }
              },
            }
          },
          [ 900020021 ] = {
            TotalFrame = 99999,
            ForceFrame = 999999,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 900000007,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 900000013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Diving002",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 900020022 ] = {
            TotalFrame = 107,
            ForceFrame = 107,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Dive002",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 0.0,
                  RotateFrame = 38,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  EntityId = 90002002201,
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
                  FrameTime = 0,
                  EventType = 1,

                }
              },
              [ 72 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 0.0,
                  RotateFrame = 35,
                  FrameTime = 72,
                  EventType = 8,

                }
              },
              [ 107 ] = {
                {

                  AddType = 2,
                  BuffId = 900000007,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 107,
                  EventType = 9,

                },
                {

                  AddType = 2,
                  BuffId = 900000013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 107,
                  EventType = 9,

                }
              },
            }
          },
          [ 900020062 ] = {
            TotalFrame = 56,
            ForceFrame = 56,
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
          },
          [ 900020901 ] = {
            TotalFrame = 100,
            ForceFrame = 100,
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
              [ 30 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 25,
                  FrameTime = 30,
                  EventType = 8,

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
        TransformName = "MarkCase",
        OffsetWorldY = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        canShowInBody = false,
        lockPosition = false,
        headRadius = 0.5,
        ShowType = 2,
        ShowTime = 0.0,
        DetailDistance = 20.0,
        SimpleDistance = 30.0
      },
      ElementState = {
        ElementType = 6,
        ElementMaxAccumulateDict = {
          Wood = 200
        }
      },
      Death = {
        DeathList = {
          {
            DeathReason = 1,
            DeathTime = 1.6,
            deathCondition = {
              DrownHeight = 1.4,
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
                  TerrainDeathHeight = 1.4,
                  TerrainDeathTime = -1.0,
                  AccelerationY = -0.6
                }
              },
            }
          }
        },
      },
      FindPath = empty,
      Condition = {
        ConditionParamsList = {
          {
            Interval = 1.0,
            Count = -1,
            ConditionList = {
              {

                Count = 10,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountInterval = 6.0,
                HitDuration = 0.0,
                ConditionType = 2
              }
            },
            MeetConditionEventList = {
              {

                Duration = 1.0,
                MeetConditionEventType = 2
              }
            },
          }
        },
      },
      Ik = {
        shakeLeftFrontId = 0,
        shakeLeftBackId = 0,
        shakeRightFrontId = 0,
        shakeRightBackId = 0,
        shakeDistanceRatio = 0.0,

      }
    }
  },
  [ 900020001001 ] = {
    EntityId = 900020001001,
    EntityName = "900020001001",
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
      Attack = {
        AttackType = 1,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 2.0,
        Width = 3.0,
        OffsetX = 0.25,
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
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          900020001,
          90002003
        },
        CreateHitEntities = {
          {
            EntityId = 90002000103,
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
          SpeedZ = 6.0,
          SpeedZAcceleration = -3.0,
          SpeedZTime = 0.2,
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
            StartAmplitude = 0.6,
            StartFrequency = 10.0,
            TargetAmplitude = 0.05,
            TargetFrequency = 4.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.35,
            DurationTime = 0.35,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 4.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.35,
            DurationTime = 0.35,
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
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
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
        ConfigName = "ShilongMo1",
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
  [ 900020002001 ] = {
    EntityId = 900020002001,
    EntityName = "900020002001",
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
        Frame = 12,
        RemoveDelayFrame = 0,
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 12,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 3.0,
        Width = 2.1,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 0.85,
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
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          900020003,
          90002004
        },
        CreateHitEntities = {
          {
            EntityId = 90002000203,
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
          SpeedY = 10.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -2.0,
          SpeedYAccelerationTime = 0.25,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 1.0,
            StartFrequency = 10.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 3.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.3,
            DurationTime = 0.3,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.05,
            TargetFrequency = 3.0,
            AmplitudeChangeTime = 0.2,
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
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
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
        ConfigName = "ShilongMo1",
        BindOffsetX = 0.0,
        BindOffsetY = 1.0,
        BindOffsetZ = 0.4,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 900020012001 ] = {
    EntityId = 900020012001,
    EntityName = "900020012001",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk010M.prefab",
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
        DurationFrame = 45,
        ShapeType = 1,
        Radius = 0.3,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.5,
        Height = 0.5,
        Width = 0.5,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          900020004,
          90002003
        },
        CreateHitEntities = {
          {
            EntityId = 90002001202,
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
          SpeedZ = 7.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.2,
          SpeedY = 7.0,
          SpeedZHitFly = 5.0,
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
            StartAmplitude = 0.6,
            StartFrequency = 10.0,
            TargetAmplitude = 0.05,
            TargetFrequency = 4.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.35,
            DurationTime = 0.35,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 4.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.35,
            DurationTime = 0.35,
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
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 35.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "",
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90002001201 ] = {
    EntityId = 90002001201,
    EntityName = "90002001201",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "shitou",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk010M.prefab",
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
        Frame = 56,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 900020011001 ] = {
    EntityId = 900020011001,
    EntityName = "900020011001",
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
        Frame = 9,
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
        Lenght = 3.0,
        Height = 2.2,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 4,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.1,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          900020002,
          900000002
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
          SpeedY = 7.0,
          SpeedZHitFly = 5.0,
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
        ConfigName = "ShilongMo1",
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
  [ 90002001101 ] = {
    EntityId = 90002001101,
    EntityName = "90002001101",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk010.prefab",
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
        Frame = 166,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90002000101 ] = {
    EntityId = 90002000101,
    EntityName = "90002000101",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongMo1FxAtk001.prefab",
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
        Frame = 49,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90002001102 ] = {
    EntityId = 90002001102,
    EntityName = "90002001102",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk010_1.prefab",
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
  [ 90002001103 ] = {
    EntityId = 90002001103,
    EntityName = "90002001103",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "shitou",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk010M.prefab",
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
  [ 90002001104 ] = {
    EntityId = 90002001104,
    EntityName = "90002001104",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 1.5 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk011H.prefab",
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
  [ 90002001202 ] = {
    EntityId = 90002001202,
    EntityName = "ShilongFxAtk012H",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongFxAtk012H.prefab",
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
  [ 90002002201 ] = {
    EntityId = 90002002201,
    EntityName = "90002002201",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.8, 0.8, 0.8 },
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
  [ 90002000001 ] = {
    EntityId = 90002000001,
    EntityName = "90002000001",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.8, 0.8, 0.8 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxcom001.prefab",
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
  [ 90002000201 ] = {
    EntityId = 90002000201,
    EntityName = "90002000201",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongMo1FxAtk002.prefab",
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
  [ 90002000202 ] = {
    EntityId = 90002000202,
    EntityName = "90002000202",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.8, 0.8, 0.8 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongMo1FxAtk002_R.prefab",
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
        Frame = 58,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90002000203 ] = {
    EntityId = 90002000203,
    EntityName = "ShilongFxAtk002_H",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongMo1FxAtk002_H.prefab",
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
  [ 90002000103 ] = {
    EntityId = 90002000103,
    EntityName = "90002000103",
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
        Prefab = "Character/Monster/Shilong/ShilongMo1/Common/Effect/ShilongMo1FxAtk001H.prefab",
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
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
