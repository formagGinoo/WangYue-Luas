Config = Config or {}
Config.Entity2090101 = Config.Entity2090101 or { }
local empty = { }
Config.Entity2090101 = 
{
  [ 2090101 ] = {
    EntityId = 2090101,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Diaoduzhongxin_01/Prefab/AssetItem_Diaoduzhongxin_01.prefab",
        Model = "AssetItem_Diaoduzhongxin_01",
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
                LocalPosition = { 0.0, 1.26661789, 0.159126639 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 4.52243, 2.53323579, 1.36493909 },
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
        Offset = { 0.0, 1.3, 1.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 3.5, 2.5, 2.0 },
        CubeOut = { 4.0, 2.5, 3.0 },
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
      Buff = empty,
      Display = {
        isDecoration = true,
        Bodyily = 1,
        DisplayEvents = {
          {
            DisplayType = 0,
            Note = "关闭",
            LayerIndex = 0,
          },
          {
            DisplayType = 1,
            Note = "启动",
            LayerIndex = 0,
          }
        },
        StateEvents = {
          {
            StateType = 0,
            LayerIndex = 0,
            CreateEntitys = {
              {
                EntityId = 209010101,
                Scale = { 1.0, 1.0, 1.0 }
              }
            },
          }
        },
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Diaoduzhongxin_01_Idle",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 209010101 ] = {
    EntityId = 209010101,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "AssetItem_Diaoduzhongxin_01",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.5, 0.5, 0.5 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Diaoduzhongxin_01/Effect/FxDiaoduzhongxinEffect.prefab",
        Model = "FxDiaoduzhongxinEffect",
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
      Animator = {
        Animator = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Diaoduzhongxin_01/Effect/FxDiaoduzhongxinEffectAni.controller",
        AnimationConfigID = "209010101",

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
                animType = 1,
                animName = "FxDiaoduzhongxinEffectAni_Stand",
              },
              {
                animType = 2,
                animName = "FxDiaoduzhongxinEffectAni_Loop",
              }
            },
          },
          {
            DisplayType = 1,
            Note = "启动",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 3,
                animName = "FxDiaoduzhongxinEffectAni_End",
              },
              {
                animType = 2,
                animName = "FxDiaoduzhongxinEffectAni_Loop",
              }
            },
          }
        },
      }
    }
  }
}
