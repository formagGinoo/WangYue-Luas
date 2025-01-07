Config = Config or {}
Config.Entity2041002 = Config.Entity2041002 or { }
local empty = { }
Config.Entity2041002 = 
{
  [ 2041002 ] = {
    EntityId = 2041002,
    Components = {
      Transform = {
        Prefab = "CommonEntity/RoofCombat/Prefab/YueYun.prefab",
        Model = "YueYun",
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
        Frame = 0,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2041002"
        },
      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = true,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 3.0,
        RadiusOut = 3.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  },
  [ 204100201 ] = {
    EntityId = 204100201,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/RoofCombat/Effect/FxYueYunCrstal_01.prefab",
        Model = "BeilubeiteFxAtk006daoguang",
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
        Frame = 0,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 204100202 ] = {
    EntityId = 204100202,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/RoofCombat/Effect/FxYueNengCircal_01.prefab",
        Model = "circal",
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
        Frame = 0,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "CommonEntity/RoofCombat/Effect/AnimationController/FxYueNengCircal_01Ani.controller",
        AnimationConfigID = "",

      },
      Sound = {
        SoundEventList = {
          {
            EventType = 0,
            SoundEvent = "FxYueNengCloud_01_Active",
            DelayTime = 0.0,
            LifeBindEntity = true
          },
          {
            EventType = 0,
            SoundEvent = "FxYueNengCloud_01_Loop",
            DelayTime = 0.0,
            LifeBindEntity = true
          },
          {
            EventType = 0,
            SoundEvent = "FxYueNengCloud_01_End",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  }
}
