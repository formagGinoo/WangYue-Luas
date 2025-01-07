Config = Config or {}
Config.Magic600070 = Config.Magic600070 or { }
local empty = { }
Config.Magic600070.Magics = 
{
  [ 60007001 ] = {
    MagicId = 60007001,
    Type = 4,
    Param = {
      isGroup = true,
      cameraShakeGroup = {
        {
          ShakeType = 3,
          IsNoTimeScale = true,
          TimeScaleMinVal = 0.0,
          Random = 0.0,
          StartOffset = 0.0,
          StartAmplitude = 0.5,
          StartFrequency = 3.0,
          TargetAmplitude = 0.1,
          TargetFrequency = 1.0,
          AmplitudeChangeTime = 0.233,
          FrequencyChangeTime = 0.233,
          DurationTime = 0.33,
          Sign = 0.0,
          DistanceDampingId = 0.0
        }
      },
      ShakeType = 3,
      IsNoTimeScale = true,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.0,
      StartFrequency = 0.0,
      TargetAmplitude = 0.0,
      TargetFrequency = 0.0,
      AmplitudeChangeTime = 0.0,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.0,
      Sign = 0,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  }
}



Config.Magic600070.Buffs = 
{}
