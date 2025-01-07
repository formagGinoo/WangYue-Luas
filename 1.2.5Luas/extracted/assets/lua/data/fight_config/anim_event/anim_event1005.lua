Config = Config or {}
Config.AnimEvent1005 = Config.AnimEvent1005 or { }
Config.AnimEvent1005.AnimEvents = 
{
  [ 0 ] = {
    Walk = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Sprint = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Run = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Stand2 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Stand1 = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack001 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack002 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack003 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack004 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack005 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack011 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack012 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack010 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    GlideFront = {},
    GlideLeft = {},
    GlideRight = {},
    GlideStart = {},
    Attack050 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    JumpUp = {
      [ 0 ] = {
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0
        }
      },
    },
    JumpUpDoubleLeft = {
      [ 0 ] = {
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0
        }
      },
    },
    JumpUpDoubleRight = {
      [ 0 ] = {
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0
        }
      },
    },
    JumpUpRunLeft = {
      [ 0 ] = {
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0
        }
      },
    },
    JumpUpRunRight = {
      [ 0 ] = {
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0
        }
      },
    },
    Attack080 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack081 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    },
    Attack082 = {
      [ 0 ] = {
        {

          visible = true,
          eventType = 2,
          frameEvent = 0
        }
      },
    }
  }
}
Config.AnimEvent1005.AnimFusions = 
{
  [ 0 ] = {
    GlideFront = {
      GlideLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Gliding = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideStart = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    },
    GlideLeft = {
      GlideRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideStart = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Gliding = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideFront = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    },
    GlideRight = {
      GlideLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideStart = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Gliding = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideFront = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    },
    GlideStart = {
      GlideLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Gliding = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      GlideFront = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    }
  }
}
Config.AnimEvent1005.AnimFrames = 
{
  ClimbingJump = 29,
  ClimbingJumpStart = 28,
  ClimbingRunEnd = 18,
  ClimbingRunLoop = 33,
  ClimbingRunStart = 16,
  InjuredEndLeft = 34,
  InjuredEndRight = 34,
  InjuredStand = 61,
  InjuredWalk = 31,
  JumpLandHard = 39,
  JumpLandRollRight = 47,
  JumpUpSprintLeft = 28,
  JumpUpSprintRight = 28,
  MenuClose = 35,
  MenuIdle = 81,
  MenuOpen = 31,
  PartnerAimEnd = 31,
  PartnerAiming = 181,
  PartnerAiming_body = 181,
  PartnerAiming_thigh = 181,
  PartnerAimShoot = 31,
  PartnerAimStart = 7,
  PartnerCtrFront = 46,
  PartnerCtrlBack = 46,
  PartnerCtrlEnd = 36,
  PartnerCtrlLeft = 46,
  PartnerCtrlLoop = 181,
  PartnerCtrlRight = 46,
  PartnerCtrlStart = 46,
  RunStartLandLeft = 27,
  RunStartLandRight = 27,
  SprintStartLandLeft = 17,
  SprintStartLandRight = 17,
  StandChange = 70,
  Stand1 = 61,
  Attack001 = 78,
  Attack002 = 84,
  Attack003 = 96,
  Attack004 = 107,
  Attack005 = 135,
  Attack010 = 89,
  Attack011 = 11,
  Attack012 = 73,
  Attack080 = 61,
  Attack081 = 12,
  Attack082 = 76,
  Stand2 = 61,
  Move02 = 67,
  Run = 25,
  Sprint = 15,
  Walk = 37,
  Climb = 41,
  ClimbingDown = 33,
  ClimbingLeft = 29,
  ClimbingRight = 29,
  ClimbingStand = 61,
  ClimbingUp = 33,
  GlideFront = 46,
  GlideLeft = 46,
  GlideRight = 46,
  GlideStart = 141,
  Gliding = 46,
  HitDown = 34,
  HitFlyFall = 16,
  HitFlyHover = 16,
  HitFlyLand = 19,
  HitFlyUp = 10,
  LeftHeavyHit = 33,
  LeftSlightHit = 23,
  Lie = 10,
  Move01 = 59,
  RightSlightHit = 33,
  RightHeavyHit = 33,
  RunEndLeft = 36,
  RunEndRight = 36,
  Swim = 35,
  SwimDeath = 76,
  SwimFast = 27,
  SwimFloat = 31,
  SwimStand = 39,
  Stun = 61,
  StandUp = 46,
  WalkEndLeft = 23,
  WalkEndRight = 23,
  JumpLand = 24,
  JumpLandRollLeft = 69,
  JumpDownLeft = 21,
  JumpDownRight = 21,
  JumpUp = 24,
  JumpUpDoubleLeft = 24,
  JumpUpDoubleRight = 24,
  JumpUpRunLeft = 21,
  JumpUpRunRight = 21,
  SprintEndLeft = 46,
  SprintEndRight = 46,
  Attack050 = 161,
  Schayao_end = 38,
  Schayao_in = 83,
  Schayao_loop = 61,
  Yzhuanshen = 44,
  Zzhuanshen = 44,
  Baoxiong_end = 26,
  Baoxiong_in = 32,
  Baoxiong_Loop = 61,
  Chayao_end = 21,
  Chayao_in = 21,
  Chayao_Loop = 61,
  Stanshou_end = 21,
  Stanshou_in = 21,
  Stanshou_Loop = 61
}
Config.AnimEvent1005.LoopingAnim = 
{
  ClimbingRunLoop = true,
  InjuredStand = true,
  InjuredWalk = true,
  MenuIdle = true,
  PartnerAiming = true,
  Stand1 = true,
  Stand2 = true,
  Run = true,
  Sprint = true,
  Walk = true,
  ClimbingDown = true,
  ClimbingLeft = true,
  ClimbingRight = true,
  ClimbingStand = true,
  ClimbingUp = true,
  GlideFront = true,
  GlideLeft = true,
  GlideRight = true,
  Gliding = true,
  Lie = true,
  Swim = true,
  SwimFast = true,
  SwimStand = true,
  Stun = true,
  WalkEndLeft = true,
  WalkEndRight = true,
  JumpDownLeft = true,
  JumpDownRight = true
}
Config.AnimEvent1005.State2AnimMap = 
{}
