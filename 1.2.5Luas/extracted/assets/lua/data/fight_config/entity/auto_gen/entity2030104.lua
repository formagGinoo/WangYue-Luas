Config = Config or {}
Config.Entity2030104 = Config.Entity2030104 or { }
local empty = { }
Config.Entity2030104 = 
{
  [ 2030104 ] = {
    EntityId = 2030104,
    EntityName = "2030104",
    Components = {
      Transform = {
        Prefab = "CommonEntity/ShootPuzzle/Prefab/ShootPuzzleStage3.prefab",
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
      Animator = {
        Animator = "CommonEntity/ShootPuzzle/Animation/ShootPuzzleStage3.controller",
        AnimationConfigID = "",

      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        PartTag = 1
      },
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      Behavior = {
        Behaviors = {
          "2030102"
        },
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      TimeoutDeath = {
        Frame = 0,
        RemoveDelayFrame = 0,
      }
    }
  }
}
