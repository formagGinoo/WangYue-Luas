Config = Config or {}
Config.Entity2030101 = Config.Entity2030101 or { }
local empty = { }
Config.Entity2030101 = 
{
  [ 2030101 ] = {
    EntityId = 2030101,
    Components = {
      ElementState = {
        ElementType = 1,

      },
      Transform = {
        Prefab = "CommonEntity/ShootPuzzle/Prefab/ShootPuzzleGear.prefab",
        Model = "ShootPuzzleGear",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Animator = {
        Animator = "CommonEntity/ShootPuzzle/Animation/ShootPuzzleGear.controller",
        AnimationConfigID = "",

      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2030101"
        },
      },
      Hit = {
        hitModified = {
          SpeedZ = 1.0,
          SpeedZAcceleration = 1.0,
          SpeedZArmor = 1.0,
          SpeedZArmorAcceleration = 1.0,
          SpeedY = 1.0,
          SpeedZHitFly = 1.0,
          SpeedYAcceleration = 1.0,
          SpeedYAloft = 1.0,
          SpeedZAloft = 1.0,
          SpeedYAloftAcceleration = 1.0,
          FlyHitSpeedZ = 1.0,
          FlyHitSpeedZAcceleration = 1.0,
          FlyHitSpeedY = 1.0,
          FlyHitSpeedYAcceleration = 1.0,
          FlyHitSpeedYAloft = 1.0,
          FlyHitSpeedZAloft = 1.0,
          FlyHitSpeedYAccelerationAloft = 1.0
        }
      },
      Buff = empty,
      Part = {
        PartList = {
          {
            Name = "ClockWise1",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 100.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "ClockWise1",
            attackTransformName = "ClockWise1",
            hitTransformName = "ClockWise1",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Part",
                LocalPosition = { -0.889, 1.442, -0.213 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.8, 1.4887, 0.3 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "ClockWise2",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 100.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "ClockWise2",
            attackTransformName = "ClockWise2",
            hitTransformName = "ClockWise2",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Part",
                LocalPosition = { 0.34, 1.442, 1.009 },
                LocalEuler = { 0.0, 120.000008, 0.0 },
                LocalScale = { 0.8, 1.4887, 0.3 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "ClockWise3",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 100.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "ClockWise3",
            attackTransformName = "ClockWise3",
            hitTransformName = "ClockWise3",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Part",
                LocalPosition = { 0.697, 1.442, -0.778 },
                LocalEuler = { 0.0, 60.0000038, 0.0 },
                LocalScale = { 0.8, 1.4887, 0.3 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "AntiClockWise1",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 100.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "AntiClockWise1",
            attackTransformName = "AntiClockWise1",
            hitTransformName = "AntiClockWise1",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Part",
                LocalPosition = { -0.882, 1.442, 0.187 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.8, 1.4887, 0.3 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "AntiClockWise2",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 100.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "AntiClockWise2",
            attackTransformName = "AntiClockWise2",
            hitTransformName = "AntiClockWise2",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Part",
                LocalPosition = { 0.687, 1.442, 0.799 },
                LocalEuler = { 0.0, 120.000008, 0.0 },
                LocalScale = { 0.8, 1.4887, 0.3 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          },
          {
            Name = "AntiClockWise3",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 100.0
            },
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "AntiClockWise3",
            attackTransformName = "AntiClockWise3",
            hitTransformName = "AntiClockWise3",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Part",
                LocalPosition = { 0.324, 1.442, -0.987 },
                LocalEuler = { 0.0, 60.0000038, 0.0 },
                LocalScale = { 0.8, 1.48870015, 0.3 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          }
        },

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
      Attributes = {
        DefaultAttrID = 20103,
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1
      }
    }
  }
}
