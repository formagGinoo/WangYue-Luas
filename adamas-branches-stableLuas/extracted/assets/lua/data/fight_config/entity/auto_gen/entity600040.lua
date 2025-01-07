Config = Config or {}
Config.Entity600040 = Config.Entity600040 or { }
local empty = { }
Config.Entity600040 = 
{
  [ 600040 ] = {
    EntityId = 600040,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Congshi/CongshiMo1/CongshiMo1.prefab",
        Model = "CongshiMo1",
        isClone = false,
        MinDistance = 0.5,
        MaxDistance = 1.5,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.85,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Animator = {
        Animator = "Character/Monster/Congshi/CongshiMo1/CongshiMo1.controller",
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
          "600040"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 5,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Move = {
        pivot = 0.84204,
        canGlide = false,
        canShowGlideObj = true,
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
        ConfigName = "CongshiMo1",
        LogicMoveConfigs = {
          Attack004 = 2,
          Attack005 = 2,
          Attack006 = 2,
          Attack007 = 2,
          Attack001Tandao = 2,
          Attack003Tandao = 2
        },        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
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
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "collide",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "CongshiMo1",
                LocalPosition = { 0.0, 0.95, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 1.0, 1.0 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 2,
            FollowBone = "ColliderPosition"
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
                LocalPosition = { -0.05473239, 0.0017447772, -0.253438652 },
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
            OnlyHitAlarm = false
          },
          {
            Name = "head",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 12000.0
            },
            PartType = 1,
            PartWeakType = 0,
            WeakTrasnforms = {
              "CongshiMo1_hair",
              "CongshiMo1_mask"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.006, -0.235, 0.0 },
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
            OnlyHitAlarm = false
          }
        },

      },
      Hit = {
        GravityAcceleration = -0.2,
        ReboundCoefficient = 0.3,
        ReboundTimes = 1.0,
        MinSpeed = 5.0,
        SpeedZCoefficient = 0.0,
        hitModified = {
          SpeedZ = 1.0,
          SpeedZAcceleration = 1.0,
          SpeedZArmor = 1.0,
          SpeedZArmorAcceleration = 1.0,
          SpeedY = 1.0,
          SpeedZHitFly = 1.0,
          SpeedYAcceleration = 1.0,
          SpeedYAloft = 1.0,
          SpeedZAloft = 1.0,
          SpeedYAloftAcceleration = 1.0,
          FlyHitSpeedZ = 1.0,
          FlyHitSpeedZAcceleration = 1.0,
          FlyHitSpeedY = 1.0,
          FlyHitSpeedYAcceleration = 1.0,
          FlyHitSpeedYAloft = 1.0,
          FlyHitSpeedZAloft = 1.0,
          FlyHitSpeedYAccelerationAloft = 1.0
        }
      },
      Skill = {
        Skills = {
          [ 90004001 ] = {
            TotalFrame = 72,
            ForceFrame = 71,
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

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9000400101,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 900000107,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 90004001002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.3,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 1.6,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 24,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 300.0,
                  RotateFrame = 15,
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 32 ] = {
                {

                  EntityId = 9000400102,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 32,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 90004001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 32,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004002 ] = {
            TotalFrame = 93,
            ForceFrame = 92,
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

                  EntityId = 9000400201,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 0.0,
                  RotateFrame = 33,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 8 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 900000107,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 20 ] = {
                {

                  EntityId = 90004002002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 9000400202,
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
                  LookAngleRange = 0.0,
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
              [ 28 ] = {
                {

                  EntityId = 90004002001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004003 ] = {
            TotalFrame = 69,
            ForceFrame = 68,
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

                }
              },
              [ 11 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 900000107,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 23 ] = {
                {

                  EntityId = 90004003002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.187,
                  BornOffsetY = 1.119,
                  BornOffsetZ = 1.6,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 23,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 9000400303,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 90004003001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004004 ] = {
            TotalFrame = 29,
            ForceFrame = 28,
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
          [ 90004005 ] = {
            TotalFrame = 37,
            ForceFrame = 37,
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
                  StartFrame = 15,
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
                  RotateFrame = 77,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  EntityId = 9000400501,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004006 ] = {
            TotalFrame = 36,
            ForceFrame = 35,
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

                  Name = "Warning002",
                  LayerIndex = 0,
                  StartFrame = 15,
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
                  RotateFrame = 66,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 9000400601,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 90004007 ] = {
            TotalFrame = 38,
            ForceFrame = 37,
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
                  RotateFrame = 38,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 90004008 ] = {
            TotalFrame = 38,
            ForceFrame = 38,
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

                  Name = "Attack001Tandao",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  MagicId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90004009 ] = {
            TotalFrame = 3,
            ForceFrame = 3,
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

                  Name = "BeAssasin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 2 ] = {
                {

                  MagicId = 900000054,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90004010 ] = {
            TotalFrame = 41,
            ForceFrame = 40,
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

                  Name = "Attack003Tandao",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  MagicId = 900000001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
            }
          },
          [ 90004011 ] = {
            TotalFrame = 89,
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

                  Name = "Palsy",
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
          [ 90004012 ] = {
            TotalFrame = 94,
            ForceFrame = 93,
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

                  Name = "WeaknessClean",
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
          [ 90004014 ] = {
            TotalFrame = 74,
            ForceFrame = 71,
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

                  Name = "Attack004",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 9000400101,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 21 ] = {
                {

                  EntityId = 900000001,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 21,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 9000400102,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 90004001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004015 ] = {
            TotalFrame = 105,
            ForceFrame = 103,
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

                  Name = "Attack005",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 9000400201,
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
                  LookAngleRange = 0.0,
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

                  AddType = 1,
                  BuffId = 900000045,
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
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 30,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 22 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 900000001,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 24,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 9000400202,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 5,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 40 ] = {
                {

                  EntityId = 90004002001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004016 ] = {
            TotalFrame = 70,
            ForceFrame = 68,
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

                  Name = "Attack006",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 18,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 11 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 900000001,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 9000400303,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 90004003001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 90004017 ] = {
            TotalFrame = 108,
            ForceFrame = 106,
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

                  Name = "Attack007",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9000400201,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 27 ] = {
                {

                  Type = 9999,
                  Frame = 23,
                  FrameTime = 27,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 900000001,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 42 ] = {
                {

                  EntityId = 9000400202,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 42,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 6,
                  FrameTime = 42,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 45 ] = {
                {

                  EntityId = 90004002001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 45,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 53 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 53,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

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
        DefaultAttrID = 600010,
      },
      Ik = {
        shakeLeftFrontId = 9000401,
        shakeLeftBackId = 9000402,
        shakeRightFrontId = 9000402,
        shakeRightBackId = 9000401,
        shakeDistanceRatio = 1.0,

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
          Fire = 150
        }
      },
      SkillSet = {
        UISets = {
          [ 1 ] = {
            ShowId = 1,
            UISetNote = "",
            CoreUIConfig = {
              BindRes = 0,
              Scale = 1.0,
              LocationOffset = { 0.0, 0.0, 0.0 },
              ScreenOffset = { 0.0, 0.0, 0.0 }
            },
            J = {
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
              Active = false,
              SkillId = 0,

            },
            F = {
              Active = false,
              SkillId = 0,

            },
            PartnerSkill = {
              Active = false,
              SkillId = 0,

            },          }
        }
      }
    }
  }
}
