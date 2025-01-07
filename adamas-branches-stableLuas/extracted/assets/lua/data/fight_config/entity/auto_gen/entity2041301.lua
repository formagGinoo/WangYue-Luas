Config = Config or {}
Config.Entity2041301 = Config.Entity2041301 or { }
local empty = { }
Config.Entity2041301 = 
{
  [ 2041301 ] = {
    EntityId = 2041301,
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
        localEntity = false,
        IsEffectResType = false
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/Unlock/Unlock52.png",
        TriggerText = "触摸",
        TriggerType = 8,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = true,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 2.0,
        RadiusOut = 3.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
