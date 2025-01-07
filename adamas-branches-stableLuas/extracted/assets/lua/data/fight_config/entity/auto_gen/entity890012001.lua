Config = Config or {}
Config.Entity890012001 = Config.Entity890012001 or { }
local empty = { }
Config.Entity890012001 = 
{
  [ 890012001 ] = {
    EntityId = 890012001,
    Components = {
      Transform = {
        Prefab = "Character/Monster/ShimaiMo/ShimaiMo1/ShimaiMo1NPC.prefab",
        Model = "ShimaiMo1",
        isClone = false,
        MinDistance = 0.5,
        MaxDistance = 1.5,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.85,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Animator = {
        Animator = "Character/Monster/ShimaiMo/ShimaiMo1/ShimaiMo1.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              RightSlightHit = 0.0,
              LeftSlightHit = 0.0,
              LeftHeavyHit = 0.0,
              RightHeavyHit = 0.0,
              HitDown = 0.0,
              Stun = 0.297,
              HitFlyUp = 0.0,
              HitFlyHover = 0.0
            }
          }
        }
      },
      Tag = {
        Tag = 1,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Move = {
        pivot = 1.11962,
        canGlide = false,
        canShowGlideObj = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        GlideBindNode = "",
        isFlyEntity = false,
        bornFlyHeight = 0.0,
        flyHeight = 0.0,
        minFlyHeight = 0.0,
        fallRecoverTime = 0.0,
        hitStateMinHeight = 0.0,
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
        ConfigName = "ShimaiMo1",
        LogicMoveConfigs = {
          Attack001 = 2,
          Attack002 = 2,
          Attack003 = 2
        },        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      State = {
        DyingTime = 2.0,
        DeathTime = 2.5,
        ReviveTime = 0.0,
        BornTime = 1.5,
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
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.3,
            ForceTime = 1.3,
            FusionChangeTime = 0.5,
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
            Time = 0.467,
            ForceTime = 0.467,
            FusionChangeTime = 0.467,
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
            FusionChangeTime = 0.83,
            IgnoreHitTime = 0.0
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
            Name = "collide",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "ShimaiMo1",
                LocalPosition = { 0.0, 1.05, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 1.05, 1.0 },
                UseMeshCollider = false
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
                LocalPosition = { 0.0, 0.0, -0.2 },
                LocalEuler = { 90.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.9, 1.5 },
                UseMeshCollider = false
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "head",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 12000.0
            },
            PartType = 1,
            PartWeakType = 1,
            WeakTrasnforms = {
              "ShimaiMo1_Head"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.04, -0.022, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.75, 0.75, 0.75 },
                UseMeshCollider = false
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          }
        },
        animStrClips = {
          "Alert",
          "Attack001",
          "Attack002",
          "Attack003",
          "Born",
          "Death",
          "Run",
          "Sit",
          "Stand1",
          "Stand2",
          "Stun",
          "Walk",
          "WalkBack",
          "WalkLeft",
          "WalkRight",
          "Warning001",
          "LeftSlightHit",
          "StandUp002",
          "RightSlightHit",
          "LeftHeavyHit",
          "RightHeavyHit",
          "HitDown",
          "HitFlyFall",
          "HitFlyHover",
          "HitFlyLand",
          "HitFlyUp",
          "Lie",
          "StandUp",
          "BackLeavyHit",
          "BeAssassin",
          "Palsy",
          "SwimDeath"
        },
        isTrigger = true
      },
      Skill = {
        Skills = {
          [ 90012001 ] = {
            TotalFrame = 82,
            ForceFrame = 73,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack001",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 90.0,
                  RotateFrame = 5,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 90012000001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 9999,
                  Frame = 25,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 19 ] = {
                {

                  EventName = "ShimaiMo1_Atk001",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 19,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 21 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 480.0,
                  RotateFrame = 10,
                  FrameTime = 21,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 90012000101,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 26 ] = {
                {

                  EntityId = 900120001001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 26,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 25.0,
                  Acceleration = -60.0,
                  MoveFrame = 1,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 26,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 29 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 42 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 5,
                  FrameTime = 42,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90012002 ] = {
            TotalFrame = 101,
            ForceFrame = 100,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 90.0,
                  RotateFrame = 33,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 8 ] = {
                {

                  EventName = "ShimaiMo1_Atk002",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 20 ] = {
                {

                  Type = 9999,
                  Frame = 25,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 90012000001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 32 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 13,
                  FrameTime = 32,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 38 ] = {
                {

                  EntityId = 90012000201,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 38,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 39 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 33.0,
                  Acceleration = -60.0,
                  MoveFrame = 2,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 39,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 40 ] = {
                {

                  EntityId = 900120002001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 43 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 43,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 68 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 15,
                  FrameTime = 68,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90012003 ] = {
            TotalFrame = 91,
            ForceFrame = 89,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack003",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 90012000301,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 90.0,
                  RotateFrame = 4,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 9 ] = {
                {

                  EventName = "ShimaiMo1_Atk003",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 90012000001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 9999,
                  Frame = 26,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 13 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 14 ] = {
                {

                  DisableWithoutTarget = false,
                  PauseAnimationMove = false,
                  DurationUpdateTargetFrame = 5,
                  OffsetType = 2,
                  TargetHPositionOffset = 3.5,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 5.0 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 18,

                }
              },
              [ 29 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.7,
                    Dir = 0,
                    Radius = 0.5,
                    Alpha = 0.5,
                    AlphaCurveId = 90012001,
                    Direction = 0,
                    Count = 10,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 0
                  },
                  LifeBindSkill = true,
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 900120003001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 30,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.7,
                      StartFrequency = 8.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.35,
                      FrequencyChangeTime = 0.35,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.7,
                      StartFrequency = 8.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.35,
                      FrequencyChangeTime = 0.35,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = 3.5,
                      StartFrequency = 4.0,
                      TargetAmplitude = 1.5,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 30,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 33 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 33,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 55 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 10,
                  FrameTime = 55,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90012004 ] = {
            TotalFrame = 30,
            ForceFrame = 29,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Alert",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 90012005 ] = {
            TotalFrame = 49,
            ForceFrame = 45,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "StandUp002",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 45,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90012006 ] = {
            TotalFrame = 95,
            ForceFrame = 90,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Warning001",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 90,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90012007 ] = {
            TotalFrame = 88,
            ForceFrame = 87,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 8 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 90.0,
                  RotateFrame = 4,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  EntityId = 90012000001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack002",
                  LayerIndex = 0,
                  StartFrame = 20,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Type = 9999,
                  Frame = 25,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 20 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 13,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 24 ] = {
                {

                  EventName = "ShimaiMo1_Atk004",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 24,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 26 ] = {
                {

                  EntityId = 90012000201,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 26,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 33.0,
                  Acceleration = -60.0,
                  MoveFrame = 1,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 27,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 28 ] = {
                {

                  EntityId = 900120002001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 31 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 55 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 15,
                  FrameTime = 55,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90012008 ] = {
            TotalFrame = 4,
            ForceFrame = 4,
            SkillBreakSkillFrame = 4,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "BeAssassin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  MagicId = 900000054,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90012009 ] = {
            TotalFrame = 25,
            ForceFrame = 25,
            SkillBreakSkillFrame = 25,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "BackLeavyHit",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
        DefaultAttrID = 900120,
      },
      FindPath = empty,
      Ik = {
        shakeLeftFrontId = 9000001,
        shakeLeftBackId = 9000002,
        shakeRightFrontId = 9000003,
        shakeRightBackId = 9000004,
        shakeDistanceRatio = 1.0,
        workWithOutImmuneHit = false,
        Look = {
          IsLookCtrlObject = true
        },
        Looked = {
          lookTransform = "Head",
          weight = 3000
        },
      },
      Sound = empty}
  }
}
