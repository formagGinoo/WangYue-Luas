Config = Config or {}
Config.AnimEvent910025 = Config.AnimEvent910025 or { }
Config.AnimEvent910025.AnimEvents = 
{
  [ 0 ] = {
    Stand1 = {},
    Stand2 = {},
    Walk = {},
    WalkBack = {},
    WalkLeft = {},
    WalkRight = {},
    Attack001 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 80 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 80
        }
      },
    },
    Attack002 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 26 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 26
        }
      },
    },
    Attack051 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 88 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 88
        }
      },
    },
    Attack057 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 60 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 60
        }
      },
    },
    Attack053 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 115 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 115
        }
      },
    },
    Attack003 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 157 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 157
        }
      },
    },
    Attack056 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 95 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 95
        }
      },
    },
    Alert = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 60 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 60
        }
      },
    }
  }
}
Config.AnimEvent910025.AnimFusions = 
{
  [ 0 ] = {
    Stand1 = {
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
    },
    Stand2 = {
      WalkLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 5
        }
      },
      WalkRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
      WalkBack = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 0
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
    },
    Walk = {
      WalkLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      WalkRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      WalkBack = {
        {
          fromStartFrame = 24,
          toStartFrame = 6,
          fusionFrame = 9
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 3
        }
      },
    },
    WalkBack = {
      WalkLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      WalkRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
      Walk = {
        {
          fromStartFrame = 30,
          toStartFrame = 6,
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
    WalkLeft = {
      WalkRight = {
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
          fusionFrame = 5
        }
      },
      WalkBack = {
        {
          fromStartFrame = 0,
          toStartFrame = 1,
          fusionFrame = 6
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 4
        }
      },
    },
    WalkRight = {
      WalkLeft = {
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
          fusionFrame = 4
        }
      },
      WalkBack = {
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
          fusionFrame = 4
        }
      },
    },
    Attack001 = {
      Attack004 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
    },
    Attack002 = {
      Attack003 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 3
        }
      },
    }
  }
}
Config.AnimEvent910025.AnimFrames = 
{
  Stand1 = 81,
  Paralysis = 31,
  Attack001 = 87,
  Stand2 = 91,
  Walk = 36,
  WalkBack = 43,
  WalkLeft = 41,
  WalkRight = 41,
  Run = 27,
  LeftSlightHit = 35,
  Attack002 = 27,
  Attack051 = 96,
  Attack052 = 31,
  Attack053 = 133,
  Attack057 = 89,
  Attack003 = 163,
  Attack004 = 148,
  Attack056 = 130,
  RightSlightHit = 37,
  LeftHeavyHit = 53,
  RightHeavyHit = 48,
  Death = 72,
  Stun = 61,
  Alert = 61,
  HitDown = 25,
  HitFlyFall = 12,
  HitFlyHover = 16,
  HitFlyLand = 24,
  HitFlyUp = 10,
  Lie = 16,
  StandUp = 71,
  BeAssassin = 6,
  BackHeavyHit = 57,
  SwimDeath = 61
}
Config.AnimEvent910025.LoopingAnim = 
{
  Stand1 = true,
  Stand2 = true,
  Walk = true,
  WalkBack = true,
  WalkLeft = true,
  WalkRight = true,
  Run = true,
  Stun = true,
  Alert = true,
  Lie = true
}
Config.AnimEvent910025.State2AnimMap = 
{}
