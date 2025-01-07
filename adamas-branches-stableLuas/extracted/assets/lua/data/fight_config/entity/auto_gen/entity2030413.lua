Config = Config or {}
Config.Entity2030413 = Config.Entity2030413 or { }
local empty = { }
Config.Entity2030413 = 
{
  [ 2030413 ] = {
    EntityId = 2030413,
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
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Behavior = {
        Behaviors = {
          "2030413"
        },
      }
    }
  },
  [ 203041301 ] = {
    EntityId = 203041301,
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Scene/FxNPCtransform.prefab",
        Model = "FxNPCtransform",
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
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsHang = true,
        IsBind = true,
        BindPositionTime = 8.0,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "NPC_Change",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  }
}
