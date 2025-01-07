Config = Config or {}
Config.Entity2020112 = Config.Entity2020112 or { }
local empty = { }
Config.Entity2020112 = 
{
  [ 2020112 ] = {
    EntityId = 2020112,
    Components = {
      Transform = {
        Prefab = "CommonEntity/TransportMap/Prefab/TransportMap.prefab",
        Model = "TransportMap",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 1.37, 0.33 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 5.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 2.7, 2.8, 1.9 },
        CubeOut = { 3.7, 3.8, 3.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Behavior = {
        Behaviors = {
          "2020112"
        },
      },
      Buff = empty,
      Animator = {
        Animator = "CommonEntity/TransportMap/Prefab/TransportMap.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 202011201 ] = {
    EntityId = 202011201,
    Components = {
      Transform = {
        Prefab = "CommonEntity/TransportMap/Effect/FxTransportMapEffect.prefab",
        Model = "FxTransportMapEffect",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "CommonEntity/TransportMap/Effect/FXTransportMap.controller",
        AnimationConfigID = "",

      },
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "root",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  },
  [ 202011202 ] = {
    EntityId = 202011202,
    Components = {
      Transform = {
        Prefab = "CommonEntity/TransportMap/Effect/FxTransportMapEffect01.prefab",
        Model = "FxTransportMapEffect01",
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
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
