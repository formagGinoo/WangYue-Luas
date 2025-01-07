Config = Config or {}
Config.Entity910024 = Config.Entity910024 or { }
local empty = { }
Config.Entity910024 = 
{
  [ 910024 ] = {
    EntityId = 910024,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMe1/ShilongMe1.prefab",
        Model = "ShilongMe1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Animator = {
        Animator = "Character/Monster/Shilong/ShilongMe1/ShilongMe1.controller",
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
        DefaultAttrID = 910024,
        AttributeEventList = {
          {
            AttrType = 1007,
            RecoverEvent = {
              Time = 10.0,
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
                900000005,
                1000019,
                1000020
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
          "910024"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 3,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Move = {
        pivot = 0.0,
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
        ConfigName = "ShilongMe1",
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
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
                ShapeType = 3,
                ParentName = "ShilongMe1",
                LocalPosition = {
                  x = -1.4305E-08,
                  y = 0.988,
                  z = 0.0
                },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.24, 1.09294844, 1.24 }
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
                LocalPosition = { 0.0, -0.184, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.397024632, 1.0 }
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
          [ 910024001 ] = {
            TotalFrame = 90,
            ForceFrame = 1,
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
              [ 9 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 0.0,
                  RotateFrame = 15,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 22 ] = {
                {

                  EntityId = 91002400101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 0.0,
                  Acceleration = 120.0,
                  RotateFrame = 5,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 910024001001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 24,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 55 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 8,
                  FrameTime = 55,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 910024002 ] = {
            TotalFrame = 90,
            ForceFrame = 1,
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

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 250.0,
                  Acceleration = 0.0,
                  RotateFrame = 30,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 16 ] = {
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
                  FrameTime = 16,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 40.0,
                  Acceleration = -2.0,
                  MoveFrame = 6,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 34,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 35 ] = {
                {

                  EntityId = 91002400201,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 40 ] = {
                {

                  EntityId = 910024002001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 41 ] = {
                {

                  EntityId = 91002400202,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 41,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
            }
          },
          [ 910024003 ] = {
            TotalFrame = 60,
            ForceFrame = 1,
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

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 300.0,
                  Acceleration = 0.0,
                  RotateFrame = 25,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 910024004 ] = {
            TotalFrame = 75,
            ForceFrame = 75,
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

                }
              },
              [ 6 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 50 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 50,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 910024005 ] = {
            TotalFrame = 174,
            ForceFrame = 174,
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

                }
              },
              [ 18 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 102 ] = {
                {

                  EntityId = 91002400001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 102,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 910024011 ] = {
            TotalFrame = 145,
            ForceFrame = 1,
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

                  Name = "Attack061",
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
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 7 ] = {
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
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 17,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 91002401101,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 30,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 910024011001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 0.0,
                  RotateFrame = 8,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 42 ] = {
                {

                  EntityId = 910024011002,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 42,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 65 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 13,
                  FrameTime = 65,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 67 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 20.0,
                  Acceleration = -2.0,
                  MoveFrame = 6,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 67,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 76 ] = {
                {

                  EntityId = 910024011003,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 76,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 89 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 720.0,
                  Acceleration = 0.0,
                  RotateFrame = 6,
                  FrameTime = 89,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 94 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 20.0,
                  Acceleration = -2.0,
                  MoveFrame = 6,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 94,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 97 ] = {
                {

                  EntityId = 910024011004,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 97,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 105 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 225.0,
                  Acceleration = 0.0,
                  RotateFrame = 12,
                  FrameTime = 105,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 145 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 145,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 910024012 ] = {
            TotalFrame = 90,
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

                  Name = "Attack062",
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
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 300.0,
                  Acceleration = 0.0,
                  RotateFrame = 22,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 91002401201,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 24,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 52 ] = {
                {

                  EntityId = 910024012001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.4,
                  BornOffsetZ = 1.45,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 345.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = true,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 1.4,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 52,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 910024012001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.4,
                  BornOffsetZ = 1.45,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = true,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 1.4,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 52,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 910024012001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.4,
                  BornOffsetZ = 1.45,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 15.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = true,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 1.4,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 52,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 88 ] = {
                {

                  AddType = 2,
                  BuffId = 900000001,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 88,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 910024021 ] = {
            TotalFrame = 99999,
            ForceFrame = 99999,
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

                  AddType = 1,
                  BuffId = 900000013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "Diving001",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 900000007,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 910024022 ] = {
            TotalFrame = 107,
            ForceFrame = 107,
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

                  Name = "Dive001",
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
                  SpeedOffset = 90.0,
                  Acceleration = 0.0,
                  RotateFrame = 38,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  EntityId = 91002402201,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 107 ] = {
                {

                  AddType = 2,
                  BuffId = 900000013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 107,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 2,
                  BuffId = 900000007,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 107,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 910024901 ] = {
            TotalFrame = 100,
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
          }
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      ElementState = {
        ElementType = 1,

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
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "ShilongMe1",
                LocalPosition = {
                  x = -1.4305E-08,
                  y = 0.988,
                  z = 0.0
                },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.24, 1.09294844, 1.24 }
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
            Name = "Head",
            PartType = 1,
            PartWeakType = 1,
            lockTransformName = "HitCase",
            attackTransformName = "HitCase",
            hitTransformName = "HitCase",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Head",
                LocalPosition = { 0.0, -0.184, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.397024632, 1.0 }
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

      }
    }
  },
  [ 910024001001 ] = {
    EntityId = 910024001001,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 2,
        Radius = 11000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 2.0,
        Height = 2.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTarget = {
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400102,
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
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
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
        },
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Move = {
        pivot = 0.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      }
    }
  },
  [ 910024002001 ] = {
    EntityId = 910024002001,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 2,
        Radius = 11000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 1.5,
        Height = 2.0,
        Width = 1.5,
        OffsetX = 0.6,
        OffsetY = 1.0,
        OffsetZ = 0.3,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTarget = {
          900000002,
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400202,
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
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 8.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      }
    }
  },
  [ 910024011001 ] = {
    EntityId = 910024011001,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 2,
        Radius = 11000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 2.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = -0.2,
        OffsetY = 1.1,
        OffsetZ = 1.2,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTarget = {
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400102,
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
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
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
        },
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 910024011002 ] = {
    EntityId = 910024011002,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 2,
        Radius = 11000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 2.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.46,
        OffsetY = 1.1,
        OffsetZ = 1.2,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTarget = {
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 2,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
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
        },
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 910024011003 ] = {
    EntityId = 910024011003,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 2,
        Radius = 11000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 3.5,
        Height = 2.0,
        Width = 3.0,
        OffsetX = -0.26,
        OffsetY = 1.1,
        OffsetZ = 1.07,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTarget = {
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400102,
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
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
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
        },
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 910024011004 ] = {
    EntityId = 910024011004,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 2,
        Radius = 11000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.1,
        OffsetZ = 0.5,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTarget = {
          900000002,
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400102,
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
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 6.0,
          SpeedZHitFly = 5.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 910024012001 ] = {
    EntityId = 910024012001,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMe1/Common/Effect/ShilongFxAtk062M.prefab",
        Model = "ShilongFxAtk062M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 301,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 1,
        Radius = 0.5,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 10000.0,
        Height = 10000.0,
        Width = 10000.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = true,
        IntervalFrame = 10,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.3,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          900000019
        },
        CreateHitEntities = {
          {
            EntityId = 91002400102,
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
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
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
        },
        ShakeId = 0,
        CalcNearShakeBone = false,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
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
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 2.0,
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      CreateEntity = {
        CreateEntityInfos = {
          {
            DelayTime = 9.95,
            EntityId = 91002401202,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 0.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 0.0
          }
        },
      }
    }
  },
  [ 91002400101 ] = {
    EntityId = 91002400101,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { -0.019, 0.0, -0.503 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk001.prefab",
        Model = "ShilongFxAtk001",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002400102 ] = {
    EntityId = 91002400102,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk001H.prefab",
        Model = "ShilongFxAtk001H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002401201 ] = {
    EntityId = 91002401201,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Head",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMe1/Common/Effect/ShilongFxAtk062.prefab",
        Model = "ShilongFxAtk062",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002401202 ] = {
    EntityId = 91002401202,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMe1/Common/Effect/ShilongFxAtk062MD.prefab",
        Model = "ShilongFxAtk062MD",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002401101 ] = {
    EntityId = 91002401101,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/ShilongMe1/Common/Effect/ShilongFxAtk061.prefab",
        Model = "ShilongFxAtk061",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 184,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 91002400001 ] = {
    EntityId = 91002400001,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxcom001.prefab",
        Model = "ShilongFxcom001",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002402201 ] = {
    EntityId = 91002402201,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxDive002.prefab",
        Model = "ShilongFxDive002",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002400201 ] = {
    EntityId = 91002400201,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk002_R.prefab",
        Model = "ShilongFxAtk002_R",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002400202 ] = {
    EntityId = 91002400202,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk002_H.prefab",
        Model = "ShilongFxAtk002_H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
  [ 91002400203 ] = {
    EntityId = 91002400203,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shilong/Common/Effect/ShilongFxAtk002_H.prefab",
        Model = "ShilongFxAtk002_H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = 169,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
