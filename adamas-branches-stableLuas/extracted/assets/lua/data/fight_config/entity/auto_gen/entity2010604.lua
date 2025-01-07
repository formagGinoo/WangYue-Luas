Config = Config or {}
Config.Entity2010604 = Config.Entity2010604 or { }
local empty = { }
Config.Entity2010604 = 
{
  [ 2010604 ] = {
    EntityId = 2010604,
    Components = {
      Transform = {
        Prefab = "CommonEntity/FxPrisonLineTemporary/FxPrisonLineLockTemporaryBig.prefab",
        Model = "FxPrisonLineLockTemporaryBig",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
