Config = Config or {}
Config.Entity2030203 = Config.Entity2030203 or { }
local empty = { }
Config.Entity2030203 = 
{
  [ 2030203 ] = {
    EntityId = 2030203,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
        isClone = false,
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
      Behavior = {
        Behaviors = {
          "2030203"
        },
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      }
    }
  }
}
