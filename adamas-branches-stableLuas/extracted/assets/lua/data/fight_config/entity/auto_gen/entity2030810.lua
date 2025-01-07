Config = Config or {}
Config.Entity2030810 = Config.Entity2030810 or { }
local empty = { }
Config.Entity2030810 = 
{
  [ 2030810 ] = {
    EntityId = 2030810,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Gasholder/Effect/FxGasholder01Loop.prefab",
        Model = "FxGasholder01Loop",
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
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
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
      State = {
        DyingTime = 0.0,
        DeathTime = 0.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 5 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 6 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 71 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 73 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 75 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 76 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 20 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          },
          [ 21 ] = {
            Time = 0.0,
            ForceTime = 0.0,
            FusionChangeTime = 999.0,
            IgnoreHitTime = 0.0
          }
        },
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Animator = {
        Animator = "CommonEntity/Gasholder/Animation/FxGasholder01LoopAni.controller",
        AnimationConfigID = "",

      }
    }
  }
}
