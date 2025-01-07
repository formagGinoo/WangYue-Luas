Config = Config or {}
Config.Entity2080109 = Config.Entity2080109 or { }
local empty = { }
Config.Entity2080109 = 
{
  [ 2080109 ] = {
    EntityId = 2080109,
    Components = {
      Transform = {
        Prefab = "Character/Animal/Mailing/MailingTask.prefab",
        Model = "MailingTask",
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
        BindTransformName = "HackPoint",
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
            Name = "HitCase",
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.3, 0.3, 0.3 },
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
        adsorbDistance = 3.0,
        IsDisableRotation = false,
        IsSetKinematic = false,
        IsDisableMove = false,
        IsCallBehavior = false,
        OnlyCanUseBuildPoint = false,
        IsAutoCheckAngle = false,
        maxAngle = 70
      },
      Part = {
        PartList = {
          {
            Name = "HitCase",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HackPoint",
            attackTransformName = "HackPoint",
            hitTransformName = "HackPoint",
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.16, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.3, 0.3, 0.3 },
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
      },
      MovePlatform = {
        ShapeType = 2,
        Radius = 0.0,
        RadiusOut = 0.0,
        CubeIng = { 3.0, 3.0, 3.0 },
        CubeOut = { 3.0, 3.0, 3.0 },
        Offset = { 0.0, 1.68, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 }
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_talk.png",
        TriggerText = "对话",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 1.5,
        RadiusOut = 2.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Animator = {
        Animator = "Character/Animal/Mailing/Mailing.controller",
        AnimationConfigID = "8012001",

      }
    }
  }
}
