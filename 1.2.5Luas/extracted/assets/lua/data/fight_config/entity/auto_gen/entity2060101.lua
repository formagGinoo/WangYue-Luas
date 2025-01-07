Config = Config or {}
Config.Entity2060101 = Config.Entity2060101 or { }
local empty = { }
Config.Entity2060101 = 
{
  [ 2060101 ] = {
    EntityId = 2060101,
    EntityName = "2060101",
    Components = {
      Transform = {
        Prefab = "CommonEntity/Volume/bxlksVolume.prefab",
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
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty}
  }
}
