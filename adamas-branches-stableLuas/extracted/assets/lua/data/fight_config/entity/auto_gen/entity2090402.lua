Config = Config or {}
Config.Entity2090402 = Config.Entity2090402 or { }
local empty = { }
Config.Entity2090402 = 
{
  [ 2090402 ] = {
    EntityId = 2090402,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/DecorationItem/Indoor_10020005_XZL_Fangjian_A_04.prefab",
        Model = "DecorationItem/Indoor_10020005_XZL_Fangjian_A_04",
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
                LocalPosition = { -0.0571289063, 0.860244751, -0.125953674 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 5.98584, 1.7204895, 7.59907532 },
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
