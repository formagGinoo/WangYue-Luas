Config = Config or {}
Config.Entity2040104 = Config.Entity2040104 or { }
local empty = { }
Config.Entity2040104 = 
{
  [ 2040104 ] = {
    EntityId = 2040104,
    Components = {
      Transform = {
        Prefab = "CommonEntity/AirWall/AirWall242.prefab",
        Model = "AirWall242",
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
      }
    }
  }
}
