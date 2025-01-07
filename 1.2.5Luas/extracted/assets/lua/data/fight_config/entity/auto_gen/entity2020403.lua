Config = Config or {}
Config.Entity2020403 = Config.Entity2020403 or { }
local empty = { }
Config.Entity2020403 = 
{
  [ 2020403 ] = {
    EntityId = 2020403,
    EntityName = "2020403",
    Components = {
      Transform = {
        Prefab = "CommonEntity/Gate/Gate_Close.prefab",
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
          "2030401"
        },
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
