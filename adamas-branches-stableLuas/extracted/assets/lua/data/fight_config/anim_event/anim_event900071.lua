Config = Config or {}
Config.AnimEvent900071 = Config.AnimEvent900071 or { }
Config.AnimEvent900071.AnimEvents = 
{
  [ 0 ] = {
    Attack001 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 76 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 76
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
      [ 69 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 69
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
      [ 51 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 51
        }
      },
    },
    Attack004 = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
      [ 57 ] = {
        {

          Enable = true,
          eventType = 9,
          frameEvent = 57
        }
      },
    },
    Death = {
      [ 0 ] = {
        {

          Enable = false,
          eventType = 9,
          frameEvent = 0
        }
      },
    }
  }
}
Config.AnimEvent900071.AnimFusions = 
{
  [ 0 ] = {
    Attack004 = {
      Attack002 = {
        {
          fromStartFrame = 40,
          toStartFrame = 0,
          fusionFrame = 10
        }
      },
      Attack001 = {
        {
          fromStartFrame = 40,
          toStartFrame = 0,
          fusionFrame = 5
        }
      },
    }
  }
}
Config.AnimEvent900071.AnimFrames = 
{
  Stand1 = 49,
  Alert = 51,
  Attack001 = 100,
  Attack002 = 118,
  Attack003 = 111,
  Attack004 = 93,
  Attack005 = 110,
  BackLeavyHit = 57,
  BeAssassin = 6,
  Death = 68,
  HitDown = 41,
  HitFlyFall = 11,
  HitFlyHover = 15,
  HitFlyLand = 24,
  HitFlyUp = 10,
  LeftHeavyHit = 51,
  LeftSlightHit = 41,
  Lie = 13,
  RightHeavyHit = 55,
  RightSlightHit = 43,
  Run = 23,
  Stand2 = 33,
  StandUp = 46,
  Stun = 43,
  SwimDeath = 63,
  Walk = 37,
  WalkBack = 37,
  WalkLeft = 37,
  WalkRight = 37
}
Config.AnimEvent900071.LoopingAnim = 
{
  Stand1 = true,
  Lie = true,
  Run = true,
  Stand2 = true,
  Stun = true,
  Walk = true,
  WalkBack = true,
  WalkLeft = true,
  WalkRight = true
}
Config.AnimEvent900071.State2AnimMap = 
{}
