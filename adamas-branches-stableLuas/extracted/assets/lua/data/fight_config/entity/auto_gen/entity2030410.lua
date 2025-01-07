Config = Config or {}
Config.Entity2030410 = Config.Entity2030410 or { }
local empty = { }
Config.Entity2030410 = 
{
  [ 2030410 ] = {
    EntityId = 2030410,
    Components = {
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2030406"
        },
      },
      Buff = empty,
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Sound = empty}
  }
}
