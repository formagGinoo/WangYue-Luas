Config = Config or {}
Config.Entity8012003 = Config.Entity8012003 or { }
local empty = { }
Config.Entity8012003 = 
{
  [ 8012003 ] = {
    EntityId = 8012003,
    EntityName = "8012003",
    Components = {
      Transform = {
        Prefab = "Character/Animal/Yizhongzhu/YizhongzhuA1/Yizhongzhu.prefab",
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
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Collider",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "YizhongxiaozhuA1",
                LocalPosition = { 0.0, 0.573, 0.311 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.60519373, 0.50535, 1.60519373 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 1.6,
        Height = 0.6,
        offsetX = 0.0,
        offsetY = 0.65,
        offsetZ = 0.35
      },
      Part = {
        PartList = {
          {
            Name = "Collider",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HitCase",
            attackTransformName = "HitCase",
            hitTransformName = "HitCase",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "YizhongxiaozhuA1",
                LocalPosition = { 0.0, 0.671, 0.359 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.53867853, 0.5240566, 1.53867853 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = false,
            CheckEntityCollider = false
          }
        },

      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Animal/Yizhongzhu/YizhongzhuA1/YizhongzhuA1.controller",
        AnimationConfigID = "8012003",

      },
      Behavior = {
        Behaviors = {
          "8012003"
        },
      },
      Camp = {
        Camp = 3
      },
      Tag = {
        Tag = 1,
        NpcTag = 2,
        PartTag = 1
      },
      Buff = empty,
      FindPath = empty,
      Attributes = {
        DefaultName = "异种小猪",
        DefaultAttrID = 8012003,
      },
      State = {
        DyingTime = 2.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 2.0,
        FightToLeisurely = 0.0,
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
      Hit = empty,
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 1,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "ShilongMe1",
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      }
    }
  }
}
