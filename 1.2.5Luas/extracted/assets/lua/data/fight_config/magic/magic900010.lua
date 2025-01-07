Config = Config or {}
Config.Magic900010 = Config.Magic900010 or { }
local empty = { }
Config.Magic900010.Magics = 
{
  [ 90001001 ] = {
    MagicId = 90001001,
    Type = 2,
    Param = {
      DamageKind = 1,
      DamageType = 1,
      ElementType = 1,
      ElementAccumulate = 0,
      SkillParam = 10000,
      SkillBaseDmg = 0,
      MagicId = 0,
      UseSelfAttr = true
    }
  },
  [ 90001002 ] = {
    MagicId = 90001002,
    Type = 5,
    Param = {
      EntityId = 90001000102,
      BindOffsetX = 0.0,
      BindOffsetY = 0.0,
      BindOffsetZ = 0.0,
      BornRotX = 0.0,
      BornRotZ = 0.0,
      IsBindEntity = false
    }
  }
}



Config.Magic900010.Buffs = 
{}
