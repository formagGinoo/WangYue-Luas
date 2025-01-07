Config = Config or {}
Config.Entity2030502 = Config.Entity2030502 or { }
local empty = { }
Config.Entity2030502 = 
{
  [ 2030502 ] = {
    EntityId = 2030502,
    EntityName = "2030502",
    Components = {
      Transform = {
        Prefab = "CommonEntity/Aircraft/Prefab/Aircraft01.prefab",
        isClone = true,
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
        HackingType = 1,
        Name = "大型无人机",
        Icon = "Textures/Icon/Single/BuildIcon/drone.png",
        Desc = "带你飞",
        MaxHeight = 80.0,
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
        Offset = { 0.0, 1.5, 0.0 },
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 0.0,
        RadiusOut = 0.0,
        CubeIng = { 3.3, 2.0, 3.3 },
        CubeOut = { 3.3, 2.0, 3.3 },
        SetOutOffset = true,
        OutOffset = { 0.0, 1.5, 0.0 }
      },
      CommonBehavior = {
        CommonBehaviors = {
          SetFollowMove = {
            ComponentBehaviorName = "CommonSetFollowMoveBehavior",

          },
          SetFollowRotation = {
            ComponentBehaviorName = "CommonSetFollowRotationBehavior",

          }
        }
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = -1,
      },
      Buff = empty}
  }
}
