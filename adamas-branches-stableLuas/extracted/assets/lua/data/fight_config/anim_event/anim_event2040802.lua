Config = Config or {}
Config.AnimEvent2040802 = Config.AnimEvent2040802 or { }
Config.AnimEvent2040802.AnimEvents = 
{
  [ 0 ] = {
    GetInCar = {
      [ 4 ] = {
        {

          soundEvent = "Drive_OpenDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 4
        }
      },
      [ 55 ] = {
        {

          soundEvent = "Drive_CloseDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 55
        }
      },
    },
    GetOffCar = {
      [ 2 ] = {
        {

          soundEvent = "Drive_OpenDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 2
        }
      },
      [ 44 ] = {
        {

          soundEvent = "Drive_CloseDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 44
        }
      },
    }
  }
}
Config.AnimEvent2040802.AnimFusions = 
{
  [ 0 ] = {}
}
Config.AnimEvent2040802.AnimFrames = 
{
  Stand1 = 33,
  SpeedDown = 33,
  SpeedUp = 33,
  TurnLeft = 33,
  TurnRight = 33,
  GetInCar = 74,
  GetOffCar = 63
}
Config.AnimEvent2040802.LoopingAnim = 
{}
Config.AnimEvent2040802.State2AnimMap = 
{}
