Config = Config or {}
Config.AnimEvent1010 = Config.AnimEvent1010 or { }
Config.AnimEvent1010.AnimEvents = 
{
  [ 0 ] = {
    ClimbJump = {
      [ 0 ] = {
        {

          soundEvent = "ClimbStart",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbRun = {
      [ 0 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
      [ 9 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 9,
          eventName = "播放音效"
        }
      },
    },
    ClimbRunStart = {
      [ 0 ] = {
        {

          soundEvent = "ClimbStart",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbRunEnd = {
      [ 0 ] = {
        {

          soundEvent = "ClimbEnd",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    Run = {
      [ 9 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 9,
          eventName = "播放地表音效"
        }
      },
      [ 19 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 19,
          eventName = "播放地表音效"
        }
      },
    },
    Climbing = {
      [ 0 ] = {
        {

          soundEvent = "Climb",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbRunOver = {
      [ 0 ] = {
        {

          soundEvent = "ClimbEnd",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbJumpOver = {
      [ 0 ] = {
        {

          soundEvent = "ClimbEnd",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbOver = {
      [ 0 ] = {
        {

          soundEvent = "ClimbEnd",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbStart1 = {
      [ 0 ] = {
        {

          soundEvent = "ClimbStart",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ClimbStart2 = {
      [ 0 ] = {
        {

          soundEvent = "ClimbStart",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    Gliding = {},
    GlideFront = {},
    GlideStart = {
      [ 0 ] = {
        {

          soundEvent = "GlideStart",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    GlideLeft = {},
    GlideRight = {},
    Stun = {},
    RightHeavyHit = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        }
      },
    },
    RightSlightHit = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        }
      },
    },
    LeftHeavyHit = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        }
      },
    },
    LeftSlightHit = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        }
      },
    },
    StandUp = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    Lie = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    HitFlyLand = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    JumpLandRollRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 0,
          eventName = "播放地表音效"
        }
      },
    },
    JumpLandRollLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 2 ] = {
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 2,
          eventName = "播放地表音效"
        }
      },
    },
    SwimStand = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    SwimFast = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    Swim = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    JumpLandHard = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 2 ] = {
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 2,
          eventName = "播放地表音效"
        }
      },
    },
    JumpLand = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 2 ] = {
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 2,
          eventName = "播放地表音效"
        }
      },
    },
    HitFlyHover = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    HitFlyFall = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    HitFlyUp = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    JumpDownRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    JumpDownLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    JumpUpDoubleRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
    },
    JumpUpDoubleLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
    },
    JumpUpSprintRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
      [ 1 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 1,
          eventName = "播放地表音效"
        }
      },
    },
    JumpUpSprintLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
      [ 1 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 1,
          eventName = "播放地表音效"
        }
      },
    },
    JumpUpRunRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
      [ 1 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 1,
          eventName = "播放地表音效"
        }
      },
    },
    JumpUpRunLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
      [ 1 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 1,
          eventName = "播放地表音效"
        }
      },
    },
    JumpUp = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          durationFrame = 20,
          ringCount = 20,
          eventType = 5,
          frameEvent = 0,
          eventName = "跳跃闪避事件"
        }
      },
      [ 1 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 1,
          eventName = "播放地表音效"
        }
      },
    },
    Move01 = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    SprintStartLandRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 0,
          eventName = "播放地表音效"
        }
      },
      [ 5 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 5,
          eventName = "播放地表音效"
        }
      },
      [ 12 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 12,
          eventName = "播放地表音效"
        }
      },
    },
    SprintStartLandLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 0,
          eventName = "播放地表音效"
        }
      },
      [ 5 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 5,
          eventName = "播放地表音效"
        }
      },
      [ 12 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 12,
          eventName = "播放地表音效"
        }
      },
    },
    SprintEndRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 0,
          eventName = "播放地表音效"
        }
      },
      [ 8 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 8,
          eventName = "播放地表音效"
        }
      },
    },
    SprintEndLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        },
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 0,
          eventName = "播放地表音效"
        }
      },
      [ 8 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 8,
          eventName = "播放地表音效"
        }
      },
    },
    Sprint = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 6 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 6,
          eventName = "播放地表音效"
        }
      },
      [ 15 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 15,
          eventName = "播放地表音效"
        }
      },
    },
    RunStartLandRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 2 ] = {
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 2,
          eventName = "播放地表音效"
        }
      },
      [ 12 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 12,
          eventName = "播放地表音效"
        }
      },
    },
    RunStartLandLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 2 ] = {
        {

          soundEvent = "LandFoot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 2,
          eventName = "播放地表音效"
        }
      },
      [ 12 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 12,
          eventName = "播放地表音效"
        }
      },
    },
    RunEndRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 5 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 5,
          eventName = "播放地表音效"
        }
      },
      [ 14 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 14,
          eventName = "播放地表音效"
        }
      },
    },
    RunEndLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
      [ 5 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 5,
          eventName = "播放地表音效"
        }
      },
      [ 14 ] = {
        {

          soundEvent = "Foot_Switch",
          lifeBindAnimClip = true,
          eventType = 4,
          frameEvent = 14,
          eventName = "播放地表音效"
        }
      },
    },
    WalkEndRight = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    WalkEndLeft = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    },
    Walk = {
      [ 0 ] = {
        {

          visible = false,
          eventType = 1,
          frameEvent = 0,
          eventName = "左武器显示"
        },
        {

          visible = false,
          eventType = 2,
          frameEvent = 0,
          eventName = "右武器显示"
        }
      },
    }
  }
}
Config.AnimEvent1010.AnimFusions = 
{
  [ 0 ] = {
    ClimbJump = {},
    ClimbRun = {},
    ClimbRunStart = {},
    ClimbRunEnd = {},
    Run = {},
    Climbing = {},
    ClimbRunOver = {},
    ClimbJumpOver = {},
    ClimbOver = {},
    ClimbStart1 = {},
    ClimbStart2 = {},
    Gliding = {
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
      GlideFront = {
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
    Stun = {
      Stand1 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    },
    RightHeavyHit = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 17,
          fusionFrame = 6
        },
        {
          fromStartFrame = 45,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand1 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stun = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    RightSlightHit = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand1 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stun = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    LeftHeavyHit = {
      Run = {
        {
          fromStartFrame = 18,
          toStartFrame = 7,
          fusionFrame = 6
        },
        {
          fromStartFrame = 45,
          toStartFrame = 13,
          fusionFrame = 6
        }
      },
      Stand1 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stun = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    LeftSlightHit = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 7,
          fusionFrame = 6
        },
        {
          fromStartFrame = 18,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand1 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Stun = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    StandUp = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 8,
          fusionFrame = 6
        },
        {
          fromStartFrame = 15,
          toStartFrame = 10,
          fusionFrame = 6
        }
      },
    },
    Lie = {
      StandUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
    },
    HitFlyLand = {
      Lie = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
    },
    JumpLandRollRight = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 3
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Climb = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 5,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    JumpLandRollLeft = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 18,
          fusionFrame = 9
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Climb = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    SwimStand = {
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimFast = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    },
    SwimFast = {
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 15
        }
      },
      SwimDeath = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 24
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Climb = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    Swim = {
      SwimDeath = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimFast = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 15
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Climb = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    JumpLandHard = {
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 21
        },
        {
          fromStartFrame = 12,
          toStartFrame = 4,
          fusionFrame = 21
        },
        {
          fromStartFrame = 21,
          toStartFrame = 4,
          fusionFrame = 9
        },
        {
          fromStartFrame = 30,
          toStartFrame = 6,
          fusionFrame = 9
        },
        {
          fromStartFrame = 33,
          toStartFrame = 9,
          fusionFrame = 9
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 12,
          toStartFrame = 11,
          fusionFrame = 6
        },
        {
          fromStartFrame = 21,
          toStartFrame = 11,
          fusionFrame = 6
        },
        {
          fromStartFrame = 30,
          toStartFrame = 11,
          fusionFrame = 6
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    JumpLand = {
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 15
        },
        {
          fromStartFrame = 3,
          toStartFrame = 11,
          fusionFrame = 21
        },
        {
          fromStartFrame = 15,
          toStartFrame = 11,
          fusionFrame = 9
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 3,
          toStartFrame = 11,
          fusionFrame = 6
        },
        {
          fromStartFrame = 12,
          toStartFrame = 14,
          fusionFrame = 6
        },
        {
          fromStartFrame = 16,
          toStartFrame = 3,
          fusionFrame = 6
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    HitFlyHover = {
      HitFlyLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    HitFlyFall = {
      HitFlyLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      HitFlyHover = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    HitFlyUp = {
      HitFlyFall = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      HitFlyHover = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpDownRight = {
      JumpLandHard = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpDownLeft = {
      JumpLandHard = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpUpDoubleRight = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 66
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 33
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 15
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      RunStartLandLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      SprintStartLandLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpUpDoubleLeft = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 66
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 33
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 15
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      RunStartLandRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      SprintStartLandRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 16,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpUpSprintRight = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SprintStartLandRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SprintStartLandLeft = {
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpUpDoubleRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpDoubleLeft = {
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpUpSprintLeft = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SprintStartLandLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SprintStartLandRight = {
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpUpDoubleLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpDoubleRight = {
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    JumpUpRunRight = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpUpDoubleLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      JumpUpDoubleRight = {
        {
          fromStartFrame = 9,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      RunStartLandLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        }
      },
    },
    JumpUpRunLeft = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpUpDoubleRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      JumpUpDoubleLeft = {
        {
          fromStartFrame = 9,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      RunStartLandRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        }
      },
    },
    JumpUp = {
      JumpLand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 8,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      RunStartLandRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 8,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpDoubleLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        },
        {
          fromStartFrame = 8,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
    },
    Move01 = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 6
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 9
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Sprint = {
        {
          fromStartFrame = 0,
          toStartFrame = 4,
          fusionFrame = 4
        },
        {
          fromStartFrame = 1,
          toStartFrame = 7,
          fusionFrame = 4
        },
        {
          fromStartFrame = 2,
          toStartFrame = 7,
          fusionFrame = 4
        },
        {
          fromStartFrame = 3,
          toStartFrame = 8,
          fusionFrame = 4
        },
        {
          fromStartFrame = 4,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 5,
          toStartFrame = 10,
          fusionFrame = 4
        },
        {
          fromStartFrame = 6,
          toStartFrame = 10,
          fusionFrame = 4
        },
        {
          fromStartFrame = 7,
          toStartFrame = 10,
          fusionFrame = 4
        },
        {
          fromStartFrame = 8,
          toStartFrame = 11,
          fusionFrame = 4
        },
        {
          fromStartFrame = 9,
          toStartFrame = 12,
          fusionFrame = 4
        },
        {
          fromStartFrame = 10,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 11,
          toStartFrame = 0,
          fusionFrame = 4
        },
        {
          fromStartFrame = 12,
          toStartFrame = 1,
          fusionFrame = 4
        },
        {
          fromStartFrame = 13,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 14,
          toStartFrame = 14,
          fusionFrame = 4
        },
        {
          fromStartFrame = 15,
          toStartFrame = 15,
          fusionFrame = 4
        },
        {
          fromStartFrame = 16,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 17,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 18,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 19,
          toStartFrame = 8,
          fusionFrame = 4
        },
        {
          fromStartFrame = 20,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 21,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 22,
          toStartFrame = 7,
          fusionFrame = 4
        },
        {
          fromStartFrame = 23,
          toStartFrame = 7,
          fusionFrame = 4
        },
        {
          fromStartFrame = 24,
          toStartFrame = 8,
          fusionFrame = 4
        },
        {
          fromStartFrame = 25,
          toStartFrame = 8,
          fusionFrame = 4
        },
        {
          fromStartFrame = 26,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 27,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 28,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 29,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 30,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 31,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 32,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 33,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 34,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 35,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 36,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 37,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 38,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 39,
          toStartFrame = 10,
          fusionFrame = 4
        },
        {
          fromStartFrame = 40,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 41,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 42,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 43,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 44,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 45,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 46,
          toStartFrame = 9,
          fusionFrame = 4
        },
        {
          fromStartFrame = 47,
          toStartFrame = 16,
          fusionFrame = 5
        },
        {
          fromStartFrame = 48,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 49,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 50,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 51,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 52,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 53,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 54,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 55,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 56,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 57,
          toStartFrame = 16,
          fusionFrame = 6
        },
        {
          fromStartFrame = 58,
          toStartFrame = 16,
          fusionFrame = 5
        },
        {
          fromStartFrame = 59,
          toStartFrame = 16,
          fusionFrame = 4
        },
        {
          fromStartFrame = 60,
          toStartFrame = 16,
          fusionFrame = 2
        },
        {
          fromStartFrame = 61,
          toStartFrame = 16,
          fusionFrame = 2
        },
        {
          fromStartFrame = 62,
          toStartFrame = 0,
          fusionFrame = 1
        }
      },
    },
    SprintStartLandRight = {
      Sprint = {
        {
          fromStartFrame = 0,
          toStartFrame = 15,
          fusionFrame = 3
        }
      },
      SprintEndRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 4,
          fusionFrame = 4
        },
        {
          fromStartFrame = 3,
          toStartFrame = 3,
          fusionFrame = 2
        },
        {
          fromStartFrame = 10,
          toStartFrame = 3,
          fusionFrame = 6
        },
        {
          fromStartFrame = 15,
          toStartFrame = 6,
          fusionFrame = 6
        }
      },
      SprintEndLeft = {
        {
          fromStartFrame = 6,
          toStartFrame = 6,
          fusionFrame = 6
        }
      },
      JumpUpSprintRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpSprintLeft = {
        {
          fromStartFrame = 3,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    SprintStartLandLeft = {
      Sprint = {
        {
          fromStartFrame = 0,
          toStartFrame = 7,
          fusionFrame = 3
        }
      },
      SprintEndLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 4,
          fusionFrame = 4
        },
        {
          fromStartFrame = 3,
          toStartFrame = 3,
          fusionFrame = 2
        },
        {
          fromStartFrame = 10,
          toStartFrame = 3,
          fusionFrame = 6
        },
        {
          fromStartFrame = 15,
          toStartFrame = 6,
          fusionFrame = 6
        }
      },
      SprintEndRight = {
        {
          fromStartFrame = 6,
          toStartFrame = 6,
          fusionFrame = 6
        }
      },
      JumpUpSprintLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpSprintRight = {
        {
          fromStartFrame = 3,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    SprintEndRight = {
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 36,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 3,
          toStartFrame = 0,
          fusionFrame = 2
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 7,
          toStartFrame = 0,
          fusionFrame = 5
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 7
        },
        {
          fromStartFrame = 14,
          toStartFrame = 0,
          fusionFrame = 4
        },
        {
          fromStartFrame = 19,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 9
        },
        {
          fromStartFrame = 2,
          toStartFrame = 15,
          fusionFrame = 9
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 9
        },
        {
          fromStartFrame = 25,
          toStartFrame = 1,
          fusionFrame = 9
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 15
        },
        {
          fromStartFrame = 3,
          toStartFrame = 15,
          fusionFrame = 15
        },
        {
          fromStartFrame = 10,
          toStartFrame = 20,
          fusionFrame = 15
        },
        {
          fromStartFrame = 20,
          toStartFrame = 26,
          fusionFrame = 15
        },
        {
          fromStartFrame = 30,
          toStartFrame = 33,
          fusionFrame = 15
        },
        {
          fromStartFrame = 39,
          toStartFrame = 35,
          fusionFrame = 15
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    SprintEndLeft = {
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 36,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 3,
          toStartFrame = 0,
          fusionFrame = 2
        },
        {
          fromStartFrame = 5,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 7,
          toStartFrame = 0,
          fusionFrame = 5
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 7
        },
        {
          fromStartFrame = 14,
          toStartFrame = 0,
          fusionFrame = 4
        },
        {
          fromStartFrame = 19,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        },
        {
          fromStartFrame = 2,
          toStartFrame = 5,
          fusionFrame = 9
        },
        {
          fromStartFrame = 10,
          toStartFrame = 11,
          fusionFrame = 9
        },
        {
          fromStartFrame = 25,
          toStartFrame = 12,
          fusionFrame = 9
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 30,
          fusionFrame = 15
        },
        {
          fromStartFrame = 3,
          toStartFrame = 35,
          fusionFrame = 15
        },
        {
          fromStartFrame = 10,
          toStartFrame = 0,
          fusionFrame = 15
        },
        {
          fromStartFrame = 20,
          toStartFrame = 10,
          fusionFrame = 15
        },
        {
          fromStartFrame = 30,
          toStartFrame = 15,
          fusionFrame = 15
        },
        {
          fromStartFrame = 35,
          toStartFrame = 33,
          fusionFrame = 15
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    Sprint = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 4,
          fusionFrame = 12
        },
        {
          fromStartFrame = 1,
          toStartFrame = 6,
          fusionFrame = 12
        },
        {
          fromStartFrame = 2,
          toStartFrame = 8,
          fusionFrame = 12
        },
        {
          fromStartFrame = 4,
          toStartFrame = 9,
          fusionFrame = 12
        },
        {
          fromStartFrame = 7,
          toStartFrame = 13,
          fusionFrame = 12
        },
        {
          fromStartFrame = 9,
          toStartFrame = 17,
          fusionFrame = 12
        },
        {
          fromStartFrame = 11,
          toStartFrame = 20,
          fusionFrame = 12
        },
        {
          fromStartFrame = 14,
          toStartFrame = 3,
          fusionFrame = 12
        }
      },
      SprintEndLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 3,
          fusionFrame = 6
        },
        {
          fromStartFrame = 12,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 14,
          toStartFrame = 3,
          fusionFrame = 4
        }
      },
      SprintEndRight = {
        {
          fromStartFrame = 3,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 7,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 9,
          toStartFrame = 4,
          fusionFrame = 6
        }
      },
      JumpUpSprintLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 2
        },
        {
          fromStartFrame = 12,
          toStartFrame = 1,
          fusionFrame = 2
        }
      },
      JumpUpSprintRight = {
        {
          fromStartFrame = 4,
          toStartFrame = 1,
          fusionFrame = 2
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Climb = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    RunStartLandRight = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      RunEndRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 6,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 10,
          toStartFrame = 4,
          fusionFrame = 6
        },
        {
          fromStartFrame = 23,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      RunEndLeft = {
        {
          fromStartFrame = 13,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 17,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 19,
          toStartFrame = 4,
          fusionFrame = 6
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 18,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 8,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    RunStartLandLeft = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 11,
          fusionFrame = 3
        }
      },
      RunEndLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 6,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 10,
          toStartFrame = 4,
          fusionFrame = 6
        },
        {
          fromStartFrame = 23,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      RunEndRight = {
        {
          fromStartFrame = 13,
          toStartFrame = 0,
          fusionFrame = 6
        },
        {
          fromStartFrame = 17,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 19,
          toStartFrame = 4,
          fusionFrame = 6
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 18,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 8,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    RunEndRight = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 1
        },
        {
          fromStartFrame = 2,
          toStartFrame = 4,
          fusionFrame = 3
        },
        {
          fromStartFrame = 5,
          toStartFrame = 12,
          fusionFrame = 4
        },
        {
          fromStartFrame = 11,
          toStartFrame = 14,
          fusionFrame = 5
        },
        {
          fromStartFrame = 32,
          toStartFrame = 13,
          fusionFrame = 3
        },
        {
          fromStartFrame = 39,
          toStartFrame = 2,
          fusionFrame = 3
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 2
        },
        {
          fromStartFrame = 39,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 4,
          toStartFrame = 0,
          fusionFrame = 4
        },
        {
          fromStartFrame = 15,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 36,
          fusionFrame = 12
        },
        {
          fromStartFrame = 2,
          toStartFrame = 38,
          fusionFrame = 12
        },
        {
          fromStartFrame = 4,
          toStartFrame = 1,
          fusionFrame = 12
        },
        {
          fromStartFrame = 7,
          toStartFrame = 13,
          fusionFrame = 12
        },
        {
          fromStartFrame = 20,
          toStartFrame = 15,
          fusionFrame = 12
        },
        {
          fromStartFrame = 30,
          toStartFrame = 2,
          fusionFrame = 12
        },
        {
          fromStartFrame = 40,
          toStartFrame = 12,
          fusionFrame = 12
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    RunEndLeft = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 12,
          fusionFrame = 1
        },
        {
          fromStartFrame = 2,
          toStartFrame = 15,
          fusionFrame = 3
        },
        {
          fromStartFrame = 5,
          toStartFrame = 1,
          fusionFrame = 4
        },
        {
          fromStartFrame = 11,
          toStartFrame = 3,
          fusionFrame = 5
        },
        {
          fromStartFrame = 32,
          toStartFrame = 2,
          fusionFrame = 3
        },
        {
          fromStartFrame = 39,
          toStartFrame = 13,
          fusionFrame = 3
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 1
        },
        {
          fromStartFrame = 2,
          toStartFrame = 0,
          fusionFrame = 2
        },
        {
          fromStartFrame = 39,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 4,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 16,
          fusionFrame = 12
        },
        {
          fromStartFrame = 2,
          toStartFrame = 18,
          fusionFrame = 12
        },
        {
          fromStartFrame = 5,
          toStartFrame = 20,
          fusionFrame = 12
        },
        {
          fromStartFrame = 7,
          toStartFrame = 33,
          fusionFrame = 12
        },
        {
          fromStartFrame = 20,
          toStartFrame = 14,
          fusionFrame = 12
        },
        {
          fromStartFrame = 30,
          toStartFrame = 22,
          fusionFrame = 12
        },
        {
          fromStartFrame = 40,
          toStartFrame = 32,
          fusionFrame = 12
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    WalkEndRight = {
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 26,
          fusionFrame = 1
        },
        {
          fromStartFrame = 5,
          toStartFrame = 32,
          fusionFrame = 1
        },
        {
          fromStartFrame = 7,
          toStartFrame = 34,
          fusionFrame = 6
        },
        {
          fromStartFrame = 13,
          toStartFrame = 11,
          fusionFrame = 9
        },
        {
          fromStartFrame = 22,
          toStartFrame = 33,
          fusionFrame = 9
        },
        {
          fromStartFrame = 30,
          toStartFrame = 33,
          fusionFrame = 9
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Run = {
        {
          fromStartFrame = 1,
          toStartFrame = 1,
          fusionFrame = 6
        },
        {
          fromStartFrame = 4,
          toStartFrame = 3,
          fusionFrame = 6
        },
        {
          fromStartFrame = 9,
          toStartFrame = 5,
          fusionFrame = 6
        },
        {
          fromStartFrame = 15,
          toStartFrame = 14,
          fusionFrame = 6
        },
        {
          fromStartFrame = 30,
          toStartFrame = 3,
          fusionFrame = 6
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 30,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 15,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    WalkEndLeft = {
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 6,
          fusionFrame = 1
        },
        {
          fromStartFrame = 6,
          toStartFrame = 10,
          fusionFrame = 1
        },
        {
          fromStartFrame = 9,
          toStartFrame = 12,
          fusionFrame = 6
        },
        {
          fromStartFrame = 13,
          toStartFrame = 31,
          fusionFrame = 9
        },
        {
          fromStartFrame = 22,
          toStartFrame = 34,
          fusionFrame = 9
        },
        {
          fromStartFrame = 32,
          toStartFrame = 34,
          fusionFrame = 9
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 12,
          fusionFrame = 6
        },
        {
          fromStartFrame = 4,
          toStartFrame = 14,
          fusionFrame = 6
        },
        {
          fromStartFrame = 9,
          toStartFrame = 16,
          fusionFrame = 6
        },
        {
          fromStartFrame = 15,
          toStartFrame = 3,
          fusionFrame = 6
        },
        {
          fromStartFrame = 30,
          toStartFrame = 12,
          fusionFrame = 6
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 30,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 15,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    },
    Walk = {
      Run = {
        {
          fromStartFrame = 0,
          toStartFrame = 10,
          fusionFrame = 4
        },
        {
          fromStartFrame = 6,
          toStartFrame = 12,
          fusionFrame = 4
        },
        {
          fromStartFrame = 13,
          toStartFrame = 15,
          fusionFrame = 4
        },
        {
          fromStartFrame = 21,
          toStartFrame = 0,
          fusionFrame = 4
        },
        {
          fromStartFrame = 27,
          toStartFrame = 2,
          fusionFrame = 4
        },
        {
          fromStartFrame = 34,
          toStartFrame = 5,
          fusionFrame = 4
        },
        {
          fromStartFrame = 38,
          toStartFrame = 8,
          fusionFrame = 4
        }
      },
      WalkEndLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        },
        {
          fromStartFrame = 8,
          toStartFrame = 3,
          fusionFrame = 6
        },
        {
          fromStartFrame = 11,
          toStartFrame = 8,
          fusionFrame = 6
        },
        {
          fromStartFrame = 13,
          toStartFrame = 9,
          fusionFrame = 6
        },
        {
          fromStartFrame = 34,
          toStartFrame = 0,
          fusionFrame = 21
        },
        {
          fromStartFrame = 37,
          toStartFrame = 0,
          fusionFrame = 18
        },
        {
          fromStartFrame = 40,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      WalkEndRight = {
        {
          fromStartFrame = 15,
          toStartFrame = 0,
          fusionFrame = 21
        },
        {
          fromStartFrame = 18,
          toStartFrame = 0,
          fusionFrame = 18
        },
        {
          fromStartFrame = 21,
          toStartFrame = 0,
          fusionFrame = 12
        },
        {
          fromStartFrame = 25,
          toStartFrame = 0,
          fusionFrame = 9
        },
        {
          fromStartFrame = 29,
          toStartFrame = 3,
          fusionFrame = 6
        }
      },
      JumpUp = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpUpRunRight = {
        {
          fromStartFrame = 1,
          toStartFrame = 0,
          fusionFrame = 3
        },
        {
          fromStartFrame = 35,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpUpRunLeft = {
        {
          fromStartFrame = 15,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      Move01 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      JumpDownLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      JumpDownRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
      Climb = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Swim = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      SwimStand = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      MenuOpen = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 6
        }
      },
    }
  }
}
Config.AnimEvent1010.AnimFrames = 
{
  Stand1 = 60,
  Attack010 = 208,
  Attack012 = 157,
  Death = 49,
  Run = 25,
  Sprint = 16,
  StandChange = 157,
  Walk = 36,
  GlideFront = 46,
  GlideLeft = 46,
  GlideRight = 46,
  GlideStart = 86,
  Gliding = 58,
  HitDown = 33,
  HitFlyFall = 15,
  HitFlyHover = 15,
  HitFlyLand = 18,
  HitFlyUp = 9,
  JumpDownLeft = 20,
  JumpDownRight = 20,
  JumpLand = 24,
  JumpLandHard = 37,
  JumpLandRollLeft = 69,
  JumpLandRollRight = 70,
  JumpUp = 24,
  JumpUpDoubleLeft = 24,
  JumpUpDoubleRight = 24,
  JumpUpRunLeft = 22,
  JumpUpRunRight = 22,
  JumpUpSprintLeft = 22,
  JumpUpSprintRight = 22,
  LeftHeavyHit = 32,
  LeftSlightHit = 22,
  Lie = 9,
  Move01 = 62,
  RightHeavyHit = 32,
  RightSlightHit = 36,
  RunStartLandLeft = 27,
  RunStartLandRight = 27,
  SprintEndLeft = 55,
  SprintEndRight = 60,
  SprintStartLandLeft = 20,
  SprintStartLandRight = 20,
  StandUp = 35,
  Stun = 60,
  Swim = 36,
  SwimDeath = 80,
  SwimFast = 28,
  SwimFloat = 51,
  SwimStand = 49,
  WalkEndLeft = 22,
  WalkEndRight = 22,
  Attack011 = 145,
  RunEndLeft = 36,
  RunEndRight = 36,
  CallPartnerBack = 76,
  CallPartnerFront = 71,
  PartnerAimEnd = 30,
  PartnerAimShoot = 30,
  PartnerAimStart = 7,
  PartnerCtrFront = 46,
  PartnerCtrlBack = 46,
  PartnerCtrlEnd = 36,
  PartnerCtrlLeft = 46,
  PartnerCtrlLoop = 120,
  PartnerCtrlRight = 46,
  PartnerCtrlStart = 46,
  Attack040 = 79,
  Attack170 = 18,
  Attack171 = 32,
  Attack172 = 183,
  Move02 = 85,
  Attack080 = 60,
  Attack082 = 116,
  ClimbDown = 32,
  ClimbJumpLeft = 40,
  ClimbJumpOver = 47,
  ClimbJumpRight = 40,
  ClimbJumpUp = 40,
  ClimbLand = 30,
  ClimbLeft = 29,
  ClimbRight = 29,
  ClimbRunLeft = 16,
  ClimbRunLeftEnd = 36,
  ClimbRunLeftStart = 22,
  ClimbRunOver = 16,
  ClimbRunRight = 16,
  ClimbRunRightEnd = 36,
  ClimbRunRightStart = 15,
  ClimbRunUp = 16,
  ClimbRunUpEnd = 39,
  ClimbRunUpStart = 20,
  ClimbStand = 80,
  ClimbStart1 = 46,
  ClimbStart2 = 20,
  ClimbUp = 32,
  Climbing = 30,
  ClimbRunEnd = 37,
  Stand2 = 141,
  Attack001 = 71,
  Attack002 = 79,
  Attack003 = 87,
  Attack004 = 102,
  Attack005 = 139,
  Attack050 = 164,
  ClimbStart = 18,
  ClimbRunStart = 20,
  ClimbingRunLoop = 16,
  ClimbRun = 18,
  ClimbJumpStart = 40,
  ClimbJumpUpLeft = 40,
  ClimbJumpUpRight = 40,
  ClimbJump = 40,
  ClimbOver = 54,
  ClimbingJump = 33,
  Attack081 = 8,
  Baoxiong_end = 26,
  Baoxiong_in = 116,
  Baoxiong_Loop = 60,
  Chayao_end = 20,
  Chayao_in = 20,
  Chayao_Loop = 60,
  Fuxiong_end = 22,
  Fuxiong_in = 20,
  Fuxiong_Loop = 60,
  Jingxia_end = 22,
  Jingxia_in = 18,
  Jingxia_Loop = 60,
  Motou_end = 30,
  Motou_in = 22,
  Motou_Loop = 60,
  Schayao_end = 30,
  Schayao_in = 22,
  Schayao_Loop = 60,
  Sit_end = 24,
  Sit_in = 20,
  Sit_Loop = 60,
  SitL_end = 29,
  SitL_in = 30,
  SitR_end = 36,
  SitR_in = 30,
  Songjian_end = 32,
  Songjian_in = 18,
  Songjian_Loop = 120,
  Stanshou_end = 20,
  Stanshou_in = 20,
  Stanshou_Loop = 60,
  Tanshou_end = 20,
  Tanshou_in = 25,
  Tanshou_Loop = 60,
  Tuosai_end = 20,
  Tuosai_in = 25,
  Tuosai_Loop = 60,
  Tuoshou_end = 30,
  Tuoshou_in = 24,
  Tuoshou_Loop = 60,
  Building_body = 91,
  Building_thigh = 91,
  BuildWalk = 20,
  BuildWalkBack = 20,
  BuildWalkLeft = 20,
  BuildWalkRight = 20
}
Config.AnimEvent1010.LoopingAnim = 
{
  Stand1 = true,
  Run = true,
  Sprint = true,
  Walk = true,
  GlideLeft = true,
  GlideRight = true,
  Gliding = true,
  JumpDownLeft = true,
  JumpDownRight = true,
  Lie = true,
  Stun = true,
  Swim = true,
  SwimFast = true,
  SwimStand = true,
  PartnerCtrlLoop = true,
  Attack171 = true,
  ClimbDown = true,
  ClimbLeft = true,
  ClimbRight = true,
  ClimbRunLeft = true,
  ClimbRunRight = true,
  ClimbStand = true,
  ClimbUp = true,
  Climbing = true,
  ClimbRunEnd = false,
  Stand2 = true,
  ClimbStart = true,
  ClimbRunStart = false,
  ClimbingRunLoop = true,
  ClimbRun = true,
  ClimbJumpStart = false,
  ClimbJump = false,
  Building_body = true,
  Building_thigh = true,
  BuildWalk = true,
  BuildWalkBack = true,
  BuildWalkLeft = true,
  BuildWalkRight = true
}
Config.AnimEvent1010.State2AnimMap = 
{}
