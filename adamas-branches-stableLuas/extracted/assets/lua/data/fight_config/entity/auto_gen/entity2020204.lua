Config = Config or {}
Config.Entity2020204 = Config.Entity2020204 or { }
local empty = { }
Config.Entity2020204 = 
{
  [ 2020204 ] = {
    EntityId = 2020204,
    Components = {
      Transform = {
        Prefab = "Scene/Commons/Prop/Prefab/Chunk_Propbucket_10020001_01_Plain.prefab",
        Model = "Metal",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Sound = empty}
  }
}
