Config = Config or {}
Config.Entity2021303 = Config.Entity2021303 or { }
local empty = { }
Config.Entity2021303 = 
{
  [ 2021303 ] = {
    EntityId = 2021303,
    Components = {
      Behavior = {
        Behaviors = {
          "2021101"
        },
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxMapGuideMiddle_GongNeng_03.prefab",
        Model = "FxMapGuideMiddle_GongNeng_03",
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
