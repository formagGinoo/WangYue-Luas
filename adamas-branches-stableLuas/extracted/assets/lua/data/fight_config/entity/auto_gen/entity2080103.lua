Config = Config or {}
Config.Entity2080103 = Config.Entity2080103 or { }
local empty = { }
Config.Entity2080103 = 
{
  [ 2080103 ] = {
    EntityId = 2080103,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Console/Console.prefab",
        Model = "Console",
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
                LocalPosition = { 0.0, 1.37, 1.06 },
                LocalEuler = { 19.757, 0.0, 0.0 },
                LocalScale = { 0.417013615, 0.415481359, 0.1001577 },
                UseMeshCollider = false
              },
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.647, 0.87 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.47901, 0.8991614, 0.49140057 },
                UseMeshCollider = false
              },
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.123, 0.0 },
                LocalEuler = { 0.0, 180.0, 0.0 },
                LocalScale = { 2.65290046, 0.242086649, 2.89443636 },
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
        adsorbDistance = 2.0,
        IsDisableRotation = false,
        IsSetKinematic = false,
        IsDisableMove = false,
        IsCallBehavior = false,
        OnlyCanUseBuildPoint = true,
        IsAutoCheckAngle = false,
        maxAngle = 45
      },
      CommonBehavior = {
        CommonBehaviors = {
          BuildConsole = {
            ComponentBehaviorName = "CommonBuildConsoleBehavior",
            NewCommonBehaviorParms = {
              [ "(空中)X轴最大倾斜角度" ] = 30.0,
              [ "(空中)X轴每帧旋转角度" ] = 0.8,
              [ "(空中)Y轴每帧旋转角度" ] = 1.15,
              [ "(空中)Z轴最大倾斜角度" ] = 15.0,
              [ "(空中)Z轴每帧旋转角度" ] = 0.5,
              [ "(水中)Y轴每帧旋转角度" ] = 0.2
            }
          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/BuildIcon/drone.png",
        TriggerText = "操纵",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 1.5,
        RadiusOut = 1.5,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Part = {
        PartList = {
          {
            Name = "body",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 1.37, 1.06 },
                LocalEuler = { 19.757, 0.0, 0.0 },
                LocalScale = { 0.417013615, 0.415481359, 0.1001577 },
                UseMeshCollider = false
              },
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.647, 0.87 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.47901, 0.8991614, 0.49140057 },
                UseMeshCollider = false
              },
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.027, 0.0 },
                LocalEuler = { 0.0, 180.0, 0.0 },
                LocalScale = { 1.6, 0.119, 1.6 },
                UseMeshCollider = false
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
      }
    }
  }
}
