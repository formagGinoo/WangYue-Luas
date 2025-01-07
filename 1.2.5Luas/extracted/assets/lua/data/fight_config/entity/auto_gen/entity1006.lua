Config = Config or {}
Config.Entity1006 = Config.Entity1006 or { }
local empty = { }
Config.Entity1006 = 
{
  [ 1006 ] = {
    EntityId = 1006,
    EntityName = "1006",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/QingmenyinR31M11/QingmenyinR31M11.prefab",
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
        ConfigName = "QingmenyinR31M11",
        LogicMoveConfigs = {
          Attack081 = 4,
          Attack080 = 4
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
        HitFlyHeight = 0.2
      },
      Skill = {
        Skills = {
          [ 1006001 ] = {
            TotalFrame = 95,
            ForceFrame = 13,
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
                  StartFrame = 3,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 1006001002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 1,
                  EventType = 10,

                },
                {

                  EntityId = 100600101,
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
                  FrameTime = 1,
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
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 1,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      10000001
                    },
                  }
                },
                {

                  EntityId = 100600102,
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
                  FrameTime = 1,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1006001001,
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
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 7 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 7,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 7,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006002 ] = {
            TotalFrame = 141,
            ForceFrame = 34,
            SkillBreakSkillFrame = 25,
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

                }
              },
              [ 3 ] = {
                {

                  EntityId = 100600201,
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
                  FrameTime = 3,
                  EventType = 1,

                }
              },
              [ 5 ] = {
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
                  MinDistance = 1.0,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 5,
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

                  MagicId = 1006002005,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  EventType = 10,

                },
                {

                  MagicId = 1006002006,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  EventType = 10,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 1006002001,
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
                  FrameTime = 9,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 100600202,
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
                  FrameTime = 15,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 1006002002,
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
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 23 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
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
                  EventType = 3,

                },
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 25,
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

                }
              },
              [ 2 ] = {
                {

                  EntityId = 100600302,
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
                  FrameTime = 2,
                  EventType = 1,

                },
                {

                  EntityId = 100600301,
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
                  FrameTime = 2,
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
                  EventType = 9,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 1006003001,
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
                  FrameTime = 9,
                  EventType = 1,

                }
              },
              [ 28 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 28,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 28,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006004 ] = {
            TotalFrame = 145,
            ForceFrame = 60,
            SkillBreakSkillFrame = 50,
            ChangeRoleFrame = 0,
            SkillType = 1,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1006004003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  EntityId = 100600401,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  FrameTime = 0,
                  EventType = 1,

                },
                {

                  MagicId = 1006004002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "Attack004",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1006004002,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 22,
                  EventType = 3,

                },
                {

                  EntityId = 1006004001,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  FrameTime = 22,
                  EventType = 1,

                }
              },
              [ 40 ] = {
                {

                  AddType = 2,
                  BuffId = 1006004003,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 40,
                  EventType = 9,

                },
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 40,
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
            SkillType = 1,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 3,
                  FrameTime = 0,
                  EventType = 2,

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
                  EventType = 3,

                },
                {

                  EntityId = 100600501,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  FrameTime = 0,
                  EventType = 1,

                }
              },
              [ 2 ] = {
                {

                  Type = 600000007,
                  Frame = 1,
                  FrameTime = 2,
                  EventType = 3,

                }
              },
              [ 5 ] = {
                {

                  MagicId = 1006005002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 5,
                  EventType = 10,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 100600502,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 1006005001,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
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
                  FrameTime = 13,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
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
                  FrameTime = 15,
                  EventType = 4,

                }
              },
              [ 59 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 59,
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
                  EventType = 13,

                }
              },
            }
          },
          [ 1006011 ] = {
            TotalFrame = 89,
            ForceFrame = 34,
            SkillBreakSkillFrame = 22,
            ChangeRoleFrame = 22,
            SkillType = 10,
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
                DodgeEffectPath = "",
                SkillIcon = "XumuR11BlueSkill",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  EntityId = 100601101,
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

                  Name = "Attack011",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  MagicId = 1006011002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 1,
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
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 3,
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
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 4,
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
                  FrameTime = 5,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  Type = 1006010,
                  Frame = 15,
                  FrameTime = 22,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 22,
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
            SkillType = 10,
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
                DodgeEffectPath = "",
                SkillIcon = "XumuR11BlueSkill",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  MagicId = 1006012003,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                },
                {

                  Name = "Attack012",
                  StartFrame = 1,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 100601201,
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
                  FrameTime = 1,
                  EventType = 1,

                }
              },
              [ 2 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 6,
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
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 2,
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
                  FrameTime = 5,
                  EventType = 1,

                }
              },
              [ 11 ] = {
                {

                  EntityId = 100601202,
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
                  FrameTime = 11,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  MagicId = 1006012004,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 15,
                  EventType = 10,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 1006012002,
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
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 35,
                  EventType = 3,

                },
                {

                  Type = 1006010,
                  Frame = 15,
                  FrameTime = 35,
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
            SkillType = 10,
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
                DodgeEffectPath = "",
                SkillIcon = "XumuR11BlueSkill",
                BehaviorConfig = 51,
                LayerConfig = 1123
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack013",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1006013001,
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
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 47 ] = {
                {

                  EntityId = 1006013001,
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
                  FrameTime = 47,
                  EventType = 1,

                },
                {

                  EntityId = 1006013001,
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
                  FrameTime = 47,
                  EventType = 1,

                }
              },
              [ 50 ] = {
                {

                  EntityId = 1006013001,
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
                  FrameTime = 50,
                  EventType = 1,

                }
              },
              [ 55 ] = {
                {

                  EntityId = 1006013001,
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
                  FrameTime = 55,
                  EventType = 1,

                }
              },
              [ 60 ] = {
                {

                  EntityId = 1006013001,
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
                  FrameTime = 60,
                  EventType = 1,

                }
              },
              [ 80 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 80,
                  EventType = 3,

                },
                {

                  Type = 1006013,
                  Frame = 15,
                  FrameTime = 80,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006021 ] = {
            TotalFrame = 138,
            ForceFrame = 68,
            SkillBreakSkillFrame = 58,
            ChangeRoleFrame = 10,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1006001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  EntityId = 100602103,
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
                  EventType = 14,

                },
                {

                  Name = "Attack021",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 20 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 20,
                  EventType = 3,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 100602106,
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
                  FrameTime = 27,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 100602101,
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
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 38 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
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
                  FrameTime = 38,
                  EventType = 4,

                },
                {

                  Type = 1006020,
                  Frame = 1,
                  FrameTime = 38,
                  EventType = 3,

                },
                {

                  EntityId = 1006021001,
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
                  FrameTime = 38,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  EntityId = 100602104,
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
                  FrameTime = 51,
                  EventType = 1,

                }
              },
              [ 59 ] = {
                {

                  EntityId = 100602102,
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
                  FrameTime = 59,
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
            SkillType = 10,
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
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 20 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 20,
                  EventType = 3,

                }
              },
              [ 22 ] = {
                {

                  Type = 1006022,
                  Frame = 1,
                  FrameTime = 22,
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
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack023",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 1006030 ] = {
            TotalFrame = 50,
            ForceFrame = 10,
            SkillBreakSkillFrame = 10,
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

                  Frame = 12,
                  RingCount = 7,
                  FrameTime = 0,
                  EventType = 6,

                },
                {

                  Type = 10000007,
                  Frame = 12,
                  FrameTime = 0,
                  EventType = 3,

                },
                {

                  Name = "Move01",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

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
            }
          },
          [ 1006031 ] = {
            TotalFrame = 84,
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
          [ 1006051 ] = {
            TotalFrame = 225,
            ForceFrame = 189,
            SkillBreakSkillFrame = 189,
            ChangeRoleFrame = 189,
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

                  AddType = 1,
                  BuffId = 1006054,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1006053,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack051",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 1006052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 189 ] = {
                {

                  Type = 10000012,
                  Frame = 1,
                  FrameTime = 189,
                  EventType = 3,

                },
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 189,
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
            SkillType = 52,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
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
                  BuffId = 1006052,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1006054,
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
          [ 1006080 ] = {
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
                  TargetVPositionOffset = 1.0,
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

                  EntityId = 1000000019,
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
          [ 1006081 ] = {
            TotalFrame = 58,
            ForceFrame = 58,
            SkillBreakSkillFrame = 58,
            ChangeRoleFrame = 58,
            SkillType = 81,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack081",
                  StartFrame = 2,
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
                  BuffId = 1006080,
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
                  Duration = 36.0,
                  MaxFallSpeed = 0.0,
                  FrameTime = 0,
                  EventType = 12,

                },
                {

                  AddType = 1,
                  BuffId = 1006082,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 1.2,
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
                      CurveId = 100608103,
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
                {

                  BoneName = "Bip001 Head",
                  DurationUpdateTargetFrame = 1,
                  OffsetType = 2,
                  TargetHPositionOffset = 1.5,
                  TargetVPositionOffset = 0.3,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 60.0,
                  MinSpeed = 0.0,
                  FrameTime = 3,
                  EventType = 18,

                }
              },
              [ 11 ] = {
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
                  FrameTime = 11,
                  EventType = 4,

                },
                {

                  EntityId = 1006081003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 2,
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
              [ 26 ] = {
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
                  FrameTime = 26,
                  EventType = 4,

                },
                {

                  EntityId = 1006081002,
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
                  FrameTime = 26,
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
              [ 37 ] = {
                {

                  ResetSpeed = true,
                  UseGravity = true,
                  BaseSpeed = 0.0,
                  AccelerationY = 0.0,
                  Duration = 21.0,
                  MaxFallSpeed = -999.0,
                  FrameTime = 37,
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
          [ 1006901 ] = {
            TotalFrame = 95,
            ForceFrame = 13,
            SkillBreakSkillFrame = 6,
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
                  StartFrame = 5,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  MagicId = 1006001002,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 10,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 100600101,
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
                  FrameTime = 1,
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
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 1,
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
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 6 ] = {
                {

                  Type = 10000002,
                  Frame = 12,
                  FrameTime = 6,
                  EventType = 3,

                }
              },
              [ 8 ] = {
                {

                  Type = 10000011,
                  Frame = 15,
                  FrameTime = 8,
                  EventType = 3,

                }
              },
            }
          },
          [ 1006996 ] = {
            TotalFrame = 78,
            ForceFrame = 20,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 16,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 600000020,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 600000007,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack021",
                  StartFrame = 21,
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
              [ 12 ] = {
                {

                  Type = 600000002,
                  Frame = 1,
                  FrameTime = 12,
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
                  EventType = 9,

                }
              },
            }
          },
          [ 1006997 ] = {
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
                  StartFrame = 40,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 600000020,
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

                  AddType = 1,
                  BuffId = 1000051,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Type = 10600001,
                  Frame = 1,
                  FrameTime = 0,
                  EventType = 3,

                }
              },
              [ 30 ] = {
                {

                  MagicId = 1000048,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 30,
                  EventType = 10,

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
            BindRes1 = 1204,
            BindRes2 = 0,
            CoreUIConfig = {
              BindRes = 1204,
              UIPath = "Prefabs/UI/Fight/CoreRes/CoreUI1001.prefab",
              Scale = 1.0,
              LocationOffset = { 0.0, 0.825, 0.0 },
              ScreenOffset = { -120.0, 80.0, 0.0 }
            },            J = {
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
              Active = false,
              SkillId = 1001051,
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
      Swim = {
        SwimHeightInterval = 1.1,
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
  [ 1006001001 ] = {
    EntityId = 1006001001,
    EntityName = "1006001001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006005001 ] = {
    EntityId = 1006005001,
    EntityName = "1006005001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
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
          1006005001
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 1,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 1,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
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
    EntityName = "1006004001",
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
        Frame = 30,
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
        DurationFrame = 30,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = true,
        IntervalFrame = 5,
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
          1006004001
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 1,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
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
    EntityName = "1006003001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 2.0,
        Repetition = true,
        IntervalFrame = 4,
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
          1006003001
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
          },
          {
            HitType = 2,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = -3.5,
          SpeedZAcceleration = 2.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006002001 ] = {
    EntityId = 1006002001,
    EntityName = "1006002001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006002001
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
          SpeedZ = 2.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006002002 ] = {
    EntityId = 1006002002,
    EntityName = "1006002002",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006002002
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
          SpeedZ = 4.5,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
          }
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006003002 ] = {
    EntityId = 1006003002,
    EntityName = "1006003002",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 2.0,
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
          1006003002
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006003003 ] = {
    EntityId = 1006003003,
    EntityName = "1006003003",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 2.0,
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
          1006003003
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006004002 ] = {
    EntityId = 1006004002,
    EntityName = "1006004002",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
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
          SpeedZ = -2.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1006004003 ] = {
    EntityId = 1006004003,
    EntityName = "1006004003",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006004001
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
        },        UseCameraShake = true,
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006004004 ] = {
    EntityId = 1006004004,
    EntityName = "1006004004",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006004001
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
        },        UseCameraShake = true,
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006004005 ] = {
    EntityId = 1006004005,
    EntityName = "1006004005",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006004001
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
        },        UseCameraShake = true,
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006011001 ] = {
    EntityId = 1006011001,
    EntityName = "1006011001",
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
        Frame = 20,
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
        DurationFrame = 20,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 5.0,
        Height = 2.5,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
        Repetition = true,
        IntervalFrame = 4,
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
          1006011001
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006012001 ] = {
    EntityId = 1006012001,
    EntityName = "1006012001",
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
        DurationFrame = 3,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006001001
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.05,
            StartAmplitude = 0.5,
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
            Random = 0.0,
            StartOffset = 0.05,
            StartAmplitude = 0.3,
            StartFrequency = 7.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 1.0,
            AmplitudeChangeTime = 0.14,
            FrequencyChangeTime = 0.14,
            DurationTime = 0.14,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006012002 ] = {
    EntityId = 1006012002,
    EntityName = "1006012002",
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
        Frame = 5,
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
        DurationFrame = 5,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
          1006001001
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
          SpeedZ = 4.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 18.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 2.0,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
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
            Random = 0.0,
            StartOffset = 0.05,
            StartAmplitude = 1.0,
            StartFrequency = 4.0,
            TargetAmplitude = 0.2,
            TargetFrequency = 6.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.15,
            DurationTime = 0.24,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 5,
        PFTimeScale = 0.02,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.02,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.1,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006013001 ] = {
    EntityId = 1006013001,
    EntityName = "1006013001",
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
        Frame = 5,
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
        DurationFrame = 5,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
        Repetition = false,
        IntervalFrame = 9,
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 4,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006021001 ] = {
    EntityId = 1006021001,
    EntityName = "1006021001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 10.0,
        Height = 1.7,
        Width = 10.0,
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
          1006001001
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
          SpeedZ = 4.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 10.0,
          SpeedYAcceleration = -30.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 15.0,
          SpeedZAloft = 5.0,
          SpeedYAccelerationAloft = -20.0,
          SpeedYAccelerationTimeAloft = 0.3
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 1,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006022001 ] = {
    EntityId = 1006022001,
    EntityName = "1006022001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 1006023001 ] = {
    EntityId = 1006023001,
    EntityName = "1006023001",
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
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 1.7,
        Width = 2.5,
        OffsetX = 0.0,
        OffsetY = 0.85,
        OffsetZ = 1.25,
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
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 2,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.03,
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
  [ 100600101 ] = {
    EntityId = 100600101,
    EntityName = "100600101",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001.prefab",
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
  [ 100600201 ] = {
    EntityId = 100600201,
    EntityName = "100600201",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk002D1.prefab",
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
    EntityName = "100600202",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk002D2.prefab",
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
    EntityName = "100600301",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk003D1.prefab",
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
  [ 100600302 ] = {
    EntityId = 100600302,
    EntityName = "100600302",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk003D2.prefab",
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
    EntityName = "100600401",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk004.prefab",
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
    EntityName = "100600501",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk005D1.prefab",
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
    EntityName = "100600502",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk005D2.prefab",
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
    EntityName = "1006081001",
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
  [ 1006081002 ] = {
    EntityId = 1006081002,
    EntityName = "1006081002",
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
          1006081,
          1000042
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
  [ 1006081003 ] = {
    EntityId = 1006081003,
    EntityName = "1006081003",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk081.prefab",
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
        Frame = 165,
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
        DurationFrame = 15,
        ShapeType = 2,
        Radius = 20000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = true,
        IntervalFrame = 3,
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
          1006004001
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
          SpeedYAccelerationTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 1,
        PFTimeScale = 0.03,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 0.03,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 0.03,
        PFSceneSpeedCurve = "-1",
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
    EntityName = "100602101",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021.prefab",
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
        Frame = 84,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
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
    EntityName = "100602102",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021Land.prefab",
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
        Frame = 75,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
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
    EntityName = "100602103",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021R.prefab",
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
        Frame = 114,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100602104 ] = {
    EntityId = 100602104,
    EntityName = "100602104",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021wuqi_000.prefab",
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
        Frame = 144,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindPositionTime = 4.8,
        BindRotationTime = 0.0,
        BindTransformName = "wuqi_000",
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
    EntityName = "100602105",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021wuqi_001.prefab",
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
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
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
    EntityName = "100602106",
    Components = {
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk021Cure.prefab",
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
        Frame = 120,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
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
    EntityName = "100601101",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 2.0,
        BindRotationTime = 2.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk011.prefab",
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
    EntityName = "100601201",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012D1.prefab",
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
    EntityName = "100601202",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk012D2.prefab",
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
    EntityName = "100601301",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001.prefab",
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
  [ 100600102 ] = {
    EntityId = 100600102,
    EntityName = "100600102",
    Components = {
      Effect = {
        IsBind = true,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001D1.prefab",
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
  [ 100600103 ] = {
    EntityId = 100600103,
    EntityName = "100600103",
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
        Prefab = "Character/Role/Female135/QingmenyinR31/Common/Effect/FxQingmenyinR31M11Atk001H.prefab",
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
