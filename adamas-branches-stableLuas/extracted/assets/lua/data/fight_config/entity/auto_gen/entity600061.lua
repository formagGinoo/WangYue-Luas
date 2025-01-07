Config = Config or {}
Config.Entity600061 = Config.Entity600061 or { }
local empty = { }
Config.Entity600061 = 
{
  [ 600061 ] = {
    EntityId = 600061,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Weihu/WeihuMo1/WeihuMo1.prefab",
        Model = "WeihuMo1",
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
        Animator = "Character/Monster/Weihu/WeihuMo1/WeihuMo1P.controller",
        AnimationConfigID = "600061",
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
      Tag = {
        Tag = 1,
        NpcTag = 9,
        SceneObjectTag = 1,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Move = {
        pivot = 0.2,
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
        ConfigName = "WeihuMo1P",
        LogicMoveConfigs = {
          Attack003 = 2,
          WeihuAimStart = 2,
          WeihuShoot = 2,
          WeihuAimLoop = 2,
          Attack605 = 2
        },        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
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
                LocalScale = { 0.7, 0.8, 0.7 },
                UseMeshCollider = false
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
                LocalScale = { 0.355591983, 0.228954569, 0.4 },
                UseMeshCollider = false
              },
              {
                ShapeType = 3,
                ParentName = "Tail01_c",
                LocalPosition = { -0.21, 0.061, 0.012 },
                LocalEuler = { 358.746033, 3.431203, 233.7226 },
                LocalScale = { 0.201444, 0.122199953, 0.21375902 },
                UseMeshCollider = false
              },
              {
                ShapeType = 3,
                ParentName = "Tail03_c",
                LocalPosition = { -0.05, 0.014, 0.008 },
                LocalEuler = { 8.135, 344.2955, 252.065643 },
                LocalScale = { 0.241680056, 0.122195184, 0.249687463 },
                UseMeshCollider = false
              },
              {
                ShapeType = 3,
                ParentName = "Tail04_c",
                LocalPosition = { 0.001, -0.006, -0.016 },
                LocalEuler = { 12.1516666, 30.1350346, 238.157288 },
                LocalScale = { 0.273536563, 0.1222, 0.3042518 },
                UseMeshCollider = false
              },
              {
                ShapeType = 3,
                ParentName = "Tail05_c",
                LocalPosition = { 0.146, -0.048, 0.049 },
                LocalEuler = { 20.0285282, 0.0, 345.6563 },
                LocalScale = { 0.352314532, 0.213559166, 0.3671853 },
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
                LocalScale = { 0.2728808, 0.395122826, 0.35865 },
                UseMeshCollider = false
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          }
        },
        animStrClips = {
          "Stand2",
          "Alert",
          "Attack001",
          "Attack002",
          "Attack003",
          "Attack004",
          "Attack005",
          "Attack007",
          "Death",
          "HitDown",
          "HitFlyFall",
          "HitFlyHover",
          "HitFlyLand",
          "HitFlyUp",
          "Lie",
          "Palsy",
          "Run",
          "StandUp",
          "Stun",
          "SwimDeath",
          "Walk",
          "WalkBack",
          "WalkLeft",
          "WalkRight",
          "WeihuAimLoop",
          "WeihuAimStart",
          "WeihuShoot",
          "RightHeavyHit",
          "RightSlightHit",
          "LeftHeavyHit",
          "LeftSlightHit",
          "CommonWorkIn",
          "CommonWorkLoop",
          "CommonWorkOut",
          "SleepIn",
          "SleepLoop",
          "SleepOut",
          "TouchIn",
          "TouchLoop",
          "TouchOut"
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
      },
      CommonBehavior = {
        CommonBehaviors = {
          PartnerWork = {
            ComponentBehaviorName = "CommonPartnerWorkBehavior",

          },
          DisplayInteract = {
            ComponentBehaviorName = "CommonDisplayInteractBehavior",

          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Sound = empty,
      Display = {
        isDecoration = false,
        Bodyily = 1,
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
                    EntityId = 60006101,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              },
              {
                animType = 2,
                animName = "CommonWorkLoop",
                CreateEntitys = {
                  {
                    EntityId = 60006102,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              },
              {
                animType = 3,
                animName = "CommonWorkOut",
                CreateEntitys = {
                  {
                    EntityId = 60006103,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              }
            },
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
                EntityId = 600000020,
                Scale = { 1.0, 1.0, 1.0 }
              },
              {
                EntityId = 600000021,
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
                Scale = { 1.0, 1.0, 1.0 }
              }
            },
          }
        },
      },
      FindPath = empty,
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
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  },
  [ 60006101 ] = {
    EntityId = 60006101,
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
        Prefab = "Character/Monster/Weihu/WeihuMo1/Partner/Effect/FxWeihuMo1CommonWorkIn.prefab",
        Model = "FxWeihuMo1CommonWorkIn",
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
        Frame = 46,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60006102 ] = {
    EntityId = 60006102,
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
        Prefab = "Character/Monster/Weihu/WeihuMo1/Partner/Effect/FxWeihuMo1CommonWorkLoop.prefab",
        Model = "FxWeihuMo1CommonWorkLoop",
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
  [ 60006103 ] = {
    EntityId = 60006103,
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
        Prefab = "Character/Monster/Weihu/WeihuMo1/Partner/Effect/FxWeihuMo1CommonWorkOut.prefab",
        Model = "FxWeihuMo1CommonWorkOut",
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
        Frame = 43,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
