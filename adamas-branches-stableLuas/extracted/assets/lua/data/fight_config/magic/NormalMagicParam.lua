Config = Config or {}
Config.NormalMagicParam = Config.NormalMagicParam or { }
local empty = { }
Config.NormalMagicParam = 
{
  AddBuff = {},
  DoDamage = {
    [ 1000 ] = "ElementAccumulate",
    [ 2 ] = "SkillBaseDmg",
    [ 1 ] = "SkillParam",
    [ 999 ] = "AddSkillPoint"
  },
  SetTimeScale = {},
  CameraShake = {},
  CreateEntity = {},
  AddBuffState = {},
  HideBone = {},
  HideGroupBone = {},
  ForceMove = {},
  ChangeAttr = {
    [ 2 ] = "MaxValue",
    [ 1 ] = "AttrValue"
  },
  ScreenEffect = {},
  EnemyCommonTimeScale = {},
  SetSceneSpeed = {},
  AddBehavior = {},
  Perform = {},
  CameraTrack = {},
  PartLogicVisible = {},
  PartLock = {},
  ChangeEntityState = {},
  CameraOffset = {},
  CameraFixed = {},
  PauseTranslucent = {},
  BuffTimeOffset = {},
  EnableAnimMove = {},
  EnableAnimMoveWithAxis = {},
  DoCure = {
    [ 1 ] = "SkillParam",
    [ 2 ] = "SkillAdditionParam"
  },
  ChangePlayerAttr = {
    [ 1 ] = "AttrValue"
  },
  ConditionListener = {},
  ChangeYAxisParam = {},
  AdditionYAxisParam = {},
  ChangeJumpParam = {},
  ChangeAttrAccumulate = {},
  ElementResistance = {},
  Revive = {
    [ 1 ] = "ReviveValue"
  },
  RoleCommonTimeScale = {},
  Execute = {},
  ChangeCollisionTagFlags = {},
  ChangeCollisionBeCheckTagFlags = {},
  WindArea = {},
  AttrTranslationPercent = {},
  AttrTranslationFixedValue = {},
  AddShield = {},
  WeaponEffect = {},
  PassParameter = {}
}
