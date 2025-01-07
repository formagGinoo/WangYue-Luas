Config = Config or {}
Config.Entity1002 = Config.Entity1002 or { }
local empty = { }
Config.Entity1002 = 
{
  [ 1002 ] = {
    EntityId = 1002,
    EntityName = "1002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR21/KekeR21M11/KekeR21M11.prefab",
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
        Animator = "Character/Role/Female165/KekeR21/KekeR21M11/KekeR21M11.controller",
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
          "1002"
        },
      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 1,
        NpcTag = 1,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Move = {
        pivot = 0.974071,
        canGlide = true,
        GlideCost = 1.0,
        GlideHeight = 5.0,
        GlideRotationSpeed = 90.0,
        GlideDownSpeed = 1.0,
        GlideMoveSpeed = 5.0,
        GlideTurnSpeed = 3.5,
        GlideTurnBackSpeed = 3.0,
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
        ConfigName = "KekeR21M11",
        LogicMoveConfigs = {
          Attack170 = 4,
          ClimbingJump = 4,
          ClimbingJumpStart = 4,
          ClimbingRunStart = 4,
          ClimbingRunEnd = 4,
          Attack081 = 4,
          Attack080 = 4,
          Attack082 = 4,
          GlideFront = 2,
          GlideLeft = 2,
          GlideRight = 2,
          Gliding = 2,
          CallPartner = 2
        },        BindRotation = false,

      },
      Rotate = {
        Speed = 720
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
                LocalScale = { 1.0, 0.85, 1.0 }
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
                LocalScale = { 1.0, 0.85, 1.0 }
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
      State = {
        DyingTime = 2.633,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 2.3,
        HitTime = {
          [ 1 ] = {
            Time = 1.267,
            ForceTime = 0.3,
            FusionChangeTime = 0.3,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.267,
            ForceTime = 0.3,
            FusionChangeTime = 0.3,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.633,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.633,
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
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
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
            Time = 5.0,
            ForceTime = 5.0,
            FusionChangeTime = 5.0,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.1,
            ForceTime = 0.1,
            FusionChangeTime = 0.1,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 1.167,
            ForceTime = 0.3,
            FusionChangeTime = 0.2,
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
        HitFlyHeight = 0.2
      },
      Skill = {
        Skills = {
          [ 1002001 ] = {
            TotalFrame = 70,
            ForceFrame = 10,
            SkillBreakSkillFrame = 7,
            ChangeRoleFrame = 0,
            SkillType = 1,
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
                ReadyEffectPath = "",
                CastEffectPath = "",
                SkillIcon = "KekeR21Attack",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack001",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 100200101,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 4,
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

                  EventName = "KekeR31M11_Atk001",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 3 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.4,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.03,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.01,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  EventType = 4,

                },
                {

                  EntityId = 1002001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.5,
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
              [ 6 ] = {
                {

                  Type = 10000011,
                  Frame = 12,
                  FrameTime = 6,
                  EventType = 3,

                }
              },
              [ 7 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 7,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  EntityId = 1002015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 900,
                  EventType = 1,

                },
                {

                  Type = 10020000,
                  Frame = 67,
                  FrameTime = 900,
                  EventType = 3,

                }
              },
              [ 904 ] = {
                {

                  Type = 10020010,
                  Frame = 1,
                  FrameTime = 904,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      10020040
                    },
                  }
                }
              },
            }
          },
          [ 1002002 ] = {
            TotalFrame = 69,
            ForceFrame = 24,
            SkillBreakSkillFrame = 21,
            ChangeRoleFrame = 0,
            SkillType = 1,
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

                  EntityId = 100200201,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 13,
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

                  EventName = "KekeR31M11_Atk002",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 1002002001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.2,
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

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.07,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.14,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.14,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  EventType = 4,

                }
              },
              [ 14 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -0.6,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.07,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.14,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.14,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 14,
                  EventType = 4,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 1002002002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.1,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 15,
                  EventType = 1,

                }
              },
              [ 19 ] = {
                {

                  Type = 10000011,
                  Frame = 12,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
              [ 21 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 21,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  Type = 10020000,
                  Frame = 91,
                  FrameTime = 900,
                  EventType = 3,

                }
              },
              [ 902 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = 0.3,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.09,
                      FrequencyChangeTime = 0.09,
                      DurationTime = 0.09,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.09,
                      FrequencyChangeTime = 0.09,
                      DurationTime = 0.09,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.09,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.09,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 902,
                  EventType = 4,

                }
              },
              [ 903 ] = {
                {

                  AddType = 1,
                  BuffId = 1002006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 903,
                  EventType = 9,

                },
                {

                  EntityId = 1002002001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.3,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 903,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1002006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 903,
                  EventType = 9,

                }
              },
              [ 908 ] = {
                {

                  Type = 10020010,
                  Frame = 1,
                  FrameTime = 908,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      10020040
                    },
                  }
                }
              },
              [ 915 ] = {
                {

                  Type = 10020010,
                  Frame = 1,
                  FrameTime = 915,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      10020040
                    },
                  }
                },
                {

                  AddType = 1,
                  BuffId = 1002006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 915,
                  EventType = 9,

                }
              },
            }
          },
          [ 1002003 ] = {
            TotalFrame = 103,
            ForceFrame = 18,
            SkillBreakSkillFrame = 15,
            ChangeRoleFrame = 0,
            SkillType = 1,
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

                },
                {

                  EntityId = 100200301,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 16,
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

                  EventName = "KekeR31M11_Atk003",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 3 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.2,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  EventType = 4,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1002003001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 5 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 5,
                  EventType = 4,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1002003002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 7 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 7,
                  EventType = 4,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 1002003003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 8,
                  EventType = 1,

                }
              },
              [ 9 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.01,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 9,
                  EventType = 4,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1002003004,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 13 ] = {
                {

                  Type = 10000011,
                  Frame = 3,
                  FrameTime = 13,
                  EventType = 3,

                }
              },
              [ 14 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 14,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002004 ] = {
            TotalFrame = 59,
            ForceFrame = 19,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 0,
            SkillType = 1,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack004",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 100200401,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 13,
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

                  EventName = "KekeR31M11_Atk004",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 5 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -0.3,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.15,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.01,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.15,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 4.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 5,
                  EventType = 4,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1002004001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 0.5,
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
              [ 9 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -0.7,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.03,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.01,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.21,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.21,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 9,
                  EventType = 4,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1002004002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.2,
                  BornOffsetZ = 0.5,
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
              [ 13 ] = {
                {

                  Type = 10000011,
                  Frame = 12,
                  FrameTime = 13,
                  EventType = 3,

                }
              },
              [ 16 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 16,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002005 ] = {
            TotalFrame = 94,
            ForceFrame = 34,
            SkillBreakSkillFrame = 31,
            ChangeRoleFrame = 0,
            SkillType = 1,
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

                  EntityId = 100200501,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 14,
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

                  EventName = "KekeR31M11_Atk005",
                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 5 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.2,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.05,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.06,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 5,
                  EventType = 4,

                }
              },
              [ 10 ] = {
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
                  FrameTime = 10,
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
                  FrameTime = 10,
                  EventType = 3,

                },
                {

                  Type = 600000007,
                  Frame = 1,
                  FrameTime = 10,
                  EventType = 3,

                }
              },
              [ 15 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -2.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.2,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.08,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.03,
                      AmplitudeChangeTime = 0.24,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.24,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 15,
                  EventType = 4,

                },
                {

                  EntityId = 1002005001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.7,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 15,
                  EventType = 1,

                }
              },
              [ 21 ] = {
                {

                  Type = 10000011,
                  Frame = 12,
                  FrameTime = 21,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002010 ] = {
            TotalFrame = 88,
            ForceFrame = 22,
            SkillBreakSkillFrame = 19,
            ChangeRoleFrame = 19,
            SkillType = 10,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1001,
                CDtime = 1.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1201,
                UseCostValue = 2,
                MaxUseCostValue = 2,
                MaskColor = "#ea5a5a",
                UseCostMode = 3,
                ChargeTimes = 3,
                ChargeCdTime = 1.5,
                RecoverCount = 1,
                RecoverCostType = 1201,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "Effect/UI/22058.prefab",
                CastEffectPath = "",
                SkillIcon = "KekeR21RedSkill",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack014",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 100201201,
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

                  EventName = "KekeR31M11_Atk014",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 2 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.2,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 2,
                  EventType = 4,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 1002010001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.7,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -10.0,
                  BornRotateOffsetY = 60.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 3,
                  EventType = 1,

                }
              },
              [ 8 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.9,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.35,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.35,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.1,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 8,
                  EventType = 4,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1002010002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 0.7,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -15.0,
                  BornRotateOffsetY = -30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  Type = 10000011,
                  Frame = 12,
                  FrameTime = 18,
                  EventType = 3,

                }
              },
              [ 19 ] = {
                {

                  Type = 10020013,
                  Frame = 2,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002011 ] = {
            TotalFrame = 88,
            ForceFrame = 22,
            SkillBreakSkillFrame = 19,
            ChangeRoleFrame = 19,
            SkillType = 10,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1001,
                CDtime = 1.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 2,
                MaxUseCostValue = 2,
                MaskColor = "#ea5a5a",
                UseCostMode = 3,
                ChargeTimes = 3,
                ChargeCdTime = 7.0,
                RecoverCount = 1,
                RecoverCostType = 1201,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "Effect/UI/22058.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "KekeR21RedSkill",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack014",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 100201201,
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
              [ 2 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.2,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 2,
                  EventType = 4,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 1002011001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.7,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -10.0,
                  BornRotateOffsetY = 60.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 3,
                  EventType = 1,

                }
              },
              [ 8 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.9,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.35,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.35,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.1,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 8,
                  EventType = 4,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1002011002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 0.7,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -20.0,
                  BornRotateOffsetY = -45.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 18,
                  EventType = 3,

                }
              },
              [ 19 ] = {
                {

                  Type = 10020013,
                  Frame = 2,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002012 ] = {
            TotalFrame = 88,
            ForceFrame = 22,
            SkillBreakSkillFrame = 19,
            ChangeRoleFrame = 19,
            SkillType = 10,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1001,
                CDtime = 1.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1201,
                UseCostValue = 2,
                MaxUseCostValue = 2,
                MaskColor = "#ea5a5a",
                UseCostMode = 3,
                ChargeTimes = 3,
                ChargeCdTime = 7.0,
                RecoverCount = 1,
                RecoverCostType = 1201,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "Effect/UI/22058.prefab",
                CastEffectPath = "",
                SkillIcon = "KekeR21RedSkill",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack014",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 100201201,
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
              [ 2 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.2,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 2,
                  EventType = 4,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 1002012001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.7,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -10.0,
                  BornRotateOffsetY = 60.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 3,
                  EventType = 1,

                }
              },
              [ 8 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.9,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.35,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.35,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.1,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.25,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 8,
                  EventType = 4,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1002012002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 0.7,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -20.0,
                  BornRotateOffsetY = -45.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 18,
                  EventType = 3,

                }
              },
              [ 19 ] = {
                {

                  Type = 10020013,
                  Frame = 2,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002013 ] = {
            TotalFrame = 60,
            ForceFrame = 40,
            SkillBreakSkillFrame = 40,
            ChangeRoleFrame = 40,
            SkillType = 10,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack015",
                  StartFrame = 20,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EventName = "kekeB2",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  EntityId = 100201501,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 1.0,
                  BornOffsetY = 1.7,
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
                  BuffId = 1002043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1002015001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.5,
                  BornOffsetY = 1.3,
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
              [ 9 ] = {
                {

                  EntityId = 1002015001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.3,
                  BornOffsetY = 1.5,
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
              [ 16 ] = {
                {

                  EntityId = 1002015001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.2,
                  BornOffsetY = 1.7,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                }
              },
              [ 19 ] = {
                {

                  Type = 10020013,
                  Frame = 3,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 1002015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -30.0,
                  BornRotateOffsetY = -80.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                },
                {

                  EntityId = 1002015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -60.0,
                  BornRotateOffsetY = -30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                },
                {

                  EntityId = 1002015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -60.0,
                  BornRotateOffsetY = 30.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                },
                {

                  EntityId = 1002015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -30.0,
                  BornRotateOffsetY = -80.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                },
                {

                  EntityId = 1002015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = -30.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 28,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 1.3,
                  UseTimescale = true,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.3,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 100201505,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 900,
                  EventType = 14,

                }
              },
            }
          },
          [ 1002030 ] = {
            TotalFrame = 50,
            ForceFrame = 10,
            SkillBreakSkillFrame = 10,
            ChangeRoleFrame = 10,
            SkillType = 30,
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
                MaskColor = "#FFFFFF",
                UseCostMode = 0,
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
                SkillIcon = "XumuR11Move",
                BehaviorConfig = 80,
                LayerConfig = 258
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Move01",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  Type = 10000007,
                  Frame = 12,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  Frame = 12,
                  RingCount = 7,
                  FrameTime = 0,
                  EventType = 6,

                },
                {

                  EventName = "dodge",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 8 ] = {
                {

                  Type = 10000006,
                  Frame = 1,
                  FrameTime = 8,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  AddType = 1,
                  BuffId = 1000007,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 900,
                  EventType = 9,

                }
              },
            }
          },
          [ 1002031 ] = {
            TotalFrame = 79,
            ForceFrame = 18,
            SkillBreakSkillFrame = 15,
            ChangeRoleFrame = 12,
            SkillType = 31,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Move02",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  Type = 10000007,
                  Frame = 18,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  EntityId = 100203001,
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

                },
                {

                  EntityId = 100203002,
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

                },
                {

                  EntityId = 100203003,
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

                },
                {

                  Type = 10020000,
                  Frame = 88,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  Frame = 18,
                  RingCount = 7,
                  FrameTime = 0,
                  EventType = 6,

                },
                {

                  EventName = "KekeR31M11_Move02",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 12 ] = {
                {

                  Type = 10000010,
                  Frame = 1,
                  FrameTime = 12,
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
                  EventType = 9,

                }
              },
            }
          },
          [ 1002040 ] = {
            TotalFrame = 78,
            ForceFrame = 20,
            SkillBreakSkillFrame = 17,
            ChangeRoleFrame = 14,
            SkillType = 40,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1002,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1204,
                UseCostValue = 90,
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
                ReadyEffectPath = "",
                CastEffectPath = "",
                SkillIcon = "KekeR21BlueSkill",
                BehaviorConfig = 50,
                LayerConfig = 36
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack160",
                  StartFrame = 2,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  Type = 10020000,
                  Frame = 78,
                  FrameTime = 0,
                  EventType = 3,

                }
              },
              [ 4 ] = {
                {

                  Name = "Attack040",
                  StartFrame = 0,
                  FrameTime = 4,
                  EventType = 2,

                },
                {

                  EntityId = 100204302,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.45,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 4,
                  EventType = 4,

                }
              },
              [ 5 ] = {
                {

                  EntityId = 1002040002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 5,
                  EventType = 1,

                }
              },
            }
          },
          [ 1002050 ] = {
            TotalFrame = 159,
            ForceFrame = 100,
            SkillBreakSkillFrame = 100,
            ChangeRoleFrame = 100,
            SkillType = 50,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1003,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1005,
                UseCostValue = 100,
                MaxUseCostValue = 0,
                MaskColor = "#cc75fe",
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
                ReadyEffectPath = "Effect/UI/22001.Prefab",
                CastEffectPath = "Effect/UI/22002.Prefab",
                SkillIcon = "KekeR21UltimateSkill",
                BehaviorConfig = 51,
                LayerConfig = 231
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 100205001,
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

                },
                {

                  Type = 10020000,
                  Frame = 159,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 1002052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 13 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 13,
                  EventType = 8,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 13,
                  EventType = 4,

                },
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 13,
                  EventType = 3,

                }
              },
              [ 16 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 16,
                  FrameTime = 16,
                  EventType = 2,

                }
              },
              [ 18 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 18,
                  FrameTime = 18,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 18,
                  EventType = 8,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 18,
                  EventType = 4,

                },
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 18,
                  EventType = 3,

                }
              },
              [ 22 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 22,
                  FrameTime = 22,
                  EventType = 2,

                }
              },
              [ 24 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 24,
                  EventType = 8,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 24,
                  EventType = 4,

                },
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 24,
                  EventType = 3,

                },
                {

                  Name = "Attack050",
                  StartFrame = 24,
                  FrameTime = 24,
                  EventType = 2,

                }
              },
              [ 28 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 28,
                  FrameTime = 28,
                  EventType = 2,

                }
              },
              [ 30 ] = {
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 30,
                  EventType = 3,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 30,
                  EventType = 4,

                },
                {

                  Name = "Attack050",
                  StartFrame = 30,
                  FrameTime = 30,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 30,
                  EventType = 8,

                }
              },
              [ 34 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 34,
                  FrameTime = 34,
                  EventType = 2,

                }
              },
              [ 36 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 36,
                  EventType = 4,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 36,
                  EventType = 8,

                },
                {

                  Name = "Attack050",
                  StartFrame = 36,
                  FrameTime = 36,
                  EventType = 2,

                },
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 36,
                  EventType = 3,

                }
              },
              [ 40 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 40,
                  FrameTime = 40,
                  EventType = 2,

                }
              },
              [ 42 ] = {
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 42,
                  EventType = 3,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 42,
                  EventType = 8,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 42,
                  EventType = 4,

                },
                {

                  Name = "Attack050",
                  StartFrame = 42,
                  FrameTime = 42,
                  EventType = 2,

                }
              },
              [ 46 ] = {
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 46,
                  EventType = 3,

                },
                {

                  Name = "Attack050",
                  StartFrame = 46,
                  FrameTime = 46,
                  EventType = 2,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 46,
                  EventType = 4,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 46,
                  EventType = 8,

                }
              },
              [ 50 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 50,
                  FrameTime = 50,
                  EventType = 2,

                },
                {

                  Type = 10020050,
                  Frame = 1,
                  FrameTime = 50,
                  EventType = 3,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 12000.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 50,
                  EventType = 8,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.05,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.05,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.04,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 50,
                  EventType = 4,

                }
              },
              [ 55 ] = {
                {

                  Name = "Attack050",
                  StartFrame = 55,
                  FrameTime = 55,
                  EventType = 2,

                }
              },
              [ 70 ] = {
                {

                  EntityId = 100205004,
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
                  FrameTime = 70,
                  EventType = 1,

                }
              },
              [ 82 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.55,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.35,
                      Sign = 50.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.02,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 51.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 52.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 82,
                  EventType = 4,

                },
                {

                  Type = 10020051,
                  Frame = 1,
                  FrameTime = 82,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  EntityId = 100205005,
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
                  FrameTime = 900,
                  EventType = 1,

                },
                {

                  EntityId = 100205006,
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
                  FrameTime = 900,
                  EventType = 1,

                }
              },
            }
          },
          [ 1002051 ] = {
            TotalFrame = 121,
            ForceFrame = 88,
            SkillBreakSkillFrame = 88,
            ChangeRoleFrame = 88,
            SkillType = 50,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1003,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1005,
                UseCostValue = 0,
                MaxUseCostValue = 100,
                MaskColor = "#cc75fe",
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
                ReadyEffectPath = "Effect/UI/22001.Prefab",
                CastEffectPath = "Effect/UI/22002.Prefab",
                DodgeEffectPath = "",
                SkillIcon = "KekeR21UltimateSkill",
                BehaviorConfig = 51,
                LayerConfig = 231
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack051",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1002052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1002053,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  EntityId = 100205101,
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
                  BuffId = 1002054,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  EventName = "KekeR31M11_Atk051",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 82 ] = {
                {

                  EntityId = 1002051001,
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
                  FrameTime = 82,
                  EventType = 1,

                }
              },
              [ 85 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 85,
                  EventType = 3,

                }
              },
              [ 88 ] = {
                {

                  Type = 10000012,
                  Frame = 1,
                  FrameTime = 88,
                  EventType = 3,

                }
              },
              [ 901 ] = {
                {

                  EventName = "kekeD1",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 901,
                  EventType = 15,

                }
              },
              [ 991 ] = {
                {

                  EntityId = 100205102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -1.5,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 1.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 991,
                  EventType = 1,

                }
              },
              [ 9100 ] = {
                {

                  EntityId = 100205102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 1.5,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 1.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 9100,
                  EventType = 1,

                }
              },
              [ 9109 ] = {
                {

                  EntityId = 100205102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -1.5,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 1.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 9109,
                  EventType = 1,

                }
              },
              [ 9115 ] = {
                {

                  EntityId = 100205102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 1.5,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 1.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 9115,
                  EventType = 1,

                }
              },
            }
          },
          [ 1002052 ] = {
            TotalFrame = 30,
            ForceFrame = 30,
            SkillBreakSkillFrame = 30,
            ChangeRoleFrame = 30,
            SkillType = 52,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack052",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1002052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1002054,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 20 ] = {
                {

                  Type = 10000009,
                  Frame = 1,
                  FrameTime = 20,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002060 ] = {
            TotalFrame = 75,
            ForceFrame = 27,
            SkillBreakSkillFrame = 24,
            ChangeRoleFrame = 21,
            SkillType = 60,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack060",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EventName = "KekeR31M11_Atk060",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  EntityId = 100206002,
                  LifeBindSkill = false,
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

                },
                {

                  EntityId = 100206003,
                  LifeBindSkill = false,
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

                },
                {

                  EntityId = 100206004,
                  LifeBindSkill = false,
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

                },
                {

                  EntityId = 100206005,
                  LifeBindSkill = false,
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

                },
                {

                  EntityId = 100206006,
                  LifeBindSkill = false,
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

                },
                {

                  AddType = 1,
                  BuffId = 1002063,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 1002060001,
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
                  FrameTime = 7,
                  EventType = 1,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 100206001,
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
                  FrameTime = 8,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -1.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.1,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 8,
                  EventType = 4,

                }
              },
              [ 11 ] = {
                {

                  EntityId = 1002060002,
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

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 63.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 64.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 11,
                  EventType = 4,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 1002060002,
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

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 65.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 66.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 14,
                  EventType = 4,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 1002060002,
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

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 67.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 68.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 17,
                  EventType = 4,

                }
              },
              [ 21 ] = {
                {

                  Type = 10000011,
                  Frame = 3,
                  FrameTime = 21,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002070 ] = {
            TotalFrame = 75,
            ForceFrame = 24,
            SkillBreakSkillFrame = 24,
            ChangeRoleFrame = 24,
            SkillType = 70,
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

                  Type = 10020000,
                  Frame = 61,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  EntityId = 100200501,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 4,
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

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.05,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.12,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.14,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 0,
                  EventType = 4,

                },
                {

                  EventName = "KekeR31M11_Atk070",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 4 ] = {
                {

                  AddType = 1,
                  BuffId = 1002006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -2.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.3,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.24,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.24,
                      Sign = 7.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = 0.15,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.05,
                      TargetFrequency = 0.03,
                      AmplitudeChangeTime = 0.24,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.24,
                      Sign = 8.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -0.15,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.24,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.24,
                      Sign = 9.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 5,
                  EventType = 4,

                },
                {

                  Type = 10020010,
                  Frame = 2,
                  FrameTime = 5,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      10020040
                    },
                  }
                }
              },
              [ 6 ] = {
                {

                  EntityId = 1002005001,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 0,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 6,
                  EventType = 1,

                }
              },
            }
          },
          [ 1002071 ] = {
            TotalFrame = 75,
            ForceFrame = 29,
            SkillBreakSkillFrame = 26,
            ChangeRoleFrame = 26,
            SkillType = 70,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack070",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1002070,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 100207001,
                  LifeBindSkill = true,
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
                  FrameTime = 3,
                  EventType = 1,

                },
                {

                  EntityId = 1002070001,
                  LifeBindSkill = true,
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
                  FrameTime = 3,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.25,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.1,
                      StartAmplitude = -0.25,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  EventType = 4,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1002070001,
                  LifeBindSkill = true,
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
              [ 5 ] = {
                {

                  EntityId = 1002070001,
                  LifeBindSkill = true,
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
                  FrameTime = 5,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.15,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.15,
                      StartAmplitude = -0.25,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.15,
                      StartAmplitude = -0.25,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 5,
                  EventType = 4,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 100207002,
                  LifeBindSkill = true,
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
              [ 15 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -1.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.25,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.08,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 0.03,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.15,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 15,
                  EventType = 4,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 1002070002,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.45,
                  BornOffsetZ = 0.5,
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
              [ 19 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.05,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.12,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.14,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 900,
                  EventType = 4,

                }
              },
              [ 904 ] = {
                {

                  AddType = 1,
                  BuffId = 1002006,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 904,
                  EventType = 9,

                }
              },
            }
          },
          [ 1002080 ] = {
            TotalFrame = 39,
            ForceFrame = 39,
            SkillBreakSkillFrame = 39,
            ChangeRoleFrame = 39,
            SkillType = 80,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack080",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 39.0,
                  MaxFallSpeed = 0.0,
                  FrameTime = 0,
                  EventType = 12,

                },
                {

                  AddType = 1,
                  BuffId = 1000034,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 7200.0,
                  Acceleration = 0.0,
                  RotateFrame = 5,
                  FrameTime = 0,
                  EventType = 8,

                },
                {                  DurationUpdateTargetFrame = 5,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.5,
                  TargetVPositionOffset = 0.7,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 0,
                  EventType = 18,

                },
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 6.0,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.2,
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
                  FrameTime = 0,
                  EventType = 21,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
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

                  EntityId = 1001080001,
                  LifeBindSkill = false,
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
                  FrameTime = 7,
                  EventType = 1,

                },
                {

                  EntityId = 1000000016,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
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
                  FrameTime = 7,
                  EventType = 1,

                },
                {

                  EventName = "tiaofan",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 7,
                  EventType = 15,

                }
              },
            }
          },
          [ 1002081 ] = {
            TotalFrame = 33,
            ForceFrame = 33,
            SkillBreakSkillFrame = 33,
            ChangeRoleFrame = 33,
            SkillType = 81,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack081",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 7200.0,
                  Acceleration = 0.0,
                  RotateFrame = 3,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 1002080,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 26.0,
                  MaxFallSpeed = 0.0,
                  FrameTime = 0,
                  EventType = 12,

                },
                {

                  EventName = "KekeR31M11_Atk081",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  AddType = 1,
                  BuffId = 1002082,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  EntityId = 100208101,
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

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 1.2,
                  UseTimescale = false,
                  EaseInTime = 0.0,
                  EaseOutTime = 0.2,
                  CameraFixeds = {
                    PositionY = {
                      CurveId = 100208101,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
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
                      CurveId = 100208103,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  EventType = 14,
                  ActiveSign = {
                    Sign = {
                      10000003
                    },
                  }
                }
              },
              [ 3 ] = {
                {                  DurationUpdateTargetFrame = 1,
                  OffsetType = 2,
                  TargetHPositionOffset = 0.5,
                  TargetVPositionOffset = 0.5,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 60.0,
                  MinSpeed = 0.0,
                  FrameTime = 3,
                  EventType = 18,

                }
              },
              [ 6 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
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
                  FrameTime = 6,
                  EventType = 4,

                }
              },
              [ 20 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -2.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.4,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.5,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.4,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.4,
                      FrequencyChangeTime = 0.2,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 20,
                  EventType = 4,

                },
                {

                  EntityId = 1002081001,
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
              [ 31 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 31,
                  EventType = 3,

                }
              },
              [ 900 ] = {
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
                  FrameTime = 900,
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
          [ 1002099 ] = {
            TotalFrame = 99,
            ForceFrame = 66,
            SkillBreakSkillFrame = 66,
            ChangeRoleFrame = 0,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack099",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 903 ] = {
                {

                  EntityId = 1002001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 903,
                  EventType = 1,

                }
              },
              [ 906 ] = {
                {

                  Name = "Attack013",
                  StartFrame = 13,
                  FrameTime = 906,
                  EventType = 2,

                }
              },
              [ 908 ] = {
                {

                  EntityId = 1002005001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.0,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 908,
                  EventType = 1,

                }
              },
              [ 909 ] = {
                {

                  EntityId = 1002001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 909,
                  EventType = 1,

                }
              },
              [ 910 ] = {
                {

                  EntityId = 1002001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.4,
                  BornOffsetZ = 0.3,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 910,
                  EventType = 1,

                }
              },
              [ 911 ] = {
                {

                  EntityId = 1002001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 911,
                  EventType = 1,

                }
              },
              [ 922 ] = {
                {

                  EntityId = 1002001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 922,
                  EventType = 1,

                }
              },
            }
          },
          [ 1002170 ] = {
            TotalFrame = 16,
            ForceFrame = 16,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 16,
            SkillType = 170,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack170",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EventName = "KekeR31M11_Atk170",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 25.0,
                  MaxFallSpeed = -3.40282347E+38,
                  FrameTime = 0,
                  EventType = 12,

                },
                {

                  Type = 10020000,
                  Frame = 25,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  EntityId = 100217001,
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
              [ 15 ] = {
                {

                  Type = 10000008,
                  Frame = 1,
                  FrameTime = 15,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002171 ] = {
            TotalFrame = 999999,
            ForceFrame = 999999,
            SkillBreakSkillFrame = 999999,
            SkillType = 171,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EventName = "KekeR31M11_Atk171",
                  LifeBindSkill = false,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Name = "Attack171",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  Type = 10000008,
                  Frame = 999999,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  ResetSpeed = true,
                  UseGravity = false,
                  BaseSpeed = -30.0,
                  AccelerationY = 0.0,
                  Duration = 9999999.0,
                  MaxFallSpeed = -30.0,
                  FrameTime = 0,
                  EventType = 12,

                },
                {

                  Type = 10020000,
                  Frame = 999999,
                  FrameTime = 0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002172 ] = {
            TotalFrame = 65,
            ForceFrame = 12,
            SkillBreakSkillFrame = 12,
            ChangeRoleFrame = 12,
            SkillType = 172,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack172",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EventName = "KekeR31M11_Atk172",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  EventType = 15,

                },
                {

                  Type = 10020000,
                  Frame = 65,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  EntityId = 100217201,
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
              [ 1 ] = {
                {

                  EntityId = 1002172001,
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
                  FrameTime = 1,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.25,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 1,
                  EventType = 4,

                }
              },
              [ 6 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 6,
                  EventType = 3,

                }
              },
            }
          },
          [ 1002996 ] = {
            TotalFrame = 77,
            ForceFrame = 33,
            SkillBreakSkillFrame = 26,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 600000007,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "CallPartner",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 600000005,
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
                  FrameTime = 7,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  Type = 600000002,
                  Frame = 0,
                  FrameTime = 15,
                  EventType = 3,

                }
              },
              [ 16 ] = {
                {

                  AddType = 1,
                  BuffId = 600000003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 16,
                  EventType = 9,

                }
              },
            }
          },
          [ 1002997 ] = {
            TotalFrame = 50,
            ForceFrame = 50,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  StartFrame = 2,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1000056,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1000057,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 1,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  MagicId = 1000051,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Type = 10600001,
                  Frame = 1,
                  FrameTime = 0,
                  EventType = 3,

                }
              },
              [ 24 ] = {
                {

                  MagicId = 1000048,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 24,
                  EventType = 10,

                }
              },
              [ 25 ] = {
                {

                  AddType = 2,
                  BuffId = 1000056,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 25,
                  EventType = 9,

                }
              },
            }
          },
          [ 1002998 ] = {
            TotalFrame = 50,
            ForceFrame = 50,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  StartFrame = 2,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1000056,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1000057,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

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
              [ 25 ] = {
                {

                  AddType = 2,
                  BuffId = 1000056,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 25,
                  EventType = 9,

                }
              },
              [ 50 ] = {
                {

                  Type = 1001998,
                  Frame = 10,
                  FrameTime = 50,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      1001999
                    },
                  }
                }
              },
            }
          },
          [ 1002999 ] = {
            TotalFrame = 103,
            ForceFrame = 56,
            SkillBreakSkillFrame = 56,
            ChangeRoleFrame = 0,
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

                },
                {

                  EntityId = 100200301,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 16,
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

                  EventName = "kekeA3",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  EventType = 15,

                }
              },
              [ 2 ] = {
                {

                  MagicId = 1000059,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 2,
                  EventType = 10,

                },
                {                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = -2.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 2,
                  EventType = 18,

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
                  FrameTime = 2,
                  EventType = 16,

                }
              },
              [ 3 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.2,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  EventType = 4,

                }
              },
              [ 5 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 5,
                  EventType = 4,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1002003002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 7 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 7,
                  EventType = 4,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 1002003003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 8,
                  EventType = 1,

                }
              },
              [ 9 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.01,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 9,
                  EventType = 4,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1002003004,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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

                },
                {

                  Name = "Attack003",
                  StartFrame = 4,
                  FrameTime = 10,
                  EventType = 2,

                }
              },
              [ 11 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.2,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 11,
                  EventType = 4,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 1002003001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 13 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 13,
                  EventType = 4,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 1002003002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 15 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 15,
                  EventType = 4,

                }
              },
              [ 16 ] = {
                {

                  EntityId = 1002003003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                }
              },
              [ 17 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.3,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.01,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.3,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 17,
                  EventType = 4,

                }
              },
              [ 18 ] = {
                {

                  MagicId = 1000060,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 18,
                  EventType = 10,

                },
                {

                  EntityId = 1002003004,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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

                  EntityId = 100200401,
                  LifeBindSkill = true,
                  LifeBindSkillFrame = 13,
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

                },
                {

                  Name = "Attack004",
                  StartFrame = 0,
                  FrameTime = 24,
                  EventType = 2,

                }
              },
              [ 28 ] = {
                {

                  EventName = "kekeA4",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 28,
                  EventType = 15,

                }
              },
              [ 29 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -0.3,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.15,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.01,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.15,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 4.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 29,
                  EventType = 4,

                }
              },
              [ 30 ] = {
                {

                  EntityId = 1002004001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 0.5,
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
              [ 33 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -0.7,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.03,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.01,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.3,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 7.0,
                      AmplitudeChangeTime = 0.21,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.21,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 33,
                  EventType = 4,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 1002004002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.2,
                  BornOffsetZ = 0.5,
                  TerriaOffsetY = 0.0,
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
            }
          }
        }
      },
      SkillSet = {
        UISets = {
          [ 1 ] = {
            ShowId = 1,
            UISetNote = "默认界面",
            BindRes1 = 1204,
            BindRes2 = 1211,
            CoreUIConfig = {
              BindRes = 1204,
              UIPath = "Prefabs/UI/Fight/CoreRes/CoreUI1002.prefab",
              Scale = 0.7,
              LocationOffset = { 0.0, 0.825, 0.0 },
              ScreenOffset = { -100.0, 80.0, 0.0 }
            },            J = {
              Active = true,
              SkillId = 1002001,
              SkillIcon = "0"
            },
            K = {
              Active = true,
              SkillId = 1002030,
              SkillIcon = "KekeR21Move"
            },
            L = {
              Active = false,
              SkillId = 1002051,
              SkillIcon = "Diyue"
            },
            I = {
              Active = true,
              SkillId = 1002010,
              SkillIcon = "KekeR21RedSkill"
            },
            O = {
              Active = true,
              SkillId = 0,
              SkillIcon = "Jump"
            },
            R = {
              Active = false,
              SkillId = 1002040,
              SkillIcon = "XumuR11UltimateSkill"
            },
            F = {
              Active = true,
              SkillId = 0,
              SkillIcon = "KekeR21BlueSkill"
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
        ClimbJumpSpeed = 0.0
      },
      Aim = empty,
      Swim = {
        SwimHeightInterval = 1.25,
        SwimmingCost = 0.0,
        FastSwimmingCost = 0.0
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
      ElementState = {
        ElementType = 2,

      },
      Sound = empty,
      Ik = {
        shakeLeftFrontId = 0,
        shakeLeftBackId = 0,
        shakeRightFrontId = 0,
        shakeRightBackId = 0,
        shakeDistanceRatio = 0.0,
        Look = {
          IsLookCtrlObject = false
        },
        Looked = {
          lookTransform = "Head",
          weight = 5000
        }
      }
    }
  },
  [ 1002160002 ] = {
    EntityId = 1002160002,
    EntityName = "1002160002",
    Components = {
      TimeoutDeath = {
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimM02.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002160003
        },
        CreateAttackEntities = {
          1002160003
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        HeadHitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        HeadHitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 20.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -115.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
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
        LineraSpeedType = 2,
        Speed = 60.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100216001 ] = {
    EntityId = 100216001,
    EntityName = "100216001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAim01.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Aim01",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 100216002 ] = {
    EntityId = 100216002,
    EntityName = "100216002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAim02.prefab",
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
        Frame = 30000271,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002160001 ] = {
    EntityId = 1002160001,
    EntityName = "1002160001",
    Components = {
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimM01.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002160
        },
        SoundsByTarget = {
          "KekeR31M11_AimM01Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_AimM01Hit",
          value = 100.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          100216005
        },
        CreateHitEntities = {
          {
            EntityId = 100216005,
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
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.0,
          SpeedZAcceleration = -25.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        HeadHitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        HeadHitParams = {
          SpeedZ = 10.0,
          SpeedZAcceleration = -50.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.5,
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
        LineraSpeedType = 2,
        Speed = 40.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100216003 ] = {
    EntityId = 100216003,
    EntityName = "100216003",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "AimShootL",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimShoot01.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_AimShoot01",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 100216004 ] = {
    EntityId = 100216004,
    EntityName = "100216004",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimShoot02.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_AimShoot02",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 100200101 ] = {
    EntityId = 100200101,
    EntityName = "100200101",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk001N.prefab",
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
  [ 100200301 ] = {
    EntityId = 100200301,
    EntityName = "100200301",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk003N.prefab",
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
        Frame = 70,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100200401 ] = {
    EntityId = 100200401,
    EntityName = "100200401",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk004N.prefab",
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
        Frame = 77,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100200501 ] = {
    EntityId = 100200501,
    EntityName = "100200501",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk005N.prefab",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100200201 ] = {
    EntityId = 100200201,
    EntityName = "100200201",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk002N.prefab",
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
  [ 100216005 ] = {
    EntityId = 100216005,
    EntityName = "100216005",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimM01H.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_AimM01Hit",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      }
    }
  },
  [ 100216006 ] = {
    EntityId = 100216006,
    EntityName = "100216006",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimM02H.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_AimM02Hit",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      }
    }
  },
  [ 1002001001 ] = {
    EntityId = 1002001001,
    EntityName = "1002001001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk001M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 0.1,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.6,
        Height = 0.2,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002001
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          100200102
        },
        CreateHitEntities = {
          {
            EntityId = 100200102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 1002002001 ] = {
    EntityId = 1002002001,
    EntityName = "1002002001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk001M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.6,
        Height = 0.2,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002002
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          100200102
        },
        CreateHitEntities = {
          {
            EntityId = 100200102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.3,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 1002002002 ] = {
    EntityId = 1002002002,
    EntityName = "1002002002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk001M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.6,
        Height = 0.2,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002002
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          100200102
        },
        CreateHitEntities = {
          {
            EntityId = 100200102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
          }
        },
        HitTypeConfigList = {
          {
            HitType = 3,
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 1002003001 ] = {
    EntityId = 1002003001,
    EntityName = "1002003001",
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
        Camp = 1
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 3,
        Radius = 20.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 1.8,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002003
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002004001 ] = {
    EntityId = 1002004001,
    EntityName = "1002004001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk003M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.6,
        Height = 0.2,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002004
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          100200102
        },
        CreateHitEntities = {
          {
            EntityId = 100200102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 1002004002 ] = {
    EntityId = 1002004002,
    EntityName = "1002004002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk001M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.6,
        Height = 0.2,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002004
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          100200102
        },
        CreateHitEntities = {
          {
            EntityId = 100200102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 1002005001 ] = {
    EntityId = 1002005001,
    EntityName = "1002005001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk005M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.6,
        Height = 0.2,
        Width = 1.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        SoundsByTarget = {
          "KekeR31M11_Atk005_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk005_Hit",
          value = 80.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          1002005002
        },
        CreateAttackEntities = {
          1002005002
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 100200102 ] = {
    EntityId = 100200102,
    EntityName = "100200102",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk001H.prefab",
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
  [ 100217001 ] = {
    EntityId = 100217001,
    EntityName = "100217001",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = 0.0,
        BindTransformName = "Bip001RFoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk170Bip001RFoot.prefab",
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
  [ 100217101 ] = {
    EntityId = 100217101,
    EntityName = "100217101",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk170Bip001RFoot.prefab",
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
        Frame = 30000271,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100217201 ] = {
    EntityId = 100217201,
    EntityName = "100217201",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk172.prefab",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002172001 ] = {
    EntityId = 1002172001,
    EntityName = "1002172001",
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
        Frame = 10,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 10,
        ShapeType = 3,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.3,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.65,
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
        MagicsByTargetBeforeHit = {
          1002172
        },
        SoundsByTarget = {
          "KekeR31M11_Atk172_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk172_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          SpeedYAccelerationTimeAloft = 0.0
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
  [ 100201001 ] = {
    EntityId = 100201001,
    EntityName = "100201001",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk010.prefab",
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
        Frame = 70,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100201101 ] = {
    EntityId = 100201101,
    EntityName = "100201101",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk011.prefab",
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
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100204101 ] = {
    EntityId = 100204101,
    EntityName = "100204101",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAim01.prefab",
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
  [ 1002040001 ] = {
    EntityId = 1002040001,
    EntityName = "1002040001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk042AimM.prefab",
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
        AttackType = 5,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002001
        },
        HitGroundCreateEntity = {
          100216005
        },
        CreateHitEntities = {
          {
            EntityId = 100216005,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedZ = 4.0,
          SpeedZAcceleration = -25.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        HeadHitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        HeadHitParams = {
          SpeedZ = 10.0,
          SpeedZAcceleration = -50.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = false,
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
        LineraSpeedType = 2,
        Speed = 30.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050001 ] = {
    EntityId = 1002050001,
    EntityName = "1002050001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100200501,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200502,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050002 ] = {
    EntityId = 1002050002,
    EntityName = "1002050002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050003 ] = {
    EntityId = 1002050003,
    EntityName = "1002050003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050004 ] = {
    EntityId = 1002050004,
    EntityName = "1002050004",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050005 ] = {
    EntityId = 1002050005,
    EntityName = "1002050005",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050006 ] = {
    EntityId = 1002050006,
    EntityName = "1002050006",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050007 ] = {
    EntityId = 1002050007,
    EntityName = "1002050007",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050008 ] = {
    EntityId = 1002050008,
    EntityName = "1002050008",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01.prefab",
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050010
        },
        CreateAttackEntities = {
          1002050010
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.6,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100205001 ] = {
    EntityId = 100205001,
    EntityName = "100205001",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050.prefab",
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
  [ 100203001 ] = {
    EntityId = 100203001,
    EntityName = "100203001",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxMove02.prefab",
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
  [ 100204002 ] = {
    EntityId = 100204002,
    EntityName = "100204002",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimShoot01.prefab",
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
        Frame = 50,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100204302 ] = {
    EntityId = 100204302,
    EntityName = "100204302",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimShoot03.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk042",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      }
    }
  },
  [ 100201002 ] = {
    EntityId = 100201002,
    EntityName = "100201002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001LHand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk010Bip001LHand.prefab",
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
        Frame = 19,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100201102 ] = {
    EntityId = 100201102,
    EntityName = "100201102",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001RHand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk011Bip001RHand.prefab",
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
        Frame = 19,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002005002 ] = {
    EntityId = 1002005002,
    EntityName = "1002005002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk005H.prefab",
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 11,
        ShapeType = 1,
        Radius = 1.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = true,
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
        MagicsByTargetBeforeHit = {
          1002005
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050009 ] = {
    EntityId = 1002050009,
    EntityName = "1002050009",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M02.prefab",
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 301,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002050011
        },
        CreateAttackEntities = {
          1002050011
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 30.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.7,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100205002 ] = {
    EntityId = 100205002,
    EntityName = "100205002",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01H.prefab",
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk051_Hit",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 100205003 ] = {
    EntityId = 100205003,
    EntityName = "100205003",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M02H.prefab",
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
  [ 100203002 ] = {
    EntityId = 100203002,
    EntityName = "100203002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001LFoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxMove02Bip001LFoot.prefab",
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
  [ 100203003 ] = {
    EntityId = 100203003,
    EntityName = "100203003",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001RFoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxMove02Bip001RFoot.prefab",
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
  [ 100205004 ] = {
    EntityId = 100205004,
    EntityName = "100205004",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001LHand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050Bip001LHand.prefab",
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
  [ 1002010001 ] = {
    EntityId = 1002010001,
    EntityName = "1002010001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014M01.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.4,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
        RemoveAfterReach = true,
        ReachRange = 0.5,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        HitGroundCreateEntity = {
          1002010003
        },
        CreateAttackEntities = {
          1002010003
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.25,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.1,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
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
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk014_Missile01",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002011001 ] = {
    EntityId = 1002011001,
    EntityName = "1002011001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014M01.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.4,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
        RemoveAfterReach = true,
        ReachRange = 0.5,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        HitGroundCreateEntity = {
          1002011003
        },
        CreateAttackEntities = {
          1002011003
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.25,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.1,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
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
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
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
  [ 100204202 ] = {
    EntityId = 100204202,
    EntityName = "100204202",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "AimShootR",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk042AimShoot.prefab",
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
  [ 100204102 ] = {
    EntityId = 100204102,
    EntityName = "100204102",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "Shoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimShoot01.prefab",
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
  [ 1002041001 ] = {
    EntityId = 1002041001,
    EntityName = "1002041001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM01.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.3,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002041002
        },
        CreateAttackEntities = {
          1002041002
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        HeadHitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        HeadHitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 20.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -115.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = false,
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
        LineraSpeedType = 2,
        Speed = 40.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002042001 ] = {
    EntityId = 1002042001,
    EntityName = "1002042001",
    Components = {
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk042AimM.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 150,
        ShapeType = 1,
        Radius = 0.3,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002040
        },
        SoundsByTarget = {
          "KekeR31M11_Atk042_Hit"
        },
        HitGroundCreateEntity = {
          100204203
        },
        CreateHitEntities = {
          {
            EntityId = 100204203,
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
          SpeedZ = 4.0,
          SpeedZAcceleration = -25.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        HeadHitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.5,
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
        LineraSpeedType = 2,
        Speed = 40.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk042_Missile",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002043001 ] = {
    EntityId = 1002043001,
    EntityName = "1002043001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM03.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        HitGroundCreateEntity = {
          1002043002
        },
        CreateAttackEntities = {
          1002043002
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        HeadHitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        HeadHitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 20.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -115.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = false,
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
        LineraSpeedType = 2,
        Speed = 40.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100201201 ] = {
    EntityId = 100201201,
    EntityName = "100201201",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = -1.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 100217202 ] = {
    EntityId = 100217202,
    EntityName = "100217202",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk172H.prefab",
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
  [ 100204103 ] = {
    EntityId = 100204103,
    EntityName = "100204103",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM01H.prefab",
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
  [ 100204203 ] = {
    EntityId = 100204203,
    EntityName = "100204203",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk042AimMH.prefab",
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
  [ 100204304 ] = {
    EntityId = 100204304,
    EntityName = "100204304",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM03H.prefab",
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
  [ 1002010002 ] = {
    EntityId = 1002010002,
    EntityName = "1002010002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014M02.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.4,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
        RemoveAfterReach = true,
        ReachRange = 0.5,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        HitGroundCreateEntity = {
          1002010004
        },
        CreateAttackEntities = {
          1002010004
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.25,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.1,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
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
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk014_Missile02",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002011002 ] = {
    EntityId = 1002011002,
    EntityName = "1002011002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014M02.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.4,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
        RemoveAfterReach = true,
        ReachRange = 0.5,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        HitGroundCreateEntity = {
          1002011004
        },
        CreateAttackEntities = {
          1002011004
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.25,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.1,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
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
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
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
  [ 1002050010 ] = {
    EntityId = 1002050010,
    EntityName = "1002050010",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M01H.prefab",
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 16,
        ShapeType = 1,
        Radius = 1.25,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
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
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          1002050
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
        HitParams = {
          SpeedZ = 4.0,
          SpeedZAcceleration = -25.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.7,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002050011 ] = {
    EntityId = 1002050011,
    EntityName = "1002050011",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050M02H.prefab",
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 16,
        ShapeType = 1,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
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
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          1002051
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
        LookatType = 2,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -30.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 2.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.7,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002041002 ] = {
    EntityId = 1002041002,
    EntityName = "1002041002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM01H.prefab",
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
        AttackType = 5,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 16,
        ShapeType = 1,
        Radius = 1.25,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
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
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1002001
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
          SpeedZ = 10.0,
          SpeedZAcceleration = -50.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002042002 ] = {
    EntityId = 1002042002,
    EntityName = "1002042002",
    Components = {
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk042AimM.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 150,
        ShapeType = 1,
        Radius = 0.3,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002040
        },
        SoundsByTarget = {
          "KekeR31M11_Atk042_Hit"
        },
        HitGroundCreateEntity = {
          100204203
        },
        CreateHitEntities = {
          {
            EntityId = 100204203,
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
          SpeedZ = 4.0,
          SpeedZAcceleration = -25.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        HeadHitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
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
        LineraSpeedType = 2,
        Speed = 40.0,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk042_Missile",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002043002 ] = {
    EntityId = 1002043002,
    EntityName = "1002043002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM03H.prefab",
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
        AttackType = 5,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 16,
        ShapeType = 1,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
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
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1002001
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
          SpeedZ = 14.0,
          SpeedZAcceleration = -70.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002160003 ] = {
    EntityId = 1002160003,
    EntityName = "1002160003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimM02H.prefab",
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
        AttackType = 5,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 5,
        ShapeType = 1,
        Radius = 1.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
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
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          1002161
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
          SpeedZ = 6.0,
          SpeedZAcceleration = -30.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 0.0,
          SpeedZAloft = 8.0,
          SpeedYAccelerationAloft = -10.0,
          SpeedYAccelerationTimeAloft = 0.06
        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_AimM02Hit",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002003002 ] = {
    EntityId = 1002003002,
    EntityName = "1002003002",
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
        Camp = 1
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 3,
        Radius = 20.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 1.8,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002003
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100200302 ] = {
    EntityId = 100200302,
    EntityName = "100200302",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk003H.prefab",
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
  [ 100200303 ] = {
    EntityId = 100200303,
    EntityName = "100200303",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk003H1.prefab",
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
  [ 100200402 ] = {
    EntityId = 100200402,
    EntityName = "100200402",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk004H.prefab",
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
  [ 100200202 ] = {
    EntityId = 100200202,
    EntityName = "100200202",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk002H.prefab",
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
  [ 100200502 ] = {
    EntityId = 100200502,
    EntityName = "100200502",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk005H.prefab",
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
  [ 1002060001 ] = {
    EntityId = 1002060001,
    EntityName = "1002060001",
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 7,
        ShapeType = 3,
        Radius = 20.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
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
        MagicsByTargetBeforeHit = {
          1002060
        },
        SoundsByTarget = {
          "KekeR31M11_Atk060_Hit01"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk060_Hit01",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          },
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 2.0,
          SpeedZAcceleration = -10.0,
          SpeedZTime = 0.15,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
  [ 1002060002 ] = {
    EntityId = 1002060002,
    EntityName = "1002060002",
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
        Camp = 1
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
        ShapeType = 3,
        Radius = 20.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.8,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
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
        MagicsByTargetBeforeHit = {
          1002061
        },
        SoundsByTarget = {
          "KekeR31M11_Atk060_Hit02"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk060_Hit02",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          },
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
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
  [ 100206001 ] = {
    EntityId = 100206001,
    EntityName = "100206001",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack060.prefab",
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
  [ 100206002 ] = {
    EntityId = 100206002,
    EntityName = "100206002",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack0603.prefab",
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
  [ 100206003 ] = {
    EntityId = 100206003,
    EntityName = "100206003",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001LFoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack0601Bip001LFoot.prefab",
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
  [ 100206004 ] = {
    EntityId = 100206004,
    EntityName = "100206004",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001RFoot",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack0602Bip001RFoot.prefab",
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
  [ 100206005 ] = {
    EntityId = 100206005,
    EntityName = "100206005",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "LHand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack060LHand.prefab",
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
  [ 100206006 ] = {
    EntityId = 100206006,
    EntityName = "100206006",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "RHand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack060RHand.prefab",
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
  [ 1002990001 ] = {
    EntityId = 1002990001,
    EntityName = "1002990001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxWeakness.prefab",
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
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 1,
        DurationFrame = 4,
        ShapeType = 3,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
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
        MagicsByTargetBeforeHit = {
          1002990
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
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
  [ 1002040002 ] = {
    EntityId = 1002040002,
    EntityName = "1002040002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxCoreAimM03.prefab",
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
        AttackType = 5,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        SoundsByTarget = {
          "KekeR31M11_Atk042_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk042_Hit",
          value = 100.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          1002043002
        },
        CreateAttackEntities = {
          1002043002
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        HeadHitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        HeadHitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 20.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -115.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },
        UseCameraShake = false,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk042_Missile",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 100205005 ] = {
    EntityId = 100205005,
    EntityName = "100205005",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = -1.0,
        BindTransformName = "AimWeaponL",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050AimWeaponL.prefab",
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
  [ 100205006 ] = {
    EntityId = 100205006,
    EntityName = "100205006",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = -1.0,
        BindTransformName = "AimWeaponR",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAttack050AimWeaponR.prefab",
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
  [ 100207001 ] = {
    EntityId = 100207001,
    EntityName = "100207001",
    Components = {
      Effect = {
        IsBind = false,
        BindPositionTime = 0.0,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk07001.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 100207002 ] = {
    EntityId = 100207002,
    EntityName = "100207002",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.3,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk07002.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 1002070001 ] = {
    EntityId = 1002070001,
    EntityName = "1002070001",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 4,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 20.0,
        OffsetX = 0.0,
        OffsetY = 0.65,
        OffsetZ = 10.0,
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
        MagicsByTargetBeforeHit = {
          1002071
        },
        SoundsByTarget = {
          "KekeR31M11_Atk070_Hit01"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk070_Hit01",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
  [ 1002070002 ] = {
    EntityId = 1002070002,
    EntityName = "1002070002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk070M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        SoundsByTarget = {
          "KekeR31M11_Atk070_Hit01"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk070_Hit01",
          value = 100.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          1002070003
        },
        CreateAttackEntities = {
          1002070003
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 1002070003 ] = {
    EntityId = 1002070003,
    EntityName = "1002070003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk070H.prefab",
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 10,
        ShapeType = 1,
        Radius = 1.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002072
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          },
          {
            HitType = 3,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002015001 ] = {
    EntityId = 1002015001,
    EntityName = "1002015001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk015M01.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002040
        },
        HitGroundCreateEntity = {
          100201502
        },
        CreateHitEntities = {
          {
            EntityId = 100201502,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201503,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201504,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
  [ 1002015002 ] = {
    EntityId = 1002015002,
    EntityName = "1002015002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk015M02.prefab",
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
        RemoveDelayFrame = 61,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002041
        },
        HitGroundCreateEntity = {
          100201503,
          1002015003
        },
        CreateAttackEntities = {
          1002015003
        },
        CreateHitEntities = {
          {
            EntityId = 100201503,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.5,
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
  [ 1002012001 ] = {
    EntityId = 1002012001,
    EntityName = "1002012001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014M01.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.4,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
        RemoveAfterReach = true,
        ReachRange = 0.5,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        HitGroundCreateEntity = {
          1002012003
        },
        CreateAttackEntities = {
          1002012003
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.25,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.1,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
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
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
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
  [ 1002012002 ] = {
    EntityId = 1002012002,
    EntityName = "1002012002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014M02.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.4,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
        RemoveAfterReach = true,
        ReachRange = 0.5,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        HitGroundCreateEntity = {
          1002012004
        },
        CreateAttackEntities = {
          1002012004
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.25,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.2,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.2,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.2,
            Sign = 0.0,
            DistanceDampingId = 0.0
          },
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -0.1,
            StartFrequency = 10.0,
            TargetAmplitude = 0.0,
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
        ShakeDir = 2,
        ShakeStrenRatio = 0.4,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100201001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201002,
        AlwaysUpdateTargetPos = true,
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
  [ 1002012003 ] = {
    EntityId = 1002012003,
    EntityName = "1002012003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014H03.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        ShapeType = 3,
        Radius = 5.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002016,
          1002014
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
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
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002012004 ] = {
    EntityId = 1002012004,
    EntityName = "1002012004",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014H04.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        ShapeType = 3,
        Radius = 5.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002016,
          1002015
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
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
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002051001 ] = {
    EntityId = 1002051001,
    EntityName = "1002051001",
    Components = {
      Behavior = {
        Behaviors = {
          "1002051001"
        },
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk051Buff.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 3000000,
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 1002010003 ] = {
    EntityId = 1002010003,
    EntityName = "1002010003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014H01.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        ShapeType = 3,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002010
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
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
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk014_Hit01",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002010004 ] = {
    EntityId = 1002010004,
    EntityName = "1002010004",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014H02.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        ShapeType = 3,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002011
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
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
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk014_Hit02",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002011004 ] = {
    EntityId = 1002011004,
    EntityName = "1002011004",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014H02.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        ShapeType = 3,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002013
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
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
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002011003 ] = {
    EntityId = 1002011003,
    EntityName = "1002011003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk014H01.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        ShapeType = 3,
        Radius = 3.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002012
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
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
        LookatType = 2,
        HitParams = {
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100205101 ] = {
    EntityId = 100205101,
    EntityName = "100205101",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk051.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 100201502 ] = {
    EntityId = 100201502,
    EntityName = "100201502",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk015H01.prefab",
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
  [ 100201501 ] = {
    EntityId = 100201501,
    EntityName = "100201501",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = -1.0,
        BindRotationTime = -1.0,
        BindTransformName = "Role",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk015.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 100201503 ] = {
    EntityId = 100201503,
    EntityName = "100201503",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk015H01.prefab",
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
  [ 1002051002 ] = {
    EntityId = 1002051002,
    EntityName = "1002051002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk051M.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 359.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
        RemoveDelayFrame = 31,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        SoundsByTarget = {
          "KekeR31M11_Atk051_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk051_Hit",
          value = 90.0,
          time = 0.0
        },
        HitGroundCreateEntity = {
          1002051003
        },
        CreateAttackEntities = {
          1002051003
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 2,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.5,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "KekeR31M11_Atk051_Missile",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 1002051003 ] = {
    EntityId = 1002051003,
    EntityName = "1002051003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk051H1.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 16,
        ShapeType = 1,
        Radius = 1.2,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
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
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          1002050
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
        LookatType = 2,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 2.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
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
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 100205001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100205002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 0.7,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        CurveConfig = {
          speed = 0.0,
          speedAccValue = 0.0,
          speedAccTime = 0.0,
          speedAccEndTime = 0.0,
          speedAccEndDist = 0.0,
          speedDecValue = 0.0,
          speedDecTime = 0.0,
          speedYDecValue = 0.0,
          speedYDecMax = 0.0
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100208101 ] = {
    EntityId = 100208101,
    EntityName = "100208101",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk081.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 1002081001 ] = {
    EntityId = 1002081001,
    EntityName = "1002081001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk081M.prefab",
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
        RemoveDelayFrame = 151,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        SoundsByTarget = {
          "kekehit"
        },
        HitGroundCreateEntity = {
          1002081002
        },
        CreateAttackEntities = {
          1002081002
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
          SpeedYAloft = 0.0,
          SpeedZAloft = 0.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 2,
        Speed = 0.0,
        SpeedCurveId = 100200101,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100200501,
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
  [ 100208102 ] = {
    EntityId = 100208102,
    EntityName = "100208102",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk081H.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 100205102 ] = {
    EntityId = 100205102,
    EntityName = "100205102",
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
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk05101.prefab",
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
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
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
  [ 1002015003 ] = {
    EntityId = 1002015003,
    EntityName = "1002015003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk015M01.prefab",
        isClone = false,
        StartRotateType = 2,
        StartRotateX = -85.0,
        RandomMinX = 0.0,
        RandomMaxX = 10.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 359.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 0.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.0
      },
      TimeoutDeath = {
        Frame = 151,
        RemoveDelayFrame = 61,
        RemoveDelayHideList = {
          "core"
        },
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
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 16,
        DurationFrame = 151,
        ShapeType = 1,
        Radius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002042
        },
        HitGroundCreateEntity = {
          100201502
        },
        CreateHitEntities = {
          {
            EntityId = 100201502,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 2
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 100201501,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 100201502,
        AlwaysUpdateTargetPos = true,
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
  [ 1002003003 ] = {
    EntityId = 1002003003,
    EntityName = "1002003003",
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
        Camp = 1
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 3,
        Radius = 20.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 1.8,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002003
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002003004 ] = {
    EntityId = 1002003004,
    EntityName = "1002003004",
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
        Camp = 1
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 3,
        Radius = 20.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 0.0,
        Height = 1.8,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.9,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = true,
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
          1002003
        },
        SoundsByTarget = {
          "KekeR31M11_Atk001_Hit"
        },
        WwisePTRC = {
          paramName = "KekeR31M11_Atk001_Hit",
          value = 80.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 100200102,
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
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.35,
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
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1002081002 ] = {
    EntityId = 1002081002,
    EntityName = "1002081002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk081H.prefab",
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
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 10,
        ShapeType = 1,
        Radius = 2.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
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
        MagicsByTargetBeforeHit = {
          1002081,
          1000042
        },
        SoundsByTarget = {
          "kekehit"
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.7,
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

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100216007 ] = {
    EntityId = 100216007,
    EntityName = "100216007",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "AimShootR",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAimShoot01.prefab",
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
  [ 100204201 ] = {
    EntityId = 100204201,
    EntityName = "100204201",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "AimShootL",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female165/KekeR31/Common/Effect/KekeR31FxAtk042AimShoot.prefab",
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
  }
}
