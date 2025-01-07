Config = Config or {}
Config.Entity2090401 = Config.Entity2090401 or { }
local empty = { }
Config.Entity2090401 = 
{
  [ 2090401 ] = {
    EntityId = 2090401,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/DecorationItem/Indoor_10020007_QX_TY_11.prefab",
        Model = "Indoor_10020007_QX_TY_11",
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
                LocalPosition = { 0.0, 0.431250632, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.50003052, 0.862503052, 7.5 },
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
