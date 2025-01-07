Config = Config or {}
Config.Entity2030408 = Config.Entity2030408 or { }
local empty = { }
Config.Entity2030408 = 
{
  [ 2030408 ] = {
    EntityId = 2030408,
    Components = {
      Transform = {
        Prefab = "CommonEntity/OpenWorldParkour/Prefab/ParkourTarget.prefab",
        Model = "Cube",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      }
    }
  }
}
