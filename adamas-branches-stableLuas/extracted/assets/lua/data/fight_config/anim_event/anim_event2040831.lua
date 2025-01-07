Config = Config or {}
Config.AnimEvent2040831 = Config.AnimEvent2040831 or { }
Config.AnimEvent2040831.AnimEvents = 
{
  [ 0 ] = {
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
    },
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
    }
  }
}
Config.AnimEvent2040831.AnimFusions = 
{
  [ 0 ] = {}
}
Config.AnimEvent2040831.AnimFrames = 
{
  Stand1 = 33,
  Forward = 33,
  GetInCar = 61,
  GetOffCar = 48,
  Reverse = 33,
  TurnLeft = 33,
  TurnRight = 33
}
Config.AnimEvent2040831.LoopingAnim = 
{
  Stand1 = true,
  Forward = true,
  Reverse = true
}
Config.AnimEvent2040831.State2AnimMap = 
{
  GetlnCar = "GetInCar"
}
