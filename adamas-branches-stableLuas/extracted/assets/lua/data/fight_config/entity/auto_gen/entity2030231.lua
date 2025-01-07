Config = Config or {}
Config.Entity2030231 = Config.Entity2030231 or { }
local empty = { }
Config.Entity2030231 = 
{
  [ 2030231 ] = {
    EntityId = 2030231,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Breakable/Zawu/Drink2/Drink2.prefab",
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
      Blow = {
        Mass = 1000.0,
        PiecesMass = 10.0,
        PhysicType = 1,
        PartStamina = {
          {
            TransformName = "AttackTarget",
            BlowBoneGroup = "BlowParent",
            Stamina = 1.0
          }
        },
        BreakSpeed = 1.0,
        DisappearTime = -1.0,
        CloseColliderTime = -1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 5,
            SoundEvent = "ObjBreak_Wood",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      },
      Part = {
        PartList = {
          {            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Drink2Root",
                LocalPosition = { 0.0, 0.284, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.65267, 1.0, 0.43733 }
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

      }
    }
  }
}
