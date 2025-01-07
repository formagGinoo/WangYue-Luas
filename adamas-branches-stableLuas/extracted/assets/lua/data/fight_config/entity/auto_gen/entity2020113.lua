Config = Config or {}
Config.Entity2020113 = Config.Entity2020113 or { }
local empty = { }
Config.Entity2020113 = 
{
  [ 2020113 ] = {
    EntityId = 2020113,
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Fight/FxTiaozhanguangzhu.prefab",
        Model = "FxTiaozhanguangzhu",
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
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_Transform.png",
        TriggerText = "前往资产",
        TriggerType = 3,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 3.0,
        RadiusOut = 4.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Behavior = {
        Behaviors = {
          "2020113"
        },
      }
    }
  }
}
