Config = Config or {}
Config.Entity2020108 = Config.Entity2020108 or { }
local empty = { }
Config.Entity2020108 = 
{
  [ 2020108 ] = {
    EntityId = 2020108,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Heyao/Prefab/Heyao.prefab",
        Model = "Heyao",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 3.5,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      TimeoutDeath = {
        Frame = 0,
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
          "2020108"
        },
      }
    }
  }
}
