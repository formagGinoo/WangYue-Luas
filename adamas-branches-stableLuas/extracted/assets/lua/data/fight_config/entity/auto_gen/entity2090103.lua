Config = Config or {}
Config.Entity2090103 = Config.Entity2090103 or { }
local empty = { }
Config.Entity2090103 = 
{
  [ 2090103 ] = {
    EntityId = 2090103,
    Components = {
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yueshishengchanxian_01/Prefab/AsseItem_Yueshishengchanxian_01.prefab",
        Model = "AsseItem_Yueshishengchanxian_01",
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
                ParentName = "AssetItem_Yueshishengchanxian_01",
                LocalPosition = { 0.0, 1.43867481, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 3.38311768, 2.87735, 15.9916992 },
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
      Buff = empty,
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 2.0, 0.0 },
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
        CubeIng = { 7.0, 4.5, 20.0 },
        CubeOut = { 8.0, 4.5, 21.0 },
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
          },
          {
            DisplayType = 1,
            Note = "启动",
            LayerIndex = 0,
            AnimConfigs = {
              {
                animType = 2,
                animName = "",
                CreateEntitys = {
                  {
                    EntityId = 209010301,
                    Scale = { 1.0, 1.0, 1.0 }
                  }
                },
              }
            },
          }
        },
      },
      Animator = {
        Animator = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yueshishengchanxian_01/Effect/FxYueshishengchanxianAni.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 209010301 ] = {
    EntityId = 209010301,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "AssetItem_Yueshishengchanxian_01",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.5, 0.5, 0.5 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yueshishengchanxian_01/Effect/FxYueshishengchanxian.prefab",
        Model = "FxYueshishengchanxian",
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
        Animator = "CommonAssetItem/AssetItemEnity/FunctionalItem/AssetItem_Yueshishengchanxian_01/Effect/FxYueshishengchanxianAni.controller",
        AnimationConfigID = "209010301",

      },
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
            AnimConfigs = {
              {
                animType = 2,
                animName = "FxYueshishengchanxianAni_Loop",
              }
            },
          }
        },
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Yueshishengchanxian_01_Active",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  }
}
