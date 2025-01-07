Config = Config or {}
Config.Entity2080111 = Config.Entity2080111 or { }
local empty = { }
Config.Entity2080111 = 
{
  [ 2080111 ] = {
    EntityId = 2080111,
    Components = {
      Transform = {
        Prefab = "CommonEntity/BuildEntity/BigTire/luntai_02.prefab",
        Model = "luntai_02",
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
                ParentName = "Axle",
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.4, 0.83, 0.4 },
                UseMeshCollider = true
              },
              {
                ShapeType = 3,
                ParentName = "Tire",
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.0, 0.28, 2.0 },
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
      Part = {
        PartList = {
          {
            Name = "body",
            PartType = 0,
            PartWeakType = 0,
            BoneColliders = {
              {
                ShapeType = 3,
                LocalPosition = { 0.0, 0.311, 0.064 },
                LocalEuler = { 0.0, 0.0, 270.0 },
                LocalScale = { 1.85, 0.8578928, 2.73 },
                UseMeshCollider = true
              },
              {
                ShapeType = 3,
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 90.0 },
                LocalScale = { 2.05, 0.349184781, 2.05 },
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
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/BuildIcon/drone.png",
        TriggerText = "激活轮胎",
        TriggerType = 0,
        Offset = { 0.0, 1.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = true,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 2.0, 2.0, 2.0 },
        CubeOut = { 3.0, 3.0, 3.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
