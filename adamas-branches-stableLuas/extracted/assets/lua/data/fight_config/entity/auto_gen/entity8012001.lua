Config = Config or {}
Config.Entity8012001 = Config.Entity8012001 or { }
local empty = { }
Config.Entity8012001 = 
{
  [ 8012001 ] = {
    EntityId = 8012001,
    Components = {
      Transform = {
        Prefab = "Character/Animal/Mailing/MailingTask.prefab",
        Model = "MailingTask",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 11,
        FixAngle = 45.0,
        CollisionRadius = 0.5,
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.85,
        offsetZ = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Animal/Mailing/Mailing.controller",
        AnimationConfigID = "",

      },
      Behavior = {
        Behaviors = {
          "8012001"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Buff = empty,
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 1.5,
        RadiusOut = 2.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
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
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      }
    }
  },
  [ 801200101 ] = {
    EntityId = 801200101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "CameraTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, -0.2, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingYincang.prefab",
        Model = "FxMailingYincang",
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
            SoundEvent = "Mailing_Yincang",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 801200102 ] = {
    EntityId = 801200102,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingBorn.prefab",
        Model = "FxMailingBorn",
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
        Frame = 130,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Mailing_Born01",
            DelayTime = 0.0,
            LifeBindEntity = true
          },
          {
            EventType = 1,
            SoundEvent = "Mailing_Born02",
            DelayTime = 1.53,
            LifeBindEntity = true
          },
          {
            EventType = 1,
            SoundEvent = "Mailing_Born03",
            DelayTime = 2.1,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 801200103 ] = {
    EntityId = 801200103,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingExceptionLoop.prefab",
        Model = "FxMailingExceptionLoop",
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
            SoundEvent = "Mailing_ExceptionLoop",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 801200104 ] = {
    EntityId = 801200104,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingExceptionLoopBip001Head.prefab",
        Model = "FxMailingExceptionLoopBip001Head",
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
            SoundEvent = "Mailing_ExceptionLoop",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 801200105 ] = {
    EntityId = 801200105,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingDisapointLoop.prefab",
        Model = "FxMailingDisapointLoop",
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
            SoundEvent = "Mailing_DisapointLoop",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 801200106 ] = {
    EntityId = 801200106,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingHappyEat.prefab",
        Model = "FxMailingHappyEat",
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
        Frame = 101,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Mailing_HappyEat",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 801200107 ] = {
    EntityId = 801200107,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingByeBye.prefab",
        Model = "FxMailingByeBye",
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
        Frame = 66,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Mailing_Byebye",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 80120011 ] = {
    EntityId = 80120011,
    Components = {
      Transform = {
        Prefab = "CommonEntity/LevelCamera/MailingCamera.prefab",
        Model = "MailingCamera",
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
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Camera = {
        Test = 2.5
      }
    }
  },
  [ 801200108 ] = {
    EntityId = 801200108,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "EffectTarget",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMailingByeByebody.prefab",
        Model = "FxMailingByeByebody",
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
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
