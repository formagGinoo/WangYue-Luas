Config = Config or {}
Config.Entity2090403 = Config.Entity2090403 or { }
local empty = { }
Config.Entity2090403 = 
{
  [ 2090403 ] = {
    EntityId = 2090403,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/DecorationItem/indoor_10020005_XZL_zuoyi_A_02.prefab",
        Model = "DecorationItem/indoor_10020005_XZL_zuoyi_A_02",
        isClone = true,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Buff = empty,
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "body",
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = {
                  x = -3.05175781E-05,
                  y = 0.6774826,
                  z = -7.62939453E-06
                },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.79766846, 1.35496521, 1.579361 },
                UseMeshCollider = false
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 1.7,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      }
    }
  }
}
