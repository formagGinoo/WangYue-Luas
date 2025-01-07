Config = Config or {}
Config.Entity2020601 = Config.Entity2020601 or { }
local empty = { }
Config.Entity2020601 = 
{
  [ 2020601 ] = {
    EntityId = 2020601,
    EntityName = "2020601",
    Components = {
      Transform = {
        Prefab = "CommonEntity/HouseDoor/Door2/Door2.prefab",
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
        BoneName = "",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      Rotate = {
        Speed = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      State = {
        DyingTime = 0.1,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 1.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.2,
            ForceTime = 0.6667,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.2,
            ForceTime = 0.6667,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 73 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 75 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.7,
            ForceTime = 0.7,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 2.0,
            ForceTime = 1.7333,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 1.7333
          }
        },
      },
      Behavior = {
        Behaviors = {
          "2020601"
        },
      },
      Trigger = {
        Offset = { -1.0, 0.1, 0.236 },
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 1.0,
        RadiusOut = 1.5,
        CubeIng = { 0.9, 0.2, 0.4 },
        CubeOut = { 1.1, 0.3, 0.6 }
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        PartTag = 1
      },
      Animator = {
        Animator = "CommonEntity/HouseDoor/Door2/Door2.controller",
        AnimationConfigID = "",

      },
      Effect = {
        IsBind = true,
        BindTransformName = "KeyCameraTarget",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  }
}
