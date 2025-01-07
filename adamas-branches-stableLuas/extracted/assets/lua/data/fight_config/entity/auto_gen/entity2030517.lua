Config = Config or {}
Config.Entity2030517 = Config.Entity2030517 or { }
local empty = { }
Config.Entity2030517 = 
{
  [ 2030517 ] = {
    EntityId = 2030517,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Elevator/Elevator.prefab",
        Model = "Root",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
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
      Buff = empty,
      Behavior = {
        Behaviors = {
          "2030517"
        },
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_Transform.png",
        TriggerText = "搭乘电梯",
        TriggerType = 3,
        Offset = { 0.0, 3.2, 1.0 },
        DurationTime = -1.0,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 9.5, 6.0, 6.6 },
        CubeOut = { 10.0, 7.0, 7.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
