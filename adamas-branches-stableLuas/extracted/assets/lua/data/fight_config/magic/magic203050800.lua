Config = Config or {}
Config.Magic203050800 = Config.Magic203050800 or { }
local empty = { }
Config.Magic203050800.Magics = 
{
  [ 2030508001 ] = {
    MagicId = 2030508001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 1,
      SkillBaseDmg = 5000,
      MagicId = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 2030508002 ] = {
    MagicId = 2030508002,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 1,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 1.4,
      StartFrequency = 40.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 20.0,
      AmplitudeChangeTime = 0.6,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.3,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  }
}



Config.Magic203050800.Buffs = 
{}
