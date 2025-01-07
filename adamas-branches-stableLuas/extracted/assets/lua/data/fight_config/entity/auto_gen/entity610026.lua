Config = Config or {}
Config.Entity610026 = Config.Entity610026 or { }
local empty = { }
Config.Entity610026 = 
{
  [ 610026 ] = {
    EntityId = 610026,
    Components = {
      Transform = {
        Prefab = "Character/Monster/ShilongMe/ShilongMe4/ShilongMe4.prefab",
        Model = "ShilongMe4",
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
        Animator = "Character/Monster/ShilongMe/ShilongMe4/ShilongMe4P.controller",
        AnimationConfigID = "610026",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              Stun = 0.25,
              RightSlightHit = 0.0,
              LeftSlightHit = 0.0,
              LeftHeavyHit = 0.0,
              RightHeavyHit = 0.0,
              HitDown = 0.0,
              Attack002 = 0.0
            }
          }
        }
      },
      Attributes = {
        DefaultAttrID = 910025,
      },
      Tag = {
        Tag = 1,
        NpcTag = 9,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 20
      },
      Move = {
        pivot = 0.71,
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
        ConfigName = "ShilongMe4",
        LogicMoveConfigs = {
          BeAssassin = 2,
          BackLeavyHit = 2,
          Attack001 = 2,
          Attack002 = 2,
          Attack051 = 2,
          Attack053 = 2,
          Attack057 = 2,
          Attack003 = 2,
          Alert = 2,
          Attack056 = 2
        },        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      State = {
        DyingTime = 2.83,
        DeathTime = 0.7333,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 1.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.13333333,
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
                LocalPosition = { 0.0, 1.15, 0.5 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.0, 1.15, 2.0 },
                UseMeshCollider = false
              }
            },
            DefaultEnable = true,
            ColliderFollow = 2,
            FollowBone = "ColliderPosition"
          }
        },
        CollisionRadius = 0.75,
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
                LocalPosition = { -0.0146442335, 1.39753664, 0.105926871 },
                LocalEuler = { 354.208618, 101.341423, 16.1830578 },
                LocalScale = { 1.0, 1.0, 1.0 },
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
                LocalScale = { 1.0, 0.283923984, 1.0 },
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
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
      ElementState = {
        ElementType = 6,
        ElementMaxAccumulateDict = {
          Wood = 200
        }
      },
      FindPath = empty,
      Condition = {
        ConditionParamsList = {
          {
            Interval = 1.0,
            Count = -1,
            ConditionList = {
              {

                Count = 8,
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

                Duration = 0.0,
                MeetConditionEventType = 2
              }
            },
          }
        },
      },
      Ik = {
        shakeLeftFrontId = 9100251,
        shakeLeftBackId = 9100252,
        shakeRightFrontId = 9100253,
        shakeRightBackId = 9100254,
        shakeDistanceRatio = 1.0,
        workWithOutImmuneHit = false,
        Look = {
          IsLookCtrlObject = true
        },
        Looked = {
          lookTransform = "Head",
          weight = 3200
        },
        AimSingleHand = {
          WeightSmoothTime = 0.0,
          DegreeUpX = 60.0,
          DegreeDownX = 20.0,

        },
        AimTwoHand = {
          WeightSmoothTime = 0.0,
          DegreeUpX = 60.0,
          DegreeDownX = 20.0,

        }
      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 1.5,
        RadiusOut = 2.5,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      CommonBehavior = {
        CommonBehaviors = {
          DisplayInteract = {
            ComponentBehaviorName = "CommonDisplayInteractBehavior",

          },
          PartnerWork = {
            ComponentBehaviorName = "CommonPartnerWorkBehavior",

          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Joint = {
        IsCanJoint = false,
        adsorbDistance = 4.0,
        IsDisableRotation = true,
        IsSetKinematic = true,
        IsDisableMove = false,
        IsCallBehavior = false,
        OnlyCanUseBuildPoint = false,
        IsAutoCheckAngle = false,
        maxAngle = 45
      },
      Display = {
        isDecoration = false,
        Bodyily = 2,
        DisplayEvents = {
          {
            DisplayType = 99,
            Note = "交互",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 1,
                animName = "TouchIn",
              },
              {
                animType = 2,
                animName = "TouchLoop",
              },
              {
                animType = 3,
                animName = "TouchOut",
              }
            },
          },
          {
            DisplayType = 98,
            Note = "举起",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 2,
                animName = "HitFlyHover",
              }
            },
          },
          {
            DisplayType = 0,
            Note = "闲置",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 2,
                animName = "Stand1",
              }
            },
          },
          {
            DisplayType = 2,
            Note = "通用工作",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 1,
                animName = "CommonWorkIn",
                CreateEntitys = {
                  {
                    EntityId = 61002601,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              },
              {
                animType = 2,
                animName = "CommonWorkLoop",
                CreateEntitys = {
                  {
                    EntityId = 61002602,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              },
              {
                animType = 3,
                animName = "CommonWorkOut",
                CreateEntitys = {
                  {
                    EntityId = 61002603,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              }
            },
          },
          {
            DisplayType = 1,
            Note = "攻击工作",
            LayerIndex = 0,
          },
          {
            DisplayType = 3,
            Note = "施法工作",
            LayerIndex = 0,
          },
          {
            DisplayType = 4,
            Note = "睡眠",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 1,
                animName = "SleepIn",
              },
              {
                animType = 2,
                animName = "SleepLoop",
              },
              {
                animType = 3,
                animName = "SleepOut",
              }
            },
          },
          {
            DisplayType = 5,
            Note = "进食",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 1,
                animName = "EatIn",
              },
              {
                animType = 2,
                animName = "EatLoop",
              },
              {
                animType = 3,
                animName = "EatOut",
              }
            },
          }
        },
        StateEvents = {
          {
            StateType = 0,
            Note = "常态",
            LayerIndex = 0,
          },
          {
            StateType = 1,
            Note = "饥饿",
            LayerIndex = 0,
            CreateEntitys = {
              {
                EntityId = 600000021,
                Scale = { 1.0, 1.0, 1.0 }
              }
            },
          },
          {
            StateType = 2,
            Note = "抑郁",
            LayerIndex = 0,
            CreateEntitys = {
              {
                EntityId = 600000020,
                Scale = { 1.0, 1.0, 1.0 }
              }
            },
          },
          {
            StateType = 3,
            Note = "饥饿&&抑郁",
            LayerIndex = 0,
            CreateEntitys = {
              {
                EntityId = 600000021,
                Scale = { 1.0, 1.0, 1.0 }
              },
              {
                EntityId = 600000020,
                Scale = { 1.0, 1.0, 1.0 }
              }
            },
          },
          {
            StateType = 4,
            Note = "交互中",
            LayerIndex = 0,
            CreateEntitys = {
              {
                EntityId = 600000023,
                Scale = { 1.5, 1.5, 1.5 }
              }
            },
          },
          {
            StateType = 5,
            Note = "举起",
            LayerIndex = 0,
          }
        },
      }
    }
  },
  [ 61002601 ] = {
    EntityId = 61002601,
    Components = {
      Effect = {
        IsHang = true,
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
        Prefab = "Character/Monster/ShilongMe/ShilongMe4/Partner/Effect/FxShilongMe4CommonWorkIn.prefab",
        Model = "FxShilongMe4CommonWorkIn",
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
        Frame = 125,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 61002602 ] = {
    EntityId = 61002602,
    Components = {
      Effect = {
        IsHang = true,
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
        Prefab = "Character/Monster/ShilongMe/ShilongMe4/Partner/Effect/FxShilongMe4CommonWorkLoop.prefab",
        Model = "FxShilongMe4CommonWorkLoop",
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
  [ 61002603 ] = {
    EntityId = 61002603,
    Components = {
      Effect = {
        IsHang = true,
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
        Prefab = "Character/Monster/ShilongMe/ShilongMe4/Partner/Effect/FxShilongMe4CommonWorkOut.prefab",
        Model = "FxShilongMe4CommonWorkOut",
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
        Frame = 95,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
