Config = Config or {}
Config.Entity20408001 = Config.Entity20408001 or { }
local empty = { }
Config.Entity20408001 = 
{
  [ 20408001 ] = {
    EntityId = 20408001,
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxRoadBoundary.prefab",
        Model = "FXSceneInteraction",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      }
    }
  }
}
