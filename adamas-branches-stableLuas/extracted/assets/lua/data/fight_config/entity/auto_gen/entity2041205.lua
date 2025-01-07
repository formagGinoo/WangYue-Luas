Config = Config or {}
Config.Entity2041205 = Config.Entity2041205 or { }
local empty = { }
Config.Entity2041205 = 
{
  [ 2041205 ] = {
    EntityId = 2041205,
    Components = {
      Transform = {
        Prefab = "Character/Npc/Male180/MaleNpc01008/MaleNpc01008.prefab",
        Model = "MaleNpc01008",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
      },
      Animator = {
        Animator = "Character/Npc/Male180/Common/Male180.controller",
        AnimationConfigID = "800020",

      },
      Attributes = {
        DefaultAttrID = 800010,
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
                ShapeType = 3,
                ParentName = "MaleNpc01008",
                LocalPosition = { 0.0, 0.85, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 0.8, 1.0 },
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
        animStrClips = {
          "Stand1",
          "Afraid",
          "Backwalk",
          "Baishou",
          "Bhit",
          "Bingstand_loop",
          "Bow_end",
          "Bow_in",
          "Bow_loop",
          "Btanshou_end",
          "Btanshou_in",
          "Btanshou_loop",
          "Chayao_end",
          "Chayao_in",
          "Chayao_In",
          "Chayao_loop",
          "CheerL_end",
          "CheerL_in",
          "CheerL_loop",
          "CheerR_end",
          "CheerR_in",
          "CheerR_loop",
          "Clap_end",
          "Clap_in",
          "Clap_loop",
          "Count",
          "Dance",
          "Death",
          "Diantou",
          "Dodge",
          "DodgeBack",
          "Exercise1",
          "Exercise2",
          "Exercise3",
          "Fhit",
          "Fire_Fire",
          "Fire_Shoot_end",
          "Fire_Shoot_in",
          "Fire_Shoot_loop",
          "Fire_Shoot_out",
          "Fue_end",
          "Fue_in",
          "Fue_loop",
          "Fuxiong_end",
          "Fuxiong_in",
          "Fuxiong_loop",
          "HitDown",
          "HitFlyFall",
          "HitFlyHover",
          "HitFlyLand",
          "HitFlyUp",
          "InStand2",
          "Jiahuanhe_end",
          "Jiahuanhe_in",
          "Jiahuanhe_loop",
          "Jiastand_loop",
          "Jiaweihe_loop",
          "Jingxia_end",
          "Jingxia_in",
          "Jingxia_loop",
          "Jump",
          "Jushou_end",
          "Jushou_in",
          "Jushou_loop",
          "Laugh",
          "LeftHeavyHit",
          "LeftSlightHit",
          "Leftwalk",
          "Lie",
          "Liedown",
          "Motou_end",
          "Motou_in",
          "Motou_loop",
          "Paishou",
          "Pchayao_end",
          "Pchayao_in",
          "Pchayao_loop",
          "PhoneSit_end",
          "PhoneSit_in",
          "PhoneSit_loop",
          "PhoneStand_end",
          "PhoneStand_in",
          "PhoneStand_loop",
          "PhoneStand_out",
          "PhoneWalk",
          "PhoneWalk_end",
          "PhoneWalk_in",
          "PhoneWalk_loop",
          "PhotoSelf_end",
          "PhotoSelf_in",
          "PleaseL_end",
          "PleaseL_in",
          "PleaseL_loop",
          "PleaseR_end",
          "PleaseR_in",
          "PleaseR_loop",
          "Point",
          "Prevent_end",
          "Prevent_in",
          "Prevent_loop",
          "Ptanshou_end",
          "Ptanshou_in",
          "Ptanshou_loop",
          "Push",
          "Refuse",
          "RightHeavyHit",
          "RightSlightHit",
          "Rightwalk",
          "Run",
          "Run_Melee",
          "Sbaoxiong_end",
          "Sbaoxiong_in",
          "Sbaoxiong_loop",
          "Schayao_end",
          "Schayao_in",
          "Schayao_In",
          "Schayao_loop",
          "Shenshou_end",
          "Shenshou_in",
          "Shenshou_loop",
          "Sit_end",
          "Sit_in",
          "Sit_loop",
          "SitGround_end",
          "SitGround_in",
          "SitGround_loop",
          "SitPlayGame_end",
          "SitPlayGame_in",
          "SitPlayGame_loop",
          "SitTalk",
          "Sjushou_end",
          "Sjushou_in",
          "Sjushou_loop",
          "Smile",
          "Songjian_end",
          "Songjian_in",
          "Songjian_loop",
          "Squat_end",
          "Squat_in",
          "Squat_loop",
          "Squat_out",
          "Stand2",
          "StandBack",
          "StandUp",
          "Stanshou_end",
          "Stanshou_in",
          "Stanshou_loop",
          "Surprise",
          "Sweep",
          "TakePhoto_end",
          "TakePhoto_in",
          "TakePhoto_loop",
          "Tanshou_end",
          "Tanshou_in",
          "Tanshou_loop",
          "TextSit_end",
          "TextSit_in",
          "TextSit_loop",
          "TextStand_end",
          "TextStand_in",
          "TextStand_loop",
          "TextStand_out",
          "TextWalk",
          "TextWalk_end",
          "TextWalk_in",
          "TextWalk_loop",
          "Threaten",
          "TLsitgroundend",
          "Tuosai_end",
          "Tuosai_in",
          "Tuosai_loop",
          "Tuoshou_end",
          "Tuoshou_in",
          "Tuoshou_loop",
          "Walk",
          "Walk_Melee",
          "WalkBack",
          "WalkBack_Melee",
          "WalkLeft_Melee",
          "WalkRight_Melee",
          "Water",
          "Woquan_end",
          "Woquan_in",
          "Woquan_loop",
          "Yaotou",
          "Yistand_loop",
          "Yzhuanshen",
          "Zhidian_end",
          "Zhidian_in",
          "Zhidian_loop",
          "Zzhuanshen",
          "Attack001",
          "Attack002",
          "Angry_loop",
          "Blink_loop",
          "Disgust_loop",
          "Happy_loop",
          "Muse_loop",
          "Quiet_loop",
          "Sad_loop",
          "Serious_loop",
          "Shy_loop",
          "Smile_loop",
          "Sorrow_loop",
          "Surprise_loop",
          "Angry_liploop",
          "Disgust_liploop",
          "Happy_liploop",
          "Muse_liploop",
          "Quiet_liploop",
          "Sad_liploop",
          "Serious_liploop",
          "Smile_liploop",
          "Sorrow_liploop",
          "Surprise_liploop",
          "Talk_liploop",
          "Talk_Stand"
        },
        isTrigger = false
      },
      Tag = {
        Tag = 1,
        NpcTag = 6,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 100,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Body",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "MaleNpc01008",
                LocalPosition = { 0.0, 0.85, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.0, 1.0, 1.0 },
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
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
        Radius = 2.0,
        RadiusOut = 2.5,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.5,
            ForceTime = 1.5,
            FusionChangeTime = 1.5,
            IgnoreHitTime = 1.5
          }
        },
      },
      ElementState = {
        ElementType = 1,

      },
      Hit = {
        hitModified = {
          SpeedZ = 1.0,
          SpeedZAcceleration = 1.0,
          SpeedZArmor = 0.0,
          SpeedZArmorAcceleration = 0.0,
          SpeedY = 1.0,
          SpeedZHitFly = 1.0,
          SpeedYAcceleration = 1.0,
          SpeedYAloft = 1.0,
          SpeedZAloft = 1.0,
          SpeedYAloftAcceleration = 1.0,
          FlyHitSpeedZ = 1.0,
          FlyHitSpeedZAcceleration = 1.0,
          FlyHitSpeedY = 1.0,
          FlyHitSpeedYAcceleration = 1.0,
          FlyHitSpeedZArmor = 1.0,
          FlyHitSpeedZArmorAcceleration = 1.0,
          FlyHitSpeedYArmor = 1.0,
          FlyHitSpeedYArmorAcceleration = 1.0,
          FlyHitSpeedYAloft = 1.0,
          FlyHitSpeedZAloft = 1.0,
          FlyHitSpeedYAccelerationAloft = 1.0
        }
      },
      FindPath = empty,
      Skill = {
        Skills = {
          [ 80001001 ] = {
            TotalFrame = 122,
            ForceFrame = 122,
            SkillBreakSkillFrame = 122,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Push",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 9 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 9999.0,
                  Acceleration = 0.0,
                  RotateFrame = 17,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 12 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 5.0,
                  Acceleration = 0.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 0.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 1,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 26 ] = {
                {

                  EntityId = 90000201,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  IsBindTargetPosGround = false,
                  CameraShakeId = -1,
                  PauseFrameId = -1,
                  FrameTime = 26,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
            }
          },
          [ 80001002 ] = {
            TotalFrame = 99999999,
            ForceFrame = 99999999,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  RotateType = 0,
                  UseSelfSpeed = 0,
                  SpeedOffset = 999.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  Name = "Afraid",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 31 ] = {
                {

                  Name = "Afraid_loop",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 31,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001003 ] = {
            TotalFrame = 99999999,
            ForceFrame = 99999999,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Squat_in",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 39 ] = {
                {

                  Name = "Squat_loop",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 39,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001004 ] = {
            TotalFrame = 75,
            ForceFrame = 75,
            SkillBreakSkillFrame = 75,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Squat_out",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001005 ] = {
            TotalFrame = 210,
            ForceFrame = 210,
            SkillBreakSkillFrame = 210,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Point",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001006 ] = {
            TotalFrame = 35,
            ForceFrame = 35,
            SkillBreakSkillFrame = 35,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Afraid",
                  LayerIndex = 0,
                  StartFrame = 58,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001051 ] = {
            TotalFrame = 60,
            ForceFrame = 60,
            SkillBreakSkillFrame = 60,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 9999999.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  Name = "LeftSlightHit",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001052 ] = {
            TotalFrame = 47,
            ForceFrame = 47,
            SkillBreakSkillFrame = 47,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Fhit",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001053 ] = {
            TotalFrame = 47,
            ForceFrame = 47,
            SkillBreakSkillFrame = 47,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Bhit",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001054 ] = {
            TotalFrame = 116,
            ForceFrame = 116,
            SkillBreakSkillFrame = 116,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 9999999.0,
                  Acceleration = 0.0,
                  RotateFrame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  Name = "Dodge",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = -5.0,
                  Acceleration = 0.0,
                  MoveFrame = 2,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 54 ] = {
                {

                  Name = "DodgeBack",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 54,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001055 ] = {
            TotalFrame = 80,
            ForceFrame = 80,
            SkillBreakSkillFrame = 80,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "PhoneStand_in",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001056 ] = {
            TotalFrame = 130,
            ForceFrame = 130,
            SkillBreakSkillFrame = 130,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "PhoneStand_out",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001057 ] = {
            TotalFrame = 90,
            ForceFrame = 90,
            SkillBreakSkillFrame = 90,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "TextStand_in",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 80001058 ] = {
            TotalFrame = 80,
            ForceFrame = 80,
            SkillBreakSkillFrame = 80,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "TextStand_out",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          }
        }
      },
      HackingInputHandle = {
        HackingType = 3,
        Name = "加工从业者",
        Icon = "Textures/Icon/Single/HeadIcon/SquNJuminnan.png",
        Desc = "靠谱的成年男性",
        EffectType = 2,
        ActiveHackingCostElectricity = 0,
        UseSelfIcon = true,
        DownButtonBindDestroy = false,
        UpHackingButtonType = 0,
        UpHackingClickType = {
          ButtonIcon = "hack_msg",
          HackingButtonName = "拦截短信",
          CostElectricity = 0,
          HackingRam = 0,
          HackingDesc = "当目标发短信的时候，可以拦截目标的短信内容"
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
          ButtonIcon = "hack_eavesdrop",
          HackingButtonName = "窃听",
          CostElectricity = 0,
          HackingRam = 0,
          HackingDesc = "当目标打电话的时候，可以窃听目标的聊天内容"
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
        DownButton = "",
        UpButtonCost = 0,
        RightButtonCost = 0,
        DownButtonCost = 0,
        LeftButtonCost = 0,
        UpPlayerAnimationName = "PartnerCtrFront",
        RightPlayerAnimationName = "",
        DownPlayerAnimationName = "PartnerCtrFront",
        LeftPlayerAnimationName = "",
        UpPartnerAnimationName = "Attack012Begin",
        RightPartnerAnimationName = "",
        DownPartnerAnimationName = "Attack012Begin",
        LeftPartnerAnimationName = "",
        UpContinueHacking = true,
        RightContinueHacking = false,
        DownContinueHacking = true,
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
        pivot = 0.85,
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
        MoveType = 1,
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
        ConfigName = "Male180",
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      }
    }
  }
}
