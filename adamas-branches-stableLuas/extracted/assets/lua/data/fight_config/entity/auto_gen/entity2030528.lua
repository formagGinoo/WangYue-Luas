Config = Config or {}
Config.Entity2030528 = Config.Entity2030528 or { }
local empty = { }
Config.Entity2030528 = 
{
  [ 2030528 ] = {
    EntityId = 2030528,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Radio/Prefab/HackShouyinji.prefab",
        Model = "HackShouyinji",
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
        Tag = 1,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      HackingInputHandle = {
        HackingType = 5,
        Name = "收音机",
        Icon = "Textures/Icon/Single/BuildIcon/Monitor.png",
        Desc = "最新款式的收音机",
        EffectType = 4,
        ActiveHackingCostElectricity = 0,
        UseSelfIcon = true,
        DownButtonBindDestroy = false,
        UpHackingButtonType = 0,
        UpHackingClickType = {
          ButtonIcon = "",
          HackingButtonName = "",
          CostElectricity = 0,
          HackingRam = 0,

        },
        UpHackingActiveType = {
          UnActiveButtonIcon = "hack_active",
          UnActiveHackingButtonName = "激活",
          CostElectricity = 0,
          UnActiveHackingRam = 6,
          ActiveButtonIcon = "hack_cancel",
          ActiveHackingButtonName = "关闭",
          ActiveHackingRam = 3,

        },
        RightHackingButtonType = 1,
        RightHackingClickType = {
          ButtonIcon = "hack_alarm",
          HackingButtonName = "警报",
          CostElectricity = 0,
          HackingRam = 10,

        },
        RightHackingActiveType = {
          UnActiveButtonIcon = "hack_active",
          UnActiveHackingButtonName = "激活",
          CostElectricity = 0,
          UnActiveHackingRam = 15,
          ActiveButtonIcon = "hack_cancel",
          ActiveHackingRam = 0,
          HackingDesc = "生成电磁场，让接触到电磁场的敌人眩晕"
        },
        DownHackingButtonType = 0,
        DownHackingClickType = {
          ButtonIcon = "hack_destroy",
          HackingButtonName = "爆炸",
          CostElectricity = 0,
          HackingRam = 20,
          HackingDesc = "爆炸，产生小范围伤害"
        },
        DownHackingActiveType = {
          UnActiveButtonIcon = "hack_active",
          UnActiveHackingButtonName = "激活",
          CostElectricity = 0,
          UnActiveHackingRam = 6,
          ActiveButtonIcon = "hack_cancel",
          ActiveHackingButtonName = "关闭",
          ActiveHackingRam = 3,

        },
        LeftHackingButtonType = 0,
        LeftHackingClickType = {
          ButtonIcon = "hack_alarm",
          HackingButtonName = "警报",
          CostElectricity = 0,
          HackingRam = 10,
          HackingDesc = "吸引周围敌人靠近"
        },
        LeftHackingActiveType = {
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveHackingRam = 0,

        },
        UpButton = "",
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
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 2.5,
        RadiusOut = 3.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
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
                LocalPosition = { 0.0, 0.094, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.4147496, 0.17672202, 0.25824517 }
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
          "2030528"
        },
      },
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      Part = {
        PartList = {
          {
            Name = "body",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HitCase",
            attackTransformName = "HitCase",
            hitTransformName = "HitCase",
            BoneColliders = {
              {
                ShapeType = 2,
                LocalPosition = { 0.0, 0.08, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.565984845, 0.173788518, 0.295491636 }
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

      },
      Attributes = {
        DefaultAttrID = 20102,
      }
    }
  }
}
