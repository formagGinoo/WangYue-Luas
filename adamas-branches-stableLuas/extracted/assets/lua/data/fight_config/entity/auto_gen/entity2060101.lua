Config = Config or {}
Config.Entity2060101 = Config.Entity2060101 or { }
local empty = { }
Config.Entity2060101 = 
{
  [ 2060101 ] = {
    EntityId = 2060101,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Volume/bxlksVolume.prefab",
        Model = "bxlksVolume",
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
      Buff = empty}
  }
}
