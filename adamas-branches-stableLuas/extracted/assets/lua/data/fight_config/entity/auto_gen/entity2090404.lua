Config = Config or {}
Config.Entity2090404 = Config.Entity2090404 or { }
local empty = { }
Config.Entity2090404 = 
{
  [ 2090404 ] = {
    EntityId = 2090404,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/DecorationItem/Outdoor_10020005_SY_Zhuoyi_01_03.prefab",
        Model = "Outdoor_10020005_SY_Zhuoyi_01_03",
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
                LocalPosition = { 0.0, 0.472829342, 0.0909255743 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.7807007, 0.9456587, 0.7770536 },
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
