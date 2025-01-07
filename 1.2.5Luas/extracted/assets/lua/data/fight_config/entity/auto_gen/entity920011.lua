Config = Config or {}
Config.Entity920011 = Config.Entity920011 or { }
local empty = { }
Config.Entity920011 = 
{
  [ 920011 ] = {
    EntityId = 920011,
    EntityName = "920011",
    Components = {
      Skill = {
        Skills = {
          [ 92001072 ] = {
            TotalFrame = 165,
            ForceFrame = 165,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack072",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 92001107201,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
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
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 0,
                  EventType = 1,

                }
              },
              [ 165 ] = {
                {

                  EntityId = 920011072001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "Bip001 R Hand",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 23.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = -1.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 165,
                  EventType = 1,

                }
              },
            }
          },
          [ 92001073 ] = {
            TotalFrame = 143,
            ForceFrame = 143,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack073",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 92001107301,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "Bone117",
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
                  FrameTime = 10,
                  EventType = 1,

                }
              },
            }
          }
        }
      },
      Transform = {
        Prefab = "Character/Monster/Beilubeite/BeilubeiteMb1/BeilubeiteMb1.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      Animator = {
        Animator = "Character/Monster/Beilubeite/BeilubeiteMb1/BeilubeiteMb1B.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              Stun = 0.396
            }
          }
        }
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 1,
        NpcTag = 4,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Move = {
        pivot = 1.27,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
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
        ConfigName = "BeilubeiteMb1",
        LogicMoveConfigs = {
          Attack010 = 6,
          Attack001 = 6,
          Attack002 = 6,
          Attack003 = 6,
          Attack004 = 6,
          Attack006 = 6,
          Attack007 = 6,
          Attack008 = 6,
          Attack014 = 6,
          Attack009 = 6,
          Attack013 = 6,
          Attack016 = 6,
          Attack017 = 6,
          Attack015 = 6,
          Attack005 = 2,
          Attack904 = 6,
          Attack906 = 6
        },        BindRotation = false,

      },
      Rotate = {
        Speed = 60
      },
      State = {
        DyingTime = 3.0,
        DeathTime = 1.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 3.733,
        HitTime = {
          [ 1 ] = {
            Time = 1.0,
            ForceTime = 0.6,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 0.967,
            ForceTime = 0.6,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 1.867,
            ForceTime = 0.6,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 1.733,
            ForceTime = 0.6,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.3,
            ForceTime = 0.3,
            FusionChangeTime = 0.3,
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
            Time = 0.6,
            ForceTime = 0.6,
            FusionChangeTime = 0.6,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.1,
            ForceTime = 0.1,
            FusionChangeTime = 0.1,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 2.97,
            ForceTime = 1.782,
            FusionChangeTime = 1.2,
            IgnoreHitTime = 1.2
          }
        },
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 1.2,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "Body",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { 0.0, 0.0, -0.3279693 },
                LocalEuler = { 0.0, 270.0, 270.0 },
                LocalScale = { 1.4000001, 1.0, 1.4000001 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          },
          {
            Name = "Head",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.12, -0.027, 0.0 },
                LocalEuler = { 0.0, 0.0, 102.55999 },
                LocalScale = { 0.572820544, 0.286410272, 0.572820544 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          },
          {
            Name = "Collision",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "BeilubeiteMb1",
                LocalPosition = { 0.0, 1.174, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 1.4, 1.2829, 1.4 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 2,
            FollowBone = "Location"
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
      Hit = {
        GravityAcceleration = -0.2,
        ReboundCoefficient = 0.3,
        ReboundTimes = 1.0,
        MinSpeed = 5.0,
        SpeedZCoefficient = 0.0,
        HitFlyHeight = 0.1
      },
      Part = {
        PartList = {
          {
            Name = "Body",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HitCase",
            attackTransformName = "HitCase",
            hitTransformName = "HitCase",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { 0.0, 0.0, -0.3279693 },
                LocalEuler = { 0.0, 270.0, 270.0 },
                LocalScale = { 1.4000001, 1.0, 1.4000001 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          },
          {
            Name = "Head",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 14000.0
            },
            PartType = 0,
            PartWeakType = 0,
            WeakTrasnforms = {
              "BeilubeiteMb1_face",
              "BeilubeiteMb1_hair"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.12, -0.027, 0.0 },
                LocalEuler = { 0.0, 0.0, 102.55999 },
                LocalScale = { 0.572820544, 0.286410272, 0.572820544 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          }
        },

      },
      Buff = empty,
      Combination = {
        Animator = "Character/Monster/Beilubeite/BeilubeiteMb1/BeilubeiteMb1B.controller",
        AnimatorName = "BeilubeiteMb1B"
      },
      Attributes = {
        DefaultName = "离歌",
        DefaultAttrID = 92001,
      },
      ElementState = {
        ElementType = 2,
        ElementMaxAccumulateDict = {
          Gold = 200
        }
      },
      Ik = {
        shakeLeftFrontId = 9200105,
        shakeLeftBackId = 9200109,
        shakeRightFrontId = 9200106,
        shakeRightBackId = 9200107,
        shakeDistanceRatio = 1.0,

      },
      FindPath = empty,
      Condition = {
        ConditionParamsList = {
          {
            Interval = 1.0,
            Count = -1,
            ConditionList = {
              {

                Count = 10,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountInterval = 10.0,
                HitDuration = 4.0,
                ConditionType = 2
              },
              {

                MinLife = 50.0,
                MaxLife = 100.0,
                ConditionType = 1
              }
            },
            MeetConditionEventList = {
              {

                Duration = 1.0,
                MeetConditionEventType = 2
              }
            },
          },
          {
            Interval = 1.0,
            Count = -1,
            ConditionList = {
              {

                Count = 8,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountInterval = 10.0,
                HitDuration = 3.0,
                ConditionType = 2
              },
              {

                MinLife = 0.0,
                MaxLife = 50.0,
                ConditionType = 1
              }
            },
            MeetConditionEventList = {
              {

                Duration = 1.0,
                MeetConditionEventType = 2
              }
            },
          }
        },
      }
    }
  },
  [ 92001107201 ] = {
    EntityId = 92001107201,
    EntityName = "92001107201",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 R Hand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiAtk072Wp.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92001107202 ] = {
    EntityId = 92001107202,
    EntityName = "92001107202",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 1.0, 1.0, 1.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiAtk072H.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 31,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 920011072001 ] = {
    EntityId = 920011072001,
    EntityName = "920011072001",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "Bip001 R Hand",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiAtk072Dandao.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 151,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 151,
        ShapeType = 2,
        Radius = 1.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 1.0,
        Height = 1.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = -2.0,
        Repetition = false,
        IntervalFrame = 1,
        RemoveAfterHit = true,
        CanHitGround = true,
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
        MagicsBySelf = {
          92001004
        },
        MagicsByTarget = {
          92001001,
          92001002,
          92001003,
          92001004
        },
        HitGroundCreateEntity = {
          9200107202,
          92002040001
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 30.0,
          SpeedZHitFly = 5.0,
          SpeedYAcceleration = -80.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
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
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 4,
        LineraSpeedType = 1,
        Speed = 40.0,
        SpeedCurveId = 920172001,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 920172002,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.5,
        RotationLockDelay = 0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92001107301 ] = {
    EntityId = 92001107301,
    EntityName = "92001107301",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Baxilikesi/BaxilikesiMb1Low/Effect/FxBaxilikesiAtk073Wp.prefab",
        isClone = false,
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      TimeoutDeath = {
        Frame = 84,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Effect = {
        IsBind = true,
        BindTransformName = "Bip001 Prop1",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  }
}
