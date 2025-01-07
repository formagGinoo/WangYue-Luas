Config = Config or {}
Config.Entity2030219 = Config.Entity2030219 or { }
local empty = { }
Config.Entity2030219 = 
{
  [ 2030219 ] = {
    EntityId = 2030219,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Breakable/Guardrail/Guardrail.prefab",
        Model = "BlowParent",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
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
                LocalScale = { 0.12997, 1.068, 2.16272569 }
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

      },
      Blow = {
        Mass = 10.0,
        PiecesMass = 3.0,
        PhysicType = 1,
        PartStamina = {
          {
            TransformName = "AttackTarget",
            BlowBoneGroup = "BlowParent",
            Stamina = 1.0
          }
        },
        BreakSpeed = 1.0,
        CreateBreakEntities = {
          {
            EntityId = 200000107,
            LookatType = 3
          }
        },
        CreateDisappearEntities = {
          {
            EntityId = 200000107,
            LookatType = 3
          }
        },
        DisappearTime = 180.0,
        CloseColliderTime = 60.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 5,
            SoundEvent = "ObjBreak_Iron",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      }
    }
  }
}
