Config = Config or {}
Config.Entity2030301  = Config.Entity2030301  or { }
local empty = { }
Config.Entity2030301  = 
{
  [ 2030301 ] = {
    EntityName = "2030301",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        RotateSpeed = 0
      },
      TimeoutDeath = {
        Time = -1.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2040105"
        },
      }
    }
  }
}
