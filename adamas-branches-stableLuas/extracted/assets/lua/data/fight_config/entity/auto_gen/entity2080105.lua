Config = Config or {}
Config.Entity2080105 = Config.Entity2080105 or { }
local empty = { }
Config.Entity2080105 = 
{
  [ 2080105 ] = {
    EntityId = 2080105,
    Components = {
      Transform = {
        Prefab = "CommonEntity/FlatCar/FlatCar.prefab",
        Model = "FlatCar",
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
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 1,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Buff = empty,
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
      Attributes = {
        DefaultAttrID = 20102,
      },
      Collision = {
        CollisionCheckType = 3,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "body",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "FlatCar_a",
                LocalPosition = { 0.0, 0.74, 0.008 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 3.5290246, 0.35, 5.001645 },
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
      Joint = {
        IsCanJoint = true,
        adsorbDistance = 4.0,
        IsDisableRotation = false,
        IsSetKinematic = false,
        IsDisableMove = false,
        IsCallBehavior = false,
        OnlyCanUseBuildPoint = false,
        IsAutoCheckAngle = false,
        maxAngle = 45
      },
      MovePlatform = {
        ShapeType = 2,
        Radius = 0.0,
        RadiusOut = 0.0,
        CubeIng = { 3.0, 3.0, 3.0 },
        CubeOut = { 3.0, 3.0, 3.0 },
        Offset = { 0.0, 1.5, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 }
      },
      Part = {
        PartList = {
          {
            Name = "body",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { -0.0332, 0.447, -0.0793 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.34802938, 0.35, 5.1762023 },
                UseMeshCollider = false
              },
              {
                ShapeType = 3,
                ParentName = "FlatCar_chelun_01a",
                LocalPosition = { -0.09, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 90.0 },
                LocalScale = { 0.9, 0.15, 0.9 },
                UseMeshCollider = true
              },
              {
                ShapeType = 3,
                ParentName = "FlatCar_chelun_01b",
                LocalPosition = { -0.09, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 90.0 },
                LocalScale = { -0.9, -0.149999991, -0.9 },
                UseMeshCollider = true
              },
              {
                ShapeType = 3,
                ParentName = "FlatCar_chelun_01c",
                LocalPosition = { -0.09, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 90.0 },
                LocalScale = { 0.9, 0.15, 0.9 },
                UseMeshCollider = true
              },
              {
                ShapeType = 3,
                ParentName = "FlatCar_chelun_01d",
                LocalPosition = { -0.09, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 90.0 },
                LocalScale = { -0.9, -0.149999991, -0.9 },
                UseMeshCollider = true
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            OnlyHitAlarm = false
          }
        },
        isTrigger = false
      },
      CommonBehavior = {
        CommonBehaviors = {
          FlatCar = {
            ComponentBehaviorName = "CommonFlatCarBehavior",
            NewCommonBehaviorParms = {
              [ "目标旋转角速度" ] = 1000.0,
              [ "旋转施加的力" ] = 1000.0,
              [ "转向时最大偏转角度" ] = 20.0
            }
          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      }
    }
  }
}
