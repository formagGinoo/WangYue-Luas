Config = Config or {}
Config.Entity2030207 = Config.Entity2030207 or { }
local empty = { }
Config.Entity2030207 = 
{
  [ 2030207 ] = {
    EntityId = 2030207,
    EntityName = "2030207",
    Components = {
      Transform = {
        Prefab = "CommonEntity/Thorn/Prefab/Thorn01.prefab",
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
      Hit = empty,
      Camp = {
        Camp = 3
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        PartTag = 1
      },
      Part = {
        PartList = {
          {
            Name = "AttackTarget",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "AttackTarget",
            attackTransformName = "AttackTarget",
            hitTransformName = "AttackTarget",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "AttackTarget",
                LocalPosition = { 0.0, 0.023, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.78, 0.576562464, 0.78 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          }
        },

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Attributes = {
        DefaultAttrID = 0,
      },
      State = {
        DyingTime = 3.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 1.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.0,
            ForceTime = 0.6667,
            FusionChangeTime = 0.6667,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.2,
            ForceTime = 0.6667,
            FusionChangeTime = 0.6667,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 0.9,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 0.9,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 73 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 75 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.7,
            ForceTime = 0.7,
            FusionChangeTime = 0.7,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 2.0,
            ForceTime = 1.7333,
            FusionChangeTime = 1.7333,
            IgnoreHitTime = 1.7333
          }
        },
      },
      Behavior = {
        Behaviors = {
          "2030206"
        },
      }
    }
  }
}
