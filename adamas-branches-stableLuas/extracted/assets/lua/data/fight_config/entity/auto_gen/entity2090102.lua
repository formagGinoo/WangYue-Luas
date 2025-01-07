Config = Config or {}
Config.Entity2090102 = Config.Entity2090102 or { }
local empty = { }
Config.Entity2090102 = 
{
  [ 2090102 ] = {
    EntityId = 2090102,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yuenengcaijiyi_01/Prefab/AssetItem_Yuenengcaijiyi_01.prefab",
        Model = "AssetItem_Yuenengcaijiyi_01",
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
                ShapeType = 3,
                LocalPosition = { 0.0, 4.461456, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 14.85203, 4.47145557, 14.85203 },
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
        Radius = 5.0,
        RadiusOut = 5.0,
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
      Display = {
        isDecoration = true,
        Bodyily = 1,
        DisplayEvents = {
          {
            DisplayType = 0,
            Note = "关闭",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 2,
                animName = "InactiveMode_Idle",
              }
            },
          },
          {
            DisplayType = 1,
            Note = "启动",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 2,
                animName = "ActiveMode_Idle",
                CreateEntitys = {
                  {
                    EntityId = 209010202,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              },
              {
                animType = 1,
                animName = "IntoActiveMode",
                CreateEntitys = {
                  {
                    EntityId = 209010201,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              },
              {
                animType = 3,
                animName = "IntoInactiveMode",
                CreateEntitys = {
                  {
                    EntityId = 209010203,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              }
            },
          }
        },
        StateEvents = {
          {
            StateType = 0,
            LayerIndex = 0,
            CreateEntitys = {
              {
                EntityId = 209010201,
                Scale = { 1.0, 1.0, 1.0 }
              }
            },
          },
          {
            StateType = 1,
            LayerIndex = 0,
          }
        },
      },
      Animator = {
        Animator = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yuenengcaijiyi_01/Animation/AssetItem_Yuenengcaijiyi_01.controller",
        AnimationConfigID = "2090102",

      },
      Buff = empty}
  },
  [ 209010201 ] = {
    EntityId = 209010201,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "AssetItem_Yuenengcaijiyi_01",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.5, 0.5, 0.5 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yuenengcaijiyi_01/Effect/FxYuenengcaijiyiEffect_01.prefab",
        Model = "FxYuenengcaijiyiEffect_01",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Yuenengcaijiyi_01_Idle",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 209010202 ] = {
    EntityId = 209010202,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "AssetItem_Yuenengcaijiyi_01",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.5, 0.5, 0.5 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yuenengcaijiyi_01/Effect/FxYuenengcaijiyiEffect_02.prefab",
        Model = "FxYuenengcaijiyiEffect_02",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Yuenengcaijiyi_01_Active",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 209010203 ] = {
    EntityId = 209010203,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "AssetItem_Yuenengcaijiyi_01",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.5, 0.5, 0.5 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yuenengcaijiyi_01/Effect/FxYuenengcaijiyiEffect_03.prefab",
        Model = "FxYuenengcaijiyiEffect_03",
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
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
