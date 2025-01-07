Config = Config or {}
Config.Entity2020403 = Config.Entity2020403 or { }
local empty = { }
Config.Entity2020403 = 
{
  [ 2020403 ] = {
    EntityId = 2020403,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Gate/Gate_Close.prefab",
        Model = "Gate_Close",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Behavior = {
        Behaviors = {
          "2030401"
        },
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      }
    }
  }
}
