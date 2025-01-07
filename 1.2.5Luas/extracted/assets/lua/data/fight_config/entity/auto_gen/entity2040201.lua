Config = Config or {}
Config.Entity2040201 = Config.Entity2040201 or { }
local empty = { }
Config.Entity2040201 = 
{
  [ 2040201 ] = {
    EntityId = 2040201,
    EntityName = "2040201",
    Components = {
      Transform = {
        Prefab = "Scene/Common/Effect/01/Prefab/FxPositionGuide.prefab",
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
      Behavior = {
        Behaviors = {
          "2040201"
        },
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Trigger = {
        Offset = { 0.0, 0.0, 0.0 },
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 3.0,
        RadiusOut = 5.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 }
      },
      Buff = empty}
  }
}
