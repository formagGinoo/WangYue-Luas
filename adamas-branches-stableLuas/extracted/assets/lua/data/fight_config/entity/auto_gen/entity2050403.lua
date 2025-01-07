Config = Config or {}
Config.Entity2050403 = Config.Entity2050403 or { }
local empty = { }
Config.Entity2050403 = 
{
  [ 2050403 ] = {
    EntityId = 2050403,
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2050403"
        },
      },
      Buff = empty}
  }
}
