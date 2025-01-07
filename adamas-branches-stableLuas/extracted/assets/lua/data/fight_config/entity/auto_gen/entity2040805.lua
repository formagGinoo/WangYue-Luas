Config = Config or {}
Config.Entity2040805 = Config.Entity2040805 or { }
local empty = { }
Config.Entity2040805 = 
{
  [ 2040805 ] = {
    EntityId = 2040805,
    Components = {
      Transform = {
        Prefab = "CommonEntity/NewCar/Prefab/NewCar00202.prefab",
        Model = "Car00202",
        isClone = true,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 1,
        NpcTag = 8,
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
            Name = "CarCollide",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Collider",
                LocalPosition = { 0.0, 0.826, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.10935783, 1.29309487, 4.860429 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          },
          {
            Name = "CrashBox",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Collider",
                LocalPosition = { 0.0, 1.23, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 4.0, 0.36, 9.0 }
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
        },
      },
      Animator = {
        Animator = "CommonEntity/NewCar/Animation/NewCar002/NewCar002.controller",
        AnimationConfigID = "",

      },
      Buff = empty}
  }
}
