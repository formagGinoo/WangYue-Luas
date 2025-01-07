Config = Config or {}
Config.Entity600071 = Config.Entity600071 or { }
local empty = { }
Config.Entity600071 = 
{
  [ 600071 ] = {
    EntityId = 600071,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/LuohouzhankeMo2.prefab",
        Model = "LuohouzhankeMo2",
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
      Animator = {
        Animator = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/LuohouzhankeMo2.controller",
        AnimationConfigID = "900071",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              AnyState = 0.15,
              Stun = 0.297,
              RightSlightHit = 0.0,
              LeftSlightHit = 0.0,
              LeftHeavyHit = 0.0,
              RightHeavyHit = 0.0,
              HitDown = 0.0,
              HitFlyUp = 0.0,
              HitFlyHover = 0.0
            }
          }
        }
      },
      Attributes = {
        DefaultAttrID = 600010,
      },
      Behavior = {
        Behaviors = {
          "600071"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 5,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Move = {
        pivot = 1.05,
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
        ConfigName = "LuohouzhankeMo2",
        LogicMoveConfigs = {
          BackLeavyHit = 6
        },        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      State = {
        DyingTime = 2.333,
        DeathTime = 1.5,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.333,
            ForceTime = 0.867,
            FusionChangeTime = 0.4,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.4,
            ForceTime = 0.867,
            FusionChangeTime = 0.4,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.667,
            ForceTime = 1.333,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.8,
            ForceTime = 1.333,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 0.566,
            ForceTime = 0.566,
            FusionChangeTime = 0.566,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.4,
            ForceTime = 1.4,
            FusionChangeTime = 1.4,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.2667,
            ForceTime = 0.2667,
            FusionChangeTime = 0.2667,
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
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 0.0,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 0.933,
            ForceTime = 0.933,
            FusionChangeTime = 0.8,
            IgnoreHitTime = 0.0
          }
        },
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
                LocalPosition = { 0.0, 0.017, -0.236 },
                LocalEuler = { 90.0, 0.0, 0.0 },
                LocalScale = { 1.1, 0.85, 1.1 },
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
                LocalPosition = { -0.104, 0.01, 0.0 },
                LocalEuler = { 281.385559, 270.000336, 179.999527 },
                LocalScale = { 0.6, 0.6, 0.6 },
                UseMeshCollider = false
              }
            },
            LogicSearch = false,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "CounterPart",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 3,
                LocalPosition = { 0.0, 0.769, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.2, 1.1, 1.2 },
                UseMeshCollider = false
              }
            },
            LogicSearch = false,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = false,
            DmgPartHurtOpen = false,
            OnlyHitAlarm = true
          }
        },
        isTrigger = true
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
          [ 600071001 ] = {
            TotalFrame = 40,
            ForceFrame = 40,
            SkillBreakSkillFrame = 40,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 0.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 5,
                UseParentCost = true,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_SkillPanel_jiuxu.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "PartnerCharm",
                BehaviorConfig = 51,
                LayerConfig = 1059
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack004",
                  LayerIndex = 0,
                  StartFrame = 7,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 120.0,
                  RotateFrame = 23,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 12 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 1.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 9.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.4,
                      FrequencyChangeTime = 0.4,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 1.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.3,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.5,
                      FrequencyChangeTime = 0.5,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 60007102,
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

                  EntityId = 600070001,
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

                }
              },
              [ 912 ] = {
                {

                  ChangeAmplitud = 4.0,
                  ChangeTime = 0.33,
                  FrameTime = 912,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 920 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = true,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.7,
                      StartFrequency = 4.0,
                      TargetAmplitude = -0.4,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.233,
                      FrequencyChangeTime = 0.233,
                      DurationTime = 0.33,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 920,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 922 ] = {
                {

                  ChangeAmplitud = -4.0,
                  ChangeTime = 0.1,
                  FrameTime = 922,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
            }
          },
          [ 600071002 ] = {
            TotalFrame = 54,
            ForceFrame = 54,
            SkillBreakSkillFrame = 54,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 5.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 5,
                UseParentCost = true,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_SkillPanel_jiuxu.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "PartnerCharm",
                BehaviorConfig = 51,
                LayerConfig = 1059
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  LayerIndex = 0,
                  StartFrame = 10,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 120.0,
                  RotateFrame = 15,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 4 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.4,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.1,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.1,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 60007106,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.1,
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
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 60007104,
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
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 60007105,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.1,
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
              [ 38 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = 0.6,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.5,
                      FrequencyChangeTime = 0.5,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 38,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 600071003 ] = {
            TotalFrame = 110,
            ForceFrame = 110,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 5.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 1,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 5,
                UseParentCost = true,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_SkillPanel_jiuxu.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "LuohouzhankeSkill",
                BehaviorConfig = 51,
                LayerConfig = 1059
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack004",
                  LayerIndex = 0,
                  StartFrame = 3,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 120.0,
                  RotateFrame = 23,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  EventName = "LuohouzhankeMo1_ATK003C",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 18 ] = {
                {

                  EventName = "LuohouzhankeMo1_ATK004_Hit",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EntityId = 60007107,
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
              [ 19 ] = {
                {

                  EntityId = 60007102,
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
              [ 20 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.8,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.231,
                      FrequencyChangeTime = 0.198,
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
                      StartAmplitude = 0.5,
                      StartFrequency = 2.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.12,
                      FrequencyChangeTime = 0.12,
                      DurationTime = 0.12,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 38 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 120.0,
                  RotateFrame = 15,
                  FrameTime = 38,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  Name = "Attack005",
                  LayerIndex = 0,
                  StartFrame = 3,
                  FrameTime = 38,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 47 ] = {
                {

                  EventName = "LuohouzhankeMo1_ATK008B",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 47,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 50 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = 0.6,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.231,
                      FrequencyChangeTime = 0.198,
                      DurationTime = 0.264,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 50,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 51 ] = {
                {

                  EntityId = 60007105,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.1,
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

                  EntityId = 60007104,
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
                  FrameTime = 51,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 60007106,
                  LifeBindSkill = false,
                  CreateEntityType = 2,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.1,
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
                  FrameTime = 51,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 66 ] = {
                {

                  EventName = "LuohouzhankeMo1_ATK012",
                  LifeBindSkill = true,
                  StopDelayFrame = 3,
                  StopFadeDuration = 5,
                  FrameTime = 66,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 83 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = 0.8,
                      StartFrequency = 8.0,
                      TargetAmplitude = 0.4,
                      TargetFrequency = 4.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.396,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 83,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 105 ] = {
                {

                  Type = 600000020,
                  Frame = 1,
                  FrameTime = 105,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 916 ] = {
                {

                  ChangeAmplitud = 4.0,
                  ChangeTime = 0.33,
                  FrameTime = 916,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 920 ] = {
                {

                  Direction = 3,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = -1.0,
                  SpeedType = 1,
                  SpeedOffset = 2.0,
                  Acceleration = 0.0,
                  MoveFrame = 13,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 920,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                },
                {

                  Enable = false,
                  FrameTime = 920,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 19,

                }
              },
              [ 924 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = true,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.7,
                      StartFrequency = 4.0,
                      TargetAmplitude = -0.4,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.233,
                      FrequencyChangeTime = 0.233,
                      DurationTime = 0.33,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 924,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 926 ] = {
                {

                  ChangeAmplitud = -4.0,
                  ChangeTime = 0.1,
                  FrameTime = 926,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 939 ] = {
                {

                  Enable = true,
                  FrameTime = 939,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 19,

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
        ElementType = 6,
        ElementMaxAccumulateDict = {
          Fire = 12000
        }
      },
      FindPath = empty,
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
      Sound = empty,
      CommonBehavior = {
        CommonBehaviors = {
          Partner = {
            ComponentBehaviorName = "CommonPartnerBehavior",
            NewCommonBehaviorParms = {
              [ "进场时间" ] = 0.0,
              [ "退场时间" ] = 0.0,
              [ "退场动作开始帧数" ] = 0.0,
              [ "退场结束时间" ] = 1.0,
              [ "进场magicId" ] = 0.0
            }
          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
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
              Active = true,
              SkillId = 600071003,

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
        Height = 2.1,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      }
    }
  },
  [ 60007101 ] = {
    EntityId = 60007101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 1.0,
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
        Prefab = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/Effect/FxLuohouzhankeMo2Atk004D.prefab",
        Model = "FxLuohouzhankeMo2Atk004D",
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
        Frame = 85,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60007102 ] = {
    EntityId = 60007102,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/Effect/FxLuohouzhankeMo2Atk004M.prefab",
        Model = "FxLuohouzhankeMo2Atk004M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 31,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 1.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 0.5,
        Height = 2.0,
        Width = 1.0,
        OffsetX = 0.25,
        OffsetY = 1.0,
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
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          60007103
        },
        SoundsByTarget = {
          "LuohouzhankeMo1_ATK001_Hit"
        },
        CreateHitEntities = {
          {
            EntityId = 60007103,
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
          SpeedZ = 6.0,
          SpeedZAcceleration = -18.0,
          SpeedZTime = 0.35,
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
        Speed = 20.0,
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
  [ 60007103 ] = {
    EntityId = 60007103,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 1.0,
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
        Prefab = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/Effect/FxLuohouzhankeMo2Atk004H.prefab",
        Model = "FxLuohouzhankeMo2Atk004H",
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
      }
    }
  },
  [ 60007104 ] = {
    EntityId = 60007104,
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
        Frame = 35,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 32,
        DurationFrame = 3,
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
        Lenght = 0.0,
        Height = 0.5,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          60007101
        },
        WwisePTRC = {
          paramName = "CongshiMo1_Atk014_Hit",
          value = 100.0,
          time = 0.0
        },        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 10.0,
          SpeedZAcceleration = -13.0,
          SpeedZTime = 0.5,
          SpeedY = 15.0,
          SpeedZHitFly = 4.0,
          SpeedYAcceleration = -100.0,
          SpeedYAccelerationTime = 0.1,
          SpeedZHitFlyTime = 0.166,
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
        },        UseCameraShake = false,
        CameraShakes = empty,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        PauseFrames = {
          [ 0 ] = {
            IsCanBreak = false,
            PFFrame = 4,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 4,
            TargetPFTimeScale = 0.1,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.1,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.1,
            PFSceneSpeedCurve = "-1"
          }
        },        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60007105 ] = {
    EntityId = 60007105,
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
        Prefab = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/Effect/FxLuohouzhankeMo2Atk005D.prefab",
        Model = "FxLuohouzhankeMo2Atk005D",
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
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60007106 ] = {
    EntityId = 60007106,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Luohouzhanke/LuohouzhankeMo2/Effect/FxLuohouzhankeMo2Atk005D2.prefab",
        Model = "FxLuohouzhankeMo2Atk005D2",
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
        Frame = 110,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60007107 ] = {
    EntityId = 60007107,
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
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 1.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 1.7,
        Height = 1.5,
        Width = 1.8,
        OffsetX = 0.0,
        OffsetY = 0.8,
        OffsetZ = 0.9,
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
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        WwisePTRC = {
          paramName = "CongshiMo1_Atk014_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 9000710303,
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
          SpeedZ = 5.0,
          SpeedZAcceleration = -3.0,
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
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.2,
              StartAmplitude = -0.6,
              StartFrequency = 2.0,
              TargetAmplitude = -0.4,
              TargetFrequency = 5.0,
              AmplitudeChangeTime = 0.133,
              FrequencyChangeTime = 0.1,
              DurationTime = 0.166,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.15,
              StartAmplitude = -0.4,
              StartFrequency = 2.0,
              TargetAmplitude = 0.25,
              TargetFrequency = 4.0,
              AmplitudeChangeTime = 0.133,
              FrequencyChangeTime = 0.133,
              DurationTime = 0.198,
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
          [ 0 ] = {
            IsCanBreak = false,
            PFFrame = 4,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 3,
            TargetPFTimeScale = 0.02,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.02,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeed = 0.02,
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
  }
}
