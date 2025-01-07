Config = Config or {}
Config.Entity20400106 = Config.Entity20400106 or { }
local empty = { }
Config.Entity20400106 = 
{
  [ 20400106 ] = {
    EntityId = 20400106,
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
      Tag = {
        Tag = 3,
        NpcTag = 5,
        SceneObjectTag = 1,
        Camp = 1,
        PartTag = 1
      },
      Behavior = {
        Behaviors = {
          "20400106"
        },
      }
    }
  }
}
