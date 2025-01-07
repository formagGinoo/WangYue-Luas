Config = Config or {}
Config.AnimEvent2040851 = Config.AnimEvent2040851 or { }
Config.AnimEvent2040851.AnimEvents = 
{
  [ 0 ] = {
    GetInCar = {
      [ 6 ] = {
        {

          soundEvent = "Drive_OpenDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 6
        }
      },
      [ 60 ] = {
        {

          soundEvent = "Drive_CloseDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 60
        }
      },
    },
    GetOffCar = {
      [ 1 ] = {
        {

          soundEvent = "Drive_OpenDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 1
        }
      },
      [ 47 ] = {
        {

          soundEvent = "Drive_CloseDoor",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 47
        }
      },
    }
  }
}
Config.AnimEvent2040851.AnimFusions = 
{
  [ 0 ] = {}
}
Config.AnimEvent2040851.AnimFrames = 
{
  Stand1 = 33,
  Forward = 33,
  GetInCar = 61,
  GetOffCar = 48,
  Reverse = 33,
  TurnLeft = 33,
  TurnRight = 33
}
Config.AnimEvent2040851.LoopingAnim = 
{
  Stand1 = true
}
Config.AnimEvent2040851.State2AnimMap = 
{}
