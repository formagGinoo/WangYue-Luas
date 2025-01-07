Config = Config or {}
Config.Entity2020402 = Config.Entity2020402 or { }
local empty = { }
Config.Entity2020402 = 
{
  [ 2020402 ] = {
    EntityId = 2020402,
    EntityName = "2020402",
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxQimaizhu01.prefab",
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
      TimeoutDeath = {
        Frame = 0,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Trigger = {
        Offset = { 0.0, 0.0, 0.0 },
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 1.0,
        RadiusOut = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 }
      }
    }
  }
}
