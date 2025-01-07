Config = Config or {}
Config.Entity101001 = Config.Entity101001 or { }
local empty = { }
Config.Entity101001 = 
{
  [ 1010001 ] = {
    EntityId = 1010001,
    Components = {
      Transform = {
        Prefab = "Character/Role/Male154/ZhaiwugeR31/ZhaiwugeR31M11/ZhaiwugeR31M11Canying.prefab",
        Model = "ZhaiwugeR31M11",
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
      Animator = {
        Animator = "Character/Role/Male154/ZhaiwugeR31/ZhaiwugeR31M11/ZhaiwugeR31M11.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              AnyState = 0.0
            }
          }
        }
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      TimeoutDeath = {
        Frame = 12,
        RemoveDelayFrame = 0,
      }
    }
  }
}
