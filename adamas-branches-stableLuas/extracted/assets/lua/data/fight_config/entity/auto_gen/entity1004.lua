Config = Config or {}
Config.Entity1004 = Config.Entity1004 or { }
local empty = { }
Config.Entity1004 = 
{
  [ 1004001001 ] = {
    EntityId = 1004001001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 10,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 0.5,
        Width = 0.5,
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
        MagicsBySelfSingle = {
          1000007,
          1004007
        },
        MagicsByTarget = {
          1004001
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004002001 ] = {
    EntityId = 1004002001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004007
        },
        MagicsByTarget = {
          1004002
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004002002 ] = {
    EntityId = 1004002002,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004007
        },
        MagicsByTarget = {
          1004002
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004003001 ] = {
    EntityId = 1004003001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 0.5,
        Width = 0.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004007
        },
        MagicsByTarget = {
          1004003
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004003002 ] = {
    EntityId = 1004003002,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004007
        },
        MagicsByTarget = {
          1004003
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004003003 ] = {
    EntityId = 1004003003,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004007
        },
        MagicsByTarget = {
          1004003
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004004001 ] = {
    EntityId = 1004004001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004004
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004004002 ] = {
    EntityId = 1004004002,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004004
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004005001 ] = {
    EntityId = 1004005001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004005
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004005002 ] = {
    EntityId = 1004005002,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004005
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004005003 ] = {
    EntityId = 1004005003,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004005
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004005004 ] = {
    EntityId = 1004005004,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004005
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 30.0,
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
  [ 1004006001 ] = {
    EntityId = 1004006001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 6.0,
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
        MagicsBySelfSingle = {
          1000007,
          1004008
        },
        MagicsByTarget = {
          1004006
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        ShakeId = 9001,
        BoneGroupShake = "ShakeObject",
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
        Speed = 15.0,
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
  [ 1004010001 ] = {
    EntityId = 1004010001,
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
        Camp = 1,
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
        ShapeType = 3,
        Radius = 2.5,
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
        Height = 1.5,
        Width = 10000.0,
        OffsetX = 0.0,
        OffsetY = 0.75,
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
        MagicsByTarget = {
          1004010
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        LookatType = 2,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.3,
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
  [ 1004060002 ] = {
    EntityId = 1004060002,
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
        Camp = 1,
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
        ShapeType = 1,
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
        Lenght = 2.0,
        Height = 2.0,
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
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
        MagicsByTarget = {
          1004060
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
  [ 100401001 ] = {
    EntityId = 100401001,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.0,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk010.prefab",
        Model = "KekeR21FxAtk010",
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
        Frame = 52,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004 ] = {
    EntityId = 1004,
    Components = {
      Animator = {
        Animator = "Character/Role/KekeR21/KekeR21M11/KekeR21M11.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              AnyState = 0.0,
              RunStart = 0.15,
              Attack070 = 0.0,
              Attack040 = 0.15,
              Walk = 0.0,
              Run = 0.07
            },
            HitFlyUp = {
              HitFlyFall = 0.03,
              HitFlyHover = 0.03
            },
            HitFlyFall = {
              HitFlyLand = 0.03,
              HitFlyHover = 0.03
            },
            HitFlyHover = {
              HitFlyLand = 0.03
            },
            RunStart = {
              RunStartEndLeft = 0.03,
              RunStartEndRight = 0.03,
              Run = 0.0
            },
            Run = {
              RunEndLeft = 0.03,
              RunEndRight = 0.03,
              JumpUpRunLeft = 0.1,
              JumpUpRunRight = 0.1
            },
            Attack070 = {
              RunStart = 0.2
            },
            Walk = {
              AnyState = 0.06,
              WalkEndLeft = 0.6,
              WalkEndRight = 0.6
            },
            WalkEndRight = {
              Walk = 0.1
            },
            WalkEndLeft = {
              Walk = 0.1
            },
            Stand2 = {
              Walk = 0.1
            },
            Stand1 = {
              Walk = 0.1
            },
            JumpDownLeft = {
              Sprint = 0.3
            },
            JumpDownRight = {
              Sprint = 0.3
            },
            Move01 = {
              Sprint = 0.1
            },
            RunStartLandLeft = {
              JumpUp = 0.1,
              JumpUpRunLeft = 0.1,
              JumpUpRunRight = 0.1,
              Sprint = 0.4,
              Run = 0.0
            },
            RunStartLandRight = {
              JumpUp = 0.1,
              JumpUpRunLeft = 0.1,
              JumpUpRunRight = 0.1,
              Sprint = 0.4,
              Run = 0.0
            },
            JumpUpRunLeft = {
              JumpLand = 0.1,
              RunStartLandRight = 0.1
            },
            JumpUpRunRight = {
              JumpLand = 0.1,
              RunStartLandLeft = 0.1
            },
            JumpUpSprintLeft = {
              JumpLand = 0.1,
              RunStartLandRight = 0.1
            },
            JumpUpSprintRight = {
              JumpLand = 0.1,
              RunStartLandLeft = 0.1
            }
          }
        }
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/KekeR21M11/KekeR21M11.prefab",
        Model = "KekeR21M11",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Behavior = {
        Behaviors = {
          "1004"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 1,
        SceneObjectTag = 0,
        Camp = 1,
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
        ConfigName = "KekeR21M11",
        LogicMoveConfigs = {
          Attack080 = 2
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
          {            BoneColliders = {
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
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.85,
        offsetZ = 0.0
      },
      Part = {
        PartList = {
          {            PartType = 0,
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
            OnlyHitAlarm = false
          }
        },

      },
      State = {
        DyingTime = 1.9,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 3.733,
        HitTime = {
          [ 1 ] = {
            Time = 1.0,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 0.967,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.867,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.733,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
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
            Time = 0.6,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.1,
            ForceTime = 0.1,
            FusionChangeTime = 0.1,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 2.2,
            ForceTime = 0.7,
            FusionChangeTime = 0.7,
            IgnoreHitTime = 1.2
          }
        },
      },
      Hit = {
        GravityAcceleration = -3.0,
        ReboundCoefficient = 0.0,
        ReboundTimes = 0.0,
        MinSpeed = 0.0,
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
          [ 1004001 ] = {
            TotalFrame = 75,
            ForceFrame = 15,
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
                SkillIcon = "KekeR21Attack",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
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

                  EntityId = 100400101,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 10000002,
                  Frame = 15,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1004001001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
              [ 10 ] = {
                {

                  Type = 10000001,
                  Frame = 12,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 906 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 906,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004002 ] = {
            TotalFrame = 65,
            ForceFrame = 21,
            SkillType = 0,
            SkillSign = 1,
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

                  EntityId = 100400201,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 10000002,
                  Frame = 21,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 3 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.06,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 1004002001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.8,
                  BornOffsetZ = 0.5,
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

                  EntityId = 1004002002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.8,
                  BornOffsetZ = 0.5,
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
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  Type = 10000001,
                  Frame = 9,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 906 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 906,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 914 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 914,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004003 ] = {
            TotalFrame = 112,
            ForceFrame = 39,
            SkillType = 0,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack003",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100400301,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 10000002,
                  Frame = 39,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1004003001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
              [ 16 ] = {
                {

                  EntityId = 1004003002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
              [ 29 ] = {
                {

                  EntityId = 1004003003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  Type = 10000001,
                  Frame = 9,
                  FrameTime = 36,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 903 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.1,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.1,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 903,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 905 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 905,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 913 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.1,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 913,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 915 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 915,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 928 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.2,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 4.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 928,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004004 ] = {
            TotalFrame = 102,
            ForceFrame = 18,
            SkillType = 0,
            SkillSign = 1,
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

                  EntityId = 100400401,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 10000002,
                  Frame = 18,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1004004001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
              [ 11 ] = {
                {

                  EntityId = 1004004002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.6,
                  BornOffsetZ = 0.5,
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
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {

                  Type = 10000001,
                  Frame = 9,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 902 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.04,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.03,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 902,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 905 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 905,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 910 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 910,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004005 ] = {
            TotalFrame = 134,
            ForceFrame = 30,
            SkillType = 0,
            SkillSign = 1,
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

                },
                {

                  EntityId = 100400501,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 10000002,
                  Frame = 30,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 9 ] = {
                {

                  EntityId = 1004005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 19 ] = {
                {

                  EntityId = 1004005003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
                  FrameTime = 19,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 1004005004,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
              [ 27 ] = {
                {

                  Type = 10000001,
                  Frame = 9,
                  FrameTime = 27,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 906 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.06,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.03,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 906,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 918 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 918,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 923 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.15,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 3.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 923,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 933 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.03,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 5.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 933,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004006 ] = {
            TotalFrame = 88,
            ForceFrame = 33,
            SkillType = 0,
            SkillSign = 1,
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

                },
                {

                  EntityId = 100400601,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Type = 10000002,
                  Frame = 33,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 1004006001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.3,
                  BornOffsetZ = 0.5,
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
              [ 910 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 10.0,
                      TargetAmplitude = -0.1,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.35,
                      Sign = 6.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 910,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004010 ] = {
            TotalFrame = 58,
            ForceFrame = 15,
            SkillType = 0,
            SkillSign = 10,
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
                SkillIcon = "KekeR21RedSkill",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack010",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100401001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100401002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100401003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 1,
                  Sign = 10030001,
                  LastTime = 2.5,
                  LastFrame = 75,
                  IgnoreTimeScale = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,

                }
              },
              [ 6 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.2,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 6,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 1004010003,
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
              [ 8 ] = {
                {

                  EntityId = 100401004,
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
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 12 ] = {
                {

                  Type = 1004010,
                  Frame = 43,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000001,
                  Frame = 30,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004011 ] = {
            TotalFrame = 62,
            ForceFrame = 18,
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

                  Name = "Attack011",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100401101,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100401002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100401003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 1,
                  Sign = 10030001,
                  LastTime = 2.5,
                  LastFrame = 75,
                  IgnoreTimeScale = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 1004010003,
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

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.05,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 100401102,
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
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.5,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 15 ] = {
                {

                  Type = 1004010,
                  Frame = 47,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000001,
                  Frame = 30,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004012 ] = {
            TotalFrame = 48,
            ForceFrame = 18,
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

                  Name = "Attack012",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100401201,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100401002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100401003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004013,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 1,
                  Sign = 10030001,
                  LastTime = 2.5,
                  LastFrame = 75,
                  IgnoreTimeScale = false,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,

                }
              },
              [ 4 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.05,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.05,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 1004010003,
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
              [ 8 ] = {
                {

                  EntityId = 100401202,
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
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 9 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.2,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 15 ] = {
                {

                  Type = 1004010,
                  Frame = 33,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Type = 10000001,
                  Frame = 30,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004030 ] = {
            TotalFrame = 59,
            ForceFrame = 12,
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
                SkillIcon = "KekeR21Move",
                BehaviorConfig = 80,
                LayerConfig = 258
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Move01",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Frame = 12,
                  RingCount = 12,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 6,

                },
                {

                  AddType = 1,
                  BuffId = 1004030,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 100403001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

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

                  EntityId = 100403003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 100403002,
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
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 11 ] = {
                {

                  Type = 10000006,
                  Frame = 1,
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 12 ] = {
                {

                  Type = 10000000,
                  Frame = 47,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004031 ] = {
            TotalFrame = 68,
            ForceFrame = 18,
            SkillType = 0,
            SkillSign = 30,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
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

                  Frame = 18,
                  RingCount = 12,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 6,

                },
                {

                  AddType = 1,
                  BuffId = 1004031,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 100403101,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100403102,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

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

                  EntityId = 100403103,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100403104,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100403105,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 100403002,
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
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 100403002,
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
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  Type = 10000000,
                  Frame = 50,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004040 ] = {
            TotalFrame = 270,
            ForceFrame = 270,
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

                  EntityId = 100404001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004045,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "Attack040",
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

                  AddType = 1,
                  BuffId = 1004048,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  AddType = 1,
                  BuffId = 1004041,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  Direction = 2,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 0.7,
                  Acceleration = 0.0,
                  MoveFrame = 255,
                  InputSpeed = 4.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 7 ] = {
                {

                  Type = 1,
                  Sign = 10040000,
                  LastTime = 8.5,
                  LastFrame = 255,
                  IgnoreTimeScale = false,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 11,

                },
                {

                  Type = 1004040,
                  Frame = 263,
                  FrameTime = 7,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004041 ] = {
            TotalFrame = 78,
            ForceFrame = 9,
            SkillType = 0,
            SkillSign = 41,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack041",
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

                  Type = 1004040,
                  Frame = 77,
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 3 ] = {
                {

                  Type = 1004041,
                  Frame = 75,
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.03,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.01,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.15,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 41.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 3,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004050 ] = {
            TotalFrame = 65,
            ForceFrame = 36,
            SkillType = 0,
            SkillSign = 50,
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
                SkillIcon = "KekeR21BlueSkill",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack050",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100405001,
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

                },
                {

                  EntityId = 100405002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100405003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  MagicId = 1004052,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  AddType = 1,
                  BuffId = 1004051,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  MagicId = 1004024,
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

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.07,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.3,
                      TargetFrequency = 20.0,
                      AmplitudeChangeTime = 0.4,
                      FrequencyChangeTime = 0.1,
                      DurationTime = 0.4,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 1004050001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 8.0,
                  BornOffsetX = -0.1,
                  BornOffsetY = 0.9,
                  BornOffsetZ = 0.4,
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
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.4,
                      StartFrequency = 5.0,
                      TargetAmplitude = -0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.4,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 1004050001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 8.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 1.2,
                  BornOffsetZ = 0.4,
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
              [ 19 ] = {
                {

                  EntityId = 1004050001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 8.0,
                  BornOffsetX = 0.1,
                  BornOffsetY = 1.1,
                  BornOffsetZ = 0.4,
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
                  FrameTime = 19,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 1004060 ] = {
            TotalFrame = 76,
            ForceFrame = 39,
            SkillType = 0,
            SkillSign = 60,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack060",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100406001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004061,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.08,
                      StartFrequency = 10.0,
                      TargetAmplitude = 0.08,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.0,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 1.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 2 ] = {
                {

                  EntityId = 1004060001,
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
                  FrameTime = 2,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 1004060001,
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
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 1004060001,
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
              [ 8 ] = {
                {

                  EntityId = 1004060001,
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
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 16 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.55,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.15,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.3,
                      Sign = 2.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 16,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 1004060003,
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
                  FrameTime = 17,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.05,
                      StartFrequency = 5.0,
                      TargetAmplitude = 0.05,
                      TargetFrequency = 5.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.2,
                      Sign = 5.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 30,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
            }
          },
          [ 1004070 ] = {
            TotalFrame = 66,
            ForceFrame = 24,
            SkillType = 0,
            SkillSign = 70,
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
                SkillIcon = "KekeR21UltimateSkill",
                BehaviorConfig = 16,
                LayerConfig = 0
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack070",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 100407001,
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

                },
                {

                  EntityId = 100407003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100407004,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004073,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1004071,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  MagicId = 1004072,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  MagicId = 1004074,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  MagicId = 1005075,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 10,

                },
                {

                  EntityId = 100407005,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100407006,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.35,
                      StartFrequency = 3.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.0,
                      DurationTime = 0.15,
                      Sign = 70.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 18 ] = {
                {

                  Type = 1004070,
                  Frame = 48,
                  FrameTime = 18,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004080 ] = {
            TotalFrame = 127,
            ForceFrame = 127,
            SkillType = 0,
            SkillSign = 80,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
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

                  AddType = 1,
                  BuffId = 1004084,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1004085,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 10000003,
                  Frame = 114,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 100408001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100408002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 100408003,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 1004086,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      10000000
                    },
                  }
                },
                {

                  EntityId = 1004080001,
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
              [ 106 ] = {
                {

                  EntityId = 100408004,
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
                  FrameTime = 106,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 110 ] = {
                {

                  EntityId = 100408005,
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
                  FrameTime = 110,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 114 ] = {
                {

                  Type = 10000004,
                  Frame = 1,
                  FrameTime = 114,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 1004090 ] = {
            TotalFrame = 55,
            ForceFrame = 55,
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

                  Name = "Interact",
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
      Pasv = {
        Skills = {
          [ 1004020 ] = {
            TotalFrame = 30,
            ForceFrame = 30,
            SkillType = 0,
            SkillSign = 20,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 1004103,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 1004104,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  MagicId = 1004021,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
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
            UISetNote = "默认界面",
            CoreUIConfig = {
              BindRes = 0,
              Scale = 1.0,
              LocationOffset = { 0.0, 0.0, 0.0 },
              ScreenOffset = { 0.0, 0.0, 0.0 }
            },
            J = {
              Active = true,
              SkillId = 1004001,
              SkillIcon = "KekeR21Attack"
            },
            K = {
              Active = true,
              SkillId = 1004030,
              SkillIcon = "KekeR21Move"
            },
            L = {
              Active = true,
              SkillId = 1004070,
              SkillIcon = "KekeR21UltimateSkill"
            },
            I = {
              Active = true,
              SkillId = 1004010,
              SkillIcon = "KekeR21RedSkill"
            },
            O = {
              Active = true,
              SkillId = 0,
              SkillIcon = "Jump"
            },
            R = {
              Active = true,
              SkillId = 1004080,
              SkillIcon = "Diyue"
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
      ElementState = {
        ElementType = 2,

      }
    }
  },
  [ 100400101 ] = {
    EntityId = 100400101,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001.prefab",
        Model = "KekeR21FxAtk001",
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
        Frame = 65,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100400201 ] = {
    EntityId = 100400201,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk002.prefab",
        Model = "KekeR21FxAtk002",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100400301 ] = {
    EntityId = 100400301,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk003.prefab",
        Model = "KekeR21FxAtk003",
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
        Frame = 88,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100400401 ] = {
    EntityId = 100400401,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk004.prefab",
        Model = "KekeR21FxAtk004",
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
        Frame = 70,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100400501 ] = {
    EntityId = 100400501,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk005.prefab",
        Model = "KekeR21FxAtk005",
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
        Frame = 85,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100400601 ] = {
    EntityId = 100400601,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk006.prefab",
        Model = "KekeR21FxAtk006",
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
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004060001 ] = {
    EntityId = 1004060001,
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
        Camp = 1,
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
        ShapeType = 1,
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
        Lenght = 2.0,
        Height = 3.0,
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
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
        MagicsByTarget = {
          1004060
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
  [ 100400102 ] = {
    EntityId = 100400102,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001H.prefab",
        Model = "KekeR21FxAtk001H",
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
        Frame = 43,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004050001 ] = {
    EntityId = 1004050001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk001M.prefab",
        Model = "KekeR21FxAtk001M",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 31,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 1,
        Radius = 0.65,
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
        Height = 1.5,
        Width = 6.0,
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
        MagicsByTarget = {
          1004050
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        Speed = 40.0,
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
  [ 100401002 ] = {
    EntityId = 100401002,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "PistolR1M1",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk010PistolR1M1.prefab",
        Model = "KekeR21FxAtk010PistolR1M1",
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
  [ 100401003 ] = {
    EntityId = 100401003,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "PistolR1M11",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk010PistolR1M11.prefab",
        Model = "KekeR21FxAtk010PistolR1M11",
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
  [ 1004010002 ] = {
    EntityId = 1004010002,
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
        Camp = 1,
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
        ShapeType = 3,
        Radius = 2.5,
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
        Height = 1.5,
        Width = 10000.0,
        OffsetX = 0.0,
        OffsetY = 0.75,
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
        MagicsByTarget = {
          1004010
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
        LookatType = 2,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.3,
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
  [ 100405001 ] = {
    EntityId = 100405001,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.1, 0.6 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk050.prefab",
        Model = "KekeR21FxAtk050",
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
      }
    }
  },
  [ 100405002 ] = {
    EntityId = 100405002,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "PistolR1M1",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk050PistolR1M1.prefab",
        Model = "KekeR21FxAtk050PistolR1M1",
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
        Frame = 61,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100405003 ] = {
    EntityId = 100405003,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "PistolR1M11",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk050PistolR1M11.prefab",
        Model = "KekeR21FxAtk050PistolR1M11",
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
        Frame = 61,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100402003 ] = {
    EntityId = 100402003,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk020H.prefab",
        Model = "KekeR21FxAtk020H",
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
  [ 1004040002 ] = {
    EntityId = 1004040002,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M02.prefab",
        Model = "KekeR21FxAtk040M02",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
        Radius = 50000.0,
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
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 100404001 ] = {
    EntityId = 100404001,
    Components = {
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
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040Start.prefab",
        Model = "KekeR21FxAtk040Start",
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
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100404002 ] = {
    EntityId = 100404002,
    Components = {
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
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040End.prefab",
        Model = "KekeR21FxAtk040End",
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
        Frame = 61,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004040003 ] = {
    EntityId = 1004040003,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M03.prefab",
        Model = "KekeR21FxAtk040M03",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
        Radius = 50000.0,
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
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 1004040005 ] = {
    EntityId = 1004040005,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M05.prefab",
        Model = "KekeR21FxAtk040M05",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
        Radius = 50000.0,
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
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 1004040004 ] = {
    EntityId = 1004040004,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M04.prefab",
        Model = "KekeR21FxAtk040M04",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
        Radius = 50000.0,
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
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 100401101 ] = {
    EntityId = 100401101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.0,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk011.prefab",
        Model = "KekeR21FxAtk011",
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
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100401201 ] = {
    EntityId = 100401201,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.0,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk012.prefab",
        Model = "KekeR21FxAtk012",
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
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100407001 ] = {
    EntityId = 100407001,
    Components = {
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
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk070.prefab",
        Model = "KekeR21FxAtk070",
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
        Frame = 106,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100407003 ] = {
    EntityId = 100407003,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "PistolR1M1",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk070PistolR1M1.prefab",
        Model = "KekeR21FxAtk070PistolR1M1",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100407004 ] = {
    EntityId = 100407004,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "PistolR1M11",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk070PistolR1M11.prefab",
        Model = "KekeR21FxAtk070PistolR1M11",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100406001 ] = {
    EntityId = 100406001,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk060.prefab",
        Model = "KekeR21FxAtk060",
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
        Frame = 77,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004040001 ] = {
    EntityId = 1004040001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M01.prefab",
        Model = "KekeR21FxAtk040M01",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
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
        Lenght = 2.0,
        Height = 2.0,
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 100403001 ] = {
    EntityId = 100403001,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove01.prefab",
        Model = "KekeR21FxMove01",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100403101 ] = {
    EntityId = 100403101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.0,
        BindRotationTime = 0.0,
        BindTransformName = "Bone081(mirrored)",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove02Bone081(mirrored).prefab",
        Model = "KekeR21FxMove02Bone081(mirrored)",
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
        Frame = 52,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004060003 ] = {
    EntityId = 1004060003,
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
        Camp = 1,
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
        Radius = 50000.0,
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
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 3.0,
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
          1004060
        },
        CreateHitEntities = {
          {
            EntityId = 100402003,
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
  [ 1004010003 ] = {
    EntityId = 1004010003,
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
        Camp = 1,
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
        Lenght = 2.0,
        Height = 1.5,
        Width = 1.5,
        OffsetX = 0.0,
        OffsetY = 0.75,
        OffsetZ = 0.75,
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
        IntervalTime = 0.02,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          1004014
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
        Speed = 1.0,
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
  [ 1004020001 ] = {
    EntityId = 1004020001,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk020H.prefab",
        Model = "KekeR21FxAtk020H",
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
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 1,
        Radius = 0.7,
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
          1004020
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 1,
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
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 1.0,
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
  [ 100401004 ] = {
    EntityId = 100401004,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.0,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk010M01.prefab",
        Model = "KekeR21FxAtk010M01",
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
      },
      CreateEntity = {
        CreateEntityInfos = {
          {
            DelayTime = 0.0,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.1,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.3,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.5,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.7,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.9,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 1.1,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 1.3,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          }
        },
      }
    }
  },
  [ 100401102 ] = {
    EntityId = 100401102,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.0,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk010M01.prefab",
        Model = "KekeR21FxAtk010M01",
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
      },
      CreateEntity = {
        CreateEntityInfos = {
          {
            DelayTime = 0.0,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.1,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.3,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.5,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.7,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.9,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 1.1,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 1.3,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          }
        },
      }
    }
  },
  [ 100401202 ] = {
    EntityId = 100401202,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.0,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk010M01.prefab",
        Model = "KekeR21FxAtk010M01",
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
      },
      CreateEntity = {
        CreateEntityInfos = {
          {
            DelayTime = 0.0,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.1,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.3,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.5,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.7,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 0.9,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 1.1,
            EntityId = 1004010001,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          },
          {
            DelayTime = 1.3,
            EntityId = 1004010002,
            Count = 1,
            MaxCount = 1,
            IntervalTime = 999.0,
            OffsetX = 0.0,
            OffsetY = 0.0,
            OffsetZ = 2.5
          }
        },
      }
    }
  },
  [ 100403102 ] = {
    EntityId = 100403102,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindPositionTime = 0.0,
        BindRotationTime = 0.0,
        BindTransformName = "Bone081",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove02Bone081.prefab",
        Model = "KekeR21FxMove02Bone081",
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
  [ 1004040006 ] = {
    EntityId = 1004040006,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M06.prefab",
        Model = "KekeR21FxAtk040M06",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
        Radius = 50000.0,
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
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 1004040007 ] = {
    EntityId = 1004040007,
    Components = {
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk040M07.prefab",
        Model = "KekeR21FxAtk040M07",
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
        Frame = 67,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
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
        ShapeType = 2,
        Radius = 50000.0,
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
        Width = 8.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
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
          1004040
        },
        CreateHitEntities = {
          {
            EntityId = 100400102,
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
          SpeedZ = -1.7,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 1.5,
          SpeedZAloft = 0.5,
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
  [ 100403002 ] = {
    EntityId = 100403002,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove02.prefab",
        Model = "KekeR21FxMove02",
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
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100408001 ] = {
    EntityId = 100408001,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001 Head",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk080Bip001Head.prefab",
        Model = "KekeR21FxAtk080Bip001Head",
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
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100408002 ] = {
    EntityId = 100408002,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001 L Hand",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk080Bip001LHand.prefab",
        Model = "KekeR21FxAtk080Bip001LHand",
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
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100408003 ] = {
    EntityId = 100408003,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001 R Hand",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk080Bip001RHand.prefab",
        Model = "KekeR21FxAtk080Bip001RHand",
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
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100408004 ] = {
    EntityId = 100408004,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { -0.5, 0.5, -1.7 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk080.prefab",
        Model = "KekeR21FxAtk080",
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
      }
    }
  },
  [ 100408005 ] = {
    EntityId = 100408005,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 5.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk080Hit.prefab",
        Model = "KekeR21FxAtk080Hit",
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
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 1004080001 ] = {
    EntityId = 1004080001,
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
        Frame = 118,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 106,
        DurationFrame = 13,
        Target = 1,
        IngoreDodge = false,
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
        Lenght = 4.0,
        Height = 6.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 3.0,
        OffsetZ = 5.0,
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
          1004087
        },
        CreateHitEntities = {
          {
            EntityId = 100402003,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 6,
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
              StartAmplitude = -0.15,
              StartFrequency = 5.0,
              TargetAmplitude = -0.1,
              TargetFrequency = 5.0,
              AmplitudeChangeTime = 0.15,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.15,
              Sign = 1.0,
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
  [ 100403103 ] = {
    EntityId = 100403103,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove02HitCase.prefab",
        Model = "KekeR21FxMove02HitCase",
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
  [ 100403104 ] = {
    EntityId = 100403104,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001LCalf",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove02Bip001LCalf.prefab",
        Model = "KekeR21FxMove02Bip001LCalf",
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
  [ 100403105 ] = {
    EntityId = 100403105,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001RCalf",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove02Bip001RCalf.prefab",
        Model = "KekeR21FxMove02Bip001RCalf",
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
  [ 100403003 ] = {
    EntityId = 100403003,
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
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxMove01HitCase.prefab",
        Model = "KekeR21FxMove01HitCase",
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
  [ 100407005 ] = {
    EntityId = 100407005,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001LCalf",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk070Bip001LCalf.prefab",
        Model = "KekeR21FxAtk070Bip001LCalf",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 100407006 ] = {
    EntityId = 100407006,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001RCalf",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk070Bip001RCalf.prefab",
        Model = "KekeR21FxAtk070Bip001RCalf",
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
        Frame = 76,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
