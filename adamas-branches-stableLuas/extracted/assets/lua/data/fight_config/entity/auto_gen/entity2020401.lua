Config = Config or {}
Config.Entity2020401 = Config.Entity2020401 or { }
local empty = { }
Config.Entity2020401 = 
{
  [ 2020401 ] = {
    EntityId = 2020401,
    Components = {
      Transform = {
        Prefab = "Equip/Weapon/Fight/Sword/SwordW5M01/SwordW5M01.prefab",
        Model = "SwordW5M01",
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
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      Trigger = {
        TriggerType = 0,
        Offset = { -1.5, 0.4, 0.5 },
        DurationTime = -1.0,
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 3.0, 2.0, 3.0 },
        CubeOut = { 4.0, 2.0, 3.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
