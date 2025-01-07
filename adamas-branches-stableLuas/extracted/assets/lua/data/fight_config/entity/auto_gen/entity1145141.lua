Config = Config or {}
Config.Entity1145141 = Config.Entity1145141 or { }
local empty = { }
Config.Entity1145141 = 
{
  [ 1145141 ] = {
    EntityId = 1145141,
    Components = {
      Transform = {
        Prefab = "CommonEntity/IronBar/IronBar.prefab",
        Model = "IronBar",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Part = {
        PartList = {
          {
            Name = "AttackTarget",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.601, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.12997, 1.068, 2.16272569 },
                UseMeshCollider = false
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          }
        },
        isTrigger = true
      },
      Behavior = {
        Behaviors = {
          "2030201"
        },
      },
      Blow = {
        Mass = 10.0,
        PiecesMass = 10.0,
        PhysicType = 1,
        BreakSpeed = 1.0,
        DisappearTime = -1.0,
        CloseColliderTime = -1.0
      }
    }
  }
}
