Config = Config or {}
Config.AnimEvent2030801 = Config.AnimEvent2030801 or { }
Config.AnimEvent2030801.AnimEvents = 
{
  [ 0 ] = {
    IntoInactiveMode = {
      [ 0 ] = {
        {

          soundEvent = "ElectChargeDevice_IntoInactiveMode",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    IntoChargingMode = {
      [ 0 ] = {
        {

          soundEvent = "ElectChargeDevice_IntoChargingMode",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    IntoActiveMode = {
      [ 0 ] = {
        {

          soundEvent = "ElectChargeDevice_IntoActiveMode",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    },
    ChargeMode_Idle = {
      [ 0 ] = {
        {

          soundEvent = "ElectChargeDevice_ChargingModeLoop",
          lifeBindAnimClip = true,
          eventType = 3,
          frameEvent = 0,
          eventName = "播放音效"
        }
      },
    }
  }
}
Config.AnimEvent2030801.AnimFusions = 
{
  [ 0 ] = {
    IntoInactiveMode = {},
    IntoChargingMode = {},
    IntoActiveMode = {},
    ChargeMode_Idle = {}
  }
}
Config.AnimEvent2030801.AnimFrames = 
{
  ActiveMode_Idle = 30,
  ChargeMode_Idle = 30,
  InactiveMode_Idle = 30,
  IntoActiveMode = 45,
  IntoChargingMode = 30,
  IntoInactiveMode = 30
}
Config.AnimEvent2030801.LoopingAnim = 
{
  ActiveMode_Idle = true,
  ChargeMode_Idle = true,
  InactiveMode_Idle = true
}
Config.AnimEvent2030801.State2AnimMap = 
{}
