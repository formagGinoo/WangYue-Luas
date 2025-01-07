Config = Config or {}
Config.Entity2080104 = Config.Entity2080104 or { }
local empty = { }
Config.Entity2080104 = 
{
  [ 2080104 ] = {
    EntityId = 2080104,
    Components = {
      Transform = {
        Prefab = "CommonEntity/WoodStump/WoodStump.prefab",
        Model = "BuildBin02",
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
                ShapeType = 3,
                LocalPosition = { 0.0, 0.338, -0.165 },
                LocalEuler = { 89.6672058, 0.0, 0.0 },
                LocalScale = { 0.55, 2.2, 0.55 },
                UseMeshCollider = true
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
        CubeIng = { 1.0, 1.0, 4.5 },
        CubeOut = { 1.0, 1.0, 4.5 },
        Offset = { 0.0, 0.3, 0.0 },
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
                ShapeType = 3,
                LocalPosition = { 0.0, 0.338, -0.165 },
                LocalEuler = { 89.6672058, 0.0, 0.0 },
                LocalScale = { 0.55, 2.2, 0.55 },
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
      }
    }
  }
}
