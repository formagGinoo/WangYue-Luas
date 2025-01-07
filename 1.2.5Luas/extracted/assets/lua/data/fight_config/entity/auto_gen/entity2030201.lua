Config = Config or {}
Config.Entity2030201 = Config.Entity2030201 or { }
local empty = { }
Config.Entity2030201 = 
{
  [ 2030201 ] = {
    EntityId = 2030201,
    EntityName = "2030201",
    Components = {
      Transform = {
        Prefab = "CommonEntity/Flowerwall/Prefab/FlowerWall.prefab",
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
      Animator = {
        Animator = "CommonEntity/Flowerwall/Animation/FlowerWall/FlowerWall.controller",
        AnimationConfigID = "",

      },
      Hit = empty,
      Camp = {
        Camp = 2
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
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 9000.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "AttackTarget",
            attackTransformName = "AttackTarget",
            hitTransformName = "AttackTarget",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "bp_root",
                LocalPosition = { -1.33, 1.936, 0.07 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 1.0, 1.0 }
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
        DefaultAttrID = 20101,
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
          "2030201"
        },
      },
      LifeBar = {
        Prefab = "Prefabs/UI/Fight/LifeBar/MonsterLifeBarObj.prefab",
        LifeBarLength = 366.0,
        ShowArmorBar = false,
        TransformName = "",
        OffsetWorldY = 0.0,
        OffsetX = 0.1,
        OffsetY = 2.5,
        OffsetZ = 1.7,
        canShowInBody = true,
        lockPosition = true,
        headRadius = 0.5,
        ShowType = 1,
        ShowTime = 5.0,
        DetailDistance = 20.0,
        SimpleDistance = 30.0
      },
      ElementState = {
        ElementType = 1,

      }
    }
  },
  [ 203020101 ] = {
    EntityId = 203020101,
    EntityName = "203020101",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bone002",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/Flowerwall/Effect/FxFlowerWallLoop.prefab",
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
      }
    }
  },
  [ 203020102 ] = {
    EntityId = 203020102,
    EntityName = "203020102",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/Flowerwall/Effect/FxFlowerWallDeath.prefab",
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
      }
    }
  }
}
