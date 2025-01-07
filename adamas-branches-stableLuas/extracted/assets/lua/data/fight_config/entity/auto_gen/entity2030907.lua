Config = Config or {}
Config.Entity2030907 = Config.Entity2030907 or { }
local empty = { }
Config.Entity2030907 = 
{
  [ 2030907 ] = {
    EntityId = 2030907,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1005.prefab",
        Model = "Entity1005",
        isClone = false,
        MinDistance = 0.5,
        MaxDistance = 1.5,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.85,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Behavior = {
        Behaviors = {
          "2030907"
        },
      },
      HackingInputHandle = {
        HackingType = 4,
        Name = "排气扇",
        Icon = "Textures/Icon/Single/BuildIcon/Pipe.png",
        Desc = "骇入以激活排气扇",
        EffectType = 2,
        ActiveHackingCostElectricity = 0,
        UseSelfIcon = true,
        DownButtonBindDestroy = false,
        UpHackingButtonType = 1,
        UpHackingClickType = {
          ButtonIcon = "hack_opendoor",
          CostElectricity = 0,
          HackingRam = 0,

        },
        UpHackingActiveType = {
          UnActiveButtonIcon = "hack_opendoor",
          UnActiveHackingButtonName = "开启",
          CostElectricity = 0,
          UnActiveHackingRam = 0,
          ActiveButtonIcon = "hack_opendoor",
          ActiveHackingButtonName = "关闭",
          ActiveHackingRam = 0,
          HackingDesc = "排气扇开关"
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
      Collision = {
        CollisionCheckType = 3,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "HackCollider",
            BoneColliders = {
              {
                ShapeType = 2,
                ParentName = "Entity1005",
                LocalPosition = { 0.0, 0.0, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 2.0, 2.0, 2.0 },
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
      }
    }
  }
}
