Config = Config or {}
Config.Entity2040105 = Config.Entity2040105 or { }
local empty = { }
Config.Entity2040105 = 
{
  [ 2040105 ] = {
    EntityId = 2040105,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_door.png",
        TriggerText = "开门",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 3.1,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 2.0, 2.0, 2.0 },
        CubeOut = { 2.0, 2.0, 2.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Behavior = {
        Behaviors = {
          "2040105"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1
      }
    }
  }
}
