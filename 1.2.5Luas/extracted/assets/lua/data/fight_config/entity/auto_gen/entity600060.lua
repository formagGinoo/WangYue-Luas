Config = Config or {}
Config.Entity600060 = Config.Entity600060 or { }
local empty = { }
Config.Entity600060 = 
{
  [ 600060 ] = {
    EntityId = 600060,
    EntityName = "600060",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Weihu/WeihuMo1/WeihuMo1.prefab",
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
        MinDistance = 0.5,
        MaxDistance = 1.5,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.85
      },
      Animator = {
        Animator = "Character/Monster/Weihu/WeihuMo1/WeihuMo1.controller",
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
              AnyState = 0.12
            }
          }
        }
      },
      Behavior = {
        Behaviors = {
          "600060"
        },
      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 1,
        NpcTag = 5,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Move = {
        pivot = 0.2,
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
        ConfigName = "WeihuMo1",
        LogicMoveConfigs = {
          Attack003 = 2,
          WeihuAimStart = 2,
          WeihuShoot = 2,
          WeihuAimLoop = 2
        },        BindRotation = false,

      },
      State = {
        DyingTime = 2.4,
        DeathTime = 0.73333,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.467,
            ForceTime = 1.0,
            FusionChangeTime = 0.4,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.467,
            ForceTime = 1.0,
            FusionChangeTime = 0.4,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.767,
            ForceTime = 1.3,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.767,
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
            Time = 0.667,
            ForceTime = 0.667,
            FusionChangeTime = 0.667,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 0.0,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 1.733,
            ForceTime = 1.733,
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
                ParentName = "WeihuMo1",
                LocalPosition = { 0.0, 0.8, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.7, 0.8, 0.7 }
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
                LocalPosition = { 0.207, -0.049, -0.097 },
                LocalEuler = { 0.0, 0.0, 97.02335 },
                LocalScale = { 0.355591983, 0.228954569, 0.4 }
              },
              {
                ShapeType = 3,
                ParentName = "Tail01_c",
                LocalPosition = { -0.21, 0.061, 0.012 },
                LocalEuler = { 358.746033, 3.431203, 233.7226 },
                LocalScale = { 0.201444, 0.122199953, 0.21375902 }
              },
              {
                ShapeType = 3,
                ParentName = "Tail03_c",
                LocalPosition = { -0.05, 0.014, 0.008 },
                LocalEuler = { 8.135, 344.2955, 252.065643 },
                LocalScale = { 0.241680056, 0.122195184, 0.249687463 }
              },
              {
                ShapeType = 3,
                ParentName = "Tail04_c",
                LocalPosition = { 0.001, -0.006, -0.016 },
                LocalEuler = { 12.1516666, 30.1350346, 238.157288 },
                LocalScale = { 0.273536563, 0.1222, 0.3042518 }
              },
              {
                ShapeType = 3,
                ParentName = "Tail05_c",
                LocalPosition = { 0.146, -0.048, 0.049 },
                LocalEuler = { 20.0285282, 0.0, 345.6563 },
                LocalScale = { 0.352314532, 0.213559166, 0.3671853 }
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
            WeakTrasnforms = {
              "Bip001 Head"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.132, 0.034, 0.0 },
                LocalEuler = { 0.0, 0.0, 358.3823 },
                LocalScale = { 0.2728808, 0.395122826, 0.35865 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
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
          [ 600060001 ] = {
            TotalFrame = 25,
            ForceFrame = 25,
            SkillBreakSkillFrame = 25,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 10.0,
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
                ReadyEffectPath = "20034",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "PartnerCharm",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "WeihuAimStart",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 14 ] = {
                {

                  Type = 600060000,
                  Frame = 1,
                  FrameTime = 14,
                  EventType = 3,

                }
              },
              [ 15 ] = {
                {

                  BoneName = "Bip001 Spine2",
                  DurationUpdateTargetFrame = 6,
                  OffsetType = 1,
                  TargetHPositionOffset = 0.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, -1.0, -1.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = -1,
                  IgnoreY = false,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 15,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 24 ] = {
                {

                  Type = 600060001,
                  Frame = 1,
                  FrameTime = 24,
                  EventType = 3,

                }
              },
            }
          },
          [ 600060002 ] = {
            TotalFrame = 999999,
            ForceFrame = 999999,
            SkillBreakSkillFrame = 1,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "WeihuAimLoop",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 600060003 ] = {
            TotalFrame = 50,
            ForceFrame = 50,
            SkillBreakSkillFrame = 50,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "WeihuShoot",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 9 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 4,
                  FrameTime = 9,
                  EventType = 8,

                }
              },
              [ 29 ] = {
                {

                  Type = 600060003,
                  Frame = 1,
                  FrameTime = 29,
                  EventType = 3,

                }
              },
            }
          },
          [ 600060004 ] = {
            TotalFrame = 0,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,

          },
          [ 600060005 ] = {
            TotalFrame = 84,
            ForceFrame = 84,
            SkillBreakSkillFrame = 84,
            ChangeRoleFrame = 84,
            SkillType = 5,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 10.0,
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
                ReadyEffectPath = "20034",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "PartnerCharm",
                BehaviorConfig = 49,
                LayerConfig = 35
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 4,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 32,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  EntityId = 60006000501,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 0,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 600060005001,
                  LifeBindSkill = false,
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
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                }
              },
              [ 42 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 0.0,
                  RotateFrame = 6,
                  FrameTime = 42,
                  EventType = 8,

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
        DefaultAttrID = 900060,
      },
      ElementState = {
        ElementType = 4,
        ElementMaxAccumulateDict = {
          Gold = 150
        }
      },
      Condition = {
        ConditionParamsList = {
          {
            Interval = 2.0,
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

                Duration = 2.0,
                MeetConditionEventType = 2
              }
            },
          }
        },
      },
      SkillSet = {
        UISets = {
          [ 1 ] = {
            ShowId = 1,
            UISetNote = "",
            BindRes1 = 0,
            BindRes2 = 0,
            CoreUIConfig = {
              BindRes = 0,
              Scale = 1.0,
              LocationOffset = { 0.0, 0.0, 0.0 },
              ScreenOffset = { 0.0, 0.0, 0.0 }
            },            J = {
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
              Active = true,
              SkillId = 600060005,

            },
            F = {
              Active = false,
              SkillId = 0,

            },          }
        }
      },
      CommonBehavior = {
        CommonBehaviors = {
          Partner = {
            ComponentBehaviorName = "CommonPartnerBehavior",
            CommonBehaviorParms = {
              [ "进场时间" ] = 0.0,
              [ "退场时间" ] = 0.0,
              [ "退场动作开始帧数" ] = 0.0,
              [ "退场结束时间" ] = 1.5
            }
          }
        }
      }
    }
  },
  [ 60006000502 ] = {
    EntityId = 60006000502,
    EntityName = "60006000502",
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
        Prefab = "Character/Monster/Weihu/WeihuMo1/Effect/FxWeihuMo1Atk005H.prefab",
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
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60006000501 ] = {
    EntityId = 60006000501,
    EntityName = "60006000501",
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
        Prefab = "Character/Monster/Weihu/WeihuMo1/Effect/FxWeihuMo1Atk005.prefab",
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
        Frame = 150,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 600060005001 ] = {
    EntityId = 600060005001,
    EntityName = "600060005001",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Weihu/WeihuMo1/Effect/FxWeihuMo1Atk005M.prefab",
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
        DurationFrame = 90,
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
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          600060005,
          900000014,
          900000015
        },
        HitGroundCreateEntity = {
          60006000502
        },
        CreateHitEntities = {
          {
            EntityId = 60006000502,
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
          SpeedYAloft = 3.0,
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
        Speed = 50.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 30,
        SignId = 900060,
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
  }
}
