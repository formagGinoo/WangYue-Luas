Config = Config or {}
Config.Entity2040866 = Config.Entity2040866 or { }
local empty = { }
Config.Entity2040866 = 
{
  [ 2040866 ] = {
    EntityId = 2040866,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Vehicle/PiKaChe/Prefab/PiKaChe00101.prefab",
        Model = "PiKaChe00101",
        isClone = true,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 1,
        NpcTag = 8,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
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
        MoveType = 6,
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
        TrackPointAcceleration = 0.2,
        TrackPointMaxSpeed = 12.0,
        TrackPointDeceleration = 0.2,
        TrackPointObstacleDistance = 2.0
      },
      Collision = {
        CollisionCheckType = 3,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "CrashBox",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Collider",
                LocalPosition = { 0.0, 0.97, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.17350841, 1.544188, 6.09881449 },
                UseMeshCollider = false
              }
            },
            DefaultEnable = false,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      },
      CommonBehavior = {
        CommonBehaviors = {
          ControlCar = {
            ComponentBehaviorName = "CommonControlCarBehavior",
            NewCommonBehaviorParms = {
              [ "最远操控距离" ] = 10000.0,
              [ "每帧消耗电量" ] = 0.0,
              [ "可操控帧数" ] = 10000.0
            }
          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_door.png",
        TriggerText = "上车",
        TriggerType = 11,
        Offset = { 0.0, 0.9, 0.0 },
        DurationTime = -1.0,
        BlockWall = true,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 6.0, 4.0, 6.0 },
        CubeOut = { 6.2, 4.0, 6.2 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Animator = {
        Animator = "CommonEntity/Vehicle/PiKaChe/Animation/PiKaChe001/PiKaChe001.controller",
        AnimationConfigID = "",

      },
      Buff = empty,
      Sound = {
        StateSoundEventMapList = {
          {
            StateID = 1,
            SubStateID = 0,
            IsLoop = false,
            LifeBindEntity = true,
            CD = 0.0,
            Priority = 1,
            PlayDistance = 20.0,
            Probability = 1.0
          }
        },
      },
      Attack = {
        AttackType = 0,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 999,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
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
        Lenght = 4.0,
        Height = 1.0,
        Width = 9.0,
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
      }
    }
  }
}
