Config = Config or {}
Config.Entity2020401 = Config.Entity2020401 or { }
local empty = { }
Config.Entity2020401 = 
{
  [ 2020401 ] = {
    EntityId = 2020401,
    EntityName = "2020401",
    Components = {
      Transform = {
        Prefab = "Equip/Weapon/SwordW5M02/SwordW5M02.prefab",
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
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
        Offset = { -1.5, 0.4, 0.5 },
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 0.0,
        RadiusOut = 0.0,
        CubeIng = { 3.0, 2.0, 3.0 },
        CubeOut = { 4.0, 2.0, 3.0 }
      }
    }
  }
}
