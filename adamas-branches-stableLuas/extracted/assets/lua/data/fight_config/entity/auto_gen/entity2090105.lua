Config = Config or {}
Config.Entity2090105 = Config.Entity2090105 or { }
local empty = { }
Config.Entity2090105 = 
{
  [ 2090105 ] = {
    EntityId = 2090105,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Canzhuo_01/Prefab/AssetItem_Canzhuo_01.prefab",
        Model = "AssetItem_Canzhuo_01",
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
                LocalPosition = { 0.0, 0.606485963, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 9.22151, 1.21297193, 3.1390965 },
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
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 3,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 4.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      CommonBehavior = {
        CommonBehaviors = {
          DisplayInteract = {
            ComponentBehaviorName = "CommonDisplayInteractBehavior",

          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Buff = empty}
  }
}
