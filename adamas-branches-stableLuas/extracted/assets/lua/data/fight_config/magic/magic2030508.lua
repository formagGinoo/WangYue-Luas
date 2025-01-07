Config = Config or {}
Config.Magic2030508 = Config.Magic2030508 or { }
local empty = { }
Config.Magic2030508.Magics = 
{
  [ 203050801 ] = {
    MagicId = 203050801,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      DamageSkillType = 0,
      ElementType = 2,
      ElementAccumulate = 1,
      SkillParam = 1,
      SkillBaseDmg = 100,
      MagicId = 0,
      AddSkillPoint = 0,
      UseSelfAttr = true,
      UseAttrType = 1,
      DelayFrame = 0
    }
  },
  [ 203050802 ] = {
    MagicId = 203050802,
    Type = 4,
    Param = {
      isGroup = false,
      cameraShakeGroup = {},
      ShakeType = 1,
      IsNoTimeScale = false,
      TimeScaleMinVal = 0.0,
      Random = 0.0,
      StartOffset = 0.0,
      StartAmplitude = 0.2,
      StartFrequency = 10.0,
      TargetAmplitude = 0.1,
      TargetFrequency = 10.0,
      AmplitudeChangeTime = 0.3,
      FrequencyChangeTime = 0.0,
      DurationTime = 0.2,
      Sign = 40,
      DistanceDampingId = 0,
      IsLookAtTarget = false,
      DelayFrame = 0
    }
  }
}



Config.Magic2030508.Buffs = 
{}
