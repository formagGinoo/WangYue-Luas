Config = Config or {}
Config.Entity2030412 = Config.Entity2030412 or { }
local empty = { }
Config.Entity2030412 = 
{
  [ 2030412 ] = {
    EntityId = 2030412,
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
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      Behavior = {
        Behaviors = {
          "2030412"
        },
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      }
    }
  }
}
