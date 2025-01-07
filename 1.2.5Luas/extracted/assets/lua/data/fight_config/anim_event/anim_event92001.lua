Config = Config or {}
Config.AnimEvent92001 = Config.AnimEvent92001 or { }
Config.AnimEvent92001.AnimEvents = 
{
  [ 0 ] = {
    Stand2 = {},
    WalkRight = {},
    WalkLeft = {},
    Walk = {},
    Run = {},
    Attack009 = {
      [ 13 ] = {
        {

          Enable = false,
          eventType = 5,
          frameEvent = 13
        }
      },
      [ 48 ] = {
        {

          Enable = true,
          eventType = 5,
          frameEvent = 48
        }
      },
    },
    HitFlyFall = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 6,
          frameEvent = 0
        }
      },
    },
    HitFlyHover = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 6,
          frameEvent = 0
        }
      },
    }
  }
}
Config.AnimEvent92001.AnimFusions = 
{
  [ 0 ] = {
    Stand2 = {
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      WalkBack = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      WalkLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      WalkRight = {
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
    },
    WalkRight = {
      WalkLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      WalkBack = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Walk = {
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
    },
    WalkLeft = {
      WalkRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      WalkBack = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      Walk = {
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
    },
    Walk = {
      WalkRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      WalkLeft = {
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
      WalkBack = {
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
    Run = {
      WalkRight = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      WalkLeft = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Walk = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
      WalkBack = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 12
        }
      },
      Stand2 = {
        {
          fromStartFrame = 0,
          toStartFrame = 0,
          fusionFrame = 9
        }
      },
    }
  }
}
Config.AnimEvent92001.AnimFrames = 
{
  Stand1 = 121,
  Attack001 = 36,
  Attack002 = 36,
  Attack003 = 36,
  Attack004 = 141,
  Attack005 = 86,
  Attack006 = 100,
  Attack007 = 147,
  Attack008 = 103,
  Attack009 = 100,
  Attack010 = 79,
  Attack013 = 146,
  Attack014 = 200,
  Attack015 = 65,
  Attack016 = 250,
  Attack017 = 157,
  Attack904 = 97,
  Attack906 = 100,
  Attack999 = 11,
  Death = 93,
  HitDown = 46,
  HitFlyFall = 16,
  HitFlyHover = 16,
  HitFlyLand = 19,
  HitFlyUp = 10,
  LeftHeavyHit = 61,
  LeftSlightHit = 43,
  Lie = 16,
  Paralysis = 31,
  RightHeavyHit = 61,
  RightSlightHit = 43,
  Run = 25,
  Stand2 = 121,
  StandUp = 96,
  Stun = 61,
  Walk = 53,
  Walkb = 53,
  WalkBack = 53,
  WalkLeft = 61,
  WalkRight = 61
}
Config.AnimEvent92001.LoopingAnim = 
{
  Stand1 = true,
  Lie = true,
  Run = true,
  Stand2 = true,
  Stun = true,
  Walk = true,
  Walkb = true,
  WalkBack = true,
  WalkLeft = true,
  WalkRight = true
}
Config.AnimEvent92001.State2AnimMap = 
{}
