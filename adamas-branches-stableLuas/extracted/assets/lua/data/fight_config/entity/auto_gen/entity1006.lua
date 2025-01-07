Config = Config or {}
Config.Entity1006 = Config.Entity1006 or { }
local empty = { }
Config.Entity1006 = 
{
  [ 1006 ] = {
    EntityId = 1006,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/QingmenyinR31M11/QingmenyinR31M11.prefab",
        Model = "QingmenyinR31M11",
        isClone = false,
        MinDistance = 0.15,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 1.0,
        TranslucentHeight = 1.35,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Animator = {
        Animator = "Character/Role/Female135/QingmenyinR31/QingmenyinR31M11/QingmenyinR31M11.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              AnyState = 0.0
            }
          }
        }
      },
      Behavior = {
        Behaviors = {
          "1006"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 1,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Move = {
        pivot = 0.78,
        canGlide = true,
        canShowGlideObj = true,
        GlideCost = 1.0,
        GlideHeight = 1.5,
        GlideRotationSpeed = 90.0,
        GlideDownSpeed = 1.0,
        GlideMoveSpeed = 5.0,
        GlideTurnSpeed = 3.5,
        GlideTurnBackSpeed = 3.0,
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
        ConfigName = "QingmenyinR31M11",
        LogicMoveConfigs = {
          Attack081 = 4,
          Attack080 = 4,
          ClimbingJump = 4,
          ClimbingJumpStart = 4,
          GlideFront = 2,
          GlideLeft = 2,
          GlideRight = 2,
          Gliding = 2,
          ClimbingRunStart = 4,
          ClimbingRunEnd = 4,
          CallPartnerBack = 2,
          CallPartnerFront = 2,
          Attack170 = 4,
          ClimbJumpLeft = 2,
          ClimbJumpRight = 2,
          ClimbRunLeftEnd = 2,
          ClimbRunRightEnd = 2,
          ClimbRunLeftStart = 2,
          ClimbRunRightStart = 2,
          ClimbStart2 = 4,
          ClimbJumpOver = 6,
          ClimbRunOver = 6,
          Climb = 6
        },        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
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
                LocalPosition = { 0.0, 0.85, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.85, 1.0 },
                UseMeshCollider = false
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 1.65,
        offsetX = 0.0,
        offsetY = 0.825,
        offsetZ = 0.0
      },
      Part = {
        PartList = {
          {
            Name = "Body",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 3,
                LocalPosition = { 0.0, 0.85, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.85, 1.0 },
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
        isTrigger = true
      },
      State = {
        DyingTime = 2.633,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 2.833,
        HitTime = {
          [ 1 ] = {
            Time = 1.467,
            ForceTime = 0.3,
            FusionChangeTime = 0.3,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.467,
            ForceTime = 0.3,
            FusionChangeTime = 0.3,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.767,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.767,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 0.8,
            ForceTime = 0.8,
            FusionChangeTime = 0.8,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.167,
            ForceTime = 1.167,
            FusionChangeTime = 1.167,
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
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.1,
            ForceTime = 0.1,
            FusionChangeTime = 0.1,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 1.0,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 1.0
          }
        },
      },
      Hit = {
        GravityAcceleration = -3.0,
        ReboundCoefficient = 0.0,
        ReboundTimes = 0.0,
        MinSpeed = 0.0,
        SpeedZCoefficient = 0.0,
        HitFlyHeight = 0.2,
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
          FlyHitSpeedZArmor = 1.0,
          FlyHitSpeedZArmorAcceleration = 1.0,
          FlyHitSpeedYArmor = 1.0,
          FlyHitSpeedYArmorAcceleration = 1.0,
          FlyHitSpeedYAloft = 1.0,
          FlyHitSpeedZAloft = 1.0,
          FlyHitSpeedYAccelerationAloft = 1.0
        }
      },
      Skill = {
        Skills = {
          [ 1006001 ] = {
            TotalFrame = 65,
            ForceFrame = 13,
            SkillBreakSkillFrame = 6,
            ChangeRoleFrame = 0,
            SkillType = 2,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1000,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                UseParentCost = false,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "QingmenyinR31M11Attack",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "QingmenyinR31M11_Atk001",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack001",
                  LayerIndex = 0,
                  StartFrame = 3,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 1006001002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 45.0,
                  Acceleration = -60.0,
                  MoveFrame = 2,
                  InputSpeed = 0.0,
                  MinDistance = 0.3,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                }
              },
              [ 3 ] = {
                {

                  EntityId = 100600102,
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
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  ChangeAmplitud = -0.5,
                  ChangeTime = 0.03,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  EntityId = 1006001001,
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
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 6 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 40 ] = {
                {

                  ChangeAmplitud = 0.5,
                  ChangeTime = 0.09,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
            }
          },
          [ 1006002 ] = {
            TotalFrame = 141,
            ForceFrame = 34,
            SkillBreakSkillFrame = 25,
            ChangeRoleFrame = 0,
            SkillType = 2,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "QingmenyinR31M11_Atk002",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack002",
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

                  IsAdd = 1,
                  Quality = 3,
                  Intensity = 0.3,
                  Clamp = 10.0,
                  UseMask = false,
                  Duration = 18,
                  LifeBind = true,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 34,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 25.0,
                  Acceleration = -30.0,
                  MoveFrame = 3,
                  InputSpeed = 0.0,
                  MinDistance = 1.0,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                }
              },
              [ 7 ] = {
                {

                  EntityId = 100600201,
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
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  MagicId = 1006002005,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  MagicId = 1006002006,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 1006002001,
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
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  ChangeAmplitud = -0.8,
                  ChangeTime = 0.03,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 100600202,
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
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 1006002002,
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
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 20 ] = {
                {

                  ChangeAmplitud = 0.8,
                  ChangeTime = 0.03,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 23 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.2,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.231,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = 0.0,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.231,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 23,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                }
              },
              [ 25 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006003 ] = {
            TotalFrame = 127,
            ForceFrame = 33,
            SkillBreakSkillFrame = 28,
            ChangeRoleFrame = 0,
            SkillType = 2,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 1,
                  Sign = 1006003,
                  LastTime = 0.0,
                  LastFrame = 500,
                  IgnoreTimeScale = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,

                },
                {

                  Type = 1006003,
                  Frame = 43,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EventName = "QingmenyinR31M11_Atk003_Music",
                  LifeBindSkill = false,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EventName = "QingmenyinR31M11_Atk003",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
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
              [ 2 ] = {
                {

                  EventName = "QingmenyinR31M11_Atk003_Magic",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EntityId = 100600302,
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
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100600301,
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
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1006003001,
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
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  AddType = 1,
                  BuffId = 1006003004,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 9 ] = {
                {

                  IsAdd = 1,
                  Quality = 3,
                  Intensity = 0.6,
                  Clamp = 10.0,
                  UseMask = false,
                  Duration = 20,
                  LifeBind = false,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 34,

                }
              },
              [ 28 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006004 ] = {
            TotalFrame = 145,
            ForceFrame = 60,
            SkillBreakSkillFrame = 40,
            ChangeRoleFrame = 0,
            SkillType = 2,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 1006004002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  AddType = 1,
                  BuffId = 1006004003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 100600402,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EventName = "QingmenyinR31M11_Atk004",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EventName = "QingmenyinR31M11_Atk004_Magic",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Type = 1006003,
                  Frame = 55,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 100600401,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = true,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack004",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1006004002,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = true,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  EntityId = 1006004001,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = true,
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
                  IsBindTargetLogicPos = true,
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  ChangeAmplitud = -0.7,
                  ChangeTime = 0.03,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 29 ] = {
                {

                  ChangeAmplitud = 0.7,
                  ChangeTime = 0.03,
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 33 ] = {
                {

                  ChangeAmplitud = -0.6,
                  ChangeTime = 0.03,
                  FrameTime = 33,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 34 ] = {
                {

                  ChangeAmplitud = 0.6,
                  ChangeTime = 0.03,
                  FrameTime = 34,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 37 ] = {
                {

                  ChangeAmplitud = -0.5,
                  ChangeTime = 0.03,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 38 ] = {
                {

                  ChangeAmplitud = 0.5,
                  ChangeTime = 0.03,
                  FrameTime = 38,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 40 ] = {
                {

                  AddType = 2,
                  BuffId = 1006004003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 41 ] = {
                {

                  ChangeAmplitud = -0.5,
                  ChangeTime = 0.03,
                  FrameTime = 41,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 42 ] = {
                {

                  ChangeAmplitud = 0.5,
                  ChangeTime = 0.03,
                  FrameTime = 42,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 45 ] = {
                {

                  ChangeAmplitud = -0.5,
                  ChangeTime = 0.03,
                  FrameTime = 45,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 46 ] = {
                {

                  ChangeAmplitud = 0.5,
                  ChangeTime = 0.03,
                  FrameTime = 46,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 48 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 48,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006005 ] = {
            TotalFrame = 119,
            ForceFrame = 39,
            SkillBreakSkillFrame = 31,
            ChangeRoleFrame = 0,
            SkillType = 2,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  ChangeAmplitud = 0.5,
                  ChangeTime = 0.03,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  Type = 1006003,
                  Frame = 30,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EventName = "QingmenyinR31M11_Atk005",
                  LifeBindSkill = true,
                  StopDelayFrame = 5,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack005",
                  LayerIndex = 0,
                  StartFrame = 3,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100600501,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = true,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  MagicId = 1006005002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 11 ] = {
                {

                  EntityId = 100600503,
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
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 100600502,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = true,
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
                  IsBindTargetLogicPos = true,
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.4,
                    Dir = 0,
                    Radius = 0.2,
                    Alpha = 1.0,
                    AlphaCurveId = 100600501,
                    Direction = 0,
                    Count = 6,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 9,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                },
                {

                  EntityId = 1006005001,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = true,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.4,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.2,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.21,
                      FrequencyChangeTime = 0.21,
                      DurationTime = 0.33,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.6,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.15,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.198,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                },
                {

                  ChangeAmplitud = -0.8,
                  ChangeTime = 0.09,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 18 ] = {
                {

                  Type = 600000010,
                  Frame = 1,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 21 ] = {
                {

                  PostProcessType = -1,
                  PostProcessParams = {
                    EnterTime = 5,
                    ExitTime = 10,
                    ColorFilter = { 0.188679218, 0.188679218, 0.188679218, 1.0 },
                    StencilRef = 4.0,
                    ReadMask = 255.0,
                    WriteMask = 255.0,
                    StencilCompare = 5,
                    ShowTemplateID = false,
                    TemplateID = 600000010,
                    PostProcessType = -1,
                    Duration = 25,
                    ID = 30
                  },
                  LifeBindSkill = true,
                  FrameTime = 21,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 30 ] = {
                {

                  Type = 2,
                  Sign = 1006003,
                  LastTime = 0.0,
                  LastFrame = 1,
                  IgnoreTimeScale = false,
                  FrameTime = 30,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,

                }
              },
              [ 50 ] = {
                {

                  ChangeAmplitud = 0.8,
                  ChangeTime = 0.03,
                  FrameTime = 50,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 59 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 59,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 897 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 3,
                  DurationTime = 1.45,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.0,
                  CameraOffsets = {
                    PositionY = {
                      CurveId = 100100512,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 897,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                }
              },
              [ 898 ] = {
                {

                  ReboundFrame = 4,
                  ReboundDegrees = {
                    {
                      startDegree = -90,
                      endDegree = 90
                    }
                  },
                  FrameTime = 898,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 13,

                }
              },
              [ 909 ] = {
                {

                  ReboundFrame = 3,
                  ReboundDegrees = {
                    {
                      startDegree = -90,
                      endDegree = 90
                    }
                  },
                  FrameTime = 909,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 13,

                }
              },
              [ 921 ] = {
                {

                  Type = 600000008,
                  Frame = 1,
                  FrameTime = 921,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 923 ] = {
                {

                  Type = 600000007,
                  Frame = 1,
                  FrameTime = 923,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006011 ] = {
            TotalFrame = 89,
            ForceFrame = 44,
            SkillBreakSkillFrame = 22,
            ChangeRoleFrame = 30,
            SkillType = 4,
            SkillSign = 10,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1001,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#ea5a5a",
                UseCostMode = 4,
                UseParentCost = false,
                ChargeTimes = 3,
                ChargeCdTime = 1.5,
                RecoverCount = 1,
                RecoverCostType = 1201,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_SkillPanel_jiuxu.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "QingmenyinR31M11Skill1",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack011",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  ChangeAmplitud = -1.5,
                  ChangeTime = 0.495,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  Type = 1006011,
                  Frame = 44,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.5,
                    Dir = 0,
                    Radius = 0.4,
                    Alpha = 1.0,
                    AlphaCurveId = 100601102,
                    Direction = 0,
                    Count = 3,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 14,
                    ID = 0
                  },
                  LifeBindSkill = true,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                },
                {

                  EntityId = 100601101,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EventName = "QingmenyinR31M11_Atk011",
                  LifeBindSkill = false,
                  StopDelayFrame = 5,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 1006011002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 3 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 15.0,
                  Acceleration = 0.0,
                  MoveFrame = 10,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                },
                {

                  AddType = 1,
                  BuffId = 1006011004,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1006011002,
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
                  FrameTime = 4,
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
                  Acceleration = -30.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                }
              },
              [ 5 ] = {
                {

                  EntityId = 1006011001,
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
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 16 ] = {
                {

                  ChangeAmplitud = 1.5,
                  ChangeTime = 0.099,
                  FrameTime = 16,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 1006011003,
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
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 1006010,
                  Frame = 15,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 600000010,
                  Frame = 1,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 44 ] = {
                {

                  AddType = 2,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 44,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 52 ] = {
                {

                  AddType = 2,
                  BuffId = 1006011004,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 52,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 900 ] = {
                {

                  EntityId = 100601102,
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
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  PostProcessType = -1,
                  PostProcessParams = {
                    EnterTime = 5,
                    ExitTime = 10,
                    ColorFilter = { 0.188679218, 0.188679218, 0.188679218, 1.0 },
                    StencilRef = 4.0,
                    ReadMask = 255.0,
                    WriteMask = 255.0,
                    StencilCompare = 5,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = -1,
                    Duration = 25,
                    ID = 30
                  },
                  LifeBindSkill = true,
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,
                  ActiveSign = {
                    Sign = {
                      610040
                    },
                  }
                },
                {

                  EntityId = 100601102,
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
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 999 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 11,
                  DurationTime = 5.0,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.2,
                  CameraFixeds = {
                    PositionZ = {
                      CurveId = 100601101,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,

                }
              },
            }
          },
          [ 1006012 ] = {
            TotalFrame = 93,
            ForceFrame = 36,
            SkillBreakSkillFrame = 36,
            ChangeRoleFrame = 36,
            SkillType = 4,
            SkillSign = 10,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1001,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#ea5a5a",
                UseCostMode = 4,
                UseParentCost = false,
                ChargeTimes = 3,
                ChargeCdTime = 1.5,
                RecoverCount = 1,
                RecoverCostType = 1201,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "QingmenyinR31M11Skill2",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1006011006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      1006011006
                    },
                  }
                },
                {

                  Type = 1006012,
                  Frame = 50,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EventName = "QingmenyinR31M11_Atk012",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EntityId = 100601205,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  AddType = 1,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "Attack012",
                  LayerIndex = 0,
                  StartFrame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  MagicId = 1006012003,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 2 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 25.0,
                  Acceleration = -30.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 0.7,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                },
                {

                  CameraShake = {
                    {
                      ShakeType = 6,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.5,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.0,
                      AmplitudeChangeTime = 0.297,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.0,
                      AmplitudeChangeTime = 0.297,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.165,
                      DurationTime = 0.165,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 7 ] = {
                {

                  MagicId = 1006012004,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  EntityId = 1006012001,
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
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100601201,
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
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 11 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 9,
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 17 ] = {
                {

                  MagicId = 1006012004,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 19 ] = {
                {

                  EntityId = 100601202,
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
                  FrameTime = 19,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 1006012002,
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
                  FrameTime = 19,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  Type = 1006010,
                  Frame = 15,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 36 ] = {
                {

                  AddType = 2,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 36,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 40 ] = {
                {

                  AddType = 2,
                  BuffId = 1006011006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 40,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      1006011006
                    },
                  }
                }
              },
              [ 900 ] = {
                {

                  PostProcessType = -1,
                  PostProcessParams = {
                    EnterTime = 5,
                    ExitTime = 10,
                    ColorFilter = { 0.188679218, 0.188679218, 0.188679218, 1.0 },
                    StencilRef = 4.0,
                    ReadMask = 255.0,
                    WriteMask = 255.0,
                    StencilCompare = 5,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = -1,
                    Duration = 25,
                    ID = 30
                  },
                  LifeBindSkill = true,
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,
                  ActiveSign = {
                    Sign = {
                      610040
                    },
                  }
                },
                {

                  EntityId = 100601203,
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
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100601204,
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
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 922 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 1.0,
                  UseTimescale = true,
                  EaseInTime = 0.099,
                  EaseOutTime = 0.3,
                  CameraOffsets = {
                    RotationX = {
                      CurveId = 100601204,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 922,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                },
                {

                  ChangeAmplitud = 1.0,
                  ChangeTime = 0.12,
                  FrameTime = 922,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 999 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 12,
                  DurationTime = 2.5,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.4,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 100601201,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                }
              },
            }
          },
          [ 1006013 ] = {
            TotalFrame = 105,
            ForceFrame = 80,
            SkillBreakSkillFrame = 80,
            ChangeRoleFrame = 80,
            SkillType = 4,
            SkillSign = 10,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1001,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#ea5a5a",
                UseCostMode = 4,
                UseParentCost = false,
                ChargeTimes = 3,
                ChargeCdTime = 1.5,
                RecoverCount = 1,
                RecoverCostType = 1201,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "QingmenyinR31M11Skill3",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack013",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1006011006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      1006011006
                    },
                  }
                },
                {

                  EventName = "QingmenyinR31M11_Atk013",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Type = 1006013,
                  Frame = 95,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 100601302,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  EntityId = 100601304,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 1006013001,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.4,
                      StartFrequency = 4.0,
                      TargetAmplitude = -0.2,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.21,
                      FrequencyChangeTime = 0.21,
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
                      StartAmplitude = 0.3,
                      StartFrequency = 4.0,
                      TargetAmplitude = 0.15,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.198,
                      DurationTime = 0.231,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 42 ] = {
                {

                  EntityId = 1006013003,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -1.017,
                  BornOffsetY = 1.167,
                  BornOffsetZ = 0.408,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -15.0,
                  BornRotateOffsetY = 30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
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
              [ 44 ] = {
                {

                  EntityId = 1006013004,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.273,
                  BornOffsetY = 1.695,
                  BornOffsetZ = 1.362,
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
                  FrameTime = 44,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 46 ] = {
                {

                  EntityId = 1006013005,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.786,
                  BornOffsetY = 2.048,
                  BornOffsetZ = 1.158,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = -30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 46,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 48 ] = {
                {

                  EntityId = 1006013006,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 1.116,
                  BornOffsetY = 1.112,
                  BornOffsetZ = 0.601,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 15.0,
                  BornRotateOffsetY = -30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 48,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 50 ] = {
                {

                  EntityId = 1006013007,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.684,
                  BornOffsetY = 0.886,
                  BornOffsetZ = 0.345,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -15.0,
                  BornRotateOffsetY = -30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
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
              [ 64 ] = {
                {

                  EntityId = 100601305,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 64,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 79 ] = {
                {

                  EntityId = 1006013009,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 79,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 80 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 80,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 2,
                  BuffId = 1006011006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 80,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      1006011006
                    },
                  }
                },
                {

                  Type = 10000013,
                  Frame = 15,
                  FrameTime = 80,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 2,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 80,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 900 ] = {
                {

                  PostProcessType = -1,
                  PostProcessParams = {
                    EnterTime = 5,
                    ExitTime = 10,
                    ColorFilter = { 0.188679218, 0.188679218, 0.188679218, 1.0 },
                    StencilRef = 4.0,
                    ReadMask = 255.0,
                    WriteMask = 255.0,
                    StencilCompare = 5,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = -1,
                    Duration = 25,
                    ID = 30
                  },
                  LifeBindSkill = true,
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,
                  ActiveSign = {
                    Sign = {
                      610040
                    },
                  }
                }
              },
              [ 915 ] = {
                {

                  EntityId = 1006013002,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  IsBindTargetPosGround = true,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 915,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 1006021 ] = {
            TotalFrame = 138,
            ForceFrame = 68,
            SkillBreakSkillFrame = 55,
            ChangeRoleFrame = 55,
            SkillType = 8,
            SkillSign = 40,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1006060,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EventName = "QingmenyinR31M11_Atk021",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  AddType = 1,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 600000008,
                  Frame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 1006001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 100602103,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 138,
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

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 3.0,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.246,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 10060021,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                },
                {

                  Name = "Attack021",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  AddType = 2,
                  BuffId = 1006060,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 100602104,
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
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  EntityId = 100602106,
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
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  MagicId = 1006003,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 28 ] = {
                {

                  Type = 1000091,
                  Frame = 1,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 100602101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 110,
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
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 1006021001,
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
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.8,
                      StartFrequency = 4.0,
                      TargetAmplitude = -0.1,
                      TargetFrequency = 8.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.298,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.0,
                      StartFrequency = 4.0,
                      TargetAmplitude = 0.3,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.18,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 33 ] = {
                {

                  Type = 1006020,
                  Frame = 1,
                  FrameTime = 33,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 53 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 53,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 2,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 53,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 54 ] = {
                {

                  EntityId = 100602102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 80,
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
                  FrameTime = 54,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 1006022 ] = {
            TotalFrame = 137,
            ForceFrame = 43,
            SkillBreakSkillFrame = 22,
            ChangeRoleFrame = 22,
            SkillType = 0,
            SkillSign = 40,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1000,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                UseParentCost = false,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "Partner64",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack022",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 20 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 22 ] = {
                {

                  Type = 1006022,
                  Frame = 1,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006023 ] = {
            TotalFrame = 92,
            ForceFrame = 77,
            SkillBreakSkillFrame = 59,
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

                  Name = "Attack023",
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
          [ 1006024 ] = {
            TotalFrame = 114,
            ForceFrame = 44,
            SkillBreakSkillFrame = 34,
            ChangeRoleFrame = 10,
            SkillType = 0,
            SkillSign = 40,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  PostProcessType = -1,
                  PostProcessParams = {
                    EnterTime = 5,
                    ExitTime = 10,
                    ColorFilter = { 0.188679218, 0.188679218, 0.188679218, 1.0 },
                    StencilRef = 4.0,
                    ReadMask = 255.0,
                    WriteMask = 255.0,
                    StencilCompare = 5,
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = -1,
                    Duration = 25,
                    ID = 30
                  },
                  LifeBindSkill = true,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,
                  ActiveSign = {
                    Sign = {
                      610040
                    },
                  }
                },
                {

                  Type = 600000008,
                  Frame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 1006001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 3.0,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.246,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 10060021,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  Name = "Attack021",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 3 ] = {
                {

                  MagicId = 1000093,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  EntityId = 100602106,
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
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 9 ] = {
                {

                  MagicId = 1000091,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 100602101,
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
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.4,
                      StartFrequency = 4.0,
                      TargetAmplitude = -0.1,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.24,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 4.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.21,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                },
                {

                  Type = 1006020,
                  Frame = 1,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 1006021001,
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
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 100602104,
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
                  FrameTime = 27,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  AddType = 2,
                  BuffId = 1006002,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 34,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 35 ] = {
                {

                  EntityId = 100602102,
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
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 1006030 ] = {
            TotalFrame = 50,
            ForceFrame = 10,
            SkillBreakSkillFrame = 10,
            SkillType = 0,
            SkillSign = 30,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1004,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                UseParentCost = false,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "",
                CastEffectPath = "",
                DodgeEffectPath = "Effect/UI/22003.prefab",
                SkillIcon = "Dodge",
                BehaviorConfig = 80,
                LayerConfig = 258
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Frame = 12,
                  RingCount = 7,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 6,

                },
                {

                  Type = 10000007,
                  Frame = 12,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Name = "Move01",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  ChangeAmplitud = -0.8,
                  ChangeTime = 0.24,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  IsAdd = 1,
                  Quality = 3,
                  Intensity = 0.3,
                  Clamp = 5.0,
                  UseMask = false,
                  Duration = 9,
                  LifeBind = true,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 34,

                }
              },
              [ 8 ] = {
                {

                  Type = 10000006,
                  Frame = 1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006031 ] = {
            TotalFrame = 84,
            ForceFrame = 18,
            SkillBreakSkillFrame = 15,
            ChangeRoleFrame = 12,
            SkillType = 256,
            SkillSign = 31,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "QingmenyinR31M11_Move02",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EntityId = 100603101,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Move02",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Type = 10000007,
                  Frame = 18,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10020000,
                  Frame = 88,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Frame = 18,
                  RingCount = 7,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 6,

                }
              },
              [ 1 ] = {
                {

                  IsAdd = 1,
                  Quality = 3,
                  Intensity = 0.3,
                  Clamp = 5.0,
                  UseMask = false,
                  Duration = 9,
                  LifeBind = true,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 34,

                },
                {

                  ChangeAmplitud = 0.8,
                  ChangeTime = 0.24,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 12 ] = {
                {

                  Type = 10000010,
                  Frame = 1,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  AddType = 1,
                  BuffId = 1002030,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 1006051 ] = {
            TotalFrame = 225,
            ForceFrame = 189,
            SkillBreakSkillFrame = 189,
            ChangeRoleFrame = 189,
            SkillType = 16,
            SkillSign = 50,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1003,
                CDtime = 20.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1653,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#cc75fe",
                UseCostMode = 1,
                UseParentCost = false,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_fight_R_mu.Prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "QingmenyinR31M11Ultimate",
                ElementIconType = "mu",
                BehaviorConfig = 51,
                LayerConfig = 227
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  ShowFightUI = false,
                  IsHighestPriority = false,
                  Frame = 189,
                  BindSkill = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 27,

                },
                {

                  EntityId = 100605102,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1006052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "Attack051",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  ShieldShake = true,
                  ShieldShakeParams = {
                    DurationFrame = 0,
                    BindSkill = false
                  },
                  ShieldShakeType = 1,
                  ShieldPauseFrame = true,
                  ShieldPauseFrameParams = {
                    DurationFrame = 0,
                    BindSkill = false
                  },
                  ShieldPauseFrameType = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 30,

                },
                {

                  AddType = 1,
                  BuffId = 1006054,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EventName = "QingmenyinR31M11_Atk051",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  AddType = 1,
                  BuffId = 1006053,
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

                  MagicId = 1006055,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 100605104,
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
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 100605105,
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
                  FrameTime = 33,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  EntityId = 100605101,
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
                  FrameTime = 36,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 50 ] = {
                {

                  EntityId = 1006051001,
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
                  FrameTime = 50,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 56 ] = {
                {

                  EntityId = 100605106,
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
                  FrameTime = 56,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 70 ] = {
                {

                  EntityId = 1006051005,
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
                  FrameTime = 70,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 82 ] = {
                {

                  EntityId = 100605108,
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
                  FrameTime = 82,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 83 ] = {
                {

                  EntityId = 100605107,
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
                  FrameTime = 83,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 90 ] = {
                {

                  EntityId = 1006051009,
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
                  FrameTime = 90,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 106 ] = {
                {

                  EntityId = 1006051010,
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
                  FrameTime = 106,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 118 ] = {
                {

                  EntityId = 1006051002,
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
                  FrameTime = 118,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 122 ] = {
                {

                  EntityId = 1006051003,
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
                  FrameTime = 122,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 150 ] = {
                {

                  EntityId = 1006051006,
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
                  FrameTime = 150,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 152 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 2.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.4,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.396,
                      FrequencyChangeTime = 0.363,
                      DurationTime = 0.495,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.396,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 152,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 153 ] = {
                {

                  EntityId = 1006051004,
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
                  FrameTime = 153,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 155 ] = {
                {

                  EntityId = 1006051011,
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
                  FrameTime = 155,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 189 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 189,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000012,
                  Frame = 1,
                  FrameTime = 189,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 9211 ] = {
                {

                  Type = 100605101,
                  Frame = 1,
                  FrameTime = 9211,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006052 ] = {
            TotalFrame = 30,
            ForceFrame = 30,
            SkillBreakSkillFrame = 30,
            ChangeRoleFrame = 30,
            SkillType = 32,
            SkillSign = 52,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack051",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1006052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1006054,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 20 ] = {
                {

                  Type = 10000009,
                  Frame = 1,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006060 ] = {
            TotalFrame = 50,
            ForceFrame = 50,
            SkillType = 0,
            SkillSign = 600,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000015,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "CallPartnerFront",
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
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 1000051,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 600000002,
                  Frame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 16 ] = {
                {

                  MagicId = 1000048,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 16,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
            }
          },
          [ 1006061 ] = {
            TotalFrame = 68,
            ForceFrame = 20,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 16,
            SkillType = 0,
            SkillSign = 601,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000016,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 600000063,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "CallPartnerFront",
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

                  EntityId = 600000005,
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
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 7 ] = {
                {

                  Type = 600000019,
                  Frame = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 600000012,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 10 ] = {
                {

                  Type = 600000002,
                  Frame = 1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 13 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.7,
                    Dir = 0,
                    Radius = 0.28,
                    Alpha = 1.0,
                    AlphaCurveId = 100000033,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 10,
                    ID = 0
                  },
                  LifeBindSkill = true,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                },
                {

                  AddType = 1,
                  BuffId = 600000003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 1006062 ] = {
            TotalFrame = 65,
            ForceFrame = 20,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 16,
            SkillType = 0,
            SkillSign = 602,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000016,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 600000007,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "CallPartnerBack",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 600000071,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 600000005,
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
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  AddType = 1,
                  BuffId = 600000012,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 10 ] = {
                {

                  Type = 600000002,
                  Frame = 1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 13 ] = {
                {

                  AddType = 1,
                  BuffId = 600000003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.7,
                    Dir = 0,
                    Radius = 0.28,
                    Alpha = 1.0,
                    AlphaCurveId = 100000033,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 10,
                    ID = 0
                  },
                  LifeBindSkill = true,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                }
              },
            }
          },
          [ 1006063 ] = {
            TotalFrame = 60,
            ForceFrame = 40,
            SkillBreakSkillFrame = 10,
            SkillType = 0,
            SkillSign = 603,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000016,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "CallPartnerFront",
                  LayerIndex = 0,
                  StartFrame = 10,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 1.0,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.5,
                  CameraFixeds = {
                    PositionZ = {
                      CurveId = 100000038,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,

                }
              },
              [ 2 ] = {
                {

                  Name = "CallPartnerFront",
                  LayerIndex = 0,
                  StartFrame = 12,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 3 ] = {
                {

                  ChangeAmplitud = -2.0,
                  ChangeTime = 0.06,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 4 ] = {
                {

                  Name = "CallPartnerFront",
                  LayerIndex = 0,
                  StartFrame = 14,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 600000005,
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
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  ChangeAmplitud = 2.0,
                  ChangeTime = 0.06,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 6 ] = {
                {

                  Name = "CallPartnerFront",
                  LayerIndex = 0,
                  StartFrame = 17,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 7 ] = {
                {

                  AddType = 1,
                  BuffId = 600000074,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 8 ] = {
                {

                  Type = 600000002,
                  Frame = 1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 10 ] = {
                {

                  AddType = 1,
                  BuffId = 600000077,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 904 ] = {
                {

                  AddType = 1,
                  BuffId = 600000003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 904,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 600000019,
                  Frame = 1,
                  FrameTime = 904,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006064 ] = {
            TotalFrame = 50,
            ForceFrame = 35,
            SkillBreakSkillFrame = 10,
            SkillType = 0,
            SkillSign = 604,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000016,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "CallPartnerBack",
                  LayerIndex = 0,
                  StartFrame = 9,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 1.0,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.5,
                  CameraFixeds = {
                    PositionZ = {
                      CurveId = 100000038,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,

                }
              },
              [ 2 ] = {
                {

                  Name = "CallPartnerBack",
                  LayerIndex = 0,
                  StartFrame = 11,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 3 ] = {
                {

                  ChangeAmplitud = -2.0,
                  ChangeTime = 0.06,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  Name = "CallPartnerBack",
                  LayerIndex = 0,
                  StartFrame = 13,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 600000005,
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
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  ChangeAmplitud = 2.0,
                  ChangeTime = 0.06,
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 7 ] = {
                {

                  AddType = 1,
                  BuffId = 600000074,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 8 ] = {
                {

                  Type = 600000002,
                  Frame = 1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 10 ] = {
                {

                  AddType = 1,
                  BuffId = 600000077,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 904 ] = {
                {

                  AddType = 1,
                  BuffId = 600000003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 904,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 600000019,
                  Frame = 1,
                  FrameTime = 904,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006080 ] = {
            TotalFrame = 39,
            ForceFrame = 39,
            SkillBreakSkillFrame = 39,
            ChangeRoleFrame = 39,
            SkillType = 1024,
            SkillSign = 80,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 1,
                  Sign = 10000033,
                  LastTime = 0.0,
                  LastFrame = 39,
                  IgnoreTimeScale = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
                },
                {

                  Name = "Attack080",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 39.0,
                  MaxFallSpeed = 0.0,
                  SaveSpeed = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                },
                {

                  AddType = 1,
                  BuffId = 1000034,
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
                  SpeedOffset = 7200.0,
                  Acceleration = 0.0,
                  RotateFrame = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  DisableWithoutTarget = false,
                  PauseAnimationMove = false,
                  BoneName = "Bip001 Head",
                  DurationUpdateTargetFrame = 5,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.5,
                  TargetVPositionOffset = 0.3,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 18,

                },
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 6.0,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.0,
                  CameraFixeds = {
                    PositionZ = {
                      CurveId = 100000016,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,
                  ActiveSign = {
                    Sign = {
                      10000002
                    },
                  }
                }
              },
              [ 7 ] = {
                {

                  EntityId = 1000000019,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = -1,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = -1.0,
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
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 1000000016,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
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
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EventName = "tiaofan",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 900 ] = {
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 6.0,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.3,
                  CameraFixeds = {
                    PositionY = {
                      CurveId = 100000015,
                      CameraOffsetReferType = 0
                    },
                    PositionZ = {
                      CurveId = 100000009,
                      CameraOffsetReferType = 0
                    },
                    RotationX = {
                      CurveId = 100000008,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
                }
              },
            }
          },
          [ 1006081 ] = {
            TotalFrame = 48,
            ForceFrame = 48,
            SkillBreakSkillFrame = 48,
            ChangeRoleFrame = 48,
            SkillType = 2048,
            SkillSign = 81,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Type = 1,
                  Sign = 10000033,
                  LastTime = 0.0,
                  LastFrame = 48,
                  IgnoreTimeScale = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
                },
                {

                  EventName = "QingmenyinR31M11_Atk081",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack081",
                  LayerIndex = 0,
                  StartFrame = 2,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 7200.0,
                  Acceleration = 0.0,
                  RotateFrame = 3,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 1006080,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 36.0,
                  MaxFallSpeed = 0.0,
                  SaveSpeed = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                }
              },
              [ 3 ] = {
                {

                  DisableWithoutTarget = false,
                  PauseAnimationMove = false,
                  BoneName = "Bip001 Head",
                  DurationUpdateTargetFrame = 5,
                  OffsetType = 2,
                  TargetHPositionOffset = 1.5,
                  TargetVPositionOffset = 1.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 60.0,
                  MinSpeed = 0.0,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 18,

                }
              },
              [ 11 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.07,
                      TargetFrequency = 15.0,
                      AmplitudeChangeTime = 0.76,
                      FrequencyChangeTime = 0.5,
                      DurationTime = 0.76,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.03,
                      TargetFrequency = 15.0,
                      AmplitudeChangeTime = 0.76,
                      FrequencyChangeTime = 0.5,
                      DurationTime = 0.76,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.03,
                      TargetFrequency = 15.0,
                      AmplitudeChangeTime = 0.76,
                      FrequencyChangeTime = 0.5,
                      DurationTime = 0.76,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                },
                {

                  EntityId = 1006081003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 2,
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
                  IsBindTargetLogicPos = true,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 26 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.4,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.2,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.21,
                      FrequencyChangeTime = 0.21,
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
                      StartAmplitude = 0.3,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.15,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.198,
                      DurationTime = 0.231,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 26,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                },
                {

                  EntityId = 1006081002,
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
                  FrameTime = 26,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 37 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = true,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 21.0,
                  MaxFallSpeed = -999.0,
                  SaveSpeed = false,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                }
              },
              [ 888 ] = {
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 0.5,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.2,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 100208102,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 888,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
                }
              },
              [ 900 ] = {
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 1.5,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 1.0,
                  CameraFixeds = {
                    PositionY = {
                      CurveId = 100608101,
                      CameraOffsetReferType = 0
                    },
                    RotationX = {
                      CurveId = 100608105,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,
                  ActiveSign = {
                    Sign = {
                      10000002
                    },
                  }
                },
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 0.5,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.2,
                  CameraOffsets = {
                    RotationX = {
                      CurveId = 100608103,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
                }
              },
            }
          },
          [ 1006090 ] = {
            TotalFrame = 68,
            ForceFrame = 20,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 16,
            SkillType = 0,
            SkillSign = 90,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1000016,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 600000063,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "CallPartnerFront",
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

                  EntityId = 1000000021,
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
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 7 ] = {
                {

                  Type = 600000019,
                  Frame = 1,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 13 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.7,
                    Dir = 0,
                    Radius = 0.28,
                    Alpha = 1.0,
                    AlphaCurveId = 100000033,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 10,
                    ID = 0
                  },
                  LifeBindSkill = true,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                },
                {

                  AddType = 1,
                  BuffId = 600000003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 1000000022,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "Bip001 R Hand",
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
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 1006170 ] = {
            TotalFrame = 16,
            ForceFrame = 16,
            SkillBreakSkillFrame = 16,
            SkillType = 8192,
            SkillSign = 170,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EntityId = 100617002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100617001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack170",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 18.0,
                  MaxFallSpeed = -3.40282347E+38,
                  SaveSpeed = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                },
                {

                  EventName = "QingmenyinR31M11_Atk170",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 6 ] = {
                {

                  Type = 600000010,
                  Frame = 1,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 15 ] = {
                {

                  Type = 10000008,
                  Frame = 1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006171 ] = {
            TotalFrame = 999999,
            ForceFrame = 999999,
            SkillBreakSkillFrame = 999999,
            SkillType = 16384,
            SkillSign = 171,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EntityId = 100617101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 999999,
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

                  IsAdd = 1,
                  Quality = 3,
                  Intensity = 0.15,
                  Clamp = 10.0,
                  UseMask = false,
                  Duration = 999999,
                  LifeBind = true,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 34,

                },
                {

                  Name = "Attack171",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Type = 10000008,
                  Frame = 999999,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = -30.0,
                  AccelerationY = 0.0,
                  Duration = 9999999.0,
                  MaxFallSpeed = -30.0,
                  SaveSpeed = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 12,

                },
                {

                  ChangeAmplitud = 0.5,
                  ChangeTime = 0.03,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  EventName = "QingmenyinR31M11_Atk171",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
            }
          },
          [ 1006172 ] = {
            TotalFrame = 86,
            ForceFrame = 12,
            SkillBreakSkillFrame = 12,
            ChangeRoleFrame = 6,
            SkillType = 32768,
            SkillSign = 172,
            IsLanding = true,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  ChangeAmplitud = -0.5,
                  ChangeTime = 0.1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  IsAdd = 1,
                  Quality = 3,
                  Intensity = 0.3,
                  Clamp = 10.0,
                  UseMask = false,
                  Duration = 3,
                  LifeBind = true,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 34,

                },
                {

                  Name = "Attack172",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100617201,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EventName = "QingmenyinR31M11_Atk172",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 1006172001,
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
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 6 ] = {
                {

                  Type = 600000010,
                  Frame = 1,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  Type = 10000011,
                  Frame = 3,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006901 ] = {
            TotalFrame = 95,
            ForceFrame = 13,
            SkillBreakSkillFrame = 6,
            ChangeRoleFrame = 0,
            SkillType = 0,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1000,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 1,
                UseParentCost = false,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "XumuR11Attack",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack001",
                  LayerIndex = 0,
                  StartFrame = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  MagicId = 1006001002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 100600101,
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
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 45.0,
                  Acceleration = -60.0,
                  MoveFrame = 3,
                  InputSpeed = 0.0,
                  MinDistance = 0.3,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                }
              },
              [ 4 ] = {
                {

                  EntityId = 1006001001,
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
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 6 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 8 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006911 ] = {
            TotalFrame = 89,
            ForceFrame = 34,
            SkillBreakSkillFrame = 22,
            ChangeRoleFrame = 22,
            SkillType = 0,
            SkillSign = 10,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EntityId = 100601101,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack011",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Type = 1006011,
                  Frame = 37,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 1006011002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 3 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 15.0,
                  Acceleration = 0.0,
                  MoveFrame = 10,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 4 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 25.0,
                  Acceleration = -30.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                }
              },
              [ 5 ] = {
                {

                  EntityId = 1006011001,
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
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  Type = 1006010,
                  Frame = 15,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 22,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 999 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 11,
                  DurationTime = 5.0,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.2,
                  CameraFixeds = {
                    PositionZ = {
                      CurveId = 100601101,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 21,

                }
              },
            }
          },
          [ 1006912 ] = {
            TotalFrame = 93,
            ForceFrame = 36,
            SkillBreakSkillFrame = 36,
            ChangeRoleFrame = 36,
            SkillType = 0,
            SkillSign = 10,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 1006012003,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  Name = "Attack012",
                  LayerIndex = 0,
                  StartFrame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Type = 1006012,
                  Frame = 50,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 100601201,
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
              [ 2 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 6,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.5,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.0,
                      AmplitudeChangeTime = 0.297,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.0,
                      AmplitudeChangeTime = 0.297,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 1.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.0,
                      AmplitudeChangeTime = 0.165,
                      FrequencyChangeTime = 0.165,
                      DurationTime = 0.165,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 25.0,
                  Acceleration = -30.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 0.7,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                }
              },
              [ 5 ] = {
                {

                  EntityId = 1006012001,
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
                  FrameTime = 5,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 9 ] = {
                {

                  MagicId = 1006012004,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 11 ] = {
                {

                  EntityId = 100601202,
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
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  MagicId = 1006012004,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 1006012002,
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
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 1006010,
                  Frame = 15,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 999 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 12,
                  DurationTime = 2.5,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.4,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 100601201,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                }
              },
            }
          }
        }
      },
      SkillSet = {
        UISets = {
          [ 1 ] = {
            ShowId = 1,
            UISetNote = "",
            CoreUIConfig = {
              BindRes = 1204,
              UIPath = "Prefabs/UI/Fight/CoreRes/CoreUI1006.prefab",
              Scale = 1.0,
              LocationOffset = { 0.0, 0.825, 0.0 },
              ScreenOffset = { -120.0, 80.0, 0.0 }
            },
            J = {
              Active = true,
              SkillId = 1006001,
              SkillIcon = "0"
            },
            K = {
              Active = true,
              SkillId = 1006030,
              SkillIcon = "XumuR11Move"
            },
            L = {
              Active = true,
              SkillId = 1006051,
              SkillIcon = "Diyue"
            },
            I = {
              Active = true,
              SkillId = 1006011,
              SkillIcon = "XumuR11BlueSkill"
            },
            O = {
              Active = true,
              SkillId = 0,
              SkillIcon = "Jump"
            },
            R = {
              Active = false,
              SkillId = 1001998,
              SkillIcon = "XumuR11UltimateSkill"
            },
            F = {
              Active = false,
              SkillId = 0,

            },
            PartnerSkill = {
              Active = true,
              SkillId = 0,

            },          }
        }
      },
      Dodge = {
        [ "_debugLimitCoolingTime" ] = 15
      },
      HandleMoveInput = empty,
      Buff = empty,
      Attributes = {
        DefaultAttrID = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Climb = {
        ClimbStrengthCost = 0.0,
        JumpStrengthCost = 0.0,
        ClimbSpeed = 0.0,
        ClimbJumpSpeed = 0.0,
        ClimbCharacterHeight = 135,
        ClimbCapsuleRadius = 0.25,
        ClimbCapsuleHeight = 0.8,
        ClimbCapsuleOffsetY = 1.0,
        ClimbStrideOverOffset = 1.3,
        ClimbJumpOverOffset = 1.2,
        ClimbRunOverOffset = 1.2,
        StrideOverHeight = 0.0
      },
      Swim = {
        SwimHeightInterval = 1.1
      },
      Death = {
        DeathList = {
          {
            DeathReason = 2,
            DeathTime = -1.0,
            deathCondition = {
              TerrainDeathList = {
                {
                  TerrainDeath = 20,
                  TerrainDeathHeight = 1.5,
                  TerrainDeathTime = -1.0,
                  AccelerationY = -1.2
                }
              },
            }
          },
          {
            DeathReason = 1,
            DeathTime = 2.0,
            deathCondition = {
              DrownHeight = 999.0,
              CheckPower = true
            }
          }
        },
      },
      ReboundAttack = empty,
      ElementState = {
        ElementType = 3,

      },
      Sound = empty,
      Ik = {
        shakeLeftFrontId = 0,
        shakeLeftBackId = 0,
        shakeRightFrontId = 0,
        shakeRightBackId = 0,
        shakeDistanceRatio = 0.0,
        workWithOutImmuneHit = false,
        Look = {
          IsLookCtrlObject = false
        },
        Looked = {
          lookTransform = "Head",
          weight = 5000
        },
      }
    }
  },
  [ 1006001001 ] = {
    EntityId = 1006001001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 5,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006001001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk001_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100600103,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 5.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = true,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.3,
              StartFrequency = 5.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 3.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = true,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.3,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006005001 ] = {
    EntityId = 1006005001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1006005001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk005_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100600504,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 1,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006004001 ] = {
    EntityId = 1006004001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 21,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 21,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = true,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = true,
        IntervalFrame = 3,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006004004
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk004_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100600403,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
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
          SpeedZ = -1.2,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedZArmor = -1.0,
          SpeedZArmorAcceleration = 0.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = -0.2,
              StartFrequency = 8.0,
              TargetAmplitude = -0.1,
              TargetFrequency = 12.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.15,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 1,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006003001 ] = {
    EntityId = 1006003001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 17,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 17,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = true,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 2.0,
        Repetition = true,
        IntervalFrame = 3,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006003001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk003_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100600303,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
          },
          {
            HitType = 2,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -3.5,
          SpeedZAcceleration = 2.0,
          SpeedZTime = 0.2,
          SpeedZArmor = -2.0,
          SpeedZArmorAcceleration = 1.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 10.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006002001 ] = {
    EntityId = 1006002001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006002001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk002_Hit01"
        },
        CreateHitEntities = {
          {
            EntityId = 100600203,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 2,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 2.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedZArmor = 2.0,
          SpeedZArmorAcceleration = -1.0,
          SpeedZArmorTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006002002 ] = {
    EntityId = 1006002002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006002002
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk002_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100600203,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 4.5,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedZArmor = 4.5,
          SpeedZArmorAcceleration = -2.0,
          SpeedZArmorTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.2,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 2.0,
              AmplitudeChangeTime = 0.18,
              FrequencyChangeTime = 0.09,
              DurationTime = 0.18,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.2,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 2.0,
              AmplitudeChangeTime = 0.18,
              FrequencyChangeTime = 0.09,
              DurationTime = 0.18,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -1.2,
              StartFrequency = 4.0,
              TargetAmplitude = -0.1,
              TargetFrequency = 2.0,
              AmplitudeChangeTime = 0.165,
              FrequencyChangeTime = 0.09,
              DurationTime = 0.165,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 3,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006004002 ] = {
    EntityId = 1006004002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        OffsetY = 1.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1006004001
        },
        CreateHitEntities = {
          {
            EntityId = 100600103,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -2.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.2,
          SpeedZArmor = -2.0,
          SpeedZArmorAcceleration = 0.0,
          SpeedZArmorTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.5,
              StartFrequency = 5.0,
              TargetAmplitude = 0.3,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006011001 ] = {
    EntityId = 1006011001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 20,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 20,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 5.0,
        Height = 2.5,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
        Repetition = true,
        IntervalFrame = 2,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006011001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk011_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100601104,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
          }
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedZArmor = 0.0,
          SpeedZArmorAcceleration = 0.0,
          SpeedZArmorTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = 0.2,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.1,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006012001 ] = {
    EntityId = 1006012001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 3,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006012001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk012_Hit01"
        },
        CreateHitEntities = {
          {
            EntityId = 100601206,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 4.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedZArmor = 4.0,
          SpeedZArmorAcceleration = -1.0,
          SpeedZArmorTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.6,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006012002 ] = {
    EntityId = 1006012002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 5,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006012002
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk012_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601207,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 4.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 20.0,
          SpeedZHitFly = 4.0,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.21,
              FrequencyChangeTime = 0.21,
              DurationTime = 0.21,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 1.2,
              StartFrequency = 4.0,
              TargetAmplitude = 0.3,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.15,
              FrequencyChangeTime = 0.15,
              DurationTime = 0.27,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 5,
            PFTimeScale = 0.02,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 4,
            TargetPFTimeScale = 0.02,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.02,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.1,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.55,
            Dir = 0,
            Radius = 0.3,
            Alpha = 1.0,
            AlphaCurveId = 100601203,
            Direction = 0,
            Count = 4,
            Center = { 0.5, 0.4 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 7,
            ID = 0
          }
        },
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013001 ] = {
    EntityId = 1006013001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 78,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 9,
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
        MagicsByTargetBeforeHit = {
          1006013001,
          1006013004
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit01"
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 2.0,
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 6,
            PFTimeScale = 1.0,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.03,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006021001 ] = {
    EntityId = 1006021001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 10.0,
        Height = 1.7,
        Width = 10.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1006021001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk021_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100600103,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 4.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 13.0,
          SpeedYAcceleration = -30.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 15.0,
          SpeedZAloft = 5.0,
          SpeedYAccelerationAloft = -20.0,
          SpeedYAccelerationTimeAloft = 0.3,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 4,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006022001 ] = {
    EntityId = 1006022001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006001001
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006023001 ] = {
    EntityId = 1006023001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        MagicsByTargetBeforeHit = {
          1006001001
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600101 ] = {
    EntityId = 100600101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001.prefab",
        Model = "FxQingmenyinR31M11Atk001",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100600201 ] = {
    EntityId = 100600201,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk002D1.prefab",
        Model = "FxQingmenyinR31M11Atk002D1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 75,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600202 ] = {
    EntityId = 100600202,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk002D2.prefab",
        Model = "FxQingmenyinR31M11Atk002D2",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 75,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600301 ] = {
    EntityId = 100600301,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk003D1.prefab",
        Model = "FxQingmenyinR31M11Atk003D1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100600302 ] = {
    EntityId = 100600302,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk003D2.prefab",
        Model = "FxQingmenyinR31M11Atk003D2",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 75,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600401 ] = {
    EntityId = 100600401,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk004.prefab",
        Model = "FxQingmenyinR31M11Atk004",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 180,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600501 ] = {
    EntityId = 100600501,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk005D1.prefab",
        Model = "FxQingmenyinR31M11Atk005D1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600502 ] = {
    EntityId = 100600502,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk005.prefab",
        Model = "FxQingmenyinR31M11Atk005",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 140,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006081001 ] = {
    EntityId = 1006081001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 16,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
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
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1000042
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 2,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006081002 ] = {
    EntityId = 1006081002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 91,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 10,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 2.0,
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
        IntervalFrame = 4,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
        MagicsByTargetBeforeHit = {
          1006081,
          1000042
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk081_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 100600103,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 10.0,
          SpeedZAcceleration = -40.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -80.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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
        SpeedCurveId = 100200101,
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
      }
    }
  },
  [ 1006081003 ] = {
    EntityId = 1006081003,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk081.prefab",
        Model = "FxQingmenyinR31M11Atk081",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 165,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 13,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = true,
        IntervalFrame = 2,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006083
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
          SpeedZ = -2.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = -0.2,
              StartFrequency = 8.0,
              TargetAmplitude = -0.1,
              TargetFrequency = 12.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.15,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 1,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100602101 ] = {
    EntityId = 100602101,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021.prefab",
        Model = "FxQingmenyinR31M11Atk021",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 84,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100602102 ] = {
    EntityId = 100602102,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021Land.prefab",
        Model = "FxQingmenyinR31M11Atk021Land",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 75,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
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
      }
    }
  },
  [ 100602103 ] = {
    EntityId = 100602103,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021R.prefab",
        Model = "FxQingmenyinR31M11Atk021R",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 54,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100602104 ] = {
    EntityId = 100602104,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021wuqi_000.prefab",
        Model = "FxQingmenyinR31M11Atk021wuqi_000",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 4.8,
        BindTransformName = "wuqi_000",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100602105 ] = {
    EntityId = 100602105,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021wuqi_001.prefab",
        Model = "FxQingmenyinR31M11Atk021wuqi_001",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100602106 ] = {
    EntityId = 100602106,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021Cure.prefab",
        Model = "FxQingmenyinR31M11Atk021Cure",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 120,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601101 ] = {
    EntityId = 100601101,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 1.0,
        BindRotationTime = 1.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011.prefab",
        Model = "FxQingmenyinR31M11Atk011",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 105,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100601201 ] = {
    EntityId = 100601201,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012D1.prefab",
        Model = "FxQingmenyinR31M11Atk012D1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 84,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100601202 ] = {
    EntityId = 100601202,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012D2.prefab",
        Model = "FxQingmenyinR31M11Atk012D2",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 168,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100601301 ] = {
    EntityId = 100601301,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013.prefab",
        Model = "FxQingmenyinR31M11Atk013",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 117,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600102 ] = {
    EntityId = 100600102,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001D1.prefab",
        Model = "FxQingmenyinR31M11Atk001D1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100600103 ] = {
    EntityId = 100600103,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001H.prefab",
        Model = "FxQingmenyinR31M11Atk001H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100601303 ] = {
    EntityId = 100601303,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013H.prefab",
        Model = "FxQingmenyinR31M11Atk013H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601302 ] = {
    EntityId = 100601302,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013.prefab",
        Model = "FxQingmenyinR31M11Atk013",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 117,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 1006013002 ] = {
    EntityId = 1006013002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 5,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 9,
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
        MagicsByTargetBeforeHit = {
          1006013002
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013003 ] = {
    EntityId = 1006013003,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M1.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013003
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601304,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601303,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100600503 ] = {
    EntityId = 100600503,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk005R.prefab",
        Model = "FxQingmenyinR31M11Atk005R",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 120,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100600402 ] = {
    EntityId = 100600402,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk004R.prefab",
        Model = "FxQingmenyinR31M11Atk004R",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 105,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100603101 ] = {
    EntityId = 100603101,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Move02.prefab",
        Model = "FxQingmenyinR31M11Move02",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 66,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605101 ] = {
    EntityId = 100605101,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051.prefab",
        Model = "FxQingmenyinR31M11Atk051",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 240,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605102 ] = {
    EntityId = 100605102,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051Diban.prefab",
        Model = "FxQingmenyinR31M11Atk051Diban",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 600,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 7.0,
        RadiusOut = 7.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  },
  [ 100605103 ] = {
    EntityId = 100605103,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051H.prefab",
        Model = "FxQingmenyinR31M11Atk051H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 1006051001 ] = {
    EntityId = 1006051001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
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
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 4,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051002,
          1006057,
          1006059
        },
        CreateHitEntities = {
          {
            EntityId = 100605109,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -3.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = 0.5,
              StartFrequency = 4.0,
              TargetAmplitude = 0.15,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051002 ] = {
    EntityId = 1006051002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 2.0,
        OffsetZ = 10.0,
        Repetition = true,
        IntervalFrame = 9,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051003,
          1006059
        },
        CreateHitEntities = {
          {
            EntityId = 100605110,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -3.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedY = 15.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = -20.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 3.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = -3.0,
          SpeedYAccelerationTimeAloft = 0.3,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.1,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051003 ] = {
    EntityId = 1006051003,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 2.0,
        OffsetZ = 10.0,
        Repetition = true,
        IntervalFrame = 9,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051003,
          1006058
        },
        CreateHitEntities = {
          {
            EntityId = 100605110,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -3.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedY = 15.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = -20.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 3.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = -3.0,
          SpeedYAccelerationTimeAloft = 0.3,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.1,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051004 ] = {
    EntityId = 1006051004,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 5,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 2.0,
        OffsetZ = 10.0,
        Repetition = false,
        IntervalFrame = 4,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051004
        },
        CreateHitEntities = {
          {
            EntityId = 100605110,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 4.0,
          SpeedYAcceleration = -30.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 3,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100605104 ] = {
    EntityId = 100605104,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051S.prefab",
        Model = "FxQingmenyinR31M11Atk051S",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 300,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605105 ] = {
    EntityId = 100605105,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051Y1.prefab",
        Model = "FxQingmenyinR31M11Atk051Y1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605106 ] = {
    EntityId = 100605106,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051Y2.prefab",
        Model = "FxQingmenyinR31M11Atk051Y2",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 27,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605107 ] = {
    EntityId = 100605107,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051Y3.prefab",
        Model = "FxQingmenyinR31M11Atk051Y3",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 21,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605108 ] = {
    EntityId = 100605108,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051Y4.prefab",
        Model = "FxQingmenyinR31M11Atk051Y4",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 18,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 1006051005 ] = {
    EntityId = 1006051005,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
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
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 4,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051002,
          1006059
        },
        CreateHitEntities = {
          {
            EntityId = 100605109,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -3.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = -0.5,
              StartFrequency = 4.0,
              TargetAmplitude = -0.15,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013004 ] = {
    EntityId = 1006013004,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M1.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013003
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601304,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601303,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013005 ] = {
    EntityId = 1006013005,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M1.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013003
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601304,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601303,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013006 ] = {
    EntityId = 1006013006,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M1.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013003
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601304,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601303,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013007 ] = {
    EntityId = 1006013007,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M1.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013003
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          BlowSpeed = 10.0,
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601304,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601303,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051006 ] = {
    EntityId = 1006051006,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 5,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 2.0,
        OffsetZ = 10.0,
        Repetition = false,
        IntervalFrame = 4,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051003
        },
        CreateHitEntities = {
          {
            EntityId = 100605110,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 2.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 4.0,
          SpeedYAcceleration = -30.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 8.0,
          SpeedZAloft = 4.0,
          SpeedYAccelerationAloft = -1.0,
          SpeedYAccelerationTimeAloft = 0.2,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 6,
            PFTimeScale = 0.03,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100601102 ] = {
    EntityId = 100601102,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011tuowei1.prefab",
        Model = "FxQingmenyinR31M11Atk011tuowei1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 78,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 2.6,
        BindRotationTime = 2.6,
        BindTransformName = "Ribbon_077_RootBone",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601103 ] = {
    EntityId = 100601103,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011tuowei2.prefab",
        Model = "FxQingmenyinR31M11Atk011tuowei2",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 78,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 2.6,
        BindRotationTime = 2.6,
        BindTransformName = "Ribbon_079_RootBone",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601203 ] = {
    EntityId = 100601203,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011tuowei1.prefab",
        Model = "FxQingmenyinR31M11Atk011tuowei1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 78,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 2.6,
        BindRotationTime = 2.6,
        BindTransformName = "Ribbon_077_RootBone",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601204 ] = {
    EntityId = 100601204,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011tuowei1.prefab",
        Model = "FxQingmenyinR31M11Atk011tuowei1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 78,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 2.6,
        BindRotationTime = 2.6,
        BindTransformName = "Ribbon_079_RootBone",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601205 ] = {
    EntityId = 100601205,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 46.0,
        BindRotationTime = 46.0,
        BindTransformName = "Bip001 L Toe0",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012D3.prefab",
        Model = "FxQingmenyinR31M11Atk012D3",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 48,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051007 ] = {
    EntityId = 1006051007,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 4.0,
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
        Height = 1.8,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = -1.0,
        Repetition = true,
        IntervalFrame = 1,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1001015
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051008 ] = {
    EntityId = 1006051008,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 7,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 4.0,
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
        Height = 1.8,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = -1.0,
        Repetition = true,
        IntervalFrame = 1,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1001015
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051009 ] = {
    EntityId = 1006051009,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
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
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 4,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051002,
          1006057,
          1006059
        },
        CreateHitEntities = {
          {
            EntityId = 100605109,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -3.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = 0.5,
              StartFrequency = 4.0,
              TargetAmplitude = 0.15,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051010 ] = {
    EntityId = 1006051010,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
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
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 20.0,
        Height = 4.0,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 4,
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
        MagicsByTargetBeforeHit = {
          1006056,
          1006051002,
          1006057,
          1006058
        },
        CreateHitEntities = {
          {
            EntityId = 100605109,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 10.0,
          SpeedZHitFly = 2.0,
          SpeedYAcceleration = -20.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.03,
              StartAmplitude = 0.5,
              StartFrequency = 4.0,
              TargetAmplitude = 0.15,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.1,
              StartAmplitude = 0.15,
              StartFrequency = 4.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.12,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006051011 ] = {
    EntityId = 1006051011,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051Area.prefab",
        Model = "FxQingmenyinR31M11Atk051Area",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 415,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Attack = {
        AttackType = 8,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 7,
        DelayFrame = 55,
        DurationFrame = 360,
        Target = 3,
        IngoreDodge = true,
        ImmuneHitMove = false,
        ShapeType = 3,
        Radius = 8.5,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 0.0,
        Height = 10.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 4.55,
        Repetition = true,
        IntervalFrame = 60,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
        MagicsByTargetBeforeHit = {
          1006051001,
          1006003
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
        HitParams = {
          BlowSpeed = 10.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      }
    }
  },
  [ 100601104 ] = {
    EntityId = 100601104,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011H.prefab",
        Model = "FxQingmenyinR31M11Atk011H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601206 ] = {
    EntityId = 100601206,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012H1.prefab",
        Model = "FxQingmenyinR31M11Atk013H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100600203 ] = {
    EntityId = 100600203,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk002H.prefab",
        Model = "FxQingmenyinR31M11Atk002H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100600303 ] = {
    EntityId = 100600303,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk003H.prefab",
        Model = "FxQingmenyinR31M11Atk003H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100600403 ] = {
    EntityId = 100600403,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk004H.prefab",
        Model = "FxQingmenyinR31M11Atk004H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100600504 ] = {
    EntityId = 100600504,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk005H.prefab",
        Model = "FxQingmenyinR31M11Atk005H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100601207 ] = {
    EntityId = 100601207,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012H2.prefab",
        Model = "FxQingmenyinR31M11Atk013H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605109 ] = {
    EntityId = 100605109,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051H.prefab",
        Model = "FxQingmenyinR31M11Atk013H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100605110 ] = {
    EntityId = 100605110,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk051H02.prefab",
        Model = "FxQingmenyinR31M11Atk013H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 1006013013 ] = {
    EntityId = 1006013013,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M2.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013005
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601306,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601305,
        AlwaysUpdateTargetPos = true,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013014 ] = {
    EntityId = 1006013014,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M2.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013005
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601306,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601305,
        AlwaysUpdateTargetPos = true,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013015 ] = {
    EntityId = 1006013015,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M2.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013005
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601306,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601305,
        AlwaysUpdateTargetPos = true,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013016 ] = {
    EntityId = 1006013016,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M2.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013005
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601306,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601305,
        AlwaysUpdateTargetPos = true,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013017 ] = {
    EntityId = 1006013017,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013M2.prefab",
        Model = "FxQingmenyinR31M11Atk013M",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 90,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
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
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
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
          1006013005
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit02"
        },
        CreateHitEntities = {
          {
            EntityId = 100601303,
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
          SpeedZ = 3.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 4.0,
              TargetAmplitude = 0.1,
              TargetFrequency = 8.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
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
            PFFrame = 2,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.3,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.3,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.3,
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
        SpeedCurveId = 100601306,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100601305,
        AlwaysUpdateTargetPos = true,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006011002 ] = {
    EntityId = 1006011002,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 20,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 12,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 4.0,
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
        Height = 1.8,
        Width = 12.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 3,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1006011003
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006011003 ] = {
    EntityId = 1006011003,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 20,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 20,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 4.0,
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
        Height = 1.8,
        Width = 12.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 3,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.03,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          1006011005
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
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
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006172001 ] = {
    EntityId = 1006172001,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 10,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 4096,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 10,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 3,
        Radius = 3.0,
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
        Height = 1.3,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.65,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1006172
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk172_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk172_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100617202,
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
          SpeedZ = 4.0,
          SpeedZAcceleration = -25.0,
          SpeedZTime = 0.15,
          SpeedY = 20.0,
          SpeedZHitFly = 2.5,
          SpeedYAcceleration = -80.0,
          SpeedYAccelerationTime = 0.2,
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
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
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
      }
    }
  },
  [ 100617001 ] = {
    EntityId = 100617001,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk170.prefab",
        Model = "QingmenyinR31M11Atk170",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 36,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100617101 ] = {
    EntityId = 100617101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = -1.0,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk171.prefab",
        Model = "FxQingmenyinR31M11Atk171",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100617201 ] = {
    EntityId = 100617201,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk172.prefab",
        Model = "QingmenyinR31M11Atk172",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100617202 ] = {
    EntityId = 100617202,
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk172H.prefab",
        Model = "QingmenyinR31M11Atk172H",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
  [ 100617002 ] = {
    EntityId = 100617002,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 0.5,
        BindRotationTime = 0.5,
        BindTransformName = "wuqi_000",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk170wuqi_000.prefab",
        Model = "FxQingmenyinR31M11Atk170wuqi_000",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 15,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100602107 ] = {
    EntityId = 100602107,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Core.prefab",
        Model = "FxQingmenyinR31M11Core",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 120,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 999999.0,
        BindRotationTime = 999999.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 100601304 ] = {
    EntityId = 100601304,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013D1.prefab",
        Model = "FxQingmenyinR31M11Atk013",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100601305 ] = {
    EntityId = 100601305,
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk013D3.prefab",
        Model = "FxQingmenyinR31M11Atk013D3",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 126,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      }
    }
  },
  [ 1006013008 ] = {
    EntityId = 1006013008,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 78,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
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
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 9,
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
        MagicsByTargetBeforeHit = {
          1006013001
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit01"
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 2.0,
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 6,
            PFTimeScale = 0.0,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.03,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006013009 ] = {
    EntityId = 1006013009,
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
        localEntity = false,
        IsEffectResType = false
      },
      TimeoutDeath = {
        Frame = 5,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 5.0,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 9,
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
        MagicsByTargetBeforeHit = {
          1006013002
        },
        SoundsByTarget = {
          "QingmenyinR31M11_Atk013_Hit01"
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 2.0,
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
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
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
              StartOffset = 0.05,
              StartAmplitude = 0.4,
              StartFrequency = 7.0,
              TargetAmplitude = 0.05,
              TargetFrequency = 1.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.14,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.05,
              StartAmplitude = -0.08,
              StartFrequency = 7.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 7.0,
              AmplitudeChangeTime = 0.14,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 6,
            PFTimeScale = 0.0,
            PFTimeScaleCurve = "-1",
            TargetPFTimeScale = 0.03,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.03,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.03,
            PFSceneSpeedCurve = "-1"
          }
        },
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
