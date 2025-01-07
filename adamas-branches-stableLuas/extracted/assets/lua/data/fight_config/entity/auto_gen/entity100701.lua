Config = Config or {}
Config.Entity100701 = Config.Entity100701 or { }
local empty = { }
Config.Entity100701 = 
{
  [ 100701 ] = {
    EntityId = 100701,
    Components = {
      Transform = {
        Prefab = "Equip/Weapon/Fight/Umbrella/UmbrellaW5M01/UmbrellaW5M01.prefab",
        Model = "UmbrellaW5M01",
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
      Behavior = {
        Behaviors = {
          "100701"
        },
      },
      Skill = {
        Skills = {
          [ 100701011 ] = {
            TotalFrame = 30,
            ForceFrame = 30,
            SkillType = 0,
            SkillSign = 1,
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

                },
                {

                  EntityId = 100701011001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = -1,
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

                  EntityId = 10070101101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 255,
                  CreateEntityType = 1,
                  IsInherit = false,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.1,
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
              [ 10 ] = {
                {

                  AddType = 1,
                  BuffId = 10070101,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 10,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 9,

                }
              },
              [ 15 ] = {
                {

                  EntityId = 10070101103,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = -1,
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
                  FrameTime = 15,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 1,

                }
              },
              [ 70 ] = {
                {

                  Name = "Attack011Loop",
                  LayerIndex = 0,
                  StartFrame = 0,
                  FrameTime = 70,
                  IsSplitFrame = false,
                  SplitFrame = 0.0,
                  EventType = 2,

                }
              },
            }
          },
          [ 100701012 ] = {
            TotalFrame = 15,
            ForceFrame = 15,
            SkillType = 0,
            SkillSign = 1,
            IsLanding = false,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  EntityId = 10070101103,
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

                  Name = "Attack011Loop",
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
      Tag = {
        Tag = 2,
        NpcTag = 1,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Buff = empty,
      Time = {
        DefalutTimeScale = 1.0
      },
      Animator = {
        Animator = "Equip/Weapon/Fight/Umbrella/UmbrellaW5M01/UmbrellaW5M01.controller",
        AnimationConfigID = "100701",

      },
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,

      }
    }
  },
  [ 10070101101 ] = {
    EntityId = 10070101101,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 99999.0,
        BindRotationTime = 0.0,
        BindTransformName = "Point026",
        IsBindWeapon = false,
        WeaponBindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female1725/ZhuishiR31M11/Common/Effect/FxZhuishiR31M11Atk011.prefab",
        Model = "FxZhuishiR31M11Atk011",
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
      TimeoutDeath = {
        Frame = 15,
        RemoveDelayFrame = 0,
      }
    }
  },
  [ 100701011001 ] = {
    EntityId = 100701011001,
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
        Frame = 99999,
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
        DurationFrame = 99999,
        Target = 1,
        IngoreDodge = false,
        ShapeType = 3,
        Radius = 2.0,
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
        Height = 2.0,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = -0.4,
        OffsetZ = 0.0,
        Repetition = true,
        IntervalFrame = 4,
        RepeatType = 1,
        RepeteHitCallBack = true,
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
          10070102
        },
        SoundsByTarget = {
          "ZhuishiR31M11_Atk011_Hit"
        },
        WwisePTRC = {
          paramName = "XumuR31M11_Atk001_Hit",
          value = 100.0,
          time = 0.0
        },        CreateHitEntities = {
          {
            EntityId = 10070101102,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 2,
            BreakLieDown = true
          },
          {
            HitType = 1,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          BlowSpeed = 10.0,
          SpeedZ = -1.5,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.15,
          SpeedZArmor = -4.0,
          SpeedZArmorAcceleration = 10.0,
          SpeedZArmorTime = 0.1,
          SpeedY = 22.0,
          SpeedZHitFly = 3.0,
          SpeedYAcceleration = -80.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 1.5,
          SpeedZAloft = 1.0,
          SpeedYAccelerationAloft = 0.0,
          SpeedYAccelerationTimeAloft = 0.0,
          FlyHitSpeedZ = 0.0,
          FlyHitSpeedZAcceleration = 0.0,
          FlyHitSpeedZTime = 0.0,
          FlyHitSpeedY = 0.0,
          FlyHitSpeedYAcceleration = 0.0,
          FlyHitSpeedYTime = 0.0,
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
              StartAmplitude = -0.15,
              StartFrequency = 5.0,
              TargetAmplitude = -0.05,
              TargetFrequency = 3.0,
              AmplitudeChangeTime = 0.2,
              FrequencyChangeTime = 0.2,
              DurationTime = 0.2,
              Sign = 0.0,
              DistanceDampingId = 0.0
            },
            {
              ShakeType = 3,
              IsNoTimeScale = false,
              TimeScaleMinVal = 0.0,
              Random = 0.0,
              StartOffset = 0.0,
              StartAmplitude = -0.08,
              StartFrequency = 5.0,
              TargetAmplitude = 0.0,
              TargetFrequency = 3.0,
              AmplitudeChangeTime = 0.2,
              FrequencyChangeTime = 0.2,
              DurationTime = 0.2,
              Sign = 0.0,
              DistanceDampingId = 0.0
            }
          },
        },
        ShakeId = 2102,
        CalcNearShakeBone = true,
        BoneEffectPos = { -0.75, 0.4, 0.5 },
        ShakeDir = 2,
        ShakeStrenRatio = 0.8,
        HavePauseFrame = false,
        PFTime = 0.03,
        UsePostProcess = false,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 10070101102 ] = {
    EntityId = 10070101102,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 0.2,
        BindRotationTime = 0.0,
        BindTransformName = "HitCase",
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female1725/ZhuishiR31M11/Common/Effect/FxZhuishiR31M11Atk011H.prefab",
        Model = "FxZhuishiR31M11Atk011H",
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
      }
    }
  },
  [ 10070101103 ] = {
    EntityId = 10070101103,
    Components = {
      Effect = {
        IsHang = false,
        IsBind = false,
        BindPositionTime = 99999.0,
        BindRotationTime = 0.0,
        BindTransformName = "Point026",
        IsBindWeapon = false,
        WeaponBindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Role/Female1725/ZhuishiR31M11/Common/Effect/FxZhuishiR31M11Atk011End.prefab",
        Model = "FxZhuishiR31M11Atk011End",
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
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      }
    }
  }
}
