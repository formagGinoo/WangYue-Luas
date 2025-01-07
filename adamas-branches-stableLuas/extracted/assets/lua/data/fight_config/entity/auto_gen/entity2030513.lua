Config = Config or {}
Config.Entity2030513 = Config.Entity2030513 or { }
local empty = { }
Config.Entity2030513 = 
{
  [ 2030513 ] = {
    EntityId = 2030513,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Monitor/Prefab/Monitor04.prefab",
        Model = "Monitor04",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      HackingInputHandle = {
        HackingType = 4,
        Name = "智能终端",
        Icon = "Textures/Icon/Single/BuildIcon/Monitor.png",
        Desc = "骇入以获取终端机密信息",
        EffectType = 2,
        ActiveHackingCostElectricity = 0,
        UseSelfIcon = true,
        DownButtonBindDestroy = false,
        UpHackingButtonType = 0,
        UpHackingClickType = {
          ButtonIcon = "hack_hijack",
          HackingButtonName = "劫持",
          CostElectricity = 0,
          HackingRam = 0,
          HackingDesc = "劫持获得操控权限"
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
        DownPartnerAnimationName = "",
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
      Move = {
        pivot = 0.0,
        canGlide = false,
        canShowGlideObj = true,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        GlideBindNode = "",
        isFlyEntity = false,
        bornFlyHeight = 0.0,
        flyHeight = 0.0,
        minFlyHeight = 0.0,
        fallRecoverTime = 0.0,
        hitStateMinHeight = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_key.png",
        TriggerText = "解锁",
        TriggerType = 0,
        Offset = { 0.0, 0.9, 0.0 },
        DurationTime = -1.0,
        ShapeType = 2,
        EnterBehaviorAlways = false,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 3.0, 3.0, 3.0 },
        CubeOut = { 3.5, 3.5, 3.5 },
        SetOutOffset = true,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Buff = empty,
      Collision = {
        CollisionCheckType = 3,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Body",
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { 0.203, 0.688, 0.053 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 1.2, 1.0 }
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
      Behavior = {
        Behaviors = {
          "2030513"
        },
      }
    }
  }
}
