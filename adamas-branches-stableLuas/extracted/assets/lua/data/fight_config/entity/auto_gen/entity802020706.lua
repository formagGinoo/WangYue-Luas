Config = Config or {}
Config.Entity802020706 = Config.Entity802020706 or { }
local empty = { }
Config.Entity802020706 = 
{
  [ 802020706 ] = {
    EntityId = 802020706,
    Components = {
      Transform = {
        Prefab = "Character/Npc/Female165/Common/Accessory/Phone/Prefab/Phone01.prefab",
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
        TriggerType = 1,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 2.0,
        RadiusOut = 3.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Behavior = {
        Behaviors = {
          "802020706"
        },
      },
      Tag = {
        Tag = 3,
        NpcTag = 6,
        SceneObjectTag = 1,
        Camp = 0,
        PartTag = 1
      }
    }
  }
}
