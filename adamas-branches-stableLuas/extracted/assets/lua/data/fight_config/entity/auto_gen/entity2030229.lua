Config = Config or {}
Config.Entity2030229 = Config.Entity2030229 or { }
local empty = { }
Config.Entity2030229 = 
{
  [ 2030229 ] = {
    EntityId = 2030229,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Breakable/Zawu/Box/Box.prefab",
        Model = "BlowParent",
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
        SceneObjectTag = 2,
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
                LocalPosition = {
                  x = 9.119511E-06,
                  y = 0.197723374,
                  z = -3.874302E-07
                },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.517628431, 0.401446968, 0.754658341 },
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
        PiecesMass = 1.0,
        PhysicType = 1,
        PartStamina = {
          {
            TransformName = "AttackTarget",
            BlowBoneGroup = "BlowParent",
            Stamina = 1.0
          }
        },
        BreakSpeed = 1.0,
        DisappearTime = 3.0,
        CloseColliderTime = 5.0
      }
    }
  }
}
