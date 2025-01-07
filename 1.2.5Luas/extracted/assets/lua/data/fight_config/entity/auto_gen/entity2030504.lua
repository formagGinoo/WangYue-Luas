Config = Config or {}
Config.Entity2030504 = Config.Entity2030504 or { }
local empty = { }
Config.Entity2030504 = 
{
  [ 2030504 ] = {
    EntityId = 2030504,
    EntityName = "2030504",
    Components = {
      Transform = {
        Prefab = "CommonEntity/Monitor/Prefab/Monitor01.prefab",
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
      Rotate = {
        Speed = 0
      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      HackingInputHandle = {
        HackingType = 2,
        Name = "摄像头",
        Icon = "Textures/Icon/Single/BuildIcon/drone.png",
        Desc = "摄像头",
        MaxHeight = 50.0,
        UseSelfIcon = false,

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

      },
      Trigger = {
        Offset = { 0.0, 0.9, 0.0 },
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 0.0,
        RadiusOut = 0.0,
        CubeIng = { 5.0, 5.0, 5.0 },
        CubeOut = { 5.0, 6.0, 5.0 },
        SetOutOffset = true,
        OutOffset = { 0.0, 1.5, 0.0 }
      },
      CommonBehavior = {
        CommonBehaviors = {
          SetFollowRotation = {
            ComponentBehaviorName = "CommonSetFollowRotationBehavior",

          }
        }
      },
      Buff = empty}
  }
}
