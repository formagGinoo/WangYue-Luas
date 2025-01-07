Config = Config or {}
Config.Entity2030225 = Config.Entity2030225 or { }
local empty = { }
Config.Entity2030225 = 
{
  [ 2030225 ] = {
    EntityId = 2030225,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Breakable/RobRoom/Xuanguan01.prefab",
        Model = "BlowParent",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = true
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
                LocalPosition = { 0.0, 0.669, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.5312524, 1.25489986, 7.59657431 }
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
        DisappearTime = -1.0,
        CloseColliderTime = 30.0
      }
    }
  }
}
