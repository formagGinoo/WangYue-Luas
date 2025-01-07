Config = Config or {}
Config.Entity2030301 = Config.Entity2030301 or { }
local empty = { }
Config.Entity2030301 = 
{
  [ 2030301 ] = {
    EntityId = 2030301,
    EntityName = "2030301",
    Components = {
      Transform = {
        Prefab = "CommonEntity/LotusLeafPuzzle/LotusLeafPuzzle.prefab",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2030301"
        },
      },
      Part = {
        PartList = {
          {
            Name = "Center",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "bind",
                LocalPosition = { 7.41, -1.15, -0.33 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 10.0, 1.0, 10.0 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = false,
            DmgPartHurtOpen = true,
            CheckEntityCollider = true
          }
        },

      },
      Buff = empty}
  }
}
