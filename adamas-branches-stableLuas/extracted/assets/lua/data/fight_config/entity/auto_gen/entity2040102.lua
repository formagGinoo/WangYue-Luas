Config = Config or {}
Config.Entity2040102 = Config.Entity2040102 or { }
local empty = { }
Config.Entity2040102 = 
{
  [ 2040102 ] = {
    EntityId = 2040102,
    Components = {
      Transform = {
        Prefab = "CommonEntity/AirWall/AirWall.prefab",
        Model = "AirWall",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
          "2040102"
        },
      },
      Part = {
        PartList = {
          {
            Name = "InteractZone",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Cube",
                LocalPosition = { -0.0077, -0.3039, -1.25 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.16227, 0.24756, 2.14039373 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = false,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          }
        },

      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 10.0,
        RadiusOut = 10.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 20.0, 20.0, 6.0 },
        CubeOut = { 20.0, 20.0, 6.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
