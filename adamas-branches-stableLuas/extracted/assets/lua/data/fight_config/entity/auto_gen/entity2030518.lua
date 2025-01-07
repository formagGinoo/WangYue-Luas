Config = Config or {}
Config.Entity2030518 = Config.Entity2030518 or { }
local empty = { }
Config.Entity2030518 = 
{
  [ 2030518 ] = {
    EntityId = 2030518,
    Components = {
      Transform = {
        Prefab = "CommonEntity/ElectronicDoor/Prefab/ElectronicDoorController.prefab",
        Model = "ElectronicDoorController",
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
        SceneObjectTag = 1,
        Camp = 1,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      HackingInputHandle = {
        HackingType = 5,
        Name = "电子门禁",
        Icon = "Textures/Icon/Single/BuildIcon/ElectronicDoorController.png",
        Desc = "用于管理门开启和关闭的装置",
        EffectType = 2,
        ActiveHackingCostElectricity = 0,
        UseSelfIcon = true,
        DownButtonBindDestroy = false,
        UpHackingButtonType = 1,
        UpHackingClickType = {
          ButtonIcon = "hack_opendoor",
          HackingButtonName = "开门",
          CostElectricity = 0,
          HackingRam = 0,
          HackingDesc = "开启门禁"
        },
        UpHackingActiveType = {
          UnActiveButtonIcon = "hack_opendoor",
          UnActiveHackingButtonName = "开门",
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveButtonIcon = "hack_opendoor",
          ActiveHackingButtonName = "关门",
          ActiveHackingRam = 0,
          HackingDesc = "开关门禁"
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
        UpButton = "hack_hijack",
        UpButtonCost = 0,
        RightButtonCost = 0,
        DownButtonCost = 0,
        LeftButtonCost = 0,
        UpPlayerAnimationName = "PartnerCtrFront",
        RightPlayerAnimationName = "",
        DownPlayerAnimationName = "",
        LeftPlayerAnimationName = "",
        UpPartnerAnimationName = "Attack012end",
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
                ParentName = "Monitor02",
                LocalPosition = { 0.0, 0.854, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.7359, 2.4257, 1.3765 }
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
          "2030518"
        },
      }
    }
  }
}
