Config = Config or {}
Config.Entity600080 = Config.Entity600080 or { }
local empty = { }
Config.Entity600080 = 
{
  [ 600080 ] = {
    EntityId = 600080,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/Common/Partner/ZhenshizhilieMo1P.prefab",
        Model = "ZhenshizhilieMo1P",
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
        Animator = "Character/Monster/Zhenshizhilie/Common/Partner/ZhenshizhilieMo1P.controller",
        AnimationConfigID = "",

      },
      Attributes = {
        DefaultAttrID = 600080,
        AttributeEventList = {
          {
            AttrType = 1007,
            RecoverEvent = {
              Time = 1.0,
              RecoverAttrType = 1007,
              RecoverAttrValue = 500,
              StopDmgCondition = {
                Time = 10.0
              }
            },
            EmptyEvent = {
              Time = 10.0,
              SelfMagicList = {
                900000003,
                900000004
              },
              PlayerMagicList = {
                900000005
              },
              EndMagicList = {
                900000006
              },
            }
          }
        },
      },
      Behavior = {
        Behaviors = {
          "600080"
        },
      },
      Tag = {
        Tag = 1,
        NpcTag = 5,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      State = {
        DyingTime = 2.83,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 1.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.2,
            ForceTime = 0.66,
            FusionChangeTime = 0.66,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.2,
            ForceTime = 0.66,
            FusionChangeTime = 0.66,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 0.9,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.8,
            ForceTime = 0.9,
            FusionChangeTime = 0.9,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.2,
            ForceTime = 1.2,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 73 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 75 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.7,
            ForceTime = 0.7,
            FusionChangeTime = 0.7,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.5,
            ForceTime = 0.5,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 2.0,
            ForceTime = 1.73,
            FusionChangeTime = 1.73,
            IgnoreHitTime = 1.73
          }
        },
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      ElementState = {
        ElementType = 5,

      },
      Skill = {
        Skills = {
          [ 60008000 ] = {
            TotalFrame = 13,
            ForceFrame = 13,
            SkillBreakSkillFrame = 13,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 2.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 0,
                MaxUseCostValue = 0,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 5,
                UseParentCost = true,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_SkillPanel_jiuxu.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "PartnerHacking",
                BehaviorConfig = 51,
                LayerConfig = 1059
              }
            },

          },
          [ 60008001 ] = {
            TotalFrame = 14,
            ForceFrame = 14,
            SkillBreakSkillFrame = 13,
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

                  EntityId = 600000002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack012Begin",
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
          [ 60008002 ] = {
            TotalFrame = 9999,
            ForceFrame = 9999,
            SkillBreakSkillFrame = 9999,
            ChangeRoleFrame = 99999,
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

                  Name = "Attack012loop",
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
          [ 60008003 ] = {
            TotalFrame = 40,
            ForceFrame = 40,
            SkillBreakSkillFrame = 33,
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

                  Name = "Attack011",
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
          [ 60008004 ] = {
            TotalFrame = 20,
            ForceFrame = 20,
            SkillBreakSkillFrame = 15,
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

                  EventName = "Hack_Start",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 15 ] = {
                {

                  Type = 800401,
                  Frame = 1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008005 ] = {
            TotalFrame = 30,
            ForceFrame = 20,
            SkillBreakSkillFrame = 20,
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

                  EventName = "Hack_Monitor",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 15 ] = {
                {

                  Type = 800401,
                  Frame = 1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008006 ] = {
            TotalFrame = 50,
            ForceFrame = 50,
            SkillBreakSkillFrame = 50,
            ChangeRoleFrame = 50,
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

                  Name = "HackStart001",
                  LayerIndex = 0,
                  StartFrame = 6,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 600000002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 8 ] = {
                {

                  AddType = 1,
                  BuffId = 600080021,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Type = 600080062,
                  Frame = 1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 14 ] = {
                {

                  AddType = 1,
                  BuffId = 600080023,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.7,
                    Dir = 0,
                    Radius = 0.28,
                    Alpha = 1.0,
                    AlphaCurveId = 100000033,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.5, 0.5 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 10,
                    ID = 0
                  },
                  LifeBindSkill = true,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 16,

                },
                {

                  Type = 600080063,
                  Frame = 1,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EventName = "Hack_In",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Type = 600080061,
                  Frame = 1,
                  FrameTime = 14,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 25 ] = {
                {

                  Name = "HackStart001",
                  LayerIndex = 0,
                  StartFrame = 47,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 37 ] = {
                {

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 37,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 989 ] = {
                {

                  ChangeAmplitud = -5.0,
                  ChangeTime = 0.3,
                  FrameTime = 989,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 999 ] = {
                {

                  AddType = 2,
                  BuffId = 600080020,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 600080020,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 600080022,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 9999 ] = {
                {

                  Type = 600000019,
                  Frame = 12,
                  FrameTime = 9999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  ChangeAmplitud = 5.0,
                  ChangeTime = 0.2,
                  FrameTime = 9999,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
            }
          },
          [ 60008007 ] = {
            TotalFrame = 20,
            ForceFrame = 20,
            SkillBreakSkillFrame = 20,
            ChangeRoleFrame = 20,
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

                  Name = "HackStart001",
                  LayerIndex = 0,
                  StartFrame = 21,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 60008011 ] = {
            TotalFrame = 14,
            ForceFrame = 14,
            SkillBreakSkillFrame = 13,
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

                  EntityId = 600000002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack012Begin",
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
          [ 60008012 ] = {
            TotalFrame = 9999,
            ForceFrame = 9999,
            SkillBreakSkillFrame = 9999,
            ChangeRoleFrame = 0,
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

                  Type = 8000201,
                  Frame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  AddType = 1,
                  BuffId = 600080001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "Attack012loop",
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
          [ 60008013 ] = {
            TotalFrame = 20,
            ForceFrame = 20,
            SkillBreakSkillFrame = 15,
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

                  Type = 801002,
                  Frame = 15,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 6000801301,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack013",
                  LayerIndex = 0,
                  StartFrame = 20,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 9 ] = {
                {

                  Type = 801301,
                  Frame = 1,
                  FrameTime = 9,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008020 ] = {
            TotalFrame = 36,
            ForceFrame = 36,
            SkillBreakSkillFrame = 36,
            ChangeRoleFrame = 36,
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

                  EventName = "Hack_Quit",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  AddType = 1,
                  BuffId = 200001040,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  Name = "HackEnd",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 19 ] = {
                {

                  EventName = "FxZhenshizhilieEnd",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 19,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 34 ] = {
                {

                  Type = 802001,
                  Frame = 1,
                  FrameTime = 34,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 35 ] = {
                {                  LifeBindSkill = true,
                  StopDelayFrame = 0,
                  StopSoundEvent = "Hack_During",
                  StopFadeDuration = 0,
                  FrameTime = 35,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
            }
          },
          [ 60008031 ] = {
            TotalFrame = 20,
            ForceFrame = 20,
            SkillBreakSkillFrame = 16,
            ChangeRoleFrame = 15,
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

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 15 ] = {
                {

                  Type = 803101,
                  Frame = 1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008032 ] = {
            TotalFrame = 30,
            ForceFrame = 30,
            SkillBreakSkillFrame = 20,
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

                  Name = "Attack012end",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 20 ] = {
                {

                  Type = 803201,
                  Frame = 1,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008033 ] = {
            TotalFrame = 99999,
            ForceFrame = 99999,
            SkillBreakSkillFrame = 99999,
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

                  Name = "Attack012loop",
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
          [ 60008040 ] = {
            TotalFrame = 46,
            ForceFrame = 46,
            SkillBreakSkillFrame = 46,
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

                  EventName = "ZhenshizhilieMo1_Atk014",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  EventName = "ZhenshizhilieMo1_Atk014_Show",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  ChangeAmplitud = 2.0,
                  ChangeTime = 0.25,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  IsBingSkill = true,
                  GroupId = 0,
                  DurationTime = 1.0,
                  UseTimescale = false,
                  EaseInTime = 0.06,
                  EaseOutTime = 0.06,
                  CameraOffsets = {
                    PositionX = {
                      CurveId = 600080003,
                      CameraOffsetReferType = 0
                    },
                    PositionZ = {
                      CurveId = 600080004,
                      CameraOffsetReferType = 0
                    },
                    PositionY = {
                      CurveId = 600080005,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                },
                {

                  Type = 804001,
                  Frame = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 6000804001,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 180,
                  SpeedOffset = 180.0,
                  Acceleration = 270.0,
                  RotateFrame = 19,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                },
                {

                  Name = "Attack014",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 8 ] = {
                {

                  AddType = 1,
                  BuffId = 600080008,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 8,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 11 ] = {
                {

                  ChangeAmplitud = -2.0,
                  ChangeTime = 0.2,
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  EntityId = 6000804002,
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
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 4,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.05,
                      StartAmplitude = -2.0,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.2,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.35,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.25,
                      StartFrequency = 7.0,
                      TargetAmplitude = -0.05,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.3,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 2,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 0.1,
                      StartFrequency = 7.0,
                      TargetAmplitude = 0.05,
                      TargetFrequency = 1.0,
                      AmplitudeChangeTime = 0.2,
                      FrequencyChangeTime = 0.15,
                      DurationTime = 0.4,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 11,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 12 ] = {
                {

                  Type = 804002,
                  Frame = 1,
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  EntityId = 600080401,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -0.25,
                  BornOffsetY = 1.5,
                  BornOffsetZ = 1.5,
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
                  FrameTime = 12,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = -20.0,
                  Acceleration = 100.0,
                  MoveFrame = 6,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 32 ] = {
                {

                  Type = 600000020,
                  Frame = 1,
                  FrameTime = 32,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 900 ] = {
                {

                  AddType = 1,
                  BuffId = 600080009,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 900,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
            }
          },
          [ 60008041 ] = {
            TotalFrame = 78,
            ForceFrame = 70,
            SkillType = 0,
            SkillSign = 0,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            SetButtonInfos = {
              {
                templateId = 1007,
                CDtime = 5.0,
                AutoReduceSkillCD = true,
                IgnoreSkillCD = false,
                CoolingNotGetCost = false,
                UseCostType = 0,
                UseCostValue = 1,
                MaxUseCostValue = 1,
                ShowCDMaskColor = "#FFFFFF",
                TriggerLimitTimeMaskColor = "#FFE0AF",
                MaskColor = "#FFFFFF",
                UseCostMode = 5,
                UseParentCost = true,
                ChargeTimes = 0,
                ChargeCdTime = 0.0,
                RecoverCount = 0,
                RecoverCostType = 0,
                ChargeMode = 2,
                RecoverType = 1,
                AutoReduceChargeCD = false,
                UseOverflow = false,
                AlwaysReduceChargeCD = false,
                ReadyEffectPath = "UIEffect/Prefab/UI_SkillPanel_jiuxu.prefab",
                CastEffectPath = "",
                DodgeEffectPath = "",
                SkillIcon = "ZhenshizhilieSkill1",
                BehaviorConfig = 51,
                LayerConfig = 1059
              }
            },
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack002",
                  LayerIndex = 0,
                  StartFrame = 5,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EntityId = 60008000202,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  ChangeAmplitud = 2.0,
                  ChangeTime = 0.25,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 29,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 4 ] = {
                {

                  EventName = "ZhenshizhilieMo1_ATK002_Charge",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 4,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                }
              },
              [ 15 ] = {
                {

                  AddType = 1,
                  BuffId = 600080016,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 20 ] = {
                {

                  AddType = 1,
                  BuffId = 600080013,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 25 ] = {
                {

                  DisableWithoutTarget = false,
                  PauseAnimationMove = false,
                  DurationUpdateTargetFrame = 10,
                  OffsetType = 2,
                  TargetHPositionOffset = 2.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 10,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 25,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      600001
                    },
                  }
                }
              },
              [ 27 ] = {
                {

                  AddType = 2,
                  BuffId = 600080013,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 27,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  ChangeAmplitud = -2.0,
                  ChangeTime = 0.231,
                  FrameTime = 27,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 32,

                }
              },
              [ 28 ] = {
                {

                  EntityId = 600080002002,
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
                  FrameTime = 28,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 600080002001,
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
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 60008000201,
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
                  FrameTime = 29,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = -0.8,
                      StartFrequency = 6.0,
                      TargetAmplitude = -0.3,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.264,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    },
                    {
                      ShakeType = 4,
                      IsNoTimeScale = true,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -1.0,
                      StartFrequency = 2.0,
                      TargetAmplitude = -0.3,
                      TargetFrequency = 2.0,
                      AmplitudeChangeTime = 0.132,
                      FrequencyChangeTime = 0.132,
                      DurationTime = 0.132,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 30,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 70 ] = {
                {

                  Type = 600000020,
                  Frame = 1,
                  FrameTime = 70,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 905 ] = {
                {

                  Direction = 3,
                  CustomX = 0.0,
                  CustomY = 1.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 1.0,
                  Acceleration = 0.0,
                  MoveFrame = 15,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 905,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 908 ] = {
                {

                  IsBingSkill = false,
                  GroupId = 0,
                  DurationTime = 1.5,
                  UseTimescale = true,
                  EaseInTime = 0.033,
                  EaseOutTime = 0.5,
                  CameraOffsets = {
                    PositionZ = {
                      CurveId = 60008007,
                      CameraOffsetReferType = 0
                    },
                    PositionY = {
                      CurveId = 60008009,
                      CameraOffsetReferType = 0
                    },
                    RotationX = {
                      CurveId = 60008008,
                      CameraOffsetReferType = 0
                    }
                  },
                  FrameTime = 908,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 14,

                }
              },
              [ 918 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 0,
                  SpeedOffset = 10.0,
                  Acceleration = -5.0,
                  MoveFrame = 7,
                  InputSpeed = 0.0,
                  MinDistance = 2.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 4,
                  FrameTime = 918,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 931 ] = {
                {

                  Direction = 3,
                  CustomX = 0.0,
                  CustomY = -1.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 4.0,
                  Acceleration = 0.0,
                  MoveFrame = 3,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  CanFlick = false,
                  IgnoreYAxis = false,
                  SkillMoveDone = 5,
                  FrameTime = 931,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 933 ] = {
                {

                  Type = 9008002,
                  Frame = 5,
                  FrameTime = 933,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008042 ] = {
            TotalFrame = 78,
            ForceFrame = 70,
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

                  Name = "Attack003",
                  LayerIndex = 0,
                  StartFrame = 45,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  EventName = "ZhenshizhilieMo1_ATK002_Charge",
                  LifeBindSkill = true,
                  StopDelayFrame = 4,
                  StopFadeDuration = 4,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 180.0,
                  RotateFrame = 29,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 8,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 60008000202,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 77,
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
                  FrameTime = 1,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 20 ] = {
                {

                  Name = "Attack002",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 20,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 60008000201,
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
                  FrameTime = 33,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EntityId = 600080002001,
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
                  FrameTime = 33,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      IsNoTimeScale = false,
                      TimeScaleMinVal = 0.0,
                      Random = 0.0,
                      StartOffset = 0.2,
                      StartAmplitude = -0.6,
                      StartFrequency = 6.0,
                      TargetAmplitude = -0.2,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.264,
                      DurationTime = 0.5,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 34,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 4,

                }
              },
              [ 70 ] = {
                {

                  Type = 600000020,
                  Frame = 1,
                  FrameTime = 70,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
              [ 918 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 0,
                  SpeedOffset = 10.0,
                  Acceleration = -5.0,
                  MoveFrame = 7,
                  InputSpeed = 0.0,
                  MinDistance = 2.5,
                  CanFlick = false,
                  IgnoreYAxis = true,
                  SkillMoveDone = 4,
                  FrameTime = 918,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 7,

                }
              },
              [ 933 ] = {
                {

                  Type = 9008002,
                  Frame = 5,
                  FrameTime = 933,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          },
          [ 60008050 ] = {
            TotalFrame = 9999,
            ForceFrame = 9999,
            SkillBreakSkillFrame = 9999,
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

                  AddType = 1,
                  BuffId = 600080001,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                },
                {

                  EntityId = 600000002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  EventName = "Hack_Start",
                  LifeBindSkill = false,
                  StopDelayFrame = 0,
                  StopFadeDuration = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 15,

                },
                {

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  Type = 805001,
                  Frame = 1,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                },
                {

                  Name = "Attack012loop",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 60008060 ] = {
            TotalFrame = 99999,
            ForceFrame = 99999,
            SkillBreakSkillFrame = 99999,
            ChangeRoleFrame = 1,
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

                  EntityId = 600000002,
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
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                },
                {

                  Name = "Attack012Begin",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 0,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  Name = "Attack012loop",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                },
                {

                  Type = 806001,
                  Frame = 1,
                  FrameTime = 13,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 3,

                }
              },
            }
          }
        }
      },
      SkillSet = {
        UISets = {
          [ 1 ] = {
            ShowId = 1,
            UISetNote = "",
            CoreUIConfig = {
              BindRes = 0,
              Scale = 1.0,
              LocationOffset = { 0.0, 0.0, 0.0 },
              ScreenOffset = { 0.0, 0.0, 0.0 }
            },
            J = {
              Active = false,
              SkillId = 0,

            },
            K = {
              Active = false,
              SkillId = 0,

            },
            L = {
              Active = false,
              SkillId = 0,

            },
            I = {
              Active = false,
              SkillId = 0,

            },
            O = {
              Active = false,
              SkillId = 0,

            },
            R = {
              Active = true,
              SkillId = 60008041,

            },
            F = {
              Active = false,
              SkillId = 0,

            },
            PartnerSkill = {
              Active = false,
              SkillId = 0,

            },          }
        }
      },
      Move = {
        pivot = 1.005143,
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
        ConfigName = "ZhenshizhilieMo1P",
        BindRotation = false,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      CommonBehavior = {
        CommonBehaviors = {
          Partner = {
            ComponentBehaviorName = "CommonPartnerBehavior",
            NewCommonBehaviorParms = {
              [ "进场时间" ] = 0.0,
              [ "退场时间" ] = 0.0,
              [ "退场动作开始帧数" ] = 0.0,
              [ "退场结束时间" ] = 0.8,
              [ "进场magicId" ] = 0.0
            }
          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Part = {
        PartList = {
          {
            Name = "ZhenshizhilieMo1P",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "",
            attackTransformName = "",
            hitTransformName = "",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "ZhenshizhilieMo1P",
                LocalPosition = { 0.0, 1.263, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.3, 0.2, 0.3 },
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
        isTrigger = true
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "ZhenshizhilieMo1P",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "ZhenshizhilieMo1P",
                LocalPosition = { 0.0, 1.263, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.3, 0.2, 0.3 },
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
      Sound = empty}
  },
  [ 6000801301 ] = {
    EntityId = 6000801301,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "Bip001 R Hand",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxBuild01.prefab",
        Model = "FxBuild01",
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000801302 ] = {
    EntityId = 6000801302,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxBuildCross.prefab",
        Model = "FxBuildCross",
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
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 600080031 ] = {
    EntityId = 600080031,
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackBullet.prefab",
        Model = "FxHackBullet",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000801303 ] = {
    EntityId = 6000801303,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxBuild02.prefab",
        Model = "FxBuild02",
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
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000800301 ] = {
    EntityId = 6000800301,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackingCover_1.prefab",
        Model = "FxHackingCover_1",
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
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxHackingCover_Ani.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 6000800101 ] = {
    EntityId = 6000800101,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackArm.prefab",
        Model = "FxHackArm",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxHackArm_Ani.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 6000801101 ] = {
    EntityId = 6000801101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxZhenshizhilieStart.prefab",
        Model = "FxZhenshizhilieStart",
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000802001 ] = {
    EntityId = 6000802001,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxZhenshizhilieEnd.prefab",
        Model = "FxZhenshizhilieEnd",
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
      TimeoutDeath = {
        Frame = 35,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000801201 ] = {
    EntityId = 6000801201,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "Bip001 R Hand",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxBuildIdle.prefab",
        Model = "FxBuildIdle",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = -1,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 600080131 ] = {
    EntityId = 600080131,
    Components = {
      Transform = {
        Prefab = "Effect/Prefab/Scene/Build/FxBuild01Bullet.prefab",
        Model = "FxBuild01Bullet",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 999,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.2,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 10000.0,
        Height = 10000.0,
        Width = 10000.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 1.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        CameraShakes = {
          [ 1 ] = {
            {
              ShakeType = 2,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.0,
              StartFrequency = 0.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 0.0,
              AmplitudeChangeTime = 0.0,
              FrequencyChangeTime = 0.0,
              DurationTime = 0.0,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
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
        Speed = 170.0,
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
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000800102 ] = {
    EntityId = 6000800102,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001 L Hand",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackArmScreen.prefab",
        Model = "FxHackArmScreen",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxHackArmScreen_Ani.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 6000800302 ] = {
    EntityId = 6000800302,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackLine.prefab",
        Model = "FxHackLine",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Hack_Line",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 60008003011 ] = {
    EntityId = 60008003011,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackingCover_2.prefab",
        Model = "FxHackingCover_2",
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
      TimeoutDeath = {
        Frame = 10,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Hack_select",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 600080401 ] = {
    EntityId = 600080401,
    Components = {
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxZhenshizhilieMo1PAtk011M.prefab",
        Model = "FxZhenshizhilieMo1PAtk011M",
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
      TimeoutDeath = {
        Frame = 150,
        RemoveDelayFrame = 15,
        RemoveDelayHideList = {
          "core"
        },
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 2,
        AttackSkillType = 0,
        PreciseDetection = true,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 150,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 0.5,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = true,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          600080005
        },
        SoundsByTarget = {
          "ZhenshizhilieMo1_Atk014_Hit"
        },
        HitGroundCreateEntity = {
          600080402
        },
        CreateAttackEntities = {
          600080402
        },
        CreateHitEntities = {
          {
            EntityId = 6000804004,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedZArmor = 5.0,
          SpeedZArmorAcceleration = -50.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 20.0,
          SpeedZHitFly = 2.5,
          SpeedYAcceleration = -80.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 2.8,
          SpeedZAloft = 2.5,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
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
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 600080001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 600080002,
        AlwaysUpdateTargetPos = true,
        RotationLockInterval = 1.0,
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
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000804001 ] = {
    EntityId = 6000804001,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "Bip001 L Hand",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxZhenshizhilieMo1PAtk01101.prefab",
        Model = "FxZhenshizhilieMo1PAtk01101",
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
      TimeoutDeath = {
        Frame = 12,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxHack_Ani 1.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 6000804002 ] = {
    EntityId = 6000804002,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.15,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { -0.25, 1.5, 1.5 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxZhenshizhilieMo1PAtk01102.prefab",
        Model = "FxZhenshizhilieMo1PAtk01102",
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
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000804003 ] = {
    EntityId = 6000804003,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackBullet.prefab",
        Model = "FxHackBullet",
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
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000804004 ] = {
    EntityId = 6000804004,
    Components = {
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
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxZhenshizhilieMo1PAtk011H.prefab",
        Model = "FxZhenshizhilieMo1PAtk011H",
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
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000804005 ] = {
    EntityId = 6000804005,
    Components = {
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
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk004H.prefab",
        Model = "FxZhenshizhilieMo1Atk004H",
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
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000804006 ] = {
    EntityId = 6000804006,
    Components = {
      Effect = {
        IsHang = true,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackFast.prefab",
        Model = "FxHackFast",
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
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Character/Monster/Zhenshizhilie/Common/Partner/effect/FxHackFast_Ani.controller",
        AnimationConfigID = "",

      }
    }
  },
  [ 600080402 ] = {
    EntityId = 600080402,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
      TimeoutDeath = {
        Frame = 9,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 9,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 1,
        Radius = 1.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = true,
        IntervalFrame = 5,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          600080005
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
          },
          {
            HitType = 2,
            BreakLieDown = true
          },
          {
            HitType = 3,
            BreakLieDown = true
          },
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedZArmor = 1.0,
          SpeedZArmorAcceleration = -10.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedZHitFlyTime = 0.0,
          SpeedYAloft = 2.0,
          SpeedZAloft = 2.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        UsePostProcess = false,
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
        SpeedCurveId = 600080001,
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
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000801401 ] = {
    EntityId = 6000801401,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "WeaponCaseLeft",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "CommonEntity/BuildTest/effect/EffectNew/FxBuildAttach.prefab",
        Model = "FxBuildLine",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000800303 ] = {
    EntityId = 6000800303,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "WeaponCaseLeft",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackLine_1.prefab",
        Model = "FxHackLine",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 600080132 ] = {
    EntityId = 600080132,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Build_Common",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      }
    }
  },
  [ 600080133 ] = {
    EntityId = 600080133,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      },
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Build_Aircraft",
            DelayTime = 0.0,
            LifeBindEntity = false
          }
        },
      }
    }
  },
  [ 600080002001 ] = {
    EntityId = 600080002001,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
      TimeoutDeath = {
        Frame = 10,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 10,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 4.0,
        SectorInnerRadius = 0.2,
        SectorAngle = 120.0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          600080012
        },
        SoundsByTarget = {
          "ZhenshizhilieMo1_ATK002_Hit"
        },
        WwisePTRC = {
          paramName = "ZhenshizhilieMo1_ATK002_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 60008000104,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = false
          },
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 5.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.1,
          SpeedZArmor = 5.0,
          SpeedZArmorAcceleration = -2.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 3,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 2,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.1,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeedCurve = "-1"
          }
        },        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "ZhenshizhilieMo1_ATK002_Shock",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 60008000201 ] = {
    EntityId = 60008000201,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 1.0, 1.0, 1.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk002M.prefab",
        Model = "FxZhenshizhilieMo1Atk002M",
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
      TimeoutDeath = {
        Frame = 75,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60008000202 ] = {
    EntityId = 60008000202,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk002.prefab",
        Model = "FxZhenshizhilieMo1Atk002",
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
      TimeoutDeath = {
        Frame = 26,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 60008000104 ] = {
    EntityId = 60008000104,
    Components = {
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
      Transform = {
        Prefab = "Character/Monster/Zhenshizhilie/ZhenshizhilieMo1/Effect/FxZhenshizhilieMo1Atk001H.prefab",
        Model = "FxZhenshizhilieMo1Atk001H",
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
      TimeoutDeath = {
        Frame = 60,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 600080002002 ] = {
    EntityId = 600080002002,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
      TimeoutDeath = {
        Frame = 10,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 10,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 2,
        Radius = 20000.0,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 4.0,
        SectorInnerRadius = 0.2,
        SectorAngle = 120.0,
        Lenght = 4.0,
        Height = 2.0,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 4.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = false,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTargetBeforeHit = {
          600080014
        },
        SoundsByTarget = {
          "ZhenshizhilieMo1_ATK002_Hit"
        },
        WwisePTRC = {
          paramName = "ZhenshizhilieMo1_ATK002_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 60008000104,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = false
          },
          {
            HitType = 2,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 10.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.2,
          SpeedZArmor = 5.0,
          SpeedZArmorAcceleration = -2.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 2.8,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        PauseFrames = {
          [ 1 ] = {
            IsCanBreak = true,
            PFFrame = 3,
            PFTimeScale = 0.0,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 2,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.1,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeedCurve = "-1"
          }
        },        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "ZhenshizhilieMo1_ATK002_Shock",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 600080002003 ] = {
    EntityId = 600080002003,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Attack = {
        AttackType = 1,
        AttackSkillType = 0,
        PreciseDetection = false,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        Target = 1,
        IngoreDodge = false,
        ImmuneHitMove = false,
        ShapeType = 3,
        Radius = 6.5,
        IsSpread = false,
        FinalRadius = 0.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        SectorRadius = 0.0,
        SectorInnerRadius = 0.0,
        SectorAngle = 0.0,
        Lenght = 0.0,
        Height = 0.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 3.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RepeatType = 1,
        RepeteHitCallBack = false,
        RemoveAfterHit = true,
        CanHitGround = false,
        StopAfterHitGround = false,
        DelayFrameToStop = 0,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 2,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          600080015
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = 5.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedZArmor = 5.0,
          SpeedZArmorAcceleration = -2.0,
          SpeedZArmorTime = 3.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 25.0,
          SpeedZAloft = 2.0,
          SpeedYAccelerationAloft = -30.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
          FlyHitSpeedZArmor = 0.0,
          FlyHitSpeedZArmorAcceleration = 0.0,
          FlyHitSpeedZArmorTime = 0.0,
          FlyHitSpeedYArmor = 0.0,
          FlyHitSpeedYArmorAcceleration = 0.0,
          FlyHitSpeedYArmorTime = 0.0,
          FlyHitSpeedYAloft = 0.0,
          FlyHitSpeedZAloft = 0.0,
          FlyHitSpeedYAccelerationAloft = 0.0,
          FlyHitSpeedYTimeAloft = 0.0,
          FlyHitSpeedZTimeAloft = 0.0
        },        UseCameraShake = true,
        CameraShakes = {
          [ 0 ] = {
            {
              ShakeType = 4,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.15,
              StartFrequency = 3.0,
              TargetAmplitude = 0.3,
              TargetFrequency = 6.0,
              AmplitudeChangeTime = 0.12,
              FrequencyChangeTime = 0.12,
              DurationTime = 0.14,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = 0.6,
              StartFrequency = 8.0,
              TargetAmplitude = 0.3,
              TargetFrequency = 4.0,
              AmplitudeChangeTime = 0.198,
              FrequencyChangeTime = 0.165,
              DurationTime = 0.231,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        PauseFrames = {
          [ 0 ] = {
            IsCanBreak = true,
            PFFrame = 4,
            PFTimeScale = 0.1,
            PFTimeScaleCurve = "-1",
            TargetPFFrame = 3,
            TargetPFTimeScale = 0.0,
            TargetPFTimeScaleCurve = "-1",
            PFMonsterSpeed = 0.0,
            PFMonsterSpeedCurve = "-1",
            PFSceneSpeedCurve = "-1"
          }
        },        UsePostProcess = false,
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
        MoveType = 3,
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
        ConfigName = "BeilubeiteMb1",
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = true,
        IsBindWeapon = false,
        TrackPointAcceleration = 0.0,
        TrackPointMaxSpeed = 0.0,
        TrackPointDeceleration = 0.0,
        TrackPointObstacleDistance = 0.0
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000800103 ] = {
    EntityId = 6000800103,
    Components = {
      Transform = {
        Prefab = "CommonEntity/BuildTest/effect/EffectNew/FxHackZone.prefab",
        Model = "FxHackZone",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Hack_During",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 6000800104 ] = {
    EntityId = 6000800104,
    Components = {
      Transform = {
        Prefab = "CommonEntity/BuildTest/effect/EffectNew/FxHackZoneStart.prefab",
        Model = "FxHackZoneStart",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 6000800304 ] = {
    EntityId = 6000800304,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackLineBlue.prefab",
        Model = "FxHackLine",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Hack_Line",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 6000800305 ] = {
    EntityId = 6000800305,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackLineGold.prefab",
        Model = "FxHackLine",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Hack_Line",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  },
  [ 6000800306 ] = {
    EntityId = 6000800306,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = true,
        BindTransformName = "",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Scene/Hack/FxHackLineRed.prefab",
        Model = "FxHackLine",
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
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Sound = {
        SoundEventList = {
          {
            EventType = 1,
            SoundEvent = "Hack_Line",
            DelayTime = 0.0,
            LifeBindEntity = true
          }
        },
      }
    }
  }
}
