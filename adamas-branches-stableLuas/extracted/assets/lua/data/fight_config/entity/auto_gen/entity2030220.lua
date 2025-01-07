Config = Config or {}
Config.Entity2030220 = Config.Entity2030220 or { }
local empty = { }
Config.Entity2030220 = 
{
  [ 2030220 ] = {
    EntityId = 2030220,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Breakable/Drum/Drum.prefab",
        Model = "DrumRoot",
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
                ParentName = "DrumRoot",
                LocalPosition = { 0.0, 0.485, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.72811949, 1.068, 1.513413 }
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
            SoundEvent = "ObjBreak_Iron",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      },
      Blow = {
        Mass = 20.0,
        PiecesMass = 3.0,
        PhysicType = 1,
        PartStamina = {
          {
            TransformName = "AttackTarget",
            BlowBoneGroup = "BlowParent",
            Stamina = 20000.0
          }
        },
        BreakSpeed = 1.0,
        DisappearTime = -1.0,
        CloseColliderTime = -1.0
      }
    }
  }
}
