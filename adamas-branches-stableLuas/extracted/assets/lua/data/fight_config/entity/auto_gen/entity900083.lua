Config = Config or {}
Config.Entity900083 = Config.Entity900083 or { }
local empty = { }
Config.Entity900083 = 
{
  [ 900083 ] = {
    EntityId = 900083,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo4/ZhenshizhilieMo4.prefab",
        Model = "ZhenshizhilieMo4",
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
        Animator = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo4/ZhenshizhilieMo4.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              AnyState = 0.07
            }
          }
        }
      },
      Attributes = {
        DefaultAttrID = 900080,
      },
      Behavior = {
        Behaviors = {
          "900083"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      },
      Move = {
        pivot = 1.0,
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
        ConfigName = "ZhenshizhilieMo4",
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      State = {
        DyingTime = 2.8,
        DeathTime = 2.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.0,
            ForceTime = 0.66,
            FusionChangeTime = 0.66,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.0,
            ForceTime = 0.66,
            FusionChangeTime = 0.66,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.1,
            ForceTime = 1.1,
            FusionChangeTime = 1.1,
            IgnoreHitTime = 1.1
          },
          [ 6 ] = {
            Time = 2.5,
            ForceTime = 2.5,
            FusionChangeTime = 2.5,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.3,
            ForceTime = 0.3,
            FusionChangeTime = 0.3,
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
            Time = 0.6,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 2.0,
            ForceTime = 2.0,
            FusionChangeTime = 2.0,
            IgnoreHitTime = 2.0
          },
          [ 21 ] = {
            Time = 1.667,
            ForceTime = 1.667,
            FusionChangeTime = 1.667,
            IgnoreHitTime = 1.667
          }
        },
        HitStateRandomMapping = {
          RightLightHit = {
            1
          },
          PressDown = {
            5
          },
          HitFly = {
            5
          },
          HitFlyHover = {
            1
          },
          HitFlyUp = {
            3
          },
          HitFlyFall = {
            1
          },
          HitFlyLand = {
            1
          },
        }
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Collider",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Root",
                LocalPosition = { 0.0, 1.13, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.3, 1.0, 1.3 }
              }
            },
            DefaultEnable = false,
            ColliderFollow = 2,
            FollowBone = "ColliderPosition"
          }
        },
        CollisionRadius = 0.5,
        Height = 1.5,
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
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { 0.127, 0.0, -0.104 },
                LocalEuler = { 90.0, 0.0, 0.0 },
                LocalScale = { 1.35, 0.85, 1.35 }
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
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.1, 0.015, 0.0 },
                LocalEuler = { 281.385529, 270.000336, 179.999512 },
                LocalScale = { 0.68, 0.68, 0.68 }
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
            Name = "DodgeBullet",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001",
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 20.0, 2.0, 20.0 }
              }
            },
            LogicSearch = false,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = false,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = true
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Skill = {
        Skills = {
          [ 900083001 ] = {
            TotalFrame = 140,
            ForceFrame = 135,
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

                  EventName = "ZhenshizhilieMo1_ATK001_Charge",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

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

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 50,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 16 ] = {
                {

                  EntityId = 90008301,
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
                  FrameTime = 16,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 90008304,
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
                  FrameTime = 16,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 900000001,
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
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 9999,
                  Frame = 60,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 51 ] = {
                {

                  EntityId = 900083001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 1.0,
                  BornOffsetY = 3.2,
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
                  FrameTime = 51,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 900083001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -1.0,
                  BornOffsetY = 3.2,
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
                  FrameTime = 51,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 910 ] = {
                {

                  EntityId = 90008303,
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
                  FrameTime = 910,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 900083002 ] = {
            TotalFrame = 10,
            ForceFrame = 10,
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

                  Name = "WalkLeft",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Direction = 3,
                  CustomX = 1.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 40.0,
                  Acceleration = -100.0,
                  MoveFrame = 5,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 1 ] = {
                {

                  AddType = 1,
                  BuffId = 900000060,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 900000007,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 900083003 ] = {
            TotalFrame = 10,
            ForceFrame = 10,
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
                  BuffId = 900000007,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "WalkLeft",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Direction = 3,
                  CustomX = -1.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 40.0,
                  Acceleration = -100.0,
                  MoveFrame = 5,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 1 ] = {
                {

                  AddType = 1,
                  BuffId = 900000060,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 900083004 ] = {
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

                  Name = "Attack004",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EventName = "ZhenshizhilieMo1_ATK004_Charge",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

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

                },
                {

                  RotateType = 0,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 53,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 90008305,
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
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  EntityId = 900000001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "WeaponCaseRight",
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
                  FrameTime = 36,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 9999,
                  Frame = 61,
                  FrameTime = 36,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 51 ] = {
                {

                  EntityId = 900083004,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "WeaponCaseRight",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -30.0,
                  BornRotateOffsetY = 30.0,
                  BornRotateOffsetZ = 20.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 51,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 80 ] = {
                {

                  AddType = 2,
                  BuffId = 900000045,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 80,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 900083009 ] = {
            TotalFrame = 4,
            ForceFrame = 4,
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

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 4.0,
                  MaxFallSpeed = 0.0,
                  SaveSpeed = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                },
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
          [ 900083010 ] = {
            TotalFrame = 42,
            ForceFrame = 42,
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
          [ 900083062 ] = {
            TotalFrame = 30,
            ForceFrame = 30,
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

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 30.0,
                  MaxFallSpeed = 0.0,
                  SaveSpeed = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                },
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
      ElementState = {
        ElementType = 3,
        ElementMaxAccumulateDict = {
          Fire = 22000
        }
      },
      FindPath = empty,
      Death = {
        DeathList = {
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
      LifeBar = {
        Prefab = "Prefabs/UI/Fight/LifeBar/MonsterLifeBarObj.prefab",
        LifeBarLength = 250.0,
        ShowArmorBar = false,
        TransformName = "Bip001 Head",
        OffsetWorldY = 0.1,
        OffsetX = 0.15,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        canShowInBody = false,
        lockPosition = false,
        headRadius = 0.0,
        ShowType = 2,
        ShowTime = 0.0,
        DetailDistance = 20.0,
        SimpleDistance = 30.0,
        NearestDis = 10.0,
        FarthestDis = 20.0,
        FarthestX = 0.4,
        FarthestScale = 1.1,
        NearestX = 0.4,
        NearestScale = 1.0
      },
      Condition = {
        ConditionParamsList = {
          {
            Interval = 2.0,
            Count = -1,
            ConditionList = {
              {

                Count = 20,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountWhenHitFly = false,
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
  [ 900083001 ] = {
    EntityId = 900083001,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk001M.prefab",
        Model = "FxZhenshizhilieMo1Atk001M",
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
        Frame = 45,
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
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 44,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 1,
        Radius = 0.4,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 1.0,
        Height = 1.0,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 38.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          900083001,
          90008001
        },
        SoundsByTarget = {
          "ZhenshizhilieMo1_ATK001_Hit"
        },
        WwisePTRC = {
          paramName = "ZhenshizhilieMo1_ATK001_Hit",
          value = 100.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          90008302
        },
        CreateHitEntities = {
          {
            EntityId = 90008302,
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
          },
          {
            HitType = 2,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 5.0,
          SpeedZAcceleration = -3.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
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
              StartAmplitude = 0.3,
              StartFrequency = 5.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 2.0,
              AmplitudeChangeTime = 0.25,
              FrequencyChangeTime = 0.3,
              DurationTime = 0.3,
              Sign = 1.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.2,
              StartFrequency = 4.0,
              TargetAmplitude = 0.03,
              TargetFrequency = 0.0,
              AmplitudeChangeTime = 0.25,
              FrequencyChangeTime = 0.35,
              DurationTime = 0.35,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeedCurve = "-1"
          }
        },        UsePostProcess = false,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 90008301,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 90008302,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 1.3,
        RotationLockDelay = 2,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
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
  [ 900083004 ] = {
    EntityId = 900083004,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk004M.prefab",
        Model = "FxZhenshizhilieMo1Atk004M",
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
        Frame = 40,
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
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 40,
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
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 25.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          900083004,
          90008004
        },
        SoundsByTarget = {
          "ZhenshizhilieMo1_ATK004_Hit"
        },
        WwisePTRC = {
          paramName = "ZhenshizhilieMo1_ATK004_Hit",
          value = 100.0,
          time = 0.0
        },        CreateAttackEntities = {
          90008302
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = false
          },
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 9.0,
          SpeedZAcceleration = -6.0,
          SpeedZTime = 0.22,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
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
              IsNoTimeScale = true,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.3,
              StartFrequency = 8.0,
              TargetAmplitude = 0.08,
              TargetFrequency = 2.0,
              AmplitudeChangeTime = 0.25,
              FrequencyChangeTime = 0.35,
              DurationTime = 0.35,
              Sign = 1.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 2.0,
              AmplitudeChangeTime = 0.22,
              FrequencyChangeTime = 0.35,
              DurationTime = 0.3,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.2,
              StartFrequency = 4.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.25,
              FrequencyChangeTime = 0.3,
              DurationTime = 0.3,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeedCurve = "-1"
          }
        },        UsePostProcess = false,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 90008303,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 90008304,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 1.0,
        RotationLockDelay = 1,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "ZhenshizhilieMo1_ATK004_Missile",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 90008301 ] = {
    EntityId = 90008301,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { -1.0, 2.7, 2.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk001.prefab",
        Model = "FxZhenshizhilieMo1Atk001",
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
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90008302 ] = {
    EntityId = 90008302,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.0,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk001H.prefab",
        Model = "FxZhenshizhilieMo1Atk001H",
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
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90008303 ] = {
    EntityId = 90008303,
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
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk001.prefab",
        Model = "FxZhenshizhilieMo1Atk001",
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
        Frame = 80,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
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
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      }
    }
  },
  [ 90008304 ] = {
    EntityId = 90008304,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 1.0, 2.7, 2.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk001.prefab",
        Model = "FxZhenshizhilieMo1Atk001",
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
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 90008305 ] = {
    EntityId = 90008305,
    Components = {
      Effect = {
        IsHang = false,
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
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk004.prefab",
        Model = "FxZhenshizhilieMo1Atk004",
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
        Frame = 0,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
