Config = Config or {}
Config.Entity2020201 = Config.Entity2020201 or { }
local empty = { }
Config.Entity2020201 = 
{
  [ 2020201 ] = {
    EntityId = 2020201,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Guide/FxGuideStart.prefab",
        Model = "FxGuideStart",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Animator = {
        Animator = "CommonEntity/Guide/FxGuide.controller",
        AnimationConfigID = "",

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
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2020201"
        },
      }
    }
  }
}
