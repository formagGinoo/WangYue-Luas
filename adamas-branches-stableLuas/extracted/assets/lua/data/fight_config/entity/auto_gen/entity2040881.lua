Config = Config or {}
Config.Entity2040881 = Config.Entity2040881 or { }
local empty = { }
Config.Entity2040881 = 
{
  [ 2040881 ] = {
    EntityId = 2040881,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/FxCheckPoint/Prefab/FxCurrentCheckPoint.prefab",
        Model = "FxCurrentCheckPoint",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
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
