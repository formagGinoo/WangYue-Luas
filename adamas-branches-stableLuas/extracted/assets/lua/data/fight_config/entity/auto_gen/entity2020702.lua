Config = Config or {}
Config.Entity2020702 = Config.Entity2020702 or { }
local empty = { }
Config.Entity2020702 = 
{
  [ 2020702 ] = {
    EntityId = 2020702,
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Fight/FxLoot1.prefab",
        Model = "FxLoot1",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_look.png",
        TriggerText = "交互",
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
      Behavior = {
        Behaviors = {
          "2020702"
        },
      }
    }
  }
}
