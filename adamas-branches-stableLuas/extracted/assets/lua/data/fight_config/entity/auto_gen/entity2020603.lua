Config = Config or {}
Config.Entity2020603 = Config.Entity2020603 or { }
local empty = { }
Config.Entity2020603 = 
{
  [ 2020603 ] = {
    EntityId = 2020603,
    Components = {
      Transform = {
        Prefab = "CommonEntity/BigBellTower/Prefab/TowerElevator.prefab",
        Model = "TowerElevator",
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
      },
      Behavior = {
        Behaviors = {
          "2020603"
        },
      },
      Buff = empty,
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 3,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Animator = {
        Animator = "CommonEntity/BigBellTower/Animation/TowerElevator/TowerElevator.controller",
        AnimationConfigID = "",

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

      },
      Collision = {
        CollisionCheckType = 3,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "colli",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "TowerElevator",
                LocalPosition = { 0.0, -0.29, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 6.4, 1.0, 6.4 },
                UseMeshCollider = false
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      },
      MovePlatform = {
        ShapeType = 2,
        Radius = 0.0,
        RadiusOut = 0.0,
        CubeIng = { 7.0, 5.0, 7.0 },
        CubeOut = { 7.0, 5.0, 7.0 },
        Offset = { 0.0, 2.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 }
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_look.png",
        TriggerText = "启动",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 1.0,
        RadiusOut = 1.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  },
  [ 202060301 ] = {
    EntityId = 202060301,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "root",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/BigBellTower/Effect/FxElevator.prefab",
        Model = "FxElevator",
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
        Frame = 0,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "CommonEntity/BigBellTower/Animation/TowerElevator/FxElevatorStartAni.controller",
        AnimationConfigID = "",

      }
    }
  }
}
