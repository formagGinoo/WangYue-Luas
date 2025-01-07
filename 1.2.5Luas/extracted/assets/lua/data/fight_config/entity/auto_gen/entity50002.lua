Config = Config or {}
Config.Entity50002 = Config.Entity50002 or { }
local empty = { }
Config.Entity50002 = 
{
  [ 50002 ] = {
    EntityId = 50002,
    EntityName = "50002",
    Components = {
      Transform = {
        Prefab = "Character/Animal/Mailing/MailingTask.prefab",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Animal/Mailing/Mailing.controller",
        AnimationConfigID = "",

      }
    }
  }
}
