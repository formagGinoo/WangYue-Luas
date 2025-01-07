Config = Config or {}
Config.Entity2020701 = Config.Entity2020701 or { }
local empty = { }
Config.Entity2020701 = 
{
  [ 2020701 ] = {
    EntityId = 2020701,
    EntityName = "2020701",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Trigger = {
        Offset = { 0.0, 0.0, 0.0 },
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 3.1,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 }
      },
      Behavior = {
        Behaviors = {
          "2020701"
        },
      }
    }
  }
}
