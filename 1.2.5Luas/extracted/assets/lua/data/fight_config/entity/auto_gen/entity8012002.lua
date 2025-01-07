Config = Config or {}
Config.Entity8012002 = Config.Entity8012002 or { }
local empty = { }
Config.Entity8012002 = 
{
  [ 8012002 ] = {
    EntityId = 8012002,
    EntityName = "8012002",
    Components = {
      Transform = {
        Prefab = "Character/Animal/Mailing/Mailing.prefab",
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
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        CollisionRadius = 0.5,
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.85,
        offsetZ = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Animal/Mailing/Mailing.controller",
        AnimationConfigID = "",

      },
      Behavior = {
        Behaviors = {
          "8012001"
        },
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 1,
        NpcTag = 0,
        PartTag = 1
      },
      Buff = empty}
  }
}
