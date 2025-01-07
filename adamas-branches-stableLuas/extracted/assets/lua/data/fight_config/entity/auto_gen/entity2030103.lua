Config = Config or {}
Config.Entity2030103 = Config.Entity2030103 or { }
local empty = { }
Config.Entity2030103 = 
{
  [ 2030103 ] = {
    EntityId = 2030103,
    Components = {
      Transform = {
        Prefab = "CommonEntity/ShootPuzzle/Prefab/ShootPuzzleStage2.prefab",
        Model = "ShootPuzzleStage2",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Animator = {
        Animator = "CommonEntity/ShootPuzzle/Animation/ShootPuzzleStage2.controller",
        AnimationConfigID = "",

      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
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
