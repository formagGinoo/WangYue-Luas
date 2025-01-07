Config = Config or {}
Config.Entity2030222 = Config.Entity2030222 or { }
local empty = { }
Config.Entity2030222 = 
{
  [ 2030222 ] = {
    EntityId = 2030222,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Breakable/Table/Table.prefab",
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
                ParentName = "TableRoot",
                LocalPosition = { 0.0, 0.32, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.3918, 1.0, 1.6098 }
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
        DisappearTime = 2.0,
        CloseColliderTime = 1.0
      }
    }
  }
}
