Config = Config or {}
Config.Entity2030912 = Config.Entity2030912 or { }
local empty = { }
Config.Entity2030912 = 
{
  [ 2030912 ] = {
    EntityId = 2030912,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Freezer/Prefab/Freezer_Build.prefab",
        Model = "Freezer_Build",
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
      HackingInputHandle = {
        HackingType = 5,
        Name = "垃圾桶",
        Icon = "Textures/Icon/Single/BuildIcon/BuildBin02.png",
        Desc = "天月城常见的垃圾桶",
        EffectType = 2,
        ActiveHackingCostElectricity = 0,
        UseSelfIcon = true,
        DownButtonBindDestroy = true,
        UpHackingButtonType = 0,
        UpHackingClickType = {
          CostElectricity = 0,
          HackingRam = 0,

        },
        UpHackingActiveType = {
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveHackingRam = 0,

        },
        RightHackingButtonType = 0,
        RightHackingClickType = {
          CostElectricity = 0,
          HackingRam = 0,

        },
        RightHackingActiveType = {
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveHackingRam = 0,

        },
        DownHackingButtonType = 0,
        DownHackingClickType = {
          CostElectricity = 0,
          HackingRam = 0,

        },
        DownHackingActiveType = {
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveHackingRam = 0,

        },
        LeftHackingButtonType = 0,
        LeftHackingClickType = {
          CostElectricity = 0,
          HackingRam = 0,

        },
        LeftHackingActiveType = {
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveHackingRam = 0,

        },
        UpButton = "",
        RightButton = "",
        DownButton = "",
        UpButtonCost = 0,
        RightButtonCost = 0,
        DownButtonCost = 0,
        LeftButtonCost = 0,
        UpPlayerAnimationName = "",
        RightPlayerAnimationName = "",
        DownPlayerAnimationName = "",
        LeftPlayerAnimationName = "",
        UpPartnerAnimationName = "",
        RightPartnerAnimationName = "",
        DownPartnerAnimationName = "Attack012end",
        LeftPartnerAnimationName = "",
        UpContinueHacking = false,
        RightContinueHacking = false,
        DownContinueHacking = false,
        LeftContinueHacking = false,
        UpHackingRam = 0,
        RightHackingRam = 0,
        DownHackingRam = 0,
        LeftHackingRam = 0,
        UpHackingButtonName = "",
        RightHackingButtonName = "",
        DownHackingButtonName = "",
        LeftHackingButtonName = ""
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
                ParentName = "Steelplate",
                LocalPosition = { 0.0, 0.135, 0.025 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.2, 1.5, 1.1 },
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
        adsorbDistance = 1.5,
        IsDisableRotation = false,
        IsSetKinematic = false,
        IsDisableMove = false,
        IsCallBehavior = false,
        OnlyCanUseBuildPoint = true,
        IsAutoCheckAngle = false,
        maxAngle = 45
      },
      Part = {
        PartList = {
          {
            Name = "body",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HackPoint",
            attackTransformName = "HackPoint",
            hitTransformName = "HackPoint",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Steelplate",
                LocalPosition = { 0.0, 0.135, 0.025 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.175, 1.5, 1.1 },
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
        Offset = { 0.0, 1.5, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 }
      }
    }
  }
}
